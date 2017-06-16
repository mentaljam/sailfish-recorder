import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string fileName
    readonly property string baseName: fileName.split(".")[0]

    canAccept: newFilename.text

    onAccepted: recorder.renameFile(fileName, newFilename.text +
                                    fileName.substring(baseName.length))

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
            text: baseName

            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: accept()
        }

        ViewPlaceholder {
            enabled: !canAccept
            text: qsTr("A file name must be specified")
        }
    }
}
