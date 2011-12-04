/*
@version: 0.4
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#include "qmaemo5homescreenadaptor.h"
#include "marketstodayqmlview.h"

#include <QtGui>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDebug>
//#include <QNetworkConfigurationManager>
#include <QDir>
#include <QGraphicsObject>
#include "logutility.h"
#include "connectionutility.h"
#include "sharedcontext.h"

int main(int argc, char *argv[])
{

    bool isDesktopWidget = false;

    if (argc > 2 && QString(argv[1]).contains("-plugin-id")) {
        isDesktopWidget = true;
    }

    QApplication app(argc, argv);

    //QNetworkConfigurationManager manager;
    //ConnectionUtility connectionUtility;

    //Signal to check available networks when auto-update is triggered
    //QObject::connect(&manager,SIGNAL(updateCompleted()),&connectionUtility,SLOT(connectionListUpdated()));


    MarketsTodayQMLView qmlView;

    QString strPath;

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
    //For maemo fremantle or harmattan use a common path
    strPath = QDir().homePath() + "/.marketstoday/OfflineStorage";
    QDir configDir(strPath);
    qDebug() << "Config path is " << strPath;
    if (!configDir.exists()){
        bool created = configDir.mkpath(strPath);
        if (!created){
            qDebug() << "Unable to create config directory at " << strPath;
        }
    }
    qmlView.engine()->setOfflineStoragePath(strPath);
#else
    qmlView.engine()->setOfflineStoragePath("qml/OfflineStorage");
#endif

    qmlView.setResizeMode(QDeclarativeView::SizeRootObjectToView);    
    qmlView.setWindowTitle("Markets Today"); 

    LogUtility logUtility;
    logUtility.logMessage(qmlView.engine()->offlineStoragePath());

    SharedContext *sharedContextObj = new SharedContext(&qmlView);
    sharedContextObj->setComponentToDisplay("StockQuotesUI");
    qmlView.rootContext()->setContextProperty("sharedContext",sharedContextObj);


    if (isDesktopWidget) {
        QMaemo5HomescreenAdaptor *adaptor = new QMaemo5HomescreenAdaptor(&qmlView);
        adaptor->setSettingsAvailable(true); //Use the standard widget settings button for home screen widget
        QObject::connect(adaptor, SIGNAL(settingsRequested()), &qmlView, SLOT(displayConfigWindow()));        

        qmlView.setFixedSize(400,325);
        qmlView.setSource(QUrl("qrc:/qml/MarketsTodayWidget.qml"));
        qmlView.show();
    }
    else{
#if defined(Q_WS_MAEMO_5)
        //For Fremantle, use QML without harmattan-components
        qmlView.setFixedSize(400,325);
        qmlView.setSource(QUrl("qrc:/qml/MarketsTodayLegacyApp.qml"));
#else
        qmlView.setAttribute(Qt::WA_AutoOrientation,true);
        qmlView.setSource(QUrl("qrc:/qml/MarketsTodayApp.qml"));
#endif
        qmlView.showFullScreen();
    }

    QObject *rootObject = qmlView.rootObject();
    //Singal to display stock quote details full screen
    QObject::connect(rootObject, SIGNAL(showStockDetails(QString)), &qmlView, SLOT(displayStockDetails(QString)));

    //Signal to reload configuration and update quotes after config window is clicked
    QObject::connect(&qmlView, SIGNAL(initializeWidget()), rootObject, SLOT(initialize()));

    //QObject::connect(rootObject, SIGNAL(checkNetworkStatus()), &connectionUtility, SLOT(checkConnectionStatus()));
    //QObject::connect(&connectionUtility, SIGNAL(connectionsAvailable()), rootObject, SLOT(reloadData()));
    QObject::connect((QObject*)qmlView.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    app.exec();
}

