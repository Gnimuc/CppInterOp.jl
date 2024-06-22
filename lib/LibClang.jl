"""
    CXErrorCode

Error codes returned by libclang routines.

Zero (`CXError_Success`) is the only error code indicating success. Other error codes, including not yet assigned non-zero values, indicate errors.

| Enumerator                 | Note                                                                                                                                              |
| :------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------ |
| CXError\\_Success          | No error.                                                                                                                                         |
| CXError\\_Failure          | A generic error code, no further details are available.  Errors of this kind can get their own specific error codes in future libclang versions.  |
| CXError\\_Crashed          | libclang crashed while performing the requested operation.                                                                                        |
| CXError\\_InvalidArguments | The function detected that the arguments violate the function contract.                                                                           |
| CXError\\_ASTReadError     | An AST deserialization error has occurred.                                                                                                        |
"""
@enum CXErrorCode::UInt32 begin
    CXError_Success = 0
    CXError_Failure = 1
    CXError_Crashed = 2
    CXError_InvalidArguments = 3
    CXError_ASTReadError = 4
end

"""
    CXTypeKind

Describes the kind of type

| Enumerator                                                    | Note                                                                                                                                           |
| :------------------------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| CXType\\_Invalid                                              | Represents an invalid type (e.g., where no type is available).                                                                                 |
| CXType\\_Unexposed                                            | A type whose specific kind is not exposed via this interface.                                                                                  |
| CXType\\_Void                                                 |                                                                                                                                                |
| CXType\\_Bool                                                 |                                                                                                                                                |
| CXType\\_Char\\_U                                             |                                                                                                                                                |
| CXType\\_UChar                                                |                                                                                                                                                |
| CXType\\_Char16                                               |                                                                                                                                                |
| CXType\\_Char32                                               |                                                                                                                                                |
| CXType\\_UShort                                               |                                                                                                                                                |
| CXType\\_UInt                                                 |                                                                                                                                                |
| CXType\\_ULong                                                |                                                                                                                                                |
| CXType\\_ULongLong                                            |                                                                                                                                                |
| CXType\\_UInt128                                              |                                                                                                                                                |
| CXType\\_Char\\_S                                             |                                                                                                                                                |
| CXType\\_SChar                                                |                                                                                                                                                |
| CXType\\_WChar                                                |                                                                                                                                                |
| CXType\\_Short                                                |                                                                                                                                                |
| CXType\\_Int                                                  |                                                                                                                                                |
| CXType\\_Long                                                 |                                                                                                                                                |
| CXType\\_LongLong                                             |                                                                                                                                                |
| CXType\\_Int128                                               |                                                                                                                                                |
| CXType\\_Float                                                |                                                                                                                                                |
| CXType\\_Double                                               |                                                                                                                                                |
| CXType\\_LongDouble                                           |                                                                                                                                                |
| CXType\\_NullPtr                                              |                                                                                                                                                |
| CXType\\_Overload                                             |                                                                                                                                                |
| CXType\\_Dependent                                            |                                                                                                                                                |
| CXType\\_ObjCId                                               |                                                                                                                                                |
| CXType\\_ObjCClass                                            |                                                                                                                                                |
| CXType\\_ObjCSel                                              |                                                                                                                                                |
| CXType\\_Float128                                             |                                                                                                                                                |
| CXType\\_Half                                                 |                                                                                                                                                |
| CXType\\_Float16                                              |                                                                                                                                                |
| CXType\\_ShortAccum                                           |                                                                                                                                                |
| CXType\\_Accum                                                |                                                                                                                                                |
| CXType\\_LongAccum                                            |                                                                                                                                                |
| CXType\\_UShortAccum                                          |                                                                                                                                                |
| CXType\\_UAccum                                               |                                                                                                                                                |
| CXType\\_ULongAccum                                           |                                                                                                                                                |
| CXType\\_BFloat16                                             |                                                                                                                                                |
| CXType\\_Ibm128                                               |                                                                                                                                                |
| CXType\\_Complex                                              |                                                                                                                                                |
| CXType\\_Pointer                                              |                                                                                                                                                |
| CXType\\_BlockPointer                                         |                                                                                                                                                |
| CXType\\_LValueReference                                      |                                                                                                                                                |
| CXType\\_RValueReference                                      |                                                                                                                                                |
| CXType\\_Record                                               |                                                                                                                                                |
| CXType\\_Enum                                                 |                                                                                                                                                |
| CXType\\_Typedef                                              |                                                                                                                                                |
| CXType\\_ObjCInterface                                        |                                                                                                                                                |
| CXType\\_ObjCObjectPointer                                    |                                                                                                                                                |
| CXType\\_FunctionNoProto                                      |                                                                                                                                                |
| CXType\\_FunctionProto                                        |                                                                                                                                                |
| CXType\\_ConstantArray                                        |                                                                                                                                                |
| CXType\\_Vector                                               |                                                                                                                                                |
| CXType\\_IncompleteArray                                      |                                                                                                                                                |
| CXType\\_VariableArray                                        |                                                                                                                                                |
| CXType\\_DependentSizedArray                                  |                                                                                                                                                |
| CXType\\_MemberPointer                                        |                                                                                                                                                |
| CXType\\_Auto                                                 |                                                                                                                                                |
| CXType\\_Elaborated                                           | Represents a type that was referred to using an elaborated type keyword.  E.g., struct S, or via a qualified name, e.g., N::M::type, or both.  |
| CXType\\_Pipe                                                 |                                                                                                                                                |
| CXType\\_OCLImage1dRO                                         |                                                                                                                                                |
| CXType\\_OCLImage1dArrayRO                                    |                                                                                                                                                |
| CXType\\_OCLImage1dBufferRO                                   |                                                                                                                                                |
| CXType\\_OCLImage2dRO                                         |                                                                                                                                                |
| CXType\\_OCLImage2dArrayRO                                    |                                                                                                                                                |
| CXType\\_OCLImage2dDepthRO                                    |                                                                                                                                                |
| CXType\\_OCLImage2dArrayDepthRO                               |                                                                                                                                                |
| CXType\\_OCLImage2dMSAARO                                     |                                                                                                                                                |
| CXType\\_OCLImage2dArrayMSAARO                                |                                                                                                                                                |
| CXType\\_OCLImage2dMSAADepthRO                                |                                                                                                                                                |
| CXType\\_OCLImage2dArrayMSAADepthRO                           |                                                                                                                                                |
| CXType\\_OCLImage3dRO                                         |                                                                                                                                                |
| CXType\\_OCLImage1dWO                                         |                                                                                                                                                |
| CXType\\_OCLImage1dArrayWO                                    |                                                                                                                                                |
| CXType\\_OCLImage1dBufferWO                                   |                                                                                                                                                |
| CXType\\_OCLImage2dWO                                         |                                                                                                                                                |
| CXType\\_OCLImage2dArrayWO                                    |                                                                                                                                                |
| CXType\\_OCLImage2dDepthWO                                    |                                                                                                                                                |
| CXType\\_OCLImage2dArrayDepthWO                               |                                                                                                                                                |
| CXType\\_OCLImage2dMSAAWO                                     |                                                                                                                                                |
| CXType\\_OCLImage2dArrayMSAAWO                                |                                                                                                                                                |
| CXType\\_OCLImage2dMSAADepthWO                                |                                                                                                                                                |
| CXType\\_OCLImage2dArrayMSAADepthWO                           |                                                                                                                                                |
| CXType\\_OCLImage3dWO                                         |                                                                                                                                                |
| CXType\\_OCLImage1dRW                                         |                                                                                                                                                |
| CXType\\_OCLImage1dArrayRW                                    |                                                                                                                                                |
| CXType\\_OCLImage1dBufferRW                                   |                                                                                                                                                |
| CXType\\_OCLImage2dRW                                         |                                                                                                                                                |
| CXType\\_OCLImage2dArrayRW                                    |                                                                                                                                                |
| CXType\\_OCLImage2dDepthRW                                    |                                                                                                                                                |
| CXType\\_OCLImage2dArrayDepthRW                               |                                                                                                                                                |
| CXType\\_OCLImage2dMSAARW                                     |                                                                                                                                                |
| CXType\\_OCLImage2dArrayMSAARW                                |                                                                                                                                                |
| CXType\\_OCLImage2dMSAADepthRW                                |                                                                                                                                                |
| CXType\\_OCLImage2dArrayMSAADepthRW                           |                                                                                                                                                |
| CXType\\_OCLImage3dRW                                         |                                                                                                                                                |
| CXType\\_OCLSampler                                           |                                                                                                                                                |
| CXType\\_OCLEvent                                             |                                                                                                                                                |
| CXType\\_OCLQueue                                             |                                                                                                                                                |
| CXType\\_OCLReserveID                                         |                                                                                                                                                |
| CXType\\_ObjCObject                                           |                                                                                                                                                |
| CXType\\_ObjCTypeParam                                        |                                                                                                                                                |
| CXType\\_Attributed                                           |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCMcePayload                        |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImePayload                        |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCRefPayload                        |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCSicPayload                        |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCMceResult                         |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeResult                         |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCRefResult                         |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCSicResult                         |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeResultSingleRefStreamout       |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeResultDualRefStreamout         |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeSingleRefStreamin              |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeDualRefStreamin                |                                                                                                                                                |
| CXType\\_ExtVector                                            |                                                                                                                                                |
| CXType\\_Atomic                                               |                                                                                                                                                |
| CXType\\_BTFTagAttributed                                     |                                                                                                                                                |
"""
@enum CXTypeKind::UInt32 begin
    CXType_Invalid = 0
    CXType_Unexposed = 1
    CXType_Void = 2
    CXType_Bool = 3
    CXType_Char_U = 4
    CXType_UChar = 5
    CXType_Char16 = 6
    CXType_Char32 = 7
    CXType_UShort = 8
    CXType_UInt = 9
    CXType_ULong = 10
    CXType_ULongLong = 11
    CXType_UInt128 = 12
    CXType_Char_S = 13
    CXType_SChar = 14
    CXType_WChar = 15
    CXType_Short = 16
    CXType_Int = 17
    CXType_Long = 18
    CXType_LongLong = 19
    CXType_Int128 = 20
    CXType_Float = 21
    CXType_Double = 22
    CXType_LongDouble = 23
    CXType_NullPtr = 24
    CXType_Overload = 25
    CXType_Dependent = 26
    CXType_ObjCId = 27
    CXType_ObjCClass = 28
    CXType_ObjCSel = 29
    CXType_Float128 = 30
    CXType_Half = 31
    CXType_Float16 = 32
    CXType_ShortAccum = 33
    CXType_Accum = 34
    CXType_LongAccum = 35
    CXType_UShortAccum = 36
    CXType_UAccum = 37
    CXType_ULongAccum = 38
    CXType_BFloat16 = 39
    CXType_Ibm128 = 40
    CXType_Complex = 100
    CXType_Pointer = 101
    CXType_BlockPointer = 102
    CXType_LValueReference = 103
    CXType_RValueReference = 104
    CXType_Record = 105
    CXType_Enum = 106
    CXType_Typedef = 107
    CXType_ObjCInterface = 108
    CXType_ObjCObjectPointer = 109
    CXType_FunctionNoProto = 110
    CXType_FunctionProto = 111
    CXType_ConstantArray = 112
    CXType_Vector = 113
    CXType_IncompleteArray = 114
    CXType_VariableArray = 115
    CXType_DependentSizedArray = 116
    CXType_MemberPointer = 117
    CXType_Auto = 118
    CXType_Elaborated = 119
    CXType_Pipe = 120
    CXType_OCLImage1dRO = 121
    CXType_OCLImage1dArrayRO = 122
    CXType_OCLImage1dBufferRO = 123
    CXType_OCLImage2dRO = 124
    CXType_OCLImage2dArrayRO = 125
    CXType_OCLImage2dDepthRO = 126
    CXType_OCLImage2dArrayDepthRO = 127
    CXType_OCLImage2dMSAARO = 128
    CXType_OCLImage2dArrayMSAARO = 129
    CXType_OCLImage2dMSAADepthRO = 130
    CXType_OCLImage2dArrayMSAADepthRO = 131
    CXType_OCLImage3dRO = 132
    CXType_OCLImage1dWO = 133
    CXType_OCLImage1dArrayWO = 134
    CXType_OCLImage1dBufferWO = 135
    CXType_OCLImage2dWO = 136
    CXType_OCLImage2dArrayWO = 137
    CXType_OCLImage2dDepthWO = 138
    CXType_OCLImage2dArrayDepthWO = 139
    CXType_OCLImage2dMSAAWO = 140
    CXType_OCLImage2dArrayMSAAWO = 141
    CXType_OCLImage2dMSAADepthWO = 142
    CXType_OCLImage2dArrayMSAADepthWO = 143
    CXType_OCLImage3dWO = 144
    CXType_OCLImage1dRW = 145
    CXType_OCLImage1dArrayRW = 146
    CXType_OCLImage1dBufferRW = 147
    CXType_OCLImage2dRW = 148
    CXType_OCLImage2dArrayRW = 149
    CXType_OCLImage2dDepthRW = 150
    CXType_OCLImage2dArrayDepthRW = 151
    CXType_OCLImage2dMSAARW = 152
    CXType_OCLImage2dArrayMSAARW = 153
    CXType_OCLImage2dMSAADepthRW = 154
    CXType_OCLImage2dArrayMSAADepthRW = 155
    CXType_OCLImage3dRW = 156
    CXType_OCLSampler = 157
    CXType_OCLEvent = 158
    CXType_OCLQueue = 159
    CXType_OCLReserveID = 160
    CXType_ObjCObject = 161
    CXType_ObjCTypeParam = 162
    CXType_Attributed = 163
    CXType_OCLIntelSubgroupAVCMcePayload = 164
    CXType_OCLIntelSubgroupAVCImePayload = 165
    CXType_OCLIntelSubgroupAVCRefPayload = 166
    CXType_OCLIntelSubgroupAVCSicPayload = 167
    CXType_OCLIntelSubgroupAVCMceResult = 168
    CXType_OCLIntelSubgroupAVCImeResult = 169
    CXType_OCLIntelSubgroupAVCRefResult = 170
    CXType_OCLIntelSubgroupAVCSicResult = 171
    CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout = 172
    CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout = 173
    CXType_OCLIntelSubgroupAVCImeSingleRefStreamin = 174
    CXType_OCLIntelSubgroupAVCImeDualRefStreamin = 175
    CXType_ExtVector = 176
    CXType_Atomic = 177
    CXType_BTFTagAttributed = 178
end

"""
    CXString

A character string.

The [`CXString`](@ref) type is used to return strings from the interface when the ownership of that string might differ from one call to the next. Use [`clang_getCString`](@ref)() to retrieve the string data and, once finished with the string data, call [`clang_disposeString`](@ref)() to free the string.
"""
struct CXString
    data::Ptr{Cvoid}
    private_flags::Cuint
end

struct CXStringSet
    Strings::Ptr{CXString}
    Count::Cuint
end

"""
    clang_getCString(string)

Retrieve the character data associated with the given string.
"""
function clang_getCString(string)
    @ccall libclang.clang_getCString(string::CXString)::Cstring
end

"""
    clang_disposeString(string)

Free the given string.
"""
function clang_disposeString(string)
    @ccall libclang.clang_disposeString(string::CXString)::Cvoid
end

"""
    clang_disposeStringSet(set)

Free the given string set.
"""
function clang_disposeStringSet(set)
    @ccall libclang.clang_disposeStringSet(set::Ptr{CXStringSet})::Cvoid
end

"""
    clang_toggleCrashRecovery(isEnabled)

Enable/disable crash recovery.

# Arguments
* `isEnabled`: Flag to indicate if crash recovery is enabled. A non-zero value enables crash recovery, while 0 disables it.
"""
function clang_toggleCrashRecovery(isEnabled)
    @ccall libclang.clang_toggleCrashRecovery(isEnabled::Cuint)::Cvoid
end
