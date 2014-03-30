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
import QtMultimedia 5.0


Page {
    id: page

    Audio {
        id: audio
        autoLoad: false
        onStopped: musicPlayer.hide();
    }


    Drawer {
        id: drawer
        function refreshRecordingsList() {
            var list = recorder.getExistingFiles();
            recordingsModel.clear();
            for(var i = 0; i < list.length; i++) {
                recordingsModel.append({"text": list[i]});

            }
        }

        Component.onCompleted: {
            refreshRecordingsList();
        }

        anchors.fill: parent;
        open: true
        backgroundSize: parent.height - 150

        background: SilicaListView {
            id: recordingsList
            width: parent.width
            height: parent.height
            model: recordingsModel

            header: PageHeader { title: "Recordings" }

            DockedPanel {
                id: musicPlayer
                height: 150
                width: parent.width
                dock: Dock.Top
                Flow {
                    anchors.centerIn: parent
                    IconButton {
                        icon.source: "../icons/stop.png"
                        onClicked: {
                            audio.stop();
                        }
                    }
                    Label {
                        x: Theme.paddingLarge
                        width: 150
                        height: stopBtn.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: {
                            var time = audio.position / 1000
                            var minutes = Math.floor(time/60);
                            var seconds = Math.ceil(time - minutes * 60);
                            return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)

                        }
                        font.family: "monospace"
                    }
                }
            }

            PullDownMenu {
                MenuItem {
                    text: "Settings"
                    onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
                }
                MenuItem {
                    text: "Refresh"
                    onClicked: {
                        banner.notify("Refreshing");
                        drawer.refreshRecordingsList();
                    }
                }
            }

            ListModel {
                id: recordingsModel
            }


            delegate: ListItem {
                id: listItem
                menu: contextMenuComponent
                onClicked: {
                    audio.source = recorder.getLocation() + "/" + model.text;
                    audio.play();
                    musicPlayer.show();
                }

                function remove() {
                    remorseAction("Deleting", function() {
                        recorder.removeFile(model.text)
                        recordingsModel.remove(index)
                    })

                }
                ListView.onRemove: animateRemoval()

                Label {
                    x: Theme.paddingLarge
                    text: model.text
                    anchors.verticalCenter: parent.verticalCenter
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Component {
                    id: contextMenuComponent
                    ContextMenu {
                        MenuItem {
                            text: "Delete"
                            onClicked: remove()
                        }
                    }
                }
            }
        }
        SilicaFlickable {
            width: page.width
            height: 150

            Row {
                id: buttons
                spacing: Theme.paddingLarge
                anchors.centerIn: parent
                IconButton {
                    id: stopBtn
                    icon.source: "../icons/stop.png"
                    enabled: recorder.recordingState === 1 || recorder.recordingState === 2
                    onClicked: {
                        recorder.stopRecording();
                        timer.stop();
                        time = 0;
                        drawer.refreshRecordingsList();
                    }
                }
                IconButton {
                    icon.source: "../icons/record.png"
                    enabled: recorder.recordingState === 0 || recorder.recordingState === 2
                    onClicked: {
                        if(recorder.recordingState === 0) {
                            var msg = recorder.startRecording();
                            if(msg === "recording") {
                                timestamp = "0:00";
                                timer.start();
                            } else if(msg === "nofolder") {
                                banner.notify("Couldn't create file in \"" + recorder.getLocation() + "\"");
                            }
                        } else if(recorder.recordingState === 2) {
                            recorder.resumeRecording();
                            timer.start();
                        }
                    }
                }
                IconButton {
                    icon.source: "../icons/pause.png"
                    enabled: recorder.recordingState === 1
                    onClicked: {
                        recorder.pauseRecording();
                        timer.stop();
                    }
                }
                Label {
                    id: recordTxt
                    x: Theme.paddingLarge
                    width: 150
                    height: stopBtn.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: timestamp
                    color: Theme.secondaryHighlightColor
                    font.family: "monospace"
                }
            }
        }
    }
}
