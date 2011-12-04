/*
@version: 0.4
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

        Row {
            spacing: 5
            height: 50
            anchors.centerIn: parent

            Button {
                id: buttonTickers
                text: "Add/Remove Tickers"
                fontSize: 14
                width: 200; height: parent.height
                onClicked: menuBar.tickersClicked()
            }

            Button {
                id: buttonOptions
                text: "Update Settings"
                fontSize: 14
                width: 200; height: parent.height
                onClicked: menuBar.optionsClicked()
            }
        }
    }
}
