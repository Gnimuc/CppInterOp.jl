using CppInterOp
using Test

@testset "Scope" begin
    @testset "lookup" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        @include I "$(@__DIR__)/include"

        declare(I, """#include "scope.h" """)

        x = lookup(I, "outer::inner::FooC")
        @test CppInterOp.is_valid(x) == true
        @test CppInterOp.getName(x) == "FooC"
        @test CppInterOp.getQualifiedName(x) == "outer::inner::FooC"

        dispose(I)
    end
end
