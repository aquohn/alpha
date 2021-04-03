import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

Rectangle {
    property var elem: null

    color: Style.fgColour
    height: childrenRect.height
    width: childrenRect.width

    MouseArea {
        id: elemMouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }

    DropShadow {
        source: elem
        // TODO change to allow permanent highlight when selected
        radius: elemMouse.containsMouse ? 8.0 : 0
        samples: 17
        color: "#80000000"
    }
}
