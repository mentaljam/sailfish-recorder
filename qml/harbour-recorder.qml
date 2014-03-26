/*
    A simple audio recording tool.
    Copyright (C) 2014  Corné Dorrestijn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.recorder.Recorder 1.0
import "pages"

ApplicationWindow
{
    property string timestamp: "Start recording";
    property int time: 0;

    Recorder {
        id: recorder
    }

    Timer {
        id: timer
        interval: 1000;
        running: false;
        repeat: true;
        onTriggered: {
            time++;
            var minutes = Math.floor(time/60);
            var seconds = time - minutes * 60;
            timestamp = minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
        }
    }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}


