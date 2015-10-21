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
import "../util"


Page {
    id: page
    allowedOrientations: Orientation.All

    Popup {
        id: banner
    }

    Audio {
        id: audio
        autoLoad: false
        onStopped: musicPlayer.hide();
    }

    Timer {
        id: migrateTimer
        interval: 1000;
        running: false;
        repeat: false;
        onTriggered: {
            pageStack.push(migrationWizard);
        }
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

            if (recorder.shouldMigrate()) {
                migrateTimer.start();
            }
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
                    id: filenameLabel
                    x: Theme.horizontalPageMargin
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
                        MenuItem {
                            text: "Rename"
                            onClicked: pageStack.push(renameDialog)
                        }
                    }
                }

                Component {
                    id: renameDialog
                    Dialog {
                        width: page.width
                        canAccept: true

                        onAcceptPendingChanged: {
                            if(acceptPending) {
                                recorder.renameFile(model.text, newFilename.text);
                                drawer.refreshRecordingsList();
                            }
                        }

                        Column {
                            width: parent.width - Theme.paddingLarge * 2
                            x: Theme.paddingLarge
                            PageHeader {
                                title: "Rename File"
                            }
                            TextField {
                                width: parent.width
                                id: newFilename
                                label: "New filename"
                                text: model.text
                            }
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

    Component {
        id: migrationWizard

        Dialog {
            Column {
                width: parent.width

                DialogHeader {
                    title: "Migration"
                }

                Label {
                    text: 'The default folder has changed from "~/Recordings/" ' +
                          'to "~/Documents/Recordings/". Do you want to move existing ' +
                          'recordings to the new folder? If you cancel the old directory will be kept.';
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.WordWrap
                    width: parent.width - Theme.horizontalPageMargin * 2
                    x: Theme.horizontalPageMargin
                }
            }

            onAccepted: {
                if (!recorder.migrate()) {
                    banner.notify("Migration failed, old recordings should still be in the old folder.");
                } else {
                    banner.notify("Migration.")
                    drawer.refreshRecordingsList();
                }
            }
        }
    }
}
