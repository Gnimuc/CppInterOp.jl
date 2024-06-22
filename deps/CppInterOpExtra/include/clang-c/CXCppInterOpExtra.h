#ifndef CPPINTEROP_C_CXCPPINTEROP_H
#define CPPINTEROP_C_CXCPPINTEROP_H

#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef void *CXCppInterpreter;
typedef void *CXCppScope;
typedef void *CXCppType;
typedef void *CXCppFunction;
typedef void *CXCppConstFunction;
typedef void *CXCppFuncAddr;
typedef void *CXCppObject;
typedef void *CXCppJitCall;

CXString clang_CppInterOp_GetVersion(void);

void clang_CppInterOp_EnableDebugOutput(bool value);

bool clang_CppInterOp_IsDebugOutputEnabled(void);

bool clang_CppInterOp_IsAggregate(CXCppScope scope);

bool clang_CppInterOp_IsNamespace(CXCppScope scope);

bool clang_CppInterOp_IsClass(CXCppScope scope);

bool clang_CppInterOp_IsComplete(CXCppScope scope);

size_t clang_CppInterOp_SizeOf(CXCppScope scope);

bool clang_CppInterOp_IsBuiltin(CXCppType type);

bool clang_CppInterOp_IsTemplate(CXCppScope scope);

bool clang_CppInterOp_IsTemplateSpecialization(CXCppScope scope);

bool clang_CppInterOp_IsTypedefed(CXCppScope scope);

bool clang_CppInterOp_IsAbstract(CXCppType type);

bool clang_CppInterOp_IsEnumScope(CXCppScope scope);

bool clang_CppInterOp_IsEnumConstant(CXCppScope scope);

bool clang_CppInterOp_IsEnumType(CXCppType type);

CXStringSet *clang_CppInterOp_GetEnums(CXCppScope scope);

bool clang_CppInterOp_IsSmartPtrType(CXCppType type);

CXCppType clang_CppInterOp_GetIntegerTypeFromEnumScope(CXCppScope scope);

CXCppType clang_CppInterOp_GetIntegerTypeFromEnumType(CXCppType type);

typedef struct {
  CXCppScope *Scopes;
  size_t Count;
} CXCppScopeSet;

void clang_CppInterOp_CXCppScopeSet_dispose(CXCppScopeSet scopes);

CXCppScopeSet clang_CppInterOp_GetEnumConstants(CXCppScope scope);

CXCppType clang_CppInterOp_GetEnumConstantType(CXCppScope scope);

size_t clang_CppInterOp_GetEnumConstantValue(CXCppScope scope);

size_t clang_CppInterOp_GetSizeOfType(CXCppType type);

bool clang_CppInterOp_IsVariable(CXCppScope scope);

CXString clang_CppInterOp_GetName(CXCppScope klass);

CXString clang_CppInterOp_GetCompleteName(CXCppType klass);

CXString clang_CppInterOp_GetQualifiedName(CXCppType klass);

CXString clang_CppInterOp_GetQualifiedCompleteName(CXCppType klass);

CXCppScopeSet clang_CppInterOp_GetUsingNamespaces(CXCppScope scope);

CXCppScope clang_CppInterOp_GetGlobalScope(void);

CXCppScope clang_CppInterOp_GetUnderlyingScope(CXCppScope scope);

CXCppScope clang_CppInterOp_GetScope(const char *name, CXCppScope parent);

CXCppScope clang_CppInterOp_GetScopeFromCompleteName(const char *name);

CXCppScope clang_CppInterOp_GetNamed(const char *name, CXCppScope parent);

CXCppScope clang_CppInterOp_GetParentScope(CXCppScope scope);

CXCppScope clang_CppInterOp_GetScopeFromType(CXCppType type);

size_t clang_CppInterOp_GetNumBases(CXCppType type);

CXCppScope clang_CppInterOp_GetBaseClass(CXCppType type, size_t ibase);

bool clang_CppInterOp_IsSubclass(CXCppScope derived, CXCppScope base);

int64_t clang_CppInterOp_GetBaseClassOffset(CXCppScope derived, CXCppScope base);

typedef struct {
  CXCppFunction *Funcs;
  size_t Count;
} CXCppFunctionSet;

void clang_CppInterOp_CXCppFunctionSet_dispose(CXCppFunctionSet funcs);

CXCppFunctionSet clang_CppInterOp_GetClassMethods(CXCppScope klass);

bool clang_CppInterOp_HasDefaultConstructor(CXCppScope scope);

CXCppFunction clang_CppInterOp_GetDefaultConstructor(CXCppScope scope);

CXCppFunction clang_CppInterOp_GetDestructor(CXCppScope scope);

CXCppFunctionSet clang_CppInterOp_GetFunctionsUsingName(CXCppScope scope, const char *name);

CXCppType clang_CppInterOp_GetFunctionReturnType(CXCppFunction func);

size_t clang_CppInterOp_GetFunctionNumArgs(CXCppFunction func);

size_t clang_CppInterOp_GetFunctionRequiredArgs(CXCppConstFunction func);

CXCppType clang_CppInterOp_GetFunctionArgType(CXCppFunction func, size_t iarg);

CXString clang_CppInterOp_GetFunctionSignature(CXCppFunction func);

bool clang_CppInterOp_IsFunctionDeleted(CXCppConstFunction function);

bool clang_CppInterOp_IsTemplatedFunction(CXCppFunction func);

bool clang_CppInterOp_ExistsFunctionTemplate(const char *name, CXCppScope parent);

bool clang_CppInterOp_IsMethod(CXCppConstFunction method);

bool clang_CppInterOp_IsPublicMethod(CXCppFunction method);

bool clang_CppInterOp_IsProtectedMethod(CXCppFunction method);

bool clang_CppInterOp_IsPrivateMethod(CXCppFunction method);

bool clang_CppInterOp_IsConstructor(CXCppConstFunction method);

bool clang_CppInterOp_IsDestructor(CXCppConstFunction method);

bool clang_CppInterOp_IsStaticMethod(CXCppConstFunction method);

CXCppFuncAddr clang_CppInterOp_GetFunctionAddressFromMangledName(const char *mangled_name);

CXCppFuncAddr clang_CppInterOp_GetFunctionAddressFromMethod(CXCppFunction method);

bool clang_CppInterOp_IsVirtualMethod(CXCppFunction method);

CXCppScopeSet clang_CppInterOp_GetDatamembers(CXCppScope scope);

CXCppScope clang_CppInterOp_LookupDatamember(const char *name, CXCppScope parent);

CXCppType clang_CppInterOp_GetVariableType(CXCppScope var);

intptr_t clang_CppInterOp_GetVariableOffset(CXCppScope var);

bool clang_CppInterOp_IsPublicVariable(CXCppScope var);

bool clang_CppInterOp_IsProtectedVariable(CXCppScope var);

bool clang_CppInterOp_IsPrivateVariable(CXCppScope var);

bool clang_CppInterOp_IsStaticVariable(CXCppScope var);

bool clang_CppInterOp_IsConstVariable(CXCppScope var);

bool clang_CppInterOp_IsRecordType(CXCppType type);

bool clang_CppInterOp_IsPODType(CXCppType type);

CXCppType clang_CppInterOp_GetUnderlyingType(CXCppType type);

CXString clang_CppInterOp_GetTypeAsString(CXCppType type);

CXCppType clang_CppInterOp_GetCanonicalType(CXCppType type);

CXCppType clang_CppInterOp_GetType(const char *type);

CXCppType clang_CppInterOp_GetComplexType(CXCppType element_type);

CXCppType clang_CppInterOp_GetTypeFromScope(CXCppScope scope);

bool clang_CppInterOp_IsTypeDerivedFrom(CXCppType derived, CXCppType base);

CXCppJitCall clang_CppInterOp_MakeFunctionCallable(CXCppConstFunction func);

void clang_CppInterOp_CXCppJitCall_dispose(CXCppJitCall call);

bool clang_CppInterOp_IsConstMethod(CXCppFunction method);

CXString clang_CppInterOp_GetFunctionArgDefault(CXCppFunction func, size_t param_index);

CXString clang_CppInterOp_GetFunctionArgName(CXCppFunction func, size_t param_index);

CXCppInterpreter clang_CppInterOp_CreateInterpreter(const char **args, size_t num_args,
                                                    const char **gpu_args,
                                                    size_t num_gpu_args);

CXCppInterpreter clang_CppInterOp_GetInterpreter(void);

void clang_CppInterOp_AddSearchPath(const char *dir, bool isUser, bool prepend);

const char *clang_CppInterOp_GetResourceDir(void);

void clang_CppInterOp_AddIncludePath(const char *dir);

int clang_CppInterOp_Declare(const char *code, bool silent);

int clang_CppInterOp_Process(const char *code);

intptr_t clang_CppInterOp_Evaluate(const char *code, bool *HadError);

CXString clang_CppInterOp_LookupLibrary(const char *lib_name);

bool clang_CppInterOp_LoadLibrary(const char *lib_stem, bool lookup);

void clang_CppInterOp_UnloadLibrary(const char *lib_stem);

CXString clang_CppInterOp_SearchLibrariesForSymbol(const char *mangled_name,
                                                   bool search_system);

bool clang_CppInterOp_InsertOrReplaceJitSymbol(const char *linker_mangled_name,
                                               uint64_t address);

CXString clang_CppInterOp_ObjToString(const char *type, void *obj);

typedef struct {
  CXCppType m_Type;
  char *m_IntegralValue;
} CXTemplateArgInfo;

CXCppScope clang_CppInterOp_InstantiateTemplate(CXCppScope tmpl,
                                                CXTemplateArgInfo *template_args,
                                                size_t template_args_size);

typedef struct {
  CXTemplateArgInfo *Args;
  size_t Count;
} CXTemplateArgInfoSet;

void clang_CppInterOp_CXTemplateArgInfoSet_dispose(CXTemplateArgInfoSet args);

CXTemplateArgInfoSet
clang_CppInterOp_GetClassTemplateInstantiationArgs(CXCppScope templ_instance);

CXCppFunction
clang_CppInterOp_InstantiateTemplateFunctionFromString(const char *function_template);

CXStringSet *clang_CppInterOp_GetAllCppNames(CXCppScope scope);

void clang_CppInterOp_DumpScope(CXCppScope scope);

typedef struct {
  size_t *Dims;
  size_t Count;
} CXCppDimensions;

void clang_CppInterOp_CXCppDimensions_dispose(CXCppDimensions dims);

CXCppDimensions clang_CppInterOp_GetDimensions(CXCppType type);

CXCppObject clang_CppInterOp_Allocate(CXCppScope scope);

void clang_CppInterOp_Deallocate(CXCppScope scope, CXCppObject address);

CXCppObject clang_CppInterOp_Construct(CXCppScope scope, void *arena);

void clang_CppInterOp_Destruct(CXCppObject This, CXCppScope type, bool withFree);

typedef enum CXCppCaptureStreamKind {
  CXCppkStdOut = 1, ///< stdout
  CXCppkStdErr,     ///< stderr
  // CXCppkStdBoth,    ///< stdout and stderr
  // CXCppkSTDSTRM  // "&1" or "&2" is not a filename
} CXCppCaptureStreamKind;

void clang_CppInterOp_BeginStdStreamCapture(CXCppCaptureStreamKind fd_kind);

CXString clang_CppInterOp_EndStdStreamCapture(void);

LLVM_CLANG_C_EXTERN_C_END

#endif // CPPINTEROP_C_CXCPPINTEROPINTERPRETER_H