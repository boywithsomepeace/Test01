#pragma once

#include <QObject>
#include <QSerialPort>

class TelemetryParser;

class SerialManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString portName READ portName WRITE setPortName NOTIFY portNameChanged)

public:
    explicit SerialManager(TelemetryParser *parser, QObject *parent = nullptr);

    bool connected() const;
    QString portName() const;

    Q_INVOKABLE void connectPort();
    Q_INVOKABLE void disconnectPort();

public slots:
    void setPortName(const QString &portName);

signals:
    void connectedChanged();
    void portNameChanged();
    void errorRaised(const QString &message);

private slots:
    void readReady();

private:
    TelemetryParser *m_parser = nullptr;
    QSerialPort m_port;
    QByteArray m_buffer;
    QString m_portName;
};
