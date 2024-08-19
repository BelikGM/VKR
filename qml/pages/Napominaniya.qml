import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "Dohodi"
    id: napominaniya
    allowedOrientations: Orientation.All

    SilicaFlickable{
        anchors.fill: parent
        PullDownMenu{
            highlightColor: "white"
            backgroundColor: "white"

            MenuItem{
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Главная")
                onClicked: pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
            MenuItem{
                text: qsTr("Доходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Dohodi.qml"))
            }
            MenuItem{
                text: qsTr("Расходы")
                onClicked: pageStack.push(Qt.resolvedUrl("Rashodi.qml"))
            }
            MenuItem{
                text: qsTr("Сбережения")
                onClicked: pageStack.push(Qt.resolvedUrl("Savings.qml"))
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
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Напоминания")
            }
            Label {
                id: napominaniyaLabel
                x: Theme.horizontalPageMargin
                anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
                color: palette.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                text: qsTr("Здесь вы можете записывать свои планы, чтобы не забыть")
            }
            TextArea {
                id: napominaniyaField
                placeholderText: qsTr("Введите ваши планы здесь")
                wrapMode: TextEdit.WordWrap
                height: parent.height / 3
            }
            Button {
                text: qsTr("Сохранить")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    napominaniyaField.text = ""
                }
            }
        }
    }
}
