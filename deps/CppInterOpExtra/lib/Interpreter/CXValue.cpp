#include "clang-c/CXValue.h"
#include "clang-c/CXString.h"
#include "clang/Interpreter/Interpreter.h"
#include "clang/Interpreter/Value.h"

#include <memory>

CXValue clang_createValueFromType(void *I, void *Ty) {
  auto V = std::make_unique<clang::Value>(static_cast<clang::Interpreter *>(I), Ty);
  return V.release();
}

void *clang_value_getType(CXValue V) {
  return static_cast<clang::Value *>(V)->getType().getAsOpaquePtr();
}

bool clang_value_isManuallyAlloc(CXValue V) {
  return static_cast<clang::Value *>(V)->isManuallyAlloc();
}

CXValueKind clang_value_getKind(CXValue V) {
  return static_cast<CXValueKind>(static_cast<clang::Value *>(V)->getKind());
}

void clang_value_setKind(CXValue V, CXValueKind K) {
  static_cast<clang::Value *>(V)->setKind(static_cast<clang::Value::Kind>(K));
}

void clang_value_setOpaqueType(CXValue V, void *Ty) {
  static_cast<clang::Value *>(V)->setOpaqueType(Ty);
}

void *clang_value_getPtr(CXValue V) { return static_cast<clang::Value *>(V)->getPtr(); }

void clang_value_setPtr(CXValue V, void *Ptr) {
  static_cast<clang::Value *>(V)->setPtr(Ptr);
}