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
import org.nemomobile.notifications 1.0
import harbour.recorder.Recorder 1.0
import "pages"

ApplicationWindow
{
    allowedOrientations: Orientation.All

    Notification {
        function show(message) {
            replacesId = 0
            previewBody = message
            publish()
        }

        id: notification
        expireTimeout: 3000
    }

    Connections {
        target: recorder
        onPathCreationFailed: notification.show(qsTr("Couldn't create file in \"%0\"".arg(recorder.location)))
    }

    Connections {
        target: recorder
        onError: {
            switch (error) {
            case Recorder.ResourceError:
                notification.show(qsTr("Could not write to \"%0\"".arg(recorder.location)))
                break
            case Recorder.OutOfSpaceError:
                notification.show(qsTr("No space left on the device"))
                break
            default:
                break
            }
        }
    }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}


