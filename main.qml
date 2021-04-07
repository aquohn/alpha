import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "tau-prolog.js" as Prolog
import "utils.js" as Utils

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("Alpha")

    AlphaCtx {
        id: topctx
        modeList: modeList
        stage: stage
        clipboard: clipboard
        hintText: hintText
        focus: true

        MouseArea {
            anchors.fill: parent
            onClicked: focus = true
        }

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
                            font.pointSize: Style.fontBig
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Style.fgColour
                        }
                    }

                    Flickable {
                        id: clipboard
                        anchors.fill: parent

                        MouseArea {
                            parent: clipboard
                            anchors.fill: parent
                            propagateComposedEvents: true
                            onClicked: {
                                focus = true
                                mouse.accepted = false
                            }
                        }
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
                    currentIndex: 0

                    delegate: RadioDelegate {
                        property int selected: 0
                        id: modeDelegate
                        text: modelData
                        checked: index == selected
                        onCheckedChanged: if (checked) {
                                      selected = index
                                  }
                        ButtonGroup.group: modeButtons
                        font.pointSize: Style.fontMed

                        contentItem : Text {
                            rightPadding: modeDelegate.indicator.width + modeDelegate.spacing
                            text: modeDelegate.text
                            font: modeDelegate.font
                            opacity: enabled ? 1.0 : 0.3
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            color : Style.fgColour
                        }

                        Binding {
                            target: modeList
                            property: "currentIndex"
                            value: modeDelegate.selected
                        }

                        Binding {
                            target: modeDelegate
                            property: "selected"
                            value: modeList.currentIndex
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

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Flickable {
                    id: stageFlickable
                    anchors.fill: parent
                    contentWidth: 1.5 * stage.width
                    contentHeight: 1.5 * stage.height
                    clip: true
                    boundsBehavior: Flickable.DragOverBounds

                    MouseArea {
                        parent: stageFlickable /* will not be part of content being flicked */
                        id: stageMouse
                        anchors.fill: parent
                        propagateComposedEvents: true
                        onClicked: {
                            focus = true
                            topctx.clicked(stage)
                            mouse.accepted = false
                        }
                    }

                    Flow {
                        id: stage /* root conjunction */
                        readonly property int alphaId: 1
                        property var addChild: function(compnt, args) {
                            compnt.createObject(stage, args)
                        }

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: Utils.calculate_width(this)
                        padding: Utils.spacing
                        spacing: Utils.spacing


                        Rectangle {
                            id: inrect
                            border.width: 1
                            color: Style.fgColour
                            height: childrenRect.height
                            width: childrenRect.width
                            layer.enabled: true
                            layer.effect: DropShadow {
                                source: inrect
                                radius: outmouse.containsMouse ? 8.0 : 0
                                samples: 17
                                color: "#80000000"
                            }

                            MouseArea {
                                id: outmouse
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.NoButton
                                cursorShape: Qt.PointingHandCursor
                                preventStealing: true
                            }

                            Flow {
                                width: Utils.calculate_width(this)
                                padding: Utils.spacing
                                spacing: Utils.spacing

                            }
                        }

                        Text {
                            text: "proposition 1"
                        }

                        Rectangle {
                            id: prop2_rect
                            color: Style.fgColour
                            height: childrenRect.height
                            width: childrenRect.width
                            layer.enabled: true
                            layer.effect: DropShadow {
                                source: prop2_rect
                                radius: prop2_mouse.containsMouse ? 8.0 : 0
                                samples: 17
                                color: "#80000000"
                            }

                            Text {
                                text: "proposition 2"
                                padding: 5
                            }

                            MouseArea {
                                id: prop2_mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.NoButton
                                cursorShape: Qt.PointingHandCursor
                                preventStealing: true
                            }
                        }
                    }

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
                    id: hintText
                    readonly property var hints: [
                        "Click and drag to move the propositions around. ",

                        "Click elements to select them and use keys to perform actions. d: delete (even level), "
                        + "i: insert proposition (odd level), x: cut, "
                        + "y: yank/copy, C: insert double cut, c: remove double cut. ",

                        "Click elements to select them and use keys to perform actions. "
                        + "Click on stage to create top-level propositions. "
                        + "a: append proposition, d: delete, C: insert cut around. "
                    ]
                    readonly property string epilogue: "M/m: toggle modes, Z/z: zoom in/out."
                    property var special: null

                    padding: Utils.spacing / 2
                    anchors.fill: parent
                    text: (special === null) ? hints[modeList.currentIndex] + epilogue : special
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
                    text: "Enter the name for the new proposition (leave blank for cut):"
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
