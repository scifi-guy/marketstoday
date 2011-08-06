/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef CONECTIONUTILITY_H
#define CONECTIONUTILITY_H

#include <QDebug>

#include <QNetworkConfigurationManager>
#include <QNetworkConfiguration>
#include "logutility.h"

class ConnectionUtility: public QObject
{
    Q_OBJECT

private:
    LogUtility *logUtility;

public:
    ConnectionUtility(QObject *parent = 0) :
        QObject(parent){
        logUtility = new LogUtility(this);
    }

    ~ConnectionUtility(){
        qDebug() << "Markets Today: In ConnectionUtility object destructor..";
    }

signals:
    void connectionsAvailable();

public slots:
    void checkConnectionStatus(){
        QNetworkConfigurationManager manager;
        logUtility->logMessage("Verifying connection status");
        if (manager.isOnline()) {
            logUtility->logMessage("A network session is already in progress, OK to update");
            emit connectionsAvailable();
        }
        else{
            logUtility->logMessage("No active network sessions found, searching for available networks");
            manager.updateConfigurations();
        }
    }

    void connectionListUpdated(){
        QNetworkConfigurationManager manager;

        //NOT WORKING
        QList<QNetworkConfiguration> list = manager.allConfigurations(QNetworkConfiguration::Discovered);

        logUtility->logMessage("Connection list updated");

        bool conxnAvailable = false;

        for (int i = 0 ; i < list.count() ; ++i)
        {
            qDebug() << "Name: " << list[i].name() << "Type: " << list[i].bearerTypeName() << "State: " << list[i].state() << "Identifier: " << list[i].identifier();

            if (list[i].bearerType() == QNetworkConfiguration::BearerWLAN && list[i].type() == QNetworkConfiguration::InternetAccessPoint) {
                conxnAvailable = true;
                logUtility->logMessage("Found network "+list[i].name());
                break;
            }

            if (conxnAvailable) emit connectionsAvailable();
        }
    }
};

#endif // CONECTIONUTILITY_H
