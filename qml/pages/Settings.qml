import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Column {
        width: parent.width
        PageHeader {
            title: "Settings"
        }
        TextField {
            id: location
            width: parent.width
            text: recorder.getLocation()
            label: "Recordings Location"
            onTextChanged: {
                recorder.setLocation(location.text)
            }
        }
        ComboBox {
            width: parent.width
            label: "Codec"
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
            text: "Vorbis is the best choise for music. Speex is the best choise for speech. PCM is raw uncompressed data and FLAC is a lossless format."
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeExtraSmall
            width: parent.width - Theme.paddingLarge * 2
            x: Theme.paddingLarge
            color: Theme.highlightColor
        }
    }
}
