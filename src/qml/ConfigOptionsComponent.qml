/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

Rectangle {
    id: configOptionsComponent
    anchors.fill: parent;
    color: "#343434"
    clip: true

    signal tickersOptionSelected
    signal settingsOptionSelected

    Rectangle {
        id: iconTickersArea
        width: 128
        height: 128
        border.width: 1
        border.color: "#BFBFBF"
        color:"#2E2E2E"
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -0.25 * parent.width
        radius: 15
        Image {
            source: "Library/images/icon_stocks.png"
            anchors.fill: parent            
        }

        MouseArea{
            id: iconTickersMouseArea
            anchors.fill: parent
            onClicked: {
                configOptionsComponent.tickersOptionSelected();
            }
        }

        states: State {
                 name: "pressed"; when: iconTickersMouseArea.pressed
                 PropertyChanges { target: iconTickersArea; color: "#9a9a9a"}
        }
    }

    Text {
        id: tickersLabel
        anchors.top: iconTickersArea.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: iconTickersArea.horizontalCenter
        height: 50
        horizontalAlignment: Text.AlignCenter; verticalAlignment: Text.AlignVCenter
        font.pixelSize: 22; font.bold: true; elide: Text.ElideMiddle; color: "#B8B8B8"; style: Text.Raised; styleColor: "black"
        text: "Add/Remove Tickers"
    }

    Rectangle {
        id: iconSettingsArea
        width: 128
        height: 128
        border.width: 1
        border.color: "#BFBFBF"
        color:"#2E2E2E"
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 0.25 * parent.width
        radius: 15
        Image {
            source: "Library/images/icon_settings.png"
            anchors.fill: parent
        }

        MouseArea{
            id: iconSettingsMouseArea
            anchors.fill: parent
            onClicked: {
                configOptionsComponent.settingsOptionSelected();
            }
        }
        states: State {
                 name: "pressed"; when: iconSettingsMouseArea.pressed
                 PropertyChanges { target: iconSettingsArea; color: "#9a9a9a"}
        }
    }

    Text {
        id: settingsLabel
        anchors.top: iconSettingsArea.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: iconSettingsArea.horizontalCenter
        height: 50
        horizontalAlignment: Text.AlignCenter; verticalAlignment: Text.AlignVCenter
        font.pixelSize: 22; font.bold: true; elide: Text.ElideMiddle; color: "#B8B8B8"; style: Text.Raised; styleColor: "black"
        text: "Update Settings"
    }
}
