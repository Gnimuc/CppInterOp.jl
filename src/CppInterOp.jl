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

# using libCppInterOpExtra_jll
if has_preference(CppInterOp, "libCppInterOpExtra")
    const libCppInterOpExtra = load_preference(CppInterOp, "libCppInterOpExtra")
else
    if isdefined(libCppInterOpExtra_jll, :libCppInterOpExtra)
        import libCppInterOpExtra_jll: libCppInterOpExtra
    end
end

libdir = joinpath(@__DIR__, "..", "lib")

include(joinpath(libdir, "LibClang.jl"))

llvm_ver = Base.libllvm_version.major

# const CLANG_BIN = joinpath(Clang_jll.artifact_dir, "bin", "clang")
# const CLANG_INC = joinpath(Clang_jll.artifact_dir, "lib", "clang", llvm_ver, "include")

include(joinpath(libdir, llvm_ver, "LibCppInterOp.jl"))
using .LibCppInterOp

include("utilities.jl")
include("version.jl")
include("core.jl")
include("api.jl")

end
