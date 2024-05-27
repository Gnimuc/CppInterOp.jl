using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using Git, Scratch, Dates

CppInterOp = Base.UUID("13f4c181-cae7-41d1-84d4-2ea5f5fafb15")

# get scratch directories
support_dir = get_scratch!(CppInterOp, "support")

# is this a full-fledged check-out?
# if isdir(joinpath(@__DIR__), "..", ".git")
#     # determine latest change to the wrappers
#     deps_timestamp = parse(Int, read(`$(git()) -C $(@__DIR__) log -1 --format=%ct CppInterOpExtra`, String))
#     @info "Latest change to the wrappers: $(unix2datetime(deps_timestamp))"

#     # find out which version of libCppInterOpExtra_jll we are using
#     Pkg.activate(joinpath(@__DIR__, ".."))
#     deps = collect(values(Pkg.dependencies()))
#     filter!(deps) do dep
#         dep.name == "libCppInterOpExtra_jll"
#     end
#     library_version = only(deps).version
#     @info "libCppInterOpExtra_jll version: $(library_version)"

#     # compare to the JLL's tags
#     jll_tags = mktempdir() do dir
#         if !isdir(joinpath(support_dir, ".git"))
#             run(`$(git()) clone -q https://github.com/JuliaBinaryWrappers/libCppInterOpExtra_jll.jl $dir`)
#         else
#             run(`$(git()) -C $dir fetch -q`)
#         end
#         tags = Dict{String,Int}()
#         for line in eachline(`$(git()) -C $dir tag --format "%(refname:short) %(creatordate:unix)"`)
#             tag, timestamp = split(line)
#             tags[tag] = parse(Int, timestamp)
#         end
#         tags
#     end
#     jll_timestamp = jll_tags["libCppInterOpExtra-v$(library_version)"]
#     @info "libCppInterOpExtra_jll timestamp: $(unix2datetime(jll_timestamp))"

#     if deps_timestamp > jll_timestamp
#         @info "Wrappers have changed since the last JLL build. Building the support library locally."
#         include(joinpath(@__DIR__, "build_local.jl"))
#     else
#         @info "Wrappers have not changed since the last JLL build. Using the JLL's support library."
#     end
# else
#     @warn """CppInterOp.jl source code is not checked-out from Git.
#              This means we cannot check for changes, and need to unconditionally build the support library."""
#     include(joinpath(@__DIR__, "build_local.jl"))
# end

include(joinpath(@__DIR__, "build_local.jl"))
