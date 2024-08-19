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
                text: qsTr("Главная")
                onClicked: pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
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
                title: qsTr("Аналитика")
            }

            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Выберите пероид:")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
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

                    property var mindate : dbManager.getMinMaxDates()[0] <=  dbManager.getMinMaxDatesR()[0] ? dbManager.getMinMaxDates()[0] : dbManager.getMinMaxDatesR()[0];
                    text: qsTr(mindate)

                    anchors.verticalCenter: parent.verticalCenter
                    property var selectedDate: mindate;
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
                    property var maxdate: dbManager.getMinMaxDates()[1] >  dbManager.getMinMaxDatesR()[1] ? dbManager.getMinMaxDates()[1] : dbManager.getMinMaxDatesR()[1];

                    text:  qsTr(maxdate)//dbManager.getMinMaxDates()[1];//Qt.formatDate(selectedDate, "yyyy-MM-dd")
                    anchors.verticalCenter: parent.verticalCenter
                    property var selectedDate: maxdate;// dbManager.getMinMaxDates()[1]; //new Date()
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
                text: qsTr("Анализировать")
                enabled: true
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    doanalyze();
                    updateTotalIncomes();
                    updateTotalExpenses();


                }

            }
            Label{
                id: dohodiLabel
                text: qsTr("")
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label{
                id: rashodiLabel
                text: qsTr("")
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label{
                id: analyzeLabel
                text: qsTr("")
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }
    function doanalyze()
    {

        console.log("doanalize()");
        var totalincomes = 0;
        var incomes = dbManager.getIncomes(begindate.text,enddate.text);
        for (var i = 0; i < incomes.length; i++) {
            totalincomes += incomes[i].amount;
        }
        var totalexpenses = 0;
        var expenses = dbManager.getExpenses(begindate.text,enddate.text);
        for (var j = 0; j < expenses.length; j++) {
            totalexpenses += expenses[j].amount;
        }
        var raznica = 0;
        if(totalincomes>totalexpenses)
        {
            raznica = totalincomes - totalexpenses;
            analyzeLabel.text = "Все Отлично\nВаши доходы превышают расходы на " + raznica.toFixed(1);
        }
        else if(totalincomes<totalexpenses)
        {
            raznica = totalexpenses - totalincomes;
            analyzeLabel.text = "Нужно быть экономнее\nВаши расходы превышают\nдоходы на " + raznica.toFixed(1);
        }
        else
        {
             analyzeLabel.text = "Выши доходы равны расходам";
        }

        // This is available in all editors.

    }
   /* function updatefromto(){
        var mindate = dbManager.getMinMaxDates()[0] <=  dbManager.getMinMaxDatesR()[0] ? dbManager.getMinMaxDates()[0] : dbManager.getMinMaxDatesR()[0];
        begindate.text = mindate ;// dbManager.getMinMaxDates()[0];
        begindate.selectedDate  = mindate;// dbManager.getMinMaxDates()[0];
        enddate.text = dbManager.getMinMaxDates()[1];
        enddate.selectedDate = dbManager.getMinMaxDates()[1];
    }
*/


    function updateTotalIncomes(){
        console.log("updatetotalincomes");
        var total = 0;
        var incomes = dbManager.getIncomes(begindate.text,enddate.text);
        for (var i = 0; i < incomes.length; i++) {
            total += incomes[i].amount;
        }
        dohodiLabel.text = "Общая сумма доходов: " + total.toFixed(1); // Отображаем сумму с двумя десятичными знаками
    }
    function updateTotalExpenses(){
        console.log("updatetotalexpenses");
        var total = 0;
        var expenses = dbManager.getExpenses(begindate.text,enddate.text);
        for (var i = 0; i < expenses.length; i++) {
            total += expenses[i].amount;
        }
        rashodiLabel.text = "Общая сумма расходов: " + total.toFixed(1); // Отображаем сумму с двумя десятичными знаками
    }

}
