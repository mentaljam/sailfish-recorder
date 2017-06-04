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

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: {
            switch (recorder.recordingState) {
            case 0:
                return qsTr("Record")
            case 1:
                return qsTr("Stop")
            case 2:
                return qsTr("Resume")
            default:
                return ""
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: recorder.recordingState === 1 ? "image://theme/icon-cover-cancel" : "image://theme/icon-cover-new"
            onTriggered: {
                switch (recorder.recordingState) {
                case 0:
                    var msg = recorder.startRecording();
                    if(msg === "recording") {
                        timestamp = "0:00"
                        timer.start()
                    }
                    break
                case 1:
                    recorder.stopRecording()
                    timer.stop()
                    time = 0
                    break
                case 2:
                    recorder.resumeRecording()
                    timer.start()
                    break
                default:
                    break
                }
            }
        }
    }
}


