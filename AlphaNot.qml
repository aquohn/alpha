import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

AlphaElem {
    id: notElem
    layer.effect: AlphaLayer {
        elem: notElem
        border.width: 1
    }
}
