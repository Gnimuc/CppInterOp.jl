"""
	createInterpreter(args::Vector{String}) -> Interpreter
Create an `Interpreter` from a list of arguments.
"""
function createInterpreter(args::Vector{T}) where {T<:AbstractString}
    return Interpreter(clang_createInterpreter(args, length(args)))
end

dispose(x::Interpreter) = clang_Interpreter_dispose(x)

# get the raw pointer to the underlying `clang::Interpreter`
getptr(x::Interpreter) = clang_Interpreter_getClangInterpreter(x)

# get the raw pointer to the underlying interpreter(not `clang::Interpreter`) and take ownership
takeptr(x::Interpreter) = clang_Interpreter_takeInterpreterAsPtr(x)

is_valid(x::Interpreter) = x.ptr != C_NULL

"""
	createInterpreter(x::Ptr{Cvoid}) -> Interpreter
Create an `Interpreter` from a raw pointer and takes ownership.
"""
function createInterpreter(x)
    return Interpreter(clang_createInterpreterFromRawPtr(x))
end

"""
    addSearchPath(x::AbstractInterpreter, path::AbstractString, isUser::Bool=true, prepend::Bool=false)
Add a search path to the `Interpreter`.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `path::AbstractString`: The directory to add.
- `isUser::Bool=true`: Whether the directory is a user directory.
- `prepend::Bool=false`: Whether to prepend the directory.
"""
function addSearchPath(x::AbstractInterpreter, path::AbstractString, isUser::Bool=true, prepend::Bool=false)
    @check_ptrs x
    clang_Interpreter_addSearchPath(x, path, isUser, prepend)
end

"""
    addIncludePath(x::AbstractInterpreter, path::AbstractString)
Add an include path to the `Interpreter`.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `path::AbstractString`: The directory to add.
"""
function addIncludePath(x::AbstractInterpreter, path::AbstractString)
    @check_ptrs x
    clang_Interpreter_addIncludePath(x, path)
end

"""
    declare(x::AbstractInterpreter, code::AbstractString, silent::Bool=false) -> Bool
Declare a code snippet and does not execute it.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `code::AbstractString`: The code snippet to declare.
- `silent::Bool=false`: Whether to suppress output.
"""
function declare(x::AbstractInterpreter, code::AbstractString, silent::Bool=false)
    @check_ptrs x
    return clang_Interpreter_declare(x, code, silent) == CXError_Success
end

"""
    process(x::AbstractInterpreter, code::AbstractString) -> Bool
Declare and execute a code snippet.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `code::AbstractString`: The code snippet to process.
"""
function process(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    return clang_Interpreter_process(x, code) == CXError_Success
end

"""
    evaluate(x::AbstractInterpreter, code::AbstractString, v::AbstractValue) -> Bool
Declare and execute a code snippet, and store the execution result in `v`.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `code::AbstractString`: The code snippet to evaluate.
- `v::AbstractValue`: The result of the evaluation.
"""
function evaluate(x::AbstractInterpreter, code::AbstractString, v::AbstractValue)
    @check_ptrs x
    return clang_Interpreter_evaluate(x, code, v) == CXError_Success
end

"""
    lookupLibrary(x::AbstractInterpreter, lib_name::AbstractString) -> String
Look up the library if access is enabled. Return the path to the library.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `lib_name::AbstractString`: The name of the library to look up.
"""
function lookupLibrary(x::AbstractInterpreter, lib_name::AbstractString)
    @check_ptrs x
    cxstr = clang_Interpreter_lookupLibrary(x, lib_name)
    return get_string(cxstr)
end

"""
    loadLibrary(x::AbstractInterpreter, lib_stem::AbstractString, lookup::Bool=true) -> Bool
Finds `lib_stem` considering the list of search paths and loads it by calling dlopen.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `lib_stem::AbstractString`: The name of the library to load.
- `lookup::Bool=true`: Whether to look up the library.
"""
function loadLibrary(x::AbstractInterpreter, lib_stem::AbstractString, lookup::Bool=true)
    @check_ptrs x
    return clang_Interpreter_loadLibrary(x, lib_stem, lookup) == CXInterpreter_Success
end

"""
    unloadLibrary(x::AbstractInterpreter, lib_stem::AbstractString) -> Bool
Finds `lib_stem` considering the list of search paths and unloads it by calling dlclose.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `lib_stem::AbstractString`: The name of the library to unload.
"""
function unloadLibrary(x::AbstractInterpreter, lib_stem::AbstractString)
    @check_ptrs x
    return clang_Interpreter_unloadLibrary(x, lib_stem) == CXInterpreter_Success
end

# """
#     searchLibrariesForSymbol(x::AbstractInterpreter, symbol::AbstractString, search_system::Bool=true) -> String
# Scan all libraries on the library search path for a given potentially mangled symbol name.
# Return the path to the first library that contains the symbol definition.

# # Arguments
# - `x::AbstractInterpreter`: The `Interpreter`.
# - `symbol::AbstractString`: The mangled name to search for.
# - `search_system::Bool=true`: Whether to search the system library paths.
# """
# function searchLibrariesForSymbol(x::AbstractInterpreter, symbol::AbstractString, search_system::Bool=true)
#     @check_ptrs x
#     cxstr = clang_interpreter_searchLibrariesForSymbol(x, symbol, search_system)
#     return get_string(cxstr)
# end

"""
    Undo(x::AbstractInterpreter, n::Integer) -> Bool
Undo `n`` previous incremental inputs.
"""
function Undo(x::AbstractInterpreter, n::Integer)
    @check_ptrs x
    clang_Interpreter_undo(x, n)
end

# """
#     getFunctionAddressFromMangledName(x::AbstractInterpreter, name::AbstractString) -> Ptr{Cvoid}
# Find the address of a function by searching its mangled name.
# """
# function getFunctionAddressFromMangledName(x::AbstractInterpreter, name::AbstractString)
#     @check_ptrs x
#     return clang_interpreter_getFunctionAddressFromMangledName(x, name)
# end
