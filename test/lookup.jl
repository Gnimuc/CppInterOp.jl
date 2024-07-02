using CppInterOp
using Test

@testset "Lookup" begin
    I = create_interpreter()
    @test I.ptr != C_NULL

    @include I "$(@__DIR__)/include"

    declare(I, """#include "scope.h" """)

    x = lookup(I, "outer::inner::FooC")
    @test CppInterOp.is_valid(x) == true
    @test CppInterOp.name(x) == "FooC"
    @test CppInterOp.fullname(x) == "outer::inner::FooC"

    dispose(I)
end
