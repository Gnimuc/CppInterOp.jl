module CppInterOp

using Clang_jll

# if haskey(ENV, "LIBCPPINTEROP_INSTALL_PREFIX") &&
#    !isempty(get(ENV, "LIBCPPINTEROP_INSTALL_PREFIX", ""))
#     # DevMode
#     const __DLEXT = Base.BinaryPlatforms.platform_dlext()
#     const __ARTIFACT_BINDIR = Sys.iswindows() ? "bin" : "lib"

#     const libcppinterop = normpath(
#         joinpath(
#             ENV["LIBCPPINTEROP_INSTALL_PREFIX"],
#             __ARTIFACT_BINDIR,
#             "libclangCppInterOp.$__DLEXT",
#         ),
#     )
#     const libcppinterop_include =
#         normpath(joinpath(ENV["LIBCPPINTEROP_INSTALL_PREFIX"], "include"))
# else
#     # JLLMode
#     include("jllshim.jl")
#     using .JLLShim

#     using libcppinterop_jll
#     const libcppinterop_include =
#         normpath(joinpath(libcppinterop_jll.artifact_dir, "include"))
# end

using Preferences

# using CppInterOpExtra_jll
if has_preference(CppInterOp, "libCppInterOpExtra")
    const libCppInterOpExtra = load_preference(CppInterOp, "libCppInterOpExtra")
else
    if isdefined(CppInterOpExtra_jll, :libCppInterOpExtra)
        import CppInterOpExtra_jll: libCppInterOpExtra
    end
end

using LLVM

llvm_version = if LLVM.version().major <= 16
    error("Unsupported LLVM version: $(LLVM.version().major)")
elseif LLVM.version().major == 17
    "17"
elseif LLVM.version().major == 18
    "18"
else # LLVM.version().major == 19
    "19"
end

libdir = joinpath(@__DIR__, "..", "lib")

include(joinpath(libdir, "LibClang.jl"))

# const CLANG_BIN = joinpath(Clang_jll.artifact_dir, "bin", "clang")
# const CLANG_INC = joinpath(Clang_jll.artifact_dir, "lib", "clang", llvm_version, "include")

include(joinpath(libdir, llvm_version, "LibCppInterOp.jl"))
using .LibCppInterOp

include("utilities.jl")
include("version.jl")
include("core.jl")
include("api.jl")

end
