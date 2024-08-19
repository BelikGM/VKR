#include "notificationmanager.h"
/*#include <QtQuick>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>*/
#include <QSystemTrayIcon>
#include <QDateTime>
#include <QApplication>
#include <QMessageBox>

NotificationManager::NotificationManager(QObject *parent): QObject(parent), timer(new QTimer(this)) {
    connect(timer, &QTimer::timeout, this, &NotificationManager::showNotification);
}

void NotificationManager::scheduleNotification(const QString &text, const QDateTime &dateTime) {
    notificationText = text;
    qint64 interval = QDateTime::currentDateTime().msecsTo(dateTime);
    if (interval > 0) {
        timer->start(interval);
    } else {
        qDebug() << "Scheduled time is in the past!";
    }
}

void NotificationManager::showNotification() {
    timer->stop();
    // Show the notification here
    QMessageBox::information(nullptr, "Notification", notificationText);
}

