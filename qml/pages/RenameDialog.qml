import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string fileName
    property string fileDir

    readonly property string _baseName: fileName.split(".")[0]
    readonly property string _extension: fileName.substring(_baseName.length)
    readonly property string _newFilePath: fileDir + "/" + fileNameField.text + _extension

    canAccept: !viewPlaceholder.enabled

    onAccepted: recorder.renameFile(fileDir + "/" + fileName, _newFilePath)

    Component.onCompleted: fileNameField.forceActiveFocus()

    Column {
        width: parent.width

        DialogHeader {
            acceptText: qsTr("Rename")
        }

        TextField {
            id: fileNameField
            width: parent.width
            label: qsTr("New filename")
            placeholderText: label
            errorHighlight: viewPlaceholder.enabled
            text: _baseName

            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: accept()
        }

        ViewPlaceholder {
            id: viewPlaceholder
            enabled: text
            text: {
                if (!fileNameField.text) {
                    qsTr("A file name must be specified")
                } else if (recordingsModel.sourceModel.contains(_newFilePath)) {
                    qsTr("File already exists")
                } else {
                    ""
                }
            }
        }
    }
}
