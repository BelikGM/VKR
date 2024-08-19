import QtQuick 2.0
import Sailfish.Silica 1.0
import com.example.DatabaseManager 1.0

Page {
    objectName: "mainPage"
    id: mainPage
    allowedOrientations: Orientation.All

    DatabaseManager {
        id: dbManager
    }

    SilicaFlickable {
        VerticalScrollDecorator{}
        anchors.fill: parent
        PullDownMenu {
            highlightColor: Theme.highlightColor
            backgroundColor: Theme.highlightColor
            MenuItem {
                horizontalAlignment: Text.AlignHCenter
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
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Главная")
            }

            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Информация о пользователе")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }

            TextField {
                id: firstNameField
                //placeholderText: qsTr("Имя")
                text: dbManager.getUserInfo().first_name
                label: "Имя"
                EnterKey.onClicked:  {firstNameField.focus = false; lastNameField.focus = true}

                onTextChanged: validateFields()
                // onTextChanged: dbManager.setUserInfo(firstNameField.text, lastNameField.text)
            }

            TextField {
                id: lastNameField
                // placeholderText: qsTr("Фамилия")
                label: "Фамилия"
                text: dbManager.getUserInfo().last_name
                EnterKey.onClicked:  {lastNameField.focus = false; ageField.focus = true}
                onTextChanged: validateFields()
                // onTextChanged: dbManager.setUserInfo(firstNameField.text, lastNameField.text)
            }
            TextField {
                id: ageField
                text: dbManager.getUserInfo().my_age
                placeholderText: qsTr("Введите ваш Возраст")
                label: "Возраст"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onTextChanged: validateFields()
                EnterKey.onClicked:  ageField.focus = false
            }




            Button {
                id: saveButton
                text: qsTr("Сохранить")
                enabled: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    dbManager.setUserInfo(firstNameField.text.trim(), lastNameField.text.trim(), ageField.text.trim());
                    saveButton.enabled = false;
                    var userInfo = dbManager.getUserInfo();
                            console.log (userInfo.first_name, userInfo.last_name, userInfo.my_age);
                    // console.log( "Setting user info:",firstNameField.text , lastNameField.text , parseInt(ageField.text))
                }
            }
                 }
    }

    function validateFields() {
        var ageValid = ageField.text.trim() !== "" && !isNaN(ageField.text) && parseFloat(ageField.text) > 0 && parseFloat(ageField.text) < 120;
        var firstNameValid = firstNameField.text.trim() !== "";
        var lastNameValid = lastNameField.text.trim() !== "";
        saveButton.enabled =  ageValid && lastNameValid && firstNameValid;

    }
}
