#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ALPHA_H
#define ALPHA_STR_MAXLEN 50

struct alpha_node {
  struct alpha_node *parent;
  struct alpha_node *child;
  struct alpha_node *nsib;
  struct alpha_node *psib;
  char *name;
  int cut;
  size_t depth;
};

#ifdef __cplusplus
}
#endif
