#ifndef QALPHA_H
#define QALPHA_H

#include <QObject>
#include <QSet>
#include <QMap>
#include <QRandomGenerator>
#include <libalpha/alpha.h>

#define QALPHA_ROOT_ID 1
typedef int alpha_id_t;

class AlphaDelegate {

private:
    QRandomGenerator rng;
    QMap<alpha_id_t, struct alpha_node *> id_node;
    QMap<struct alpha_node *, alpha_id_t> node_id;

public:
    struct alpha_node *root;
    alpha_id_t root_id;

    AlphaDelegate(alpha_id_t root_id);
    ~AlphaDelegate();

    void reset(void);

    alpha_id_t addNode(struct alpha_node *node);
    void addNode(struct alpha_node *node, alpha_id_t id);

    void remId(alpha_id_t id);
    void remNode(alpha_node *node);

    alpha_id_t getId(struct alpha_node *node);
    struct alpha_node *getNode(alpha_id_t id);
};

class QAlpha : public QObject {

    Q_OBJECT
    Q_PROPERTY(int root_id READ root_id)
    Q_PROPERTY(int name_max_len READ name_max_len)

private:
    struct alpha_node *stage_root;
    struct alpha_node *clipboard_root;
    AlphaDelegate stageDelegate;
    AlphaDelegate clipboardDelegate;

    void _clear(AlphaDelegate *delegatep, struct alpha_node **rootp);
    void _register(AlphaDelegate *delegatep, struct alpha_node *node);
    QString _get_node(AlphaDelegate *delegatep, alpha_id_t id);
    QList<int> _get_children(AlphaDelegate *delegatep, alpha_id_t id);
    QList<int> _get_children(AlphaDelegate *delegatep, struct alpha_node *node);
    QList<int> _get_descendants(AlphaDelegate *delegatep, alpha_id_t id);
    QList<int> _get_descendants(AlphaDelegate *delegatep, struct alpha_node *node);

    int _hypo_insert(AlphaDelegate *delegatep, alpha_id_t target, QString content);
    int _hypo_delete(AlphaDelegate *delegatep, alpha_id_t target);
    int _hypo_addcut(AlphaDelegate *delegatep, alpha_id_t target);
    int _hypo_remcut(AlphaDelegate *delegatep, alpha_id_t target);

public:
    explicit QAlpha(QObject *parent = nullptr);

    int root_id() const {
        return QALPHA_ROOT_ID;
    }

    int name_max_len() const {
        return ALPHA_STR_MAXLEN;
    }

    Q_INVOKABLE void stage_clear(void);
    Q_INVOKABLE void clip_clear(void);
    /* empty string => cut */
    Q_INVOKABLE QString stage_get_node(alpha_id_t id);
    Q_INVOKABLE QString clip_get_node(alpha_id_t id);
    Q_INVOKABLE QList<int> stage_get_children(alpha_id_t id);
    Q_INVOKABLE QList<int> clip_get_children(alpha_id_t id);

    /* Model manipulation methods; return alpha_id of node whose children
     * alphaCtx will need to re-check. Note that the returned alpha_id can be for
     * the clipboard or the stage; TODO document */
    Q_INVOKABLE int prf_insert(alpha_id_t target, alpha_id_t content);
    Q_INVOKABLE int prf_delete(alpha_id_t target);
    Q_INVOKABLE int prf_addcut(alpha_id_t target);
    Q_INVOKABLE int prf_remcut(alpha_id_t target);
    Q_INVOKABLE int prf_cut(alpha_id_t target);
    Q_INVOKABLE int prf_yank(alpha_id_t target);
    Q_INVOKABLE int prf_paste(alpha_id_t target, alpha_id_t content);

    Q_INVOKABLE int hypo_insert(alpha_id_t target, QString content);
    Q_INVOKABLE int hypo_delete(alpha_id_t target);
    Q_INVOKABLE int hypo_addcut(alpha_id_t target);
    Q_INVOKABLE int hypo_remcut(alpha_id_t target);

    Q_INVOKABLE int clip_insert(alpha_id_t target, QString content);
    Q_INVOKABLE int clip_delete(alpha_id_t target);
    Q_INVOKABLE int clip_addcut(alpha_id_t target);
    Q_INVOKABLE int clip_remcut(alpha_id_t target);
};

#endif // QALPHA_H
