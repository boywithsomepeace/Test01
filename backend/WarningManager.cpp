#include "WarningManager.h"

#include "VehicleData.h"

WarningManager::WarningManager(VehicleData *vehicleData, QObject *parent)
    : QObject(parent)
    , m_vehicleData(vehicleData)
{
    if (!m_vehicleData)
        return;

    connect(m_vehicleData, &VehicleData::batterySocChanged, this, &WarningManager::evaluate);
    connect(m_vehicleData, &VehicleData::motorTempChanged, this, &WarningManager::evaluate);
    connect(m_vehicleData, &VehicleData::inverterTempChanged, this, &WarningManager::evaluate);
    connect(m_vehicleData, &VehicleData::faultCodeChanged, this, &WarningManager::evaluate);
    evaluate();
}

bool WarningManager::active() const { return m_active; }
QString WarningManager::title() const { return m_title; }
QString WarningManager::message() const { return m_message; }
QString WarningManager::severity() const { return m_severity; }

void WarningManager::evaluate()
{
    if (!m_vehicleData)
        return;

    if (!m_vehicleData->faultCode().isEmpty()) {
        setWarning(QStringLiteral("SYSTEM WATCH"), m_vehicleData->faultCode(), QStringLiteral("caution"));
    } else if (m_vehicleData->motorTemp() >= 82.0 || m_vehicleData->inverterTemp() >= 78.0) {
        setWarning(QStringLiteral("THERMAL LIMIT"), QStringLiteral("Reduce load and monitor drivetrain."), QStringLiteral("critical"));
    } else if (m_vehicleData->batterySoc() <= 18) {
        setWarning(QStringLiteral("LOW SOC"), QStringLiteral("Plan charging stop."), QStringLiteral("caution"));
    } else {
        setWarning(QString(), QString(), QStringLiteral("nominal"));
    }
}

void WarningManager::setWarning(const QString &title, const QString &message, const QString &severity)
{
    const bool active = !title.isEmpty();
    if (m_active == active && m_title == title && m_message == message && m_severity == severity)
        return;

    m_active = active;
    m_title = title;
    m_message = message;
    m_severity = severity;
    emit warningChanged();
}
