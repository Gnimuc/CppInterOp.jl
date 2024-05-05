module LibCppInterOp

using ..CppInterOp: libcppinterop
using ..CppInterOp: CXString, CXStringSet

const intptr_t = Clong


const CXCppInterpreter = Ptr{Cvoid}

const CXCppScope = Ptr{Cvoid}

const CXCppType = Ptr{Cvoid}

const CXCppFunction = Ptr{Cvoid}

const CXCppConstFunction = Ptr{Cvoid}

const CXCppFuncAddr = Ptr{Cvoid}

const CXCppObject = Ptr{Cvoid}

const CXCppJitCall = Ptr{Cvoid}

function clang_CppInterOp_GetVersion()
    @ccall libcppinterop.clang_CppInterOp_GetVersion()::CXString
end

function clang_CppInterOp_EnableDebugOutput(value)
    @ccall libcppinterop.clang_CppInterOp_EnableDebugOutput(value::Bool)::Cvoid
end

function clang_CppInterOp_IsDebugOutputEnabled()
    @ccall libcppinterop.clang_CppInterOp_IsDebugOutputEnabled()::Bool
end

function clang_CppInterOp_IsAggregate(scope)
    @ccall libcppinterop.clang_CppInterOp_IsAggregate(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsNamespace(scope)
    @ccall libcppinterop.clang_CppInterOp_IsNamespace(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsClass(scope)
    @ccall libcppinterop.clang_CppInterOp_IsClass(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsComplete(scope)
    @ccall libcppinterop.clang_CppInterOp_IsComplete(scope::CXCppScope)::Bool
end

function clang_CppInterOp_SizeOf(scope)
    @ccall libcppinterop.clang_CppInterOp_SizeOf(scope::CXCppScope)::Csize_t
end

function clang_CppInterOp_IsBuiltin(type)
    @ccall libcppinterop.clang_CppInterOp_IsBuiltin(type::CXCppType)::Bool
end

function clang_CppInterOp_IsTemplate(scope)
    @ccall libcppinterop.clang_CppInterOp_IsTemplate(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsTemplateSpecialization(scope)
    @ccall libcppinterop.clang_CppInterOp_IsTemplateSpecialization(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsTypedefed(scope)
    @ccall libcppinterop.clang_CppInterOp_IsTypedefed(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsAbstract(type)
    @ccall libcppinterop.clang_CppInterOp_IsAbstract(type::CXCppType)::Bool
end

function clang_CppInterOp_IsEnumScope(scope)
    @ccall libcppinterop.clang_CppInterOp_IsEnumScope(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsEnumConstant(scope)
    @ccall libcppinterop.clang_CppInterOp_IsEnumConstant(scope::CXCppScope)::Bool
end

function clang_CppInterOp_IsEnumType(type)
    @ccall libcppinterop.clang_CppInterOp_IsEnumType(type::CXCppType)::Bool
end

function clang_CppInterOp_GetEnums(scope)
    @ccall libcppinterop.clang_CppInterOp_GetEnums(scope::CXCppScope)::Ptr{CXStringSet}
end

function clang_CppInterOp_IsSmartPtrType(type)
    @ccall libcppinterop.clang_CppInterOp_IsSmartPtrType(type::CXCppType)::Bool
end

function clang_CppInterOp_GetIntegerTypeFromEnumScope(scope)
    @ccall libcppinterop.clang_CppInterOp_GetIntegerTypeFromEnumScope(
        scope::CXCppScope,
    )::CXCppType
end

function clang_CppInterOp_GetIntegerTypeFromEnumType(type)
    @ccall libcppinterop.clang_CppInterOp_GetIntegerTypeFromEnumType(
        type::CXCppType,
    )::CXCppType
end

struct CXCppScopeSet
    Scopes::Ptr{CXCppScope}
    Count::Csize_t
end

function clang_CppInterOp_CXCppScopeSet_dispose(scopes)
    @ccall libcppinterop.clang_CppInterOp_CXCppScopeSet_dispose(
        scopes::CXCppScopeSet,
    )::Cvoid
end

function clang_CppInterOp_GetEnumConstants(scope)
    @ccall libcppinterop.clang_CppInterOp_GetEnumConstants(scope::CXCppScope)::CXCppScopeSet
end

function clang_CppInterOp_GetEnumConstantType(scope)
    @ccall libcppinterop.clang_CppInterOp_GetEnumConstantType(scope::CXCppScope)::CXCppType
end

function clang_CppInterOp_GetEnumConstantValue(scope)
    @ccall libcppinterop.clang_CppInterOp_GetEnumConstantValue(scope::CXCppScope)::Csize_t
end

function clang_CppInterOp_GetSizeOfType(type)
    @ccall libcppinterop.clang_CppInterOp_GetSizeOfType(type::CXCppType)::Csize_t
end

function clang_CppInterOp_IsVariable(scope)
    @ccall libcppinterop.clang_CppInterOp_IsVariable(scope::CXCppScope)::Bool
end

function clang_CppInterOp_GetName(klass)
    @ccall libcppinterop.clang_CppInterOp_GetName(klass::CXCppScope)::CXString
end

function clang_CppInterOp_GetCompleteName(klass)
    @ccall libcppinterop.clang_CppInterOp_GetCompleteName(klass::CXCppType)::CXString
end

function clang_CppInterOp_GetQualifiedName(klass)
    @ccall libcppinterop.clang_CppInterOp_GetQualifiedName(klass::CXCppType)::CXString
end

function clang_CppInterOp_GetQualifiedCompleteName(klass)
    @ccall libcppinterop.clang_CppInterOp_GetQualifiedCompleteName(
        klass::CXCppType,
    )::CXString
end

function clang_CppInterOp_GetUsingNamespaces(scope)
    @ccall libcppinterop.clang_CppInterOp_GetUsingNamespaces(
        scope::CXCppScope,
    )::CXCppScopeSet
end

function clang_CppInterOp_GetGlobalScope()
    @ccall libcppinterop.clang_CppInterOp_GetGlobalScope()::CXCppScope
end

function clang_CppInterOp_GetUnderlyingScope(scope)
    @ccall libcppinterop.clang_CppInterOp_GetUnderlyingScope(scope::CXCppScope)::CXCppScope
end

function clang_CppInterOp_GetScope(name, parent)
    @ccall libcppinterop.clang_CppInterOp_GetScope(
        name::Ptr{Cchar},
        parent::CXCppScope,
    )::CXCppScope
end

function clang_CppInterOp_GetScopeFromCompleteName(name)
    @ccall libcppinterop.clang_CppInterOp_GetScopeFromCompleteName(
        name::Ptr{Cchar},
    )::CXCppScope
end

function clang_CppInterOp_GetNamed(name, parent)
    @ccall libcppinterop.clang_CppInterOp_GetNamed(
        name::Ptr{Cchar},
        parent::CXCppScope,
    )::CXCppScope
end

function clang_CppInterOp_GetParentScope(scope)
    @ccall libcppinterop.clang_CppInterOp_GetParentScope(scope::CXCppScope)::CXCppScope
end

function clang_CppInterOp_GetScopeFromType(type)
    @ccall libcppinterop.clang_CppInterOp_GetScopeFromType(type::CXCppType)::CXCppScope
end

function clang_CppInterOp_GetNumBases(type)
    @ccall libcppinterop.clang_CppInterOp_GetNumBases(type::CXCppType)::Csize_t
end

function clang_CppInterOp_GetBaseClass(type, ibase)
    @ccall libcppinterop.clang_CppInterOp_GetBaseClass(
        type::CXCppType,
        ibase::Csize_t,
    )::CXCppScope
end

function clang_CppInterOp_IsSubclass(derived, base)
    @ccall libcppinterop.clang_CppInterOp_IsSubclass(
        derived::CXCppScope,
        base::CXCppScope,
    )::Bool
end

function clang_CppInterOp_GetBaseClassOffset(derived, base)
    @ccall libcppinterop.clang_CppInterOp_GetBaseClassOffset(
        derived::CXCppScope,
        base::CXCppScope,
    )::Int64
end

struct CXCppFunctionSet
    Funcs::Ptr{CXCppFunction}
    Count::Csize_t
end

function clang_CppInterOp_CXCppFunctionSet_dispose(funcs)
    @ccall libcppinterop.clang_CppInterOp_CXCppFunctionSet_dispose(
        funcs::CXCppFunctionSet,
    )::Cvoid
end

function clang_CppInterOp_GetClassMethods(klass)
    @ccall libcppinterop.clang_CppInterOp_GetClassMethods(
        klass::CXCppScope,
    )::CXCppFunctionSet
end

function clang_CppInterOp_HasDefaultConstructor(scope)
    @ccall libcppinterop.clang_CppInterOp_HasDefaultConstructor(scope::CXCppScope)::Bool
end

function clang_CppInterOp_GetDefaultConstructor(scope)
    @ccall libcppinterop.clang_CppInterOp_GetDefaultConstructor(
        scope::CXCppScope,
    )::CXCppFunction
end

function clang_CppInterOp_GetDestructor(scope)
    @ccall libcppinterop.clang_CppInterOp_GetDestructor(scope::CXCppScope)::CXCppFunction
end

function clang_CppInterOp_GetFunctionsUsingName(scope, name)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionsUsingName(
        scope::CXCppScope,
        name::Ptr{Cchar},
    )::CXCppFunctionSet
end

function clang_CppInterOp_GetFunctionReturnType(func)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionReturnType(
        func::CXCppFunction,
    )::CXCppType
end

function clang_CppInterOp_GetFunctionNumArgs(func)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionNumArgs(func::CXCppFunction)::Csize_t
end

function clang_CppInterOp_GetFunctionRequiredArgs(func)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionRequiredArgs(
        func::CXCppConstFunction,
    )::Csize_t
end

function clang_CppInterOp_GetFunctionArgType(func, iarg)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionArgType(
        func::CXCppFunction,
        iarg::Csize_t,
    )::CXCppType
end

function clang_CppInterOp_GetFunctionSignature(func)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionSignature(
        func::CXCppFunction,
    )::CXString
end

function clang_CppInterOp_IsFunctionDeleted(_function)
    @ccall libcppinterop.clang_CppInterOp_IsFunctionDeleted(
        _function::CXCppConstFunction,
    )::Bool
end

function clang_CppInterOp_IsTemplatedFunction(func)
    @ccall libcppinterop.clang_CppInterOp_IsTemplatedFunction(func::CXCppFunction)::Bool
end

function clang_CppInterOp_ExistsFunctionTemplate(name, parent)
    @ccall libcppinterop.clang_CppInterOp_ExistsFunctionTemplate(
        name::Ptr{Cchar},
        parent::CXCppScope,
    )::Bool
end

function clang_CppInterOp_IsMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsMethod(method::CXCppConstFunction)::Bool
end

function clang_CppInterOp_IsPublicMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsPublicMethod(method::CXCppFunction)::Bool
end

function clang_CppInterOp_IsProtectedMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsProtectedMethod(method::CXCppFunction)::Bool
end

function clang_CppInterOp_IsPrivateMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsPrivateMethod(method::CXCppFunction)::Bool
end

function clang_CppInterOp_IsConstructor(method)
    @ccall libcppinterop.clang_CppInterOp_IsConstructor(method::CXCppConstFunction)::Bool
end

function clang_CppInterOp_IsDestructor(method)
    @ccall libcppinterop.clang_CppInterOp_IsDestructor(method::CXCppConstFunction)::Bool
end

function clang_CppInterOp_IsStaticMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsStaticMethod(method::CXCppConstFunction)::Bool
end

function clang_CppInterOp_GetFunctionAddressFromMangledName(mangled_name)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionAddressFromMangledName(
        mangled_name::Ptr{Cchar},
    )::CXCppFuncAddr
end

function clang_CppInterOp_GetFunctionAddressFromMethod(method)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionAddressFromMethod(
        method::CXCppFunction,
    )::CXCppFuncAddr
end

function clang_CppInterOp_IsVirtualMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsVirtualMethod(method::CXCppFunction)::Bool
end

function clang_CppInterOp_GetDatamembers(scope)
    @ccall libcppinterop.clang_CppInterOp_GetDatamembers(scope::CXCppScope)::CXCppScopeSet
end

function clang_CppInterOp_LookupDatamember(name, parent)
    @ccall libcppinterop.clang_CppInterOp_LookupDatamember(
        name::Ptr{Cchar},
        parent::CXCppScope,
    )::CXCppScope
end

function clang_CppInterOp_GetVariableType(var)
    @ccall libcppinterop.clang_CppInterOp_GetVariableType(var::CXCppScope)::CXCppType
end

function clang_CppInterOp_GetVariableOffset(var)
    @ccall libcppinterop.clang_CppInterOp_GetVariableOffset(var::CXCppScope)::intptr_t
end

function clang_CppInterOp_IsPublicVariable(var)
    @ccall libcppinterop.clang_CppInterOp_IsPublicVariable(var::CXCppScope)::Bool
end

function clang_CppInterOp_IsProtectedVariable(var)
    @ccall libcppinterop.clang_CppInterOp_IsProtectedVariable(var::CXCppScope)::Bool
end

function clang_CppInterOp_IsPrivateVariable(var)
    @ccall libcppinterop.clang_CppInterOp_IsPrivateVariable(var::CXCppScope)::Bool
end

function clang_CppInterOp_IsStaticVariable(var)
    @ccall libcppinterop.clang_CppInterOp_IsStaticVariable(var::CXCppScope)::Bool
end

function clang_CppInterOp_IsConstVariable(var)
    @ccall libcppinterop.clang_CppInterOp_IsConstVariable(var::CXCppScope)::Bool
end

function clang_CppInterOp_IsRecordType(type)
    @ccall libcppinterop.clang_CppInterOp_IsRecordType(type::CXCppType)::Bool
end

function clang_CppInterOp_IsPODType(type)
    @ccall libcppinterop.clang_CppInterOp_IsPODType(type::CXCppType)::Bool
end

function clang_CppInterOp_GetUnderlyingType(type)
    @ccall libcppinterop.clang_CppInterOp_GetUnderlyingType(type::CXCppType)::CXCppType
end

function clang_CppInterOp_GetTypeAsString(type)
    @ccall libcppinterop.clang_CppInterOp_GetTypeAsString(type::CXCppType)::CXString
end

function clang_CppInterOp_GetCanonicalType(type)
    @ccall libcppinterop.clang_CppInterOp_GetCanonicalType(type::CXCppType)::CXCppType
end

function clang_CppInterOp_GetType(type)
    @ccall libcppinterop.clang_CppInterOp_GetType(type::Ptr{Cchar})::CXCppType
end

function clang_CppInterOp_GetComplexType(element_type)
    @ccall libcppinterop.clang_CppInterOp_GetComplexType(element_type::CXCppType)::CXCppType
end

function clang_CppInterOp_GetTypeFromScope(scope)
    @ccall libcppinterop.clang_CppInterOp_GetTypeFromScope(scope::CXCppScope)::CXCppType
end

function clang_CppInterOp_IsTypeDerivedFrom(derived, base)
    @ccall libcppinterop.clang_CppInterOp_IsTypeDerivedFrom(
        derived::CXCppType,
        base::CXCppType,
    )::Bool
end

function clang_CppInterOp_MakeFunctionCallable(func)
    @ccall libcppinterop.clang_CppInterOp_MakeFunctionCallable(
        func::CXCppConstFunction,
    )::CXCppJitCall
end

function clang_CppInterOp_CXCppJitCall_dispose(call)
    @ccall libcppinterop.clang_CppInterOp_CXCppJitCall_dispose(call::CXCppJitCall)::Cvoid
end

function clang_CppInterOp_IsConstMethod(method)
    @ccall libcppinterop.clang_CppInterOp_IsConstMethod(method::CXCppFunction)::Bool
end

function clang_CppInterOp_GetFunctionArgDefault(func, param_index)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionArgDefault(
        func::CXCppFunction,
        param_index::Csize_t,
    )::CXString
end

function clang_CppInterOp_GetFunctionArgName(func, param_index)
    @ccall libcppinterop.clang_CppInterOp_GetFunctionArgName(
        func::CXCppFunction,
        param_index::Csize_t,
    )::CXString
end

function clang_CppInterOp_CreateInterpreter(args, num_args, gpu_args, num_gpu_args)
    @ccall libcppinterop.clang_CppInterOp_CreateInterpreter(
        args::Ptr{Ptr{Cchar}},
        num_args::Csize_t,
        gpu_args::Ptr{Ptr{Cchar}},
        num_gpu_args::Csize_t,
    )::CXCppInterpreter
end

function clang_CppInterOp_GetInterpreter()
    @ccall libcppinterop.clang_CppInterOp_GetInterpreter()::CXCppInterpreter
end

function clang_CppInterOp_AddSearchPath(dir, isUser, prepend)
    @ccall libcppinterop.clang_CppInterOp_AddSearchPath(
        dir::Ptr{Cchar},
        isUser::Bool,
        prepend::Bool,
    )::Cvoid
end

function clang_CppInterOp_GetResourceDir()
    @ccall libcppinterop.clang_CppInterOp_GetResourceDir()::Ptr{Cchar}
end

function clang_CppInterOp_AddIncludePath(dir)
    @ccall libcppinterop.clang_CppInterOp_AddIncludePath(dir::Ptr{Cchar})::Cvoid
end

function clang_CppInterOp_Declare(code, silent)
    @ccall libcppinterop.clang_CppInterOp_Declare(code::Ptr{Cchar}, silent::Bool)::Cint
end

function clang_CppInterOp_Process(code)
    @ccall libcppinterop.clang_CppInterOp_Process(code::Ptr{Cchar})::Cint
end

function clang_CppInterOp_Evaluate(code, HadError)
    @ccall libcppinterop.clang_CppInterOp_Evaluate(
        code::Ptr{Cchar},
        HadError::Ptr{Bool},
    )::intptr_t
end

function clang_CppInterOp_LookupLibrary(lib_name)
    @ccall libcppinterop.clang_CppInterOp_LookupLibrary(lib_name::Ptr{Cchar})::CXString
end

function clang_CppInterOp_LoadLibrary(lib_stem, lookup)
    @ccall libcppinterop.clang_CppInterOp_LoadLibrary(
        lib_stem::Ptr{Cchar},
        lookup::Bool,
    )::Bool
end

function clang_CppInterOp_UnloadLibrary(lib_stem)
    @ccall libcppinterop.clang_CppInterOp_UnloadLibrary(lib_stem::Ptr{Cchar})::Cvoid
end

function clang_CppInterOp_SearchLibrariesForSymbol(mangled_name, search_system)
    @ccall libcppinterop.clang_CppInterOp_SearchLibrariesForSymbol(
        mangled_name::Ptr{Cchar},
        search_system::Bool,
    )::CXString
end

function clang_CppInterOp_InsertOrReplaceJitSymbol(linker_mangled_name, address)
    @ccall libcppinterop.clang_CppInterOp_InsertOrReplaceJitSymbol(
        linker_mangled_name::Ptr{Cchar},
        address::UInt64,
    )::Bool
end

function clang_CppInterOp_ObjToString(type, obj)
    @ccall libcppinterop.clang_CppInterOp_ObjToString(
        type::Ptr{Cchar},
        obj::Ptr{Cvoid},
    )::CXString
end

struct CXTemplateArgInfo
    m_Type::CXCppType
    m_IntegralValue::Ptr{Cchar}
end

function clang_CppInterOp_InstantiateClassTemplate(tmpl, template_args, template_args_size)
    @ccall libcppinterop.clang_CppInterOp_InstantiateClassTemplate(
        tmpl::CXCppScope,
        template_args::Ptr{CXTemplateArgInfo},
        template_args_size::Csize_t,
    )::CXCppScope
end

struct CXTemplateArgInfoSet
    Args::Ptr{CXTemplateArgInfo}
    Count::Csize_t
end

function clang_CppInterOp_CXTemplateArgInfoSet_dispose(args)
    @ccall libcppinterop.clang_CppInterOp_CXTemplateArgInfoSet_dispose(
        args::CXTemplateArgInfoSet,
    )::Cvoid
end

function clang_CppInterOp_GetClassTemplateInstantiationArgs(templ_instance)
    @ccall libcppinterop.clang_CppInterOp_GetClassTemplateInstantiationArgs(
        templ_instance::CXCppScope,
    )::CXTemplateArgInfoSet
end

function clang_CppInterOp_InstantiateTemplateFunctionFromString(function_template)
    @ccall libcppinterop.clang_CppInterOp_InstantiateTemplateFunctionFromString(
        function_template::Ptr{Cchar},
    )::CXCppFunction
end

function clang_CppInterOp_GetAllCppNames(scope)
    @ccall libcppinterop.clang_CppInterOp_GetAllCppNames(
        scope::CXCppScope,
    )::Ptr{CXStringSet}
end

function clang_CppInterOp_DumpScope(scope)
    @ccall libcppinterop.clang_CppInterOp_DumpScope(scope::CXCppScope)::Cvoid
end

struct CXCppDimensions
    Dims::Ptr{Csize_t}
    Count::Csize_t
end

function clang_CppInterOp_CXCppDimensions_dispose(dims)
    @ccall libcppinterop.clang_CppInterOp_CXCppDimensions_dispose(
        dims::CXCppDimensions,
    )::Cvoid
end

function clang_CppInterOp_GetDimensions(type)
    @ccall libcppinterop.clang_CppInterOp_GetDimensions(type::CXCppType)::CXCppDimensions
end

function clang_CppInterOp_Allocate(scope)
    @ccall libcppinterop.clang_CppInterOp_Allocate(scope::CXCppScope)::CXCppObject
end

function clang_CppInterOp_Deallocate(scope, address)
    @ccall libcppinterop.clang_CppInterOp_Deallocate(
        scope::CXCppScope,
        address::CXCppObject,
    )::Cvoid
end

function clang_CppInterOp_Construct(scope, arena)
    @ccall libcppinterop.clang_CppInterOp_Construct(
        scope::CXCppScope,
        arena::Ptr{Cvoid},
    )::CXCppObject
end

function clang_CppInterOp_Destruct(This, type, withFree)
    @ccall libcppinterop.clang_CppInterOp_Destruct(
        This::CXCppObject,
        type::CXCppScope,
        withFree::Bool,
    )::Cvoid
end

@enum CXCppCaptureStreamKind::UInt32 begin
    CXCppkStdOut = 1
    CXCppkStdErr = 2
end

function clang_CppInterOp_BeginStdStreamCapture(fd_kind)
    @ccall libcppinterop.clang_CppInterOp_BeginStdStreamCapture(
        fd_kind::CXCppCaptureStreamKind,
    )::Cvoid
end

function clang_CppInterOp_EndStdStreamCapture()
    @ccall libcppinterop.clang_CppInterOp_EndStdStreamCapture()::CXString
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all = true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
