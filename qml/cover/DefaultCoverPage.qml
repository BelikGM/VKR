import QtQuick 2.0
import Sailfish.Silica 1.0

Cover {
    objectName: "defaultCover"

    CoverTemplate {

        objectName: "placeholder"
        anchors.centerIn: parent
        id: cov
        Image {
            id: pic
            source: Qt.resolvedUrl("MoiFinansi.png")
            sourceSize.width: parent.width
            sourceSize.height: parent.height

            anchors.fill: { bottom:act.top}
            transform: [
                Scale { xScale: 1; yScale: 1 },
                Rotation {
                    id: rotation
                    axis.x: 1; axis.y: 1; axis.z: 1
                    angle: 0
                    origin.x: width/2; origin.y: height/2
                },
                Translate { x: 0; y: 0 }
            ]
        }
        Timer {
            running: true
            interval: 1; repeat: true
            onTriggered: rotation.angle += 1
        }


        CoverActionList {
            id: act
            CoverAction {
                iconSource: "image://theme/icon-cover-previous"
                onTriggered: rotation.angle -= 30
            }

            CoverAction {
                iconSource: "image://theme/icon-cover-next"
                onTriggered: rotation.angle += 30
            }

        }
        /*
            Text {

            id: txt
            text: qsTr("Открыть")
            anchors.bottom:  act.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: palette.highlightColor
            font.pointSize: 48
            textFormat: Text.RichText
            wrapMode: Text.WordWrap

            
        } */
    }

}
