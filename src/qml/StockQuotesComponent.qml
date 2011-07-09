/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7
import "Library" as Library
import "Library/js/ISODate.js" as DateLib

Rectangle {
    id: stockQuotesComponent
    clip: true
    color: "#343434"

    signal updateStarted
    signal updateCompleted

    property ListModel stockQuotesListModel
    property string lastUpdatedTimeStamp
    property int componentWidth
    property int componentHeight
    property int itemHeight: 50

    Component {
        id: stockQuotesDelegate

        Item {
            id: wrapper; width: componentWidth; height: itemHeight
            Item {
                Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: wrapper.height - 2; width: wrapper.width; y: 1 }
                Row {
                    x: 30;y: 15;
                    width: componentWidth - 40;
                    spacing: 5

                    Text { text: if (width >= 250) {stockName;} else {symbol;} width: parent.width * 35/100; font.pixelSize: 18; font.bold: true; elide: Text.ElideRight; color: "white"; style: Text.Raised; styleColor: "black" }
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

    Rectangle{
        id: pathViewWrapper
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: footerText.top
        color: "#343434"

        PathView{
            id: stockQuotesView
            flickDeceleration: 500
            //preferredHighlightBegin: 1/stockQuotesView.count
            //preferredHighlightEnd: 1/stockQuotesView.count
            //pathItemCount: count
            focus: true
            interactive: true
            model: stockQuotesListModel
            delegate:  stockQuotesDelegate
            path: Path {
                startX: width / 2
                startY: itemHeight/2
                PathLine {
                    x: width / 2
                    y: stockQuotesView.count * itemHeight  + itemHeight/2
                }
            }
            Keys.onDownPressed: if (!moving && interactive) {
                                    console.log(stockQuotesView.height);
                                    incrementCurrentIndex();
                                }
            Keys.onUpPressed: if (!moving && interactive) decrementCurrentIndex()

            Connections {
                target:  stockQuotesComponent
                onUpdateCompleted:{
                    stockQuotesView.currentIndex = 0;
                }
            }

        }
    }

    Rectangle{
        id: footerText
        width: parent.width
        height: 25
        color: "#343434"
        anchors.bottom: toolBar.top
        Text {
            id: timeStamp
            anchors.fill: parent
            text: stockQuotesComponent.lastUpdatedTimeStamp
            horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
            width: parent.width; font.pixelSize: 12; elide: Text.ElideRight;
            color: "#cccccc"
            style: Text.Raised; styleColor: "black"

            Connections {
                target: stockQuotesComponent
                onUpdateCompleted:{
                    timeStamp.text = stockQuotesComponent.lastUpdatedTimeStamp;
                }
            }
        }
    }

    Library.ToolBar {
        id:toolBar
        width: parent.width; height: 40
        anchors.bottom: parent.bottom
        opacity: 0.9
        onReloadButtonClicked: reloadQuotes();
        onDownButtonClicked: if (!stockQuotesView.moving && stockQuotesView.interactive) stockQuotesView.currentIndex = stockQuotesView.currentIndex + 1
        onUpButtonClicked: if (!stockQuotesView.moving && stockQuotesView.interactive) stockQuotesView.currentIndex = stockQuotesView.currentIndex - 1
        onNewsButtonClicked: Qt.openUrlExternally("http://finance.yahoo.com");
        Connections {
            target: stockQuotesComponent
            onUpdateStarted:{
                if (!toolBar.updatePending) toolBar.updatePending = true;
            }
            onUpdateCompleted:{
                toolBar.updatePending = false;
                console.log(stockQuotesComponent.lastUpdatedTimeStamp);
            }
        }
    }
}
