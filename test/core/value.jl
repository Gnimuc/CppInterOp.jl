import CppInterOp as Cpp
using Test

@testset "Value Core" begin
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

@testset "Value Core | Decay" begin
    I = Cpp.create_interpreter()
    @test I.ptr != C_NULL

    Cpp.declare(I, "#include <vector>")
    Cpp.process(I, "std::vector<int> x = {1, 2, 3};")

    v_x = Cpp.createValue()
    @test Cpp.evaluate(I, "x", v_x)
    @test Cpp.hasValue(v_x) == true
    @test Cpp.isManuallyAlloc(v_x) == false
    @test Cpp.getKind(v_x) == Cpp.CXValue_PtrOrObj

    v_xptr = Cpp.createValue()
    @test Cpp.evaluate(I, "&x", v_xptr)
    @test Cpp.hasValue(v_xptr) == true
    @test Cpp.isManuallyAlloc(v_xptr) == false
    @test Cpp.getKind(v_xptr) == Cpp.CXValue_PtrOrObj

    # objects "decay" into pointers
    @test Cpp.getPtr(v_x) == Cpp.getPtr(v_xptr)

    Cpp.dispose(v_x)
    Cpp.dispose(v_xptr)
end
