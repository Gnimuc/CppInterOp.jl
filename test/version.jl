using CppInterOp
using CppInterOp: GetVersion, llvm_version
using Test

@testset "Sanity Check" begin
    ver = GetVersion()
    @info "CppInterOp version: $ver"
    @test occursin(llvm_version, ver)
end
