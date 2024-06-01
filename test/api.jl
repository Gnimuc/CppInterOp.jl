import CppInterOp as Cpp
using Test

@testset "InterpreterTest" begin
    @testset "DebugFlag" begin
        Cpp.CreateInterpreter()
        @test Cpp.IsDebugOutputEnabled() == false
        @test_nowarn Cpp.Process("int a = 12;")

        Cpp.EnableDebugOutput()
        @test Cpp.IsDebugOutputEnabled() == true
        @test_nowarn Cpp.Process("int b = 12;")

        Cpp.EnableDebugOutput(false)
        @test Cpp.IsDebugOutputEnabled() == false
        @test_nowarn Cpp.Process("int c = 12;")
    end

    @testset "Evaluate" begin
        Cpp.CreateInterpreter()
        @test Cpp.Evaluate("__cplusplus") == 201402
        had_error = Ref{Bool}(false)
        @test Cpp.Evaluate("#error", had_error) != 0
        @test had_error[] == true

        @test Cpp.Evaluate("int i = 11; ++i", had_error) == 12
        @test had_error[] == false
    end

    @testset "Process" begin
        Cpp.CreateInterpreter()
        @test Cpp.Process("") == 0
        @test Cpp.Process("int a = 12;") == 0
        @test Cpp.Process("error_here;") != 0
        @test Cpp.Process("int f(); int res = f();") != 0
    end

    @testset "CreateInterpreter" begin
        itpr = Cpp.CreateInterpreter()
        @test itpr != C_NULL
        # Check if the default standard is c++14
        Cpp.Declare(
            """#if __cplusplus==201402L
                   int cpp14() { return 2014; }
               #else
                   void cppUnknown() {}
               #endif
            """)
        @test Cpp.GetNamed("cpp14") != Cpp.CppScope(C_NULL)
        @test Cpp.GetNamed("cppUnknown") == Cpp.CppScope(C_NULL)

        itpr = Cpp.CreateInterpreter(["-std=c++17"])
        @test itpr != C_NULL
        Cpp.Declare(
            """#if __cplusplus==201703L
                   int cpp17() { return 2017; }
               #else
                   void cppUnknown() {}
               #endif
            """)
        @test Cpp.GetNamed("cpp17") != Cpp.CppScope(C_NULL)
        @test Cpp.GetNamed("cppUnknown") == Cpp.CppScope(C_NULL)
    end

    @testset "GetResourceDir" begin
        @test endswith(normpath(Cpp.GetResourceDir()), normpath("lib/clang/$(Cpp.llvm_version)"))
    end
end
