"""
    create_cppcall(x::AbstractFunctionScope) -> JitCall
Create a trampoline function for calling the C/C++ function/method.
"""
function create_cppcall(x::AbstractScope)
    @assert isvalid(x) "Invalid function scope: $x"
    return JitCall(clang_jitcall_create(x))
end

dispose(x::AbstractJitCall) = clang_jitcall_dispose(x)

function isvalid(x::AbstractJitCall)
    @check_ptrs x
    return clang_jitcall_isValid(x)
end

function invoke(x::AbstractJitCall, result, args=[], self=C_NULL)
    @check_ptrs x
    return clang_jitcall_invoke(x, result, args, length(args), self)
end
