#include <stdlib.h>

int main(int argc, char **argv) {
  int i;
  int sum;
  for (i = 1, sum = 0; i < argc; ++i) {
    int ith_val = atoi(argv[i]);
    sum += ith_val;
  }
  return sum;
}
