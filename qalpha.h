#ifndef QALPHA_H
#define QALPHA_H

#include <QObject>
#include <QMap>
#include <QRandomGenerator>
#include <libalpha/alpha.h>

typedef unsigned long alpha_id_t;

class AlphaDelegate {
    QMap<alpha_id_t, struct alpha_node *> id_node;
    QMap<struct alpha_node *, alpha_id_t> node_id;

public:
    explicit AlphaDelegate(struct alpha_node *root);

    alpha_id_t addNode(struct alpha_node *ap);
    void addNode(struct alpha_node *ap, alpha_id_t id);

    void remId(alpha_id_t id);
    void remNode(alpha_node *node);

    alpha_id_t getId(struct alpha_node *ap);
    alpha_id_t getNode(alpha_id_t id);
};

class QAlpha : public QObject {

    Q_OBJECT

    QRandomGenerator rng;
    struct alpha_node *stage;
    struct alpha_node *clipboard;
    AlphaDelegate stageDelegate;
    AlphaDelegate clipboardDelegate;

public:
    explicit QAlpha(QObject *parent = nullptr);


};

#endif // QALPHA_H
