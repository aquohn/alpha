import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "tau-prolog.js" as Prolog
import "utils.js" as Utils

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Alpha")

    AlphaCtx {
        id: topctx
        modeList: modeList
        stage: stage
        clipboard: clipboard

        Rectangle {
            height: parent.height
            width: 0.3 * parent.width
            color: Style.bgColour
            id: tools

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    color: Style.fgColour
                    border.color: Style.bgColour
                    border.width: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Rectangle {
                        id: rectangle
                        color: Style.bgColour
                        width: parent.width
                        height: 0.1 * parent.height

                        Text {
                            text: "Clipboard"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Style.fgColour
                        }
                    }

                    Flickable {
                        id: clipboard
                        anchors.fill: parent
                    }
                }

                ButtonGroup {
                    id: modeButtons

                }

                ListView {
                    id: modeList
                    model: ["Navigation", "Proof (Manipulate)", "Hypothesis (Insert)"]
                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredHeight: childrenRect.height
                    delegate: RadioDelegate {
                        id: modeDelegate
                        text: modelData
                        checked: index == modeList.currentIndex
                        onCheckedChanged: modeList.currentIndex = index
                        ButtonGroup.group: modeButtons

                        contentItem : Text {
                            rightPadding: modeDelegate.indicator.width + modeDelegate.spacing
                            text: modeDelegate.text
                            font: modeDelegate.font
                            opacity: enabled ? 1.0 : 0.3
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            color : Style.fgColour
                        }
                    }
                }
            }
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: tools.right
            anchors.right: parent.right
            height: parent.height
            width: 0.7 * parent.width
            spacing: 0

            Flickable {
                Layout.fillHeight: true
                Layout.fillWidth: true
                contentWidth: 1.5 * stage.childrenRect.width
                contentHeight: 1.5 * stage.childrenRect.height
                clip: true
                boundsBehavior: Flickable.DragOverBounds

                MouseArea {
                    id: stageMouse
                    anchors.fill: stage
                }

                Flow {
                    id: stage /* root conjunction */

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Utils.calculate_width(this)
                    padding: Utils.spacing
                    spacing: Utils.spacing
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 0.1 * parent.height
                color: Style.fgColour
                border.color: Style.bgColour
                border.width: 1
                Layout.alignment: Qt.Align | Qt.AlignBottom

                TextInput {
                    padding: Utils.spacing / 2
                    anchors.fill: parent
                    id: user_input
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    cursorShape: Qt.IBeamCursor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 0.1 * parent.height
                color: Style.bgColour

                Text {

                    readonly property var hints: [
                        "Click and drag to move around the propositions.",
                        "d: delete (even level), i: insert proposition (odd level), x: cut, "
                        + "y: yank/copy, C: insert double cut, c: remove double cut.",
                        "a: append proposition (anywhere), d: delete (anywhere), C: insert cut"
                    ]

                    padding: Utils.spacing / 2
                    anchors.fill: parent
                    text: hints[modeList.currentIndex]
                    color: Style.fgColour
                    wrapMode: Text.WordWrap
                }
            }

        }

        Popup {
            id: propname_prompt
            padding: 10
            anchors.centerIn: Overlay.overlay
            width: 0.5 * window.width
            height: 0.3 * window.width

            contentItem: Column {
                spacing: 5
                padding: 5

                Text {
                    text: "Enter the name for the new proposition:"
                }

                Rectangle {
                    height: 32
                    color: Style.fgColour
                    border.color: Style.bgColour
                    border.width: 1

                    TextInput {
                        anchors.fill: parent
                        id: propname_input
                    }
                }

                Button {
                    text: "Done"
                    /* TODO send propname_input */
                }
            }
        }
    }
}
