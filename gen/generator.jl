using Clang.Generators
using Clang.Clang_jll
using libCppInterOp_jll

@add_def intptr_t

options = load_options(joinpath(@__DIR__, "option.toml"))

using Pkg: Pkg
import BinaryBuilderBase:
                          PkgSpec, Prefix, temp_prefix, setup_dependencies, cleanup_dependencies, destdir

const dependencies = PkgSpec[PkgSpec(; name="LLVM_full_jll")]

const libdir = joinpath(@__DIR__, "..", "lib")

cd(@__DIR__) do
    for (llvm_version, julia_version) in ((v"18.1.7", v"1.12"),)
        @info "Generating..." llvm_version julia_version
        temp_prefix() do prefix
            # let prefix = Prefix(mktempdir())
            platform = Pkg.BinaryPlatforms.HostPlatform()
            platform["llvm_version"] = string(llvm_version.major)
            platform["julia_version"] = string(julia_version)
            artifact_paths = setup_dependencies(prefix, dependencies, platform; verbose=true)

            let options = deepcopy(options)
                output_file_path = joinpath(libdir,
                                            string(llvm_version.major),
                                            options["general"]["output_file_path"])
                isdir(dirname(output_file_path)) || mkpath(dirname(output_file_path))
                options["general"]["output_file_path"] = output_file_path

                libclang_include_dir = joinpath(Clang_jll.artifact_dir, "include")
                # include_dir = joinpath(libCppInterOp_jll.artifact_dir, "include")
                include_dir = joinpath("/Users/gnimuc/.julia/dev/libCppInterOp_jll/override", "include")
                header_dir = joinpath(include_dir, "clang-c")
                args = Generators.get_default_args()
                push!(args, "-isystem$libclang_include_dir")
                push!(args, "-I$include_dir")

                headers = [joinpath(header_dir, x) for x in readdir(header_dir) if endswith(x, ".h")]
                ctx = create_context(headers, args, options)

                build!(ctx)
            end

            cleanup_dependencies(prefix, artifact_paths, platform)
        end
    end
end
