# CppInterOp

[![Build Status](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Development

1. Build [Julia@1959349](https://github.com/JuliaLang/julia/commit/19593496a803c044ecb572087dbb2c19651d087e) from source and run:
```
LLVM_MAJOR_VER=`julia -e "print(Base.libllvm_version.major)"`
julia -e "using Pkg; pkg\"add LLVM_full_jll@${LLVM_MAJOR_VER}\""
LLVM_DIR=`julia -e "using LLVM_full_jll; print(LLVM_full_jll.artifact_dir)"`
echo "LLVM_DIR=$LLVM_DIR"
```

2. Build [CppInterOp](https://github.com/Gnimuc/CppInterOp/tree/c-api) by running:

```
cmake -B build -DBUILD_SHARED_LIBS=ON -DUSE_CLING=Off -DUSE_REPL=ON -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm -DClang_DIR=$LLVM_DIR/lib/cmake/clang -DCMAKE_INSTALL_PREFIX=./your_install_directory
cmake --build build --config Release --target install
cmake --build build --target check-cppinterop
```

3. Set `ENV["LIBCPPINTEROP_INSTALL_PREFIX"]` to the install directory and install the package by running:

```
pkg> dev https://github.com/Gnimuc/CppInterOp.jl.git
```

4. Test the package by running:

```
julia> import CppInterOp as Cpp
Precompiling CppInterOp...
  1 dependency successfully precompiled in 1 seconds. 36 already precompiled.

julia> Cpp.CreateInterpreter()

[70724] signal 11 (2): Segmentation fault: 11
in expression starting at REPL[2]:1
_ZN4llvm15AnalysisManagerINS_6ModuleEJEE13getResultImplEPNS_11AnalysisKeyERS1_ at /Users/gnimuc/Code/juliasrc/usr/lib/libLLVM.dylib (unknown line)
_ZN4llvm11PassManagerINS_6ModuleENS_15AnalysisManagerIS1_JEEEJEE3runERS1_RS3_ at /Users/gnimuc/Code/juliasrc/usr/lib/libLLVM.dylib (unknown line)
_ZN12_GLOBAL__N_118EmitAssemblyHelper23RunOptimizationPipelineEN5clang13BackendActionERNSt3__110unique_ptrIN4llvm17raw_pwrite_streamENS3_14default_deleteIS6_EEEERNS4_INS5_14ToolOutputFileENS7_ISB_EEEE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN5clang17EmitBackendOutputERNS_17DiagnosticsEngineERKNS_19HeaderSearchOptionsERKNS_14CodeGenOptionsERKNS_13TargetOptionsERKNS_11LangOptionsEN4llvm9StringRefEPNSE_6ModuleENS_13BackendActionENSE_18IntrusiveRefCntPtrINSE_3vfs10FileSystemEEENSt3__110unique_ptrINSE_17raw_pwrite_streamENSN_14default_deleteISP_EEEE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN5clang15BackendConsumer21HandleTranslationUnitERNS_10ASTContextE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN5clang17IncrementalParser23ParseOrWrapTopLevelDeclEv at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN5clang17IncrementalParserC2ERNS_11InterpreterENSt3__110unique_ptrINS_16CompilerInstanceENS3_14default_deleteIS5_EEEERN4llvm11LLVMContextERNS9_5ErrorE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN5clang11InterpreterC2ENSt3__110unique_ptrINS_16CompilerInstanceENS1_14default_deleteIS3_EEEERN4llvm5ErrorE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN5clang11Interpreter6createENSt3__110unique_ptrINS_16CompilerInstanceENS1_14default_deleteIS3_EEEE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN6compat22createClangInterpreterERNSt3__16vectorIPKcNS0_9allocatorIS3_EEEE at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN3Cpp11InterpreterC2EiPKPKcS2_RKNSt3__16vectorINS5_10shared_ptrIN5clang19ModuleFileExtensionEEENS5_9allocatorISA_EEEEPvb at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
_ZN3Cpp11InterpreterC1EiPKPKcS2_RKNSt3__16vectorINS5_10shared_ptrIN5clang19ModuleFileExtensionEEENS5_9allocatorISA_EEEEPvb at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
CreateInterpreter at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
clang_CppInterOp_CreateInterpreter at /Users/gnimuc/Code/CppInterOp/install/lib/libclangCppInterOp.dylib (unknown line)
clang_CppInterOp_CreateInterpreter at /Users/gnimuc/.julia/dev/CppInterOp/lib/17/LibCppInterOp.jl:460 [inlined]
CreateInterpreter at /Users/gnimuc/.julia/dev/CppInterOp/src/api.jl:439 [inlined]
CreateInterpreter at /Users/gnimuc/.julia/dev/CppInterOp/src/api.jl:439
unknown function (ip: 0x11254419b)
jl_apply at /Users/gnimuc/Code/juliasrc/src/./julia.h:2188 [inlined]
do_call at /Users/gnimuc/Code/juliasrc/src/interpreter.c:126
eval_stmt_value at /Users/gnimuc/Code/juliasrc/src/interpreter.c:174
eval_body at /Users/gnimuc/Code/juliasrc/src/interpreter.c:659
jl_interpret_toplevel_thunk at /Users/gnimuc/Code/juliasrc/src/interpreter.c:829
jl_toplevel_eval_flex at /Users/gnimuc/Code/juliasrc/src/toplevel.c:953
__repl_entry_eval_expanded_with_loc at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:220
toplevel_eval_with_hooks at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:227
toplevel_eval_with_hooks at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:231
toplevel_eval_with_hooks at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:231
toplevel_eval_with_hooks at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:231
toplevel_eval_with_hooks at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:224 [inlined]
eval_user_input at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:249
repl_backend_loop at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:358
#start_repl_backend#59 at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:343
start_repl_backend at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:340
#run_repl#72 at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:499
run_repl at /Users/gnimuc/Code/juliasrc/usr/share/julia/stdlib/v1.12/REPL/src/REPL.jl:485
unknown function (ip: 0x1124086d7)
#1161 at ./client.jl:448
jfptr_YY.1161_16625 at /Users/gnimuc/Code/juliasrc/usr/share/julia/compiled/v1.12/REPL/u0gqU_DKBzt.dylib (unknown line)
jl_apply at /Users/gnimuc/Code/juliasrc/src/./julia.h:2188 [inlined]
jl_f__call_latest at /Users/gnimuc/Code/juliasrc/src/builtins.c:875
#invokelatest#2 at ./essentials.jl:1032 [inlined]
invokelatest at ./essentials.jl:1029 [inlined]
run_main_repl at ./client.jl:432
repl_main at ./client.jl:569 [inlined]
_start at ./client.jl:543
jfptr__start_70245 at /Users/gnimuc/Code/juliasrc/usr/lib/julia/sys.dylib (unknown line)
jl_apply at /Users/gnimuc/Code/juliasrc/src/./julia.h:2188 [inlined]
true_main at /Users/gnimuc/Code/juliasrc/src/jlapi.c:900
jl_repl_entrypoint at /Users/gnimuc/Code/juliasrc/src/jlapi.c:1059
Allocations: 2126721 (Pool: 2126605; Big: 116); GC: 4
[1]    70724 segmentation fault  juliasrc
```