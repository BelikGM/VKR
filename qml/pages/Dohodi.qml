import QtQuick 2.0
import Sailfish.Silica 1.0
import com.example.DatabaseManager 1.0


Page {
    objectName: "Dohodi"
    id: dogodi
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
                text: qsTr("Расходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Rashodi.qml"))
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
                title: qsTr("Доходы")
            }

            Label {
                id: labeladd
                text: qsTr("Добавить доход")
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Label{
                padding: Theme.paddingLarge
                text: qsTr("Дата:")
                Button {
                    id: datebutton
                    text:  Qt.formatDate(selectedDate, "yyyy-MM-dd")
                    //anchors.horizontalCenter: parent.horizontalCenter
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

            /*
            DatePicker {
                height: 400
                width: 400
                id: dateField
                anchors.horizontalCenter: parent.horizontalCenter

            }

            TextField {
                id: categoryField
                placeholderText: qsTr("Категория")
                onTextChanged: validateFields()
                EnterKey.onClicked:  categoryField.focus = false
            }
*/
            ComboBox {
                // anchors{top: myrow.bottom}
                id: categoryField2
                width: parent.width * 0.9
                //anchors.horizontalCenter: parent.horizontalCenter
                //description: "Выберите Категорию:"
                label : "Категория:"

                menu: ContextMenu {
                    MenuItem { text: "Зарплата" }
                    MenuItem { text: "Подарок" }
                    MenuItem { text: "Инвестиции" }
                    MenuItem { text: "Премия" }
                    MenuItem { text: "Пенсия" }
                    MenuItem { text: "Пособие" }
                    MenuItem { text: "Стипендия" }
                    MenuItem { text: "Проценты" }
                    MenuItem { text: "Прочее" }
                }
                onCurrentIndexChanged: validateFields()
            }


            TextField {
                id: amountField
                placeholderText: qsTr("Введите значение")
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

                    var categoryText = categoryField2.currentItem ? categoryField2.currentItem.text : "";

                    dbManager.addIncome(dateStr, categoryText, parseFloat(amountField.text));
                  //  incomeList.model.append({"date": dateStr, "category": categoryField2.value, "amount": parseFloat(amountField.text)});

                    categoryField2.value = "";
                    amountField.text = "";
                    saveButton.enabled = false;
                    updatefromto();
                    updateTotalIncomes(); // Обновить общую сумму доходов
                    updatedatebutton();
                    updateIncomeList();


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
                    text:dbManager.getMinMaxDates()[0];// Qt.formatDate(selectedDate, "yyyy-MM-dd")
                    anchors.verticalCenter: parent.verticalCenter
                    property var selectedDate: dbManager.getMinMaxDates()[0]
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
                    text: dbManager.getMinMaxDates()[1];//Qt.formatDate(selectedDate, "yyyy-MM-dd")
                    anchors.verticalCenter: parent.verticalCenter
                    property var selectedDate: dbManager.getMinMaxDates()[1]; //new Date()
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
                    updateIncomeList()
                    updateTotalIncomes(); // Обновить общую сумму доходов


                }

            }
            Label {
                id: totalIncomesLabel
                text: ""
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ListView {
                id: incomeList
                width: parent.width
                height: parent.height / 3
                bottomMargin: Theme.paddingLarge
                leftMargin: Theme.paddingSmall
                model: ListModel {
                    Component.onCompleted: {
                        console.log("list");
                        var startDate = Qt.formatDate(begindate.selectedDate, "yyyy-MM-dd");
                        var endDate = Qt.formatDate(enddate.selectedDate, "yyyy-MM-dd");
                        var incomes = dbManager.getIncomes(startDate, endDate);
                        incomeList.model.clear();
                        for (var i = 0; i < incomes.length; i++) {
                            incomeList.model.append(incomes[i]);
                        }
//                        for (var i = dbManager.getIncomes(startDate,endDate).length - 1; i >=0 ; i--) {
//                            var income = dbManager.getIncomes(startDate,endDate)[i];
//                            append({"date": income.date, "category": income.category, "amount": income.amount});
//                        }
                        updateTotalIncomes(); // Обновить общую сумму расходов при загрузке списка
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
                text: qsTr("Очистить доходы")
                enabled:  false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    dbManager.removeIncomes();
                    incomeList.model.clear();
                    updateTotalIncomes();
                }
            }
        }
    }
    function updatefromto(){
        begindate.text = dbManager.getMinMaxDates()[0];
        begindate.selectedDate  = dbManager.getMinMaxDates()[0];
        enddate.text = dbManager.getMinMaxDates()[1];
        enddate.selectedDate = dbManager.getMinMaxDates()[1];
    }

    function updateIncomeList() {
        console.log("updatelist");
            var startDate = Qt.formatDate(begindate.selectedDate, "yyyy-MM-dd");
            var endDate = Qt.formatDate(enddate.selectedDate, "yyyy-MM-dd");
            var incomes = dbManager.getIncomes(startDate, endDate);
            incomeList.model.clear();
            for (var i = 0; i < incomes.length; i++) {
                incomeList.model.append(incomes[i]);
            }
        }
    function updatedatebutton()
    {
        console.log("updatebutton");
        datebutton.selectedDate = new Date();
        datebutton.text = Qt.formatDate(datebutton.selectedDate, "yyyy-MM-dd")
    }
    function validateFields() {
        categoryField2.value  = categoryField2.currentItem.text;
        var dateValid =     datebutton.text !== "";
        //var categoryValid = categoryField2.text !== "";
        var amountValid = amountField.text.trim() !== "" && !isNaN(amountField.text) && parseFloat(amountField.text) > 0;
        saveButton.enabled = /* categoryValid && */ amountValid;
    }

    function updateTotalIncomes(){
        console.log("updatetotal");
        var total = 0;
        var incomes = dbManager.getIncomes(begindate.text,enddate.text);
        for (var i = 0; i < incomes.length; i++) {
            total += incomes[i].amount;
        }
        deleteButton.enabled = total > 0;
        totalIncomesLabel.text = "Общая сумма доходов: " + total.toFixed(2); // Отображаем сумму с двумя десятичными знаками
    }
}

