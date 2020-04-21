/*
    A simple audio recording tool.
    Copyright (C) 2014  Corné Dorrestijn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.recorder 1.0
import "../components"


Page {
    id: page
    allowedOrientations: Orientation.All

    RecordingPlayer {
        id: player
    }

    InfoLabel {
        id: statusLabel
        y: (recordingsList.height - height) / 2
        opacity: 0.0
    }

    SilicaListView {
        id: recordingsList
        anchors {
            left: parent.left
            top: player.bottom
            right: parent.right
            bottom: controls.top
            bottomMargin: Theme.paddingLarge
        }
        enabled: opacity > 0.0
        currentIndex: -1
        clip: true
        model: recordingsModel
        header: PageHeader { title: qsTr("Recordings") }        
        delegate: RecordingDelegate { }

        section {
            property: "section"
            delegate: SectionHeader {
                text: section
            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
        }

        ViewPlaceholder {
            enabled: !recordingsList.count
            text: qsTr("Your recordings will be shown here")
        }

        VerticalScrollDecorator { }
    }

    Item {
        id: controls
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
            margins: Theme.paddingLarge
        }
        height: buttons.height

        Row {
            id: buttons
            width: parent.width
            spacing: Theme.paddingLarge

            IconButton {
                id: stopBtn
                icon.source: "../icons/stop.png"
                enabled: recorder.state !== Recorder.StoppedState
                onClicked: recorder.stop()
            }

            IconButton {
                icon.source: "../icons/record.png"
                enabled: recorder.state !== Recorder.RecordingState
                onClicked: {
                    switch (recorder.state) {
                    case Recorder.StoppedState:
                        recorder.startRecording()
                        break
                    case Recorder.PausedState:
                        recorder.record()
                        break
                    default:
                        break
                    }
                }
            }

            IconButton {
                icon.source: "../icons/pause.png"
                enabled: recorder.state === Recorder.RecordingState
                onClicked: recorder.pause()
            }

            Label {
                height: parent.height
                width: buttons.width - (stopBtn.width + Theme.paddingLarge) * 3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: recorder.state === Recorder.StoppedState ? "00:00:00" : recorder.durationLabel
                color: Theme.secondaryHighlightColor
                font.family: "monospace"
            }
        }
    }

    states: [
        State { name: "stopped";   when: recorder.state === Recorder.StoppedState   },
        State { name: "recording"; when: recorder.state === Recorder.RecordingState },
        State { name: "paused";    when: recorder.state === Recorder.PausedState    }
    ]

    transitions: [

        Transition {
            to: "stopped"
            SequentialAnimation {
                PropertyAnimation { target: statusLabel; property: "opacity"; duration: 150; to: 0.0 }
                PropertyAnimation { target: recordingsList; property: "opacity"; duration: 150; to: 1.0 }
            }
        },

        Transition {
            to: "recording"
            SequentialAnimation {
                PropertyAction { target: recordingsList; property: "opacity"; value: 0.0 }
                PropertyAnimation { target: statusLabel; property: "opacity"; duration: 150; to: 0.0 }
                PropertyAction { target: statusLabel; property: "text"; value: qsTr("Recording...") }
                PropertyAnimation { target: statusLabel; property: "opacity"; duration: 150; to: 1.0 }
            }
        },

        Transition {
            to: "paused"
            SequentialAnimation {
                PropertyAction { target: recordingsList; property: "opacity"; value: 0.0 }
                PropertyAnimation { target: statusLabel; property: "opacity"; duration: 150; to: 0.0 }
                PropertyAction { target: statusLabel; property: "text"; value: qsTr("Paused") }
                PropertyAnimation { target: statusLabel; property: "opacity"; duration: 150; to: 1.0 }
            }
        }
    ]
}
