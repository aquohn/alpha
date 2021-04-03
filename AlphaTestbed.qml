import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

Rectangle {
    id: inrect
    border.width: 1
    color: Style.fgColour
    height: childrenRect.height
    width: childrenRect.width
    layer.enabled: true
    layer.effect: DropShadow {
        source: inrect
        radius: outmouse.containsMouse ? 8.0 : 0
        samples: 17
        color: "#80000000"
    }

    MouseArea {
        id: outmouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }

    Flow {
        width: Utils.calculate_width(this)
        padding: Utils.spacing
        spacing: Utils.spacing

        Rectangle {
            border.width: 1
            height: childrenRect.height
            width: childrenRect.width

            DropShadow {
                anchors.fill: parent
                source: parent
                radius: 8.0
                samples: 17
                color: "#80000000"
                visible: inmouse.containsMouse
            }

            MouseArea {
                id: inmouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.NoButton
                cursorShape: Qt.PointingHandCursor
                preventStealing: true
            }

            Flow {
                width: Utils.calculate_width(this)
                padding: Utils.spacing
                spacing: Utils.spacing

                Text {
                    text: "proposition inner"
                }

                Text {
                    text: "qroqosition inner"
                }
            }
        }


        Text {
            text: "proposition"
        }

        Text {
            text: "qroqosition"
        }
    }
}

Text {
    text: "proposition 1"
}

Rectangle {
    id: prop2_rect
    color: Style.fgColour
    height: childrenRect.height
    width: childrenRect.width
    layer.enabled: true
    layer.effect: DropShadow {
        source: prop2_rect
        radius: prop2_mouse.containsMouse ? 8.0 : 0
        samples: 17
        color: "#80000000"
    }

    Text {
        text: "proposition 2"
        padding: 5
    }

    MouseArea {
        id: prop2_mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }
}


