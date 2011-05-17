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

Item {
    id: screen; width: 400; height: 325

    signal showConfigInNewWindow
    signal quoteRefreshStarted
    signal quoteRefreshCompleted

    property int autoUpdateInterval: 300000
    property bool updateWeekDaysOnly: false

    function getQuery(){
        var query;
        var symbolsArray = DBUtility.getAllSymbols();
        if (symbolsArray && symbolsArray.length > 0){
            var i = 0;
            for (i = 0; i< symbolsArray.length; i++) {
                logUtility.logMessage("Appending "+symbolsArray[i]+ " to Query");

                if (!query){
                    query = '"'+symbolsArray[i]+'"';
                }
                else{
                    query = query + ',"' + symbolsArray[i]+'"';
                }
            }
        }

        return query;        
    }


    function reloadQuotes(){
        var query = getQuery();
        if (query){
            screen.quoteRefreshStarted();
            logUtility.logMessage("Reloading Data..");

            //var queryURL = 'http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol in ("INDU","^IXIC","^GSPC","CLJ11.NYM","YHOO","AAPL","GOOG","MSFT")&env=store://datatables.org/alltableswithkeys';
            var queryURL = 'http://query.yahooapis.com/v1/public/yql?q=select Symbol,Name,LastTradePriceOnly,Change,ChangeinPercent from yahoo.finance.quotes where symbol in ('+query+')&env=store://datatables.org/alltableswithkeys';
            logUtility.logMessage(queryURL);

            var response = new XMLHttpRequest();
            response.onreadystatechange = function() {
                if (response.readyState == XMLHttpRequest.DONE) {
                    stockQuoteDataModel.xml = response.responseText;
                    lastUpdatedDateModel.xml = response.responseText;
                    logUtility.logMessage("Data Reload Completed..");
                    screen.quoteRefreshCompleted();
                }
            }

            response.open("GET", queryURL);
            response.send();
        }
        else{
            logUtility.logMessage("No stock symbols found in configuration.");
        }
    }

    function loadSettings(){
        var value;
        value  = DBUtility.getSetting("UpdateFreqency");
        if (!value || value == "0.0" || value == ""){
            autoUpdateInterval = 0;
        }
        else{
            autoUpdateInterval = parseInt(value)*60*1000; //Convert minutes to milliseconds
        }
        value  = DBUtility.getSetting("UpdateWeekdaysOnly");
        if (!value || value == "0.0" || value == ""){
            updateWeekDaysOnly = false;
        }
        else{
            updateWeekDaysOnly = true;
        }
    }

    function initialize(){
        if (autoUpdateTimer.running) autoUpdateTimer.stop();
        loadSettings();
        reloadQuotes();
        if (autoUpdateInterval != 0) {
            logUtility.logMessage("Starting Timer..");
            autoUpdateTimer.start();
        }
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
                logUtility.logMessage("Update triggered: Allowed to update all days of the week");
                reloadQuotes();
            }
            else if (Common.isTodayAWeekDay()){
                logUtility.logMessage("Update triggered: Today is a weekday");
                reloadQuotes();
            }
            else{
                logUtility.logMessage("Update not triggered: Today is not a weekday");
            }
        }
    }

    XmlListModel{
        id: stockQuoteDataModel
        query:  "/query/results/quote"

        XmlRole { name: "symbol"; query: "Symbol/string()" }
        XmlRole { name: "stockName"; query: "Name/string()" }
        XmlRole { name: "lastTradedPrice"; query: "LastTradePriceOnly/string()" }
        XmlRole { name: "change"; query: "Change/string()" }
        XmlRole { name: "changePercentage"; query: "ChangeinPercent/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready){
                logUtility.logMessage("No. of tickers: "+stockQuoteDataModel.count);
            }
        }
    }

    XmlListModel {
        id: lastUpdatedDateModel
        query: "/query"
        namespaceDeclarations: "declare namespace yahoo='http://www.yahooapis.com/v1/base.rng';"
        XmlRole { name: "timestamp"; query: '@yahoo:created/string()'}

        onStatusChanged: {
            if (status == XmlListModel.Ready && lastUpdatedDateModel.get(0)){
                logUtility.logMessage("Updated: "+DateLib.ISODate.format(lastUpdatedDateModel.get(0).timestamp));
            }
        }
    }            

    Rectangle {
        id: background        
        anchors.fill: parent;
        color: "#343434"
        clip: true
        property int itemHeight: 50

        Library.TitleBar {
            id: titleBar;
            width: parent.width; height: 60;
            anchors.top: parent.top
            title: "Markets Today";
            buttonType: "Config";
            onSettingsClicked: {
                screen.showConfigInNewWindow();
            }

            onCloseClicked: {
                Qt.quit();
            }
        }

        Loader {
            id: marketsTodayLoader
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            sourceComponent: stockQuotesParentComponent
        }

        Component {
            id: stockQuotesParentComponent
            StockQuotesComponent{
                id:stockQuotesComponent
                componentWidth: background.width
                stockQuotesListModel: stockQuoteDataModel
                lastUpdatedModel: lastUpdatedDateModel

                Connections {
                    target: screen

                    onQuoteRefreshStarted: {
                        stockQuotesComponent.updateStarted();
                    }

                    onQuoteRefreshCompleted: {
                        stockQuotesComponent.updateCompleted();
                    }
                }

                Component.onCompleted: {
                    titleBar.title = "Markets Today";
                    titleBar.buttonType = "Config";
                }
            }
        }
    }
}
