import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

DockedPanel {
    function play(file) {
        open = true
        audio.source = file
        audio.play()
    }

    id: player
    height: column.height + Theme.paddingLarge * 2
    width: parent.width
    dock: Dock.Top
    modal: true

    onOpenChanged: if (!open) audio.stop()

    Connections {
        target: recorder
        onStatusChanged: player.hide()
    }

    Audio {
        id: audio
        autoLoad: false
        onStopped: player.hide()
    }

    Column {
        id: column
        y: Theme.paddingLarge * 2
        width: parent.width
        spacing: Theme.paddingLarge

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingLarge

            IconButton {
                icon.source: "../icons/stop.png"
                enabled: audio.state !== Audio.StoppedState
                onClicked: audio.stop()
            }

            IconButton {
                icon.source: audio.playbackState === Audio.PausedState ?
                                 "../icons/play.png" : "../icons/pause.png"
                onClicked: {
                    switch (audio.playbackState) {
                    case Audio.PlayingState:
                        audio.pause()
                        break
                    case Audio.PausedState:
                        audio.play()
                        break
                    }
                }
            }

            Label {
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: recorder.formatTime(audio.position)
                font.family: "monospace"
            }
        }

        Slider {
            id: userSlider
            width: player.width
            maximumValue: audio.duration

            onReleased: audio.seek(value)

            Connections {
                target: audio
                onPositionChanged: {
                    if (!userSlider.pressed) {
                        userSlider.value = audio.position
                    }
                }
            }
        }
    }
}
