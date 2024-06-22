import CppInterOp as Cpp
using Test

@testset "Interpreter" begin
    args = Cpp.get_compiler_flags()
    clang_bin = joinpath(Cpp.Clang_jll.artifact_dir, "bin", "clang")
    pushfirst!(args, clang_bin)
    push!(args, "-xc++")
    I = Cpp.createInterpreter(args)
    @test I.ptr != C_NULL

    @test Cpp.lookupLibrary(I, "libjulia") == ""

    julia_libdir = joinpath(Sys.BINDIR, "..", "lib") |> normpath
    Cpp.addSearchPath(I, julia_libdir)
    @test Cpp.lookupLibrary(I, "libjulia") != ""
    @test Cpp.loadLibrary(I, "libstdc++") == true
    # TODO: @test Cpp.unloadLibrary(I, "libstdc++")
    # TODO: @test Cpp.searchLibrariesForSymbol(I, "jl_init") != ""

    julia_incdir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath
    Cpp.addIncludePath(I, julia_incdir)

    @test Cpp.declare(I, "#include <julia.h>", false) == true

    @test Cpp.process(I, "jl_init()") == true

    v = Cpp.createValue()
    @test Cpp.evaluate(I, "jl_cpu_threads()", v)
    @test Cpp.isManuallyAlloc(v) == false
    @test Cpp.getKind(v) == Cpp.CXValue_Int
    Cpp.dispose(v)

    Cpp.dispose(I)
end
