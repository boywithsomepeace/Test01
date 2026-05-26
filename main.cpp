#include <QGuiApplication>
#include <QCoreApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend/SerialManager.h"
#include "backend/TelemetryParser.h"
#include "backend/TelemetrySimulator.h"
#include "backend/VehicleData.h"
#include "backend/WarningManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("EV_HMI"));
    QGuiApplication::setOrganizationName(QStringLiteral("EmbeddedEV"));

    VehicleData vehicleData;
    TelemetryParser parser(&vehicleData);
    SerialManager serialManager(&parser);
    WarningManager warningManager(&vehicleData);
    TelemetrySimulator simulator(&vehicleData);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("vehicleData"), &vehicleData);
    engine.rootContext()->setContextProperty(QStringLiteral("telemetryParser"), &parser);
    engine.rootContext()->setContextProperty(QStringLiteral("serialManager"), &serialManager);
    engine.rootContext()->setContextProperty(QStringLiteral("warningManager"), &warningManager);
    engine.rootContext()->setContextProperty(QStringLiteral("telemetrySimulator"), &simulator);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, [] {
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    return app.exec();
}
