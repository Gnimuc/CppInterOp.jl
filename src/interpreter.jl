"""
    create_interpreter(args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER) -> Interpreter
Create a C/C++ interpreter.

# Arguments
- `args::Vector{String}`: Additional compiler flags.
- `is_cxx::Bool`: Whether to use the C++ compiler build environment.
- `version::String`: The compiler version.
"""
function create_interpreter(args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER)
    default_args = get_compiler_flags(; is_cxx, version)
    is_cxx && push!(default_args, "-xc++")
    clang_bin = joinpath(Clang_jll.artifact_dir, "bin", "clang")
    pushfirst!(default_args, clang_bin)  # Argv0
    return createInterpreter([default_args..., args...])
end

"""
    evaluate(x::AbstractInterpreter, code::AbstractString)
Evaluate a code snippet and return the result.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `code::AbstractString`: The code snippet to evaluate.
"""
function evaluate(x::AbstractInterpreter, code::AbstractString)
    v = createValue()
    res = clang_interpreter_evaluate(x, code, v)
    if res == CXError_Success
        ret = get_value(CppValue(v))
        dispose(v)
        return ret
    end
    @error "Failed to evaluate code snippet."
    dispose(v)
    return nothing
end

"""
    undo(x::AbstractInterpreter, n::Integer=1)
Undo the last `n` steps.
"""
undo(x::AbstractInterpreter, n::Integer=1) = Undo(x, n) == CXError_Success

lookup_func(x::AbstractInterpreter, name::AbstractString) = getFunctionAddressFromMangledName(x, name)

macro include(I, path)
    quote
        addIncludePath($(esc(I)), $(esc(path)))
    end
end
