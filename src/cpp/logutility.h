/*
@version: 0.4
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

#ifndef LOGUTILITY_H
#define LOGUTILITY_H
#include <QDebug>
#include <QFile>
#include <QIODevice>
#include <QDateTime>
#include <QDir>

class LogUtility : public QObject
{
    Q_OBJECT

private:
    QFile * logFile;

public:
    LogUtility(QObject *parent = 0) :
        QObject(parent){
        QString strPath;

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
        //For maemo fremantle or harmattan use a common path
        strPath = QDir().homePath() + "/.marketstoday/marketstoday.log";
#else
        strPath = "marketstoday.log";
#endif
        logFile = new QFile(strPath,this);

        if (!logFile->open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
            qDebug() << "MT: Error opening logfile for writing";
        }
    }

    ~LogUtility(){
        if (logFile->isOpen())
            logFile->close();
        qDebug() << "Markets Today: In LogUtility object destructor..";
    }

public slots:
    void logMessage(QString strMessage) {

        QString strTimeNow = QDateTime::currentDateTime().toString("dd-MMM-yyyy HH:mm:ss");
        qDebug() << QString("MT: [%1] - %2").arg(strTimeNow,strMessage);        

        if (logFile->isOpen() && logFile->isWritable()) {
            QTextStream logStream(logFile);
            logStream <<  QString("[%1] - %2").arg(strTimeNow,strMessage) << endl;
        }
    }
};

#endif // LOGUTILITY_H
