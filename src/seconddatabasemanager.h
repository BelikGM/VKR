#ifndef SECONDDATABASEMANAGER_H
#define SECONDDATABASEMANAGER_H


#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

class SecondDatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit SecondDatabaseManager(QObject *parent = nullptr);


    Q_INVOKABLE void addSaving(const QString &comment, double amount);
    Q_INVOKABLE void removeSavings();
    Q_INVOKABLE QVariantList getSavings();
    Q_INVOKABLE void addDebt(const QString &date,const QString &comment, double amount);
    Q_INVOKABLE void removeDebts();
    Q_INVOKABLE QVariantList getDebts();
    Q_INVOKABLE void addAchieve(const QString &comment, const QString &amount);
    Q_INVOKABLE QVariantMap getAchieves();

};

#endif // DATABASEMANAGER_H
