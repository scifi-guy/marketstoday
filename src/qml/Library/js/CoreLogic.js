/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

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

function refreshDataModel(responseXML){
    if (!(responseXML && stockQuoteDataModel)) return;

    var xmlDoc = responseXML.documentElement;
    var results = xmlDoc.firstChild;

    //Not the best code I ever wrote, but got no choice
    //Refer to Memory leak issue with XMLListModel --> http://bugreports.qt.nokia.com/browse/QTBUG-15191

    if (results) {
        var quoteNodes = results.childNodes;
        if (quoteNodes){
            logUtility.logMessage("Clearing Data Model");
            stockQuoteDataModel.clear();

            var i = 0;
            for (i = 0; i < quoteNodes.length; i++) {

                var quoteElements = quoteNodes[i].childNodes;
                var j = 0;
                var symbol,stockName,lastTradedPrice,change,changePercentage

                for (j = 0; j < quoteElements.length; j++){

                    switch (quoteElements[j].nodeName){
                        case 'Symbol':
                            symbol = quoteElements[j].childNodes[0].nodeValue;
                            break;
                        case 'Name':
                            stockName = quoteElements[j].childNodes[0].nodeValue;
                            break;
                        case 'LastTradePriceOnly':
                            lastTradedPrice = quoteElements[j].childNodes[0].nodeValue;
                            break;
                        case 'Change':
                            change = quoteElements[j].childNodes[0].nodeValue;
                            break;
                        case 'ChangeinPercent':
                            changePercentage = quoteElements[j].childNodes[0].nodeValue;
                            break;
                        default:
                    }
                }
                stockQuoteDataModel.append({"symbol":symbol,"stockName":stockName,"lastTradedPrice":lastTradedPrice,"change":change,"changePercentage":changePercentage});
                logUtility.logMessage("Symbol: "+stockQuoteDataModel.get(i).symbol+", Name: "+ stockQuoteDataModel.get(i).stockName+", LastTraded: "+stockQuoteDataModel.get(i).lastTradedPrice+", Change: "+stockQuoteDataModel.get(i).change+", ChangePercent: "+stockQuoteDataModel.get(i).changePercentage);
            }
        }
    }

    var queryNode = xmlDoc;
    if (queryNode) {
        var i = 0;
        var queryAttributes = queryNode.attributes;
        for (i = 0; i < queryAttributes.length; i++) {
            if (queryAttributes[i].name == 'created') {
                screen.lastUpdatedTimeStamp = "Updated: "+DateLib.ISODate.format(queryAttributes[i].value);
                logUtility.logMessage(screen.lastUpdatedTimeStamp);
                break;
            }
        }
    }
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
                refreshDataModel(response.responseXML);
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
    if (!value || value == "0.0" || value === ""){
        autoUpdateInterval = 0;
    }
    else{
        autoUpdateInterval = parseInt(value)*60*1000; //Convert minutes to milliseconds
    }
    value  = DBUtility.getSetting("UpdateWeekdaysOnly");
    if (!value || value == "0.0" || value === ""){
        updateWeekDaysOnly = false;
    }
    else{
        updateWeekDaysOnly = true;
    }

    value  = DBUtility.getSetting("UpdateOnSavedNetworksOnly");
    if (!value || value == "0.0" || value === ""){
        updateOnSavedNetworksOnly = false;
    }
    else{
        updateOnSavedNetworksOnly = true;
    }

}

function initialize(){
    if (autoUpdateTimer.running) autoUpdateTimer.stop();
    loadSettings();
    reloadQuotes();

    if (autoUpdateInterval !== 0) {
        logUtility.logMessage("Starting Timer..");
        autoUpdateTimer.start();
    }
}
