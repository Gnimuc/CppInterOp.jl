#include "clang-c/CXCppInterOpExtra.h"
#include "clang-c/CXString.h"
#include "clang/Interpreter/CppInterOp.h"
#include <cstring>
#include <memory>

using namespace Cpp;

CXString createCXString(const std::string &str) {
  char *s = new char[str.length() + 1];
  std::strcpy(s, str.c_str());

  CXString Str;
  Str.data = s && s[0] == '\0' ? "" : s;
  Str.private_flags = 1; // CXS_Malloc
  return Str;
}

CXStringSet *createCXStringSet(const std::vector<std::string> &strs) {
  CXStringSet *Set = new CXStringSet;
  Set->Count = strs.size();
  Set->Strings = new CXString[Set->Count];
  for (unsigned int i = 0; i < Set->Count; ++i) {
    char *Str = new char[strs[i].length() + 1];
    std::strcpy(Str, strs[i].c_str());
    Set->Strings[i].data = Str && Str[0] == '\0' ? "" : Str;
    Set->Strings[i].private_flags = 1; // CXS_Malloc
  }
  return Set;
}

CXString clang_CppInterOp_GetVersion(void) { return createCXString(GetVersion()); }

void clang_CppInterOp_EnableDebugOutput(bool value) { EnableDebugOutput(value); }

bool clang_CppInterOp_IsDebugOutputEnabled(void) { return IsDebugOutputEnabled(); }

bool clang_CppInterOp_IsAggregate(CXCppScope scope) { return IsAggregate(scope); }

bool clang_CppInterOp_IsNamespace(CXCppScope scope) { return IsNamespace(scope); }

bool clang_CppInterOp_IsClass(CXCppScope scope) { return IsClass(scope); }

bool clang_CppInterOp_IsComplete(CXCppScope scope) { return IsComplete(scope); }

size_t clang_CppInterOp_SizeOf(CXCppScope scope) { return SizeOf(scope); }

bool clang_CppInterOp_IsBuiltin(CXCppType type) { return IsBuiltin(type); }

bool clang_CppInterOp_IsTemplate(CXCppScope scope) { return IsTemplate(scope); }

bool clang_CppInterOp_IsTemplateSpecialization(CXCppScope scope) {
  return IsTemplateSpecialization(scope);
}

bool clang_CppInterOp_IsTypedefed(CXCppScope scope) { return IsTypedefed(scope); }

bool clang_CppInterOp_IsAbstract(CXCppType type) { return IsAbstract(type); }

bool clang_CppInterOp_IsEnumScope(CXCppScope scope) { return IsEnumScope(scope); }

bool clang_CppInterOp_IsEnumConstant(CXCppScope scope) { return IsEnumConstant(scope); }

bool clang_CppInterOp_IsEnumType(CXCppType type) { return IsEnumType(type); }

CXStringSet *clang_CppInterOp_GetEnums(CXCppScope scope) {
  std::vector<std::string> EnumNames;
  GetEnums(scope, EnumNames);
  return createCXStringSet(EnumNames);
}

bool clang_CppInterOp_IsSmartPtrType(CXCppType type) { return IsSmartPtrType(type); }

CXCppType clang_CppInterOp_GetIntegerTypeFromEnumScope(CXCppScope scope) {
  return GetIntegerTypeFromEnumScope(scope);
}

CXCppType clang_CppInterOp_GetIntegerTypeFromEnumType(CXCppType type) {
  return GetIntegerTypeFromEnumType(type);
}

void clang_CppInterOp_CXCppScopeSet_dispose(CXCppScopeSet scopes) {
  if (scopes.Scopes)
    delete scopes.Scopes;
}

CXCppScopeSet clang_CppInterOp_GetEnumConstants(CXCppScope scope) {
  CXCppScopeSet S;
  const auto &V = GetEnumConstants(scope);
  S.Count = V.size();
  S.Scopes = new CXCppScope[S.Count];
  std::copy(V.begin(), V.end(), S.Scopes);
  return S;
}

CXCppType clang_CppInterOp_GetEnumConstantType(CXCppScope scope) {
  return GetEnumConstantType(scope);
}

size_t clang_CppInterOp_GetEnumConstantValue(CXCppScope scope) {
  return GetEnumConstantValue(scope);
}

size_t clang_CppInterOp_GetSizeOfType(CXCppType type) { return GetSizeOfType(type); }

bool clang_CppInterOp_IsVariable(CXCppScope scope) { return IsVariable(scope); }

CXString clang_CppInterOp_GetName(CXCppScope klass) {
  return createCXString(GetName(klass));
}

CXString clang_CppInterOp_GetCompleteName(CXCppType klass) {
  return createCXString(GetCompleteName(klass));
}

CXString clang_CppInterOp_GetQualifiedName(CXCppType klass) {
  return createCXString(GetQualifiedName(klass));
}

CXString clang_CppInterOp_GetQualifiedCompleteName(CXCppType klass) {
  return createCXString(GetQualifiedCompleteName(klass));
}

CXCppScopeSet clang_CppInterOp_GetUsingNamespaces(CXCppScope scope) {
  CXCppScopeSet S;
  const auto &V = GetUsingNamespaces(scope);
  S.Count = V.size();
  S.Scopes = new CXCppScope[S.Count];
  std::copy(V.begin(), V.end(), S.Scopes);
  return S;
}

CXCppScope clang_CppInterOp_GetGlobalScope(void) { return GetGlobalScope(); }

CXCppScope clang_CppInterOp_GetUnderlyingScope(CXCppScope scope) {
  return GetUnderlyingScope(scope);
}

CXCppScope clang_CppInterOp_GetScope(const char *name, CXCppScope parent) {
  std::string s(name);
  return GetScope(s, parent);
}

CXCppScope clang_CppInterOp_GetScopeFromCompleteName(const char *name) {
  std::string s(name);
  return GetScopeFromCompleteName(s);
}

CXCppScope clang_CppInterOp_GetNamed(const char *name, CXCppScope parent) {
  std::string s(name);
  return GetNamed(s, parent);
}

CXCppScope clang_CppInterOp_GetParentScope(CXCppScope scope) {
  return GetParentScope(scope);
}

CXCppScope clang_CppInterOp_GetScopeFromType(CXCppType type) {
  return GetScopeFromType(type);
}

size_t clang_CppInterOp_GetNumBases(CXCppType type) { return GetNumBases(type); }

CXCppType clang_CppInterOp_GetBaseClass(CXCppType type, size_t index) {
  return GetBaseClass(type, index);
}

bool clang_CppInterOp_IsSubclass(CXCppScope derived, CXCppScope base) {
  return IsSubclass(derived, base);
}

int64_t clang_CppInterOp_GetBaseClassOffset(CXCppScope derived, CXCppScope base) {
  return GetBaseClassOffset(derived, base);
}

void clang_CppInterOp_CXCppFunctionSet_dispose(CXCppFunctionSet funcs) {
  if (funcs.Funcs)
    delete funcs.Funcs;
}

CXCppFunctionSet clang_CppInterOp_GetClassMethods(CXCppScope klass) {
  CXCppFunctionSet S;
  std::vector<TCppFunction_t> V;
  GetClassMethods(klass, V);
  S.Count = V.size();
  S.Funcs = new CXCppFunction[S.Count];
  std::copy(V.begin(), V.end(), S.Funcs);
  return S;
}

bool clang_CppInterOp_HasDefaultConstructor(CXCppScope scope) {
  return HasDefaultConstructor(scope);
}

CXCppFunction clang_CppInterOp_GetDefaultConstructor(CXCppScope scope) {
  return GetDefaultConstructor(scope);
}

CXCppFunction clang_CppInterOp_GetDestructor(CXCppScope scope) {
  return GetDestructor(scope);
}

CXCppFunctionSet clang_CppInterOp_GetFunctionsUsingName(CXCppScope scope,
                                                        const char *name) {
  std::string s(name);
  CXCppFunctionSet S;
  const auto &V = GetFunctionsUsingName(scope, s);
  S.Count = V.size();
  S.Funcs = new CXCppFunction[S.Count];
  std::copy(V.begin(), V.end(), S.Funcs);
  return S;
}

CXCppType clang_CppInterOp_GetFunctionReturnType(CXCppFunction func) {
  return GetFunctionReturnType(func);
}

size_t clang_CppInterOp_GetFunctionNumArgs(CXCppFunction func) {
  return GetFunctionNumArgs(func);
}

size_t clang_CppInterOp_GetFunctionRequiredArgs(CXCppConstFunction func) {
  return GetFunctionRequiredArgs(func);
}

CXCppType clang_CppInterOp_GetFunctionArgType(CXCppFunction func, size_t index) {
  return GetFunctionArgType(func, index);
}

CXString clang_CppInterOp_GetFunctionSignature(CXCppFunction func) {
  return createCXString(GetFunctionSignature(func));
}

bool clang_CppInterOp_IsFunctionDeleted(CXCppConstFunction func) {
  return IsFunctionDeleted(func);
}

bool clang_CppInterOp_IsTemplatedFunction(CXCppFunction func) {
  return IsTemplatedFunction(func);
}

bool clang_CppInterOp_ExistsFunctionTemplate(const char *name, CXCppScope parent) {
  std::string s(name);
  return ExistsFunctionTemplate(s, parent);
}

bool clang_CppInterOp_IsMethod(CXCppConstFunction method) { return IsMethod(method); }

bool clang_CppInterOp_IsPublicMethod(CXCppFunction method) {
  return IsPublicMethod(method);
}

bool clang_CppInterOp_IsProtectedMethod(CXCppFunction method) {
  return IsProtectedMethod(method);
}

bool clang_CppInterOp_IsPrivateMethod(CXCppFunction method) {
  return IsPrivateMethod(method);
}

bool clang_CppInterOp_IsConstructor(CXCppConstFunction method) {
  return IsConstructor(method);
}

bool clang_CppInterOp_IsDestructor(CXCppConstFunction method) {
  return IsDestructor(method);
}

bool clang_CppInterOp_IsStaticMethod(CXCppConstFunction method) {
  return IsStaticMethod(method);
}

CXCppFuncAddr clang_CppInterOp_GetFunctionAddressFromMangledName(const char *mangled_name) {
  return GetFunctionAddress(mangled_name);
}

CXCppFuncAddr clang_CppInterOp_GetFunctionAddressFromMethod(CXCppFunction method) {
  return GetFunctionAddress(method);
}

bool clang_CppInterOp_IsVirtualMethod(CXCppFunction method) {
  return IsVirtualMethod(method);
}

CXCppScopeSet clang_CppInterOp_GetDatamembers(CXCppScope scope) {
  CXCppScopeSet S;
  const auto &V = GetDatamembers(scope);
  S.Count = V.size();
  S.Scopes = new CXCppScope[S.Count];
  std::copy(V.begin(), V.end(), S.Scopes);
  return S;
}

CXCppScope clang_CppInterOp_LookupDatamember(const char *name, CXCppScope parent) {
  std::string s(name);
  return LookupDatamember(s, parent);
}

CXCppType clang_CppInterOp_GetVariableType(CXCppScope var) { return GetVariableType(var); }

intptr_t clang_CppInterOp_GetVariableOffset(CXCppScope var) {
  return GetVariableOffset(var);
}

bool clang_CppInterOp_IsPublicVariable(CXCppScope var) { return IsPublicVariable(var); }

bool clang_CppInterOp_IsProtectedVariable(CXCppScope var) {
  return IsProtectedVariable(var);
}

bool clang_CppInterOp_IsPrivateVariable(CXCppScope var) { return IsPrivateVariable(var); }

bool clang_CppInterOp_IsStaticVariable(CXCppScope var) { return IsStaticVariable(var); }

bool clang_CppInterOp_IsConstVariable(CXCppScope var) { return IsConstVariable(var); }

bool clang_CppInterOp_IsRecordType(CXCppType type) { return IsRecordType(type); }

bool clang_CppInterOp_IsPODType(CXCppType type) { return IsPODType(type); }

CXCppType clang_CppInterOp_GetUnderlyingType(CXCppType type) {
  return GetUnderlyingType(type);
}

CXString clang_CppInterOp_GetTypeAsString(CXCppType type) {
  return createCXString(GetTypeAsString(type));
}

CXCppType clang_CppInterOp_GetCanonicalType(CXCppType type) {
  return GetCanonicalType(type);
}

CXCppType clang_CppInterOp_GetType(const char *type) {
  std::string s(type);
  return GetType(s);
}

CXCppType clang_CppInterOp_GetComplexType(CXCppType element_type) {
  return GetComplexType(element_type);
}

CXCppType clang_CppInterOp_GetTypeFromScope(CXCppScope scope) {
  return GetTypeFromScope(scope);
}

bool clang_CppInterOp_IsTypeDerivedFrom(CXCppType derived, CXCppType base) {
  return IsTypeDerivedFrom(derived, base);
}

CXCppJitCall clang_CppInterOp_MakeFunctionCallable(CXCppConstFunction func) {
  auto C = std::make_unique<JitCall>(MakeFunctionCallable(func));
  return C.release();
}

void clang_CppInterOp_CXCppJitCall_dispose(CXCppJitCall call) {
  delete static_cast<JitCall *>(call);
}

bool clang_CppInterOp_IsConstMethod(CXCppFunction method) { return IsConstMethod(method); }

CXString clang_CppInterOp_GetFunctionArgDefault(CXCppFunction func, size_t index) {
  return createCXString(GetFunctionArgDefault(func, index));
}

CXString clang_CppInterOp_GetFunctionArgName(CXCppFunction func, size_t index) {
  return createCXString(GetFunctionArgName(func, index));
}

CXCppInterpreter clang_CppInterOp_CreateInterpreter(const char **args, size_t num_args,
                                                    const char **gpu_args,
                                                    size_t num_gpu_args) {
  std::vector<const char *> Args;
  for (size_t i = 0; i < num_args; i++) {
    Args.push_back(args[i]);
  }
  std::vector<const char *> GpuArgs;
  for (size_t i = 0; i < num_gpu_args; i++) {
    GpuArgs.push_back(gpu_args[i]);
  }
  return CreateInterpreter(Args, GpuArgs);
}

CXCppInterpreter clang_CppInterOp_GetInterpreter(void) { return GetInterpreter(); }

void clang_CppInterOp_AddSearchPath(const char *dir, bool isUser, bool prepend) {
  AddSearchPath(dir, isUser, prepend);
}

const char *clang_CppInterOp_GetResourceDir(void) { return GetResourceDir(); }

void clang_CppInterOp_AddIncludePath(const char *dir) { AddIncludePath(dir); }

int clang_CppInterOp_Declare(const char *code, bool silent) {
  return Declare(code, silent);
}

int clang_CppInterOp_Process(const char *code) { return Process(code); }

intptr_t clang_CppInterOp_Evaluate(const char *code, bool *had_error) {
  return Evaluate(code, had_error);
}

CXString clang_CppInterOp_LookupLibrary(const char *lib_name) {
  return createCXString(LookupLibrary(lib_name));
}

bool clang_CppInterOp_LoadLibrary(const char *lib_stem, bool lookup) {
  return LoadLibrary(lib_stem, lookup);
}

void clang_CppInterOp_UnloadLibrary(const char *lib_stem) { UnloadLibrary(lib_stem); }

CXString clang_CppInterOp_SearchLibrariesForSymbol(const char *mangled_name,
                                                   bool search_system) {
  return createCXString(SearchLibrariesForSymbol(mangled_name, search_system));
}

bool clang_CppInterOp_InsertOrReplaceJitSymbol(const char *linker_mangled_name,
                                               uint64_t address) {
  return InsertOrReplaceJitSymbol(linker_mangled_name, address);
}

CXString clang_CppInterOp_ObjToString(const char *type, void *obj) {
  return createCXString(ObjToString(type, obj));
}

CXCppScope clang_CppInterOp_InstantiateTemplate(CXCppScope tmpl,
                                                CXTemplateArgInfo *template_args,
                                                size_t template_args_size) {
  std::vector<TemplateArgInfo> Args;
  for (size_t i = 0; i < template_args_size; i++) {
    Args.push_back({template_args[i].m_Type, template_args[i].m_IntegralValue});
  }
  return InstantiateTemplate(tmpl, Args.data(), Args.size());
}

CXCppFunction
clang_CppInterOp_InstantiateTemplateFunctionFromString(const char *function_template) {
  return InstantiateTemplateFunctionFromString(function_template);
}

void clang_CppInterOp_CXTemplateArgInfoSet_dispose(CXTemplateArgInfoSet args) {
  if (args.Args)
    delete args.Args;
}

CXTemplateArgInfoSet
clang_CppInterOp_GetClassTemplateInstantiationArgs(CXCppScope templ_instance) {
  CXTemplateArgInfoSet S;
  std::vector<TemplateArgInfo> V;
  GetClassTemplateInstantiationArgs(templ_instance, V);
  S.Count = V.size();
  S.Args = new CXTemplateArgInfo[S.Count];
  for (size_t i = 0; i < S.Count; i++) {
    S.Args[i].m_Type = V[i].m_Type;
    S.Args[i].m_IntegralValue = const_cast<char *>(V[i].m_IntegralValue);
  }
  return S;
}

CXStringSet *clang_CppInterOp_GetAllCppNames(CXCppScope scope) {
  return createCXStringSet(GetAllCppNames(scope));
}

void clang_CppInterOp_DumpScope(CXCppScope scope) { DumpScope(scope); }

void clang_CppInterOp_CXCppDimensions_dispose(CXCppDimensions dims) {
  if (dims.Dims)
    delete dims.Dims;
}

CXCppDimensions clang_CppInterOp_GetDimensions(CXCppType type) {
  CXCppDimensions D;
  const auto &V = GetDimensions(type);
  D.Count = V.size();
  D.Dims = new size_t[D.Count];
  std::copy(V.begin(), V.end(), D.Dims);
  return D;
}

CXCppObject clang_CppInterOp_Allocate(CXCppScope scope) { return Allocate(scope); }

void clang_CppInterOp_Deallocate(CXCppScope scope, CXCppObject address) {
  Deallocate(scope, address);
}

CXCppObject clang_CppInterOp_Construct(CXCppScope scope, void *arena) {
  return Construct(scope, arena);
}

void clang_CppInterOp_Destruct(CXCppObject This, CXCppScope type, bool withFree) {
  Destruct(This, type, withFree);
}

void clang_CppInterOp_BeginStdStreamCapture(CXCppCaptureStreamKind fd_kind) {
  BeginStdStreamCapture(static_cast<CaptureStreamKind>(fd_kind));
}

CXString clang_CppInterOp_EndStdStreamCapture(void) {
  return createCXString(EndStdStreamCapture().c_str());
}