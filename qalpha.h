#ifndef QALPHA_H
#define QALPHA_H

#include <QObject>
#include <QMap>
#include <libalpha/alpha.h>

class AlphaDelegate {
    QMap<unsigned long, struct alpha_node *> id_node;
    QMap<struct alpha_node *, unsigned long> node_id;

public:
    void addNode(struct alpha_node *ap, unsigned long id);

    void remIds(QList<unsigned long> idlist);
    void remId(unsigned long id);

    unsigned long getAvailId();
    unsigned long getId(struct alpha_node *ap);
    unsigned long getNode(unsigned long id);
};

class QAlpha : public QObject
{
    Q_OBJECT
public:
    explicit QAlpha(QObject *parent = nullptr);


};

#endif // QALPHA_H
