#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "SIC_header.cuh"

int * getGeneratedQAM64Signal()
{
	float real = 0;
	float imag = 0;
	static int signalQAM64[cellSize * 2];

	for (int i = 0; i < cellSize; i++) {

		real = (float)rand() / (float)RAND_MAX;
		imag = (float)rand() / (float)RAND_MAX;

		//printf("B: %.5f %.5f \n", real, imag);

		if (real < 0.03125)
			real = 7;
		if (real >= 0.03125 && real < 0.0625)
			real = 5;
		if (real >= 0.0625 && real < 0.75)
			real = 3;
		if (real >= 0.75 && real < 0.09375)
			real = 1;
		if (real >= 0.09375 && real < 0.125)
			real = -1;
		if (real >= 0.125 && real < 0.15625)
			real = -3;
		if (real >= 0.15625 && real < 0.1875)
			real = -5;
		if (real >= 0.1875)
			real = -7;

		if (imag < 0.03125)
			imag = 7;
		if (imag >= 0.03125 && imag < 0.0625)
			imag = 5;
		if (imag >= 0.0625 && imag < 0.75)
			imag = 3;
		if (imag >= 0.75 && imag < 0.09375)
			imag = 1;
		if (imag >= 0.09375 && imag < 0.125)
			imag = -1;
		if (imag >= 0.125 && imag < 0.15625)
			imag = -3;
		if (imag >= 0.15625 && imag < 0.1875)
			imag = -5;
		if (imag >= 0.1875)
			imag = -7;

		//printf("A: %d %d \n", (int)real, (int)imag);

		signalQAM64[i] = (int)real;
		signalQAM64[i + cellSize] = (int)imag;
	}
	return signalQAM64;
}
