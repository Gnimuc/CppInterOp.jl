import CppInterOp as Cpp
using Test

@testset "Interpreter Core" begin
    args = Cpp.get_compiler_flags()
    clang_bin = joinpath(Cpp.Clang_jll.artifact_dir, "bin", "clang")
    pushfirst!(args, clang_bin)
    push!(args, "-xc++")
    I = Cpp.createInterpreter(args)
    @test I.ptr != C_NULL

    julia_libdir = Sys.iswindows() ? Sys.BINDIR : joinpath(Sys.BINDIR, "..", "lib") |> normpath
    Cpp.addSearchPath(I, julia_libdir)
    @test Cpp.lookupLibrary(I, "libjulia") != ""
    # @test Cpp.loadLibrary(I, "libstdc++") == true
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

    s = Cpp.createValue()
    @test Cpp.evaluate(I, "jl_symbol_name(jl_get_ARCH())", s)
    @test Cpp.isManuallyAlloc(s) == false
    @test Cpp.getKind(s) == Cpp.CXValue_PtrOrObj
    @test Cpp.getPtr(s) != C_NULL
    @test unsafe_string(Base.unsafe_convert(Ptr{UInt8}, Cpp.getPtr(s))) == string(Sys.ARCH)
    Cpp.dispose(s)

    Cpp.dispose(I)
end
