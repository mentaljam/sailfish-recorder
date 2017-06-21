import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.recorder 1.0

Dialog {
    readonly property alias dirName: dirNameField.text
    property DirectoryModel directoryModel

    canAccept: !viewPlaceholder.enabled

    Component.onCompleted: dirNameField.forceActiveFocus()

    Column {
        width: parent.width
        spacing: Theme.paddingMedium

        DialogHeader {
            id: header
            acceptText: qsTr("Create")
        }

        TextField {
            id: dirNameField
            width: parent.width
            label: qsTr("Directory name")
            placeholderText: label
            errorHighlight: viewPlaceholder.enabled
        }

        ViewPlaceholder {
            id: viewPlaceholder
            enabled: text
            text: {
                if (!dirName) {
                    qsTr("Enter new directory name")
                } else if (directoryModel.contains(dirName)) {
                    qsTr("Directory already exists")
                } else {
                    ""
                }
            }
        }
    }
}
