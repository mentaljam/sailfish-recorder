import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string fileName

    canAccept: newFilename.text

    onAcceptPendingChanged: {
        if (acceptPending) {
            recorder.renameFile(fileName, newFilename.text)
        }
    }

    Component.onCompleted: newFilename.forceActiveFocus()

    Column {
        width: parent.width

        PageHeader {
            title: qsTr("Rename File")
        }

        TextField {
            id: newFilename
            width: parent.width
            label: qsTr("New filename")
            placeholderText: label
            text: fileName

            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: accept()
        }
    }
}
