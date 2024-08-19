#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>
#include <QTimer>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

class NotificationManager : public QObject {
    Q_OBJECT
public:
    explicit NotificationManager(QObject *parent = nullptr);

public slots:
    void scheduleNotification(const QString &text, const QDateTime &dateTime);

private slots:
    void showNotification();

private:
    QTimer *timer;
    QString notificationText;
};

#endif
