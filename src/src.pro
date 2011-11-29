TEMPLATE = app

CONFIG += debug

exists($$QMAKE_INCDIR_QT"/../qmsystem2/qmkeys.h"){
   DEFINES += Q_WS_MAEMO_6
}

QT += script \
    declarative \
    sql \
    network

TARGET = marketstoday
HEADERS += \
    cpp/marketstodayqmlview.h \
    cpp/configqmlview.h \
    cpp/logutility.h \
    cpp/connectionutility.h \
    cpp/sharedcontext.h

SOURCES += cpp/main.cpp \
    cpp/marketstodayqmlview.cpp \
    cpp/configqmlview.cpp
VPATH += cpp

MOC_DIR = cpp/.mocs
OBJECTS_DIR = cpp/.objs

OTHER_FILES += \
    qml/Config.qml \
    qml/ConfigOptionsComponent.qml \
    qml/ConfigParametersComponent.qml \
    qml/ConfigTickersComponent.qml \
    qml/Library/TitleBar.qml \
    qml/Library/ToolBar.qml \
    qml/Library/js/DBUtility.js \
    qml/Library/js/ISODate.js \
    qml/Library/js/Common.js \
    qml/Library/js/XMLParser.js \
    qml/Library/js/CoreLogic.js \
    qml/MarketsTodayWidget.qml \
    qml/MarketsTodayApp.qml \
    qml/Library/MenuBar.qml \
    qml/Library/Button.qml \
    qml/StockDetailsComponent.qml \
    qml/StockDetailsRow.qml \
    qml/Library/Loading.qml \
    qml/MarketsTodayLegacyApp.qml \
    qml/Library/CustomGestureArea.qml \
    qml/StockDetailsComponentLegacy.qml

RESOURCES += \
    resources.qrc

symbian {

    TARGET.UID3 = 0xE6159209
    # Allow network access on Symbian
    TARGET.CAPABILITY += NetworkServices ReadUserData
}
else:unix {   
   INSTALLDIR = /../debian/marketstoday
   INSTALLS += target app icon26 icon32 icon48 icon64 appicon

   # Maemo 5 specific paths (The exists function is used to make sure the widget is deployed to FREMANTLE_X86 target in Scratchbox
   # Scratchbox is not identified as maemo or maemo5 platform
   maemo5 | exists(/usr/bin/hildon-home) {
    message("Deploying widget")

    INSTALLS += widget
    widget.path = /usr/share/applications/hildon-home
    widget.files += data/marketstoday-widget.desktop
    app.path = /usr/share/applications/hildon
    app.files += data/marketstoday-app.desktop
   }
   else{
    app.path = /usr/share/applications
    app.files += data/marketstoday-app-meego.desktop   
   }

   target.path = $$INTSALLDIR/opt/marketstoday/

   icon26.path = /usr/share/icons/hicolor/26x26/apps
   icon26.files += data/icons/26x26/marketstoday.png

   icon32.path = /usr/share/icons/hicolor/32x32/apps
   icon32.files += data/icons/32x32/marketstoday.png

   icon48.path = /usr/share/icons/hicolor/48x48/apps
   icon48.files += data/icons/48x48/marketstoday.png

   icon64.path = /usr/share/icons/hicolor/64x64/apps
   icon64.files += data/icons/64x64/marketstoday.png

   appicon.path = /usr/share/icons/hicolor/80x80/apps
   appicon.files += data/icons/marketstoday_icon.png
}

# Include Qt Maemo 5 Home screen widget adaptor
include(qmaemo5homescreenadaptor/qmaemo5homescreenadaptor.pri)








