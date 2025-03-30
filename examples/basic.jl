import CppInterOp as Cpp

I = Cpp.create_interpreter()

Cpp.declare(I, """
#include <iostream>
#include <vector>
""")

Cpp.process(I, """float x = 15000;""")
Cpp.process(I, """float y = x >= 3.6 ? 3.6 : x;""")
Cpp.process(I, """std::cout << y << ", not great, not terrible." << std::endl;""")
