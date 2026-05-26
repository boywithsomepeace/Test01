#include "VehicleData.h"

#include <QtGlobal>

VehicleData::VehicleData(QObject *parent)
    : QObject(parent)
{
}

int VehicleData::speed() const { return m_speed; }
int VehicleData::batterySoc() const { return m_batterySoc; }
double VehicleData::packVoltage() const { return m_packVoltage; }
double VehicleData::packCurrent() const { return m_packCurrent; }
double VehicleData::motorTemp() const { return m_motorTemp; }
double VehicleData::inverterTemp() const { return m_inverterTemp; }
double VehicleData::batteryTemp() const { return m_batteryTemp; }
int VehicleData::rangeKm() const { return m_rangeKm; }
double VehicleData::odometerKm() const { return m_odometerKm; }
double VehicleData::averageEfficiency() const { return m_averageEfficiency; }
double VehicleData::ambientTempC() const { return m_ambientTempC; }
QString VehicleData::weatherCondition() const { return m_weatherCondition; }
QString VehicleData::gear() const { return m_gear; }
QString VehicleData::driveMode() const { return m_driveMode; }
double VehicleData::throttlePercent() const { return m_throttlePercent; }
double VehicleData::pwmCommand() const { return m_pwmCommand; }
bool VehicleData::charging() const { return m_charging; }
bool VehicleData::leftIndicator() const { return m_leftIndicator; }
bool VehicleData::rightIndicator() const { return m_rightIndicator; }
bool VehicleData::headlights() const { return m_headlights; }
double VehicleData::regenKw() const { return m_regenKw; }
QString VehicleData::faultCode() const { return m_faultCode; }

void VehicleData::setSpeed(int value)
{
    value = qBound(0, value, 220);
    if (m_speed == value)
        return;
    m_speed = value;
    emit speedChanged();
}

void VehicleData::setBatterySoc(int value)
{
    value = qBound(0, value, 100);
    if (m_batterySoc == value)
        return;
    m_batterySoc = value;
    emit batterySocChanged();
}

void VehicleData::setPackVoltage(double value)
{
    if (qFuzzyCompare(m_packVoltage, value))
        return;
    m_packVoltage = value;
    emit packVoltageChanged();
}

void VehicleData::setPackCurrent(double value)
{
    if (qFuzzyCompare(m_packCurrent, value))
        return;
    m_packCurrent = value;
    emit packCurrentChanged();
}

void VehicleData::setMotorTemp(double value)
{
    if (qFuzzyCompare(m_motorTemp, value))
        return;
    m_motorTemp = value;
    emit motorTempChanged();
}

void VehicleData::setInverterTemp(double value)
{
    if (qFuzzyCompare(m_inverterTemp, value))
        return;
    m_inverterTemp = value;
    emit inverterTempChanged();
}

void VehicleData::setBatteryTemp(double value)
{
    if (qFuzzyCompare(m_batteryTemp, value))
        return;
    m_batteryTemp = value;
    emit batteryTempChanged();
}

void VehicleData::setRangeKm(int value)
{
    value = qMax(0, value);
    if (m_rangeKm == value)
        return;
    m_rangeKm = value;
    emit rangeKmChanged();
}

void VehicleData::setOdometerKm(double value)
{
    if (qFuzzyCompare(m_odometerKm, value))
        return;
    m_odometerKm = value;
    emit odometerKmChanged();
}

void VehicleData::setAverageEfficiency(double value)
{
    if (qFuzzyCompare(m_averageEfficiency, value))
        return;
    m_averageEfficiency = value;
    emit averageEfficiencyChanged();
}

void VehicleData::setAmbientTempC(double value)
{
    if (qFuzzyCompare(m_ambientTempC, value))
        return;
    m_ambientTempC = value;
    emit ambientTempCChanged();
}

void VehicleData::setWeatherCondition(const QString &value)
{
    if (m_weatherCondition == value)
        return;
    m_weatherCondition = value;
    emit weatherConditionChanged();
}

void VehicleData::setGear(const QString &value)
{
    if (m_gear == value)
        return;
    m_gear = value;
    emit gearChanged();
}

void VehicleData::setDriveMode(const QString &value)
{
    if (m_driveMode == value)
        return;
    m_driveMode = value;
    emit driveModeChanged();
}

void VehicleData::setThrottlePercent(double value)
{
    value = qBound(0.0, value, 100.0);
    if (qFuzzyCompare(m_throttlePercent, value))
        return;
    m_throttlePercent = value;
    emit throttlePercentChanged();
}

void VehicleData::setPwmCommand(double value)
{
    value = qBound(0.0, value, 100.0);
    if (qFuzzyCompare(m_pwmCommand, value))
        return;
    m_pwmCommand = value;
    emit pwmCommandChanged();
}

void VehicleData::setCharging(bool value)
{
    if (m_charging == value)
        return;
    m_charging = value;
    emit chargingChanged();
}

void VehicleData::setLeftIndicator(bool value)
{
    if (m_leftIndicator == value)
        return;
    m_leftIndicator = value;
    emit leftIndicatorChanged();
}

void VehicleData::setRightIndicator(bool value)
{
    if (m_rightIndicator == value)
        return;
    m_rightIndicator = value;
    emit rightIndicatorChanged();
}

void VehicleData::setHeadlights(bool value)
{
    if (m_headlights == value)
        return;
    m_headlights = value;
    emit headlightsChanged();
}

void VehicleData::setRegenKw(double value)
{
    if (qFuzzyCompare(m_regenKw, value))
        return;
    m_regenKw = value;
    emit regenKwChanged();
}

void VehicleData::setFaultCode(const QString &value)
{
    if (m_faultCode == value)
        return;
    m_faultCode = value;
    emit faultCodeChanged();
}
