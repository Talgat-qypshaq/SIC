#include "SIC_header.cuh"
#include "SIC_Random.cpp"

class SIC_Generate
{
  public:
    SIC_Random r;
    float real = 0;
    float imag = 0;
    int signal[cellSize * 2];
    int * getGeneratedQPSKSignal()
    {
    	for (int i = 0; i < cellSize; i++)
      {
        real = r.getRandomFloat();
        imag = r.getRandomFloat();
    		//printf("A: %.2f %.2f \n", real, imag);
    		if (real > 0)
    			real = 1;
    		else
    			real = -1;
    		if (imag > 0)
    			imag = 1;
    		else
    			imag = -1;
    		signal[i] = (int)real;
    		signal[i + cellSize] = (int)imag;
    		//printf("A: %d %d \n", signal[i], signal[i + cellSize]);
    	}
    	return signal;
    }
    int * getGeneratedQAM16Signal()
    {
    	for (int i = 0; i < cellSize; i++)
    	{
        real = r.getRandomFloat();
        imag = r.getRandomFloat();
    		//printf("A: %.2f %.2f \n", real, imag);
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
    		signal[i] = (int)real;
    		signal[i + cellSize] = (int)imag;
    		//printf("B: %d %d \n", signal[i], signal[i + cellSize]);
    	}
    	return signal;
    }
    int * getGeneratedQAM64Signal()
    {
    	for (int i = 0; i < cellSize; i++)
      {
        real = r.getRandomFloat();
        imag = r.getRandomFloat();
    		//printf("A: %.2f %.2f \n", real, imag);
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
    		signal[i] = (int)real;
    		signal[i + cellSize] = (int)imag;
    		//printf("B: %d %d \n", signal[i], signal[i + cellSize]);
      }
    	return signal;
    }
};
