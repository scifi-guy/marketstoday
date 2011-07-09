/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

import Qt 4.7

Item {
    id: toolbar
    property bool updatePending: false
    property bool displayIcons: true
    property bool displayNavigation: false
    property int componentHeight: toolbar.height

    signal reloadButtonClicked
    signal downButtonClicked
    signal upButtonClicked
    signal newsButtonClicked

    BorderImage { source: "images/toolbar.sci"; width: parent.width; height: parent.height + 14; y: -7 }

    Rectangle {
        id: reloadButtonArea
        width: 60
        height: parent.height
        anchors.left: parent.left
        color: "#00000000"
        visible: toolbar.displayIcons

        Image {
            id: reloadButton
            source: "images/reload.png"
            width: 32; height: 32
            anchors.centerIn: parent

            NumberAnimation on rotation {
                from: 0; to: 360; running: toolbar.updatePending == true; loops: Animation.Infinite; duration: 900
            }
        }

        MouseArea{
          id: reloadButtonMouseArea
          anchors.fill: parent
          onClicked: {
              toolbar.updatePending = true;
              toolbar.reloadButtonClicked();
          }
        }

        states: State {
                 name: "pressed"; when: reloadButtonMouseArea.pressed
                 PropertyChanges { target: reloadButtonArea; color: "#9a9a9a"}
        }
    }

    Rectangle {
        id: downButtonArea
        width: 60
        height: parent.height
        anchors.right: parent.horizontalCenter; anchors.horizontalCenterOffset: -60;
        color: "#00000000"
        visible: (toolbar.displayIcons && toolbar.displayNavigation)

        Image {
            id: downButton
            source: "images/down.png"
            width: 32; height: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
        }

        MouseArea{
          id: downButtonMouseArea
          anchors.fill: parent
          onClicked: toolbar.downButtonClicked()
        }

        states: State {
                 name: "pressed"; when: downButtonMouseArea.pressed
                 PropertyChanges { target: downButtonArea; color: "#9a9a9a"}
        }
    }


    Rectangle {
        id: upButtonArea
        width: 60
        height: parent.height
        anchors.left: parent.horizontalCenter; anchors.horizontalCenterOffset: 60;
        color: "#00000000"
        visible: (toolbar.displayIcons && toolbar.displayNavigation)

        Image {
            id: upButton
            source: "images/up.png"
            width: 32; height: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        MouseArea{
          id: upButtonMouseArea
          anchors.fill: parent
          onClicked: toolbar.upButtonClicked()
        }

        states: State {
                 name: "pressed"; when: upButtonMouseArea.pressed
                 PropertyChanges { target: upButtonArea; color: "#9a9a9a"}
        }
    }



    Rectangle {
        id: newsButtonArea
        width: 60
        height: parent.height
        anchors.right: parent.right
        color: "#00000000"
        visible: toolbar.displayIcons

        Image {
            id: newsButton
            source: "images/news.png"
            width: 32; height: 32
            anchors.centerIn: parent
        }

        MouseArea{
          id: newsButtonMouseArea
          anchors.fill: parent
          onClicked: toolbar.newsButtonClicked()
        }

        states: State {
                 name: "pressed"; when: newsButtonMouseArea.pressed
                 PropertyChanges { target: newsButtonArea; color: "#9a9a9a"}
        }
    }

}
