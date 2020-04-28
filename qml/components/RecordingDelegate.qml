import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    menu: ContextMenu {

        MenuItem {
            text: qsTr("Rename")
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/RenameDialog.qml"), {
                                          fileName: fileName,
                                          fileDir: fileDir
                                      })
        }

        MenuItem {
            text: qsTr("Delete")
            onClicked: {
                remorseAction(qsTr("Deleting"), function() {
                    recorder.removeFile(filePath)
                })
            }
        }

        MenuItem {
            text: qsTr("Share")
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/Share.qml"), {
                                          title: fileName,
                                          path: filePath,
                                          filter: mimeType
                                      })
        }
    }

    ListView.onRemove: animateRemoval()

    onClicked: player.play(filePath)

    Label {
        id: filenameLabel
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }
        text: fileName
        anchors.verticalCenter: parent.verticalCenter
        color: parent.highlighted ? Theme.highlightColor : Theme.primaryColor
    }
}
