module LibCppInterOp

using ..CppInterOp: libCppInterOp, libCppInterOpExtra
using ..CppInterOp: CXErrorCode, CXTypeKind, CXString, CXStringSet

const intptr_t = Clong


mutable struct CXInterpreterImpl end

"""
An opaque pointer representing an interpreter context.
"""
const CXInterpreter = Ptr{CXInterpreterImpl}

"""
    clang_createInterpreter(argv, argc)

Create a Clang interpreter instance from the given arguments.

# Arguments
* `argv`: The arguments that would be passed to the interpreter.
* `argc`: The number of arguments in `argv`.
# Returns
a [`CXInterpreter`](@ref).
"""
function clang_createInterpreter(argv, argc)
    @ccall libCppInterOp.clang_createInterpreter(argv::Ptr{Ptr{Cchar}}, argc::Cint)::CXInterpreter
end

const TInterp_t = Ptr{Cvoid}

"""
    clang_createInterpreterFromPtr(I)

Bridge between C API and C++ API.

# Returns
a [`CXInterpreter`](@ref).
"""
function clang_createInterpreterFromPtr(I)
    @ccall libCppInterOp.clang_createInterpreterFromPtr(I::TInterp_t)::CXInterpreter
end

"""
    clang_interpreter_getInterpreterAsPtr(I)

Returns a [`TInterp_t`](@ref).
"""
function clang_interpreter_getInterpreterAsPtr(I)
    @ccall libCppInterOp.clang_interpreter_getInterpreterAsPtr(I::CXInterpreter)::TInterp_t
end

"""
    clang_interpreter_takeInterpreterAsPtr(I)

Similar to [`clang_interpreter_getInterpreterAsPtr`](@ref)() but it takes the ownership.
"""
function clang_interpreter_takeInterpreterAsPtr(I)
    @ccall libCppInterOp.clang_interpreter_takeInterpreterAsPtr(I::CXInterpreter)::TInterp_t
end

"""
    clang_interpreter_Undo(I, N)

Undo N previous incremental inputs.
"""
function clang_interpreter_Undo(I, N)
    @ccall libCppInterOp.clang_interpreter_Undo(I::CXInterpreter, N::Cuint)::CXErrorCode
end

"""
    clang_interpreter_dispose(I)

Dispose of the given interpreter context.
"""
function clang_interpreter_dispose(I)
    @ccall libCppInterOp.clang_interpreter_dispose(I::CXInterpreter)::Cvoid
end

"""
    CXInterpreter_CompilationResult

Describes the return result of the different routines that do the incremental compilation.
"""
@enum CXInterpreter_CompilationResult::UInt32 begin
    CXInterpreter_Success = 0
    CXInterpreter_Failure = 1
    CXInterpreter_MoreInputExpected = 2
end

"""
    clang_interpreter_addSearchPath(I, dir, isUser, prepend)

Add a search path to the interpreter.

# Arguments
* `I`: The interpreter.
* `dir`: The directory to add.
* `isUser`: Whether the directory is a user directory.
* `prepend`: Whether to prepend the directory to the search path.
"""
function clang_interpreter_addSearchPath(I, dir, isUser, prepend)
    @ccall libCppInterOp.clang_interpreter_addSearchPath(I::CXInterpreter, dir::Ptr{Cchar}, isUser::Bool, prepend::Bool)::Cvoid
end

"""
    clang_interpreter_getResourceDir(I)

Get the resource directory.
"""
function clang_interpreter_getResourceDir(I)
    @ccall libCppInterOp.clang_interpreter_getResourceDir(I::CXInterpreter)::Ptr{Cchar}
end

"""
    clang_interpreter_addIncludePath(I, dir)

Add an include path.

# Arguments
* `I`: The interpreter.
* `dir`: The directory to add.
"""
function clang_interpreter_addIncludePath(I, dir)
    @ccall libCppInterOp.clang_interpreter_addIncludePath(I::CXInterpreter, dir::Ptr{Cchar})::Cvoid
end

"""
    clang_interpreter_declare(I, code, silent)

Declares a code snippet in `code` and does not execute it.

# Arguments
* `I`: The interpreter.
* `code`: The code snippet to declare.
* `silent`: Whether to suppress the diagnostics or not
# Returns
a [`CXErrorCode`](@ref).
"""
function clang_interpreter_declare(I, code, silent)
    @ccall libCppInterOp.clang_interpreter_declare(I::CXInterpreter, code::Ptr{Cchar}, silent::Bool)::CXErrorCode
end

"""
    clang_interpreter_process(I, code)

Declares and executes a code snippet in `code`.

# Arguments
* `I`: The interpreter.
* `code`: The code snippet to execute.
# Returns
a [`CXErrorCode`](@ref).
"""
function clang_interpreter_process(I, code)
    @ccall libCppInterOp.clang_interpreter_process(I::CXInterpreter, code::Ptr{Cchar})::CXErrorCode
end

"""
An opaque pointer representing a lightweight struct that is used for carrying execution results.
"""
const CXValue = Ptr{Cvoid}

"""
    clang_createValue()

Create a [`CXValue`](@ref).

# Returns
a [`CXValue`](@ref).
"""
function clang_createValue()
    @ccall libCppInterOp.clang_createValue()::CXValue
end

"""
    clang_value_dispose(V)

Dispose of the given [`CXValue`](@ref).

# Arguments
* `V`: The [`CXValue`](@ref) to dispose.
"""
function clang_value_dispose(V)
    @ccall libCppInterOp.clang_value_dispose(V::CXValue)::Cvoid
end

"""
    clang_interpreter_evaluate(I, code, V)

Declares, executes and stores the execution result to `V`.

# Arguments
* `I`:\\[in\\] The interpreter.
* `code`:\\[in\\] The code snippet to evaluate.
* `V`:\\[out\\] The value to store the execution result.
# Returns
a [`CXErrorCode`](@ref).
"""
function clang_interpreter_evaluate(I, code, V)
    @ccall libCppInterOp.clang_interpreter_evaluate(I::CXInterpreter, code::Ptr{Cchar}, V::CXValue)::CXErrorCode
end

"""
    clang_interpreter_lookupLibrary(I, lib_name)

Looks up the library if access is enabled.

# Arguments
* `I`: The interpreter.
* `lib_name`: The name of the library to lookup.
# Returns
the path to the library.
"""
function clang_interpreter_lookupLibrary(I, lib_name)
    @ccall libCppInterOp.clang_interpreter_lookupLibrary(I::CXInterpreter, lib_name::Ptr{Cchar})::CXString
end

"""
    clang_interpreter_loadLibrary(I, lib_stem, lookup)

Finds `lib_stem` considering the list of search paths and loads it by calling dlopen.

# Arguments
* `I`: The interpreter.
* `lib_stem`: The stem of the library to load.
* `lookup`: Whether to lookup the library or not.
# Returns
a [`CXInterpreter_CompilationResult`](@ref).
"""
function clang_interpreter_loadLibrary(I, lib_stem, lookup)
    @ccall libCppInterOp.clang_interpreter_loadLibrary(I::CXInterpreter, lib_stem::Ptr{Cchar}, lookup::Bool)::CXInterpreter_CompilationResult
end

"""
    clang_interpreter_unloadLibrary(I, lib_stem)

Finds `lib_stem` considering the list of search paths and unloads it by calling dlclose.

# Arguments
* `I`: The interpreter.
* `lib_stem`: The stem of the library to unload.
"""
function clang_interpreter_unloadLibrary(I, lib_stem)
    @ccall libCppInterOp.clang_interpreter_unloadLibrary(I::CXInterpreter, lib_stem::Ptr{Cchar})::Cvoid
end

"""
    clang_interpreter_searchLibrariesForSymbol(I, mangled_name, search_system)

Scans all libraries on the library search path for a given potentially mangled symbol name.

# Arguments
* `I`: The interpreter.
* `mangled_name`: The mangled name of the symbol to search for.
* `search_system`: Whether to search the system paths or not.
# Returns
the path to the first library that contains the symbol definition.
"""
function clang_interpreter_searchLibrariesForSymbol(I, mangled_name, search_system)
    @ccall libCppInterOp.clang_interpreter_searchLibrariesForSymbol(I::CXInterpreter, mangled_name::Ptr{Cchar}, search_system::Bool)::CXString
end

"""
    clang_interpreter_insertOrReplaceJitSymbol(I, linker_mangled_name, address)

Inserts or replaces a symbol in the JIT with the one provided. This is useful for providing our own implementations of facilities such as printf.

# Arguments
* `I`: The interpreter.
* `linker_mangled_name`: The name of the symbol to be inserted or replaced.
* `address`: The new address of the symbol.
# Returns
true on failure.
"""
function clang_interpreter_insertOrReplaceJitSymbol(I, linker_mangled_name, address)
    @ccall libCppInterOp.clang_interpreter_insertOrReplaceJitSymbol(I::CXInterpreter, linker_mangled_name::Ptr{Cchar}, address::UInt64)::Bool
end

const CXFuncAddr = Ptr{Cvoid}

"""
    clang_interpreter_getFunctionAddressFromMangledName(I, mangled_name)

Get the function address from the given mangled name.

# Arguments
* `I`: The interpreter.
* `mangled_name`: The mangled name of the function.
# Returns
the address of the function given its potentially mangled name.
"""
function clang_interpreter_getFunctionAddressFromMangledName(I, mangled_name)
    @ccall libCppInterOp.clang_interpreter_getFunctionAddressFromMangledName(I::CXInterpreter, mangled_name::Ptr{Cchar})::CXFuncAddr
end

"""
    CXQualType

An opaque pointer representing a type.
"""
struct CXQualType
    kind::CXTypeKind
    data::Ptr{Cvoid}
    meta::Ptr{Cvoid}
end

"""
    clang_qualtype_isBuiltin(type)

Checks if it is a "built-in" or a "complex" type.
"""
function clang_qualtype_isBuiltin(type)
    @ccall libCppInterOp.clang_qualtype_isBuiltin(type::CXQualType)::Bool
end

"""
    clang_qualtype_isEnumType(type)

Checks if the passed value is an enum type or not.
"""
function clang_qualtype_isEnumType(type)
    @ccall libCppInterOp.clang_qualtype_isEnumType(type::CXQualType)::Bool
end

"""
    clang_qualtype_isSmartPtrType(type)

We assume that smart pointer types define both operator* and operator->.
"""
function clang_qualtype_isSmartPtrType(type)
    @ccall libCppInterOp.clang_qualtype_isSmartPtrType(type::CXQualType)::Bool
end

"""
    clang_scope_isRecordType(type)

Checks if the provided parameter is a Record (struct).
"""
function clang_scope_isRecordType(type)
    @ccall libCppInterOp.clang_scope_isRecordType(type::CXQualType)::Bool
end

"""
    clang_scope_isPODType(type)

Checks if the provided parameter is a Plain Old Data Type (POD).
"""
function clang_scope_isPODType(type)
    @ccall libCppInterOp.clang_scope_isPODType(type::CXQualType)::Bool
end

"""
    clang_qualtype_getIntegerTypeFromEnumType(type)

For the given "type", this function gets the integer type that the enum represents, so that you can store it properly in your specific language.
"""
function clang_qualtype_getIntegerTypeFromEnumType(type)
    @ccall libCppInterOp.clang_qualtype_getIntegerTypeFromEnumType(type::CXQualType)::CXQualType
end

"""
    clang_qualtype_getUnderlyingType(type)

Gets the pure, Underlying Type (as opposed to the Using Type).
"""
function clang_qualtype_getUnderlyingType(type)
    @ccall libCppInterOp.clang_qualtype_getUnderlyingType(type::CXQualType)::CXQualType
end

"""
    clang_qualtype_getTypeAsString(type)

Gets the Type (passed as a parameter) as a String value.
"""
function clang_qualtype_getTypeAsString(type)
    @ccall libCppInterOp.clang_qualtype_getTypeAsString(type::CXQualType)::CXString
end

"""
    clang_qualtype_getCanonicalType(type)

Gets the Canonical Type string from the std string. A canonical type is the type with any typedef names, syntactic sugars or modifiers stripped out of it.
"""
function clang_qualtype_getCanonicalType(type)
    @ccall libCppInterOp.clang_qualtype_getCanonicalType(type::CXQualType)::CXQualType
end

"""
    clang_qualtype_getType(I, name)

Used to either get the built-in type of the provided string, or use the name to lookup the actual type.
"""
function clang_qualtype_getType(I, name)
    @ccall libCppInterOp.clang_qualtype_getType(I::CXInterpreter, name::Ptr{Cchar})::CXQualType
end

"""
    clang_qualtype_getComplexType(eltype)

Returns the complex of the provided type.
"""
function clang_qualtype_getComplexType(eltype)
    @ccall libCppInterOp.clang_qualtype_getComplexType(eltype::CXQualType)::CXQualType
end

"""
    clang_qualtype_getSizeOfType(type)

Gets the size of the "type" that is passed in to this function.
"""
function clang_qualtype_getSizeOfType(type)
    @ccall libCppInterOp.clang_qualtype_getSizeOfType(type::CXQualType)::Csize_t
end

"""
    clang_qualtype_isTypeDerivedFrom(derived, base)

Checks if a C++ type derives from another.
"""
function clang_qualtype_isTypeDerivedFrom(derived, base)
    @ccall libCppInterOp.clang_qualtype_isTypeDerivedFrom(derived::CXQualType, base::CXQualType)::Bool
end

"""
    CXScopeKind

Describes the kind of entity that a scope refers to.
"""
@enum CXScopeKind::UInt32 begin
    CXScope_Unexposed = 1
    CXScope_Enum = 5
    CXScope_Field = 6
    CXScope_EnumConstant = 7
    CXScope_Function = 8
    CXCursor_Var = 9
    CXScope_Typedef = 20
    CXScope_Namespace = 22
    CXScope_ClassTemplate = 31
    CXScope_TypeAlias = 36
    CXScope_Invalid = 70
    CXScope_TranslationUnit = 350
    CXScope_Record = 999
    CXScope_CXXRecord = 1000
end

"""
    CXScope

An opaque pointer representing a variable, typedef, function, struct, etc.
"""
struct CXScope
    kind::CXScopeKind
    data::Ptr{Cvoid}
    meta::Ptr{Cvoid}
end

function clang_scope_dump(S)
    @ccall libCppInterOp.clang_scope_dump(S::CXScope)::Cvoid
end

"""
    clang_scope_getTypeFromScope(S)

This will convert a class into its type, so for example, you can use it to declare variables in it.
"""
function clang_scope_getTypeFromScope(S)
    @ccall libCppInterOp.clang_scope_getTypeFromScope(S::CXScope)::CXQualType
end

"""
    clang_scope_isAggregate(S)

Checks if the given class represents an aggregate type.

# Returns
true if the `scope` supports aggregate initialization.
"""
function clang_scope_isAggregate(S)
    @ccall libCppInterOp.clang_scope_isAggregate(S::CXScope)::Bool
end

"""
    clang_scope_isNamespace(S)

Checks if the scope is a namespace or not.
"""
function clang_scope_isNamespace(S)
    @ccall libCppInterOp.clang_scope_isNamespace(S::CXScope)::Bool
end

"""
    clang_scope_isClass(S)

Checks if the scope is a class or not.
"""
function clang_scope_isClass(S)
    @ccall libCppInterOp.clang_scope_isClass(S::CXScope)::Bool
end

"""
    clang_scope_isComplete(S)

Checks if the class definition is present, or not. Performs a template instantiation if necessary.
"""
function clang_scope_isComplete(S)
    @ccall libCppInterOp.clang_scope_isComplete(S::CXScope)::Bool
end

"""
    clang_scope_sizeOf(S)

Get the size of the given type.
"""
function clang_scope_sizeOf(S)
    @ccall libCppInterOp.clang_scope_sizeOf(S::CXScope)::Csize_t
end

"""
    clang_scope_isTemplate(S)

Checks if it is a templated class.
"""
function clang_scope_isTemplate(S)
    @ccall libCppInterOp.clang_scope_isTemplate(S::CXScope)::Bool
end

"""
    clang_scope_isTemplateSpecialization(S)

Checks if it is a class template specialization class.
"""
function clang_scope_isTemplateSpecialization(S)
    @ccall libCppInterOp.clang_scope_isTemplateSpecialization(S::CXScope)::Bool
end

"""
    clang_scope_isTypedefed(S)

Checks if `handle` introduces a typedef name via `typedef` or `using`.
"""
function clang_scope_isTypedefed(S)
    @ccall libCppInterOp.clang_scope_isTypedefed(S::CXScope)::Bool
end

function clang_scope_isAbstract(S)
    @ccall libCppInterOp.clang_scope_isAbstract(S::CXScope)::Bool
end

"""
    clang_scope_isEnumScope(S)

Checks if it is an enum name (EnumDecl represents an enum name).
"""
function clang_scope_isEnumScope(S)
    @ccall libCppInterOp.clang_scope_isEnumScope(S::CXScope)::Bool
end

"""
    clang_scope_isEnumConstant(S)

Checks if it is an enum's value (EnumConstantDecl represents each enum constant that is defined).
"""
function clang_scope_isEnumConstant(S)
    @ccall libCppInterOp.clang_scope_isEnumConstant(S::CXScope)::Bool
end

"""
    clang_scope_getEnums(S)

Extracts enum declarations from a specified scope and stores them in vector
"""
function clang_scope_getEnums(S)
    @ccall libCppInterOp.clang_scope_getEnums(S::CXScope)::Ptr{CXStringSet}
end

"""
    clang_scope_getIntegerTypeFromEnumScope(S)

For the given "class", get the integer type that the enum represents, so that you can store it properly in your specific language.
"""
function clang_scope_getIntegerTypeFromEnumScope(S)
    @ccall libCppInterOp.clang_scope_getIntegerTypeFromEnumScope(S::CXScope)::CXQualType
end

struct CXScopeSet
    Scopes::Ptr{CXScope}
    Count::Csize_t
end

"""
    clang_disposeScopeSet(set)

Free the given scope set.
"""
function clang_disposeScopeSet(set)
    @ccall libCppInterOp.clang_disposeScopeSet(set::Ptr{CXScopeSet})::Cvoid
end

"""
    clang_scope_getEnumConstants(S)

Gets a list of all the enum constants for an enum.
"""
function clang_scope_getEnumConstants(S)
    @ccall libCppInterOp.clang_scope_getEnumConstants(S::CXScope)::Ptr{CXScopeSet}
end

"""
    clang_scope_getEnumConstantType(S)

Gets the enum name when an enum constant is passed.
"""
function clang_scope_getEnumConstantType(S)
    @ccall libCppInterOp.clang_scope_getEnumConstantType(S::CXScope)::CXQualType
end

"""
    clang_scope_getEnumConstantValue(S)

Gets the index value (0,1,2, etcetera) of the enum constant that was passed into this function.
"""
function clang_scope_getEnumConstantValue(S)
    @ccall libCppInterOp.clang_scope_getEnumConstantValue(S::CXScope)::Csize_t
end

"""
    clang_scope_isVariable(S)

Checks if the passed value is a variable.
"""
function clang_scope_isVariable(S)
    @ccall libCppInterOp.clang_scope_isVariable(S::CXScope)::Bool
end

"""
    clang_scope_getName(S)

Gets the name of any named decl (a class, namespace, variable, or a function).
"""
function clang_scope_getName(S)
    @ccall libCppInterOp.clang_scope_getName(S::CXScope)::CXString
end

"""
    clang_scope_getCompleteName(S)

This is similar to [`clang_scope_getName`](@ref)() function, but besides the name, it also gets the template arguments.
"""
function clang_scope_getCompleteName(S)
    @ccall libCppInterOp.clang_scope_getCompleteName(S::CXScope)::CXString
end

"""
    clang_scope_getQualifiedName(S)

Gets the "qualified" name (including the namespace) of any named decl (a class, namespace, variable, or a function).
"""
function clang_scope_getQualifiedName(S)
    @ccall libCppInterOp.clang_scope_getQualifiedName(S::CXScope)::CXString
end

"""
    clang_scope_getQualifiedCompleteName(S)

This is similar to [`clang_scope_getQualifiedName`](@ref)() function, but besides the "qualified" name (including the namespace), it also gets the template arguments.
"""
function clang_scope_getQualifiedCompleteName(S)
    @ccall libCppInterOp.clang_scope_getQualifiedCompleteName(S::CXScope)::CXString
end

"""
    clang_scope_getUsingNamespaces(S)

Gets the list of namespaces utilized in the supplied scope.
"""
function clang_scope_getUsingNamespaces(S)
    @ccall libCppInterOp.clang_scope_getUsingNamespaces(S::CXScope)::Ptr{CXScopeSet}
end

"""
    clang_scope_getGlobalScope(I)

Gets the global scope of the whole interpreter instance.
"""
function clang_scope_getGlobalScope(I)
    @ccall libCppInterOp.clang_scope_getGlobalScope(I::CXInterpreter)::CXScope
end

"""
    clang_scope_getUnderlyingScope(S)

Strips the typedef and returns the underlying class, and if the underlying decl is not a class it returns the input unchanged.
"""
function clang_scope_getUnderlyingScope(S)
    @ccall libCppInterOp.clang_scope_getUnderlyingScope(S::CXScope)::CXScope
end

"""
    clang_scope_getScope(name, parent)

Gets the namespace or class (by stripping typedefs) for the name passed as a parameter. `parent` is mandatory, the global scope should be used as the default value.
"""
function clang_scope_getScope(name, parent)
    @ccall libCppInterOp.clang_scope_getScope(name::Ptr{Cchar}, parent::CXScope)::CXScope
end

"""
    clang_scope_getNamed(name, parent)

This function performs a lookup within the specified parent, a specific named entity (functions, enums, etcetera).
"""
function clang_scope_getNamed(name, parent)
    @ccall libCppInterOp.clang_scope_getNamed(name::Ptr{Cchar}, parent::CXScope)::CXScope
end

"""
    clang_scope_getParentScope(parent)

Gets the parent of the scope that is passed as a parameter.
"""
function clang_scope_getParentScope(parent)
    @ccall libCppInterOp.clang_scope_getParentScope(parent::CXScope)::CXScope
end

"""
    clang_scope_getScopeFromType(type)

Gets the scope of the type that is passed as a parameter.
"""
function clang_scope_getScopeFromType(type)
    @ccall libCppInterOp.clang_scope_getScopeFromType(type::CXQualType)::CXScope
end

"""
    clang_scope_getNumBases(S)

Gets the number of Base Classes for the Derived Class that is passed as a parameter.
"""
function clang_scope_getNumBases(S)
    @ccall libCppInterOp.clang_scope_getNumBases(S::CXScope)::Csize_t
end

"""
    clang_scope_getBaseClass(S, ibase)

Gets a specific Base Class using its index. Typically [`clang_scope_getNumBases`](@ref)() is used to get the number of Base Classes, and then that number can be used to iterate through the index value to get each specific base class.
"""
function clang_scope_getBaseClass(S, ibase)
    @ccall libCppInterOp.clang_scope_getBaseClass(S::CXScope, ibase::Csize_t)::CXScope
end

"""
    clang_scope_isSubclass(derived, base)

Checks if the supplied Derived Class is a sub-class of the provided Base Class.
"""
function clang_scope_isSubclass(derived, base)
    @ccall libCppInterOp.clang_scope_isSubclass(derived::CXScope, base::CXScope)::Bool
end

"""
    clang_scope_getBaseClassOffset(derived, base)

Each base has its own offset in a Derived Class. This offset can be used to get to the Base Class fields.
"""
function clang_scope_getBaseClassOffset(derived, base)
    @ccall libCppInterOp.clang_scope_getBaseClassOffset(derived::CXScope, base::CXScope)::Int64
end

"""
    clang_scope_getClassMethods(S)

Gets a list of all the Methods that are in the Class that is supplied as a parameter.
"""
function clang_scope_getClassMethods(S)
    @ccall libCppInterOp.clang_scope_getClassMethods(S::CXScope)::Ptr{CXScopeSet}
end

"""
    clang_scope_getFunctionTemplatedDecls(S)

Template function pointer list to add proxies for un-instantiated/non-overloaded templated methods.
"""
function clang_scope_getFunctionTemplatedDecls(S)
    @ccall libCppInterOp.clang_scope_getFunctionTemplatedDecls(S::CXScope)::Ptr{CXScopeSet}
end

"""
    clang_scope_hasDefaultConstructor(S)

Checks if a class has a default constructor.
"""
function clang_scope_hasDefaultConstructor(S)
    @ccall libCppInterOp.clang_scope_hasDefaultConstructor(S::CXScope)::Bool
end

"""
    clang_scope_getDefaultConstructor(S)

Returns the default constructor of a class, if any.
"""
function clang_scope_getDefaultConstructor(S)
    @ccall libCppInterOp.clang_scope_getDefaultConstructor(S::CXScope)::CXScope
end

"""
    clang_scope_getDestructor(S)

Returns the class destructor, if any.
"""
function clang_scope_getDestructor(S)
    @ccall libCppInterOp.clang_scope_getDestructor(S::CXScope)::CXScope
end

"""
    clang_scope_getFunctionsUsingName(S, name)

Looks up all the functions that have the name that is passed as a parameter in this function.
"""
function clang_scope_getFunctionsUsingName(S, name)
    @ccall libCppInterOp.clang_scope_getFunctionsUsingName(S::CXScope, name::Ptr{Cchar})::Ptr{CXScopeSet}
end

"""
    clang_scope_getFunctionReturnType(func)

Gets the return type of the provided function.
"""
function clang_scope_getFunctionReturnType(func)
    @ccall libCppInterOp.clang_scope_getFunctionReturnType(func::CXScope)::CXQualType
end

"""
    clang_scope_getFunctionNumArgs(func)

Gets the number of Arguments for the provided function.
"""
function clang_scope_getFunctionNumArgs(func)
    @ccall libCppInterOp.clang_scope_getFunctionNumArgs(func::CXScope)::Csize_t
end

"""
    clang_scope_getFunctionRequiredArgs(func)

Gets the number of Required Arguments for the provided function.
"""
function clang_scope_getFunctionRequiredArgs(func)
    @ccall libCppInterOp.clang_scope_getFunctionRequiredArgs(func::CXScope)::Csize_t
end

"""
    clang_scope_getFunctionArgType(func, iarg)

For each Argument of a function, you can get the Argument Type by providing the Argument Index, based on the number of arguments from the [`clang_scope_getFunctionNumArgs`](@ref)() function.
"""
function clang_scope_getFunctionArgType(func, iarg)
    @ccall libCppInterOp.clang_scope_getFunctionArgType(func::CXScope, iarg::Csize_t)::CXQualType
end

"""
    clang_scope_getFunctionSignature(func)

Returns a stringified version of a given function signature in the form: void N::f(int i, double d, long l = 0, char ch = 'a').
"""
function clang_scope_getFunctionSignature(func)
    @ccall libCppInterOp.clang_scope_getFunctionSignature(func::CXScope)::CXString
end

"""
    clang_scope_isFunctionDeleted(func)

Checks if a function was marked as `=delete.`
"""
function clang_scope_isFunctionDeleted(func)
    @ccall libCppInterOp.clang_scope_isFunctionDeleted(func::CXScope)::Bool
end

"""
    clang_scope_isTemplatedFunction(func)

Checks if a function is a templated function.
"""
function clang_scope_isTemplatedFunction(func)
    @ccall libCppInterOp.clang_scope_isTemplatedFunction(func::CXScope)::Bool
end

"""
    clang_scope_existsFunctionTemplate(name, parent)

This function performs a lookup to check if there is a templated function of that type. `parent` is mandatory, the global scope should be used as the default value.
"""
function clang_scope_existsFunctionTemplate(name, parent)
    @ccall libCppInterOp.clang_scope_existsFunctionTemplate(name::Ptr{Cchar}, parent::CXScope)::Bool
end

"""
    clang_scope_getClassTemplatedMethods(name, parent)

Gets a list of all the Templated Methods that are in the Class that is supplied as a parameter.
"""
function clang_scope_getClassTemplatedMethods(name, parent)
    @ccall libCppInterOp.clang_scope_getClassTemplatedMethods(name::Ptr{Cchar}, parent::CXScope)::Ptr{CXScopeSet}
end

"""
    clang_scope_isMethod(method)

Checks if the provided parameter is a method.
"""
function clang_scope_isMethod(method)
    @ccall libCppInterOp.clang_scope_isMethod(method::CXScope)::Bool
end

"""
    clang_scope_isPublicMethod(method)

Checks if the provided parameter is a 'Public' method.
"""
function clang_scope_isPublicMethod(method)
    @ccall libCppInterOp.clang_scope_isPublicMethod(method::CXScope)::Bool
end

"""
    clang_scope_isProtectedMethod(method)

Checks if the provided parameter is a 'Protected' method.
"""
function clang_scope_isProtectedMethod(method)
    @ccall libCppInterOp.clang_scope_isProtectedMethod(method::CXScope)::Bool
end

"""
    clang_scope_isPrivateMethod(method)

Checks if the provided parameter is a 'Private' method.
"""
function clang_scope_isPrivateMethod(method)
    @ccall libCppInterOp.clang_scope_isPrivateMethod(method::CXScope)::Bool
end

"""
    clang_scope_isConstructor(method)

Checks if the provided parameter is a Constructor.
"""
function clang_scope_isConstructor(method)
    @ccall libCppInterOp.clang_scope_isConstructor(method::CXScope)::Bool
end

"""
    clang_scope_isDestructor(method)

Checks if the provided parameter is a Destructor.
"""
function clang_scope_isDestructor(method)
    @ccall libCppInterOp.clang_scope_isDestructor(method::CXScope)::Bool
end

"""
    clang_scope_isStaticMethod(method)

Checks if the provided parameter is a 'Static' method.
"""
function clang_scope_isStaticMethod(method)
    @ccall libCppInterOp.clang_scope_isStaticMethod(method::CXScope)::Bool
end

"""
    clang_scope_getFunctionAddress(method)

Returns the address of the function given its function declaration.
"""
function clang_scope_getFunctionAddress(method)
    @ccall libCppInterOp.clang_scope_getFunctionAddress(method::CXScope)::CXFuncAddr
end

"""
    clang_scope_isVirtualMethod(method)

Checks if the provided parameter is a 'Virtual' method.
"""
function clang_scope_isVirtualMethod(method)
    @ccall libCppInterOp.clang_scope_isVirtualMethod(method::CXScope)::Bool
end

"""
    clang_scope_isConstMethod(method)

Checks if a function declared is of const type or not.
"""
function clang_scope_isConstMethod(method)
    @ccall libCppInterOp.clang_scope_isConstMethod(method::CXScope)::Bool
end

"""
    clang_scope_getFunctionArgDefault(func, param_index)

Returns the default argument value as string.
"""
function clang_scope_getFunctionArgDefault(func, param_index)
    @ccall libCppInterOp.clang_scope_getFunctionArgDefault(func::CXScope, param_index::Csize_t)::CXString
end

"""
    clang_scope_getFunctionArgName(func, param_index)

Returns the argument name of function as string.
"""
function clang_scope_getFunctionArgName(func, param_index)
    @ccall libCppInterOp.clang_scope_getFunctionArgName(func::CXScope, param_index::Csize_t)::CXString
end

struct CXTemplateArgInfo
    Type::Ptr{Cvoid}
    IntegralValue::Ptr{Cchar}
end

"""
    clang_scope_instantiateTemplate(tmpl, template_args, template_args_size)

Builds a template instantiation for a given templated declaration. Offers a single interface for instantiation of class, function and variable templates.

# Arguments
* `tmpl`:\\[in\\] The uninstantiated template class/function.
* `template_args`:\\[in\\] The pointer to vector of template arguments stored in the `TemplateArgInfo` struct
* `template_args_size`:\\[in\\] The size of the vector of template arguments passed as `template_args`
# Returns
a [`CXScope`](@ref) representing the instantiated templated class/function/variable.
"""
function clang_scope_instantiateTemplate(tmpl, template_args, template_args_size)
    @ccall libCppInterOp.clang_scope_instantiateTemplate(tmpl::CXScope, template_args::Ptr{CXTemplateArgInfo}, template_args_size::Csize_t)::CXScope
end

"""
    clang_scope_getDatamembers(S)

Gets all the Fields/Data Members of a Class. For now, it only gets non-static data members but in a future update, it may support getting static data members as well.
"""
function clang_scope_getDatamembers(S)
    @ccall libCppInterOp.clang_scope_getDatamembers(S::CXScope)::Ptr{CXScopeSet}
end

"""
    clang_scope_lookupDatamember(name, parent)

This is a Lookup function to be used specifically for data members. `parent` is mandatory, the global scope should be used as the default value.
"""
function clang_scope_lookupDatamember(name, parent)
    @ccall libCppInterOp.clang_scope_lookupDatamember(name::Ptr{Cchar}, parent::CXScope)::CXScope
end

"""
    clang_scope_getVariableType(var)

Gets the type of the variable that is passed as a parameter.
"""
function clang_scope_getVariableType(var)
    @ccall libCppInterOp.clang_scope_getVariableType(var::CXScope)::CXQualType
end

"""
    clang_scope_getVariableOffset(var)

Gets the address of the variable, you can use it to get the value stored in the variable.
"""
function clang_scope_getVariableOffset(var)
    @ccall libCppInterOp.clang_scope_getVariableOffset(var::CXScope)::intptr_t
end

"""
    clang_scope_isPublicVariable(var)

Checks if the provided variable is a 'Public' variable.
"""
function clang_scope_isPublicVariable(var)
    @ccall libCppInterOp.clang_scope_isPublicVariable(var::CXScope)::Bool
end

"""
    clang_scope_isProtectedVariable(var)

Checks if the provided variable is a 'Protected' variable.
"""
function clang_scope_isProtectedVariable(var)
    @ccall libCppInterOp.clang_scope_isProtectedVariable(var::CXScope)::Bool
end

"""
    clang_scope_isPrivateVariable(var)

Checks if the provided variable is a 'Private' variable.
"""
function clang_scope_isPrivateVariable(var)
    @ccall libCppInterOp.clang_scope_isPrivateVariable(var::CXScope)::Bool
end

"""
    clang_scope_isStaticVariable(var)

Checks if the provided variable is a 'Static' variable.
"""
function clang_scope_isStaticVariable(var)
    @ccall libCppInterOp.clang_scope_isStaticVariable(var::CXScope)::Bool
end

"""
    clang_scope_isConstVariable(var)

Checks if the provided variable is a 'Const' variable.
"""
function clang_scope_isConstVariable(var)
    @ccall libCppInterOp.clang_scope_isConstVariable(var::CXScope)::Bool
end

"""
An opaque pointer representing the object of a given type ([`CXScope`](@ref)).
"""
const CXObject = Ptr{Cvoid}

"""
    clang_allocate(S)

Allocates memory for the given type.
"""
function clang_allocate(S)
    @ccall libCppInterOp.clang_allocate(S::CXScope)::CXObject
end

"""
    clang_deallocate(address)

Deallocates memory for a given class.
"""
function clang_deallocate(address)
    @ccall libCppInterOp.clang_deallocate(address::CXObject)::Cvoid
end

"""
    clang_construct(scope, arena)

Creates an object of class `scope` and calls its default constructor. If `arena` is set it uses placement new.
"""
function clang_construct(scope, arena)
    @ccall libCppInterOp.clang_construct(scope::CXScope, arena::Ptr{Cvoid})::CXObject
end

"""
    clang_destruct(This, S, withFree)

Calls the destructor of object of type `type`. When withFree is true it calls operator delete/free.

# Arguments
* `This`: The object to destruct.
* `type`: The type of the object.
* `withFree`: Whether to call operator delete/free or not.
"""
function clang_destruct(This, S, withFree)
    @ccall libCppInterOp.clang_destruct(This::CXObject, S::CXScope, withFree::Bool)::Cvoid
end

mutable struct CXJitCallImpl end

"""
An opaque pointer representing CppInterOp's JitCall, a class modeling function calls for functions produced by the interpreter in compiled code.
"""
const CXJitCall = Ptr{CXJitCallImpl}

"""
    clang_jitcall_create(func)

Creates a trampoline function by using the interpreter and returns a uniform interface to call it from compiled code.

# Returns
a [`CXJitCall`](@ref).
"""
function clang_jitcall_create(func)
    @ccall libCppInterOp.clang_jitcall_create(func::CXScope)::CXJitCall
end

"""
    clang_jitcall_dispose(J)

Dispose of the given [`CXJitCall`](@ref).

# Arguments
* `J`: The [`CXJitCall`](@ref) to dispose.
"""
function clang_jitcall_dispose(J)
    @ccall libCppInterOp.clang_jitcall_dispose(J::CXJitCall)::Cvoid
end

"""
    CXJitCallKind

The kind of the JitCall.
"""
@enum CXJitCallKind::UInt32 begin
    CXJitCall_Unknown = 0
    CXJitCall_GenericCall = 1
    CXJitCall_DestructorCall = 2
end

"""
    clang_jitcall_getKind(J)

Get the kind of the given [`CXJitCall`](@ref).

# Arguments
* `J`: The [`CXJitCall`](@ref).
# Returns
the kind of the given [`CXJitCall`](@ref).
"""
function clang_jitcall_getKind(J)
    @ccall libCppInterOp.clang_jitcall_getKind(J::CXJitCall)::CXJitCallKind
end

"""
    clang_jitcall_isValid(J)

Check if the given [`CXJitCall`](@ref) is valid.

# Arguments
* `J`: The [`CXJitCall`](@ref).
# Returns
true if the given [`CXJitCall`](@ref) is valid.
"""
function clang_jitcall_isValid(J)
    @ccall libCppInterOp.clang_jitcall_isValid(J::CXJitCall)::Bool
end

"""
    clang_jitcall_invoke(J, result, args, n, self)

Makes a call to a generic function or method.

# Arguments
* `J`: The [`CXJitCall`](@ref).
* `result`: The location where the return result will be placed.
* `args`: The arguments to pass to the invocation.
* `n`: The number of arguments.
* `self`: The 'this pointer' of the object.
"""
function clang_jitcall_invoke(J, result, args, n, self)
    @ccall libCppInterOp.clang_jitcall_invoke(J::CXJitCall, result::Ptr{Cvoid}, args::Ptr{Ptr{Cvoid}}, n::Cuint, self::Ptr{Cvoid})::Cvoid
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
