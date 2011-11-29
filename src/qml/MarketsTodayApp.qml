/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import QtQuick 1.1
import com.nokia.meego 1.0

import "Library" as Library
import "Library/js/ISODate.js" as DateLib
import "Library/js/DBUtility.js" as DBUtility
import "Library/js/Common.js" as Common
import "Library/js/CoreLogic.js" as CoreLib

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    showToolBar: false
    showStatusBar: false

    property int autoUpdateInterval: 300000
    property bool updateWeekDaysOnly: false
    property bool updateOnSavedNetworksOnly: false
    property string rssURL: "http://finance.yahoo.com/rss/topfinstories"
    property string lastUpdatedTimeStamp
    property bool isDesktopWidget
    //property string selectedSymbol:"YHOO"
    property string selectedSymbol:sharedContext.getStockSymbol()

    signal showConfigInNewWindow
    signal showStockDetails(string strSymbol)
    signal quoteRefreshStarted
    signal quoteRefreshCompleted(bool success, string strMessage)
    signal newsReloadCompleted(bool success, string strMessage)
    signal checkNetworkStatus

    function initialize(){
        mainPage.initializePage();
    }

    Page {
        id: mainPage

        property int itemHeight: 50
        property int titleBarHeight: 60
        property int toolBarHeight: 40
        property int componentWidth: mainPage.width

        function reloadData(){
            CoreLib.reloadQuotes();
            CoreLib.reloadNews();
        }

        function initializePage(){
            var componentToDisplay = sharedContext.getComponentToDisplay();
            if (componentToDisplay === "StockQuoteDetails"){
                uiLoader.sourceComponent = stockDetailsComponent;
                titleBar.buttonType = "Close";
                titleBar.displayMenu = false;
                toolBar.displayIcons = false;
            }
            else{
                DBUtility.initialize();
                uiLoader.sourceComponent = stockQuotesUIComponent;
                CoreLib.initialize();
            }
        }

        Component.onCompleted: {
            initializePage();
        }

        Timer {
            id: autoUpdateTimer
            interval: autoUpdateInterval
            //running: (autoUpdateInterval == 0? false:true)
            repeat: true
            onTriggered: {
                if (!updateWeekDaysOnly){
                    logUtility.logMessage("Allowed to update all days of the week");
                    mainPage.reloadData();
                    //checkNetworkStatus();
                }
                else if (Common.isTodayAWeekDay()){
                    logUtility.logMessage("Today is a weekday");
                    mainPage.reloadData();
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

            Component {
                id: stockQuotesDelegateLandscape

                Item {
                    id: wrapper; width: mainPage.componentWidth; height: mainPage.itemHeight
                    Item {
                        Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: wrapper.height - 2; width: wrapper.width; y: 1
                            MouseArea {
                                anchors.fill: parent
                                onDoubleClicked: {
                                    appWindow.selectedSymbol = symbol;
                                    uiLoader.sourceComponent = stockDetailsComponent;
                                    titleBar.buttonType = "Back";
                                    titleBar.displayMenu = false;
                                    toolBar.displayIcons = false;
                                }
                            }
                        }

                        Row {
                            x: 30;y: 15;
                            width: mainPage.componentWidth - 60;
                            spacing: 5

                            Text { text: stockName; width: parent.width * 30/100; font.pixelSize: 18; font.bold: true; elide: Text.ElideRight; color: "white"; style: Text.Raised; styleColor: "black" }
                            Text { text: lastTradedPrice; width: parent.width * 15/100; font.pixelSize: 18; horizontalAlignment: Text.AlignLeft; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                            Text { text: change !== ""? (change + " ("+changePercentage+")"):""; width: parent.width * 25/100;  font.pixelSize: 18; horizontalAlignment: Text.AlignLeft; elide: Text.ElideRight
                                    color: if(change >= 0){"green";} else {"red";}
                                        style: Text.Raised; styleColor: "black" }
                            Text { text: volume; width: parent.width * 15/100; font.pixelSize: 18; horizontalAlignment: Text.AlignLeft; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                            Text { text: marketCap; width: parent.width * 15/100; font.pixelSize: 18; horizontalAlignment: Text.AlignLeft; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                        }
                    }
                }
            }

            Component {
                id: stockQuotesDelegatePortrait

                Item {
                    id: wrapperItem; width: mainPage.componentWidth; height: mainPage.itemHeight
                    Item {
                        Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: wrapperItem.height - 2; width: wrapperItem.width; y: 1                            
                            MouseArea {
                                anchors.fill: parent
                                onDoubleClicked: {
                                    appWindow.selectedSymbol = symbol;
                                    uiLoader.sourceComponent = stockDetailsComponent;
                                    titleBar.buttonType = "Back";
                                    titleBar.displayMenu = false;
                                    toolBar.displayIcons = false;
                                }
                            }
                        }

                        Row {
                            x: 10;y: 15;
                            width: mainPage.componentWidth - 5;
                            spacing: 3

                            Text { text: stockName; width: parent.width * 42/100; font.pixelSize: 18; font.bold: true; elide: Text.ElideRight; color: "white"; style: Text.Raised; styleColor: "black" }
                            Text { text: lastTradedPrice; width: parent.width * 20/100; font.pixelSize: 18; horizontalAlignment: Text.AlignLeft; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                            Column {
                                y: -15;
                                width: parent.width * 18/100; height: parent.height
                                spacing: 2
                                Text { text: change; font.pixelSize: 16; horizontalAlignment: Text.AlignLeft; elide: Text.ElideRight
                                    color: if(change >= 0){"green";} else {"red";}
                                        style: Text.Raised; styleColor: "black" }
                                Text { text: changePercentage; font.pixelSize: 16; horizontalAlignment: Text.AlignLeft; elide: Text.ElideRight;
                                    color: if(change >= 0){"green";} else {"red";}
                                        style: Text.Raised; styleColor: "black" }
                            }
                            Text { text: volume; width: parent.width * 20/100; font.pixelSize: 18; horizontalAlignment: Text.AlignLeft; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                        }
                    }
                }
            }

            Component {
                id: newsDelegate

                Item {
                    id: newsWrapper; width: mainPage.componentWidth; height: mainPage.itemHeight
                    Item {
                        anchors.fill: parent
                        Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: newsWrapper.height - 2; width: newsWrapper.width; y: 1 }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.right: parent.right
                            text: title; font.pixelSize: 18
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
                id: titleBar;
                width: parent.width; height: mainPage.titleBarHeight;
                anchors.top: parent.top
                title: "Markets Today";
                buttonType: "Close";
                z: 5  //required to keep Titlebar and Menu buttons on top of everything else

                onCloseClicked: Qt.quit()

                onTickersClicked: {
                    uiLoader.sourceComponent = configTickersComponent;
                    titleBar.buttonType = "Back";
                    titleBar.displayMenu = false;
                    toolBar.displayIcons = false;
                }

                onOptionsClicked: {
                    uiLoader.sourceComponent = configParamsComponent;
                    titleBar.buttonType = "Back";
                    titleBar.displayMenu = false;
                    toolBar.displayIcons = false;
                }

                onBackClicked: {
                    uiLoader.sourceComponent = stockQuotesUIComponent;
                    titleBar.buttonType = "Close";
                    titleBar.displayMenu = false;
                    toolBar.displayIcons = true;
                    mainPage.initializePage();
                }
            }

            Loader {
                id: uiLoader
                width: parent.width
                anchors.top: titleBar.bottom
                anchors.bottom: toolBar.top
            }

            Library.ToolBar {
                id:toolBar
                width: parent.width; height: mainPage.toolBarHeight
                anchors.bottom: parent.bottom
                opacity: 0.9
                displayNavigation: false
                onReloadButtonClicked: mainPage.reloadData();

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
                    target: appWindow
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
                        id: listViewWrapper
                        width: parent.width
                        anchors.top: parent.top
                        anchors.bottom: footerText.top
                        color: "#343434"

                        ListView {
                            id: stockQuotesView
                            anchors.fill: parent
                            flickDeceleration: 500
                            model: stockQuoteDataModel
                            delegate:  listViewWrapper.height > listViewWrapper.width ? stockQuotesDelegatePortrait : stockQuotesDelegateLandscape
                            focus:true
                            snapMode: ListView.SnapToItem
                        }
                    }

                    Rectangle {
                        id: stockStatusMsgArea
                        height: 100
                        color: "#343434"
                        anchors {left: parent.left; leftMargin: 15; right: parent.right; rightMargin: 15;
                                verticalCenter: parent.verticalCenter}
                        visible: false

                        Text {
                            id: stockStatusText
                            anchors.fill: parent
                            text: "Loading quotes.."
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                            width: parent.width; font.pixelSize: 16; elide: Text.ElideNone;
                            color: "#cccccc"
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            style: Text.Raised; styleColor: "black"

                            Connections {
                                target: appWindow
                                onQuoteRefreshCompleted: {
                                    if (success){
                                        stockStatusMsgArea.visible = false;
                                    }
                                    else{
                                        stockStatusText.text = strMessage;
                                        stockStatusMsgArea.visible = true;
                                    }
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
                            text: lastUpdatedTimeStamp
                            horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                            width: parent.width; font.pixelSize: 12; elide: Text.ElideRight;
                            color: "#cccccc"
                            style: Text.Raised; styleColor: "black"

                            Connections {
                                target: appWindow
                                onQuoteRefreshCompleted:{
                                    timeStamp.text = lastUpdatedTimeStamp;
                                }
                            }
                        }
                    }
                }
            }

            Component{
                id: stockDetailsComponent
                StockDetailsComponent {
                    symbol: selectedSymbol
                    onLogRequest: logUtility.logMessage(strMessage)
                    onLockInLandscape: mainPage.orientationLock = PageOrientation.LockLandscape
                    onUnlockOrientation: mainPage.orientationLock = PageOrientation.Automatic
                }
            }

            Component {
                id: newsComponent
                Item {
                    Rectangle{
                        id: newsViewArea
                        width: parent.width
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        color: "#343434"

                        ListView {
                            id: newsView
                            anchors.fill: parent
                            flickDeceleration: 500
                            model: newsDataModel
                            delegate:  newsDelegate
                            focus:true
                            snapMode: ListView.SnapToItem
                        }
                    }

                    Rectangle {
                        id: newsStatusMsgArea
                        height: 100
                        color: "#343434"
                        anchors {left: parent.left; leftMargin: 15; right: parent.right; rightMargin: 15;
                                verticalCenter: parent.verticalCenter}
                        visible: false

                        Text {
                            id: newsStatusText
                            anchors.fill: parent
                            text: "Loading news.."
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                            width: parent.width; font.pixelSize: 16; elide: Text.ElideNone;
                            color: "#cccccc"
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            style: Text.Raised; styleColor: "black"

                            Connections {
                                target: appWindow
                                onNewsReloadCompleted: {
                                    if (success){
                                        newsStatusMsgArea.visible = false;
                                        newsViewArea.visible = true;
                                    }
                                    else{
                                        newsStatusText.text = strMessage;
                                        newsViewArea.visible = false;
                                        newsStatusMsgArea.visible = true;
                                    }
                                }
                            }
                        }
                    }

                }
            }

            Component {
                id: configTickersComponent

                ConfigTickersComponent{
                    itemHeight: mainPage.itemHeight
                    componentWidth: mainPage.componentWidth
                    onLogRequest: logUtility.logMessage(strMessage)
                }
            }

            Component {
                id: configParamsComponent
                ConfigParametersComponent{
                    onLogRequest: logUtility.logMessage(strMessage)
                }
            }
        }
    }
}
