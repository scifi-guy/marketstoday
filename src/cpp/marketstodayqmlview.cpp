/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#include "marketstodayqmlview.h"
#include "configqmlview.h"
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include "logutility.h"
#include <QDebug>

MarketsTodayQMLView::MarketsTodayQMLView(QWidget *parent) : QDeclarativeView(parent), logUtility(new LogUtility(this))
{    
    // Setup QDeclarativeView
    //setAttribute(Qt::WA_OpaquePaintEvent);
    setAttribute(Qt::WA_TranslucentBackground);
    setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    setAlignment(Qt::AlignCenter);
    this->rootContext()->setContextProperty("logUtility",logUtility);
}

QSize MarketsTodayQMLView::sizeHint() const
{
    return QSize(400, 325);
}

void MarketsTodayQMLView::displayConfigWindow() {

    ConfigQMLView *configView = new ConfigQMLView(this->parentWidget(),this);

#ifdef Q_WS_MAEMO_5
    //For maemo use a common path
    configView->engine()->setOfflineStoragePath("/home/user/.marketstoday/OfflineStorage");
#else
    configView->engine()->setOfflineStoragePath("qml/OfflineStorage");
#endif
    configView->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    configView->setSource(QUrl("qrc:/qml/Config.qml"));
    configView->setWindowTitle("Configuration");
    QObject::connect((QObject*)configView->engine(), SIGNAL(quit()), configView, SLOT(configClosed()));
    configView->showFullScreen();
}

void MarketsTodayQMLView::initialize(){
    emit initializeWidget();
}

MarketsTodayQMLView::~MarketsTodayQMLView(){
    qDebug() << "In destructor for MarketsTodayQMLView object";
}
