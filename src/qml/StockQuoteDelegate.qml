/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

Component {
    Item {
        id: wrapper; width: wrapper.PathView.view.width; height: 50
        Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: wrapper.height; width: wrapper.width; y: 1
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: wrapper.PathView.view.width - 70;
                spacing: 5
                Text { text: symbol; width: parent.width * 35/100; font.pixelSize: 18; font.bold: true; elide: Text.ElideRight; color: "white"; style: Text.Raised; styleColor: "black" }
                Text { text: lastTradedPrice; width: parent.width * 25/100; font.pixelSize: 18; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                Text { text: change; width: parent.width * 20/100; font.pixelSize: 18; elide: Text.ElideRight
                    color: if(change >= 0){"green";} else {"red";}
                        style: Text.Raised; styleColor: "black" }
                Text { text: changePercentage; width: parent.width * 20/100; font.pixelSize: 18; elide: Text.ElideRight;
                    color: if(change >= 0){"green";} else {"red";}
                        style: Text.Raised; styleColor: "black" }
            }
        }
    }
}
