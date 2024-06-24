#ifndef CPPINTEROP_SCOPE_H
#define CPPINTEROP_SCOPE_H

typedef int FooTyDef;

namespace outer {
    namespace inner {
        class FooC {
            struct FooS {};
        };
    }
}

#endif // CPPINTEROP_SCOPE_H