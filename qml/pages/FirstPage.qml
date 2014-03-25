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


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PullDownMenu {
                MenuItem {
                    text: "Settings"
                    onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
                }
            }

            PageHeader {
                title: "Audio Recorder"
            }
            Item {
                height: 172
                width: parent.width
                Image {
                    id: recordBtn
                    anchors.centerIn: parent
                    height: 172
                    width: 172
                    source: "../record.png"
                    opacity: region.pressed ? 0.7 : 1
                }
                Timer {
                    id: timer
                    interval: 1000;
                    running: false;
                    repeat: true;
                    onTriggered: {
                        time++;
                        var minutes = Math.floor(time/60);
                        var seconds = time - minutes * 60;
                        recordTxt.text = minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
                    }
                }

                MouseArea {
                    id: region
                    anchors.fill: parent
                    onClicked: {
                        if(recorder.isRecording) {
                            recordBtn.source = "../record.png"
                            recorder.stopRecording();
                            timer.stop();
                            time = 0;
                        } else {
                            var msg = recorder.startRecording();
                            if(msg === "recording") {
                                errorTxt.text = "";
                                recordBtn.source = "../stop.png"
                                recordTxt.text = "0:00"
                                timer.start();
                            } else if(msg === "nofolder") {
                                errorTxt.text = "Couldn't create \"" + recorder.getLocation() + "\"";
                            }
                        }
                    }
                }
            }

            Label {
                id: recordTxt
                x: Theme.paddingLarge
                width: parent.width - (Theme.paddingLarge*2)
                horizontalAlignment: Text.AlignHCenter
                text: "Start Recording"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
                font.family: "monospace"
            }

            Label {
                id: errorTxt
                x: Theme.paddingLarge
                width: parent.width - (Theme.paddingLarge*2)
                wrapMode: Text.WordWrap;
                text: "";
                color: Theme.highlightColor
            }
        }
    }
}


