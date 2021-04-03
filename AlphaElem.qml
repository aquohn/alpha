import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "utils.js" as Utils

Flow {
    id: elem

    property int alphaID: 0
    property var alphaCtx: null

    padding: Utils.spacing
    spacing: Utils.spacing

    layer.enabled: true
    layer.effect: AlphaLayer {
        elem: elem
    }
}
