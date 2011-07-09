/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License

Based on Nokia Qt Quick Demos with copyright notice below.

Source: http://doc.qt.nokia.com/4.7-snapshot/demos-declarative-twitter-twittercore-titlebar-qml.html
*/

/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import Qt 4.7

Item {
    id: titleBar
    property string title: "Markets Today"
    property string buttonType: "Config"
    property bool displayMenu: false
    signal menuDisplayed
    signal settingsClicked
    signal closeClicked
    signal backClicked

    signal tickersClicked
    signal optionsClicked

    BorderImage { source: "images/titlebar.sci"; width: parent.width; height: parent.height + 14; y: -7 }

    Item {
        id: container
        width: parent.width; height: parent.height

        Component{
            id: contextMenuComponent
            MenuBar{
                onTickersClicked: titleBar.tickersClicked();
                onOptionsClicked: titleBar.optionsClicked();
            }
        }

        Loader {
            id: contextMenuLoader
            width: 350
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: 40
            z: 100
            visible: displayMenu

            onLoaded: {
                contextMenuLoader.state = "visible"
            }

            states: State {
                name: "visible"
                AnchorChanges { target: contextMenuLoader; anchors { bottom: undefined; top: container.top } }
                PropertyChanges { target: contextMenuLoader; anchors.topMargin: 5 }
            }

            transitions: Transition {
                AnchorAnimation { easing.type: Easing.OutQuart; duration: 500 }
            }
        }

        Text {
            id: categoryText            
            anchors {
                leftMargin: 5; rightMargin: 10
                centerIn: parent
            }
            elide: Text.ElideMiddle
            text: title
            font.bold: true; color: "White"; style: Text.Raised; styleColor: "Black"
            font.pixelSize: 18

            MouseArea{
                id: contextMenuMouseArea
                anchors.fill: parent
                onClicked: {
                    if (!displayMenu) {
                        displayMenu = true;
                        contextMenuLoader.sourceComponent = contextMenuComponent;
                    }
                    else{
                        displayMenu = false;
                    }
                }
            }
        }

        Component {
            id: configButton

            Rectangle {
                id: configButtonArea
                anchors.fill: parent
                color: "#00000000"

                Image {
                    source: "images/config.png"
                    width: 40; height: 40
                    anchors.centerIn: parent
                }

                MouseArea{
                  id: configButtonMouseArea
                  anchors.fill: parent
                  onClicked: {
                      titleBar.settingsClicked();
                  }
                }

                states: State {
                         name: "pressed"; when: configButtonMouseArea.pressed
                         PropertyChanges { target: configButtonArea; color: "#9a9a9a"}
                }
            }
        }

        Component {
            id: closeButton

            Rectangle {
                id: closeButtonArea
                anchors.fill: parent
                color: "#00000000"

                Image {
                    source: "images/close.png"
                    width: 32; height: 32
                    anchors.centerIn: parent
                }

                MouseArea{
                  id: closeButtonMouseArea
                  anchors.fill: parent
                  onClicked: titleBar.closeClicked();
                }

                states: State {
                         name: "pressed"; when: closeButtonMouseArea.pressed
                         PropertyChanges { target: closeButtonArea; color: "#9a9a9a"}
                }
            }
        }

        Component {
            id: backButton

            Rectangle {
                id: backButtonArea
                anchors.fill: parent
                color: "#00000000"

                Image {
                    source: "images/back.png"
                    width: 32; height: 32
                    anchors.centerIn: parent
                }
                MouseArea{
                  id: backButtonMouseArea
                  anchors.fill: parent
                  onClicked: titleBar.backClicked();
                }

                states: State {
                         name: "pressed"; when: backButtonMouseArea.pressed
                         PropertyChanges { target: backButtonArea; color: "#9a9a9a"}
                }
            }
        }

        Component {
            id: blankComponent

            Item{

            }
        }

        Loader {
            width: 80
            height: parent.height
            anchors.right: parent.right
            sourceComponent: buttonType == "Config" ? configButton : (buttonType == "Close"? closeButton: (buttonType == "Back"? backButton:blankComponent))
        }
    }
}
