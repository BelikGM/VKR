import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    //backgroundColor: "transparent"
    objectName: "advice"
    id: advice
    allowedOrientations: Orientation.All

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
                text: qsTr("О приложении")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        contentHeight: column.height
        Column{
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader{
                title: qsTr("Советы")
            }
            Label{
                x: Theme.horizontalPageMargin
                anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
                text: qsTr("Вот несколько советов по управлению личными финансами:
                <ul>
                <li><b>Определите цели:</b> Четко определите свои финансовые цели и сроки их достижения.</li>
                <li><b>Создайте бюджет:</b> Ведите учет доходов и расходов, чтобы контролировать свои финансы.</li>
                <li><b>Сокращайте долги:</b> Погашайте высокопроцентные долги как можно быстрее.</li>
                <li><b>Создайте резерв:</b> Иметь финансовую подушку на случай непредвиденных обстоятельств.</li>
                <li><b>Инвестируйте:</b> Рассмотрите возможность инвестирования для увеличения капитала.</li>
                </ul>")
                font.pixelSize: Theme.fontSizeMedium
                color: palette.highlightColor
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
            }
        }
    }
}
