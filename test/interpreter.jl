using CppInterOp
using CppInterOp: create_interpreter, dispose, process, evaluate, undo, lookup_func
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
        @test evaluate(I, "x") === 42.0f0

        dispose(I)
    end

    @testset "function lookup" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        process(I, """extern "C" int foo() { return 42; }""")
        funcptr = lookup_func(I, "foo")
        @test funcptr != C_NULL
        @test ccall(funcptr, Cint, ()) === Cint(42)

        I2 = create_interpreter()
        @test I2.ptr != C_NULL
        process(I2, """extern "C" int foo() { return 42; }""")
        funcptr2 = lookup_func(I2, "foo")
        @test funcptr2 != C_NULL
        @test ccall(funcptr2, Cint, ()) === Cint(42)

        # this is obvious because they are compiled in different interpreters
        @test funcptr != funcptr2

        jlfuncptr = lookup_func(I, "jl_cpu_threads")
        @test jlfuncptr != C_NULL

        jlfuncptr2 = lookup_func(I2, "jl_cpu_threads")
        @test jlfuncptr2 != C_NULL

        # this is because they are from the same library
        @test jlfuncptr == jlfuncptr2

        dispose(I)
        dispose(I2)
    end
end
