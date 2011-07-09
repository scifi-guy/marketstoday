/****************************************************************************
** Meta object code from reading C++ file 'logutility.h'
**
** Created: Fri Jul 8 20:09:18 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../logutility.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'logutility.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_LogUtility[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      23,   12,   11,   11, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_LogUtility[] = {
    "LogUtility\0\0strMessage\0logMessage(QString)\0"
};

const QMetaObject LogUtility::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_LogUtility,
      qt_meta_data_LogUtility, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &LogUtility::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *LogUtility::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *LogUtility::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_LogUtility))
        return static_cast<void*>(const_cast< LogUtility*>(this));
    return QObject::qt_metacast(_clname);
}

int LogUtility::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: logMessage((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
