/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef SHAREDCONTEXT_H
#define SHAREDCONTEXT_H

#include <QDebug>
#include <QObject>

class SharedContext: public QObject
{
    Q_OBJECT

private:
    QString stockSymbol;
    QString componentToDisplay;

public:
    SharedContext(QObject *parent = 0) :
        QObject(parent){
    }
    ~SharedContext(){
        qDebug() << "Markets Today: In SharedContext object destructor..";
    }

    void setStockSymbol(QString symbol){
        this->stockSymbol = symbol;
    }

    Q_INVOKABLE QString getStockSymbol(){
        return this->stockSymbol;
    }

    void setComponentToDisplay(QString component){
        this->componentToDisplay = component;
    }

    Q_INVOKABLE QString getComponentToDisplay(){
        return this->componentToDisplay;
    }

};

#endif // SHAREDCONTEXT_H
