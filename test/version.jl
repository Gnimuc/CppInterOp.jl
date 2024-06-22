import CppInterOp as Cpp
using Test

@testset "Sanity Check" begin
    ver = Cpp.GetVersion()
    @info "CppInterOp version: $ver"
    @test occursin(Cpp.llvm_version, ver)
end
