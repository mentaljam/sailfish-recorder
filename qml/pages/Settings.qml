import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All
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
            text: "Vorbis is a good choice for music. Speex is a good choice for speech. PCM and FLAC are both a lossless format."
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
            label: "Sample Rate"
            currentIndex: rates.indexOf(recorder.getSampleRate())

            onCurrentItemChanged: {
                recorder.setSampleRate(rates[currentIndex]);
            }

            menu: ContextMenu {
                MenuItem {
                    text: "auto"
                }

                MenuItem {
                    text: "8kHz"
                }
                MenuItem {
                    text: "11kHz"
                }
                MenuItem {
                    text: "16kHz"
                }
                MenuItem {
                    text: "22kHz"
                }
                MenuItem {
                    text: "32kHz"
                }
                MenuItem {
                    text: "44kHz"
                }
            }
        }
    }
}
