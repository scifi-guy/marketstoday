/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7
import "Library/js/DBUtility.js" as DBUtility

Item {
    id: tickerTab
    property int componentWidth
    property int itemHeight
    signal logRequest(string strMessage)

    Component.onCompleted: {
            DBUtility.initialize();
            loadSymbols();
    }

    function loadSymbols(){
        var symbolsArray = DBUtility.getAllSymbols();
        if (symbolsArray && symbolsArray.length > 0){
            var i = 0;
            for (i = 0; i< symbolsArray.length; i++) {
                logRequest("Appending "+symbolsArray[i]+ " to ListModel");
                symbolsListModel.append({"symbol": symbolsArray[i]});
            }
            logRequest("ListModel count is  "+symbolsListModel.count);
        }
    }

    function removeSymbol(symbol,index){
        logRequest("Removing symbol "+symbol+" at index "+index);

        var result = DBUtility.removeSymbol(symbol);
        if (result != "Error"){
            symbolsListModel.remove(index);
        }
        else{
            logRequest("Error: DB error while removing "+symbol+" at index "+index);
        }

    }

    function addSymbol(symbol){
        if (symbol && symbol.length > 0){
            symbol = symbol.toUpperCase();
            logRequest("Adding symbol "+symbol);
            var result = DBUtility.addSymbol(symbol);
            logRequest("Result is "+result);

            if (result != "Error"){
                symbolsListModel.append({"symbol": symbol});
            }
            else{
                logRequest("Error: DB error while adding "+symbol);
            }
        }
        else{
            logRequest("Error: Invalid symbol "+symbol);
        }                
    }

    ListModel {
        id: symbolsListModel
    }

    Component {
        id: tickersListDelegate

        Item {
            id: wrapper; width: componentWidth; height: itemHeight
            Rectangle { id: listRecord;
                color: "black";
                opacity: index % 2 ? 0.2 : 0.4;
                height: parent.height - 2;
                width: parent.width; y: 1 }

            Text {
                text: symbol;
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                width: parent.width - 120;
                height: parent.height
                font.pixelSize: 18;
                font.bold: true;
                elide: Text.ElideRight;
                color: "white";
                style: Text.Raised;
                styleColor: "black"
            }

            Rectangle {
                id: removeButtonArea
                width: 120
                height: parent.height
                anchors.right: parent.right
                color: "#00000000";

                Image {
                    source: "Library/images/remove.png"
                    anchors.centerIn: parent
                    width: 32; height: 32
                }

                MouseArea{
                    id:removeButtonMouseArea
                    anchors.fill: parent
                    onClicked: {
                        removeSymbol(symbol,index)
                    }
                }

                states: State {
                         name: "pressed"; when: removeButtonMouseArea.pressed
                         PropertyChanges { target: removeButtonArea; color: "#9a9a9a"}
                }
            }
        }
    }

    Rectangle {
        id: newSymbolRow
        //width: parent.width
        width: componentWidth
        height: itemHeight;
        anchors.top: parent.top
        color: "#343434"

        Item {
            id: lineEditItem
            width: parent.width - 120
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            BorderImage { source: "Library/images/lineedit.sci"; anchors.fill: parent }
            TextInput{
                id: newSymbol
                width: parent.width
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                maximumLength:25
                font.pixelSize: 18
                font.bold: true
                font.capitalization: Font.AllUppercase                
                inputMethodHints: Qt.ImhNoPredictiveText
                color: "#151515"; selectionColor: "green"
                KeyNavigation.tab: addButton
                Keys.onReturnPressed: {
                    logRequest("Return pressed");
                    addSymbol(newSymbol.text.trim());
                    newSymbol.text = "";
                    newSymbol.closeSoftwareInputPanel();
                }
                Keys.onEnterPressed: {
                    logRequest("Enter pressed");
                    addSymbol(newSymbol.text.trim());
                    newSymbol.text = "";
                    newSymbol.closeSoftwareInputPanel();
                }
                focus: true
            }
        }

        Rectangle {
            id: addButtonArea
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: 120
            height: parent.height
            color:"#343434"
            Image {
                id: addButton
                source: "Library/images/add.png"
                width: 32; height: 32
                anchors.centerIn: parent
            }
            MouseArea{
                id:addButtonMouseArea
                anchors.fill: parent
                onClicked: {
                     addSymbol(newSymbol.text.trim());
                     newSymbol.text = "";
                     newSymbol.closeSoftwareInputPanel();
                }
            }
            states: State {
                     name: "pressed"; when: addButtonMouseArea.pressed
                     PropertyChanges { target: addButtonArea; color: "#9a9a9a"}
            }
        }
    }
    Rectangle{
        anchors.top: newSymbolRow.bottom
        anchors.bottom: parent.bottom
        width: parent.width;

        color:"#343434"
        ListView{
            id: symbolsListView
            anchors.fill: parent
            model: symbolsListModel
            delegate: tickersListDelegate
        }

    }
}
