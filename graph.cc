// Example HIP code showing an issue with graph API in rocm-5.1.0
// from Cyril CETRE
// ref: https://github.com/ROCm-Developer-Tools/HIP/issues/2550
#include <hip/hip_runtime.h>
#include <stdio.h>
#include <iostream>
#include <unistd.h>
#include <string>
#include <vector>

template <typename T>
void check(T result, char const *const func, const char *const file,
           int const line) {
  if (result) {
    fprintf(stderr, "Hip error at %s:%d code=%d(%s) \"%s\" \n", file, line,
            static_cast<unsigned int>(result), hipGetErrorName(result), func);
    exit(EXIT_FAILURE);
  }
}
#define checkHipErrors(val) check((val), #val, __FILE__, __LINE__)

__global__ void kernel(int i, volatile int *stop) {
    printf("Kernel %d going...\n", i);
}

int main(int argc, char* argv[]) {
  int n = 4;
  if(argc > 1)
    n = std::stoi(argv[1]);
  std::vector<hipStream_t> streams(n);
  int* stop;
  for (int i = 0; i < n; ++i)
    hipStreamCreate(&streams[i]);

  std::vector<hipGraph_t> cuGraphs(n);
  std::vector<hipGraphExec_t> graphExec(n, NULL);

  for (int i = 0; i < n; ++i) {
    checkHipErrors(hipStreamBeginCapture(streams[i], hipStreamCaptureModeGlobal));

    hipLaunchKernelGGL(kernel, dim3(1), dim3(1), 0, streams[i], i, stop);

    checkHipErrors(hipStreamEndCapture(streams[i], &cuGraphs[i]));
    checkHipErrors(hipGraphInstantiate(&graphExec[i], cuGraphs[i], NULL, NULL, 0));
    checkHipErrors(hipGraphDestroy(cuGraphs[i]));
  }
  std::cout << "launching graph..." << std::endl;
  
  for (int i = 0; i < n; ++i) 
    checkHipErrors(hipGraphLaunch(graphExec[i], streams[i]));
  std::cout << "Synchronizing processes..." << std::endl;
  hipDeviceSynchronize();

  return 0;
}
