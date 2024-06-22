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
    is_cxx && push!(args, "-xc++")
    clang_bin = joinpath(Clang_jll.artifact_dir, "bin", "clang")
    pushfirst!(args, clang_bin)  # Argv0
    return createInterpreter(args)
end

"""
    evaluate(x::AbstractInterpreter, code::AbstractString) -> Value
Evaluate a code snippet and return the result.

# Arguments
- `x::AbstractInterpreter`: The `Interpreter`.
- `code::AbstractString`: The code snippet to evaluate.
"""
function evaluate(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    v = createValue()
    res = clang_interpreter_evaluate(x, code, v)
    if res != CXEval_Success
        dispose(v)
        error("Failed to evaluate code snippet.")
    end
    return v
end
