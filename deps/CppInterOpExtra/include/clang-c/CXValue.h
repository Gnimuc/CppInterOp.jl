#ifndef LLVM_CLANG_C_CXVALUE_H
#define LLVM_CLANG_C_CXVALUE_H

#include "clang-c/CXCppInterOp.h"
#include "clang-c/CXString.h"
#include "clang-c/CXValue.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXValue clang_createValueFromType(void *I, void *Ty);

void *clang_value_getType(CXValue V);

bool clang_value_isManuallyAlloc(CXValue V);

typedef enum {
  CXValue_Bool = 0,
  CXValue_Char_S,
  CXValue_SChar,
  CXValue_UChar,
  CXValue_Short,
  CXValue_UShort,
  CXValue_Int,
  CXValue_UInt,
  CXValue_Long,
  CXValue_ULong,
  CXValue_LongLong,
  CXValue_ULongLong,
  CXValue_Float,
  CXValue_Double,
  CXValue_LongDouble,
  CXValue_Void,
  CXValue_PtrOrObj,
  CXValue_Unspecified
} CXValueKind;

CXValueKind clang_value_getKind(CXValue V);

void clang_value_setKind(CXValue V, CXValueKind K);

void clang_value_setOpaqueType(CXValue V, void *Ty);

void *clang_value_getPtr(CXValue V);

void clang_value_setPtr(CXValue V, void *P);

LLVM_CLANG_C_EXTERN_C_END

#endif // LLVM_CLANG_C_CXVALUE_H