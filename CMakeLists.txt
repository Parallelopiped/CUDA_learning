

cmake_minimum_required(VERSION 3.13)
project(cudaclion)

set(CMAKE_CXX_STANDARD 14)
find_package(CUDA REQUIRED)
file(GLOB CU matrixmul.cu)
cuda_add_executable(kernel matrixmul.cu)
