#include "clang-c/CXCppInterOpExtra.h"
#include "clang/Interpreter/CppInterOp.h"

using namespace Cpp;

void clang_CppInterOp_EnableDebugOutput(bool value) { EnableDebugOutput(value); }

bool clang_CppInterOp_IsDebugOutputEnabled(void) { return IsDebugOutputEnabled(); }

