import CppInterOp as Cpp
using Test

@testset "Invoke" begin
    I = Cpp.create_interpreter()
    @test I.ptr != C_NULL

    Cpp.declare(I, """#include <ctime>""")

    x = Cpp.lookup(I, "clock")
    @test Cpp.isvalid(x) == true
    @test Cpp.name(x) == "clock"
    @test Cpp.fullname(x) == "clock"

    clk = Cpp.create_cppcall(x)
    t1 = Cpp.evaluate(I, "clock()")
    result = Ref{Clong}(C_NULL)
    Cpp.invoke(clk, result)
    t = result[]
    t2 = Cpp.evaluate(I, "clock()")
    @test t1 < t < t2

    Cpp.dispose(clk)
    Cpp.dispose(I)
end
