import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.recorder 1.0

Page {
    property string location

    Component.onCompleted: {
        directoryModel.location = location
    }

    DirectoryModel {
        id: directoryModel
    }

    SilicaListView {
        anchors.fill: parent

        header: PageHeader {
            title: {
                if (location === recorder.sdCardPath) {
                    qsTr("SD Card")
                } else if (location === StandardPaths.home) {
                    qsTr("Home")
                } else {
                    var l = location.split("/")
                    l[l.length - 1]
                }
            }
        }

        model: directoryModel

        delegate: ListItem {
            onClicked: pageStack.push(Qt.resolvedUrl("LocationPage.qml"),
                                      { location: directoryModel.location + "/" + display })
            menu: ContextMenu {
                    MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        remorseAction(qsTr("Deleting"), function() {
                            directoryModel.removeDir(display)
                        })
                    }
                }
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
                width: parent.width - Theme.horizontalPageMargin * 2
                spacing: Theme.paddingMedium

                Image {
                    source: "image://theme/icon-m-folder?" +
                            (pressed ? Theme.highlightColor : Theme.primaryColor)
                }

                Label {
                    height: parent.height
                    text: display
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }

        PullDownMenu {

            MenuItem {
                visible: recorder.location !== location
                text: qsTr("Current location")
                onClicked: settingsPage.openFileBrowser(recorder.location)
            }

            MenuItem {
                readonly property bool usingSdCard: location.search(recorder.sdCardPath) === 0

                visible: recorder.sdCardPath
                text: usingSdCard ? qsTr("Home") : qsTr("SD Card")
                onClicked: settingsPage.openFileBrowser(
                               usingSdCard ? StandardPaths.home : recorder.sdCardPath)
            }

            MenuItem {
                text: qsTr("New directory")
                onClicked: {
                    var d = pageStack.push(Qt.resolvedUrl("NewDirectoryPage.qml"),
                                           { directoryModel: directoryModel })
                    d.accepted.connect(function() {
                        directoryModel.newDir(d.dirName)
                    })
                }
            }

            MenuItem {
                text: qsTr("Apply")
                onClicked: {
                    recorder.location = location
                    pageStack.pop(settingsPage)
                }
            }
        }

        VerticalScrollDecorator { }
    }
}
