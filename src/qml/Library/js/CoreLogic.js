/*
@version: 0.4
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

var strErrorMessage;

function reloadQuotes(){
    var query = getQuery();
    if (query){
        quoteRefreshStarted();
        logUtility.logMessage("Reloading Data..");

        //var queryURL = 'http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol in ("INDU","^IXIC","^GSPC","CLJ11.NYM","YHOO","AAPL","GOOG","MSFT")&env=store://datatables.org/alltableswithkeys';
        var queryURL = 'http://query.yahooapis.com/v1/public/yql?q=select Symbol,Name,LastTradePriceOnly,Change,ChangeinPercent,Volume,MarketCapitalization from yahoo.finance.quotes where symbol in ('+query+')&env=store://datatables.org/alltableswithkeys';
        logUtility.logMessage(queryURL);

        var response = new XMLHttpRequest();
        response.onreadystatechange = function() {
            if (response.readyState == XMLHttpRequest.DONE) {
                var success = refreshDataModel(response);
                if (success === true){
                    logUtility.logMessage("Data Reload Completed..");
                }
                else{
                    logUtility.logMessage("Data Reload Failed..");
                }
                quoteRefreshCompleted(success,strErrorMessage);
            }
        }

        response.open("GET", queryURL);
        response.send();
    }
    else{
        logUtility.logMessage("No stock symbols found in configuration.");
        if (!isDesktopWidget)
            strErrorMessage = "Tap the title bar to add stock tickers and update settings."
        else
            strErrorMessage = "Use the widget settings screen to add stock tickers and update configuration."
        stockQuoteDataModel.clear();
        quoteRefreshCompleted(false,strErrorMessage);
    }
}

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

function reloadNews(){
    if (!rssURL || rssURL == "Unknown") {
        logUtility.logMessage("Invalid RSS URL: "+rssURL);
    }
    else{
        logUtility.logMessage("Reloading news from "+rssURL);
        //var queryURL = "http://finance.yahoo.com/rss/topfinstories";
        logUtility.logMessage(rssURL);
        var response = new XMLHttpRequest();
        response.onreadystatechange = function() {
            if (response.readyState == XMLHttpRequest.DONE) {
                var success = refreshNewsModel(response);
                if (success === true){
                    logUtility.logMessage("News Reload Completed..");
                }
                else{
                    logUtility.logMessage("News Reload Failed..");
                }
                newsReloadCompleted(success,strErrorMessage);
            }
        }

        response.open("GET", rssURL);
        response.send();
    }
}

function refreshDataModel(response){
    var status = false;   
    if (!response.responseXML) {
        //This shouldn't happen
        strErrorMessage = "Error occurred while loading stock quotes."
        if (response.responseText)
            logUtility.logMessage(response.responseText);
        else
            logUtility.logMessage("No responseXML for quotes");
        return status;
    }

    var xmlDoc = response.responseXML.documentElement;
    var results = xmlDoc.firstChild;

    //Not the best code I ever wrote, but got no choice
    //Refer to Memory leak issue with XMLListModel --> http://bugreports.qt.nokia.com/browse/QTBUG-15191

    if (results) {
        var quoteNodes = results.childNodes;
        if (quoteNodes && quoteNodes.length > 0){
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

            status = true;
        }
        else
        {
            strErrorMessage = "Quotes could not be fetched from Yahoo! Finance. Please verify the tickers and try again later."
            logUtility.logMessage(response.responseText);
            status = false;
        }
    }
    else{
        strErrorMessage = "Stock quote data from Yahoo! Finance is currently not available. Please try again later."
        logUtility.logMessage(response.responseText);
        status = false;
    }


    var queryNode = xmlDoc;
    if (queryNode) {
        i = 0;
        var queryAttributes = queryNode.attributes;
        for (i = 0; i < queryAttributes.length; i++) {
            if (queryAttributes[i].name == 'created') {
                lastUpdatedTimeStamp = "Updated: "+DateLib.ISODate.format(queryAttributes[i].value);
                logUtility.logMessage(lastUpdatedTimeStamp);
                break;
            }
        }
    }

    return status;
}

function refreshNewsModel(response){
    var status = false;
    if (!response.responseXML) {
        //This shouldn't happen
        strErrorMessage = "Error occurred while loading news."
        if (response.responseText)
            logUtility.logMessage(response.responseText);
        else
            logUtility.logMessage("No responseXML for news");
        return status;
    }

    //Not the best code I ever wrote, but got no choice
    //Refer to Memory leak issue with XMLListModel --> http://bugreports.qt.nokia.com/browse/QTBUG-15191


    var xmlDoc = response.responseXML.documentElement;
    //var channel = xmlDoc.firstChild; Doesn't work with some RSS providers. THANK YOU, YAHOO

    var channel;

    var i = 0;
    for (i = 0; i < xmlDoc.childNodes.length; i++){
        if (xmlDoc.childNodes[i].nodeName === 'channel') {
            channel = xmlDoc.childNodes[i];
            break;
        }
    }

    if (channel) {
        var itemNodes = channel.childNodes;
        if (itemNodes){

            logUtility.logMessage("Clearing News Model");
            newsDataModel.clear();
            logUtility.logMessage("No. of news stories = "+itemNodes.length);

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
            status = true;
        }
        else{
            strErrorMessage = "The RSS feed did not contain any news stories. Please try again later."
            logUtility.logMessage(response.responseText);
            status = false;
        }
    }
    else{
        strErrorMessage = "The RSS feed did not return valid data. Please check the URL and try again later."
        logUtility.logMessage(response.responseText);
        status = false;
    }

    return status;
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
    else if (value === 'http://finance.yahoo.com/rss/topstories'){
        /*
          Yahoo changed their Top New rss feed from http://finance.yahoo.com/rss/topstories to http://finance.yahoo.com/rss/topfinstories.
          Since the application has a hardcoded default rss feed, it is better to update it here. Not sure if this is the best way to deal with such changes.
         */

            rssURL = "http://finance.yahoo.com/rss/topfinstories";
            DBUtility.setSetting("RSSURL",rssURL);
    }
    else
    {
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
