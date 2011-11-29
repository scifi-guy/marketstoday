/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7
import "Library" as Library

Item {

    width: 800
    height: 380

    id: stockDetailsScreen
    property int componentWidth: width
    property int itemHeight: 50
    property string symbol: "YHOO"
    property string stockName: ""
    property string lastTradedPrice: ""
    property string lastTradedDateTime: ""
    property string change: ""
    property string changePercentage: ""
    property string daysRange: ""
    property string yearRange: ""
    property string marketVolume: ""
    property string prevClose: ""
    property string marketCap: ""
    property string baseChartURL: "http://chart.finance.yahoo.com/z?q=&l=&z=m&p=s&a=v&p=s&lang=en-US&region=US"
    property string chartURL: ""
    property string rssURL: ""

    property int currentScreenIndex: 1

    signal logRequest(string strMessage)
    signal loadChart(string duration)
    signal lockInLandscape()
    signal unlockOrientation()

    Rectangle {
        anchors.fill: parent
        color:"#343434"
        id: detailsRect

        Library.CustomGestureArea {
            anchors.fill: parent
            onSwipeLeft: detailsRect.switchScreen()
            onSwipeRight: detailsRect.switchScreen()
        }

        Component.onCompleted: {                                   
            if (symbol !== "") {
                loadDetails();
                loadNews();
                chartURL = baseChartURL+"&t=1d&s="+symbol;
            }
        }

        function switchScreen(){
            switch (currentScreenIndex){
            case 1:
                stockDetailsScreen.lockInLandscape();
                stockDetailsLoader.sourceComponent = stockChartComponent;
                currentScreenIndex = currentScreenIndex + 1;
                break;
            case 2:
                stockDetailsScreen.unlockOrientation();
                stockDetailsLoader.sourceComponent = stockDetailsComponent;
                currentScreenIndex = currentScreenIndex - 1;
                break;
            default:
                //Do Nothing
            }
            logRequest("currentScreenIndex = "+currentScreenIndex);
        }

        function loadDetails(){
            var queryURL = 'http://query.yahooapis.com/v1/public/yql?q=select Symbol,Name,LastTradePriceOnly,LastTradeDate,LastTradeTime,Change,ChangeinPercent,DaysRange,YearRange,Volume,PreviousClose,MarketCapitalization from yahoo.finance.quotes where symbol in ("'+symbol+'")&env=store://datatables.org/alltableswithkeys';
            logRequest("Loading stock details from "+queryURL);
            var response = new XMLHttpRequest();
            response.onreadystatechange = function() {
                if (response.readyState == XMLHttpRequest.DONE) {
                    refreshDetails(response.responseXML);
                }
            }

            response.open("GET", queryURL);
            response.send();
        }

        function loadNews(){
            rssURL = "http://feeds.finance.yahoo.com/rss/2.0/headline?region=US&lang=en-US&s="+symbol;
            logRequest("Loading news from "+rssURL);
            var response = new XMLHttpRequest();
            response.onreadystatechange = function() {
                if (response.readyState == XMLHttpRequest.DONE) {
                    refreshNewsModel(response.responseXML);
                }
            }

            response.open("GET", rssURL);
            response.send();
        }

        function refreshDetails(responseXML){
            if (!responseXML) return;
            var xmlDoc = responseXML.documentElement;
            var results = xmlDoc.firstChild;

            if (results) {
                var quoteNodes = results.childNodes;
                if (quoteNodes){
                    if (quoteNodes.length === 0) {
                        logRequest("No results for stock quote details");
                    }
                    else{
                        //We are only expecting one quote node per symbol.
                        var quoteElements = quoteNodes[0].childNodes;
                        var j = 0;
                        var lastTradedDate = "", lastTradedTime ="";
                        for (j = 0; j < quoteElements.length; j++){

                            if (quoteElements[j].childNodes[0]) {
                                switch (quoteElements[j].nodeName){
                                    case 'Name':
                                        stockName = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'LastTradePriceOnly':
                                        lastTradedPrice = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'LastTradeDate':
                                        lastTradedDate = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'LastTradeTime':
                                        lastTradedTime = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'Change':
                                        change = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'ChangeinPercent':
                                        changePercentage = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'DaysRange':
                                        daysRange = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'YearRange':
                                        yearRange = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'Volume':
                                        marketVolume = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'PreviousClose':
                                        prevClose = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    case 'MarketCapitalization':
                                        marketCap = quoteElements[j].childNodes[0].nodeValue;
                                        break;
                                    default:
                                }
                            }
                        }
                        if (lastTradedDate !== "") lastTradedDateTime = lastTradedDate + " " + lastTradedTime;
                    }
                }
            }
        }

        function refreshNewsModel(responseXML){
            if (!(responseXML && stockNewsDataModel)) return;

            var xmlDoc = responseXML.documentElement;
            var channel = xmlDoc.firstChild;

            //Not the best code I ever wrote, but got no choice
            //Refer to Memory leak issue with XMLListModel --> http://bugreports.qt.nokia.com/browse/QTBUG-15191

            if (channel) {
                var itemNodes = channel.childNodes;
                if (itemNodes){

                    logRequest("Clearing News Model");
                    stockNewsDataModel.clear();

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
                            stockNewsDataModel.append({"title":newsTitle,"link":newsLink});
                        }
                    }
                }
            }
        }

        ListModel{
            id: stockNewsDataModel
        }

        Component {
            id: stockNewsDelegate

            Item {
                id: newsWrapper; width: stockDetailsLoader.width; height: itemHeight
                Item {
                    anchors.fill: parent
                    Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: newsWrapper.height - 2; width: newsWrapper.width; y: 1 }
                    Text {
                        anchors {verticalCenter: parent.verticalCenter;left: parent.left;leftMargin: 10;right: parent.right}
                        text: title; font.pixelSize: 14
                        font.bold: false;
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight;
                        color: "white";
                        style: Text.Raised;
                        styleColor: "black"
                    }
                    Library.CustomGestureArea {
                        anchors.fill: parent
                        onDoubleClicked: {
                            logRequest("Opening news article: "+link);
                            Qt.openUrlExternally(link);
                        }
                        onSwipeLeft: detailsRect.switchScreen()
                        onSwipeRight: detailsRect.switchScreen()
                    }
                }
            }
        }

        Component {
            id: stockDetailsComponent

            Item {
                anchors.fill: parent

                Text {
                    id: stockNameLabel
                    anchors.top: parent.top
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30
                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 18; font.bold: true; elide: Text.ElideMiddle; color: "#B8B8B8"; style: Text.Raised; styleColor: "black"
                    text: (stockName != "")? (stockName +" ("+symbol+")"):symbol
                }


                Rectangle {
                    id: stockDetailsSection
                    border.width: 1
                    border.color: "#BFBFBF"
                    color:"#2E2E2E"
                    anchors {top: stockNameLabel.bottom;left: parent.left;right: parent.right}
                    height: 125
                    radius: 15

                    Column{
                        id: stockDetailsColumn
                        anchors {top: parent.top; left: parent.left; leftMargin: 10}
                        width: parent.width

                        StockDetailsRow{
                            label1: "Last Traded"
                            value1: lastTradedPrice
                            cell1Width: stockDetailsColumn.width/2

                            label2: "Day's Range"
                            value2: daysRange
                            cell2Width: stockDetailsColumn.width/2
                        }

                        StockDetailsRow{
                            label1: "Last Trade Time"
                            value1: lastTradedDateTime
                            cell1Width: stockDetailsColumn.width/2

                            label2: "52w Range"
                            value2: yearRange
                            cell2Width: stockDetailsColumn.width/2
                        }

                        StockDetailsRow{
                            label1: "Change"
                            value1: ((change != "" && changePercentage != "")? change + " ("+changePercentage+")":"")
                            cell1Width: stockDetailsColumn.width/2

                            label2: "Volume"
                            value2: marketVolume
                            cell2Width: stockDetailsColumn.width/2
                        }

                        StockDetailsRow{
                            label1: "Prev. Close"
                            value1: prevClose
                            cell1Width: stockDetailsColumn.width/2

                            label2: "Market Cap"
                            value2: marketCap
                            cell2Width: stockDetailsColumn.width/2
                        }
                    }
                }

                Rectangle{
                    border.width: 1
                    border.color: "#BFBFBF"
                    color:"#2E2E2E"
                    width: parent.width
                    anchors {top: stockDetailsSection.bottom;topMargin: 5;
                             bottom: parent.bottom;
                             left: parent.left;
                             right: parent.right}
                    ListView {
                        flickDeceleration: 500
                        anchors.fill: parent
                        model: stockNewsDataModel
                        delegate: stockNewsDelegate
                        focus:true
                        snapMode: ListView.SnapToItem
                    }
                }

            }
        }

        Loader {
          id: stockDetailsLoader
          anchors{top: parent.top; bottom: parent.bottom
                  left: parent.left; leftMargin: 10
                  right:  parent.right; rightMargin: 10}
          sourceComponent: stockDetailsComponent
        }


        Component{
            id: stockChartComponent

            Item {
                id: chartAreaWrapper
                anchors.fill: parent

                Rectangle {
                    id: chartArea
                    border.width: 1
                    border.color: "#BFBFBF"
                    //color:"#2E2E2E"
                    color:"white"
                    anchors { top: parent.top;topMargin: 40;
                              bottom: parent.bottom; bottomMargin: 40;
                              left: parent.left; right: parent.right}
                    radius: 10

                    Library.Loading { anchors.centerIn: parent; visible: chartImg.status == Image.Loading}

                    Image {
                        id: chartImg
                        anchors {left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter}
                        source: chartURL
                        sourceSize.width: 512
                        sourceSize.height: 288
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            switch(status){
                                case Image.Ready:
                                    logRequest("Image is ready");
                                    break;
                                case Image.Loading:
                                    logRequest("Image is loading");
                                    break;
                                case Image.Error:
                                    logRequest("Image loading failed");
                                    break;
                                default:
                                    logRequest("No image specified");
                                    break;
                            }

                        }

                        Connections{
                            target: stockDetailsScreen
                            onLoadChart: {
                                chartURL = baseChartURL+"&t="+duration+"&s="+symbol;
                                logRequest(chartURL);
                            }
                        }
                    }

                    Column {
                        width: 130
                        spacing: 20
                        anchors {top: parent.top; topMargin: 40; bottom: parent.bottom;
                                 right: chartArea.right;rightMargin: 10}

                        Row {
                            height: 40
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            Library.Button {
                                id: oneDayButton
                                text:  "1d"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("1d");
                            }

                            Library.Button {
                                id: fiveDayButton
                                text:  "5d"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("5d");
                            }
                        }

                        Row {
                            height: 40
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            Library.Button {
                                id: threeMonthButton
                                text:  "3m"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("3m");
                            }

                            Library.Button {
                                id: sixMonthButton
                                text:  "6m"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("6m");
                            }
                        }
                        Row {
                            height: 40
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            Library.Button {
                                id: oneYearButton
                                text:  "1y"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("1y");
                            }

                            Library.Button {
                                id: twoYearButton
                                text:  "2y"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("2y");
                            }
                        }
                        Row {
                            height: 40
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            Library.Button {
                                id: fiveYearButton
                                text:  "5y"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("5y");
                            }

                            Library.Button {
                                id: maxButton
                                text:  "max"
                                anchors { verticalCenter: parent.verticalCenter}
                                width: 50; height: 32
                                onClicked: loadChart("my");
                            }
                        }
                    }
                }
            }
        }
    }
}
