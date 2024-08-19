#include <auroraapp.h>
#include <QtQuick>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "databasemanager.h"
#include "seconddatabasemanager.h"
#include <QQmlContext>

int main(int argc, char *argv[]) {
    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("ru.auroraos"));
    application->setApplicationName(QStringLiteral("MoiFinansi"));

    qmlRegisterType<DatabaseManager>("com.example.DatabaseManager", 1, 0, "DatabaseManager");
    qmlRegisterType<SecondDatabaseManager>("com.example.SecondDatabaseManager", 1, 0, "SecondDatabaseManager");


    QScopedPointer<QQuickView> view(Aurora::Application::createView());
    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/MoiFinansi.qml")));
    view->show();

    return application->exec();
}
