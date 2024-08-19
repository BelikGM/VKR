import QtQuick 2.0
import Sailfish.Silica 1.0
import com.example.DatabaseManager 1.0
//import QtQuick.Controls 2.15

Page {
    objectName: "Rashodi"
    id: rashodi
    allowedOrientations: Orientation.All

    DatabaseManager {
        id: dbManager
    }

    SilicaFlickable {
        VerticalScrollDecorator{}
        anchors.fill: parent
        PullDownMenu {
            highlightColor: "white"
            backgroundColor: "white"
            MenuItem {
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Главная")
                onClicked: pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
            MenuItem {
                text: qsTr("Доходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Dohodi.qml"))
            }
            MenuItem {
                text: qsTr("Сбережения")
                onClicked: pageStack.push(Qt.resolvedUrl("Savings.qml"))
            }
            MenuItem{
                //height: 100
                text: qsTr("Цель")
                onClicked: pageStack.push(Qt.resolvedUrl("Achieve.qml"))

            }
            MenuItem{
                //height: 100
                text: qsTr("Задолженности")
                onClicked: pageStack.push(Qt.resolvedUrl("Debts.qml"))

            }
            MenuItem{
                //height: 100
                text: qsTr("Аналитика")
                onClicked: pageStack.push(Qt.resolvedUrl("Analitika.qml"))
            }
            MenuItem{
                //height: 100
                text: qsTr("Советы")
                onClicked: pageStack.push(Qt.resolvedUrl("Advice.qml"))

            }

            MenuItem {
                text: qsTr("О приложении")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Расходы")
            }

            Label {
                text: qsTr("Добавить расход")
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Label{
                padding: Theme.paddingLarge
                text: qsTr("Дата:")
                Button {
                    id: datebutton
                    text:  Qt.formatDate(selectedDate, "yyyy-MM-dd")
                                       anchors{left:parent.right  ; verticalCenter: parent.verticalCenter }
                    property var selectedDate: new Date() // добавляем свойство для хранения выбранной даты
                    onClicked: {
                        var dialog = pageStack.push(pickerComponent, {
                                                        date: new Date()
                                                    })
                        dialog.accepted.connect(function() {
                            datebutton.selectedDate = dialog.date // сохраняем выбранную дату в свойство
                            datebutton.text = Qt.formatDate(datebutton.selectedDate, "yyyy-MM-dd") // форматируем текст кнопки
                        })
                    }

                    Component {
                        id: pickerComponent
                        DatePickerDialog {
                            id: datePickerDialog
                            date: datebutton.selectedDate // передаем текущую дату в диалог выбора даты
                        }
                    }
                }

            }
            /*  DatePicker {
                height: 400
                width: 400
                id: dateField
                anchors.horizontalCenter: parent.horizontalCenter
            } */

            TextField {
                id: categoryField
                placeholderText: qsTr("Введите название категории")
                label: "Категория"
                onTextChanged: validateFields()
                EnterKey.onClicked: { categoryField.focus = false; amountField.focus = true}

            }

            TextField {
                id: amountField
                placeholderText: qsTr("Введите значение ")
                label: "Сумма"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onTextChanged: validateFields()
                EnterKey.onClicked:  amountField.focus = false
            }

            Button {
                id: saveButton
                text: qsTr("Сохранить")
                enabled: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var dateStr = Qt.formatDate(datebutton.selectedDate, "yyyy-MM-dd");
                    dbManager.addExpense(dateStr, categoryField.text.trim(), parseFloat(amountField.text.trim()));
                  //  expenseList.model.append({"date": dateStr, "category": categoryField.text.trim(), "amount": parseFloat(amountField.text)});

                    categoryField.text = "";
                    amountField.text = "";
                    saveButton.enabled = false;
                    updatefromto();
                    updateTotalExpenses(); // Обновить общую сумму доходов
                    updatedatebutton();
                    updateExpenseList();

                }
            }

            Row {
                spacing: Theme.paddingSmall
                Label {
                    id: labelfrom
                    text: qsTr("От")
                    anchors.verticalCenter: parent.verticalCenter
                }
                Button {
                    id: begindate
                    text:dbManager.getMinMaxDatesR()[0];// Qt.formatDate(selectedDate, "yyyy-MM-dd")
                    anchors.verticalCenter: parent.verticalCenter
                    property var selectedDate: dbManager.getMinMaxDatesR()[0]
                    onClicked: {
                        var dialog = pageStack.push(pickerComponent2, { date: new Date() })
                        dialog.accepted.connect(function() {
                            begindate.selectedDate = dialog.date
                            begindate.text = Qt.formatDate(begindate.selectedDate, "yyyy-MM-dd")
                        })
                    }
                    Component {
                        id: pickerComponent2
                        DatePickerDialog {
                            id: datePickerDialog2
                            date: begindate.text
                        }
                    }
                }
                Label {
                    id: labelto
                    text: qsTr("До")
                    anchors.verticalCenter: parent.verticalCenter
                }
                Button {
                    id: enddate
                    text: dbManager.getMinMaxDatesR()[1];//Qt.formatDate(selectedDate, "yyyy-MM-dd")
                    anchors.verticalCenter: parent.verticalCenter
                    property var selectedDate: dbManager.getMinMaxDatesR()[1]; //new Date()
                    onClicked: {

                        var dialog = pageStack.push(pickerComponent3, { date: new Date() })
                        dialog.accepted.connect(function() {
                            enddate.selectedDate = dialog.date
                            enddate.text = Qt.formatDate(enddate.selectedDate, "yyyy-MM-dd")

                        })
                    }
                    Component {
                        id: pickerComponent3
                        DatePickerDialog {
                            id: datePickerDialog3
                            date: enddate.selectedDate
                        }
                    }
                }
            }

            Button {
                id: showButton
                text: qsTr("Показать")
                enabled: true
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    updateExpenseList()
                    updateTotalExpenses(); // Обновить общую сумму доходов


                }

            }
            Label {
                id: totalExpensesLabel
                text: ""
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ListView {
                id: expenseList
                width: parent.width
                height: parent.height / 3
                bottomMargin: Theme.paddingLarge
                leftMargin: Theme.paddingSmall
                model: ListModel {
                    Component.onCompleted: {
                        console.log("list");
                        var startDate = Qt.formatDate(begindate.selectedDate, "yyyy-MM-dd");
                        var endDate = Qt.formatDate(enddate.selectedDate, "yyyy-MM-dd");
                        var expenses = dbManager.getExpenses(startDate, endDate);
                        expenseList.model.clear();
                        for (var i = 0; i < expenses.length; i++) {
                            expenseList.model.append(expenses[i]);
                        }
//                        for (var i = dbManager.getIncomes(startDate,endDate).length - 1; i >=0 ; i--) {
//                            var income = dbManager.getIncomes(startDate,endDate)[i];
//                            append({"date": income.date, "category": income.category, "amount": income.amount});
//                        }
                        updateTotalExpenses(); // Обновить общую сумму расходов при загрузке списка
                    }
                }

                delegate: Item {
                    width: parent.width
                    height: 50

                    Row {
                        spacing: 10
                        Label {
                            text: model.date
                            font.pixelSize: Theme.fontSizeMedium



                        }

                        Label {
                            text: model.category
                            font.pixelSize: Theme.fontSizeMedium
                            width: parent.width*0.45
                            truncationMode: TruncationMode.Elide
                        }

                        Label {
                            text: model.amount
                            font.pixelSize: Theme.fontSizeMedium

                        }
                    }
                }
            }
            Button{
                id: deleteButton
                text: qsTr("Очистить расходы")
                enabled:  false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    dbManager.removeExpenses();
                    expenseList.model.clear();
                    updateTotalExpenses();
                }
            }


            }
        }

    function updatefromto(){
        begindate.text = dbManager.getMinMaxDatesR()[0];
        begindate.selectedDate  = dbManager.getMinMaxDatesR()[0];
        enddate.text = dbManager.getMinMaxDatesR()[1];
        enddate.selectedDate = dbManager.getMinMaxDatesR()[1];
    }

    function updateExpenseList() {
        console.log("updatelist");
            var startDate = Qt.formatDate(begindate.selectedDate, "yyyy-MM-dd");
            var endDate = Qt.formatDate(enddate.selectedDate, "yyyy-MM-dd");
            var expenses = dbManager.getExpenses(startDate, endDate);
            expenseList.model.clear();
            for (var i = 0; i < expenses.length; i++) {
                expenseList.model.append(expenses[i]);
            }
        }
    function updatedatebutton()
    {
        console.log("updatebutton");
        datebutton.selectedDate = new Date();
        datebutton.text = Qt.formatDate(datebutton.selectedDate, "yyyy-MM-dd")
    }
    function validateFields() {
        var dateValid =     datebutton.text !== "";
        var categoryValid = categoryField.text.trim() !== "";
        var amountValid = amountField.text.trim() !== "" && !isNaN(amountField.text) && parseFloat(amountField.text) > 0;
        saveButton.enabled = categoryValid && amountValid;
    }

    function updateTotalExpenses(){
        console.log("updatetotal");
        var total = 0;
        var expenses = dbManager.getExpenses(begindate.text,enddate.text);
        for (var i = 0; i < expenses.length; i++) {
            total += expenses[i].amount;
        }
        deleteButton.enabled = total > 0;
        totalExpensesLabel.text = "Общая сумма расходов: " + total.toFixed(2); // Отображаем сумму с двумя десятичными знаками
    }
}






/*  Column{

            id: column
           width: page.width
            spacing: Theme.paddingLarge
            PageHeader{
                title: qsTr("Расходы")

            }
            Label{
                x:Theme.horizontalPageMargin
                text: qsTr("TExtText")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
        }
        SilicaListView {
            anchors.topMargin: column.height
            anchors.centerIn: parent

            VerticalScrollDecorator{}
            anchors.fill: parent

            model: ListModel {
                id: listModel
                Component.onCompleted: {
                    for (var i=1; i<20; i++) {
                        append({"name": "Item " + i})
                    }
                }
            }

            delegate: ListItem {
                width: ListView.view.width

                Label {
                    id: label
                    text: model.name
                    anchors.centerIn: parent
                }

                menu: ContextMenu {
                    MenuItem {
                        text: "Toggle bold font"
                        onClicked: label.font.bold = !label.font.bold
                    }
                    MenuItem {
                        text: "Remove"
                        onClicked: listModel.remove(model.index)
                    }
                }
            }
        }
        */

