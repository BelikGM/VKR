#include "seconddatabasemanager.h"

SecondDatabaseManager::SecondDatabaseManager(QObject *parent): QObject(parent) {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("finance_app_2.db");

    if (!db.open()) {
        qDebug() << "Ошибка открытия базы данных:" << db.lastError();
    } else {
        QSqlQuery query;
        query.exec("CREATE TABLE IF NOT EXISTS savings (id INTEGER PRIMARY KEY, comment TEXT, amount REAL)");
        query.exec("CREATE TABLE IF NOT EXISTS debts (id INTEGER PRIMARY KEY, date TEXT, comment TEXT, amount REAL)");
        query.exec("CREATE TABLE IF NOT EXISTS goal (id INTEGER PRIMARY KEY, comment TEXT, amount TEXT)");

    }
}
void SecondDatabaseManager::addAchieve(const QString &achieve, const QString &amount) {
    qDebug() << "Setting user info:" << achieve << amount; // Для отладки
    QSqlQuery deleteQuery;
    if (!deleteQuery.exec("DELETE FROM goal")) {
        qDebug() << "Ошибка удаления информации о цели:" << deleteQuery.lastError();
        return;
    }

    QSqlQuery insertQuery;
    insertQuery.prepare("INSERT INTO goal (comment, amount) VALUES (:comment, :amount)");
    insertQuery.bindValue(":comment", achieve);
    insertQuery.bindValue(":amount", amount);
    //insertQuery.bindValue(":age", age);
    if (!insertQuery.exec()) {
        qDebug() << "Ошибка установки информации о пользователе:" << insertQuery.lastError();
    }
}

QVariantMap SecondDatabaseManager::getAchieves() {
    QSqlQuery query("SELECT  comment, amount FROM goal");
    QVariantMap achieveInfo;
    if (query.next()) {
        achieveInfo["comment"] = query.value(0).toString();
        achieveInfo["amount"] = query.value(1).toString();
    }
    return achieveInfo;
}

void SecondDatabaseManager::addSaving(const QString &comment, double amount) {
    QSqlQuery query;
    query.prepare("INSERT INTO savings (comment, amount) VALUES (:comment, :amount)");
    query.bindValue(":comment", comment);
    query.bindValue(":amount", amount);
    if (!query.exec()) {
        qDebug() << "Ошибка добавления сбережения:" << query.lastError();
    }
}

void SecondDatabaseManager::removeSavings() {
    QSqlQuery query("DELETE FROM savings");
    if (!query.exec()) {
        qDebug() << "Ошибка удаления сбережений:" << query.lastError();
    }
}
QVariantList SecondDatabaseManager::getSavings() {
    QSqlQuery query("SELECT  comment, amount FROM savings");
    QVariantList savings;
    while (query.next()) {
        QVariantMap saving;
        saving["comment"] = query.value(0).toString();
        saving["amount"] = query.value(1).toDouble();
        savings.append(saving);
    }
    return savings;
}
void SecondDatabaseManager::addDebt(const QString &date, const QString &comment, double amount) {
    QSqlQuery query;
    query.prepare("INSERT INTO debts (date, comment, amount) VALUES (:date, :comment, :amount)");
    query.bindValue(":date", date);
    query.bindValue(":comment", comment);
    query.bindValue(":amount", amount);
    if (!query.exec()) {
        qDebug() << "Ошибка добавления задолженности:" << query.lastError();
    }
}

void SecondDatabaseManager::removeDebts() {
    QSqlQuery query("DELETE FROM debts");
    if (!query.exec()) {
        qDebug() << "Ошибка удаления долгов:" << query.lastError();
    }
}

QVariantList SecondDatabaseManager::getDebts() {
    QSqlQuery query("SELECT date, comment, amount FROM debts");
    QVariantList debts;
    while (query.next()) {
        QVariantMap debt;
        debt["date"] = query.value(0).toString();
        debt["comment"] = query.value(1).toString();
        debt["amount"] = query.value(2).toDouble();
        debts.append(debt);
    }
    return debts;
}
/*
void SecondDatabaseManager::addAchieve(const QString &comment) {
    QSqlQuery query;
    query.prepare("INSERT INTO achieves (comment) VALUES (:comment)");
    query.bindValue(":comment", comment);
    //query.bindValue(":amount", amount);
    if (!query.exec()) {
        qDebug() << "Ошибка добавления цели:" << query.lastError();
    }
}

QVariantMap SecondDatabaseManager::getAchieves() {
    QSqlQuery query("SELECT  comment FROM achieves");
    QVariantMap achieveInfo;
    if (query.next()) {
        //QVariantMap achieve;
        achieveInfo["comment"] = query.value(0).toString();
       // achieveInfo["amount"] = query.value(1).toDouble();
        //achieves.append(achieve);
    }
    return achieveInfo;
}
*/
/*
void DatabaseManager::setUserInfo(const QString &firstName, const QString &lastName) {
    //qDebug() << "Setting user info:" << firstName << lastName << age; // Для отладки
    QSqlQuery deleteQuery;
    if (!deleteQuery.exec("DELETE FROM user")) {
        qDebug() << "Ошибка удаления информации о пользователе:" << deleteQuery.lastError();
        return;
    }

    QSqlQuery insertQuery;
    insertQuery.prepare("INSERT INTO user (first_name, last_name) VALUES (:first_name, :last_name)");
    insertQuery.bindValue(":first_name", firstName);
    insertQuery.bindValue(":last_name", lastName);
    //insertQuery.bindValue(":age", age);
    if (!insertQuery.exec()) {
        qDebug() << "Ошибка установки информации о пользователе:" << insertQuery.lastError();
    }
}

QVariantMap DatabaseManager::getUserInfo() {
    QSqlQuery query("SELECT first_name, last_name FROM user");
    QVariantMap userInfo;
    if (query.next()) {
        userInfo["first_name"] = query.value(0).toString();
        userInfo["last_name"] = query.value(1).toString();
       // userInfo["age"] = query.value(2).toDouble();
    }
    return userInfo;
}
*/
