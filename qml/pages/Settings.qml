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
    }
}
