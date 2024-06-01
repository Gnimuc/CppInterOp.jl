using CppInterOp
import CppInterOp as Cpp

create_interpreter()

Cpp.EnableDebugOutput()

Cpp.Declare("""
#include <iostream>
#include <vector>
""")

Cpp.Process("""float x = 15000;""")
Cpp.Process("""float y = x >= 3.6 ? 3.6 : x;""")
Cpp.Process("""std::cout << y << ", not great, not terrible." << std::endl;""")
