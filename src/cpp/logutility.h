/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef LOGUTILITY_H
#define LOGUTILITY_H
#include <QDebug>
#include <QFile>
#include <QIODevice>
#include <QDateTime>

class LogUtility : public QObject
{
    Q_OBJECT

public:
    LogUtility(QObject *parent = 0) :
        QObject(parent){

    }
    ~LogUtility(){
        qDebug() << "Markets Today: In LogUtility object destructor..";
    }

public slots:
    void logMessage(QString strMessage) {

        QString strTimeNow = QDateTime::currentDateTime().toString("dd-MMM-yyyy HH:mm:ss");
        qDebug() << QString("MT: [%1] - %2").arg(strTimeNow,strMessage);

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
    //For maemo fremantle or harmattan use a common path
        QFile logFile("/home/user/.marketstoday/marketstoday.log");
#else
        QFile logFile("marketstoday.log");
#endif

        if (!logFile.open(QIODevice::Append | QIODevice::WriteOnly | QIODevice::Text)) { return; }

        QTextStream logStream(&logFile);
        logStream <<  QString("[%1] - %2").arg(strTimeNow,strMessage) << endl;
    }
};

#endif // LOGUTILITY_H
