import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "aboutPage"
    allowedOrientations: Orientation.All


    SilicaFlickable {
        VerticalScrollDecorator{}
        objectName: "flickable"
        anchors.fill: parent
        contentHeight: layout.height + Theme.paddingLarge

        id: aboutPage

        PullDownMenu{
            backgroundColor: "white"
            highlightColor: backgroundColor
            //quickSelect: true
            MenuItem{
                //height: 100
                horizontalAlignment:     Text.AlignHCenter
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
                text: qsTr("Советы")
                onClicked: pageStack.push(Qt.resolvedUrl("Advice.qml"))

            }



        }


        Column {

            id: layout
            objectName: "layout"
            width: parent.width
            spacing: Theme.paddingSmall
            PageHeader {

                objectName: "pageHeader"
                title: qsTr("О приложении")

            }

            Label {

                objectName: "descriptionText"
                anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
                color: palette.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                text: qsTr("Мобильное приложение предназначено для учёта личных финансов, контроля расходов и доходов, а также планирования целей.")
            }

            SectionHeader {
                objectName: "licenseHeader"
                text: qsTr("Лицензия 3-Clause BSD")
            }

            Label {
                objectName: "licenseText"
                anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
                color: palette.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                text: qsTr("<b>Copyright (C) 2022 ru.auroraos</b>

                <p>Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:</p>
                <ol>
                <li>Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</li>
                <li>Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.</li>
                <li>Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.</li>
                </ol>
                <p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>")
            }
        }
    }

}
