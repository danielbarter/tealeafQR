#include <fftw3.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>


// amplitudes should be a pointer to an array double[2 * num_columns * num_rows][2]
uint8_t *generateTeaLeafQR( double *amplitudes,
                            uint32_t num_rows,
                            uint32_t num_columns,
                            uint32_t row_cutoff,
                            uint32_t column_cutoff );

void freeTeaLeafQR(bool *ptr);
