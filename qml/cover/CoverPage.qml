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
import harbour.recorder.Recorder 1.0

CoverBackground {

    Column {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        spacing: Theme.paddingLarge

        Label {
            width: parent.width
            font.pixelSize: Theme.fontSizeLarge
            text: {
                switch (recorder.state) {
                case Recorder.StoppedState:
                    return qsTr("Record")
                case Recorder.RecordingState:
                    return qsTr("Recording...")
                case Recorder.PausedState:
                    return qsTr("Paused")
                default:
                    return ""
                }
            }
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            text: recorder.state === Recorder.StoppedState ?
                      "" : recorder.durationLabel
            horizontalAlignment: Qt.AlignHCenter
        }
    }

    Loader {
        id: actionLoader
        sourceComponent: recorder.state === Recorder.StoppedState ?
                             stoppedComponent : startedComponent

        Component {
            id: stoppedComponent

            CoverActionList {
                CoverAction {
                    iconSource: "image://theme/icon-cover-new"
                    onTriggered: recorder.startRecording()
                }
            }
        }

        Component {
            id: startedComponent

            CoverActionList {

                CoverAction {
                    iconSource: "image://theme/icon-cover-cancel"
                    onTriggered: recorder.stop()
                }

                CoverAction {
                    iconSource: recorder.state === Recorder.RecordingState ?
                                    "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
                    onTriggered: recorder.state === Recorder.RecordingState ?
                                     recorder.pause() : recorder.record()
                }
            }
        }
    }
}
