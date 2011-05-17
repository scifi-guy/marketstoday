/*
@version: 0.1
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
            if (!value || value == "0.0" || value == ""){
                configParametersComponent.updateFreqEnabled = false;
            }
            else{
                configParametersComponent.updateFreqEnabled = true;
                configParametersComponent.updateFreqMin = parseInt(value);
            }
            value  = DBUtility.getSetting("UpdateWeekdaysOnly");
            if (!value || value == "0.0" || value == ""){
                configParametersComponent.updateWeekdaysOnly = false;
            }
            else{
                configParametersComponent.updateWeekdaysOnly = true;
            }
        }

        function saveSettings(){
            DBUtility.setSetting("UpdateFreqency",configParametersComponent.updateFreqMin);
            DBUtility.setSetting("UpdateWeekdaysOnly",(configParametersComponent.updateWeekdaysOnly?1:0));
        }

        Text {
            id: autoUpdateSectionLabel
            anchors.top: parent.top
            //anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 45
            height: 50
            horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
            font.pixelSize: 22; font.bold: true; elide: Text.ElideRight; color: "#B8B8B8"; style: Text.Raised; styleColor: "black"
            text: "Auto-Update"
        }

        Rectangle {
            id: autoUpdateSection
            border.width: 1
            border.color: "#BFBFBF"
            color:"#2E2E2E"
            anchors.top: autoUpdateSectionLabel.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
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
        }
    }
}
