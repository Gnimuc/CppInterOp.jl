module JLLShim

using Preferences
using Clang_jll
using libCppInterOp_jll
# using libCppInterOpExtra_jll
using Libdl

import ..CppInterOp: libCppInterOpExtra

function __init__()
    if Clang_jll.libclang_cpp_handle == C_NULL
        global libclang_cpp_handle = Libdl.dlopen(Clang_jll.libclang_cpp_path, RTLD_LAZY | RTLD_DEEPBIND)
        global libCppInterOp_handle = Libdl.dlopen(libCppInterOp_jll.libCppInterOp_path, RTLD_LAZY | RTLD_DEEPBIND)
        if has_preference("CppInterOp", "libCppInterOpExtra")
            Libdl.dlopen(libCppInterOpExtra, RTLD_LAZY | RTLD_DEEPBIND)
        else
            global libCppInterOpExtra_handle = Libdl.dlopen(libCppInterOpExtra_jll.libCppInterOpExtra_path, RTLD_LAZY | RTLD_DEEPBIND)
        end
    end
end

end
