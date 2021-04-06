#ifndef QALPHA_H
#define QALPHA_H

#include <QObject>
#include <QMap>
#include <libalpha/alpha.h>

class AlphaIndexer {
    QMap<unsigned long, struct alpha_node *> id_map;
public:

};

class QAlpha : public QObject
{
    Q_OBJECT
public:
    explicit QAlpha(QObject *parent = nullptr);

};

#endif // QALPHA_H
