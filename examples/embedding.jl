import CppInterOp as Cpp

julia_include_dir = normpath(joinpath(Sys.BINDIR, "..", "include", "julia"))

Cpp.CreateInterpreter()

Cpp.EnableDebugOutput()

Cpp.AddIncludePath(julia_include_dir)

Cpp.Declare("""
#include "julia.h"
#include <iostream>
""")

Cpp.Process("""jl_init();""")

Cpp.Process("""jl_eval_string("println(sqrt(2.0))");""")

Cpp.Process("""
    jl_value_t *ret = jl_eval_string("sqrt(2.0)");

    if (jl_typeis(ret, jl_float64_type)) {
        double ret_unboxed = jl_unbox_float64(ret);
        std::cout << "sqrt(2.0) in C: " << ret_unboxed << std::endl;
    }
    else {
        std::cout << "ERROR: unexpected return type from sqrt(::Float64)" << std::endl;
    }
""")


const HELLO = String["hello", "world", "from", "Julia!"]

Cpp.Process("""
    jl_array_t *vec = (jl_array_t*)jl_get_global(jl_main_module, jl_symbol("HELLO"));
    jl_value_t **strs = (jl_value_t**)jl_array_data(vec, jl_value_t*);
    std::string str = "";
    for (int i = 0; i < jl_array_len(vec); i++) {
        std::cout << jl_string_ptr(strs[i]) << std::endl;
        const char* c_str = jl_string_ptr(strs[i]);
        std::string s = c_str;
        str += s + " ";
    }
    std::cout << str << std::endl;
""")
