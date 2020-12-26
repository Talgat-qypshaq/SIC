#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "SIC_header.cuh"

int * getGeneratedQAM16Signal() {
	float real = 0;
	float imag = 0;
	static int signalQAM16[cellSize * 2];

	for (int i = 0; i < cellSize; i++)
	{

		real = (float)rand() / (float)RAND_MAX;
		imag = (float)rand() / (float)RAND_MAX;

		//printf("B: %.5f %.5f \n", real, imag);

		if (real < 0.25)
			real = 1;
		if (real >= 0.25 && real < 0.5)
			real = -1;
		if (real >= 0.5 && real < 0.75)
			real = 3;
		if (real >= 0.75)
			real = -3;

		if (imag < 0.25)
			imag = 1;
		if (imag >= 0.25 && imag < 0.5)
			imag = -1;
		if (imag >= 0.5 && imag < 0.75)
			imag = 3;
		if (imag >= 0.75)
			imag = -3;

		//printf("A: %d %d \n", (int)real, (int)imag);

		signalQAM16[i] = (int)real;
		signalQAM16[i + cellSize] = (int)imag;
	}
	return signalQAM16;
}
