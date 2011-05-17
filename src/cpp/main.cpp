/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#include "qmaemo5homescreenadaptor.h"
#include "marketstodayqmlview.h"

#include <QtGui>
#include <QDeclarativeEngine>
#include <QDebug>
#include "logutility.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    MarketsTodayQMLView widgetAdaptor;
    QMaemo5HomescreenAdaptor *adaptor = new QMaemo5HomescreenAdaptor(&widgetAdaptor);
    adaptor->setSettingsAvailable(false); //Don't use the standard widget settings button   

#ifdef Q_WS_MAEMO_5
    //For maemo use a common path
    widgetAdaptor.engine()->setOfflineStoragePath("/home/user/.marketstoday/OfflineStorage");
#else
    widgetAdaptor.engine()->setOfflineStoragePath("qml/OfflineStorage");
#endif
    widgetAdaptor.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    widgetAdaptor.setFixedSize(400,325);
    widgetAdaptor.setSource(QUrl("qrc:/qml/MarketsToday.qml"));
    widgetAdaptor.setWindowTitle("Markets Today");

    LogUtility logUtility;
    logUtility.logMessage(widgetAdaptor.engine()->offlineStoragePath());

    QObject *rootObject = dynamic_cast<QObject*>(widgetAdaptor.rootObject());
    //Signal to display config window when user clicks config icon
    QObject::connect(rootObject, SIGNAL(showConfigInNewWindow()), &widgetAdaptor, SLOT(displayConfigWindow()));
    //Signal to reload configuration and update quotes after config window is clicked
    QObject::connect(&widgetAdaptor, SIGNAL(initializeWidget()), rootObject, SLOT(initialize()));

    widgetAdaptor.show();
    app.exec();
}
