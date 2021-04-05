#include <cstdio>
#include <iostream>
const int size = 5;

__global__ void add(int *a, int *b, int *c){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;
    int idx = i + size * j;
    if(i < size && j < size){
        c[idx] = a[idx] + b[idx];
    }
}

int main(){
    int a[size][size];
    int b[size][size];
    int c[size][size];
    int *g_a, *g_b, *g_c;
    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            a[i][j] = 1;
            b[i][j] = 2;
        }
    }
    a[0][3] = 4;
    cudaMalloc((void**)&g_a, sizeof(int) * size * size);
    cudaMalloc((void**)&g_b, sizeof(int) * size * size);
    cudaMalloc((void**)&g_c, sizeof(int) * size * size);
    cudaMemcpy(g_a, a, sizeof(int) * size * size, cudaMemcpyHostToDevice);
    cudaMemcpy(g_b, b, sizeof(int) * size * size, cudaMemcpyHostToDevice);
    //grid数量确保够用
    dim3 ThreadsPerBlock(16, 16);
    dim3 BlocksPerGrid((size - 1) / ThreadsPerBlock.x + 1, (size - 1) / ThreadsPerBlock.y + 1);
    add<<<BlocksPerGrid, ThreadsPerBlock>>>(g_a, g_b, g_c);
    //add<<<1, ThreadsPerBlock>>>(g_a, g_b, g_c);
    cudaMemcpy(c, g_c, sizeof(int) * size * size, cudaMemcpyDeviceToHost);
    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++)
            printf("%d ", c[i][j]);
        puts("");
    }
    return 0;
}