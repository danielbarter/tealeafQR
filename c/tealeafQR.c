#include "tealeafQR.h"


bool masked(int32_t row,
            int32_t column,
            int32_t num_rows,
            int32_t num_columns,
            int32_t row_cutoff,
            int32_t column_cutoff)
{
  return (row_cutoff <= row && row <= num_rows - row_cutoff)
    || (column_cutoff <= column && column <= num_columns - column_cutoff);
}


int32_t amplitudeIndex( int32_t row,
                        int32_t column,
                        int32_t num_rows,
                        int32_t num_columns,
                        int32_t row_cutoff,
                        int32_t column_cutoff)
{
  int32_t middle = row_cutoff * column_cutoff;
  if (row < row_cutoff && column < column_cutoff)
    {
      return row * column_cutoff + column;
    }

  if (row < row_cutoff && num_columns - column_cutoff < column)
    {
      return middle + row * column_cutoff + (num_columns - column);
    }

  if (num_rows - row_cutoff < row && column < column_cutoff)
    {
      return - ( middle + (num_rows - row ) * column_cutoff + column );
    }

  if ( num_rows - row_cutoff < row && num_columns - column_cutoff < column )
    {
      return - ( (num_rows - row) * column_cutoff + (num_columns - column) );
    }

  return 1234567;
}


uint8_t *generateTeaLeafQR( double *amplitudes,
                            int32_t num_rows,
                            int32_t num_columns,
                            int32_t row_cutoff,
                            int32_t column_cutoff )
{
  fftw_complex *in, *out;
  uint8_t *image;
  fftw_plan plan;
  int32_t array_size = num_rows * num_columns;
  int32_t i, amplitude_index;
  int32_t row,column;

  in = fftw_alloc_complex(array_size);
  out = fftw_alloc_complex(array_size);

  plan = fftw_plan_dft_2d(num_rows,num_columns,in,out,FFTW_BACKWARD,FFTW_ESTIMATE);

  // initializing input array
  for (i = 0; i < array_size; ++i)
    {
      row = i / num_columns;
      column = i % num_columns;
      if (masked(row,column,num_rows,num_columns,row_cutoff,column_cutoff))
        {
          in[i][0] = 0.0;
          in[i][1] = 0.0;
        } else
        {
          amplitude_index = 2 * amplitudeIndex(row,column,num_rows,num_columns,row_cutoff,column_cutoff);
          if (amplitude_index < 0)
            {
              in[i][0] = amplitudes[-amplitude_index];
              in[i][1] = - amplitudes[-amplitude_index + 1];
            } else
            {
              in[i][0] = amplitudes[amplitude_index];
              in[i][1] = amplitudes[amplitude_index+1];
            }
        }
    }

  fftw_execute(plan);

  image = malloc(array_size * sizeof(bool));

  for (i = 0; i < array_size; ++i)
    {
      if ( out[i][0] > array_size / 2 )
        {
          image[i] = 255;
        } else
        {
          image[i] = 0;
        }
    }

  fftw_destroy_plan(plan);
  fftw_free(in);
  fftw_free(out);

  return image;

}
