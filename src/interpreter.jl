"""
    create_interpreter(cpu_args=String[], gpu_args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER) -> CppInterpreter

Create a new C/C++ interpreter.

# Arguments
- `cpu_args::Vector{String}`: Additional arguments for the CPU compiler.
- `gpu_args::Vector{String}`: Additional arguments for the GPU compiler.
- `is_cxx::Bool`: Whether to use the C++ compiler build environment.
- `version::String`: The version of the C++ compiler build environment.
"""
function create_interpreter(cpu_args=String[], gpu_args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER)
    # Config the JLL build environment
    env = JLLEnvs.get_default_env(; version, is_cxx)
    args = ["-isystem" * dir for dir in JLLEnvs.get_system_includes(env)]
    clang_inc = joinpath(Clang_jll.artifact_dir, "lib", "clang", llvm_version, "include")
    push!(args, "-isystem" * clang_inc)
    push!(args, "--target=$(JLLEnvs.target(env.platform))")

    # Clean up default system includes
    is_cxx && push!(args, "-nostdinc++", "-nostdlib++")
    push!(args, "-nostdinc", "-nostdlib")

    # Add user-defined arguments
    append!(args, cpu_args)

    return CreateInterpreter(args, gpu_args)
end

"""
    get_current_interpreter() -> CppInterpreter

Return the current C/C++ interpreter.
"""
get_current_interpreter() = GetInterpreter()
