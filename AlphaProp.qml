import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

AlphaElem {
    property alias text: propName.text

    Text {
        id: propName
        property int alphaID: 0
        property var alphaCtx: null
        text: ""
        padding: Utils.spacing / 2
    }
}
