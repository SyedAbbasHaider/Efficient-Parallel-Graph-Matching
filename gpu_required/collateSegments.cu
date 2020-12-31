/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void collateSegments_gpu(int * src, int * scanResult, int * output, int numEdges) {
	
	int i;
	int tid = blockIdx.x * blockDim.x + threadIdx.x; //global index of the thread
	int total_threads = blockDim.x * gridDim.x; //total number of threads
	
	for(i=tid; i < numEdges; i += total_threads){
		if(src[i] != src[i+1]){
			output[src[i]] = scanResult[i];
		}
	}//end for loop

}//end main function
