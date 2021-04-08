import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "tau-prolog.js" as Prolog
import "utils.js" as Utils

Item {
    id: alphaCtx
    anchors.fill: parent

    /* external elements */

    property var modeList: null
    property var stage: null
    property var clipboard: null
    property var hintText: null
    property var alphaEngine: null

    /* state */

    readonly property int modeNavi: 0
    readonly property int modeProof: 1
    readonly property int modeHypo: 2
    property int currMode: modeList.currentIndex
    property var alphaSelected: null
    property var alphaClipped: null

    function clicked(alphaElem) {
        if (currMode === modeNavi) {
            return
        } else if (alphaClipped !== null) {
            paste(alphaElem, alphaClipped)
        } else if (alphaSelected === null) {
            select(alphaElem)
        } else {
            console.log("Click ignored!")
        }
    }

    function select(alphaElem) {
        if (alphaElem.alphaId === 1) { /* root conjunction selected */
            if (currMode === modeHypo) {
                propPrompt.open()
            } else {
                clear()
            }
            return
        }

        alphaSelected.selected = false
        alphaSelected = alphaElem
        alphaElem.selected = true
        alphaClipped = null
    }

    function paste(target, content) {
        /* TODO */
    }

    function clip() {
        alphaClipped = alphaSelected
        alphaSelected = null
        hintText.special = "Click on an element to paste the clipboard contents there"
        /* TODO move tree to clipboard */
    }

    function clear() {
        alphaClipped = null /* TODO prevent accidental deletion */
        if (alphaSelected != null) {
            alphaSelected.selected = false
        }
        alphaSelected = null
        hintText.special = null
        alphaCtx.focus = true
    }

    /* Key handling logic */

    Keys.onPressed: {
        let numModes = 3
        let toAccept = true

        if (event.key === Qt.Key_Escape) {
            clear()
        } else if (event.text === 'm') {
            modeList.currentIndex = (currMode + 1) % numModes
        } else if (event.text === 'M') {
            let temp = currMode - 1;
            if (temp < 0) {
                temp += numModes
            }
            modeList.currentIndex = temp % numModes
        } else if (event.text === 'z') {
            if (stage.scale > 0.2) {
                stage.scale -= 0.2
            }
        } else if (event.text === 'Z') {
            stage.scale += 0.2
        } else if (currMode === modeProof && alphaSelected !== null) {
            switch (event.text) {
            case 'i': /* insert (add arbitrary child within odd level) */
                break
            case 'd': /* delete (any even level graph; do not put in clipboard) */
                break;
            case 'y': /* yank/copy (can only be pasted in nodes descended from parent) */
                break
            case 'x': /* cut (can be pasted; sometimes must be pasted) */
                break
            case 'C': /* enclose with double cut */
                break
            case 'c': /* remove double cut */
                break
            default:
                toAccept = false
            }
        } else if (currMode === modeHypo && alphaSelected !== null) {
            switch (event.text) {
            case 'i': /* insert node at selection */
                break
            case 'd': /* delete selection */
                break
            case 'C': /* enclose with cut */
                break
            case 'c': /* remove enclosing cut */
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

    Popup {
        id: propPrompt
        padding: Utils.spacing
        anchors.centerIn: Overlay.overlay
        width: 0.5 * window.width

        function sendInput(input) {
            /* TODO validate and send input */
        }

        contentItem: ColumnLayout {
            spacing: Utils.spacing

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: "Enter the name for the new proposition (leave blank for cut):"
            }

            Rectangle {
                Layout.fillWidth: true
                color: Style.fgColour
                border.color: Style.bgColour
                border.width: 1
                height: propInput.contentHeight + Utils.spacing

                TextInput {
                    id: propInput
                    anchors.fill: parent
                    padding: Utils.spacing / 2
                    clip: true
                    onAccepted: propPrompt.sendInput(propInput.text)
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    cursorShape: Qt.IBeamCursor
                }
            }

            Text {
                id: promptError
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: "red"
                text: ""
                visible: (text !== "")
            }

            Button {
                Layout.alignment: Qt.AlignHCenter
                text: "Done"
                onClicked: propPrompt.sendInput(propInput.text)
            }
        }
    }
}
