#include <fftw3.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>


// test whether an amlpitude should be set to zero
bool masked(int32_t row,
            int32_t column,
            int32_t num_rows,
            int32_t num_columns,
            int32_t row_cutoff,
            int32_t column_cutoff);


// if an index is not masked, return the corresponding index in the amplitude array
// negative index indicates a complex conjugate
int32_t amplitudeIndex( int32_t row,
                        int32_t column,
                        int32_t num_rows,
                        int32_t num_columns,
                        int32_t row_cutoff,
                        int32_t column_cutoff);


// amplitudes should be a pointer to an array double[2 * row_cutoff * column_cutoff][2]
uint8_t *generateTeaLeafQR( double *amplitudes,
                            int32_t num_rows,
                            int32_t num_columns,
                            int32_t row_cutoff,
                            int32_t column_cutoff );



void freeTeaLeafQR(bool *ptr);
