#include "qalpha.h"

/* TODO exception handling */

AlphaDelegate::AlphaDelegate(alpha_id_t root_id) {
    alpha_ret_t ret;
    root = alpha_makenode(nullptr, nullptr, ALPHA_TYPE_AND, &ret);
    addNode(nullptr, 0);
    addNode(root, root_id);
}

alpha_id_t AlphaDelegate::addNode(struct alpha_node *node) {
    if (!node) {
        return 0;
    }

    alpha_id_t id = node->hash;
    while (id_node.find(id) == id_node.end()) {
        id += rng();
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
    return *(node_id.find(node));
}

struct alpha_node *AlphaDelegate::getNode(alpha_id_t id){
    return *(id_node.find(id));
}

QAlpha::QAlpha(QObject *parent) :
    QObject(parent), stageDelegate(QALPHA_ROOT_ID), clipboardDelegate(QALPHA_ROOT_ID) {
    stage_root = stageDelegate.root;
    clipboard_root = clipboardDelegate.root;
}

void QAlpha::stage_clear(void) { }
void QAlpha::clip_clear(void) { }

int QAlpha::prf_insert(alpha_id_t target, alpha_id_t) { }
int QAlpha::prf_delete(alpha_id_t target) { }
int QAlpha::prf_addcut(alpha_id_t target) { }
int QAlpha::prf_remcut(alpha_id_t target) { }
int QAlpha::prf_cut(alpha_id_t target) { }
int QAlpha::prf_yank(alpha_id_t target) { }

int QAlpha::hypo_insert(alpha_id_t target, alpha_id_t) { }
int QAlpha::hypo_delete(alpha_id_t target) { }
int QAlpha::hypo_addcut(alpha_id_t target) { }
int QAlpha::hypo_remcut(alpha_id_t target) { }

int QAlpha::clip_insert(alpha_id_t target, alpha_id_t) { }
int QAlpha::clip_delete(alpha_id_t target) { }
int QAlpha::clip_addcut(alpha_id_t target) { }
int QAlpha::clip_remcut(alpha_id_t target) { }

