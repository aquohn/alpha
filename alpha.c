#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "alpha.h"

struct alpha_node *alpha_makenode(struct alpha_node *parent,
  struct alpha_node *child, struct alpha_node *nsib, struct alpha_node *psib,
  const char *name,  int cut) {

  if ((name && child) || (!name && !child)) {
    return NULL;
  }

  char *namebuf = NULL;
  size_t namelen = strnlen(name, ALPHA_STR_MAXLEN);
  if (namelen >= ALPHA_STR_MAXLEN) {
    return NULL;
  } else {
    namebuf = malloc(namelen * sizeof(char));
    if (!namebuf) {
      return NULL;
    }
  }

  struct alpha_node *ap = malloc(sizeof(struct alpha_node));
  if (!ap) {
    free(namebuf);
    return NULL;
  }

  if (!parent) {
    ap->depth = 0;
  } else {
    ap->depth = parent->depth + 1;
  }
  ap->parent = parent;
  ap->child = child;
  ap->nsib = nsib;
  ap->psib = psib;
  
  strncpy(namebuf, name, namelen); /* TOCTOU */
  ap->name = namebuf;

  ap->cut = cut;

  return ap;
}

/* Delete nodes within a tree being deleted */
static void alpha_delnode(struct alpha_node *ap) {
  if (!ap) return;

  alpha_delnode(ap->child);
  alpha_delnode(ap->nsib);
  
  free(ap->name);
  free(ap);
}

/* Delete tree rooted at this node */
void alpha_deltree(struct alpha_node *ap) {
  if (!ap) return;

  alpha_delnode(ap->child);
  if (ap->psib) {
    (ap->psib)->nsib = ap->nsib;
  }
  
  free(ap->name);
  free(ap);
}

/* Update a node's depth after its parent's depth has been updated */
static void alpha_updnode(struct alpha_node *ap, int depth) {
  if (!ap) return;

  alpha_updnode(ap->child, depth+1);
  alpha_updnode(ap->nsib, depth);
}

/* TODO match tree vs match node */
int alpha_match(struct alpha_node *a1p, struct alpha_node *a2p) {
  if ((a1p && !a2p) || (!a1p && a2p)) {
    return 0;
  } else if (!a1p && !a2p) {
    return 1;
  }

  if ((a1p->name && !a2p->name) || (!a1p->name && a2p->name)) {
    return 0;
  } else if (a1p->name && a2p->name) {
    if (strncmp(a1p->name, a2p->name, ALPHA_STR_MAXLEN) != 0) {
      return 0;
    }
  }

  return alpha_match(a1p->parent, a2p->parent)
    && alpha_match(a1p->child, a2p->child)
    && alpha_match(a1p->nsib, a2p->nsib);
}

/* TODO paste: check if pasting a graph here would be valid; ascend
 * the ancestry until the destination's ancestor is the source's parent  */

/* TODO delete and paste, each with check */
