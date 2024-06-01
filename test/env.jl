using CppInterOp
import CppInterOp as Cpp
using Test

@testset "JLL Environment" begin
    create_interpreter()

    mktemp() do path, io
        redirect_stderr(io) do
            Cpp.Declare("""
                #include <iostream>
            """)
        end
        flush(io)
        s = read(path, String)
        @error s
        @test isempty(s)
    end

    mktemp() do path, io
        redirect_stdout(io) do
            Cpp.Process("""std::cout << "Hello World!" << std::endl;""")
        end
        flush(io)
        s = read(path, String)
        @test strip(s) == "Hello World!"
    end
end
