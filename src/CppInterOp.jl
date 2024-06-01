module CppInterOp

using Clang_jll
using libCppInterOp_jll
# using libCppInterOpExtra_jll

using Preferences

if has_preference(CppInterOp, "libCppInterOpExtra")
	const libCppInterOpExtra = load_preference(CppInterOp, "libCppInterOpExtra")
else
	if isdefined(libCppInterOpExtra_jll, :libCppInterOpExtra)
		import libCppInterOpExtra_jll: libCppInterOpExtra
	end
end

include("jllshim.jl")
using .JLLShim

const libdir = joinpath(@__DIR__, "..", "lib")

include(joinpath(libdir, "LibClang.jl"))

const llvm_version = string(Base.libllvm_version.major)

include(joinpath(libdir, llvm_version, "LibCppInterOp.jl"))
using .LibCppInterOp

include("platform/JLLEnvs.jl")
using .JLLEnvs

function create_interpreter(cpu_args=String[], gpu_args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER)
    env = JLLEnvs.get_default_env(; version, is_cxx)
    args = ["-isystem" * dir for dir in JLLEnvs.get_system_includes(env)]
    clang_inc = joinpath(Clang_jll.artifact_dir, "lib", "clang", llvm_version, "include")
    push!(args, "-isystem" * clang_inc)
    push!(args, "--target=$(JLLEnvs.target(env.platform))")
    is_cxx && push!(args, "-nostdinc++", "-nostdlib++")
    push!(args, "-nostdinc", "-nostdlib")
    append!(args, cpu_args)
    return CreateInterpreter(args, gpu_args)
end
export create_interpreter

include("utilities.jl")
include("version.jl")
include("core.jl")
include("api.jl")

end
