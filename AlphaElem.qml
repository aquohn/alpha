import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

Item {
    readonly property var innerFlow: alphaFlow
    property var addChild: function(compnt, args) {
        console.log("Not implemented!")
    }

    property int alphaID: 0
    property var alphaCtx: null
    property bool selected: false
    property alias border: elemRect.border
    property var areaElem: elemRect

    height: areaElem.height
    width: areaElem.width

    Rectangle {
        id: elemRect
        color: Style.fgColour
        anchors.fill: alphaFlow
    }

    Flow {
        id: alphaFlow
        width: Utils.calculate_width(this)
        padding: Utils.spacing
        spacing: Utils.spacing
    }

    MouseArea {
        id: elemMouse
        anchors.fill: areaElem
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }

    DropShadow {
        id: elemShadow
        anchors.fill: areaElem
        source: areaElem
        visible: (parent.selected || elemMouse.containsMouse)
        radius: 8.0
        samples: 17
        color: "#80000000"
    }
}
