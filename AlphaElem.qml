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

    property int alphaId: 0
    property var alphaCtx: null
    property bool selected: false
    property alias border: elemRect.border
    property var areaElem: elemRect

    id: thisElem
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
        cursorShape: (alphaCtx.currMode === alphaCtx.modeNavi) ? Qt.ArrowCursor : Qt.PointingHandCursor
        preventStealing: (alphaCtx.currMode === alphaCtx.modeNavi)
        onClicked: alphaCtx.clicked(thisElem)
    }

    DropShadow {
        id: elemShadow
        anchors.fill: areaElem
        source: areaElem
        visible: (parent.selected || elemMouse.containsMouse)
        radius: 5.0
        samples: 15
        opacity: (alphaCtx.currMode === alphaCtx.modeNavi) ? 0.0 : 0.8
        color: (alphaCtx.alphaClipped === null) ? "lightsteelblue" : "lightgreen"
    }
}
