#include "TelemetrySimulator.h"

#include "VehicleData.h"

#include <QtMath>

namespace {
double pwmForMode(const QString &mode, double throttle)
{
    const double t = qBound(0.0, throttle / 100.0, 1.0);
    if (mode == QStringLiteral("SPORTS"))
        return qPow(t, 0.62) * 100.0;
    if (mode == QStringLiteral("CITY"))
        return t * 100.0;
    return qLn(1.0 + 8.0 * t) / qLn(9.0) * 72.0;
}
}

TelemetrySimulator::TelemetrySimulator(VehicleData *vehicleData, QObject *parent)
    : QObject(parent)
    , m_vehicleData(vehicleData)
{
    if (m_vehicleData)
        m_batterySoc = m_vehicleData->batterySoc();
    m_timer.setInterval(80);
    connect(&m_timer, &QTimer::timeout, this, &TelemetrySimulator::tick);
    m_timer.start();
}

void TelemetrySimulator::setRunning(bool running)
{
    if (running)
        m_timer.start();
    else
        m_timer.stop();
}

void TelemetrySimulator::tick()
{
    if (!m_vehicleData)
        return;

    m_phase += 0.035;
    const double cruise = (qSin(m_phase) + 1.0) * 0.5;
    const int speed = qRound(28.0 + cruise * 64.0 + qSin(m_phase * 2.7) * 5.0);
    const double throttle = qBound(0.0, 18.0 + cruise * 74.0 + qSin(m_phase * 3.3) * 8.0, 100.0);
    const double dtHours = m_timer.interval() / 3600000.0;
    const double distanceKm = ((m_lastSpeed + speed) * 0.5) * dtHours;
    const double demoDistanceMultiplier = 80.0;
    const double demoDrainMultiplier = 420.0;
    const double efficiency = 10.7 + cruise * 2.4 + qSin(m_phase * 1.4) * 0.4;
    const double estimatedPackKwh = 42.0;
    const double usedKwh = distanceKm * demoDrainMultiplier * efficiency / 1000.0;

    m_lastSpeed = speed;
    m_batterySoc = qMax(0.0, m_batterySoc - usedKwh / estimatedPackKwh * 100.0);
    if (m_batterySoc <= 8.0)
        m_batterySoc = 100.0;

    m_vehicleData->setSpeed(speed);
    m_vehicleData->setThrottlePercent(throttle);
    m_vehicleData->setPwmCommand(pwmForMode(m_vehicleData->driveMode(), throttle));
    m_vehicleData->setBatterySoc(qRound(m_batterySoc));
    m_vehicleData->setPackCurrent(18.0 + speed * 0.62 + qSin(m_phase * 1.8) * 6.0);
    m_vehicleData->setPackVoltage(386.0 - speed * 0.035 + qSin(m_phase * 0.7) * 1.2);
    m_vehicleData->setMotorTemp(41.0 + speed * 0.11);
    m_vehicleData->setInverterTemp(36.0 + speed * 0.08);
    m_vehicleData->setBatteryTemp(30.0 + speed * 0.035);
    m_vehicleData->setOdometerKm(m_vehicleData->odometerKm() + distanceKm * demoDistanceMultiplier);
    m_vehicleData->setAverageEfficiency(efficiency);
    m_vehicleData->setRangeKm(qMax(0, qRound((m_batterySoc / 100.0) * estimatedPackKwh * 1000.0 / efficiency)));
    m_vehicleData->setAmbientTempC(29.0 + qSin(m_phase * 0.08) * 2.0);
    m_vehicleData->setWeatherCondition(QStringLiteral("PUNE"));
    m_vehicleData->setRegenKw(speed < 36 ? 6.5 * (1.0 - speed / 36.0) : 0.0);
    m_vehicleData->setLeftIndicator(qSin(m_phase * 2.2) > 0.35);
    m_vehicleData->setRightIndicator(false);
    m_vehicleData->setFaultCode(speed > 88 ? QStringLiteral("THERMAL WATCH") : QString());
}
