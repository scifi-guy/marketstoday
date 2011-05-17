/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef CONFIGQMLVIEW_H
#define CONFIGQMLVIEW_H

#include <QDeclarativeView>
#include "marketstodayqmlview.h"
#include "logutility.h"

class ConfigQMLView : public QDeclarativeView
{
    Q_OBJECT

public:
    ConfigQMLView(QWidget *parent = 0, MarketsTodayQMLView *parentView = 0);
    ~ConfigQMLView();

public slots:
    void configClosed();

private:
    MarketsTodayQMLView *stockQuotesView;
    LogUtility * const logUtility;
};

#endif // CONFIGQMLVIEW_H
