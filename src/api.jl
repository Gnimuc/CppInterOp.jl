function EnableDebugOutput(value = true)
    clang_CppInterOp_EnableDebugOutput(value)
end

IsDebugOutputEnabled() = clang_CppInterOp_IsDebugOutputEnabled()

function IsAggregate(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsAggregate(x)
end

function IsNamespace(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsNamespace(x)
end

function IsClass(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsClass(x)
end

function IsComplete(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsComplete(x)
end

function SizeOf(x)
    @check_ptrs x
    return clang_CppInterOp_SizeOf(x)
end

function IsBuiltin(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_IsBuiltin(x)
end

function IsTemplate(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsTemplate(x)
end

function IsTemplateSpecialization(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsTemplateSpecialization(x)
end

function IsTypedefed(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsTypedefed(x)
end

function IsAbstract(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_IsAbstract(x)
end

function IsEnumScope(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsEnumScope(x)
end

function IsEnumConstant(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsEnumConstant(x)
end

function IsEnumType(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_IsEnumType(x)
end

function GetEnums(x::AbstractCppScope)
    @check_ptrs x
    return get_string(clang_CppInterOp_GetEnums(x))
end

function IsSmartPtrType(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_IsSmartPtrType(x)
end

function GetIntegerTypeFromEnumScope(x::AbstractCppScope)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetIntegerTypeFromEnumScope(x))
end

function GetIntegerTypeFromEnumType(x::AbstractCppType)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetIntegerTypeFromEnumType(x))
end

struct CXCppScopeSet
    Scopes::Ptr{CXCppScope}
    Count::Csize_t
end

dispose(x::CXCppScopeSet) = clang_CppInterOp_CXCppScopeSet_dispose(x)

# FIXME: return a vector of enum constants
function GetEnumConstants(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_GetEnumConstants(x)
end

function GetEnumConstantType(x::AbstractCppScope)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetEnumConstantType(x))
end

function GetEnumConstantValue(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_GetEnumConstantValue(x)
end

function GetSizeOfType(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_GetSizeOfType(x)
end

function IsVariable(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsVariable(x)
end

function GetName(x::AbstractCppScope)
    @check_ptrs x
    return get_string(clang_CppInterOp_GetName(x))
end

function GetCompleteName(x::AbstractCppType)
    @check_ptrs x
    return get_string(clang_CppInterOp_GetCompleteName(x))
end

function GetQualifiedName(x::AbstractCppType)
    @check_ptrs x
    return get_string(clang_CppInterOp_GetQualifiedName(x))
end

function GetQualifiedCompleteName(x::AbstractCppType)
    @check_ptrs x
    return get_string(clang_CppInterOp_GetQualifiedCompleteName(x))
end

function GetUsingNamespaces(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_GetUsingNamespaces(x)
end

GetGlobalScope() = CppScope(clang_CppInterOp_GetGlobalScope())

function GetUnderlyingScope(x::AbstractCppScope)
    @check_ptrs x
    return CppScope(clang_CppInterOp_GetUnderlyingScope(x))

end

function GetScope(name::AbstractString, parent::AbstractCppScope = CppScope(C_NULL))
    return CppScope(clang_CppInterOp_GetScope(name, parent))
end

function GetScopeFromCompleteName(name::AbstractString)
    return CppScope(clang_CppInterOp_GetScopeFromCompleteName(name))
end

function GetNamed(name::AbstractString, parent::AbstractCppScope = CppScope(C_NULL))
    return CppScope(clang_CppInterOp_GetNamed(name, parent))
end

function GetParentScope(x::AbstractCppScope)
    @check_ptrs x
    return CppScope(clang_CppInterOp_GetParentScope(x))
end

function GetScopeFromType(x::AbstractCppType)
    @check_ptrs x
    return CppScope(clang_CppInterOp_GetScopeFromType(x))
end

function GetNumBases(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_GetNumBases(x)
end

function GetBaseClass(x::AbstractCppType, ibase::Integer)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetBaseClass(x, ibase))
end

function IsSubclass(derived::AbstractCppScope, base::AbstractCppScope)
    @check_ptrs derived base
    return clang_CppInterOp_IsSubclass(derived, base)
end

function GetBaseClassOffset(derived::AbstractCppScope, base::AbstractCppScope)
    @check_ptrs derived base
    return clang_CppInterOp_GetBaseClassOffset(derived, base)
end

struct CXCppFunctionSet
    Funcs::Ptr{CXCppFunction}
    Count::Csize_t
end

dispose(x::CXCppFunctionSet) = clang_CppInterOp_CXCppFunctionSet_dispose(x)

function GetClassMethods(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_GetClassMethods(x)
end

function HasDefaultConstructor(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_HasDefaultConstructor(x)
end

function GetDefaultConstructor(x::AbstractCppScope)
    @check_ptrs x
    return CppFunction(clang_CppInterOp_GetDefaultConstructor(x))
end

function GetDestructor(x::AbstractCppScope)
    @check_ptrs x
    return CppFunction(clang_CppInterOp_GetDestructor(x))
end

function GetFunctionsUsingName(x::AbstractCppScope, name::AbstractString)
    @check_ptrs x
    return clang_CppInterOp_GetFunctionsUsingName(x, name)
end

function GetFunctionReturnType(x::AbstractCppFunction)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetFunctionReturnType(x))
end

function GetFunctionNumArgs(x::AbstractCppFunction)
    @check_ptrs x
    return clang_CppInterOp_GetFunctionNumArgs(x)
end

function GetFunctionRequiredArgs(x::AbstractCppFunction)
    @check_ptrs x
    return clang_CppInterOp_GetFunctionRequiredArgs(x)
end

function GetFunctionArgType(func::AbstractCppFunction, iarg::Integer)
    @check_ptrs func
    return CppType(clang_CppInterOp_GetFunctionArgType(func, iarg))
end

function GetFunctionSignature(func::AbstractCppFunction)
    @check_ptrs func
    return get_string(clang_CppInterOp_GetFunctionSignature(func))
end

function IsFunctionDeleted(x::AbstractCppFunction)
    @check_ptrs x
    return clang_CppInterOp_IsFunctionDeleted(x)
end

function IsTemplatedFunction(x::AbstractCppFunction)
    @check_ptrs x
    return clang_CppInterOp_IsTemplatedFunction(x)
end

function ExistsFunctionTemplate(
    name::AbstractString,
    parent::AbstractCppScope = CppScope(C_NULL),
)
    return clang_CppInterOp_ExistsFunctionTemplate(name, parent)
end

function IsMethod(method::AbstractCppConstFunction)
    @check_ptrs method
    return clang_CppInterOp_IsMethod(method)
end

function IsPublicMethod(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsPublicMethod(method)
end

function IsProtectedMethod(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsProtectedMethod(method)
end

function IsPrivateMethod(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsPrivateMethod(method)
end

function IsConstructor(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsConstructor(method)
end

function IsDestructor(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsDestructor(method)
end

function IsStaticMethod(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsStaticMethod(method)
end

function GetFunctionAddressFromMangledName(mangled_name::AbstractString)
    @check_ptrs mangled_name
    return CppFuncAddr(clang_CppInterOp_GetFunctionAddressFromMangledName(mangled_name))
end

function GetFunctionAddressFromMethod(method::AbstractCppFunction)
    @check_ptrs method
    return CppFuncAddr(clang_CppInterOp_GetFunctionAddressFromMethod(method))
end

function IsVirtualMethod(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsVirtualMethod(method)
end

function GetDatamembers(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_GetDatamembers(x)
end

function LookupDatamember(name::AbstractString, parent::AbstractCppScope)
    @check_ptrs parent
    return CppScope(clang_CppInterOp_LookupDatamember(name, parent))
end

function GetVariableType(x::AbstractCppScope)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetVariableType(x))
end

function GetVariableOffset(x::AbstractCppScope)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetVariableOffset(x))
end

function IsPublicVariable(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsPublicVariable(x)
end

function IsProtectedVariable(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsProtectedVariable(x)
end

function IsPrivateVariable(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsPrivateVariable(x)
end

function IsStaticVariable(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsStaticVariable(x)
end

function IsConstVariable(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_IsConstVariable(x)
end

function IsRecordType(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_IsRecordType(x)
end

function IsPODType(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_IsPODType(x)
end

function GetUnderlyingType(x::AbstractCppType)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetUnderlyingType(x))
end

function GetTypeAsString(x::AbstractCppType)
    @check_ptrs x
    return get_string(clang_CppInterOp_GetTypeAsString(x))
end

function GetCanonicalType(x::AbstractCppType)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetCanonicalType(x))
end

function GetType(x::AbstractString)
    return CppType(clang_CppInterOp_GetType(x))
end

function GetComplexType(element_type::AbstractCppType)
    @check_ptrs element_type
    return CppType(clang_CppInterOp_GetComplexType(element_type))
end

function GetTypeFromScope(x::AbstractCppScope)
    @check_ptrs x
    return CppType(clang_CppInterOp_GetTypeFromScope(x))
end

function IsTypeDerivedFrom(derived::AbstractCppType, base::AbstractCppType)
    @check_ptrs derived base
    return clang_CppInterOp_IsTypeDerivedFrom(derived, base)
end

function MakeFunctionCallable(x::AbstractCppConstFunction)
    @check_ptrs x
    return CppFunction(clang_CppInterOp_MakeFunctionCallable(x))
end

dispose(x::CXCppJitCall) = clang_CppInterOp_CXCppJitCall_dispose(x)

function IsConstMethod(method::AbstractCppFunction)
    @check_ptrs method
    return clang_CppInterOp_IsConstMethod(method)
end

function GetFunctionArgDefault(func::AbstractCppFunction, param_index::Integer)
    @check_ptrs func
    return get_string(clang_CppInterOp_GetFunctionArgDefault(func, param_index))
end

function GetFunctionArgName(func::AbstractCppFunction, param_index::Integer)
    @check_ptrs func
    return get_string(clang_CppInterOp_GetFunctionArgName(func, param_index))
end

function CreateInterpreter(
    args::Vector{<:AbstractString} = String[],
    gpu_args::Vector{<:AbstractString} = String[],
)
    return CppInterpreter(
        clang_CppInterOp_CreateInterpreter(args, length(args), gpu_args, length(gpu_args)),
    )
end

GetInterpreter() = CppInterpreter(clang_CppInterOp_GetInterpreter())

AddSearchPath(dir::AbstractString, isUser::Bool, prepend::Bool) =
    clang_CppInterOp_AddSearchPath(dir, isUser, prepend)

GetResourceDir() = unsafe_string(clang_CppInterOp_GetResourceDir())

AddIncludePath(dir::AbstractString) = clang_CppInterOp_AddIncludePath(dir)

Declare(code::AbstractString, silent::Bool=false) = clang_CppInterOp_Declare(code, silent)

Process(code::AbstractString) = clang_CppInterOp_Process(code)

Evaluate(code::AbstractString, hadError=Ref{Bool}()) = clang_CppInterOp_Evaluate(code, hadError)

LookupLibrary(lib_name::AbstractString) =
    get_string(clang_CppInterOp_LookupLibrary(lib_name))

LoadLibrary(lib_stem::AbstractString, lookup::Bool=true) =
    clang_CppInterOp_LoadLibrary(lib_stem, lookup)

UnloadLibrary(lib_stem::AbstractString) = clang_CppInterOp_UnloadLibrary(lib_stem)

SearchLibrariesForSymbol(mangled_name::AbstractString, search_system::Bool) =
    clang_CppInterOp_SearchLibrariesForSymbol(mangled_name, search_system)

InsertOrReplaceJitSymbol(linker_mangled_name::AbstractString, address::Unsigned) =
    clang_CppInterOp_InsertOrReplaceJitSymbol(linker_mangled_name, address)

ObjToString(type::AbstractString, obj) = get_string(clang_CppInterOp_ObjToString(type, obj))

struct CXTemplateArgInfo
    m_Type::CXCppType
    m_IntegralValue::Ptr{Cchar}
end

InstantiateClassTemplate(
    tmpl::AbstractCppScope,
    template_args,
    template_args_size::Integer,
) = CppScope(
    clang_CppInterOp_InstantiateClassTemplate(tmpl, template_args, template_args_size),
)

struct CXTemplateArgInfoSet
    Args::Ptr{CXTemplateArgInfo}
    Count::Csize_t
end

dispose(x::CXTemplateArgInfoSet) = clang_CppInterOp_CXTemplateArgInfoSet_dispose(x)

function GetClassTemplateInstantiationArgs(templ_instance::AbstractCppScope)
    @check_ptrs templ_instance
    return clang_CppInterOp_GetClassTemplateInstantiationArgs(templ_instance)
end

function InstantiateTemplateFunctionFromString(function_template::AbstractString)
    @check_ptrs function_template
    return CppFunction(
        clang_CppInterOp_InstantiateTemplateFunctionFromString(function_template),
    )
end

function GetAllCppNames(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_GetAllCppNames(x)
end

function DumpScope(x::AbstractCppScope)
    @check_ptrs x
    return clang_CppInterOp_DumpScope(x)
end

struct CXCppDimensions
    Dims::Ptr{Csize_t}
    Count::Csize_t
end

dispose(x::CXCppDimensions) = clang_CppInterOp_CXCppDimensions_dispose(x)

function GetDimensions(x::AbstractCppType)
    @check_ptrs x
    return clang_CppInterOp_GetDimensions(x)
end

function Allocate(x::AbstractCppScope)
    @check_ptrs x
    return CppObject(clang_CppInterOp_Allocate(x))
end

function Deallocate(scope::AbstractCppScope, address::AbstractCppObject)
    @check_ptrs scope address
    return clang_CppInterOp_Deallocate(scope, address)
end

function Construct(scope::AbstractCppScope, arena)
    @check_ptrs scope
    return CppObject(clang_CppInterOp_Construct(scope, arena))
end

function Destruct(this::AbstractCppObject, type::AbstractCppScope, withFree::Bool)
    @check_ptrs this type
    return clang_CppInterOp_Destruct(this, type, withFree)
end

@enum CXCppCaptureStreamKind::UInt32 begin
    CXCppkStdOut = 1
    CXCppkStdErr = 2
end

BeginStdStreamCapture(fd_kind::CXCppCaptureStreamKind) =
    clang_CppInterOp_BeginStdStreamCapture(fd_kind)

EndStdStreamCapture() = get_string(clang_CppInterOp_EndStdStreamCapture())
