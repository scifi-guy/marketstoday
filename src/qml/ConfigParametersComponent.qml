/*
@version: 0.4
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7
import "Library/js/DBUtility.js" as DBUtility

Item {
    id: configParametersComponent
    property bool updateFreqEnabled
    property string  updateFreqMin
    property bool updateWeekdaysOnly
    //property bool updateOnSavedNetworksOnly
    property string  rssURL: "http://finance.yahoo.com/rss/topfinstories"
    signal logRequest(string strMessage)

    Rectangle {
        id: updateConfig
        anchors.fill: parent
        color:"#343434"

        Component.onCompleted: {
                DBUtility.initialize();
                loadSettings();
        }

        Component.onDestruction:{
            logRequest("Saving settings");
            saveSettings();
        }

        function loadSettings(){
            var value;
            value  = DBUtility.getSetting("UpdateFreqency");
            if (!value || value == "0.0" || value === "" || isNaN(value)){
                configParametersComponent.updateFreqEnabled = false;
            }
            else{
                configParametersComponent.updateFreqEnabled = true;
                configParametersComponent.updateFreqMin = parseInt(value);
            }
            value  = DBUtility.getSetting("UpdateWeekdaysOnly");
            if (!value || value == "0.0" || value === ""|| !configParametersComponent.updateFreqEnabled){
                configParametersComponent.updateWeekdaysOnly = false;
            }
            else{
                configParametersComponent.updateWeekdaysOnly = true;
            }

/*
            value  = DBUtility.getSetting("UpdateOnSavedNetworksOnly");
            if (!value || value == "0.0" || value === ""){
                configParametersComponent.updateOnSavedNetworksOnly = false;
            }
            else{
                configParametersComponent.updateOnSavedNetworksOnly = true;
            }
*/

            value  = DBUtility.getSetting("RSSURL");
            if (!value || value == "Unknown" || value === ""){
                //configParametersComponent.rssURL = configParametersComponent.defaultRSSFeed;
            }
            else{
                configParametersComponent.rssURL = value;
            }
        }

        function saveSettings(){
            if (isNaN(configParametersComponent.updateFreqMin))
                DBUtility.setSetting("UpdateFreqency","");
            else
                DBUtility.setSetting("UpdateFreqency",configParametersComponent.updateFreqMin);

            DBUtility.setSetting("UpdateWeekdaysOnly",(configParametersComponent.updateWeekdaysOnly?1:0));
            //DBUtility.setSetting("UpdateOnSavedNetworksOnly",(configParametersComponent.updateOnSavedNetworksOnly?1:0));
            DBUtility.setSetting("RSSURL",configParametersComponent.rssURL);
        }

        Text {
            id: newsSectionLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 35
            height: 50
            horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
            font.pixelSize: 22; font.bold: true; elide: Text.ElideRight; color: "#B8B8B8"; style: Text.Raised; styleColor: "black"
            text: "News Feed"
        }

        Rectangle {
            id: newsSection
            border.width: 1
            border.color: "#BFBFBF"
            color:"#2E2E2E"
            anchors.top: newsSectionLabel.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30
            height: 60
            radius: 15

            Row {
                id: rowRSSURL
                //anchors.top: parent.top
                //anchors.topMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                height: 50
                spacing: 5

                Text{
                    height:parent.height
                    horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
                    text: "RSS URL: "
                    color: "#ffffff";
                }

                Item {
                    height: 40
                    //updateConfig.width > updateConfig.height?
                    width:  parent.width*3/4
                    BorderImage { source: "Library/images/lineedit.sci"; anchors.fill: parent }
                    TextInput{
                        id: txtRSSURL
                        height: parent.height
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        focus: true
                        text: configParametersComponent.rssURL
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 18
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase
                        onTextChanged: {
                            configParametersComponent.rssURL = txtRSSURL.text;
                        }
                    }
                }
            }
        }

        Text {
            id: autoUpdateSectionLabel
            anchors.top: newsSection.bottom
            //anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 35
            height: 50
            horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
            font.pixelSize: 22; font.bold: true; elide: Text.ElideRight; color: "#B8B8B8"; style: Text.Raised; styleColor: "black"
            text: "Auto-Update *"
        }

        Rectangle {
            id: autoUpdateSection
            border.width: 1
            border.color: "#BFBFBF"
            color:"#2E2E2E"
            anchors.top: autoUpdateSectionLabel.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30
            height: 120
            radius: 15

            Row {
                id: rowUpdateFreq
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                height: 50
                spacing: 5

                Image {
                    id: checkboxUpdateFreqImg
                    source: configParametersComponent.updateFreqEnabled? "Library/images/checkbox_checked.png":"Library/images/checkbox_unchecked.png"
                    width: 32; height: 32
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            configParametersComponent.updateFreqEnabled = !configParametersComponent.updateFreqEnabled;
                            if (!configParametersComponent.updateFreqEnabled){
                                txtUpdateFreqMin.text = "";
                                configParametersComponent.updateWeekdaysOnly = false;
                            }
                        }
                    }
                }

                Text{
                    height:parent.height
                    horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
                    text: "Every "
                    color: configParametersComponent.updateFreqEnabled? "#ffffff" :"#B8B8B8";
                }
                Item {
                    height: 40
                    width: 80
                    BorderImage { source: "Library/images/lineedit.sci"; anchors.fill: parent }
                    TextInput{                        
                        id: txtUpdateFreqMin
                        anchors.fill: parent
                        focus: true
                        text: configParametersComponent.updateFreqMin
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 18
                        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                        onTextChanged: {
                            configParametersComponent.updateFreqMin = txtUpdateFreqMin.text;
                        }
                    }
                }
                Text{
                    height:parent.height
                    horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
                    text: " minutes"
                    color: configParametersComponent.updateFreqEnabled? "#ffffff" :"#B8B8B8";
                }
            }
            Row {
                id: rowUpdateDays
                anchors.top: rowUpdateFreq.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                height: 50
                spacing: 5

                Image {
                    id: checkboxUpdateWeekdays
                    source: configParametersComponent.updateWeekdaysOnly? "Library/images/checkbox_checked.png":"Library/images/checkbox_unchecked.png"
                    width: 32; height: 32
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            configParametersComponent.updateWeekdaysOnly = !configParametersComponent.updateWeekdaysOnly;
                        }
                    }
                }

                Text{
                    height:parent.height
                    horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
                    text: "Only on weekdays"
                    color: configParametersComponent.updateWeekdaysOnly? "#ffffff" :"#B8B8B8";
                }
            }
/*
            Row {
                id: rowUpdateConnections
                anchors.top: rowUpdateDays.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                height: 50
                spacing: 5

                Image {
                    id: checkboxUpdateKnownConnections
                    source: configParametersComponent.updateOnSavedNetworksOnly? "Library/images/checkbox_checked.png":"Library/images/checkbox_unchecked.png"
                    width: 32; height: 32
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            configParametersComponent.updateOnSavedNetworksOnly = !configParametersComponent.updateOnSavedNetworksOnly;
                        }
                    }
                }

                Text{
                    height:parent.height
                    horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black"
                    text: "Only on saved Wifi connections"
                    color: configParametersComponent.updateOnSavedNetworksOnly? "#ffffff" :"#B8B8B8";
                }
            }
*/
        }

        Rectangle{
            id: footerText
            width: parent.width
            height: 25
            color: "#343434"
            anchors.bottom: parent.bottom
            Text {
                id: footerMessage
                anchors.fill: parent
                text: "* Quotes will be auto-updated only when the application/widget is running."
                horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                width: parent.width; font.pixelSize: 12; elide: Text.ElideRight;
                color: "#cccccc"
                style: Text.Raised; styleColor: "black"
            }
        }
    }
}
