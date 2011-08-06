/*
@version: 0.2
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
                var symbol,stockName,lastTradedPrice,change,changePercentage,volume,marketCap

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
                            change = (quoteElements[j].childNodes[0])? quoteElements[j].childNodes[0].nodeValue:"";
                            break;
                        case 'ChangeinPercent':
                            changePercentage = (quoteElements[j].childNodes[0])? quoteElements[j].childNodes[0].nodeValue:"";
                            break;
                        case 'Volume':
                            volume = (quoteElements[j].childNodes[0])? quoteElements[j].childNodes[0].nodeValue:"";
                            break;
                        case 'MarketCapitalization':
                            marketCap = (quoteElements[j].childNodes[0])? quoteElements[j].childNodes[0].nodeValue:"";
                            break;
                        default:
                    }
                }
                stockQuoteDataModel.append({"symbol":symbol,"stockName":stockName,"lastTradedPrice":lastTradedPrice,"change":change,"changePercentage":changePercentage,"volume":volume,"marketCap":marketCap});
                //logUtility.logMessage("Symbol: "+stockQuoteDataModel.get(i).symbol+", Name: "+ stockQuoteDataModel.get(i).stockName+", LastTraded: "+stockQuoteDataModel.get(i).lastTradedPrice+", Change: "+stockQuoteDataModel.get(i).change+", ChangePercent: "+stockQuoteDataModel.get(i).changePercentage+", Volume: "+stockQuoteDataModel.get(i).volume+", MarketCap: "+stockQuoteDataModel.get(i).marketCap);
                logUtility.logMessage(stockQuoteDataModel.get(i).symbol+", "+stockQuoteDataModel.get(i).lastTradedPrice+", "+stockQuoteDataModel.get(i).change+", "+stockQuoteDataModel.get(i).changePercentage+", "+stockQuoteDataModel.get(i).volume+", "+stockQuoteDataModel.get(i).marketCap);
            }
        }
    }

    var queryNode = xmlDoc;
    if (queryNode) {
        i = 0;
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

function refreshNewsModel(responseXML){
    if (!(responseXML && newsDataModel)) return;

    var xmlDoc = responseXML.documentElement;
    var channel = xmlDoc.firstChild;

    //Not the best code I ever wrote, but got no choice
    //Refer to Memory leak issue with XMLListModel --> http://bugreports.qt.nokia.com/browse/QTBUG-15191

    if (channel) {
        var itemNodes = channel.childNodes;
        if (itemNodes){

            logUtility.logMessage("Clearing News Model");
            newsDataModel.clear();

            var i = 0;
            for (i = 0; i < itemNodes.length; i++) {

                if (itemNodes[i].nodeName === 'item'){
                    var newsElements = itemNodes[i].childNodes;
                    var j = 0;
                    var newsTitle,newsLink
                    for (j = 0; j < newsElements.length; j++){

                        switch (newsElements[j].nodeName){
                            case 'title':
                                newsTitle = newsElements[j].childNodes[0].nodeValue;
                                break;
                            case 'link':
                                newsLink = newsElements[j].childNodes[0].nodeValue;
                                break;
                            default:
                        }
                    }
                    newsDataModel.append({"title":newsTitle,"link":newsLink});
                    //logUtility.logMessage("Title: "+newsDataModel.get(i).title+", Link: "+ newsDataModel.get(i).link);
                    //logUtility.logMessage("Title: "+newsTitle+", Link: "+ newsLink);
                }
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
        var queryURL = 'http://query.yahooapis.com/v1/public/yql?q=select Symbol,Name,LastTradePriceOnly,Change,ChangeinPercent,Volume,MarketCapitalization from yahoo.finance.quotes where symbol in ('+query+')&env=store://datatables.org/alltableswithkeys';
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

function reloadNews(){
    if (!rssURL || rssURL == "Unknown") {
        logUtility.logMessage("Invalid RSS URL: "+rssURL);
    }
    else{
        logUtility.logMessage("Reloading news from "+rssURL);
        //var queryURL = "http://finance.yahoo.com/rss/topstories";
        logUtility.logMessage(rssURL);
        var response = new XMLHttpRequest();
        response.onreadystatechange = function() {
            if (response.readyState == XMLHttpRequest.DONE) {
                refreshNewsModel(response.responseXML);
                logUtility.logMessage("News Reload Completed..");
            }
        }

        response.open("GET", rssURL);
        response.send();
    }
}


function loadSettings(){
    var value;
    value  = DBUtility.getSetting("UpdateFreqency");
    if (!value || value == "0.0" || value === "" || isNaN(value)){
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

/*
    value  = DBUtility.getSetting("UpdateOnSavedNetworksOnly");
    if (!value || value == "0.0" || value === ""){
        updateOnSavedNetworksOnly = false;
    }
    else{
        updateOnSavedNetworksOnly = true;
    }
*/

    value  = DBUtility.getSetting("RSSURL");
    if (!value || value == "Unknown" || value === ""){
        //Do Nothing
    }
    else{
        rssURL = value;
    }
}

function initialize(){
    if (autoUpdateTimer.running) autoUpdateTimer.stop();
    loadSettings();
    reloadQuotes();
    reloadNews();

    if (autoUpdateInterval !== 0) {
        logUtility.logMessage("Starting Timer..");
        autoUpdateTimer.start();
    }
}
