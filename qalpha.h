#ifndef QALPHA_H
#define QALPHA_H

#include <QObject>
#include <QMap>
#include <QRandomGenerator>
#include <libalpha/alpha.h>

#define QALPHA_ROOT_ID 1
typedef unsigned long alpha_id_t;

class AlphaDelegate {

private:
    QRandomGenerator rng;
    QMap<alpha_id_t, struct alpha_node *> id_node;
    QMap<struct alpha_node *, alpha_id_t> node_id;

public:
    struct alpha_node *root;

    AlphaDelegate(alpha_id_t root_id);

    alpha_id_t addNode(struct alpha_node *node);
    void addNode(struct alpha_node *node, alpha_id_t id);

    void remId(alpha_id_t id);
    void remNode(alpha_node *node);

    alpha_id_t getId(struct alpha_node *node);
    struct alpha_node *getNode(alpha_id_t id);
};

class QAlpha : public QObject {

    Q_OBJECT

private:
    struct alpha_node *stage_root;
    struct alpha_node *clipboard_root;
    AlphaDelegate stageDelegate;
    AlphaDelegate clipboardDelegate;

public:
    const alpha_id_t root_id = QALPHA_ROOT_ID;
    explicit QAlpha(QObject *parent = nullptr);

    Q_INVOKABLE void stage_clear(void);
    Q_INVOKABLE void clip_clear(void);

    Q_INVOKABLE int prf_insert(alpha_id_t target, alpha_id_t);
    Q_INVOKABLE int prf_delete(alpha_id_t target);
    Q_INVOKABLE int prf_addcut(alpha_id_t target);
    Q_INVOKABLE int prf_remcut(alpha_id_t target);
    Q_INVOKABLE int prf_cut(alpha_id_t target);
    Q_INVOKABLE int prf_yank(alpha_id_t target);

    Q_INVOKABLE int hypo_insert(alpha_id_t target, alpha_id_t);
    Q_INVOKABLE int hypo_delete(alpha_id_t target);
    Q_INVOKABLE int hypo_addcut(alpha_id_t target);
    Q_INVOKABLE int hypo_remcut(alpha_id_t target);

    Q_INVOKABLE int clip_insert(alpha_id_t target, alpha_id_t);
    Q_INVOKABLE int clip_delete(alpha_id_t target);
    Q_INVOKABLE int clip_addcut(alpha_id_t target);
    Q_INVOKABLE int clip_remcut(alpha_id_t target);
};

#endif // QALPHA_H
