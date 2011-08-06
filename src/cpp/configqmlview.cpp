/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#include "configqmlview.h"
#include "marketstodayqmlview.h"
#include "logutility.h"
#include <QtDeclarative/QDeclarativeView>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QGraphicsObject>
#include <QDebug>

ConfigQMLView::ConfigQMLView(QWidget *parent, MarketsTodayQMLView *parentView)
    : QDeclarativeView(parent), logUtility(new LogUtility(this))
{
    // Setup QDeclarativeView
    setAlignment(Qt::AlignCenter);
    //setContentResizable(false);
    this->stockQuotesView = parentView;
    this->rootContext()->setContextProperty("logUtility",logUtility);
}

void ConfigQMLView::configClosed(){
    logUtility->logMessage("Config window is closed");
    this->stockQuotesView->initialize();
    this->close();
}

ConfigQMLView::~ConfigQMLView(){
    qDebug() << "In destructor for ConfigQMLView object";
}
