/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

Item {

    width: 800
    height: 380

    id: stockDetailsComponent
    property int itemHeight: 50
    property string symbol: "YHOO"
    property string stockName: "Yahoo"
    property string lastTradedPrice: ""
    property string lastTradedTime: ""
    property string change: ""
    property string changePercentage: ""
    property string dayLow: ""
    property string dayHigh: ""
    property string fiftyTwoWeekLow: ""
    property string fiftyTwoWeekHigh: ""
    property string marketVolume: ""
    property string prevClose: ""
    property string marketCap: ""
    property string chartURL: ""

    signal logRequest(string strMessage)

    Rectangle {
        anchors.fill: parent
        color:"#343434"

        Component.onCompleted: {
            loadDetails();
            if (symbol !== "") {
                chartURL = "http://chart.finance.yahoo.com/z?t=1d&q=&l=&z=m&p=s&a=v&p=s&lang=en-US&region=US&s="+symbol;
                stockDetailsLoader.sourceComponent = stockChartComponent;
                console.log(stockDetailsLoader.width + " x "+ stockDetailsLoader.height);
            }
        }

        function loadDetails(){
            if (symbol === "") return;

        }

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
            anchors {top: stockNameLabel.bottom;left: parent.left;leftMargin: 40;right: parent.right;rightMargin: 40}
            height: 125
            radius: 15

            Column{
                id: stockDetailsColumn
                anchors {top: parent.top; left: parent.left; leftMargin: 10}
                width: (parent.width - 10)

                StockDetailsRow{
                    label1: "Last Traded"
                    value1: lastTradedPrice
                    cell1Width: stockDetailsColumn.width/2

                    label2: "Day's Range"
                    value2: ((dayHigh != "" && dayLow != "")? (dayLow + " - " + dayHigh) : "")
                    cell2Width: stockDetailsColumn.width/2
                }

                StockDetailsRow{
                    label1: "Last Trade Time"
                    value1: lastTradedTime
                    cell1Width: stockDetailsColumn.width/2

                    label2: "52w Range"
                    value2: ((fiftyTwoWeekHigh != "" && fiftyTwoWeekLow != "")? (fiftyTwoWeekLow + " - " + fiftyTwoWeekHigh) : "")
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

        Loader {
          id: stockDetailsLoader
          anchors {top: stockDetailsSection.bottom;bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
          //width: parent.width
          width: 480
        }

        Component{
            id: stockChartComponent
            Rectangle {
                id: rectangleChart
                border.width: 1
                border.color: "#BFBFBF"
                color:"#2E2E2E"
                anchors {top: parent.top;topMargin: 5;bottom: parent.bottom; left: parent.left;leftMargin: 40;right: parent.right;rightMargin: 40}
                radius: 15
                Image {
                    anchors.fill: parent
                    id: name
                    source: chartURL
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}
