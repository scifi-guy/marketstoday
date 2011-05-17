/*
@version: 0.1
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef MARKETSTODAYQMLVIEW_H
#define MARKETSTODAYQMLVIEW_H

#include <QDeclarativeView>
#include "logutility.h"

class MarketsTodayQMLView: public QDeclarativeView
{
    Q_OBJECT

public:
    MarketsTodayQMLView(QWidget *parent = 0);
    ~MarketsTodayQMLView();
    QSize sizeHint() const;

public slots:
    void displayConfigWindow();
    void initialize();

signals:
    void initializeWidget();

private:
    LogUtility * const logUtility;

};

#endif // MARKETSTODAYQMLVIEW_H
