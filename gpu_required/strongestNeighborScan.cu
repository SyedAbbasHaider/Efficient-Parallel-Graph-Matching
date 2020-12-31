/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__device__ int small_helper(int x, int y){
	if(x < y){
		return x;
	}
	else{
		return y;
	}
}//end helper function

__global__ void strongestNeighborScan_gpu(int * src, int * oldDst, int * newDst, int * oldWeight, int * newWeight, int * madeChanges, int distance, int numEdges) {
	
	int i ;
	int tid = blockIdx.x * blockDim.x + threadIdx.x; //global index of the thread
	int total_threads = blockDim.x * gridDim.x; //total number of threads
	
	for(i=tid; i < numEdges; i += total_threads){

		if(tid >= numEdges){ //terminate if thread ID is larger than array size
			return;
		}
	
		if(src[i] == src[i-distance]){//if they are in same segments
			if(oldWeight[i] == oldWeight[i-distance]){//if adjacent weights are same
				newDst[i] = small_helper(oldDst[i], oldDst[i-distance]);//update newDst
				newWeight[i] = oldWeight[i];//update newWeight
			}
			else{//if adjacent weights are not same
				newWeight[i] = max(oldWeight[i], oldWeight[i-distance]); //update newWeight
				if(newWeight[i] == oldWeight[i]){ //update newDst
					newDst[i] = oldDst[i];
				}else{
					newDst[i] = oldDst[i-distance];
				} 
			}	
		}

		else{//they are not in same segment
			newWeight[i] = oldWeight[i];
			newDst[i] = oldDst[i];
		}

		//check termination
		if(oldDst[i] != newDst[i]){
			*madeChanges = 1;
		}

	}//end for loop

}//end fucntion