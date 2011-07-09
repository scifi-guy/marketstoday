/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

import "Library" as Library
import "Library/js/ISODate.js" as DateLib
import "Library/js/DBUtility.js" as DBUtility
import "Library/js/Common.js" as Common
import "Library/js/CoreLogic.js" as CoreLib

Item {
    id: screen

    signal showConfigInNewWindow
    signal quoteRefreshStarted
    signal quoteRefreshCompleted
    signal checkNetworkStatus

    property int itemHeight: 50
    property int componentWidth: screen.width
    property int autoUpdateInterval: 300000
    property bool updateWeekDaysOnly: false
    property bool updateOnSavedNetworksOnly: false
    property string lastUpdatedTimeStamp
    property bool isDesktopWidget

    function reloadQuotes(){
        CoreLib.reloadQuotes();
    }

    function initialize(){
        CoreLib.initialize();
    }

    Component.onCompleted: {
        initialize();
    }

    Timer {
        id: autoUpdateTimer
        interval: autoUpdateInterval
        //running: (autoUpdateInterval == 0? false:true)
        repeat: true
        onTriggered: {
            if (!updateWeekDaysOnly){
                logUtility.logMessage("Allowed to update all days of the week");
                //reloadQuotes();
                checkNetworkStatus();
            }
            else if (Common.isTodayAWeekDay()){
                logUtility.logMessage("Today is a weekday");
                //reloadQuotes();
                checkNetworkStatus();
            }
            else{
                logUtility.logMessage("Update not triggered: Today is not a weekday");
            }
        }
    }

    ListModel{
        id: stockQuoteDataModel
    }

    Rectangle {
        id: background
        anchors.fill: parent;
        color: "#343434"
        clip: true

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

        Library.TitleBar {
            id: titleBar;
            width: parent.width; height: 60;
            anchors.top: parent.top
            title: "Markets Today";
            buttonType: "";
        }

        Rectangle{
            id: pathViewWrapper
            width: parent.width
            anchors.top: titleBar.bottom
            anchors.bottom: footerText.top
            color: "#343434"

            PathView {
                id: stockQuotesView
                anchors.fill: parent
                flickDeceleration: 500
                //preferredHighlightBegin: 1/stockQuotesView.count
                //preferredHighlightEnd: 1/stockQuotesView.count
                //pathItemCount: count
                focus: true
                interactive: true
                model: stockQuoteDataModel
                delegate:  stockQuotesDelegate
                path: Path {
                    startX: width / 2
                    startY: itemHeight/2
                    PathLine {
                        x: width / 2
                        y: stockQuotesView.count * itemHeight  + itemHeight/2
                    }
                }
                Keys.onDownPressed: if (!moving && interactive) incrementCurrentIndex()
                Keys.onUpPressed: if (!moving && interactive) decrementCurrentIndex()

                Connections {
                    target:  screen
                    onQuoteRefreshCompleted:{
                        stockQuotesView.currentIndex = 0;
                    }
                }

                Connections {
                    target: toolBar
                    onDownButtonClicked: {
                        if (!stockQuotesView.moving && stockQuotesView.interactive)
                            stockQuotesView.currentIndex = stockQuotesView.currentIndex + 1
                    }
                    onUpButtonClicked: {
                        if (!stockQuotesView.moving && stockQuotesView.interactive)
                            stockQuotesView.currentIndex = stockQuotesView.currentIndex - 1
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
                text: screen.lastUpdatedTimeStamp
                horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                width: parent.width; font.pixelSize: 12; elide: Text.ElideRight;
                color: "#cccccc"
                style: Text.Raised; styleColor: "black"

                Connections {
                    target: screen
                    onQuoteRefreshCompleted:{
                        timeStamp.text = screen.lastUpdatedTimeStamp;
                    }
                }
            }
        }

        Library.ToolBar {
            id:toolBar
            width: parent.width; height: 40
            anchors.bottom: parent.bottom
            opacity: 0.9
            displayNavigation: true
            onReloadButtonClicked: screen.reloadQuotes();
            onNewsButtonClicked: Qt.openUrlExternally("http://finance.yahoo.com");
            Connections {
                target: screen
                onQuoteRefreshStarted:{
                    if (!toolBar.updatePending) toolBar.updatePending = true;
                }
                onQuoteRefreshCompleted:{
                    toolBar.updatePending = false;
                    console.log(screen.lastUpdatedTimeStamp);
                }
            }
        }
    }
}
