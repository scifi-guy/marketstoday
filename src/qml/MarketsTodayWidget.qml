/*
@version: 0.2
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
    signal showStockDetails(string strSymbol)
    signal quoteRefreshStarted
    signal quoteRefreshCompleted
    signal checkNetworkStatus

    property int itemHeight: 50
    property int titleBarHeight: 60
    property int toolBarHeight: 40
    property int componentWidth: screen.width
    property int autoUpdateInterval: 300000
    property bool updateWeekDaysOnly: false
    property bool updateOnSavedNetworksOnly: false
    property string rssURL: "http://finance.yahoo.com/rss/topstories"
    property string lastUpdatedTimeStamp
    property bool isDesktopWidget
    property string selectedSymbol:""

    function reloadData(){
        CoreLib.reloadQuotes();
        CoreLib.reloadNews();
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
                reloadData();
                //checkNetworkStatus();
            }
            else if (Common.isTodayAWeekDay()){
                logUtility.logMessage("Today is a weekday");
                reloadData();
                //checkNetworkStatus();
            }
            else{
                logUtility.logMessage("Update not triggered: Today is not a weekday");
            }
        }
    }

    ListModel{
        id: stockQuoteDataModel
    }

    ListModel {
        id: newsDataModel
    }

    Rectangle {
        id: background
        anchors.fill: parent;
        color: "#343434"
        clip: true

        Component.onCompleted: {
            console.log("Rectangle Height = "+background.height);
        }

        Component {
            id: stockQuotesDelegate

            Item {
                id: wrapper; width: parent.width; height: itemHeight
                Item {
                    anchors.fill: parent
                    Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: wrapper.height - 2; width: wrapper.width; y: 1
                        Image{
                            id: informationIcon
                            width: 32
                            height: 32
                            z: 10
                            anchors {right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter}
                            visible: false
                            source: "Library/images/information.png"
                            MouseArea{
                                anchors.fill: parent;
                                onPressed: {
                                    //console.log("Image clicked");
                                    showStockDetails(symbol);
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed:{
                                informationIcon.visible = true;
                                //console.log("Rectangle clicked");
                            }
                        }
                    }
                    Row {
                        y: 15;//x: 30;
                        anchors {left: parent.left;leftMargin: 10;right: parent.right;rightMargin: 10}
                        //width: componentWidth;
                        height: parent.height
                        spacing: 5

                        Text { text: symbol; width: parent.width * 25/100; font.pixelSize: 18; font.bold: true; verticalAlignment:Text.AlignVCenter; elide: Text.ElideRight; color: "white"; style: Text.Raised; styleColor: "black" }
                        Text { text: lastTradedPrice; width: parent.width * 25/100; font.pixelSize: 18; verticalAlignment:Text.AlignVCenter; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                        Column {
                            y: -15;
                            width: parent.width * 20/100; height: parent.height
                            spacing: 2
                            Text { text: change; font.pixelSize: 16; elide: Text.ElideRight
                                color: if(change >= 0){"green";} else {"red";}
                                    style: Text.Raised; styleColor: "black" }
                            Text { text: changePercentage; font.pixelSize: 16; elide: Text.ElideRight;
                                color: if(change >= 0){"green";} else {"red";}
                                    style: Text.Raised; styleColor: "black" }
                        }
                        Text { text: volume; width: parent.width * 30/100; font.pixelSize: 18; verticalAlignment:Text.AlignVCenter; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                    }
                }
            }
        }

        Component {
            id: newsDelegate

            Item {
                id: newsWrapper; width: componentWidth; height: itemHeight
                Item {
                    anchors.fill: parent
                    Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: newsWrapper.height - 2; width: newsWrapper.width; y: 1 }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.right: parent.right
                        text: title; font.pixelSize: 14
                        font.bold: false;
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight;
                        color: "white";
                        style: Text.Raised;
                        styleColor: "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally(link);
                    }
                }
            }
        }

        Library.TitleBar {
            id: titleBar
            width: parent.width; height: screen.titleBarHeight
            anchors.top: parent.top
            title: "Markets Today"
            buttonType: ""
            displayMenuIcon: false

            onBackClicked: {
                uiLoader.sourceComponent = stockQuotesUIComponent;
                titleBar.buttonType = "";
                titleBar.displayMenu = false;
                toolBar.displayIcons = true;
            }
        }

        Loader {
            id: uiLoader
            width: parent.width
            anchors.top: titleBar.bottom
            anchors.bottom: toolBar.top
            sourceComponent: stockQuotesUIComponent
        }

        Library.ToolBar {
            id:toolBar
            width: parent.width; height: screen.toolBarHeight
            anchors.bottom: parent.bottom
            opacity: 0.9
            displayNavigation: true
            onReloadButtonClicked: screen.reloadData();
            onNewsButtonClicked: {
                uiLoader.sourceComponent = newsComponent;
                toolBar.displayIcons = true;
                toolBar.targetContentType = "Stocks";
            }

            onStocksButtonClicked: {
                uiLoader.sourceComponent = stockQuotesUIComponent;
                toolBar.displayIcons = true;
                toolBar.targetContentType = "News";
            }


            Connections {
                target: screen
                onQuoteRefreshStarted:{
                    if (!toolBar.updatePending) toolBar.updatePending = true;
                }
                onQuoteRefreshCompleted:{
                    toolBar.updatePending = false;
                }
            }
        }

        Component {
            id: stockQuotesUIComponent
            Item {
                Rectangle{
                    id: pathViewWrapper
                    width: parent.width
                    anchors.top: parent.top
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
                    anchors.bottom: parent.bottom
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
            }
        }

        Component {
            id: newsComponent
            Item {
                Rectangle{
                    width: parent.width
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#343434"

                    PathView {
                        id: newsView
                        anchors.fill: parent
                        flickDeceleration: 500
                        focus: true
                        interactive: true
                        model: newsDataModel
                        delegate:  newsDelegate
                        path: Path {
                            startX: width / 2
                            startY: itemHeight/2
                            PathLine {
                                x: width / 2
                                y: newsView.count * itemHeight  + itemHeight/2
                            }
                        }
                        Keys.onDownPressed: if (!moving && interactive) incrementCurrentIndex()
                        Keys.onUpPressed: if (!moving && interactive) decrementCurrentIndex()

                        Connections {
                            target:  screen
                            onQuoteRefreshCompleted:{
                                newsView.currentIndex = 0;
                            }
                        }

                        Connections {
                            target: toolBar
                            onDownButtonClicked: {
                                if (!newsView.moving && newsView.interactive)
                                    newsView.currentIndex = newsView.currentIndex + 1
                            }
                            onUpButtonClicked: {
                                if (!newsView.moving && newsView.interactive)
                                    newsView.currentIndex = newsView.currentIndex - 1
                            }
                       }
                    }
                }
            }
        }
    }
}
