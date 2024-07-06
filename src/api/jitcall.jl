"""
    create_cppcall(x::CXScope) -> CXJitCall
Create a trampoline function for calling the C/C++ function/method.
"""
function create_cppcall(x::CXScope)
    @assert is_valid(x) "Invalid function scope: $x"
    return clang_jitcall_create(x)
end

dispose(x::CXJitCall) = clang_jitcall_dispose(x)

function is_valid(x::CXJitCall)
    @assert CXJitCall != C_NULL
    return clang_jitcall_isValid(x)
end

function invoke(x::CXJitCall, result, args=[], self=C_NULL)
    @assert CXJitCall != C_NULL
    return clang_jitcall_invoke(x, result, args, length(args), self)
end
