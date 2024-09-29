#ifndef CPPINTEROP_C_CXCPPINTEROP_H
#define CPPINTEROP_C_CXCPPINTEROP_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_CppInterOp_EnableDebugOutput(bool value);

bool clang_CppInterOp_IsDebugOutputEnabled(void);

LLVM_CLANG_C_EXTERN_C_END

#endif // CPPINTEROP_C_CXCPPINTEROPINTERPRETER_H