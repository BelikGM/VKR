#include "databasemanager.h"

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("finance_app.db");

    if (!db.open()) {
        qDebug() << "Ошибка открытия базы данных:" << db.lastError();
    } else {
        QSqlQuery query;
        query.exec("CREATE TABLE IF NOT EXISTS incomes (id INTEGER PRIMARY KEY, date TEXT, category TEXT, amount REAL)");
        query.exec("CREATE TABLE IF NOT EXISTS expenses (id INTEGER PRIMARY KEY, date TEXT, category TEXT, amount REAL)");
        query.exec("CREATE TABLE IF NOT EXISTS user1 (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, my_age TEXT)");
    }
}

void DatabaseManager::addIncome(const QString &date, const QString &category, double amount) {
    QSqlQuery query;
    query.prepare("INSERT INTO incomes (date, category, amount) VALUES (:date, :category, :amount)");
    query.bindValue(":date", date);
    query.bindValue(":category", category);
    query.bindValue(":amount", amount);
    if (!query.exec()) {
        qDebug() << "Ошибка добавления дохода:" << query.lastError();
    }
}

void DatabaseManager::removeIncomes() {
    QSqlQuery query("DELETE FROM incomes");
    if (!query.exec()) {
        qDebug() << "Ошибка удаления доходов:" << query.lastError();
    }
}

QVariantList DatabaseManager::getIncomes(const QString &startDate, const QString &endDate) {
   /* QSqlQuery query("SELECT date, category, amount FROM incomes");
    QVariantList incomes;
    while (query.next()) {
        QVariantMap income;
        income["date"] = query.value(0).toString();
        income["category"] = query.value(1).toString();
        income["amount"] = query.value(2).toDouble();
        incomes.append(income);
    }
    return incomes;*/
    qDebug() << "Setting getIncomes info:" << startDate << endDate ; // Для отладки

    QSqlQuery query;
    query.prepare("SELECT date, category, amount FROM incomes WHERE date BETWEEN :start_date AND :end_date");
    query.bindValue(":start_date", startDate);
    query.bindValue(":end_date", endDate);
    if (!query.exec()) {
        qDebug() << "Ошибка получения доходов за промежуток времени:" << query.lastError();
        return QVariantList();
    }

    QVariantList incomes;
    while (query.next()) {
        QVariantMap income;
        income["date"] = query.value(0).toString();
        income["category"] = query.value(1).toString();
        income["amount"] = query.value(2).toDouble();
        incomes.append(income);
         qDebug() << query.value(0).toString()<< query.value(1).toString()<< query.value(2).toString()<< endl;
    }
    return incomes;
}

QVariantList DatabaseManager::getMinMaxDates() {
    QSqlQuery query;
    query.prepare("SELECT MIN(date), MAX(date) FROM incomes");

    if (!query.exec()) {
        qDebug() << "Ошибка получения минимальной и максимальной даты:" << query.lastError();
        return QVariantList();
    }

    QVariantList minMaxDates;
    if (query.next()) {
        minMaxDates.append(query.value(0).toString());
        minMaxDates.append(query.value(1).toString());
    }

    return minMaxDates;
}
void DatabaseManager::addExpense(const QString &date, const QString &category, double amount) {
    QSqlQuery query;
    query.prepare("INSERT INTO expenses (date, category, amount) VALUES (:date, :category, :amount)");
    query.bindValue(":date", date);
    query.bindValue(":category", category);
    query.bindValue(":amount", amount);
    if (!query.exec()) {
        qDebug() << "Ошибка добавления расхода:" << query.lastError();
    }
}
void DatabaseManager::removeExpenses() {
    QSqlQuery query("DELETE FROM expenses");
    if (!query.exec()) {
        qDebug() << "Ошибка удаления расходов :" << query.lastError();
    }
}
QVariantList DatabaseManager::getExpenses(const QString &startDate, const QString &endDate) {
 /*   QSqlQuery query("SELECT date, category, amount FROM expenses");
    QVariantList expenses;
    while (query.next()) {
        QVariantMap expense;
        expense["date"] = query.value(0).toString();
        expense["category"] = query.value(1).toString();
        expense["amount"] = query.value(2).toDouble();
        expenses.append(expense);
    }
    return expenses;
    */
    qDebug() << "Setting getExpenses info:" << startDate << endDate ; // Для отладки

    QSqlQuery query;
    query.prepare("SELECT date, category, amount FROM expenses WHERE date BETWEEN :start_date AND :end_date");
    query.bindValue(":start_date", startDate);
    query.bindValue(":end_date", endDate);
    if (!query.exec()) {
        qDebug() << "Ошибка получения расходов за промежуток времени:" << query.lastError();
        return QVariantList();
    }

    QVariantList expenses;
    while (query.next()) {
        QVariantMap expense;
        expense["date"] = query.value(0).toString();
        expense["category"] = query.value(1).toString();
        expense["amount"] = query.value(2).toDouble();
        expenses.append(expense);
         qDebug() << query.value(0).toString()<< query.value(1).toString()<< query.value(2).toString()<< endl;
    }
    return expenses;
}
QVariantList DatabaseManager::getMinMaxDatesR() {
    QSqlQuery query;
    query.prepare("SELECT MIN(date), MAX(date) FROM expenses");

    if (!query.exec()) {
        qDebug() << "Ошибка получения минимальной и максимальной даты:" << query.lastError();
        return QVariantList();
    }

    QVariantList minMaxDates;
    if (query.next()) {
        minMaxDates.append(query.value(0).toString());
        minMaxDates.append(query.value(1).toString());
    }

    return minMaxDates;
}

void DatabaseManager::setUserInfo(const QString &firstName, const QString &lastName, const QString &myage){
    qDebug() << "Setting user1 info:" << firstName << lastName << myage; // Для отладки
    QSqlQuery deleteQuery;
    if (!deleteQuery.exec("DELETE FROM user1")) {
        qDebug() << "Ошибка удаления информации о пользователе:" << deleteQuery.lastError();
        return;
    }

    QSqlQuery insertQuery;
    insertQuery.prepare("INSERT INTO user1 (first_name, last_name, my_age) VALUES (:first_name, :last_name, :my_age)");
    insertQuery.bindValue(":first_name", firstName);
    insertQuery.bindValue(":last_name", lastName);
    insertQuery.bindValue(":my_age",myage);

    if (!insertQuery.exec()) {
        qDebug() << "Ошибка установки информации о пользователе:" << insertQuery.lastError();
    }
}

QVariantMap DatabaseManager::getUserInfo() {
    QSqlQuery query("SELECT  first_name, last_name, my_age FROM user1 ORDER BY ROWID DESC LIMIT 1");
    QVariantMap userInfo;
    if (query.next()) {

        userInfo["first_name"] = query.value(0).toString();
        userInfo["last_name"] = query.value(1).toString();
        userInfo["my_age"] = query.value(2).toString();
    }
    return userInfo;
}

