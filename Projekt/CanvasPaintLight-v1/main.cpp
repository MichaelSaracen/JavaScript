#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "cpp/canvasengine.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Saracen");
    app.setOrganizationDomain("CBM");
    qmlRegisterType<CanvasEngine>("App.Components", 1, 0, "CanvasEngine");
    //qmlRegisterType<ImageFilter>("App.Constants", 1, 0, "ImageFilter");
    QQmlApplicationEngine engine;
    engine.addImportPath(":/");
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
