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



    SilicaListView {
        id: recordingsList
        width: parent.width
        height: parent.height
        model: recordingsModel

        header: PageHeader { title: "Recordings" }
        footer: Item { height: 150 }

        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: "Test Banner"
                onClicked: banner.notify("Hello World");
            }
            MenuItem {
                text: "Add Items"
                onClicked: {
                    for (var index = 0; index < 5; index++) {
                        recordingsModel.append({"text": "Recording " + index});
                    }
                }
            }
        }

        delegate: ListItem {
            id: listItem
            menu: contextMenuComponent
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
                    MenuItem {
                        text: "Second option"
                    }
                }
            }
        }

        DockedPanel {
            id: bottomPanel
            width: page.width
            y: -150
            height: 150
            dock: Dock.Bottom
            open: true


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

    ListModel {
        id: recordingsModel
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    /*

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: "Test Banner"
                onClicked: banner.notify("Hello World");
            }
            MenuItem {
                text: "Add Items"
                onClicked: {
                    for (var index = 0; index < 5; index++) {
                        recordingsModel.append({"text": "Recording " + index});
                    }
                }
            }
        }

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "Audio Recorder"
            }

            Row {
                id: buttons
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    icon.source: "../icons/stop.png"
                    enabled: recorder.recordingState === 1 || recorder.recordingState === 2
                    onClicked: {
                        recorder.stopRecording();
                        timer.stop();
                        time = 0;
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
            }

            Label {
                id: recordTxt
                x: Theme.paddingLarge
                width: parent.width - (Theme.paddingLarge*2)
                horizontalAlignment: Text.AlignHCenter
                text: timestamp
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
                font.family: "monospace"
            }
        }

        SilicaListView {
            id: recordingsList
            width: parent.width
            height: contentHeight
            model: recordingsModel
            delegate: ListItem {
                id: listItem
                menu: contextMenuComponent
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
                        MenuItem {
                            text: "Second option"
                        }
                    }
                }
            }
        }

        ListModel {
            id: recordingsModel
        }
    }

    */
}


