import QtQuick 2.0
import Sailfish.Silica 1.0
import com.example.SecondDatabaseManager 1.0

Page {
    objectName: "debts"
    id: debts
    allowedOrientations: Orientation.All

    SecondDatabaseManager {
        id: secdbManager
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
                title: qsTr("Задолженности")
            }

            Label {
                text: qsTr("Добавить задолженность")
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Label{
                padding: Theme.paddingLarge
                text: qsTr("Дата:")
                Button {
                    id: datebutton
                    text:  Qt.formatDate(selectedDate, "dd-MM-yyyy")
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors{left:parent.right  ; verticalCenter: parent.verticalCenter }
                    property var selectedDate: new Date() // добавляем свойство для хранения выбранной даты
                    onClicked: {
                        var dialog = pageStack.push(pickerComponent, {
                                                        date: new Date()
                                                    })
                        dialog.accepted.connect(function() {
                            datebutton.selectedDate = dialog.date // сохраняем выбранную дату в свойство
                            datebutton.text = Qt.formatDate(datebutton.selectedDate, "dd-MM-yyyy") // форматируем текст кнопки
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
            /*DatePicker {
                height: 400
                width: 400
                id: dateField
                anchors.horizontalCenter: parent.horizontalCenter
            }*/

            TextField {
                id: commentField
                placeholderText: qsTr("Комментарий")
                label: "Комментарий"
                onTextChanged: validateFields()
                EnterKey.onClicked: { commentField.focus = false; amountField.focus = true}

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
                    var dateStr = Qt.formatDate(datebutton.selectedDate, "dd-MM-yyyy");
                    secdbManager.addDebt(dateStr, commentField.text, parseFloat(amountField.text));
                    debtList.model.append({"date": dateStr, "comment": commentField.text.trim(), "amount": parseFloat(amountField.text)});
                    commentField.text = "";
                    amountField.text = "";
                    saveButton.enabled = false;
                    deleteButton.enabled = true
                    updateTotalDebts();
                    updatedatebutton();
                }
            }

            Label {
                id: totalDebtsLabel
                text: ""
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button{
                id: deleteButton
                text: qsTr("Очистить долги")
                enabled:  false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    secdbManager.removeDebts();
                    debtList.model.clear();
                    updateTotalDebts();
                }
            }
            ListView {
                id: debtList
                width: parent.width
                height: parent.height / 3
                leftMargin: Theme.paddingSmall
                model: ListModel {
                    Component.onCompleted: {
                        for (var i = secdbManager.getDebts().length - 1; i >=0 ; i--) {
                            var debt = secdbManager.getDebts()[i];
                            append({"date": debt.date, "comment": debt.comment, "amount": debt.amount});
                        }
                        updateTotalDebts(); // Обновить общую сумму расходов при загрузке списка
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
                            text: model.comment
                            font.pixelSize: Theme.fontSizeSmall
                            truncationMode: TruncationMode.Elide
                            width: parent.width* 0.4
                        }

                        Label {
                            text: model.amount
                            font.pixelSize: Theme.fontSizeMedium
                        }
                    }
                }
            }
        }
    }
    function updatedatebutton()
    {
        datebutton.selectedDate = new Date();
        datebutton.text = Qt.formatDate(datebutton.selectedDate, "dd-MM-yyyy")
    }
    function validateFields() {
        var dateValid = datebutton.text !== "";
        var commentValid = commentField.text.trim() !== "";
        var amountValid = amountField.text.trim() !== "" && !isNaN(amountField.text) && parseFloat(amountField.text) > 0.0;
        saveButton.enabled =  commentValid && amountValid;

    }

    function updateTotalDebts() {
        var total = 0;
        var debts = secdbManager.getDebts();
        for (var i = 0; i < debts.length; i++) {
            total += debts[i].amount;
        }
        totalDebtsLabel.text = "Общая сумма долгов: " + total.toFixed(2);
        deleteButton.enabled = total > 0;
    }
}
