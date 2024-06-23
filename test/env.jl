import CppInterOp as Cpp
using Test

@testset "JLL Environment" begin
    I = Cpp.create_interpreter()

    mktemp() do path, io
        redirect_stderr(io) do
            Cpp.declare(I, """
                #include <iostream>
            """)
        end
        flush(io)
        s = read(path, String)
        @test isempty(s)
    end

    mktemp() do path, io
        redirect_stdout(io) do
            Cpp.process(I, """std::cout << "Hello World!" << std::endl;""")
        end
        flush(io)
        s = read(path, String)
        @test strip(s) == "Hello World!"
    end
end
