module LibCppInterOp

using ..CppInterOp: libCppInterOp, libCppInterOpExtra
using ..CppInterOp: CXErrorCode, CXTypeKind, CXCursorKind, CXString, CXStringSet

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
    clang_createInterpreterFromRawPtr(I)

Bridge between C API and C++ API.

# Returns
a [`CXInterpreter`](@ref).
"""
function clang_createInterpreterFromRawPtr(I)
    @ccall libCppInterOp.clang_createInterpreterFromRawPtr(I::TInterp_t)::CXInterpreter
end

"""
    clang_Interpreter_getClangInterpreter(I)

Returns a pointer to the underlying interpreter.
"""
function clang_Interpreter_getClangInterpreter(I)
    @ccall libCppInterOp.clang_Interpreter_getClangInterpreter(I::CXInterpreter)::Ptr{Cvoid}
end

"""
    clang_Interpreter_takeInterpreterAsPtr(I)

Returns a [`TInterp_t`](@ref) and takes the ownership.
"""
function clang_Interpreter_takeInterpreterAsPtr(I)
    @ccall libCppInterOp.clang_Interpreter_takeInterpreterAsPtr(I::CXInterpreter)::TInterp_t
end

"""
    clang_Interpreter_undo(I, N)

Undo N previous incremental inputs.
"""
function clang_Interpreter_undo(I, N)
    @ccall libCppInterOp.clang_Interpreter_undo(I::CXInterpreter, N::Cuint)::CXErrorCode
end

"""
    clang_Interpreter_dispose(I)

Dispose of the given interpreter context.
"""
function clang_Interpreter_dispose(I)
    @ccall libCppInterOp.clang_Interpreter_dispose(I::CXInterpreter)::Cvoid
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
    clang_Interpreter_addSearchPath(I, dir, isUser, prepend)

Add a search path to the interpreter.

# Arguments
* `I`: The interpreter.
* `dir`: The directory to add.
* `isUser`: Whether the directory is a user directory.
* `prepend`: Whether to prepend the directory to the search path.
"""
function clang_Interpreter_addSearchPath(I, dir, isUser, prepend)
    @ccall libCppInterOp.clang_Interpreter_addSearchPath(I::CXInterpreter, dir::Ptr{Cchar}, isUser::Bool, prepend::Bool)::Cvoid
end

"""
    clang_Interpreter_addIncludePath(I, dir)

Add an include path.

# Arguments
* `I`: The interpreter.
* `dir`: The directory to add.
"""
function clang_Interpreter_addIncludePath(I, dir)
    @ccall libCppInterOp.clang_Interpreter_addIncludePath(I::CXInterpreter, dir::Ptr{Cchar})::Cvoid
end

"""
    clang_Interpreter_declare(I, code, silent)

Declares a code snippet in `code` and does not execute it.

# Arguments
* `I`: The interpreter.
* `code`: The code snippet to declare.
* `silent`: Whether to suppress the diagnostics or not
# Returns
a [`CXErrorCode`](@ref).
"""
function clang_Interpreter_declare(I, code, silent)
    @ccall libCppInterOp.clang_Interpreter_declare(I::CXInterpreter, code::Ptr{Cchar}, silent::Bool)::CXErrorCode
end

"""
    clang_Interpreter_process(I, code)

Declares and executes a code snippet in `code`.

# Arguments
* `I`: The interpreter.
* `code`: The code snippet to execute.
# Returns
a [`CXErrorCode`](@ref).
"""
function clang_Interpreter_process(I, code)
    @ccall libCppInterOp.clang_Interpreter_process(I::CXInterpreter, code::Ptr{Cchar})::CXErrorCode
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
    clang_Value_dispose(V)

Dispose of the given [`CXValue`](@ref).

# Arguments
* `V`: The [`CXValue`](@ref) to dispose.
"""
function clang_Value_dispose(V)
    @ccall libCppInterOp.clang_Value_dispose(V::CXValue)::Cvoid
end

"""
    clang_Interpreter_evaluate(I, code, V)

Declares, executes and stores the execution result to `V`.

# Arguments
* `I`:\\[in\\] The interpreter.
* `code`:\\[in\\] The code snippet to evaluate.
* `V`:\\[out\\] The value to store the execution result.
# Returns
a [`CXErrorCode`](@ref).
"""
function clang_Interpreter_evaluate(I, code, V)
    @ccall libCppInterOp.clang_Interpreter_evaluate(I::CXInterpreter, code::Ptr{Cchar}, V::CXValue)::CXErrorCode
end

"""
    clang_Interpreter_lookupLibrary(I, lib_name)

Looks up the library if access is enabled.

# Arguments
* `I`: The interpreter.
* `lib_name`: The name of the library to lookup.
# Returns
the path to the library.
"""
function clang_Interpreter_lookupLibrary(I, lib_name)
    @ccall libCppInterOp.clang_Interpreter_lookupLibrary(I::CXInterpreter, lib_name::Ptr{Cchar})::CXString
end

"""
    clang_Interpreter_loadLibrary(I, lib_stem, lookup)

Finds `lib_stem` considering the list of search paths and loads it by calling dlopen.

# Arguments
* `I`: The interpreter.
* `lib_stem`: The stem of the library to load.
* `lookup`: Whether to lookup the library or not.
# Returns
a [`CXInterpreter_CompilationResult`](@ref).
"""
function clang_Interpreter_loadLibrary(I, lib_stem, lookup)
    @ccall libCppInterOp.clang_Interpreter_loadLibrary(I::CXInterpreter, lib_stem::Ptr{Cchar}, lookup::Bool)::CXInterpreter_CompilationResult
end

"""
    clang_Interpreter_unloadLibrary(I, lib_stem)

Finds `lib_stem` considering the list of search paths and unloads it by calling dlclose.

# Arguments
* `I`: The interpreter.
* `lib_stem`: The stem of the library to unload.
"""
function clang_Interpreter_unloadLibrary(I, lib_stem)
    @ccall libCppInterOp.clang_Interpreter_unloadLibrary(I::CXInterpreter, lib_stem::Ptr{Cchar})::Cvoid
end

"""
    CXScope

A fake CXCursor for working with the interpreter. It has the same structure as CXCursor, but unlike CXCursor, it stores a handle to the interpreter in the third slot of the data field. This pave the way for upstreaming features to the LLVM project.
"""
struct CXScope
    kind::CXCursorKind
    xdata::Cint
    data::NTuple{3, Ptr{Cvoid}}
end

function clang_scope_dump(S)
    @ccall libCppInterOp.clang_scope_dump(S::CXScope)::Cvoid
end

"""
    clang_hasDefaultConstructor(S)

Checks if a class has a default constructor.
"""
function clang_hasDefaultConstructor(S)
    @ccall libCppInterOp.clang_hasDefaultConstructor(S::CXScope)::Bool
end

"""
    clang_getDefaultConstructor(S)

Returns the default constructor of a class, if any.
"""
function clang_getDefaultConstructor(S)
    @ccall libCppInterOp.clang_getDefaultConstructor(S::CXScope)::CXScope
end

"""
    clang_getDestructor(S)

Returns the class destructor, if any.
"""
function clang_getDestructor(S)
    @ccall libCppInterOp.clang_getDestructor(S::CXScope)::CXScope
end

"""
    clang_getFunctionSignature(func)

Returns a stringified version of a given function signature in the form: void N::f(int i, double d, long l = 0, char ch = 'a').
"""
function clang_getFunctionSignature(func)
    @ccall libCppInterOp.clang_getFunctionSignature(func::CXScope)::CXString
end

"""
    clang_isTemplatedFunction(func)

Checks if a function is a templated function.
"""
function clang_isTemplatedFunction(func)
    @ccall libCppInterOp.clang_isTemplatedFunction(func::CXScope)::Bool
end

"""
    clang_existsFunctionTemplate(name, parent)

This function performs a lookup to check if there is a templated function of that type. `parent` is mandatory, the global scope should be used as the default value.
"""
function clang_existsFunctionTemplate(name, parent)
    @ccall libCppInterOp.clang_existsFunctionTemplate(name::Ptr{Cchar}, parent::CXScope)::Bool
end

struct CXTemplateArgInfo
    Type::Ptr{Cvoid}
    IntegralValue::Ptr{Cchar}
end

"""
    clang_instantiateTemplate(tmpl, template_args, template_args_size)

Builds a template instantiation for a given templated declaration. Offers a single interface for instantiation of class, function and variable templates.

# Arguments
* `tmpl`:\\[in\\] The uninstantiated template class/function.
* `template_args`:\\[in\\] The pointer to vector of template arguments stored in the `TemplateArgInfo` struct
* `template_args_size`:\\[in\\] The size of the vector of template arguments passed as `template_args`
# Returns
a [`CXScope`](@ref) representing the instantiated templated class/function/variable.
"""
function clang_instantiateTemplate(tmpl, template_args, template_args_size)
    @ccall libCppInterOp.clang_instantiateTemplate(tmpl::CXScope, template_args::Ptr{CXTemplateArgInfo}, template_args_size::Csize_t)::CXScope
end

"""
    CXQualType

A fake CXType for working with the interpreter. It has the same structure as CXType, but unlike CXType, it stores a handle to the interpreter in the second slot of the data field.
"""
struct CXQualType
    kind::CXTypeKind
    data::NTuple{2, Ptr{Cvoid}}
end

"""
    clang_getTypeAsString(type)

Gets the string of the type that is passed as a parameter.
"""
function clang_getTypeAsString(type)
    @ccall libCppInterOp.clang_getTypeAsString(type::CXQualType)::CXString
end

"""
    clang_getComplexType(eltype)

Returns the complex of the provided type.
"""
function clang_getComplexType(eltype)
    @ccall libCppInterOp.clang_getComplexType(eltype::CXQualType)::CXQualType
end

"""
An opaque pointer representing the object of a given type ([`CXScope`](@ref)).
"""
const CXObject = Ptr{Cvoid}

"""
    clang_allocate(n)

Allocates memory for the given type.
"""
function clang_allocate(n)
    @ccall libCppInterOp.clang_allocate(n::Cuint)::CXObject
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
    clang_invoke(func, result, args, n, self)

Creates a trampoline function and makes a call to a generic function or method.

# Arguments
* `func`: The function or method to call.
* `result`: The location where the return result will be placed.
* `args`: The arguments to pass to the invocation.
* `n`: The number of arguments.
* `self`: The 'this pointer' of the object.
"""
function clang_invoke(func, result, args, n, self)
    @ccall libCppInterOp.clang_invoke(func::CXScope, result::Ptr{Cvoid}, args::Ptr{Ptr{Cvoid}}, n::Csize_t, self::Ptr{Cvoid})::Cvoid
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

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
