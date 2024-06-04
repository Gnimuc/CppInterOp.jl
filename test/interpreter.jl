using CppInterOp
using Test

@testset "CppInterpreter" begin
    @testset "create_interpreter" begin
        itpr = create_interpreter()
        @test itpr.ptr != C_NULL
        @test itpr == get_current_interpreter()
    end
end
