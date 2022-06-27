-- -*- lua -*-
family("rocm_provider")

-- Conflicting modules
unload( "hip", "hip-rocclr", "comgr", "rocm-cmake", "llvm-amdgpu",
"rocm-device-libs", "hsa-rocr-dev", "hsakmt-roct", "rocminfo", "rccl",
"hipify-clang", "hipblas", "hipcub", "hipsparse", "hipfort", "rocm-opencl",
"rocm-clang-ocl", "rocm-opencl-runtime", "rocm-openmp-extras", "rocblas",
"rocfft", "rocrand", "rocthrust", "rocsolver", "rocsparse", "rocprofiler-dev",
"rocprim", "rocm-smi", "rocm-smi-lib", "miopen-hip", "rocalution", "rocm-gdb")

conflict( "hip", "hip-rocclr", "comgr", "rocm-cmake", "llvm-amdgpu",
"rocm-device-libs", "hsa-rocr-dev", "hsakmt-roct", "rocminfo", "rccl",
"hipify-clang", "hipblas", "hipcub", "hipsparse", "hipfort", "rocm-opencl",
"rocm-clang-ocl", "rocm-opencl-runtime", "rocm-openmp-extras", "rocblas",
"rocfft", "rocrand", "rocthrust", "rocsolver", "rocsparse", "rocprofiler-dev",
"rocprim", "rocm-smi", "rocm-smi-lib", "miopen-hip", "rocalution", "rocm-gdb")


whatis([[Name : hip]])
whatis([[Version : 4.5.0]])
whatis([[Short description : HIP is a C++ Runtime API and Kernel Language that allows developers to create portable applications for AMD and NVIDIA GPUs from single source code.]])

help([[HIP is a C++ Runtime API and Kernel Language that allows developers to
create portable applications for AMD and NVIDIA GPUs from single source
code.]])

local version = "4.5.0"
local rocm_path="/opt/rocm-" .. version


-- prepend_path("PATH", pathJoin(rocm_path, "llvm", "bin"), ":")
prepend_path("PATH", pathJoin(rocm_path, "bin"), ":")
-- MPB 2021-09-16: Removed ROCm LLVM lib dirs from the environment per
--                 discussion today with Matt Davis, Reuben Budiardja, Verónica
--                 Melesse Vergara, & Cathy Willis
-- prepend_path("LD_LIBRARY_PATH", pathJoin(rocm_path, "llvm", "lib"))
-- append_path("LIBRARY_PATH", pathJoin(rocm_path, "llvm", "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(rocm_path, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(rocm_path, "lib64"))

prepend_path("XLOCALEDIR", "/usr/share/X11/locale", ":")

prepend_path("CMAKE_PREFIX_PATH", rocm_path, ":")
prepend_path("CMAKE_PREFIX_PATH", pathJoin(rocm_path, "hip"), ":")

setenv("ROCM_PATH", rocm_path)
setenv("HIP_PATH", pathJoin(rocm_path, "hip"))
setenv("LLVM_PATH", pathJoin(rocm_path, "llvm"))
setenv("HIP_CLANG_PATH", pathJoin(rocm_path, "llvm/bin"))
setenv("HSA_PATH", rocm_path)
setenv("ROCMINFO_PATH", rocm_path)
setenv("DEVICE_LIB_PATH", pathJoin(rocm_path, "amdgcn/bitcode"))
setenv("HIP_DEVICE_LIB_PATH", pathJoin(rocm_path, "amdgcn/bitcode"))

setenv("HIP_PLATFORM", "amd")
setenv("HIP_COMPILER", "clang")
append_path("HIPCC_COMPILE_FLAGS_APPEND", "--rocm-path="..rocm_path, " ")

setenv("OLCF_ROCM_ROOT", rocm_path)



