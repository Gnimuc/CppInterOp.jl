module JLLShim

using Clang_jll
using libcppinterop_jll
using Libdl

function __init__()
    if Clang_jll.libclang_cpp_handle == C_NULL
        global libclang_cpp_handle =
            Libdl.dlopen(Clang_jll.libclang_cpp_path, RTLD_LAZY | RTLD_DEEPBIND)
        global libcppinterop_handle =
            Libdl.dlopen(libcppinterop_jll.libcppinterop_path, RTLD_LAZY | RTLD_DEEPBIND)
    end
end

end
