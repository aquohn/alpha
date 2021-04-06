import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

AlphaElem {
    addChild: function(compnt, args) {
        compnt.createObject(innerFlow, args)
    }
}
