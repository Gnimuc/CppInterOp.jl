"""
    abstract type AbstractInterpreter <: Any
Supertype for interpreters.
"""
abstract type AbstractInterpreter <: Any end

"""
    abstract type AbstractValue <: Any
Supertype for values.
"""
abstract type AbstractValue end

"""
    abstract type AbstractScope <: Any
Supertype for scopes.
"""
abstract type AbstractScope end

abstract type AbstractRecordScope <: AbstractScope end

"""
    abstract type AbstractType <: Any
Supertype for types.
"""
abstract type AbstractType end

"""
    abstract type AbstractObject <: Any
Supertype for objects.
"""
abstract type AbstractObject end
