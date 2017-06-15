import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    onAccepted: {
        if (!recorder.migrate()) {
            notification.show(qsTr("Migration failed, old recordings should still be in the old folder."))
        } else {
            notification.show(qsTr("Migration finished"))
        }
    }

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Migration")
        }

        Label {
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }
            text: qsTr("The default folder has changed from \"%0\" to \"%1\". Do you want to move existing recordings to the new folder? If you cancel the old directory will be kept.")
                    .arg("~/Recordings/").arg("~/Documents/Recordings/")
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
        }
    }
}
