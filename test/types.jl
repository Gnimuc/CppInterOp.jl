using CppInterOp
using CppInterOp: get_scope, get_type, isvalid
import CppInterOp as Cpp
using Test

@testset "Types" begin
    @testset "Conversion" begin
        I = create_interpreter()
        @test I.ptr != C_NULL

        @include I "$(@__DIR__)/include"

        declare(I, """#include "type.h" """)

        Foo = lookup(I, "Foo")
        @test isvalid(Foo)
        @test Foo == get_scope(get_type(Foo))

        FooTyDef = lookup(I, "FooTyDef")
        @test isvalid(FooTyDef)
        # typedefs is desugared to the actual type
        @test FooTyDef != get_scope(get_type(FooTyDef))
        @test Foo == get_scope(get_type(FooTyDef))

        # test build-in types
        int = get_type(I, "int")
        @test isvalid(BuiltinCint)
        @test Cpp.sizeof(int) == sizeof(Cint)

        dispose(I)
    end
end
