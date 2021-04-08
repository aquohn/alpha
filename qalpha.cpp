#include "qalpha.h"
#include <QByteArray>
#include <limits>

/* TODO exception handling */

AlphaDelegate::AlphaDelegate(alpha_id_t root_id) {
    alpha_ret_t ret;
    root = alpha_makenode(nullptr, nullptr, ALPHA_TYPE_AND, &ret);
    this->root_id = root_id;
    addNode(nullptr, 0);
    addNode(root, root_id);
}
AlphaDelegate::~AlphaDelegate() {
    alpha_delnode(root);
}

alpha_id_t AlphaDelegate::addNode(struct alpha_node *node) {
    if (!node) {
        return 0;
    }

    hash_t hash = node->hash % std::numeric_limits<alpha_id_t>::max();
    alpha_id_t id = (alpha_id_t) hash;
    while (id_node.find(id) == id_node.end()) {
        alpha_id_t rand = (alpha_id_t) rng();
        id ^= rand;
    }

    addNode(node, id);
    return id;
}
void AlphaDelegate::addNode(struct alpha_node *node, alpha_id_t id) {
    if (id_node.find(id) != id_node.end() || node_id.find(node) != node_id.end()) {
        return;
    }

    id_node.insert(id, node);
    node_id.insert(node, id);
}
void AlphaDelegate::reset(void) {
    id_node.clear();
    node_id.clear();
    alpha_delnode(root);

    alpha_ret_t ret;
    root = alpha_makenode(nullptr, nullptr, ALPHA_TYPE_AND, &ret);
    addNode(nullptr, 0);
    addNode(root, root_id);
}

void AlphaDelegate::remId(alpha_id_t id) {
    struct alpha_node *node = *(id_node.find(id));
    id_node.remove(id);
    node_id.remove(node);
}
void AlphaDelegate::remNode(alpha_node *node) {
    alpha_id_t id = *(node_id.find(node));
    node_id.remove(node);
    id_node.remove(id);
}
alpha_id_t AlphaDelegate::getId(struct alpha_node *node) {
    auto it = node_id.find(node);
    if (it == node_id.end()) {
        return 0;
    }
    return *it;
}
struct alpha_node *AlphaDelegate::getNode(alpha_id_t id){
    auto it = id_node.find(id);
    if (it == id_node.end()) {
        return nullptr;
    }
    return *it;
}

QAlpha::QAlpha(QObject *parent) :
    QObject(parent), stageDelegate(QALPHA_ROOT_ID), clipboardDelegate(QALPHA_ROOT_ID) {
    stage_root = stageDelegate.root;
    clipboard_root = clipboardDelegate.root;
}

void QAlpha::_clear(AlphaDelegate *delegatep, struct alpha_node **rootp) {
    delegatep->reset();
    *rootp = delegatep->root;
}
void QAlpha::_register(AlphaDelegate *delegatep, struct alpha_node *node) {
    delegatep->addNode(node);
    for (size_t i = 0; i < node->children.num_sibs; ++i) {
        struct alpha_node *child = node->children.sibs[i];
        _register(delegatep, child);
    }
}
QString QAlpha::_get_node(AlphaDelegate *delegatep, alpha_id_t id) {
    struct alpha_node *node = delegatep->getNode(id);
    if (node->name) {
        return QString(node->name);
    }
    return QStringLiteral("");
}
QList<int> QAlpha::_get_children(AlphaDelegate *delegatep, alpha_id_t id) {
    struct alpha_node *node = delegatep->getNode(id);
    return _get_children(delegatep, node);
}
QList<int> QAlpha::_get_children(AlphaDelegate *delegatep, struct alpha_node *node) {
    QList<int> childIds;
    for (size_t i = 0; i < node->children.num_sibs; ++i) {
        int id = delegatep->getId(node->children.sibs[i]);
        childIds.append(id);
    }
    return childIds;
}
QList<int> QAlpha::_get_descendants(AlphaDelegate *delegatep, alpha_id_t id) {
    struct alpha_node *node = delegatep->getNode(id);
    return _get_descendants(delegatep, node);
}
QList<int> QAlpha::_get_descendants(AlphaDelegate *delegatep, struct alpha_node *node) {
    QList<int> descendants;
    for (size_t i = 0; i < node->children.num_sibs; ++i) {
        struct alpha_node *child = node->children.sibs[i];
        int id = delegatep->getId(child);
        descendants += id;
        descendants += _get_descendants(delegatep, child);
    }
    return descendants;
}

void QAlpha::stage_clear(void) {
    _clear(&stageDelegate, &stage_root);
}
void QAlpha::clip_clear(void) {
    _clear(&clipboardDelegate, &clipboard_root);
}
QString QAlpha::stage_get_node(alpha_id_t id) {
    return _get_node(&stageDelegate, id);
}
QString QAlpha::clip_get_node(alpha_id_t id) {
    return _get_node(&clipboardDelegate, id);
}
QList<int> QAlpha::stage_get_children(alpha_id_t id) {
    return _get_children(&stageDelegate, id);
}
QList<int> QAlpha::clip_get_children(alpha_id_t id) {
    return _get_children(&clipboardDelegate, id);
}

int QAlpha::prf_insert(alpha_id_t target, alpha_id_t content) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    struct alpha_node *contnode = clipboardDelegate.getNode(content);

    if (alpha_prfinsert(tgtnode, contnode) == ALPHA_RET_OK) {
        _register(&stageDelegate, contnode);
        return target;
    } else {
        return 0;
    }
}

int QAlpha::prf_delete(alpha_id_t target) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    struct alpha_node *parent = tgtnode->parent;
    if (!parent) { /* cannot delete root node */
        return 0;
    }
    alpha_id_t parent_id = stageDelegate.getId(parent);

    QList<int> to_delete = _get_descendants(&stageDelegate, tgtnode);
    to_delete += target;

    if (alpha_prferase(tgtnode) == ALPHA_RET_OK) {
        for (auto it = to_delete.begin(); it < to_delete.end(); ++it) {
            stageDelegate.remId(*it);
        }
        return parent_id;
    } else {
        return 0;
    }
}

int QAlpha::prf_addcut(alpha_id_t target) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    struct alpha_node *parent = alpha_adddneg(tgtnode);
    if (!parent) {
        return 0;
    }

    _register(&stageDelegate, parent);
    return stageDelegate.getId(parent);
}

int QAlpha::prf_remcut(alpha_id_t target) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    struct alpha_node *parent = tgtnode->parent;
    if (alpha_remdneg(tgtnode) == ALPHA_RET_OK) {
        return stageDelegate.getId(parent);
    }
    return 0;
}

int QAlpha::prf_cut(alpha_id_t target) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    if (alpha_chkdeiter(tgtnode) != ALPHA_RET_OK) {
        return 0;
    }

    if (alpha_move(clipboard_root, tgtnode) != ALPHA_RET_OK) {
        return 0;
    }

    _register(&clipboardDelegate, tgtnode);
    return clipboardDelegate.root_id;
}

int QAlpha::prf_yank(alpha_id_t target) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    if (alpha_paste(clipboard_root, tgtnode) != ALPHA_RET_OK) {
        return 0;
    }

    _register(&clipboardDelegate, tgtnode);
    return clipboardDelegate.root_id;
}

int QAlpha::prf_paste(alpha_id_t target, alpha_id_t content) {
    struct alpha_node *tgtnode = stageDelegate.getNode(target);
    struct alpha_node *contnode = clipboardDelegate.getNode(content);

    if (alpha_paste(tgtnode, contnode) == ALPHA_RET_OK) {
        _register(&stageDelegate, contnode);
        return target;
    } else {
        return 0;
    }
}

int QAlpha::_hypo_insert(AlphaDelegate *delegatep, alpha_id_t target, QString content) {
    struct alpha_node *tgtnode = delegatep->getNode(target);
    struct alpha_node *newnode;
    alpha_ret_t ret;
    if (content.length() == 0) {
        newnode = alpha_makenode(tgtnode, nullptr, ALPHA_TYPE_CUT, &ret);
    } else {
        QByteArray byteArr = content.toUtf8();
        newnode = alpha_makenode(tgtnode, byteArr.data(), ALPHA_TYPE_PROP, &ret);
    }

    if (!newnode) {
        return 0;
    }

    delegatep->addNode(newnode);
    return target;
}

int QAlpha::_hypo_delete(AlphaDelegate *delegatep, alpha_id_t target) {
    struct alpha_node *tgtnode = delegatep->getNode(target);
    if (!tgtnode) {
        return 0;
    }

    /* cannot delete root */
    if (!tgtnode->parent) {
        return 0;
    }

    QList<int> to_delete = _get_descendants(delegatep, tgtnode);
    to_delete += target;

    alpha_id_t parent_id = delegatep->getId(tgtnode->parent);
    alpha_delnode(tgtnode);
    for (auto it = to_delete.begin(); it < to_delete.end(); ++it) {
        delegatep->remId(*it);
    }

    return parent_id;
}

int QAlpha::_hypo_addcut(AlphaDelegate *delegatep, alpha_id_t target) {
    struct alpha_node *tgtnode = delegatep->getNode(target);
}

int QAlpha::_hypo_remcut(AlphaDelegate *delegatep, alpha_id_t target) {
    struct alpha_node *tgtnode = delegatep->getNode(target);
}

int QAlpha::hypo_insert(alpha_id_t target, QString content) {
    return _hypo_insert(&stageDelegate, target, content);
}
int QAlpha::hypo_delete(alpha_id_t target) {
    return _hypo_delete(&stageDelegate, target);
}
int QAlpha::hypo_addcut(alpha_id_t target) {
    return _hypo_addcut(&stageDelegate, target);
}
int QAlpha::hypo_remcut(alpha_id_t target) {
    return _hypo_remcut(&stageDelegate, target);
}

int QAlpha::clip_insert(alpha_id_t target, QString content) {
    return _hypo_insert(&clipboardDelegate, target, content);
}
int QAlpha::clip_delete(alpha_id_t target) {
    return _hypo_delete(&clipboardDelegate, target);
}
int QAlpha::clip_addcut(alpha_id_t target) {
    return _hypo_addcut(&clipboardDelegate, target);
}
int QAlpha::clip_remcut(alpha_id_t target) {
    return _hypo_remcut(&clipboardDelegate, target);
}
