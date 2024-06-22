module LibCppInterOp

using ..CppInterOp: libCppInterOp
using ..CppInterOp: CXErrorCode, CXTypeKind, CXString, CXStringSet

const intptr_t = Clong


mutable struct CXInterpreterImpl end

const CXInterpreter = Ptr{CXInterpreterImpl}

function clang_createInterpreter(argv, argc)
    @ccall libCppInterOp.clang_createInterpreter(argv::Ptr{Ptr{Cchar}}, argc::Cint)::CXInterpreter
end

const TInterp_t = Ptr{Cvoid}

function clang_createInterpreterFromPtr(I)
    @ccall libCppInterOp.clang_createInterpreterFromPtr(I::TInterp_t)::CXInterpreter
end

function clang_interpreter_getInterpreterAsPtr(I)
    @ccall libCppInterOp.clang_interpreter_getInterpreterAsPtr(I::CXInterpreter)::TInterp_t
end

function clang_interpreter_takeInterpreterAsPtr(I)
    @ccall libCppInterOp.clang_interpreter_takeInterpreterAsPtr(I::CXInterpreter)::TInterp_t
end

function clang_interpreter_dispose(I)
    @ccall libCppInterOp.clang_interpreter_dispose(I::CXInterpreter)::Cvoid
end

@enum CXInterpreter_CompilationResult::UInt32 begin
    CXInterpreter_Success = 0
    CXInterpreter_Failure = 1
    CXInterpreter_MoreInputExpected = 2
end

function clang_interpreter_addSearchPath(I, dir, isUser, prepend)
    @ccall libCppInterOp.clang_interpreter_addSearchPath(I::CXInterpreter, dir::Ptr{Cchar}, isUser::Bool, prepend::Bool)::Cvoid
end

function clang_interpreter_getResourceDir(I)
    @ccall libCppInterOp.clang_interpreter_getResourceDir(I::CXInterpreter)::Ptr{Cchar}
end

function clang_interpreter_addIncludePath(I, dir)
    @ccall libCppInterOp.clang_interpreter_addIncludePath(I::CXInterpreter, dir::Ptr{Cchar})::Cvoid
end

function clang_interpreter_declare(I, code, silent)
    @ccall libCppInterOp.clang_interpreter_declare(I::CXInterpreter, code::Ptr{Cchar}, silent::Bool)::CXErrorCode
end

function clang_interpreter_process(I, code)
    @ccall libCppInterOp.clang_interpreter_process(I::CXInterpreter, code::Ptr{Cchar})::CXErrorCode
end

const CXValue = Ptr{Cvoid}

# no prototype is found for this function at CXCppInterOp.h:147:9, please use with caution
function clang_createValue()
    @ccall libCppInterOp.clang_createValue()::CXValue
end

function clang_value_dispose(V)
    @ccall libCppInterOp.clang_value_dispose(V::CXValue)::Cvoid
end

function clang_interpreter_evaluate(I, code, V)
    @ccall libCppInterOp.clang_interpreter_evaluate(I::CXInterpreter, code::Ptr{Cchar}, V::CXValue)::CXErrorCode
end

function clang_interpreter_lookupLibrary(I, lib_name)
    @ccall libCppInterOp.clang_interpreter_lookupLibrary(I::CXInterpreter, lib_name::Ptr{Cchar})::CXString
end

function clang_interpreter_loadLibrary(I, lib_stem, lookup)
    @ccall libCppInterOp.clang_interpreter_loadLibrary(I::CXInterpreter, lib_stem::Ptr{Cchar}, lookup::Bool)::CXInterpreter_CompilationResult
end

function clang_interpreter_unloadLibrary(I, lib_stem)
    @ccall libCppInterOp.clang_interpreter_unloadLibrary(I::CXInterpreter, lib_stem::Ptr{Cchar})::Cvoid
end

function clang_interpreter_searchLibrariesForSymbol(I, mangled_name, search_system)
    @ccall libCppInterOp.clang_interpreter_searchLibrariesForSymbol(I::CXInterpreter, mangled_name::Ptr{Cchar}, search_system::Bool)::CXString
end

function clang_interpreter_insertOrReplaceJitSymbol(I, linker_mangled_name, address)
    @ccall libCppInterOp.clang_interpreter_insertOrReplaceJitSymbol(I::CXInterpreter, linker_mangled_name::Ptr{Cchar}, address::UInt64)::Bool
end

const CXFuncAddr = Ptr{Cvoid}

function clang_interpreter_getFunctionAddressFromMangledName(I, mangled_name)
    @ccall libCppInterOp.clang_interpreter_getFunctionAddressFromMangledName(I::CXInterpreter, mangled_name::Ptr{Cchar})::CXFuncAddr
end

struct CXQualType
    kind::CXTypeKind
    data::Ptr{Cvoid}
    meta::Ptr{Cvoid}
end

function clang_qualtype_isBuiltin(type)
    @ccall libCppInterOp.clang_qualtype_isBuiltin(type::CXQualType)::Bool
end

function clang_qualtype_isEnumType(type)
    @ccall libCppInterOp.clang_qualtype_isEnumType(type::CXQualType)::Bool
end

function clang_qualtype_isSmartPtrType(type)
    @ccall libCppInterOp.clang_qualtype_isSmartPtrType(type::CXQualType)::Bool
end

function clang_scope_isRecordType(type)
    @ccall libCppInterOp.clang_scope_isRecordType(type::CXQualType)::Bool
end

function clang_scope_isPODType(type)
    @ccall libCppInterOp.clang_scope_isPODType(type::CXQualType)::Bool
end

function clang_qualtype_getIntegerTypeFromEnumType(type)
    @ccall libCppInterOp.clang_qualtype_getIntegerTypeFromEnumType(type::CXQualType)::CXQualType
end

function clang_qualtype_getUnderlyingType(type)
    @ccall libCppInterOp.clang_qualtype_getUnderlyingType(type::CXQualType)::CXQualType
end

function clang_qualtype_getTypeAsString(type)
    @ccall libCppInterOp.clang_qualtype_getTypeAsString(type::CXQualType)::CXString
end

function clang_qualtype_getCanonicalType(type)
    @ccall libCppInterOp.clang_qualtype_getCanonicalType(type::CXQualType)::CXQualType
end

function clang_qualtype_getType(I, name)
    @ccall libCppInterOp.clang_qualtype_getType(I::CXInterpreter, name::Ptr{Cchar})::CXQualType
end

function clang_qualtype_getComplexType(eltype)
    @ccall libCppInterOp.clang_qualtype_getComplexType(eltype::CXQualType)::CXQualType
end

function clang_qualtype_getSizeOfType(type)
    @ccall libCppInterOp.clang_qualtype_getSizeOfType(type::CXQualType)::Csize_t
end

function clang_qualtype_isTypeDerivedFrom(derived, base)
    @ccall libCppInterOp.clang_qualtype_isTypeDerivedFrom(derived::CXQualType, base::CXQualType)::Bool
end

@enum CXScopeKind::UInt32 begin
    CXScope_Unexposed = 0
    CXScope_Invalid = 1
    CXScope_Global = 2
    CXScope_Namespace = 3
    CXScope_Function = 4
    CXScope_Variable = 5
    CXScope_EnumConstant = 6
    CXScope_Field = 7
end

struct CXScope
    kind::CXScopeKind
    data::Ptr{Cvoid}
    meta::Ptr{Cvoid}
end

function clang_scope_dump(S)
    @ccall libCppInterOp.clang_scope_dump(S::CXScope)::Cvoid
end

function clang_scope_getTypeFromScope(S)
    @ccall libCppInterOp.clang_scope_getTypeFromScope(S::CXScope)::CXQualType
end

function clang_scope_isAggregate(S)
    @ccall libCppInterOp.clang_scope_isAggregate(S::CXScope)::Bool
end

function clang_scope_isNamespace(S)
    @ccall libCppInterOp.clang_scope_isNamespace(S::CXScope)::Bool
end

function clang_scope_isClass(S)
    @ccall libCppInterOp.clang_scope_isClass(S::CXScope)::Bool
end

function clang_scope_isComplete(S)
    @ccall libCppInterOp.clang_scope_isComplete(S::CXScope)::Bool
end

function clang_scope_sizeOf(S)
    @ccall libCppInterOp.clang_scope_sizeOf(S::CXScope)::Csize_t
end

function clang_scope_isTemplate(S)
    @ccall libCppInterOp.clang_scope_isTemplate(S::CXScope)::Bool
end

function clang_scope_isTemplateSpecialization(S)
    @ccall libCppInterOp.clang_scope_isTemplateSpecialization(S::CXScope)::Bool
end

function clang_scope_isTypedefed(S)
    @ccall libCppInterOp.clang_scope_isTypedefed(S::CXScope)::Bool
end

function clang_scope_isAbstract(S)
    @ccall libCppInterOp.clang_scope_isAbstract(S::CXScope)::Bool
end

function clang_scope_isEnumScope(S)
    @ccall libCppInterOp.clang_scope_isEnumScope(S::CXScope)::Bool
end

function clang_scope_isEnumConstant(S)
    @ccall libCppInterOp.clang_scope_isEnumConstant(S::CXScope)::Bool
end

function clang_scope_getEnums(S)
    @ccall libCppInterOp.clang_scope_getEnums(S::CXScope)::Ptr{CXStringSet}
end

function clang_scope_getIntegerTypeFromEnumScope(S)
    @ccall libCppInterOp.clang_scope_getIntegerTypeFromEnumScope(S::CXScope)::CXQualType
end

struct CXScopeSet
    Scopes::Ptr{CXScope}
    Count::Csize_t
end

function clang_disposeScopeSet(set)
    @ccall libCppInterOp.clang_disposeScopeSet(set::Ptr{CXScopeSet})::Cvoid
end

function clang_scope_getEnumConstants(S)
    @ccall libCppInterOp.clang_scope_getEnumConstants(S::CXScope)::Ptr{CXScopeSet}
end

function clang_scope_getEnumConstantType(S)
    @ccall libCppInterOp.clang_scope_getEnumConstantType(S::CXScope)::CXQualType
end

function clang_scope_getEnumConstantValue(S)
    @ccall libCppInterOp.clang_scope_getEnumConstantValue(S::CXScope)::Csize_t
end

function clang_scope_isVariable(S)
    @ccall libCppInterOp.clang_scope_isVariable(S::CXScope)::Bool
end

function clang_scope_getName(S)
    @ccall libCppInterOp.clang_scope_getName(S::CXScope)::CXString
end

function clang_scope_getCompleteName(S)
    @ccall libCppInterOp.clang_scope_getCompleteName(S::CXScope)::CXString
end

function clang_scope_getQualifiedName(S)
    @ccall libCppInterOp.clang_scope_getQualifiedName(S::CXScope)::CXString
end

function clang_scope_getQualifiedCompleteName(S)
    @ccall libCppInterOp.clang_scope_getQualifiedCompleteName(S::CXScope)::CXString
end

function clang_scope_getUsingNamespaces(S)
    @ccall libCppInterOp.clang_scope_getUsingNamespaces(S::CXScope)::Ptr{CXScopeSet}
end

function clang_scope_getGlobalScope(I)
    @ccall libCppInterOp.clang_scope_getGlobalScope(I::CXInterpreter)::CXScope
end

function clang_scope_getUnderlyingScope(S)
    @ccall libCppInterOp.clang_scope_getUnderlyingScope(S::CXScope)::CXScope
end

function clang_scope_getScope(name, parent)
    @ccall libCppInterOp.clang_scope_getScope(name::Ptr{Cchar}, parent::CXScope)::CXScope
end

function clang_scope_getNamed(name, parent)
    @ccall libCppInterOp.clang_scope_getNamed(name::Ptr{Cchar}, parent::CXScope)::CXScope
end

function clang_scope_getParentScope(parent)
    @ccall libCppInterOp.clang_scope_getParentScope(parent::CXScope)::CXScope
end

function clang_scope_getScopeFromType(type)
    @ccall libCppInterOp.clang_scope_getScopeFromType(type::CXQualType)::CXScope
end

function clang_scope_getNumBases(S)
    @ccall libCppInterOp.clang_scope_getNumBases(S::CXScope)::Csize_t
end

function clang_scope_getBaseClass(S, ibase)
    @ccall libCppInterOp.clang_scope_getBaseClass(S::CXScope, ibase::Csize_t)::CXScope
end

function clang_scope_isSubclass(derived, base)
    @ccall libCppInterOp.clang_scope_isSubclass(derived::CXScope, base::CXScope)::Bool
end

function clang_scope_getBaseClassOffset(derived, base)
    @ccall libCppInterOp.clang_scope_getBaseClassOffset(derived::CXScope, base::CXScope)::Int64
end

function clang_scope_getClassMethods(S)
    @ccall libCppInterOp.clang_scope_getClassMethods(S::CXScope)::Ptr{CXScopeSet}
end

function clang_scope_getFunctionTemplatedDecls(S)
    @ccall libCppInterOp.clang_scope_getFunctionTemplatedDecls(S::CXScope)::Ptr{CXScopeSet}
end

function clang_scope_hasDefaultConstructor(S)
    @ccall libCppInterOp.clang_scope_hasDefaultConstructor(S::CXScope)::Bool
end

function clang_scope_getDefaultConstructor(S)
    @ccall libCppInterOp.clang_scope_getDefaultConstructor(S::CXScope)::CXScope
end

function clang_scope_getDestructor(S)
    @ccall libCppInterOp.clang_scope_getDestructor(S::CXScope)::CXScope
end

function clang_scope_getFunctionsUsingName(S, name)
    @ccall libCppInterOp.clang_scope_getFunctionsUsingName(S::CXScope, name::Ptr{Cchar})::Ptr{CXScopeSet}
end

function clang_scope_getFunctionReturnType(func)
    @ccall libCppInterOp.clang_scope_getFunctionReturnType(func::CXScope)::CXQualType
end

function clang_scope_getFunctionNumArgs(func)
    @ccall libCppInterOp.clang_scope_getFunctionNumArgs(func::CXScope)::Csize_t
end

function clang_scope_getFunctionRequiredArgs(func)
    @ccall libCppInterOp.clang_scope_getFunctionRequiredArgs(func::CXScope)::Csize_t
end

function clang_scope_getFunctionArgType(func, iarg)
    @ccall libCppInterOp.clang_scope_getFunctionArgType(func::CXScope, iarg::Csize_t)::CXQualType
end

function clang_scope_getFunctionSignature(func)
    @ccall libCppInterOp.clang_scope_getFunctionSignature(func::CXScope)::CXString
end

function clang_scope_isFunctionDeleted(func)
    @ccall libCppInterOp.clang_scope_isFunctionDeleted(func::CXScope)::Bool
end

function clang_scope_isTemplatedFunction(func)
    @ccall libCppInterOp.clang_scope_isTemplatedFunction(func::CXScope)::Bool
end

function clang_scope_existsFunctionTemplate(name, parent)
    @ccall libCppInterOp.clang_scope_existsFunctionTemplate(name::Ptr{Cchar}, parent::CXScope)::Bool
end

function clang_scope_getClassTemplatedMethods(name, parent)
    @ccall libCppInterOp.clang_scope_getClassTemplatedMethods(name::Ptr{Cchar}, parent::CXScope)::Ptr{CXScopeSet}
end

function clang_scope_isMethod(method)
    @ccall libCppInterOp.clang_scope_isMethod(method::CXScope)::Bool
end

function clang_scope_isPublicMethod(method)
    @ccall libCppInterOp.clang_scope_isPublicMethod(method::CXScope)::Bool
end

function clang_scope_isProtectedMethod(method)
    @ccall libCppInterOp.clang_scope_isProtectedMethod(method::CXScope)::Bool
end

function clang_scope_isPrivateMethod(method)
    @ccall libCppInterOp.clang_scope_isPrivateMethod(method::CXScope)::Bool
end

function clang_scope_isConstructor(method)
    @ccall libCppInterOp.clang_scope_isConstructor(method::CXScope)::Bool
end

function clang_scope_isDestructor(method)
    @ccall libCppInterOp.clang_scope_isDestructor(method::CXScope)::Bool
end

function clang_scope_isStaticMethod(method)
    @ccall libCppInterOp.clang_scope_isStaticMethod(method::CXScope)::Bool
end

function clang_scope_getFunctionAddress(method)
    @ccall libCppInterOp.clang_scope_getFunctionAddress(method::CXScope)::CXFuncAddr
end

function clang_scope_isVirtualMethod(method)
    @ccall libCppInterOp.clang_scope_isVirtualMethod(method::CXScope)::Bool
end

function clang_scope_isConstMethod(method)
    @ccall libCppInterOp.clang_scope_isConstMethod(method::CXScope)::Bool
end

function clang_scope_getFunctionArgDefault(func, param_index)
    @ccall libCppInterOp.clang_scope_getFunctionArgDefault(func::CXScope, param_index::Csize_t)::CXString
end

function clang_scope_getFunctionArgName(func, param_index)
    @ccall libCppInterOp.clang_scope_getFunctionArgName(func::CXScope, param_index::Csize_t)::CXString
end

struct CXTemplateArgInfo
    Type::Ptr{Cvoid}
    IntegralValue::Ptr{Cchar}
end

function clang_scope_instantiateTemplate(tmpl, template_args, template_args_size)
    @ccall libCppInterOp.clang_scope_instantiateTemplate(tmpl::CXScope, template_args::Ptr{CXTemplateArgInfo}, template_args_size::Csize_t)::CXScope
end

function clang_scope_getDatamembers(S)
    @ccall libCppInterOp.clang_scope_getDatamembers(S::CXScope)::Ptr{CXScopeSet}
end

function clang_scope_lookupDatamember(name, parent)
    @ccall libCppInterOp.clang_scope_lookupDatamember(name::Ptr{Cchar}, parent::CXScope)::CXScope
end

function clang_scope_getVariableType(var)
    @ccall libCppInterOp.clang_scope_getVariableType(var::CXScope)::CXQualType
end

function clang_scope_getVariableOffset(var)
    @ccall libCppInterOp.clang_scope_getVariableOffset(var::CXScope)::intptr_t
end

function clang_scope_isPublicVariable(var)
    @ccall libCppInterOp.clang_scope_isPublicVariable(var::CXScope)::Bool
end

function clang_scope_isProtectedVariable(var)
    @ccall libCppInterOp.clang_scope_isProtectedVariable(var::CXScope)::Bool
end

function clang_scope_isPrivateVariable(var)
    @ccall libCppInterOp.clang_scope_isPrivateVariable(var::CXScope)::Bool
end

function clang_scope_isStaticVariable(var)
    @ccall libCppInterOp.clang_scope_isStaticVariable(var::CXScope)::Bool
end

function clang_scope_isConstVariable(var)
    @ccall libCppInterOp.clang_scope_isConstVariable(var::CXScope)::Bool
end

const CXObject = Ptr{Cvoid}

function clang_allocate(S)
    @ccall libCppInterOp.clang_allocate(S::CXScope)::CXObject
end

function clang_deallocate(address)
    @ccall libCppInterOp.clang_deallocate(address::CXObject)::Cvoid
end

function clang_construct(scope, arena)
    @ccall libCppInterOp.clang_construct(scope::CXScope, arena::Ptr{Cvoid})::CXObject
end

function clang_destruct(This, S, withFree)
    @ccall libCppInterOp.clang_destruct(This::CXObject, S::CXScope, withFree::Bool)::Cvoid
end

mutable struct CXJitCallImpl end

const CXJitCall = Ptr{CXJitCallImpl}

function clang_jitcall_dispose(J)
    @ccall libCppInterOp.clang_jitcall_dispose(J::CXJitCall)::Cvoid
end

@enum CXJitCallKind::UInt32 begin
    CXJitCall_Unknown = 0
    CXJitCall_GenericCall = 1
    CXJitCall_DestructorCall = 2
end

function clang_jitcall_getKind(J)
    @ccall libCppInterOp.clang_jitcall_getKind(J::CXJitCall)::CXJitCallKind
end

function clang_jitcall_isValid(J)
    @ccall libCppInterOp.clang_jitcall_isValid(J::CXJitCall)::Bool
end

struct CXJitCallArgList
    data::Ptr{Ptr{Cvoid}}
    numArgs::Csize_t
end

function clang_jitcall_invoke(J, result, args, self)
    @ccall libCppInterOp.clang_jitcall_invoke(J::CXJitCall, result::Ptr{Cvoid}, args::CXJitCallArgList, self::Ptr{Cvoid})::Cvoid
end

function clang_jitcall_makeFunctionCallable(func)
    @ccall libCppInterOp.clang_jitcall_makeFunctionCallable(func::CXScope)::CXJitCall
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
