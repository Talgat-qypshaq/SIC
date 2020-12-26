#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
//#include "SIC_QPSK.c"
//#include "SIC_QAM16.c"
//#include "SIC_QAM64.c"
//#include "SIC_Rayleigh.c"
#include "SIC_header.cuh"
using namespace std;

FILE *fp1, *fp2, *fp3;
int lengthOfLineFunction(FILE *fp2, char *fileLocation, char *line, int lengthOfLine);

__device__ double QPSK(double signal)
{
	//printf("B signal: %.5f\n", signal);
	if (signal>0)
		signal = 1;
	else
		signal = -1;
	//printf("A signal: %.5f\n", signal);
	return signal;
}

__device__ double QAM16(double signal)
{
	//printf("B signal: %.5f\n", signal);
	if (signal < 0.25)
		signal = 1;
	if (signal >= 0.25 && signal < 0.5)
		signal = -1;
	if (signal >= 0.5 && signal < 0.75)
		signal = 3;
	if (signal >= 0.75)
		signal = -3;
	//printf("A signal: %.5f\n", signal);
	return signal;
}

__device__ double QAM64(double signal)
{
	//printf("B signal: %.5f\n", signal);
	if (signal < 0.03125)
		signal = 7;
	if (signal >= 0.03125 && signal < 0.0625)
		signal = 5;
	if (signal >= 0.0625 && signal < 0.75)
		signal = 3;
	if (signal >= 0.75 && signal < 0.09375)
		signal = 1;
	if (signal >= 0.09375 && signal < 0.125)
		signal = -1;
	if (signal >= 0.125 && signal < 0.15625)
		signal = -3;
	if (signal >= 0.15625 && signal < 0.1875)
		signal = -5;
	if (signal >= 0.1875)
		signal = -7;
	//printf("A signal: %.5f\n", signal);
	return signal;
}

__global__ void SIC(float *powerCoefficients, double *Rayleigh, double *receivedSignal)
{
	int index = threadIdx.x + blockIdx.x*blockDim.x;
	//int index = threadIdx.x;
	double signal[2];
	double sumSignalPowerCoefficientChannel[2];
	//index of the thread is the id of user, which is being decoded
	if (index < cellSize)
	{
		//printf("luck I am");
		//int order = index % numberOfUEs;
		int order = 1;
		for (int i = numberOfUEs; i >= order; i--)
		{
			//int order = index % i;
			//printf("oder = %d \n", order);
			signal[0] = (receivedSignal[index] - sumSignalPowerCoefficientChannel[0]) / (Rayleigh[index]*powerCoefficients[i]);
			signal[1] = (receivedSignal[index + cellSize] - sumSignalPowerCoefficientChannel[1]) / (Rayleigh[index + cellSize] * powerCoefficients[i]);
			switch (modulation)
			{
				case 4:
				{
					 signal[0] = QPSK(signal[0]);
					 signal[1] = QPSK(signal[1]);
					 break;
				}
				case 16:
				{
					 signal[0] = QAM16(signal[0]);
					 signal[1] = QAM16(signal[1]);
					 break;
				}
				case 64:
				{
					 signal[0] = QAM64(signal[0]);
					 signal[1] = QAM64(signal[1]);
					 break;
				}
			}
			if (i != order)
			{
				sumSignalPowerCoefficientChannel[0] = sumSignalPowerCoefficientChannel[0] + (Rayleigh[index] * signal[0] * powerCoefficients[i]);
				sumSignalPowerCoefficientChannel[1] = sumSignalPowerCoefficientChannel[1] + (Rayleigh[index + cellSize] * signal[1] * powerCoefficients[i]);
			}
		}
		//printf("RayleighReal = %.3f; receivedSignalReal = %.3f;\n", Rayleigh[index], receivedSignal[index]);
		//printf("RayleighImag = %.3f; receivedSignalImag = %.3f;\n", Rayleigh[index + numberOfUEs], receivedSignal[index + numberOfUEs]);
		receivedSignal[index] = signal[0];
		receivedSignal[index + cellSize] = signal[1];
	}
}

int main(void )
{
	char fileLocation[256] = "/home/talgat/github/SIC/OPA/PowerAllocation";
	int totalPower = 1;
	int order = cellSize % numberOfUEs;
	char a[8] = "10";
	char fileLocationEnd[8] = ".txt";
	strcat(a, fileLocationEnd);
	strcat(fileLocation, a);
	//printf("File Location %s \n", fileLocation);
	char line[255];
	int lengthOfLine = 0;
	int i = 0;
	lengthOfLine = lengthOfLineFunction(fp1, fileLocation, line, lengthOfLine);
	//printf("\nlengthOfLine %d \n", lengthOfLine);
	//array for optimum power allocation coefficients
	float *powerCoefficientMatrix = 0;
	if (powerCoefficientMatrix != 0)
	{
		powerCoefficientMatrix = (float*)realloc(powerCoefficientMatrix, numberOfUEs * sizeof(float));
	}
	else
	{
		powerCoefficientMatrix = (float*)malloc(numberOfUEs * sizeof(float));
	}
	//iterate through each value in a line
	fp2 = fopen(fileLocation, "r");
	fgets(line, lengthOfLine, (FILE*)fp2);
	//printf("\nline: %s\n", line);
	char *p = strtok(line, " ");
	for (int m = 0; m < numberOfUEs; m++)
	{
		powerCoefficientMatrix[m] = (float)atof(p);
		p = strtok(NULL, " ");
	}
	fclose(fp2);

		int *generatedSignal;
		switch (modulation)
		{
			case 4:
			{
				generatedSignal = getGeneratedQPSKSignal();
				//printf("4\n");
				break;
			}
			case 16:
			{
				generatedSignal = getGeneratedQAM16Signal();
				//printf("16\n");
				break;
			}
			case 64:
			{
				generatedSignal = getGeneratedQAM64Signal();
				//printf("64\n");
				break;
			}
		}

		double *rayleighChannel;
		rayleighChannel = getGeneratedRayleighChannel(powerCoefficientMatrix);
		float signalWithPowerCoefficient[cellSize * 2];

		for (i = 0; i<cellSize; i++)
		{
			signalWithPowerCoefficient[i] = generatedSignal[i] * sqrt(powerCoefficientMatrix[order] * totalPower);
			signalWithPowerCoefficient[i + cellSize] = generatedSignal[i + cellSize] * sqrt(powerCoefficientMatrix[order] * totalPower);
		}

		float superSignalReal = 0;
		float superSignalImag = 0;

		for (i = 0; i < cellSize; i++)
		{
			superSignalReal = superSignalReal + signalWithPowerCoefficient[i];
			superSignalImag = superSignalImag + signalWithPowerCoefficient[i + cellSize];
		}

		double receivedSignal[cellSize * 2];
		for (i = 0; i < cellSize; i++)
		{
			//noise is considered as zero
			receivedSignal[i] = superSignalReal*rayleighChannel[i];
			receivedSignal[i + cellSize] = superSignalImag*rayleighChannel[i + cellSize];
		}

		float  *dev_PowerCoefficientMatrix;
		double  *dev_RayleighChannel;
		double  *dev_ReceivedSignal;

		cudaMalloc((void**)&dev_PowerCoefficientMatrix, numberOfUEs * sizeof(float));
		cudaMemcpy(dev_PowerCoefficientMatrix, powerCoefficientMatrix, numberOfUEs * sizeof(float), cudaMemcpyHostToDevice);

		cudaMalloc((void**)&dev_RayleighChannel, cellSize * 2 * sizeof(double));
		cudaMemcpy(dev_RayleighChannel, rayleighChannel, cellSize * 2 * sizeof(double), cudaMemcpyHostToDevice);

		cudaMalloc((void**)&dev_ReceivedSignal, cellSize * 2 * sizeof(double));
		cudaMemcpy(dev_ReceivedSignal, receivedSignal, cellSize * 2 * sizeof(double), cudaMemcpyHostToDevice);

		cudaEvent_t start, stop;
		float elapsedTime;
		cudaEventCreate(&start);
		cudaEventCreate(&stop);
		cudaEventRecord(start, 0);
		//CALLING CUDA START  ****************************************************************************************
		SIC << <cellCoefficient, groupSize >> > (dev_PowerCoefficientMatrix, dev_RayleighChannel, dev_ReceivedSignal);
		//CALLING CUDA END    ****************************************************************************************
		cudaEventRecord(stop, 0);
		cudaEventSynchronize(stop);
		cudaEventElapsedTime(&elapsedTime, start, stop);
		
		char fileLocation_2[128] = "/home/talgat/github/SIC/results.txt";
		fp3 = fopen(fileLocation_2, "w");
		printf("Time to generate: %.3f ms", elapsedTime);
		fprintf(fp3, "%.3f", elapsedTime);
		fclose(fp3);
		printf("\n");
		cudaMemcpy(&receivedSignal, dev_ReceivedSignal, cellSize * 2 * sizeof(double), cudaMemcpyDeviceToHost);

		cudaFree(dev_PowerCoefficientMatrix);
		cudaFree(dev_RayleighChannel);
		cudaFree(dev_ReceivedSignal);
}
int lengthOfLineFunction(FILE *fp, char *fileLocation, char *line, int lengthOfLine)
{
	fp = fopen(fileLocation, "r");
	int numberOfUsers = 1;
	for (int i = 0; i < 1; i++) {
		fgets(line, 511, (FILE*)fp);
		lengthOfLine = strlen(line);
		for (int j = 0; line[j] != '\0'; j++) {
			if (line[j] == ' ') numberOfUsers++;
		}
	}
	//printf("1. There are %d chars in a line \n", lengthOfLine);
	//printf("2. There are %d UEs in a BS", numberOfUsers);
	lengthOfLine = lengthOfLine + 3;
	fclose(fp);
	return lengthOfLine;
}
