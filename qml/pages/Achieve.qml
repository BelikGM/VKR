import QtQuick 2.0
import Sailfish.Silica 1.0
import com.example.SecondDatabaseManager 1.0
Page {
    //backgroundColor: "transparent"
    objectName: "achieve"
    id: achieve
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
                //height: 100
                text: qsTr("Главная")
                onClicked: pageStack.push(Qt.resolvedUrl("MainPage.qml"))

            }
            MenuItem{
                //height: 100
                horizontalAlignment:     Text.AlignHCenter
                text: qsTr("Доходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Dohodi.qml"))


            }
            MenuItem{
                //height: 100
                text: qsTr("Расходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Rashodi.qml"))

            }
            MenuItem{
                //height: 100
                text: qsTr("Сбережения")
                onClicked: pageStack.push(Qt.resolvedUrl("Savings.qml"))

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

            MenuItem{
                //height: 100
                text: qsTr("О приложении")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))

            }
        }

        contentHeight: column.height
        Column{
            anchors.fill: parent
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader{
                title: qsTr("Цель")

            }
            Label{
                x:Theme.horizontalPageMargin
                text: qsTr("Я хочу накопить на...")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            TextField {
                id: commentField
                placeholderText: qsTr("Название цели")
                text: secdbManager.getAchieves().comment// ? secdbManager.getAchieves().comment : ""

                //text: secdbManager.getAchieves().comment
                label: qsTr("Цель")
                onTextChanged: validateFields()
                EnterKey.onClicked: {commentField.focus = false; amountField.focus = true}
            }

            TextField {
                id: amountField
                placeholderText: qsTr("Стоимость")
                label: qsTr("Стоимость")
                //text: secdbManager.getAchieves().amount // secdbManager.getAchieves().amount : ""

                 text: secdbManager.getAchieves().amount
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onTextChanged: validateFields()
                 EnterKey.onClicked: {amountField.focus = false}
            }

            Button {
                id: saveButton
                text: qsTr("Сохранить")
                enabled: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    //secdbManager.addAchieve(commentField.text, parseFloat(amountField.text));
                      secdbManager.addAchieve(commentField.text.trim(), parseFloat(amountField.text));
                    saveButton.enabled = false;
                    updateProgress();

                }
            }
            Label {
                id: totalSavingsLabel
                text: ""
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }




            ProgressBar {
                   id: progressBar
                   width: parent.width
                   maximumValue: parseFloat(amountField.text)
                   value: calculateProgress()
                   valueText: (isNaN(value / maximumValue) || !isFinite(value / maximumValue))
                              ? qsTr("")
                              : Math.round((value / maximumValue) * 100) + "%"
               }

        }
    }

    function validateFields() {
        var commentValid = commentField.text.trim() !== "";
        var amountValid = amountField.text.trim() !== "" && !isNaN(amountField.text) && parseFloat(amountField.text) > 0;
        saveButton.enabled = commentValid && amountValid;
    }

    function calculateProgress() {
        var totalSavings = 0;
        var savings = secdbManager.getSavings();
        for (var i = 0; i < savings.length; i++) {
            totalSavings += savings[i].amount;
        }
        totalSavingsLabel.text = "Текущая сумма сбережений: " + totalSavings.toFixed(2);
        return totalSavings;

    }

    function updateProgress() {
        progressBar.value = calculateProgress();
    }


}






/*  ProgressBar{
      anchors.top: column.bottom
      highlighted : true
      indeterminate : false
      label : "string"
      maximumValue : 1.0
      minimumValue : 0
      progressValue : 0.8
    //  value : 50
      valueText : "string222"
  }
  ProgressBar {
      maximumValue: 100
      value: 50
      valueText: value + "%"
  } */
