import CppInterOp as Cpp
using Test

@testset "Value" begin
    v = Cpp.createValue()
    @test v.ptr != C_NULL

    Cpp.dispose(v)
end
