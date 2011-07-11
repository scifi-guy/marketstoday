/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

Row{
    property string label1
    property string value1
    property int cell1Width
    property string label2
    property string value2
    property int cell2Width

    height: 30
    spacing: 5

    Text{
        width: cell1Width
        height: itemHeight
        horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14;font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
        color: "#ffffff";
        text: label1+": " + value1
    }

    Text{
        width: cell2Width
        height: itemHeight
        horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
        color: "#ffffff";
        text: label2+": " + value2
    }
}
