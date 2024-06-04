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

include("interpreter.jl")
export create_interpreter, get_current_interpreter

include("utilities.jl")
include("version.jl")
include("core.jl")
include("api.jl")

end
