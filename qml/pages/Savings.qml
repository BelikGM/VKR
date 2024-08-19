import QtQuick 2.0
import Sailfish.Silica 1.0
import com.example.SecondDatabaseManager 1.0
Page {
    objectName: "savings"
    id: savings
    allowedOrientations: Orientation.All
    SecondDatabaseManager {
        id: secdbManager
    }
    SilicaFlickable{
        VerticalScrollDecorator{}
        anchors.fill: parent
        PullDownMenu{
            highlightColor: Theme.highlightColor
            backgroundColor: Theme.highlightColor
            MenuItem{
                text: qsTr("Главная")
                onClicked: pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
            MenuItem{
                horizontalAlignment:     Text.AlignHCenter
                text: qsTr("Доходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Dohodi.qml"))
            }
            MenuItem{
                text: qsTr("Расходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Rashodi.qml"))
            }
            MenuItem{
                text: qsTr("Цель")
                onClicked: pageStack.push(Qt.resolvedUrl("Achieve.qml"))

            }
            MenuItem{
                text: qsTr("Задолженности")
                onClicked: pageStack.push(Qt.resolvedUrl("Debts.qml"))

            }
            MenuItem{
                //height: 100
                text: qsTr("Аналитика")
                onClicked: pageStack.push(Qt.resolvedUrl("Analitika.qml"))
            }
            MenuItem{
                text: qsTr("Советы")
                onClicked: pageStack.push(Qt.resolvedUrl("Advice.qml"))
            }

            MenuItem{
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
                title: qsTr("Сбережения")
            }

            Label {
                text: qsTr("Добавить сбережение")
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
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
                    // var dateStr = Qt.formatDate(dateField.date, "yyyy-MM-dd");
                    secdbManager.addSaving( commentField.text.trim(), parseFloat(amountField.text));
                    savingList.model.append({ "comment": commentField.text.trim(), "amount": parseFloat(amountField.text)});
                    //dateField.text = "";
                    commentField.text = "";
                    amountField.text = "";
                    saveButton.enabled = false;
                    updateTotalSavings(); // Обновить общую сумму расходов
                }
            }
            Label {
                id: totalSavingsLabel
                text: ""
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button{
                id: deleteButton
                text: qsTr("Очистить сбережения")
                enabled:  true
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    secdbManager.removeSavings();
                    savingList.model.clear();
                    updateTotalSavings();
                }
            }

            ListView {
                id: savingList
                width: parent.width
                height: parent.height / 3
                leftMargin: Theme.paddingSmall
                model: ListModel {
                    Component.onCompleted: {
                        for (var i = secdbManager.getSavings().length - 1; i >=0 ; i--) {
                            var saving = secdbManager.getSavings()[i];
                            append({"comment": saving.comment, "amount": saving.amount});
                        }
                        updateTotalSavings(); // Обновить общую сумму расходов при загрузке списка
                    }
                }
                delegate: Item {
                    width: parent.width
                    height: 50
                    Row {
                        anchors.fill: parent
                        spacing: 20


                        Label {
                            text: model.comment
                            font.pixelSize: Theme.fontSizeMedium
                            truncationMode: TruncationMode.Elide
                            width: parent.width*0.45

                        }

                        Label {
                            text: model.amount
                            font.pixelSize: Theme.fontSizeMedium
                            truncationMode: TruncationMode.Elide
                            width: parent.width* 0.45
                        }
                    }
                }
            }
        }
    }
    function validateFields() {
        //var dateValid = dateField.text !== "";
        var commentValid = commentField.text.trim() !== "";
        var amountValid = amountField.text !== "" && !isNaN(amountField.text) && parseFloat(amountField.text) > 0;
        saveButton.enabled =  commentValid && amountValid;
    }

    function updateTotalSavings() {
        var total = 0;
        var savings = secdbManager.getSavings();
        for (var i = 0; i < savings.length; i++) {
            total += savings[i].amount;
        }
        deleteButton.enabled = total > 0;
        totalSavingsLabel.text = "Общая сумма сбережений: " + total.toFixed(2); // Отображаем сумму с двумя десятичными знаками
    }
}



