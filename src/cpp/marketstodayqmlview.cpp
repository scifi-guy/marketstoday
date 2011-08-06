/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#include "marketstodayqmlview.h"
#include "configqmlview.h"
#include "sharedcontext.h"
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDeclarativeProperty>
#include <QGraphicsObject>
#include "logutility.h"
#include <QDebug>

MarketsTodayQMLView::MarketsTodayQMLView(QWidget *parent) : QDeclarativeView(parent), logUtility(new LogUtility(this))
{        
    // Setup QDeclarativeView
    //setAttribute(Qt::WA_OpaquePaintEvent);
    //setAttribute(Qt::WA_TranslucentBackground);
    setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    setAlignment(Qt::AlignCenter);
    this->rootContext()->setContextProperty("logUtility",logUtility);
}

QSize MarketsTodayQMLView::sizeHint() const
{
    return QSize(400, 365);
}

void MarketsTodayQMLView::displayConfigWindow() {

    ConfigQMLView *configView = new ConfigQMLView(this->parentWidget(),this);

#if defined(Q_WS_MAEMO_5) | defined(Q_WS_MAEMO_6)
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

void MarketsTodayQMLView::displayStockDetails(QString symbol){

    QDeclarativeView *detailsView = new QDeclarativeView(this->parentWidget());
    SharedContext *sharedContextObj = new SharedContext(detailsView);
    sharedContextObj->setComponentToDisplay("StockQuoteDetails");
    sharedContextObj->setStockSymbol(symbol);

#if defined(Q_WS_MAEMO_5) | defined(Q_WS_MAEMO_6)
    //For maemo use a common path
    detailsView->engine()->setOfflineStoragePath("/home/user/.marketstoday/OfflineStorage");
#else
    detailsView->engine()->setOfflineStoragePath("qml/OfflineStorage");
#endif

    detailsView->setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    detailsView->setAlignment(Qt::AlignCenter);
    detailsView->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    detailsView->rootContext()->setContextProperty("sharedContext",sharedContextObj);
    detailsView->rootContext()->setContextProperty("logUtility",logUtility);
    detailsView->setSource(QUrl("qrc:/qml/MarketsTodayApp.qml"));
    detailsView->setWindowTitle("Markets Today");
    QObject::connect((QObject*)detailsView->engine(), SIGNAL(quit()), detailsView, SLOT(close()));
    detailsView->setFixedSize(800,480);
    detailsView->showFullScreen();

    logUtility->logMessage("Stock Details window displayed");
}

void MarketsTodayQMLView::initialize(){
    emit initializeWidget();
}

MarketsTodayQMLView::~MarketsTodayQMLView(){
    qDebug() << "In destructor for MarketsTodayQMLView object";
}

