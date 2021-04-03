import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "tau-prolog.js" as Prolog
import "utils.js" as Utils

Item {
    anchors.fill: parent
    focus: true

    property var modeList: null
    property var stage: null
    property var clipboard: null

    /* State */

    readonly property int modeNavi: 0
    readonly property int modeProof: 1
    readonly property int modeHypo: 2
    property int alphaSelected: 0
    property int alphaClipped: 0

    function select(alpha_id) {
        alphaSelected = alpha_id
        alphaClipped = 0
    }

    function clip() {
        alphaClipped = alphaSelected
        alphaSelected = 0
        /* TODO move tree to clipboard */
    }

    function clear() {
        alphaClipped = 0
        alphaSelected = 0
    }

    /* Key handling logic */

    Keys.onPressed: {
        let currMode = modeList.currentIndex
        let toAccept = true

        if (event.text === 'm') {
            modeList.currentIndex = (currMode + 1) % 3
        } else if (event.text === 'M') {
            modeList.currentIndex = (currMode - 1) % 3
        } else if (currMode === modeProof && alphaSelected !== 0) {
            switch (event.text) {
            case 'd': /* delete (any even level graph; deleted graph may be pasted) */
                break;
            case 'i': /* insert (add arbitrary child within odd level) */
                break
            case 'x': /* cut (can be pasted; sometimes must be pasted) */
                break
            case 'y': /* yank/copy (can only be pasted in nodes descended from parent) */
                break
            case 'C': /* enclose with double cut */
                break
            case 'c': /* remove double cut */
                break
            default:
                toAccept = false
            }
        } else if (currMode === modeHypo && alphaSelected !== 0) {
            switch (event.text) {
            case 'a': /* append proposition within selected node */
                break
            case 'C': /* enclose with cut */
                break
            case 'd': /* delete selection */
                break
            default:
                toAccept = false
            }
        } else {
            toAccept = false
        }

        if (toAccept) {
            event.accepted = true
        }
    }
}
