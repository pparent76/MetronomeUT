#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include <QQmlContext>

#include "Timer.h"
int main(int argc, char *argv[])
{
    QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
    app->setApplicationName("metronome.pparent");

    qDebug() << "Starting app from main.cpp";

    QQuickView *view = new QQuickView();
    Timer timer;
    view->rootContext()->setContextProperty("timer", &timer);
    view->setSource(QUrl("qrc:/qml/Main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();

    return app->exec();
}
