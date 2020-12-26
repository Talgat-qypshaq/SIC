#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "SIC_header.cuh"

int * getGeneratedQPSKSignal() {
	int real = 0;
	int imag = 0;
	static int signalQPSK[cellSize * 2];

	for (int i = 0; i < cellSize; i++) {

		real = rand() % 19 + (-9);
		imag = rand() % 19 + (-9);

		//printf("B: %d %d \n", real, imag);

		if (real > 0)
			real = 1;
		else
			real = -1;

		if (imag > 0)
			imag = 1;
		else
			imag = -1;

		//printf("A: %d %d \n", real, imag);

		signalQPSK[i] = real;
		signalQPSK[i + cellSize] = imag;
	}
	return signalQPSK;
}
