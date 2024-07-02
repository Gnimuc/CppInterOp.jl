using CppInterOp
using CppInterOp: get_scope, get_type, is_valid
import CppInterOp as Cpp
using Test

@testset "Types" begin
    @testset "Conversion" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        @include I "$(@__DIR__)/include"

        declare(I, """#include "type.h" """)

        Foo = lookup(I, "Foo")
        @test is_valid(Foo)
        @test Cpp.is_equal(Foo, get_scope(get_type(Foo)))

        FooTyDef = lookup(I, "FooTyDef")
        @test is_valid(FooTyDef)
        # typedefs is desugared to the actual type
        @test !Cpp.is_equal(FooTyDef, get_scope(get_type(FooTyDef)))
        @test Cpp.is_equal(Foo, get_scope(get_type(FooTyDef)))

        dispose(I)
    end

    @testset "sizeof" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        # build-in types
        int = get_type(I, "int")
        @test is_valid(int)
        @test Cpp.sizeof(int) == sizeof(Cint)

        dispose(I)
    end
end
