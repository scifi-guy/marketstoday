/****************************************************************************
** Meta object code from reading C++ file 'marketstodayqmlview.h'
**
** Created: Fri Jul 8 20:09:18 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../marketstodayqmlview.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'marketstodayqmlview.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MarketsTodayQMLView[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      21,   20,   20,   20, 0x05,

 // slots: signature, parameters, type, tag, flags
      40,   20,   20,   20, 0x0a,
      62,   20,   20,   20, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_MarketsTodayQMLView[] = {
    "MarketsTodayQMLView\0\0initializeWidget()\0"
    "displayConfigWindow()\0initialize()\0"
};

const QMetaObject MarketsTodayQMLView::staticMetaObject = {
    { &QDeclarativeView::staticMetaObject, qt_meta_stringdata_MarketsTodayQMLView,
      qt_meta_data_MarketsTodayQMLView, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MarketsTodayQMLView::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MarketsTodayQMLView::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MarketsTodayQMLView::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MarketsTodayQMLView))
        return static_cast<void*>(const_cast< MarketsTodayQMLView*>(this));
    return QDeclarativeView::qt_metacast(_clname);
}

int MarketsTodayQMLView::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDeclarativeView::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: initializeWidget(); break;
        case 1: displayConfigWindow(); break;
        case 2: initialize(); break;
        default: ;
        }
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void MarketsTodayQMLView::initializeWidget()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}
QT_END_MOC_NAMESPACE
