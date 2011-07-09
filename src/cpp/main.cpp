/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#include "qmaemo5homescreenadaptor.h"
#include "marketstodayqmlview.h"

#include <QtGui>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDebug>
#include <QNetworkConfigurationManager>
#include <QGraphicsObject>
#include "logutility.h"
#include "connectionutility.h"

int main(int argc, char *argv[])
{

    bool isDesktopWidget = false;

    if (argc > 2 && QString(argv[1]).contains("-plugin-id")) {
        isDesktopWidget = true;
    }

    QApplication app(argc, argv);

    QNetworkConfigurationManager manager;
    ConnectionUtility connectionUtility;

    //Signal to check available networks when auto-update is triggered
    QObject::connect(&manager,SIGNAL(updateCompleted()),&connectionUtility,SLOT(connectionListUpdated()));


    MarketsTodayQMLView qmlView;

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
    //For maemo fremantle or harmattan use a common path
    qmlView.engine()->setOfflineStoragePath("/home/user/.marketstoday/OfflineStorage");
#else
    qmlView.engine()->setOfflineStoragePath("qml/OfflineStorage");
#endif
    qmlView.setResizeMode(QDeclarativeView::SizeRootObjectToView);    
    qmlView.setWindowTitle("Markets Today");
    qmlView.setFixedSize(400,325);    

    LogUtility logUtility;
    logUtility.logMessage(qmlView.engine()->offlineStoragePath());

    if (isDesktopWidget) {
        QMaemo5HomescreenAdaptor *adaptor = new QMaemo5HomescreenAdaptor(&qmlView);
        adaptor->setSettingsAvailable(true); //Use the standard widget settings button for home screen widget
        QObject::connect(adaptor, SIGNAL(settingsRequested()), &qmlView, SLOT(displayConfigWindow()));        

        qmlView.setSource(QUrl("qrc:/qml/MarketsTodayWidget.qml"));
        qmlView.show();
    }
    else{
        qmlView.setSource(QUrl("qrc:/qml/MarketsTodayApp.qml"));
        qmlView.showFullScreen();
    }

    QObject *rootObject = qmlView.rootObject();
    //Signal to display config window when user clicks config icon
    //QObject::connect(rootObject, SIGNAL(showConfigInNewWindow()), &qmlView, SLOT(displayConfigWindow()));
    //Signal to reload configuration and update quotes after config window is clicked
    QObject::connect(&qmlView, SIGNAL(initializeWidget()), rootObject, SLOT(initialize()));

    QObject::connect(rootObject, SIGNAL(checkNetworkStatus()), &connectionUtility, SLOT(checkConnectionStatus()));
    QObject::connect(&connectionUtility, SIGNAL(connectionsAvailable()), rootObject, SLOT(reloadQuotes()));
    QObject::connect((QObject*)qmlView.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    app.exec();
}
