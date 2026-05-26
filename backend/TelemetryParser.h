#pragma once

#include <QByteArray>
#include <QObject>

class VehicleData;

class TelemetryParser : public QObject
{
    Q_OBJECT

public:
    explicit TelemetryParser(VehicleData *vehicleData, QObject *parent = nullptr);

public slots:
    void parseLine(const QByteArray &line);

signals:
    void frameAccepted();
    void frameRejected(const QString &reason);

private:
    VehicleData *m_vehicleData = nullptr;
};
