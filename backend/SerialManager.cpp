#include "SerialManager.h"

#include "TelemetryParser.h"

SerialManager::SerialManager(TelemetryParser *parser, QObject *parent)
    : QObject(parent)
    , m_parser(parser)
{
    connect(&m_port, &QSerialPort::readyRead, this, &SerialManager::readReady);
}

bool SerialManager::connected() const
{
    return m_port.isOpen();
}

QString SerialManager::portName() const
{
    return m_portName;
}

void SerialManager::setPortName(const QString &portName)
{
    if (m_portName == portName)
        return;
    m_portName = portName;
    emit portNameChanged();
}

void SerialManager::connectPort()
{
    if (m_port.isOpen())
        return;

    m_port.setPortName(m_portName);
    m_port.setBaudRate(QSerialPort::Baud115200);
    m_port.setDataBits(QSerialPort::Data8);
    m_port.setParity(QSerialPort::NoParity);
    m_port.setStopBits(QSerialPort::OneStop);
    m_port.setFlowControl(QSerialPort::NoFlowControl);

    if (!m_port.open(QIODevice::ReadOnly)) {
        emit errorRaised(m_port.errorString());
        return;
    }
    emit connectedChanged();
}

void SerialManager::disconnectPort()
{
    if (!m_port.isOpen())
        return;
    m_port.close();
    emit connectedChanged();
}

void SerialManager::readReady()
{
    m_buffer.append(m_port.readAll());
    int index = -1;
    while ((index = m_buffer.indexOf('\n')) >= 0) {
        const QByteArray line = m_buffer.left(index);
        m_buffer.remove(0, index + 1);
        if (m_parser)
            m_parser->parseLine(line);
    }
}
