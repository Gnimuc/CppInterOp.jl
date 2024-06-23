import CppInterOp as Cpp
using Test

@testset "Value" begin
    I = Cpp.create_interpreter()
    @test I.ptr != C_NULL

    julia_incdir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath
    Cpp.addIncludePath(I, julia_incdir)

    @test Cpp.declare(I, "#include <julia.h>", false) == true

    @test Cpp.process(I, "jl_init()") == true

    v = Cpp.createValue()
    @test Cpp.isValid(v) == false
    @test Cpp.evaluate(I, "jl_cpu_threads()", v)
    @test Cpp.isValid(v) == true
    @test Cpp.hasValue(v) == true
    @test Cpp.isVoid(v) == false
    @test Cpp.isManuallyAlloc(v) == false
    @test Cpp.getKind(v) == Cpp.CXValue_Int
    @test Cpp.getInt(v) == @ccall jl_cpu_threads()::Cint
    Cpp.dispose(v)
end
