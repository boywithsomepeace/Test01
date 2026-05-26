#include "TelemetryParser.h"

#include "VehicleData.h"

#include <QHash>
#include <QStringList>

TelemetryParser::TelemetryParser(VehicleData *vehicleData, QObject *parent)
    : QObject(parent)
    , m_vehicleData(vehicleData)
{
}

void TelemetryParser::parseLine(const QByteArray &line)
{
    const QString frame = QString::fromUtf8(line).trimmed();
    if (frame.isEmpty() || !m_vehicleData) {
        emit frameRejected(QStringLiteral("empty frame"));
        return;
    }

    QHash<QString, QString> values;
    const auto parts = frame.split(',', Qt::SkipEmptyParts);
    for (const QString &part : parts) {
        const auto pair = part.split('=', Qt::KeepEmptyParts);
        if (pair.size() != 2)
            continue;
        values.insert(pair.at(0).trimmed().toUpper(), pair.at(1).trimmed());
    }

    if (values.isEmpty()) {
        emit frameRejected(QStringLiteral("no key/value pairs"));
        return;
    }

    if (values.contains(QStringLiteral("SPD"))) m_vehicleData->setSpeed(values.value(QStringLiteral("SPD")).toInt());
    if (values.contains(QStringLiteral("SOC"))) m_vehicleData->setBatterySoc(values.value(QStringLiteral("SOC")).toInt());
    if (values.contains(QStringLiteral("V"))) m_vehicleData->setPackVoltage(values.value(QStringLiteral("V")).toDouble());
    if (values.contains(QStringLiteral("A"))) m_vehicleData->setPackCurrent(values.value(QStringLiteral("A")).toDouble());
    if (values.contains(QStringLiteral("MT"))) m_vehicleData->setMotorTemp(values.value(QStringLiteral("MT")).toDouble());
    if (values.contains(QStringLiteral("IT"))) m_vehicleData->setInverterTemp(values.value(QStringLiteral("IT")).toDouble());
    if (values.contains(QStringLiteral("BT"))) m_vehicleData->setBatteryTemp(values.value(QStringLiteral("BT")).toDouble());
    if (values.contains(QStringLiteral("RNG"))) m_vehicleData->setRangeKm(values.value(QStringLiteral("RNG")).toInt());
    if (values.contains(QStringLiteral("ODO"))) m_vehicleData->setOdometerKm(values.value(QStringLiteral("ODO")).toDouble());
    if (values.contains(QStringLiteral("EFF"))) m_vehicleData->setAverageEfficiency(values.value(QStringLiteral("EFF")).toDouble());
    if (values.contains(QStringLiteral("AMB"))) m_vehicleData->setAmbientTempC(values.value(QStringLiteral("AMB")).toDouble());
    if (values.contains(QStringLiteral("WX"))) m_vehicleData->setWeatherCondition(values.value(QStringLiteral("WX")).toUpper());
    if (values.contains(QStringLiteral("GEAR"))) m_vehicleData->setGear(values.value(QStringLiteral("GEAR")).toUpper());
    if (values.contains(QStringLiteral("MODE"))) m_vehicleData->setDriveMode(values.value(QStringLiteral("MODE")).toUpper());
    if (values.contains(QStringLiteral("THR"))) m_vehicleData->setThrottlePercent(values.value(QStringLiteral("THR")).toDouble());
    if (values.contains(QStringLiteral("PWM"))) m_vehicleData->setPwmCommand(values.value(QStringLiteral("PWM")).toDouble());
    if (values.contains(QStringLiteral("CHG"))) m_vehicleData->setCharging(values.value(QStringLiteral("CHG")).toInt() != 0);
    if (values.contains(QStringLiteral("L"))) m_vehicleData->setLeftIndicator(values.value(QStringLiteral("L")).toInt() != 0);
    if (values.contains(QStringLiteral("R"))) m_vehicleData->setRightIndicator(values.value(QStringLiteral("R")).toInt() != 0);
    if (values.contains(QStringLiteral("HEAD"))) m_vehicleData->setHeadlights(values.value(QStringLiteral("HEAD")).toInt() != 0);
    if (values.contains(QStringLiteral("REGEN"))) m_vehicleData->setRegenKw(values.value(QStringLiteral("REGEN")).toDouble());
    if (values.contains(QStringLiteral("FAULT"))) m_vehicleData->setFaultCode(values.value(QStringLiteral("FAULT")));

    emit frameAccepted();
}
