NVCC=nvcc
CUDAFLAGS= -arch=sm_60
OPT= -g -G
RM=/bin/rm -f
all: SIC

main: SIC.o SIC_QPSK.o SIC_QAM16.o SIC_QAM64.o SIC_Rayleigh.cpp
	${NVCC} ${OPT} -o main SIC.o SIC_QPSK.o SIC_QAM16.o SIC_QAM64.o SIC_Rayleigh.o

SIC_Rayleigh.o: SIC_header.cuh SIC_Rayleigh.cpp
	${NVCC} ${OPT} ${CUDAFLAGS} -std=c++11 -c SIC_Rayleigh.cpp

SIC_QAM64.o: SIC_header.cuh SIC_QAM64.cpp
	${NVCC} ${OPT} ${CUDAFLAGS} -std=c++11 -c SIC_QAM64.cpp

SIC_QAM16.o: SIC_header.cuh SIC_QAM16.cpp
	${NVCC} ${OPT} ${CUDAFLAGS} -std=c++11 -c SIC_QAM16.cpp

SIC_QPSK.o: SIC_header.cuh SIC_QPSK.cpp
	${NVCC} ${OPT} ${CUDAFLAGS} -std=c++11 -c SIC_QPSK.cpp

SIC.o: SIC_header.cuh SIC.cu
	$(NVCC) ${OPT} $(CUDAFLAGS)	-std=c++11 -c SIC.cu -lcufft

SIC: SIC.o SIC_QPSK.o SIC_QAM16.o SIC_QAM64.o SIC_Rayleigh.o
	${NVCC} ${CUDAFLAGS} -o SIC SIC.o SIC_QPSK.o SIC_QAM16.o SIC_QAM64.o SIC_Rayleigh.o -lcufft

clean:
	${RM} *.o SIC
