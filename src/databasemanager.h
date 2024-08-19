
#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    Q_INVOKABLE void addIncome(const QString &date, const QString &category, double amount);
    Q_INVOKABLE void removeIncomes();
    Q_INVOKABLE QVariantList getIncomes(const QString &startDate, const QString &endDate);
    Q_INVOKABLE QVariantList getMinMaxDates();
    Q_INVOKABLE void addExpense(const QString &date, const QString &category, double amount);
    Q_INVOKABLE void removeExpenses();
    Q_INVOKABLE QVariantList getExpenses(const QString &startDate, const QString &endDate);
    Q_INVOKABLE QVariantList getMinMaxDatesR();
    Q_INVOKABLE void setUserInfo(const QString &firstName, const QString &lastName, const QString &myage);
    Q_INVOKABLE QVariantMap getUserInfo();
};

#endif // DATABASEMANAGER_H
