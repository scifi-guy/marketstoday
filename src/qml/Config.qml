/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7
import "Library" as Library

Rectangle {
    id: screen

    width: 800; height: 480

    property int componentWidth: screen.width
    property int itemHeight: 50

    function close(){
        Qt.quit();
    }

    function back(){
        configArea.sourceComponent = configParentComponent;
        titleBar.buttonType = "Close";
    }    

    Library.TitleBar {
        id: titleBar; width: parent.width; height: 60;
        anchors.top: parent.top
        title: "Markets Today - Configuration"
        buttonType: "Close"
        onCloseClicked: close()
        onBackClicked: back()
    }

    Loader {
        id: configArea
        sourceComponent: configParentComponent
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
    }

    Component {
        id: configParentComponent
        ConfigOptionsComponent {
            id: configOptionsComponent
            onTickersOptionSelected: {
                configArea.sourceComponent = tickersComponent;
                titleBar.buttonType = "Back";
            }
            onSettingsOptionSelected: {
                configArea.sourceComponent = settingsComponent;
                titleBar.buttonType = "Back";
            }
        }
    }

    Component {
        id: tickersComponent
        ConfigTickersComponent {
            id: tickersTab
            anchors.fill: parent
            componentWidth: screen.componentWidth
            itemHeight: screen.itemHeight
            onLogRequest: logUtility.logMessage(strMessage)

        }
    }

    Component {
        id: settingsComponent
        ConfigParametersComponent {
            id: settingsTab
            anchors.fill: parent
            onLogRequest: logUtility.logMessage(strMessage)
        }
    }
}
