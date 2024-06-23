module CppInterOp

using Clang_jll
using libCppInterOp_jll
using libCppInterOpExtra_jll

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

include(joinpath(libdir, llvm_version, "LibCppInterOpExtra.jl"))
using .LibCppInterOpExtra

include("platform/JLLEnvs.jl")
using .JLLEnvs

# internal
include("utilities.jl")
include("core/core.jl")
include("api/api.jl")
# deprecated
include("extra.jl")

include("version.jl")

# public API
include("env.jl")
export get_compiler_flags

include("types.jl")
export cppconvert

include("interpreter.jl")
export create_interpreter, dispose
export declare, process, evaluate, undo

end
