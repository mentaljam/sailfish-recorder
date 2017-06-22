import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    function openFileBrowser(location) {
        // Check location root is HOME or SD Card or something else
        var prefix = location.search(StandardPaths.home) === 0 ?
                    StandardPaths.home : location.search(recorder.sdCardPath) === 0 ?
                        recorder.sdCardPath : ""
        if (prefix) {
            // WTF! RPM validator is complaining on nemo home path in comments!
            // Split location path, for example: [ "$HOME", "Documents", "Recordings" ]
            var locationPath = [ prefix ]
            if (location !== prefix) {
                locationPath = locationPath.concat(location.slice(prefix.length + 1).split("/"))
            }
            // Generate an array of directory pages for pushing to the pageStack
            var pages = []
            var locationComponet = Qt.createComponent(Qt.resolvedUrl("LocationPage.qml"))
            var prevObject = page
            for (var i = 1; i <= locationPath.length; ++i) {
                // Each direcory page is a child of previous
                prevObject = locationComponet.createObject(prevObject, { location: prefix })
                pages.push(prevObject)
                // Increment path by steps: "$HOME" -> "$HOME"/Documents" -> "$HOME/Documents/Recordings"
                prefix += "/" + locationPath[i]
            }
            if (pageStack.currentPage === page) {
                pageStack.push(pages)
            } else {
                pageStack.replaceAbove(page, pages)
            }
        } else {
            // Unknown location prefix, open home directory
            if (pageStack.currentPage === page) {
                pageStack.push(Qt.resolvedUrl("LocationPage.qml"), { location: StandardPaths.home })
            } else {
                pageStack.replaceAbove(page, Qt.resolvedUrl("LocationPage.qml"),
                                       { location: StandardPaths.home })
            }
        }
    }

    id: page
    allowedOrientations: Orientation.All

    Component.onCompleted: settingsPage = this

    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("Location")
            }

            ValueButton {
                label: qsTr("Recordings Location")
                value: recorder.location
                onClicked: openFileBrowser(recorder.location)
            }

            Button {
                readonly property bool visible2: recorder.location !== recorder.defaultStoragePath

                anchors.horizontalCenter: parent.horizontalCenter
                height: visible2 ? Theme.itemSizeExtraSmall : 0.0
                opacity: visible2 ? 1.0 : 0.0
                text: qsTr("Set to default")
                onClicked: Remorse.popupAction(page, qsTr("Applying"), function() {
                    recorder.location = recorder.defaultStoragePath
                })

                Behavior on height { NumberAnimation {} }
            }

            TextSwitch {
                text: qsTr("Recursive Search")
                description: qsTr("Search for recording files in subdirectories")
                checked: recorder.recursiveSearch
                onCheckedChanged: recorder.recursiveSearch = checked
            }

            SectionHeader {
                text: qsTr("Codec")
            }

            ComboBox {
                width: parent.width
                label: qsTr("Codec")
                currentIndex: recorder.codec
                description: qsTr("Vorbis is a good choice for music. Speex is a good choice for speech. PCM and FLAC are both a lossless format.")

                onCurrentItemChanged: recorder.codec = currentIndex

                menu: ContextMenu {
                    MenuItem { text: "Vorbis" }
                    MenuItem { text: "Speex" }
                    MenuItem { text: "PCM" }
                    MenuItem { text: "FLAC" }
                }
            }

            ComboBox {
                property variant rates: [
                    0,
                    8000,
                    11025,
                    16000,
                    22050,
                    32000,
                    44100
                ]

                width: parent.width
                label: qsTr("Sample Rate")
                currentIndex: rates.indexOf(recorder.sampleRate)

                onCurrentItemChanged: recorder.sampleRate = rates[currentIndex]

                menu: ContextMenu {
                    MenuItem { text: qsTr("auto") }
                    MenuItem { text: qsTr("%0kHz").arg(8) }
                    MenuItem { text: qsTr("%0kHz").arg(11) }
                    MenuItem { text: qsTr("%0kHz").arg(16) }
                    MenuItem { text: qsTr("%0kHz").arg(22) }
                    MenuItem { text: qsTr("%0kHz").arg(32) }
                    MenuItem { text: qsTr("%0kHz").arg(44) }
                }
            }
        }
    }
}
