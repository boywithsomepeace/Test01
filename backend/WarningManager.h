#pragma once

#include <QObject>
#include <QString>

class VehicleData;

class WarningManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool active READ active NOTIFY warningChanged)
    Q_PROPERTY(QString title READ title NOTIFY warningChanged)
    Q_PROPERTY(QString message READ message NOTIFY warningChanged)
    Q_PROPERTY(QString severity READ severity NOTIFY warningChanged)

public:
    explicit WarningManager(VehicleData *vehicleData, QObject *parent = nullptr);

    bool active() const;
    QString title() const;
    QString message() const;
    QString severity() const;

signals:
    void warningChanged();

private slots:
    void evaluate();

private:
    void setWarning(const QString &title, const QString &message, const QString &severity);

    VehicleData *m_vehicleData = nullptr;
    bool m_active = false;
    QString m_title;
    QString m_message;
    QString m_severity = QStringLiteral("nominal");
};
