using CppInterOp
using Test

@testset "Debug config" begin
    CppInterOp.EnableDebugOutput()
    @test CppInterOp.IsDebugOutputEnabled()
end
