#pragma once

#include <QObject>
#include <QTimer>

class VehicleData;

class TelemetrySimulator : public QObject
{
    Q_OBJECT

public:
    explicit TelemetrySimulator(VehicleData *vehicleData, QObject *parent = nullptr);
    Q_INVOKABLE void setRunning(bool running);

private slots:
    void tick();

private:
    VehicleData *m_vehicleData = nullptr;
    QTimer m_timer;
    double m_phase = 0.0;
    double m_batterySoc = 82.0;
    double m_lastSpeed = 0.0;
};
