/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef MARKETSTODAYQMLVIEW_H
#define MARKETSTODAYQMLVIEW_H

#include <QObject>
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
    void displayStockDetails(QString symbol);

signals:
    void initializeWidget();

private:
    LogUtility * const logUtility;
};

#endif // MARKETSTODAYQMLVIEW_H
