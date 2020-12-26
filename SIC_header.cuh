//number of clusters is a group size
//one thread is assigned per cluster
#define numberOfUEs 10
#define groupSize 32
//this is cellCoefficients is for the number of blocks initiated
#define cellCoefficient 6
#define cellSize 1920
// always check cell size:
// cell size = numberOfUEs x groupSize x cell coefficient
#define modulation 4
int * getGeneratedQPSKSignal(void);
int * getGeneratedQAM16Signal(void);
int * getGeneratedQAM64Signal(void);
double * getGeneratedRayleighChannel(float *powerCoefficientMatrix);
