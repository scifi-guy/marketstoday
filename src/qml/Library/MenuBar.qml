/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

Item {
    id: menuBar
    signal tickersClicked
    signal optionsClicked
    property int itemHeight: menuBar.height

    BorderImage { source: "images/toolbar.sci"; width: parent.width; height: parent.height + 14; y: -7 }

    Item {
        id: container
        anchors.fill: parent

        Button {
            id: buttonTickers
            text: "Add/Remove Tickers"
            anchors.right: parent.horizontalCenter; anchors.horizontalCenterOffset: -75; y: 3; width: 150; height: 32
            onClicked: menuBar.tickersClicked()
        }

        Button {
            id: buttonOptions
            text: "Update Settings"
            anchors.left: parent.horizontalCenter; anchors.horizontalCenterOffset: 75; y: 3; width: 150; height: 32
            onClicked: menuBar.optionsClicked()
        }
    }
}
