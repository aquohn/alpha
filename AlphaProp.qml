import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

AlphaElem {
    areaElem: propName

    property alias text: propName.text
    addChild: function(compnt, args) {
        console.log("Cannot add child to proposition!")
    }

    Text {
        id: propName
        text: ""
        padding: Utils.spacing / 2
    }
}
