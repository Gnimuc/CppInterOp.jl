using CppInterOp
using Test

@testset "Interpreter" begin
    @testset "create_interpreter" begin
        I = create_interpreter()
        @test I.ptr != C_NULL
        dispose(I)
    end

    @testset "evaluate" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        @test process(I, "int x = 1 + 1;")
        @test evaluate(I, "x") === Cint(2)

        dispose(I)
    end

    @testset "undo" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        process(I, "int x = 1 + 1;")
        @test evaluate(I, "x") === Cint(2)
        @test undo(I, 2) == true

        process(I, "float x = 42.0;")
        @test evaluate(I, "x") === 42f0

        dispose(I)
    end
end
