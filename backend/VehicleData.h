#pragma once

#include <QObject>
#include <QString>

class VehicleData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int batterySoc READ batterySoc WRITE setBatterySoc NOTIFY batterySocChanged)
    Q_PROPERTY(double packVoltage READ packVoltage WRITE setPackVoltage NOTIFY packVoltageChanged)
    Q_PROPERTY(double packCurrent READ packCurrent WRITE setPackCurrent NOTIFY packCurrentChanged)
    Q_PROPERTY(double motorTemp READ motorTemp WRITE setMotorTemp NOTIFY motorTempChanged)
    Q_PROPERTY(double inverterTemp READ inverterTemp WRITE setInverterTemp NOTIFY inverterTempChanged)
    Q_PROPERTY(double batteryTemp READ batteryTemp WRITE setBatteryTemp NOTIFY batteryTempChanged)
    Q_PROPERTY(int rangeKm READ rangeKm WRITE setRangeKm NOTIFY rangeKmChanged)
    Q_PROPERTY(double odometerKm READ odometerKm WRITE setOdometerKm NOTIFY odometerKmChanged)
    Q_PROPERTY(double averageEfficiency READ averageEfficiency WRITE setAverageEfficiency NOTIFY averageEfficiencyChanged)
    Q_PROPERTY(double ambientTempC READ ambientTempC WRITE setAmbientTempC NOTIFY ambientTempCChanged)
    Q_PROPERTY(QString weatherCondition READ weatherCondition WRITE setWeatherCondition NOTIFY weatherConditionChanged)
    Q_PROPERTY(QString gear READ gear WRITE setGear NOTIFY gearChanged)
    Q_PROPERTY(QString driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    Q_PROPERTY(double throttlePercent READ throttlePercent WRITE setThrottlePercent NOTIFY throttlePercentChanged)
    Q_PROPERTY(double pwmCommand READ pwmCommand WRITE setPwmCommand NOTIFY pwmCommandChanged)
    Q_PROPERTY(bool charging READ charging WRITE setCharging NOTIFY chargingChanged)
    Q_PROPERTY(bool leftIndicator READ leftIndicator WRITE setLeftIndicator NOTIFY leftIndicatorChanged)
    Q_PROPERTY(bool rightIndicator READ rightIndicator WRITE setRightIndicator NOTIFY rightIndicatorChanged)
    Q_PROPERTY(bool headlights READ headlights WRITE setHeadlights NOTIFY headlightsChanged)
    Q_PROPERTY(double regenKw READ regenKw WRITE setRegenKw NOTIFY regenKwChanged)
    Q_PROPERTY(QString faultCode READ faultCode WRITE setFaultCode NOTIFY faultCodeChanged)

public:
    explicit VehicleData(QObject *parent = nullptr);

    int speed() const;
    int batterySoc() const;
    double packVoltage() const;
    double packCurrent() const;
    double motorTemp() const;
    double inverterTemp() const;
    double batteryTemp() const;
    int rangeKm() const;
    double odometerKm() const;
    double averageEfficiency() const;
    double ambientTempC() const;
    QString weatherCondition() const;
    QString gear() const;
    QString driveMode() const;
    double throttlePercent() const;
    double pwmCommand() const;
    bool charging() const;
    bool leftIndicator() const;
    bool rightIndicator() const;
    bool headlights() const;
    double regenKw() const;
    QString faultCode() const;

public slots:
    void setSpeed(int value);
    void setBatterySoc(int value);
    void setPackVoltage(double value);
    void setPackCurrent(double value);
    void setMotorTemp(double value);
    void setInverterTemp(double value);
    void setBatteryTemp(double value);
    void setRangeKm(int value);
    void setOdometerKm(double value);
    void setAverageEfficiency(double value);
    void setAmbientTempC(double value);
    void setWeatherCondition(const QString &value);
    void setGear(const QString &value);
    void setDriveMode(const QString &value);
    void setThrottlePercent(double value);
    void setPwmCommand(double value);
    void setCharging(bool value);
    void setLeftIndicator(bool value);
    void setRightIndicator(bool value);
    void setHeadlights(bool value);
    void setRegenKw(double value);
    void setFaultCode(const QString &value);

signals:
    void speedChanged();
    void batterySocChanged();
    void packVoltageChanged();
    void packCurrentChanged();
    void motorTempChanged();
    void inverterTempChanged();
    void batteryTempChanged();
    void rangeKmChanged();
    void odometerKmChanged();
    void averageEfficiencyChanged();
    void ambientTempCChanged();
    void weatherConditionChanged();
    void gearChanged();
    void driveModeChanged();
    void throttlePercentChanged();
    void pwmCommandChanged();
    void chargingChanged();
    void leftIndicatorChanged();
    void rightIndicatorChanged();
    void headlightsChanged();
    void regenKwChanged();
    void faultCodeChanged();

private:
    int m_speed = 0;
    int m_batterySoc = 82;
    double m_packVoltage = 387.4;
    double m_packCurrent = 18.0;
    double m_motorTemp = 42.0;
    double m_inverterTemp = 38.0;
    double m_batteryTemp = 31.0;
    int m_rangeKm = 196;
    double m_odometerKm = 6666.6;
    double m_averageEfficiency = 11.3;
    double m_ambientTempC = 31.0;
    QString m_weatherCondition = QStringLiteral("PUNE");
    QString m_gear = QStringLiteral("N");
    QString m_driveMode = QStringLiteral("ECO");
    double m_throttlePercent = 0.0;
    double m_pwmCommand = 0.0;
    bool m_charging = false;
    bool m_leftIndicator = true;
    bool m_rightIndicator = false;
    bool m_headlights = true;
    double m_regenKw = 0.0;
    QString m_faultCode;
};
