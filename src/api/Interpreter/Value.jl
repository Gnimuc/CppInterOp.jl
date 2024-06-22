"""
	createValue() -> Value
Create a opaque pointer to `clang::Value`.
"""
createValue() = Value(clang_createValue())

dispose(x::Value) = clang_value_dispose(x)
