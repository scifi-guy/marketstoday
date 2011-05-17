TEMPLATE = app

QT += script \
    declarative \
    sql

TARGET = marketstoday
HEADERS += \
    cpp/marketstodayqmlview.h \
    cpp/configqmlview.h \
    cpp/logutility.h
SOURCES += cpp/main.cpp \
    cpp/marketstodayqmlview.cpp \
    cpp/configqmlview.cpp
VPATH += cpp

MOC_DIR = cpp/.mocs
OBJECTS_DIR = cpp/.objs

OTHER_FILES += qml/MarketsToday.qml \
    qml/Config.qml \
    qml/ConfigOptionsComponent.qml \
    qml/ConfigParametersComponent.qml \
    qml/ConfigTickersComponent.qml \
    qml/StockQuoteDelegate.qml \
    qml/StockQuotesComponent.qml \
    qml/Library/TitleBar.qml \
    qml/Library/ToolBar.qml \
    qml/Library/js/DBUtility.js \
    qml/Library/js/ISODate.js \
    qml/Library/js/Common.js

RESOURCES += \
    resources.qrc

INSTALLDIR = /../debian/marketstoday

symbian {

    TARGET.UID3 = 0xE6159209
    # Allow network access on Symbian
    TARGET.CAPABILITY += NetworkServices
}

unix {
   INSTALLS += target desktop icon48
   target.path = $$INTSALLDIR/opt/marketstoday/
   desktop.path = /usr/share/applications/hildon-home
   desktop.files += data/marketstoday.desktop
   icon48.path = /usr/share/icons/hicolor/48x48/apps
   icon48.files += data/icons/marketstoday.png
}

# Include Qt Maemo 5 Home screen widget adaptor
include(qmaemo5homescreenadaptor/qmaemo5homescreenadaptor.pri)
