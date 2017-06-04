import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All
    Column {
        width: parent.width
        PageHeader {
            title: qsTr("Settings")
        }
        TextField {
            id: location
            width: parent.width
            text: recorder.getLocation()
            label: qsTr("Recordings Location")
            placeholderText: label
            onTextChanged: {
                recorder.setLocation(location.text)
            }
        }
        ComboBox {
            width: parent.width
            label: qsTr("Codec")
            currentIndex: recorder.getCodecIndex()

            onCurrentItemChanged: {
                recorder.setCodec(currentItem.text, currentIndex);
            }

            menu: ContextMenu {
                MenuItem {
                    text: "Vorbis";
                }
                MenuItem {
                    text: "Speex"
                }
                MenuItem {
                    text: "PCM"
                }
                MenuItem {
                    text: "FLAC"
                }
            }
        }
        Label {
            text: qsTr("Vorbis is a good choice for music. Speex is a good choice for speech. PCM and FLAC are both a lossless format.")
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeExtraSmall
            width: parent.width - Theme.horizontalPageMargin * 2
            x: Theme.horizontalPageMargin
            color: Theme.highlightColor
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
            currentIndex: rates.indexOf(recorder.getSampleRate())

            onCurrentItemChanged: {
                recorder.setSampleRate(rates[currentIndex]);
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("auto")
                }

                MenuItem {
                    text: qsTr("%0kHz").arg(8)
                }
                MenuItem {
                    text: qsTr("%0kHz").arg(11)
                }
                MenuItem {
                    text: qsTr("%0kHz").arg(16)
                }
                MenuItem {
                    text: qsTr("%0kHz").arg(22)
                }
                MenuItem {
                    text: qsTr("%0kHz").arg(32)
                }
                MenuItem {
                    text: qsTr("%0kHz").arg(44)
                }
            }
        }
    }
}
