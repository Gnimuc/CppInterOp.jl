using CppInterOp
using CppInterOp: get_scope, get_type, is_valid, @include
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
        @test Foo.data == get_scope(get_type(Foo)).data

        FooTyDef = lookup(I, "FooTyDef")
        @test is_valid(FooTyDef)
        # typedefs is desugared to the actual type
        @test FooTyDef.data != get_scope(get_type(FooTyDef)).data
        @test Foo.data == get_scope(get_type(FooTyDef)).data

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
