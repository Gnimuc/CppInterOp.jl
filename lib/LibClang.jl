using CEnum

const Ctime_t = Int

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
A compilation database holds all information used to compile files in a project. For each file in the database, it can be queried for the working directory or the command line used for the compiler invocation.

Must be freed by [`clang_CompilationDatabase_dispose`](@ref)
"""
const CXCompilationDatabase = Ptr{Cvoid}

"""
Contains the results of a search in the compilation database

When searching for the compile command for a file, the compilation db can return several commands, as the file may have been compiled with different options in different places of the project. This choice of compile commands is wrapped in this opaque data structure. It must be freed by [`clang_CompileCommands_dispose`](@ref).
"""
const CXCompileCommands = Ptr{Cvoid}

"""
Represents the command line invocation to compile a specific file.
"""
const CXCompileCommand = Ptr{Cvoid}

"""
    CXCompilationDatabase_Error

Error codes for Compilation Database
"""
@cenum CXCompilationDatabase_Error::UInt32 begin
    CXCompilationDatabase_NoError = 0
    CXCompilationDatabase_CanNotLoadDatabase = 1
end

"""
    clang_CompilationDatabase_fromDirectory(BuildDir, ErrorCode)

Creates a compilation database from the database found in directory buildDir. For example, CMake can output a compile\\_commands.json which can be used to build the database.

It must be freed by [`clang_CompilationDatabase_dispose`](@ref).
"""
function clang_CompilationDatabase_fromDirectory(BuildDir, ErrorCode)
    @ccall libclang.clang_CompilationDatabase_fromDirectory(BuildDir::Cstring, ErrorCode::Ptr{CXCompilationDatabase_Error})::CXCompilationDatabase
end

"""
    clang_CompilationDatabase_dispose(arg1)

Free the given compilation database
"""
function clang_CompilationDatabase_dispose(arg1)
    @ccall libclang.clang_CompilationDatabase_dispose(arg1::CXCompilationDatabase)::Cvoid
end

"""
    clang_CompilationDatabase_getCompileCommands(arg1, CompleteFileName)

Find the compile commands used for a file. The compile commands must be freed by [`clang_CompileCommands_dispose`](@ref).
"""
function clang_CompilationDatabase_getCompileCommands(arg1, CompleteFileName)
    @ccall libclang.clang_CompilationDatabase_getCompileCommands(arg1::CXCompilationDatabase, CompleteFileName::Cstring)::CXCompileCommands
end

"""
    clang_CompilationDatabase_getAllCompileCommands(arg1)

Get all the compile commands in the given compilation database.
"""
function clang_CompilationDatabase_getAllCompileCommands(arg1)
    @ccall libclang.clang_CompilationDatabase_getAllCompileCommands(arg1::CXCompilationDatabase)::CXCompileCommands
end

"""
    clang_CompileCommands_dispose(arg1)

Free the given CompileCommands
"""
function clang_CompileCommands_dispose(arg1)
    @ccall libclang.clang_CompileCommands_dispose(arg1::CXCompileCommands)::Cvoid
end

"""
    clang_CompileCommands_getSize(arg1)

Get the number of CompileCommand we have for a file
"""
function clang_CompileCommands_getSize(arg1)
    @ccall libclang.clang_CompileCommands_getSize(arg1::CXCompileCommands)::Cuint
end

"""
    clang_CompileCommands_getCommand(arg1, I)

Get the I'th CompileCommand for a file

Note : 0 <= i < [`clang_CompileCommands_getSize`](@ref)([`CXCompileCommands`](@ref))
"""
function clang_CompileCommands_getCommand(arg1, I)
    @ccall libclang.clang_CompileCommands_getCommand(arg1::CXCompileCommands, I::Cuint)::CXCompileCommand
end

"""
    clang_CompileCommand_getDirectory(arg1)

Get the working directory where the CompileCommand was executed from
"""
function clang_CompileCommand_getDirectory(arg1)
    @ccall libclang.clang_CompileCommand_getDirectory(arg1::CXCompileCommand)::CXString
end

"""
    clang_CompileCommand_getFilename(arg1)

Get the filename associated with the CompileCommand.
"""
function clang_CompileCommand_getFilename(arg1)
    @ccall libclang.clang_CompileCommand_getFilename(arg1::CXCompileCommand)::CXString
end

"""
    clang_CompileCommand_getNumArgs(arg1)

Get the number of arguments in the compiler invocation.
"""
function clang_CompileCommand_getNumArgs(arg1)
    @ccall libclang.clang_CompileCommand_getNumArgs(arg1::CXCompileCommand)::Cuint
end

"""
    clang_CompileCommand_getArg(arg1, I)

Get the I'th argument value in the compiler invocations

Invariant : - argument 0 is the compiler executable
"""
function clang_CompileCommand_getArg(arg1, I)
    @ccall libclang.clang_CompileCommand_getArg(arg1::CXCompileCommand, I::Cuint)::CXString
end

"""
    clang_CompileCommand_getNumMappedSources(arg1)

Get the number of source mappings for the compiler invocation.
"""
function clang_CompileCommand_getNumMappedSources(arg1)
    @ccall libclang.clang_CompileCommand_getNumMappedSources(arg1::CXCompileCommand)::Cuint
end

"""
    clang_CompileCommand_getMappedSourcePath(arg1, I)

Get the I'th mapped source path for the compiler invocation.
"""
function clang_CompileCommand_getMappedSourcePath(arg1, I)
    @warn "`clang_CompileCommand_getMappedSourcePath` Left here for backward compatibility.\nNo mapped sources exists in the C++ backend anymore.\nThis function just return Null `CXString`.\nSee:\n- [Remove unused CompilationDatabase::MappedSources](https://reviews.llvm.org/D32351)\n"
    @ccall libclang.clang_CompileCommand_getMappedSourcePath(arg1::CXCompileCommand, I::Cuint)::CXString
end

"""
    clang_CompileCommand_getMappedSourceContent(arg1, I)

Get the I'th mapped source content for the compiler invocation.
"""
function clang_CompileCommand_getMappedSourceContent(arg1, I)
    @warn "`clang_CompileCommand_getMappedSourceContent` Left here for backward compatibility.\nNo mapped sources exists in the C++ backend anymore.\nThis function just return Null `CXString`.\nSee:\n- [Remove unused CompilationDatabase::MappedSources](https://reviews.llvm.org/D32351)\n"
    @ccall libclang.clang_CompileCommand_getMappedSourceContent(arg1::CXCompileCommand, I::Cuint)::CXString
end

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
@cenum CXErrorCode::UInt32 begin
    CXError_Success = 0
    CXError_Failure = 1
    CXError_Crashed = 2
    CXError_InvalidArguments = 3
    CXError_ASTReadError = 4
end

"""
    clang_getBuildSessionTimestamp()

Return the timestamp for use with Clang's `-fbuild-session-timestamp=` option.
"""
function clang_getBuildSessionTimestamp()
    @ccall libclang.clang_getBuildSessionTimestamp()::Culonglong
end

mutable struct CXVirtualFileOverlayImpl end

"""
Object encapsulating information about overlaying virtual file/directories over the real file system.
"""
const CXVirtualFileOverlay = Ptr{CXVirtualFileOverlayImpl}

"""
    clang_VirtualFileOverlay_create(options)

Create a [`CXVirtualFileOverlay`](@ref) object. Must be disposed with [`clang_VirtualFileOverlay_dispose`](@ref)().

# Arguments
* `options`: is reserved, always pass 0.
"""
function clang_VirtualFileOverlay_create(options)
    @ccall libclang.clang_VirtualFileOverlay_create(options::Cuint)::CXVirtualFileOverlay
end

"""
    clang_VirtualFileOverlay_addFileMapping(arg1, virtualPath, realPath)

Map an absolute virtual file path to an absolute real one. The virtual path must be canonicalized (not contain "."/"..").

# Returns
0 for success, non-zero to indicate an error.
"""
function clang_VirtualFileOverlay_addFileMapping(arg1, virtualPath, realPath)
    @ccall libclang.clang_VirtualFileOverlay_addFileMapping(arg1::CXVirtualFileOverlay, virtualPath::Cstring, realPath::Cstring)::CXErrorCode
end

"""
    clang_VirtualFileOverlay_setCaseSensitivity(arg1, caseSensitive)

Set the case sensitivity for the [`CXVirtualFileOverlay`](@ref) object. The [`CXVirtualFileOverlay`](@ref) object is case-sensitive by default, this option can be used to override the default.

# Returns
0 for success, non-zero to indicate an error.
"""
function clang_VirtualFileOverlay_setCaseSensitivity(arg1, caseSensitive)
    @ccall libclang.clang_VirtualFileOverlay_setCaseSensitivity(arg1::CXVirtualFileOverlay, caseSensitive::Cint)::CXErrorCode
end

"""
    clang_VirtualFileOverlay_writeToBuffer(arg1, options, out_buffer_ptr, out_buffer_size)

Write out the [`CXVirtualFileOverlay`](@ref) object to a char buffer.

# Arguments
* `options`: is reserved, always pass 0.
* `out_buffer_ptr`: pointer to receive the buffer pointer, which should be disposed using [`clang_free`](@ref)().
* `out_buffer_size`: pointer to receive the buffer size.
# Returns
0 for success, non-zero to indicate an error.
"""
function clang_VirtualFileOverlay_writeToBuffer(arg1, options, out_buffer_ptr, out_buffer_size)
    @ccall libclang.clang_VirtualFileOverlay_writeToBuffer(arg1::CXVirtualFileOverlay, options::Cuint, out_buffer_ptr::Ptr{Cstring}, out_buffer_size::Ptr{Cuint})::CXErrorCode
end

"""
    clang_free(buffer)

free memory allocated by libclang, such as the buffer returned by [`CXVirtualFileOverlay`](@ref)() or [`clang_ModuleMapDescriptor_writeToBuffer`](@ref)().

# Arguments
* `buffer`: memory pointer to free.
"""
function clang_free(buffer)
    @ccall libclang.clang_free(buffer::Ptr{Cvoid})::Cvoid
end

"""
    clang_VirtualFileOverlay_dispose(arg1)

Dispose a [`CXVirtualFileOverlay`](@ref) object.
"""
function clang_VirtualFileOverlay_dispose(arg1)
    @ccall libclang.clang_VirtualFileOverlay_dispose(arg1::CXVirtualFileOverlay)::Cvoid
end

mutable struct CXModuleMapDescriptorImpl end

"""
Object encapsulating information about a module.modulemap file.
"""
const CXModuleMapDescriptor = Ptr{CXModuleMapDescriptorImpl}

"""
    clang_ModuleMapDescriptor_create(options)

Create a [`CXModuleMapDescriptor`](@ref) object. Must be disposed with [`clang_ModuleMapDescriptor_dispose`](@ref)().

# Arguments
* `options`: is reserved, always pass 0.
"""
function clang_ModuleMapDescriptor_create(options)
    @ccall libclang.clang_ModuleMapDescriptor_create(options::Cuint)::CXModuleMapDescriptor
end

"""
    clang_ModuleMapDescriptor_setFrameworkModuleName(arg1, name)

Sets the framework module name that the module.modulemap describes.

# Returns
0 for success, non-zero to indicate an error.
"""
function clang_ModuleMapDescriptor_setFrameworkModuleName(arg1, name)
    @ccall libclang.clang_ModuleMapDescriptor_setFrameworkModuleName(arg1::CXModuleMapDescriptor, name::Cstring)::CXErrorCode
end

"""
    clang_ModuleMapDescriptor_setUmbrellaHeader(arg1, name)

Sets the umbrella header name that the module.modulemap describes.

# Returns
0 for success, non-zero to indicate an error.
"""
function clang_ModuleMapDescriptor_setUmbrellaHeader(arg1, name)
    @ccall libclang.clang_ModuleMapDescriptor_setUmbrellaHeader(arg1::CXModuleMapDescriptor, name::Cstring)::CXErrorCode
end

"""
    clang_ModuleMapDescriptor_writeToBuffer(arg1, options, out_buffer_ptr, out_buffer_size)

Write out the [`CXModuleMapDescriptor`](@ref) object to a char buffer.

# Arguments
* `options`: is reserved, always pass 0.
* `out_buffer_ptr`: pointer to receive the buffer pointer, which should be disposed using [`clang_free`](@ref)().
* `out_buffer_size`: pointer to receive the buffer size.
# Returns
0 for success, non-zero to indicate an error.
"""
function clang_ModuleMapDescriptor_writeToBuffer(arg1, options, out_buffer_ptr, out_buffer_size)
    @ccall libclang.clang_ModuleMapDescriptor_writeToBuffer(arg1::CXModuleMapDescriptor, options::Cuint, out_buffer_ptr::Ptr{Cstring}, out_buffer_size::Ptr{Cuint})::CXErrorCode
end

"""
    clang_ModuleMapDescriptor_dispose(arg1)

Dispose a [`CXModuleMapDescriptor`](@ref) object.
"""
function clang_ModuleMapDescriptor_dispose(arg1)
    @ccall libclang.clang_ModuleMapDescriptor_dispose(arg1::CXModuleMapDescriptor)::Cvoid
end

"""
A particular source file that is part of a translation unit.
"""
const CXFile = Ptr{Cvoid}

"""
    clang_getFileName(SFile)

Retrieve the complete file and path name of the given file.
"""
function clang_getFileName(SFile)
    @ccall libclang.clang_getFileName(SFile::CXFile)::CXString
end

"""
    clang_getFileTime(SFile)

Retrieve the last modification time of the given file.
"""
function clang_getFileTime(SFile)
    @ccall libclang.clang_getFileTime(SFile::CXFile)::Ctime_t
end

"""
    CXFileUniqueID

Uniquely identifies a [`CXFile`](@ref), that refers to the same underlying file, across an indexing session.
"""
struct CXFileUniqueID
    data::NTuple{3, Culonglong}
end

"""
    clang_getFileUniqueID(file, outID)

Retrieve the unique ID for the given `file`.

# Arguments
* `file`: the file to get the ID for.
* `outID`: stores the returned [`CXFileUniqueID`](@ref).
# Returns
If there was a failure getting the unique ID, returns non-zero, otherwise returns 0.
"""
function clang_getFileUniqueID(file, outID)
    @ccall libclang.clang_getFileUniqueID(file::CXFile, outID::Ptr{CXFileUniqueID})::Cint
end

"""
    clang_File_isEqual(file1, file2)

Returns non-zero if the `file1` and `file2` point to the same file, or they are both NULL.
"""
function clang_File_isEqual(file1, file2)
    @ccall libclang.clang_File_isEqual(file1::CXFile, file2::CXFile)::Cint
end

"""
    clang_File_tryGetRealPathName(file)

Returns the real path name of `file`.

An empty string may be returned. Use [`clang_getFileName`](@ref)() in that case.
"""
function clang_File_tryGetRealPathName(file)
    @ccall libclang.clang_File_tryGetRealPathName(file::CXFile)::CXString
end

"""
    CXSourceLocation

Identifies a specific source location within a translation unit.

Use [`clang_getExpansionLocation`](@ref)() or [`clang_getSpellingLocation`](@ref)() to map a source location to a particular file, line, and column.
"""
struct CXSourceLocation
    ptr_data::NTuple{2, Ptr{Cvoid}}
    int_data::Cuint
end

"""
    CXSourceRange

Identifies a half-open character range in the source code.

Use [`clang_getRangeStart`](@ref)() and [`clang_getRangeEnd`](@ref)() to retrieve the starting and end locations from a source range, respectively.
"""
struct CXSourceRange
    ptr_data::NTuple{2, Ptr{Cvoid}}
    begin_int_data::Cuint
    end_int_data::Cuint
end

"""
    clang_getNullLocation()

Retrieve a NULL (invalid) source location.
"""
function clang_getNullLocation()
    @ccall libclang.clang_getNullLocation()::CXSourceLocation
end

"""
    clang_equalLocations(loc1, loc2)

Determine whether two source locations, which must refer into the same translation unit, refer to exactly the same point in the source code.

# Returns
non-zero if the source locations refer to the same location, zero if they refer to different locations.
"""
function clang_equalLocations(loc1, loc2)
    @ccall libclang.clang_equalLocations(loc1::CXSourceLocation, loc2::CXSourceLocation)::Cuint
end

"""
    clang_Location_isInSystemHeader(location)

Returns non-zero if the given source location is in a system header.
"""
function clang_Location_isInSystemHeader(location)
    @ccall libclang.clang_Location_isInSystemHeader(location::CXSourceLocation)::Cint
end

"""
    clang_Location_isFromMainFile(location)

Returns non-zero if the given source location is in the main file of the corresponding translation unit.
"""
function clang_Location_isFromMainFile(location)
    @ccall libclang.clang_Location_isFromMainFile(location::CXSourceLocation)::Cint
end

"""
    clang_getNullRange()

Retrieve a NULL (invalid) source range.
"""
function clang_getNullRange()
    @ccall libclang.clang_getNullRange()::CXSourceRange
end

"""
    clang_getRange(_begin, _end)

Retrieve a source range given the beginning and ending source locations.
"""
function clang_getRange(_begin, _end)
    @ccall libclang.clang_getRange(_begin::CXSourceLocation, _end::CXSourceLocation)::CXSourceRange
end

"""
    clang_equalRanges(range1, range2)

Determine whether two ranges are equivalent.

# Returns
non-zero if the ranges are the same, zero if they differ.
"""
function clang_equalRanges(range1, range2)
    @ccall libclang.clang_equalRanges(range1::CXSourceRange, range2::CXSourceRange)::Cuint
end

"""
    clang_Range_isNull(range)

Returns non-zero if `range` is null.
"""
function clang_Range_isNull(range)
    @ccall libclang.clang_Range_isNull(range::CXSourceRange)::Cint
end

"""
    clang_getExpansionLocation(location, file, line, column, offset)

Retrieve the file, line, column, and offset represented by the given source location.

If the location refers into a macro expansion, retrieves the location of the macro expansion.

# Arguments
* `location`: the location within a source file that will be decomposed into its parts.
* `file`: [out] if non-NULL, will be set to the file to which the given source location points.
* `line`: [out] if non-NULL, will be set to the line to which the given source location points.
* `column`: [out] if non-NULL, will be set to the column to which the given source location points.
* `offset`: [out] if non-NULL, will be set to the offset into the buffer to which the given source location points.
"""
function clang_getExpansionLocation(location, file, line, column, offset)
    @ccall libclang.clang_getExpansionLocation(location::CXSourceLocation, file::Ptr{CXFile}, line::Ptr{Cuint}, column::Ptr{Cuint}, offset::Ptr{Cuint})::Cvoid
end

"""
    clang_getPresumedLocation(location, filename, line, column)

Retrieve the file, line and column represented by the given source location, as specified in a # line directive.

Example: given the following source code in a file somefile.c

```c++
 #123 "dummy.c" 1
 static int func(void)
 {
     return 0;
 }
```

the location information returned by this function would be

File: dummy.c Line: 124 Column: 12

whereas [`clang_getExpansionLocation`](@ref) would have returned

File: somefile.c Line: 3 Column: 12

# Arguments
* `location`: the location within a source file that will be decomposed into its parts.
* `filename`: [out] if non-NULL, will be set to the filename of the source location. Note that filenames returned will be for "virtual" files, which don't necessarily exist on the machine running clang - e.g. when parsing preprocessed output obtained from a different environment. If a non-NULL value is passed in, remember to dispose of the returned value using [`clang_disposeString`](@ref)() once you've finished with it. For an invalid source location, an empty string is returned.
* `line`: [out] if non-NULL, will be set to the line number of the source location. For an invalid source location, zero is returned.
* `column`: [out] if non-NULL, will be set to the column number of the source location. For an invalid source location, zero is returned.
"""
function clang_getPresumedLocation(location, filename, line, column)
    @ccall libclang.clang_getPresumedLocation(location::CXSourceLocation, filename::Ptr{CXString}, line::Ptr{Cuint}, column::Ptr{Cuint})::Cvoid
end

"""
    clang_getInstantiationLocation(location, file, line, column, offset)

Legacy API to retrieve the file, line, column, and offset represented by the given source location.

This interface has been replaced by the newer interface #[`clang_getExpansionLocation`](@ref)(). See that interface's documentation for details.
"""
function clang_getInstantiationLocation(location, file, line, column, offset)
    @ccall libclang.clang_getInstantiationLocation(location::CXSourceLocation, file::Ptr{CXFile}, line::Ptr{Cuint}, column::Ptr{Cuint}, offset::Ptr{Cuint})::Cvoid
end

"""
    clang_getSpellingLocation(location, file, line, column, offset)

Retrieve the file, line, column, and offset represented by the given source location.

If the location refers into a macro instantiation, return where the location was originally spelled in the source file.

# Arguments
* `location`: the location within a source file that will be decomposed into its parts.
* `file`: [out] if non-NULL, will be set to the file to which the given source location points.
* `line`: [out] if non-NULL, will be set to the line to which the given source location points.
* `column`: [out] if non-NULL, will be set to the column to which the given source location points.
* `offset`: [out] if non-NULL, will be set to the offset into the buffer to which the given source location points.
"""
function clang_getSpellingLocation(location, file, line, column, offset)
    @ccall libclang.clang_getSpellingLocation(location::CXSourceLocation, file::Ptr{CXFile}, line::Ptr{Cuint}, column::Ptr{Cuint}, offset::Ptr{Cuint})::Cvoid
end

"""
    clang_getFileLocation(location, file, line, column, offset)

Retrieve the file, line, column, and offset represented by the given source location.

If the location refers into a macro expansion, return where the macro was expanded or where the macro argument was written, if the location points at a macro argument.

# Arguments
* `location`: the location within a source file that will be decomposed into its parts.
* `file`: [out] if non-NULL, will be set to the file to which the given source location points.
* `line`: [out] if non-NULL, will be set to the line to which the given source location points.
* `column`: [out] if non-NULL, will be set to the column to which the given source location points.
* `offset`: [out] if non-NULL, will be set to the offset into the buffer to which the given source location points.
"""
function clang_getFileLocation(location, file, line, column, offset)
    @ccall libclang.clang_getFileLocation(location::CXSourceLocation, file::Ptr{CXFile}, line::Ptr{Cuint}, column::Ptr{Cuint}, offset::Ptr{Cuint})::Cvoid
end

"""
    clang_getRangeStart(range)

Retrieve a source location representing the first character within a source range.
"""
function clang_getRangeStart(range)
    @ccall libclang.clang_getRangeStart(range::CXSourceRange)::CXSourceLocation
end

"""
    clang_getRangeEnd(range)

Retrieve a source location representing the last character within a source range.
"""
function clang_getRangeEnd(range)
    @ccall libclang.clang_getRangeEnd(range::CXSourceRange)::CXSourceLocation
end

"""
    CXSourceRangeList

Identifies an array of ranges.

| Field  | Note                                         |
| :----- | :------------------------------------------- |
| count  | The number of ranges in the `ranges` array.  |
| ranges | An array of `CXSourceRanges`.                |
"""
struct CXSourceRangeList
    count::Cuint
    ranges::Ptr{CXSourceRange}
end

"""
    clang_disposeSourceRangeList(ranges)

Destroy the given [`CXSourceRangeList`](@ref).
"""
function clang_disposeSourceRangeList(ranges)
    @ccall libclang.clang_disposeSourceRangeList(ranges::Ptr{CXSourceRangeList})::Cvoid
end

"""
    CXDiagnosticSeverity

Describes the severity of a particular diagnostic.

| Enumerator             | Note                                                                                                                           |
| :--------------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| CXDiagnostic\\_Ignored | A diagnostic that has been suppressed, e.g., by a command-line option.                                                         |
| CXDiagnostic\\_Note    | This diagnostic is a note that should be attached to the previous (non-note) diagnostic.                                       |
| CXDiagnostic\\_Warning | This diagnostic indicates suspicious code that may not be wrong.                                                               |
| CXDiagnostic\\_Error   | This diagnostic indicates that the code is ill-formed.                                                                         |
| CXDiagnostic\\_Fatal   | This diagnostic indicates that the code is ill-formed such that future parser recovery is unlikely to produce useful results.  |
"""
@cenum CXDiagnosticSeverity::UInt32 begin
    CXDiagnostic_Ignored = 0
    CXDiagnostic_Note = 1
    CXDiagnostic_Warning = 2
    CXDiagnostic_Error = 3
    CXDiagnostic_Fatal = 4
end

"""
A single diagnostic, containing the diagnostic's severity, location, text, source ranges, and fix-it hints.
"""
const CXDiagnostic = Ptr{Cvoid}

"""
A group of CXDiagnostics.
"""
const CXDiagnosticSet = Ptr{Cvoid}

"""
    clang_getNumDiagnosticsInSet(Diags)

Determine the number of diagnostics in a [`CXDiagnosticSet`](@ref).
"""
function clang_getNumDiagnosticsInSet(Diags)
    @ccall libclang.clang_getNumDiagnosticsInSet(Diags::CXDiagnosticSet)::Cuint
end

"""
    clang_getDiagnosticInSet(Diags, Index)

Retrieve a diagnostic associated with the given [`CXDiagnosticSet`](@ref).

# Arguments
* `Diags`: the [`CXDiagnosticSet`](@ref) to query.
* `Index`: the zero-based diagnostic number to retrieve.
# Returns
the requested diagnostic. This diagnostic must be freed via a call to [`clang_disposeDiagnostic`](@ref)().
"""
function clang_getDiagnosticInSet(Diags, Index)
    @ccall libclang.clang_getDiagnosticInSet(Diags::CXDiagnosticSet, Index::Cuint)::CXDiagnostic
end

"""
    CXLoadDiag_Error

Describes the kind of error that occurred (if any) in a call to [`clang_loadDiagnostics`](@ref).

| Enumerator               | Note                                                                                   |
| :----------------------- | :------------------------------------------------------------------------------------- |
| CXLoadDiag\\_None        | Indicates that no error occurred.                                                      |
| CXLoadDiag\\_Unknown     | Indicates that an unknown error occurred while attempting to deserialize diagnostics.  |
| CXLoadDiag\\_CannotLoad  | Indicates that the file containing the serialized diagnostics could not be opened.     |
| CXLoadDiag\\_InvalidFile | Indicates that the serialized diagnostics file is invalid or corrupt.                  |
"""
@cenum CXLoadDiag_Error::UInt32 begin
    CXLoadDiag_None = 0
    CXLoadDiag_Unknown = 1
    CXLoadDiag_CannotLoad = 2
    CXLoadDiag_InvalidFile = 3
end

"""
    clang_loadDiagnostics(file, error, errorString)

Deserialize a set of diagnostics from a Clang diagnostics bitcode file.

# Arguments
* `file`: The name of the file to deserialize.
* `error`: A pointer to a enum value recording if there was a problem deserializing the diagnostics.
* `errorString`: A pointer to a [`CXString`](@ref) for recording the error string if the file was not successfully loaded.
# Returns
A loaded [`CXDiagnosticSet`](@ref) if successful, and NULL otherwise. These diagnostics should be released using [`clang_disposeDiagnosticSet`](@ref)().
"""
function clang_loadDiagnostics(file, error, errorString)
    @ccall libclang.clang_loadDiagnostics(file::Cstring, error::Ptr{CXLoadDiag_Error}, errorString::Ptr{CXString})::CXDiagnosticSet
end

"""
    clang_disposeDiagnosticSet(Diags)

Release a [`CXDiagnosticSet`](@ref) and all of its contained diagnostics.
"""
function clang_disposeDiagnosticSet(Diags)
    @ccall libclang.clang_disposeDiagnosticSet(Diags::CXDiagnosticSet)::Cvoid
end

"""
    clang_getChildDiagnostics(D)

Retrieve the child diagnostics of a [`CXDiagnostic`](@ref).

This [`CXDiagnosticSet`](@ref) does not need to be released by [`clang_disposeDiagnosticSet`](@ref).
"""
function clang_getChildDiagnostics(D)
    @ccall libclang.clang_getChildDiagnostics(D::CXDiagnostic)::CXDiagnosticSet
end

"""
    clang_disposeDiagnostic(Diagnostic)

Destroy a diagnostic.
"""
function clang_disposeDiagnostic(Diagnostic)
    @ccall libclang.clang_disposeDiagnostic(Diagnostic::CXDiagnostic)::Cvoid
end

"""
    CXDiagnosticDisplayOptions

Options to control the display of diagnostics.

The values in this enum are meant to be combined to customize the behavior of [`clang_formatDiagnostic`](@ref)().

| Enumerator                           | Note                                                                                                                                                                                                                                                                                                                                                     |
| :----------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXDiagnostic\\_DisplaySourceLocation | Display the source-location information where the diagnostic was located.  When set, diagnostics will be prefixed by the file, line, and (optionally) column to which the diagnostic refers. For example,  ```c++  test.c:28: warning: extra tokens at end of #endif directive ```  This option corresponds to the clang flag `-fshow-source-location.`  |
| CXDiagnostic\\_DisplayColumn         | If displaying the source-location information of the diagnostic, also include the column number.  This option corresponds to the clang flag `-fshow-column.`                                                                                                                                                                                             |
| CXDiagnostic\\_DisplaySourceRanges   | If displaying the source-location information of the diagnostic, also include information about source ranges in a machine-parsable format.  This option corresponds to the clang flag `-fdiagnostics-print-source-range-info.`                                                                                                                          |
| CXDiagnostic\\_DisplayOption         | Display the option name associated with this diagnostic, if any.  The option name displayed (e.g., -Wconversion) will be placed in brackets after the diagnostic text. This option corresponds to the clang flag `-fdiagnostics-show-option.`                                                                                                            |
| CXDiagnostic\\_DisplayCategoryId     | Display the category number associated with this diagnostic, if any.  The category number is displayed within brackets after the diagnostic text. This option corresponds to the clang flag `-fdiagnostics-show-category=id.`                                                                                                                            |
| CXDiagnostic\\_DisplayCategoryName   | Display the category name associated with this diagnostic, if any.  The category name is displayed within brackets after the diagnostic text. This option corresponds to the clang flag `-fdiagnostics-show-category=name.`                                                                                                                              |
"""
@cenum CXDiagnosticDisplayOptions::UInt32 begin
    CXDiagnostic_DisplaySourceLocation = 1
    CXDiagnostic_DisplayColumn = 2
    CXDiagnostic_DisplaySourceRanges = 4
    CXDiagnostic_DisplayOption = 8
    CXDiagnostic_DisplayCategoryId = 16
    CXDiagnostic_DisplayCategoryName = 32
end

"""
    clang_formatDiagnostic(Diagnostic, Options)

Format the given diagnostic in a manner that is suitable for display.

This routine will format the given diagnostic to a string, rendering the diagnostic according to the various options given. The [`clang_defaultDiagnosticDisplayOptions`](@ref)() function returns the set of options that most closely mimics the behavior of the clang compiler.

# Arguments
* `Diagnostic`: The diagnostic to print.
* `Options`: A set of options that control the diagnostic display, created by combining [`CXDiagnosticDisplayOptions`](@ref) values.
# Returns
A new string containing for formatted diagnostic.
"""
function clang_formatDiagnostic(Diagnostic, Options)
    @ccall libclang.clang_formatDiagnostic(Diagnostic::CXDiagnostic, Options::Cuint)::CXString
end

"""
    clang_defaultDiagnosticDisplayOptions()

Retrieve the set of display options most similar to the default behavior of the clang compiler.

# Returns
A set of display options suitable for use with [`clang_formatDiagnostic`](@ref)().
"""
function clang_defaultDiagnosticDisplayOptions()
    @ccall libclang.clang_defaultDiagnosticDisplayOptions()::Cuint
end

"""
    clang_getDiagnosticSeverity(arg1)

Determine the severity of the given diagnostic.
"""
function clang_getDiagnosticSeverity(arg1)
    @ccall libclang.clang_getDiagnosticSeverity(arg1::CXDiagnostic)::CXDiagnosticSeverity
end

"""
    clang_getDiagnosticLocation(arg1)

Retrieve the source location of the given diagnostic.

This location is where Clang would print the caret ('^') when displaying the diagnostic on the command line.
"""
function clang_getDiagnosticLocation(arg1)
    @ccall libclang.clang_getDiagnosticLocation(arg1::CXDiagnostic)::CXSourceLocation
end

"""
    clang_getDiagnosticSpelling(arg1)

Retrieve the text of the given diagnostic.
"""
function clang_getDiagnosticSpelling(arg1)
    @ccall libclang.clang_getDiagnosticSpelling(arg1::CXDiagnostic)::CXString
end

"""
    clang_getDiagnosticOption(Diag, Disable)

Retrieve the name of the command-line option that enabled this diagnostic.

# Arguments
* `Diag`: The diagnostic to be queried.
* `Disable`: If non-NULL, will be set to the option that disables this diagnostic (if any).
# Returns
A string that contains the command-line option used to enable this warning, such as "-Wconversion" or "-pedantic".
"""
function clang_getDiagnosticOption(Diag, Disable)
    @ccall libclang.clang_getDiagnosticOption(Diag::CXDiagnostic, Disable::Ptr{CXString})::CXString
end

"""
    clang_getDiagnosticCategory(arg1)

Retrieve the category number for this diagnostic.

Diagnostics can be categorized into groups along with other, related diagnostics (e.g., diagnostics under the same warning flag). This routine retrieves the category number for the given diagnostic.

# Returns
The number of the category that contains this diagnostic, or zero if this diagnostic is uncategorized.
"""
function clang_getDiagnosticCategory(arg1)
    @ccall libclang.clang_getDiagnosticCategory(arg1::CXDiagnostic)::Cuint
end

"""
    clang_getDiagnosticCategoryName(Category)

Retrieve the name of a particular diagnostic category. This is now deprecated. Use [`clang_getDiagnosticCategoryText`](@ref)() instead.

# Arguments
* `Category`: A diagnostic category number, as returned by [`clang_getDiagnosticCategory`](@ref)().
# Returns
The name of the given diagnostic category.
"""
function clang_getDiagnosticCategoryName(Category)
    @ccall libclang.clang_getDiagnosticCategoryName(Category::Cuint)::CXString
end

"""
    clang_getDiagnosticCategoryText(arg1)

Retrieve the diagnostic category text for a given diagnostic.

# Returns
The text of the given diagnostic category.
"""
function clang_getDiagnosticCategoryText(arg1)
    @ccall libclang.clang_getDiagnosticCategoryText(arg1::CXDiagnostic)::CXString
end

"""
    clang_getDiagnosticNumRanges(arg1)

Determine the number of source ranges associated with the given diagnostic.
"""
function clang_getDiagnosticNumRanges(arg1)
    @ccall libclang.clang_getDiagnosticNumRanges(arg1::CXDiagnostic)::Cuint
end

"""
    clang_getDiagnosticRange(Diagnostic, Range)

Retrieve a source range associated with the diagnostic.

A diagnostic's source ranges highlight important elements in the source code. On the command line, Clang displays source ranges by underlining them with '~' characters.

# Arguments
* `Diagnostic`: the diagnostic whose range is being extracted.
* `Range`: the zero-based index specifying which range to
# Returns
the requested source range.
"""
function clang_getDiagnosticRange(Diagnostic, Range)
    @ccall libclang.clang_getDiagnosticRange(Diagnostic::CXDiagnostic, Range::Cuint)::CXSourceRange
end

"""
    clang_getDiagnosticNumFixIts(Diagnostic)

Determine the number of fix-it hints associated with the given diagnostic.
"""
function clang_getDiagnosticNumFixIts(Diagnostic)
    @ccall libclang.clang_getDiagnosticNumFixIts(Diagnostic::CXDiagnostic)::Cuint
end

"""
    clang_getDiagnosticFixIt(Diagnostic, FixIt, ReplacementRange)

Retrieve the replacement information for a given fix-it.

Fix-its are described in terms of a source range whose contents should be replaced by a string. This approach generalizes over three kinds of operations: removal of source code (the range covers the code to be removed and the replacement string is empty), replacement of source code (the range covers the code to be replaced and the replacement string provides the new code), and insertion (both the start and end of the range point at the insertion location, and the replacement string provides the text to insert).

# Arguments
* `Diagnostic`: The diagnostic whose fix-its are being queried.
* `FixIt`: The zero-based index of the fix-it.
* `ReplacementRange`: The source range whose contents will be replaced with the returned replacement string. Note that source ranges are half-open ranges [a, b), so the source code should be replaced from a and up to (but not including) b.
# Returns
A string containing text that should be replace the source code indicated by the `ReplacementRange`.
"""
function clang_getDiagnosticFixIt(Diagnostic, FixIt, ReplacementRange)
    @ccall libclang.clang_getDiagnosticFixIt(Diagnostic::CXDiagnostic, FixIt::Cuint, ReplacementRange::Ptr{CXSourceRange})::CXString
end

"""
An "index" that consists of a set of translation units that would typically be linked together into an executable or library.
"""
const CXIndex = Ptr{Cvoid}

mutable struct CXTargetInfoImpl end

"""
An opaque type representing target information for a given translation unit.
"""
const CXTargetInfo = Ptr{CXTargetInfoImpl}

mutable struct CXTranslationUnitImpl end

"""
A single translation unit, which resides in an index.
"""
const CXTranslationUnit = Ptr{CXTranslationUnitImpl}

"""
Opaque pointer representing client data that will be passed through to various callbacks and visitors.
"""
const CXClientData = Ptr{Cvoid}

"""
    CXUnsavedFile

Provides the contents of a file that has not yet been saved to disk.

Each [`CXUnsavedFile`](@ref) instance provides the name of a file on the system along with the current contents of that file that have not yet been saved to disk.

| Field    | Note                                                                                                |
| :------- | :-------------------------------------------------------------------------------------------------- |
| Filename | The file whose contents have not yet been saved.  This file must already exist in the file system.  |
| Contents | A buffer containing the unsaved contents of this file.                                              |
| Length   | The length of the unsaved contents of this buffer.                                                  |
"""
struct CXUnsavedFile
    Filename::Cstring
    Contents::Cstring
    Length::Culong
end

"""
    CXAvailabilityKind

Describes the availability of a particular entity, which indicates whether the use of this entity will result in a warning or error due to it being deprecated or unavailable.

| Enumerator                     | Note                                                                                |
| :----------------------------- | :---------------------------------------------------------------------------------- |
| CXAvailability\\_Available     | The entity is available.                                                            |
| CXAvailability\\_Deprecated    | The entity is available, but has been deprecated (and its use is not recommended).  |
| CXAvailability\\_NotAvailable  | The entity is not available; any use of it will be an error.                        |
| CXAvailability\\_NotAccessible | The entity is available, but not accessible; any use of it will be an error.        |
"""
@cenum CXAvailabilityKind::UInt32 begin
    CXAvailability_Available = 0
    CXAvailability_Deprecated = 1
    CXAvailability_NotAvailable = 2
    CXAvailability_NotAccessible = 3
end

"""
    CXVersion

Describes a version number of the form major.minor.subminor.

| Field    | Note                                                                                                                                                                       |
| :------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Major    | The major version number, e.g., the '10' in '10.7.3'. A negative value indicates that there is no version number at all.                                                   |
| Minor    | The minor version number, e.g., the '7' in '10.7.3'. This value will be negative if no minor version number was provided, e.g., for version '10'.                          |
| Subminor | The subminor version number, e.g., the '3' in '10.7.3'. This value will be negative if no minor or subminor version number was provided, e.g., in version '10' or '10.7'.  |
"""
struct CXVersion
    Major::Cint
    Minor::Cint
    Subminor::Cint
end

"""
    CXCursor_ExceptionSpecificationKind

Describes the exception specification of a cursor.

A negative value indicates that the cursor is not a function declaration.

| Enumerator                                               | Note                                                               |
| :------------------------------------------------------- | :----------------------------------------------------------------- |
| CXCursor\\_ExceptionSpecificationKind\\_None             | The cursor has no exception specification.                         |
| CXCursor\\_ExceptionSpecificationKind\\_DynamicNone      | The cursor has exception specification throw()                     |
| CXCursor\\_ExceptionSpecificationKind\\_Dynamic          | The cursor has exception specification throw(T1, T2)               |
| CXCursor\\_ExceptionSpecificationKind\\_MSAny            | The cursor has exception specification throw(...).                 |
| CXCursor\\_ExceptionSpecificationKind\\_BasicNoexcept    | The cursor has exception specification basic noexcept.             |
| CXCursor\\_ExceptionSpecificationKind\\_ComputedNoexcept | The cursor has exception specification computed noexcept.          |
| CXCursor\\_ExceptionSpecificationKind\\_Unevaluated      | The exception specification has not yet been evaluated.            |
| CXCursor\\_ExceptionSpecificationKind\\_Uninstantiated   | The exception specification has not yet been instantiated.         |
| CXCursor\\_ExceptionSpecificationKind\\_Unparsed         | The exception specification has not been parsed yet.               |
| CXCursor\\_ExceptionSpecificationKind\\_NoThrow          | The cursor has a \\_\\_declspec(nothrow) exception specification.  |
"""
@cenum CXCursor_ExceptionSpecificationKind::UInt32 begin
    CXCursor_ExceptionSpecificationKind_None = 0
    CXCursor_ExceptionSpecificationKind_DynamicNone = 1
    CXCursor_ExceptionSpecificationKind_Dynamic = 2
    CXCursor_ExceptionSpecificationKind_MSAny = 3
    CXCursor_ExceptionSpecificationKind_BasicNoexcept = 4
    CXCursor_ExceptionSpecificationKind_ComputedNoexcept = 5
    CXCursor_ExceptionSpecificationKind_Unevaluated = 6
    CXCursor_ExceptionSpecificationKind_Uninstantiated = 7
    CXCursor_ExceptionSpecificationKind_Unparsed = 8
    CXCursor_ExceptionSpecificationKind_NoThrow = 9
end

"""
    clang_createIndex(excludeDeclarationsFromPCH, displayDiagnostics)

Provides a shared context for creating translation units.

It provides two options:

- excludeDeclarationsFromPCH: When non-zero, allows enumeration of "local" declarations (when loading any new translation units). A "local" declaration is one that belongs in the translation unit itself and not in a precompiled header that was used by the translation unit. If zero, all declarations will be enumerated.

Here is an example:

```c++
   // excludeDeclsFromPCH = 1, displayDiagnostics=1
   Idx = clang_createIndex(1, 1);
   // IndexTest.pch was produced with the following command:
   // "clang -x c IndexTest.h -emit-ast -o IndexTest.pch"
   TU = clang_createTranslationUnit(Idx, "IndexTest.pch");
   // This will load all the symbols from 'IndexTest.pch'
   clang_visitChildren(clang_getTranslationUnitCursor(TU),
                       TranslationUnitVisitor, 0);
   clang_disposeTranslationUnit(TU);
   // This will load all the symbols from 'IndexTest.c', excluding symbols
   // from 'IndexTest.pch'.
   char *args[] = { "-Xclang", "-include-pch=IndexTest.pch" };
   TU = clang_createTranslationUnitFromSourceFile(Idx, "IndexTest.c", 2, args,
                                                  0, 0);
   clang_visitChildren(clang_getTranslationUnitCursor(TU),
                       TranslationUnitVisitor, 0);
   clang_disposeTranslationUnit(TU);
```

This process of creating the 'pch', loading it separately, and using it (via -include-pch) allows 'excludeDeclsFromPCH' to remove redundant callbacks (which gives the indexer the same performance benefit as the compiler).
"""
function clang_createIndex(excludeDeclarationsFromPCH, displayDiagnostics)
    @ccall libclang.clang_createIndex(excludeDeclarationsFromPCH::Cint, displayDiagnostics::Cint)::CXIndex
end

"""
    clang_disposeIndex(index)

Destroy the given index.

The index must not be destroyed until all of the translation units created within that index have been destroyed.
"""
function clang_disposeIndex(index)
    @ccall libclang.clang_disposeIndex(index::CXIndex)::Cvoid
end

"""
    CXChoice

| Enumerator          | Note                                                                            |
| :------------------ | :------------------------------------------------------------------------------ |
| CXChoice\\_Default  | Use the default value of an option that may depend on the process environment.  |
| CXChoice\\_Enabled  | Enable the option.                                                              |
| CXChoice\\_Disabled | Disable the option.                                                             |
"""
@cenum CXChoice::UInt32 begin
    CXChoice_Default = 0
    CXChoice_Enabled = 1
    CXChoice_Disabled = 2
end

"""
    CXGlobalOptFlags

| Enumerator                                        | Note                                                                                                                                                                                                                                                                      |
| :------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CXGlobalOpt\\_None                                | Used to indicate that no special [`CXIndex`](@ref) options are needed.                                                                                                                                                                                                    |
| CXGlobalOpt\\_ThreadBackgroundPriorityForIndexing | Used to indicate that threads that libclang creates for indexing purposes should use background priority.  Affects #[`clang_indexSourceFile`](@ref), #[`clang_indexTranslationUnit`](@ref), #[`clang_parseTranslationUnit`](@ref), #[`clang_saveTranslationUnit`](@ref).  |
| CXGlobalOpt\\_ThreadBackgroundPriorityForEditing  | Used to indicate that threads that libclang creates for editing purposes should use background priority.  Affects #[`clang_reparseTranslationUnit`](@ref), #[`clang_codeCompleteAt`](@ref), #[`clang_annotateTokens`](@ref)                                               |
| CXGlobalOpt\\_ThreadBackgroundPriorityForAll      | Used to indicate that all threads that libclang creates should use background priority.                                                                                                                                                                                   |
"""
@cenum CXGlobalOptFlags::UInt32 begin
    CXGlobalOpt_None = 0
    CXGlobalOpt_ThreadBackgroundPriorityForIndexing = 1
    CXGlobalOpt_ThreadBackgroundPriorityForEditing = 2
    CXGlobalOpt_ThreadBackgroundPriorityForAll = 3
end

"""
    CXIndexOptions

Index initialization options.

0 is the default value of each member of this struct except for Size. Initialize the struct in one of the following three ways to avoid adapting code each time a new member is added to it:

```c++
 CXIndexOptions Opts;
 memset(&Opts, 0, sizeof(Opts));
 Opts.Size = sizeof(CXIndexOptions);
```

or explicitly initialize the first data member and zero-initialize the rest:

```c++
 CXIndexOptions Opts = { sizeof(CXIndexOptions) };
```

or to prevent the -Wmissing-field-initializers warning for the above version:

```c++
 CXIndexOptions Opts{};
 Opts.Size = sizeof(CXIndexOptions);
```

| Field                               | Note                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| :---------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Size                                | The size of struct [`CXIndexOptions`](@ref) used for option versioning.  Always initialize this member to sizeof([`CXIndexOptions`](@ref)), or assign sizeof([`CXIndexOptions`](@ref)) to it right after creating a [`CXIndexOptions`](@ref) object.                                                                                                                                                                                           |
| ThreadBackgroundPriorityForIndexing | A [`CXChoice`](@ref) enumerator that specifies the indexing priority policy.  # See also CXGlobalOpt\\_ThreadBackgroundPriorityForIndexing                                                                                                                                                                                                                                                                                                     |
| ThreadBackgroundPriorityForEditing  | A [`CXChoice`](@ref) enumerator that specifies the editing priority policy.  # See also CXGlobalOpt\\_ThreadBackgroundPriorityForEditing                                                                                                                                                                                                                                                                                                       |
| ExcludeDeclarationsFromPCH          | # See also [`clang_createIndex`](@ref)()                                                                                                                                                                                                                                                                                                                                                                                                       |
| DisplayDiagnostics                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| StorePreamblesInMemory              | Store PCH in memory. If zero, PCH are stored in temporary files.                                                                                                                                                                                                                                                                                                                                                                               |
| PreambleStoragePath                 | The path to a directory, in which to store temporary PCH files. If null or empty, the default system temporary directory is used. These PCH files are deleted on clean exit but stay on disk if the program crashes or is killed.  This option is ignored if *StorePreamblesInMemory* is non-zero.  Libclang does not create the directory at the specified path in the file system. Therefore it must exist, or storing PCH files will fail.  |
| InvocationEmissionPath              | Specifies a path which will contain log files for certain libclang invocations. A null value implies that libclang invocations are not logged.                                                                                                                                                                                                                                                                                                 |
"""
struct CXIndexOptions
    data::NTuple{24, UInt8}
end

function Base.getproperty(x::Ptr{CXIndexOptions}, f::Symbol)
    f === :Size && return Ptr{Cuint}(x + 0)
    f === :ThreadBackgroundPriorityForIndexing && return Ptr{Cuchar}(x + 4)
    f === :ThreadBackgroundPriorityForEditing && return Ptr{Cuchar}(x + 5)
    f === :ExcludeDeclarationsFromPCH && return (Ptr{Cuint}(x + 4), 16, 1)
    f === :DisplayDiagnostics && return (Ptr{Cuint}(x + 4), 17, 1)
    f === :StorePreamblesInMemory && return (Ptr{Cuint}(x + 4), 18, 1)
    f === :PreambleStoragePath && return Ptr{Cstring}(x + 8)
    f === :InvocationEmissionPath && return Ptr{Cstring}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::CXIndexOptions, f::Symbol)
    r = Ref{CXIndexOptions}(x)
    ptr = Base.unsafe_convert(Ptr{CXIndexOptions}, r)
    fptr = getproperty(ptr, f)
    begin
        if fptr isa Ptr
            return GC.@preserve(r, unsafe_load(fptr))
        else
            (baseptr, offset, width) = fptr
            ty = eltype(baseptr)
            baseptr32 = convert(Ptr{UInt32}, baseptr)
            u64 = GC.@preserve(r, unsafe_load(baseptr32))
            if offset + width > 32
                u64 |= GC.@preserve(r, unsafe_load(baseptr32 + 4)) << 32
            end
            u64 = u64 >> offset & (1 << width - 1)
            return u64 % ty
        end
    end
end

function Base.setproperty!(x::Ptr{CXIndexOptions}, f::Symbol, v)
    fptr = getproperty(x, f)
    if fptr isa Ptr
        unsafe_store!(getproperty(x, f), v)
    else
        (baseptr, offset, width) = fptr
        baseptr32 = convert(Ptr{UInt32}, baseptr)
        u64 = unsafe_load(baseptr32)
        straddle = offset + width > 32
        if straddle
            u64 |= unsafe_load(baseptr32 + 4) << 32
        end
        mask = 1 << width - 1
        u64 &= ~(mask << offset)
        u64 |= (unsigned(v) & mask) << offset
        unsafe_store!(baseptr32, u64 & typemax(UInt32))
        if straddle
            unsafe_store!(baseptr32 + 4, u64 >> 32)
        end
    end
end

"""
    clang_createIndexWithOptions(options)

Provides a shared context for creating translation units.

Call this function instead of [`clang_createIndex`](@ref)() if you need to configure the additional options in [`CXIndexOptions`](@ref).

For example:

```c++
 CXIndex createIndex(const char *ApplicationTemporaryPath) {
   const int ExcludeDeclarationsFromPCH = 1;
   const int DisplayDiagnostics = 1;
   CXIndex Idx;
 #if CINDEX_VERSION_MINOR >= 64
   CXIndexOptions Opts;
   memset(&Opts, 0, sizeof(Opts));
   Opts.Size = sizeof(CXIndexOptions);
   Opts.ThreadBackgroundPriorityForIndexing = 1;
   Opts.ExcludeDeclarationsFromPCH = ExcludeDeclarationsFromPCH;
   Opts.DisplayDiagnostics = DisplayDiagnostics;
   Opts.PreambleStoragePath = ApplicationTemporaryPath;
   Idx = clang_createIndexWithOptions(&Opts);
   if (Idx)
     return Idx;
   fprintf(stderr,
           "clang_createIndexWithOptions() failed. "
           "CINDEX_VERSION_MINOR = %d, sizeof(CXIndexOptions) = %u\\n",
           CINDEX_VERSION_MINOR, Opts.Size);
 #else
   (void)ApplicationTemporaryPath;
 #endif
   Idx = clang_createIndex(ExcludeDeclarationsFromPCH, DisplayDiagnostics);
   clang_CXIndex_setGlobalOptions(
       Idx, clang_CXIndex_getGlobalOptions(Idx) |
                CXGlobalOpt_ThreadBackgroundPriorityForIndexing);
   return Idx;
 }
```

# Returns
The created index or null in case of error, such as an unsupported value of options->Size.
# See also
[`clang_createIndex`](@ref)()
"""
function clang_createIndexWithOptions(options)
    @ccall libclang.clang_createIndexWithOptions(options::Ptr{CXIndexOptions})::CXIndex
end

"""
    clang_CXIndex_setGlobalOptions(arg1, options)

Sets general options associated with a [`CXIndex`](@ref).

This function is DEPRECATED. Set [`CXIndexOptions`](@ref)::ThreadBackgroundPriorityForIndexing and/or [`CXIndexOptions`](@ref)::ThreadBackgroundPriorityForEditing and call [`clang_createIndexWithOptions`](@ref)() instead.

For example:

```c++
 CXIndex idx = ...;
 clang_CXIndex_setGlobalOptions(idx,
     clang_CXIndex_getGlobalOptions(idx) |
     CXGlobalOpt_ThreadBackgroundPriorityForIndexing);
```

# Arguments
* `options`: A bitmask of options, a bitwise OR of CXGlobalOpt\\_XXX flags.
"""
function clang_CXIndex_setGlobalOptions(arg1, options)
    @ccall libclang.clang_CXIndex_setGlobalOptions(arg1::CXIndex, options::Cuint)::Cvoid
end

"""
    clang_CXIndex_getGlobalOptions(arg1)

Gets the general options associated with a [`CXIndex`](@ref).

This function allows to obtain the final option values used by libclang after specifying the option policies via [`CXChoice`](@ref) enumerators.

# Returns
A bitmask of options, a bitwise OR of CXGlobalOpt\\_XXX flags that are associated with the given [`CXIndex`](@ref) object.
"""
function clang_CXIndex_getGlobalOptions(arg1)
    @ccall libclang.clang_CXIndex_getGlobalOptions(arg1::CXIndex)::Cuint
end

"""
    clang_CXIndex_setInvocationEmissionPathOption(arg1, Path)

Sets the invocation emission path option in a [`CXIndex`](@ref).

This function is DEPRECATED. Set [`CXIndexOptions`](@ref)::InvocationEmissionPath and call [`clang_createIndexWithOptions`](@ref)() instead.

The invocation emission path specifies a path which will contain log files for certain libclang invocations. A null value (default) implies that libclang invocations are not logged..
"""
function clang_CXIndex_setInvocationEmissionPathOption(arg1, Path)
    @ccall libclang.clang_CXIndex_setInvocationEmissionPathOption(arg1::CXIndex, Path::Cstring)::Cvoid
end

"""
    clang_isFileMultipleIncludeGuarded(tu, file)

Determine whether the given header is guarded against multiple inclusions, either with the conventional #ifndef/#define/#endif macro guards or with #pragma once.
"""
function clang_isFileMultipleIncludeGuarded(tu, file)
    @ccall libclang.clang_isFileMultipleIncludeGuarded(tu::CXTranslationUnit, file::CXFile)::Cuint
end

"""
    clang_getFile(tu, file_name)

Retrieve a file handle within the given translation unit.

# Arguments
* `tu`: the translation unit
* `file_name`: the name of the file.
# Returns
the file handle for the named file in the translation unit `tu`, or a NULL file handle if the file was not a part of this translation unit.
"""
function clang_getFile(tu, file_name)
    @ccall libclang.clang_getFile(tu::CXTranslationUnit, file_name::Cstring)::CXFile
end

"""
    clang_getFileContents(tu, file, size)

Retrieve the buffer associated with the given file.

# Arguments
* `tu`: the translation unit
* `file`: the file for which to retrieve the buffer.
* `size`: [out] if non-NULL, will be set to the size of the buffer.
# Returns
a pointer to the buffer in memory that holds the contents of `file`, or a NULL pointer when the file is not loaded.
"""
function clang_getFileContents(tu, file, size)
    @ccall libclang.clang_getFileContents(tu::CXTranslationUnit, file::CXFile, size::Ptr{Csize_t})::Cstring
end

"""
    clang_getLocation(tu, file, line, column)

Retrieves the source location associated with a given file/line/column in a particular translation unit.
"""
function clang_getLocation(tu, file, line, column)
    @ccall libclang.clang_getLocation(tu::CXTranslationUnit, file::CXFile, line::Cuint, column::Cuint)::CXSourceLocation
end

"""
    clang_getLocationForOffset(tu, file, offset)

Retrieves the source location associated with a given character offset in a particular translation unit.
"""
function clang_getLocationForOffset(tu, file, offset)
    @ccall libclang.clang_getLocationForOffset(tu::CXTranslationUnit, file::CXFile, offset::Cuint)::CXSourceLocation
end

"""
    clang_getSkippedRanges(tu, file)

Retrieve all ranges that were skipped by the preprocessor.

The preprocessor will skip lines when they are surrounded by an if/ifdef/ifndef directive whose condition does not evaluate to true.
"""
function clang_getSkippedRanges(tu, file)
    @ccall libclang.clang_getSkippedRanges(tu::CXTranslationUnit, file::CXFile)::Ptr{CXSourceRangeList}
end

"""
    clang_getAllSkippedRanges(tu)

Retrieve all ranges from all files that were skipped by the preprocessor.

The preprocessor will skip lines when they are surrounded by an if/ifdef/ifndef directive whose condition does not evaluate to true.
"""
function clang_getAllSkippedRanges(tu)
    @ccall libclang.clang_getAllSkippedRanges(tu::CXTranslationUnit)::Ptr{CXSourceRangeList}
end

"""
    clang_getNumDiagnostics(Unit)

Determine the number of diagnostics produced for the given translation unit.
"""
function clang_getNumDiagnostics(Unit)
    @ccall libclang.clang_getNumDiagnostics(Unit::CXTranslationUnit)::Cuint
end

"""
    clang_getDiagnostic(Unit, Index)

Retrieve a diagnostic associated with the given translation unit.

# Arguments
* `Unit`: the translation unit to query.
* `Index`: the zero-based diagnostic number to retrieve.
# Returns
the requested diagnostic. This diagnostic must be freed via a call to [`clang_disposeDiagnostic`](@ref)().
"""
function clang_getDiagnostic(Unit, Index)
    @ccall libclang.clang_getDiagnostic(Unit::CXTranslationUnit, Index::Cuint)::CXDiagnostic
end

"""
    clang_getDiagnosticSetFromTU(Unit)

Retrieve the complete set of diagnostics associated with a translation unit.

# Arguments
* `Unit`: the translation unit to query.
"""
function clang_getDiagnosticSetFromTU(Unit)
    @ccall libclang.clang_getDiagnosticSetFromTU(Unit::CXTranslationUnit)::CXDiagnosticSet
end

"""
    clang_getTranslationUnitSpelling(CTUnit)

Get the original translation unit source file name.
"""
function clang_getTranslationUnitSpelling(CTUnit)
    @ccall libclang.clang_getTranslationUnitSpelling(CTUnit::CXTranslationUnit)::CXString
end

"""
    clang_createTranslationUnitFromSourceFile(CIdx, source_filename, num_clang_command_line_args, clang_command_line_args, num_unsaved_files, unsaved_files)

Return the [`CXTranslationUnit`](@ref) for a given source file and the provided command line arguments one would pass to the compiler.

Note: The 'source\\_filename' argument is optional. If the caller provides a NULL pointer, the name of the source file is expected to reside in the specified command line arguments.

Note: When encountered in 'clang\\_command\\_line\\_args', the following options are ignored:

'-c' '-emit-ast' '-fsyntax-only' '-o <output file>' (both '-o' and '<output file>' are ignored)

# Arguments
* `CIdx`: The index object with which the translation unit will be associated.
* `source_filename`: The name of the source file to load, or NULL if the source file is included in `clang_command_line_args`.
* `num_clang_command_line_args`: The number of command-line arguments in `clang_command_line_args`.
* `clang_command_line_args`: The command-line arguments that would be passed to the `clang` executable if it were being invoked out-of-process. These command-line options will be parsed and will affect how the translation unit is parsed. Note that the following options are ignored: '-c', '-emit-ast', '-fsyntax-only' (which is the default), and '-o <output file>'.
* `num_unsaved_files`: the number of unsaved file entries in `unsaved_files`.
* `unsaved_files`: the files that have not yet been saved to disk but may be required for code completion, including the contents of those files. The contents and name of these files (as specified by [`CXUnsavedFile`](@ref)) are copied when necessary, so the client only needs to guarantee their validity until the call to this function returns.
"""
function clang_createTranslationUnitFromSourceFile(CIdx, source_filename, num_clang_command_line_args, clang_command_line_args, num_unsaved_files, unsaved_files)
    @ccall libclang.clang_createTranslationUnitFromSourceFile(CIdx::CXIndex, source_filename::Cstring, num_clang_command_line_args::Cint, clang_command_line_args::Ptr{Cstring}, num_unsaved_files::Cuint, unsaved_files::Ptr{CXUnsavedFile})::CXTranslationUnit
end

"""
    clang_createTranslationUnit(CIdx, ast_filename)

Same as [`clang_createTranslationUnit2`](@ref), but returns the [`CXTranslationUnit`](@ref) instead of an error code. In case of an error this routine returns a `NULL` [`CXTranslationUnit`](@ref), without further detailed error codes.
"""
function clang_createTranslationUnit(CIdx, ast_filename)
    @ccall libclang.clang_createTranslationUnit(CIdx::CXIndex, ast_filename::Cstring)::CXTranslationUnit
end

"""
    clang_createTranslationUnit2(CIdx, ast_filename, out_TU)

Create a translation unit from an AST file (`-emit-ast).`

# Arguments
* `out_TU`:\\[out\\] A non-NULL pointer to store the created [`CXTranslationUnit`](@ref).
# Returns
Zero on success, otherwise returns an error code.
"""
function clang_createTranslationUnit2(CIdx, ast_filename, out_TU)
    @ccall libclang.clang_createTranslationUnit2(CIdx::CXIndex, ast_filename::Cstring, out_TU::Ptr{CXTranslationUnit})::CXErrorCode
end

"""
    CXTranslationUnit_Flags

Flags that control the creation of translation units.

The enumerators in this enumeration type are meant to be bitwise ORed together to specify which options should be used when constructing the translation unit.

| Enumerator                                               | Note                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| :------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXTranslationUnit\\_None                                 | Used to indicate that no special translation-unit options are needed.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXTranslationUnit\\_DetailedPreprocessingRecord          | Used to indicate that the parser should construct a "detailed" preprocessing record, including all macro definitions and instantiations.  Constructing a detailed preprocessing record requires more memory and time to parse, since the information contained in the record is usually not retained. However, it can be useful for applications that require more detailed information about the behavior of the preprocessor.                                                                                                                                                                                                                                                  |
| CXTranslationUnit\\_Incomplete                           | Used to indicate that the translation unit is incomplete.  When a translation unit is considered "incomplete", semantic analysis that is typically performed at the end of the translation unit will be suppressed. For example, this suppresses the completion of tentative declarations in C and of instantiation of implicitly-instantiation function templates in C++. This option is typically used when parsing a header with the intent of producing a precompiled header.                                                                                                                                                                                                |
| CXTranslationUnit\\_PrecompiledPreamble                  | Used to indicate that the translation unit should be built with an implicit precompiled header for the preamble.  An implicit precompiled header is used as an optimization when a particular translation unit is likely to be reparsed many times when the sources aren't changing that often. In this case, an implicit precompiled header will be built containing all of the initial includes at the top of the main file (what we refer to as the "preamble" of the file). In subsequent parses, if the preamble or the files in it have not changed, [`clang_reparseTranslationUnit`](@ref)() will re-use the implicit precompiled header to improve parsing performance.  |
| CXTranslationUnit\\_CacheCompletionResults               | Used to indicate that the translation unit should cache some code-completion results with each reparse of the source file.  Caching of code-completion results is a performance optimization that introduces some overhead to reparsing but improves the performance of code-completion operations.                                                                                                                                                                                                                                                                                                                                                                              |
| CXTranslationUnit\\_ForSerialization                     | Used to indicate that the translation unit will be serialized with [`clang_saveTranslationUnit`](@ref).  This option is typically used when parsing a header with the intent of producing a precompiled header.                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXTranslationUnit\\_CXXChainedPCH                        | DEPRECATED: Enabled chained precompiled preambles in C++.  Note: this is a *temporary* option that is available only while we are testing C++ precompiled preamble support. It is deprecated.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXTranslationUnit\\_SkipFunctionBodies                   | Used to indicate that function/method bodies should be skipped while parsing.  This option can be used to search for declarations/definitions while ignoring the usages.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXTranslationUnit\\_IncludeBriefCommentsInCodeCompletion | Used to indicate that brief documentation comments should be included into the set of code completions returned from this translation unit.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXTranslationUnit\\_CreatePreambleOnFirstParse           | Used to indicate that the precompiled preamble should be created on the first parse. Otherwise it will be created on the first reparse. This trades runtime on the first parse (serializing the preamble takes time) for reduced runtime on the second parse (can now reuse the preamble).                                                                                                                                                                                                                                                                                                                                                                                       |
| CXTranslationUnit\\_KeepGoing                            | Do not stop processing when fatal errors are encountered.  When fatal errors are encountered while parsing a translation unit, semantic analysis is typically stopped early when compiling code. A common source for fatal errors are unresolvable include files. For the purposes of an IDE, this is undesirable behavior and as much information as possible should be reported. Use this flag to enable this behavior.                                                                                                                                                                                                                                                        |
| CXTranslationUnit\\_SingleFileParse                      | Sets the preprocessor in a mode for parsing a single file only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXTranslationUnit\\_LimitSkipFunctionBodiesToPreamble    | Used in combination with CXTranslationUnit\\_SkipFunctionBodies to constrain the skipping of function bodies to the preamble.  The function bodies of the main file are not skipped.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXTranslationUnit\\_IncludeAttributedTypes               | Used to indicate that attributed types should be included in [`CXType`](@ref).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXTranslationUnit\\_VisitImplicitAttributes              | Used to indicate that implicit attributes should be visited.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXTranslationUnit\\_IgnoreNonErrorsFromIncludedFiles     | Used to indicate that non-errors from included files should be ignored.  If set, [`clang_getDiagnosticSetFromTU`](@ref)() will not report e.g. warnings from included files anymore. This speeds up [`clang_getDiagnosticSetFromTU`](@ref)() for the case where these warnings are not of interest, as for an IDE for example, which typically shows only the diagnostics in the main file.                                                                                                                                                                                                                                                                                      |
| CXTranslationUnit\\_RetainExcludedConditionalBlocks      | Tells the preprocessor not to skip excluded conditional blocks.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
"""
@cenum CXTranslationUnit_Flags::UInt32 begin
    CXTranslationUnit_None = 0
    CXTranslationUnit_DetailedPreprocessingRecord = 1
    CXTranslationUnit_Incomplete = 2
    CXTranslationUnit_PrecompiledPreamble = 4
    CXTranslationUnit_CacheCompletionResults = 8
    CXTranslationUnit_ForSerialization = 16
    CXTranslationUnit_CXXChainedPCH = 32
    CXTranslationUnit_SkipFunctionBodies = 64
    CXTranslationUnit_IncludeBriefCommentsInCodeCompletion = 128
    CXTranslationUnit_CreatePreambleOnFirstParse = 256
    CXTranslationUnit_KeepGoing = 512
    CXTranslationUnit_SingleFileParse = 1024
    CXTranslationUnit_LimitSkipFunctionBodiesToPreamble = 2048
    CXTranslationUnit_IncludeAttributedTypes = 4096
    CXTranslationUnit_VisitImplicitAttributes = 8192
    CXTranslationUnit_IgnoreNonErrorsFromIncludedFiles = 16384
    CXTranslationUnit_RetainExcludedConditionalBlocks = 32768
end

"""
    clang_defaultEditingTranslationUnitOptions()

Returns the set of flags that is suitable for parsing a translation unit that is being edited.

The set of flags returned provide options for [`clang_parseTranslationUnit`](@ref)() to indicate that the translation unit is likely to be reparsed many times, either explicitly (via [`clang_reparseTranslationUnit`](@ref)()) or implicitly (e.g., by code completion (`clang_codeCompletionAt`())). The returned flag set contains an unspecified set of optimizations (e.g., the precompiled preamble) geared toward improving the performance of these routines. The set of optimizations enabled may change from one version to the next.
"""
function clang_defaultEditingTranslationUnitOptions()
    @ccall libclang.clang_defaultEditingTranslationUnitOptions()::Cuint
end

"""
    clang_parseTranslationUnit(CIdx, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, options)

Same as [`clang_parseTranslationUnit2`](@ref), but returns the [`CXTranslationUnit`](@ref) instead of an error code. In case of an error this routine returns a `NULL` [`CXTranslationUnit`](@ref), without further detailed error codes.
"""
function clang_parseTranslationUnit(CIdx, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, options)
    @ccall libclang.clang_parseTranslationUnit(CIdx::CXIndex, source_filename::Cstring, command_line_args::Ptr{Cstring}, num_command_line_args::Cint, unsaved_files::Ptr{CXUnsavedFile}, num_unsaved_files::Cuint, options::Cuint)::CXTranslationUnit
end

"""
    clang_parseTranslationUnit2(CIdx, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, options, out_TU)

Parse the given source file and the translation unit corresponding to that file.

This routine is the main entry point for the Clang C API, providing the ability to parse a source file into a translation unit that can then be queried by other functions in the API. This routine accepts a set of command-line arguments so that the compilation can be configured in the same way that the compiler is configured on the command line.

# Arguments
* `CIdx`: The index object with which the translation unit will be associated.
* `source_filename`: The name of the source file to load, or NULL if the source file is included in `command_line_args`.
* `command_line_args`: The command-line arguments that would be passed to the `clang` executable if it were being invoked out-of-process. These command-line options will be parsed and will affect how the translation unit is parsed. Note that the following options are ignored: '-c', '-emit-ast', '-fsyntax-only' (which is the default), and '-o <output file>'.
* `num_command_line_args`: The number of command-line arguments in `command_line_args`.
* `unsaved_files`: the files that have not yet been saved to disk but may be required for parsing, including the contents of those files. The contents and name of these files (as specified by [`CXUnsavedFile`](@ref)) are copied when necessary, so the client only needs to guarantee their validity until the call to this function returns.
* `num_unsaved_files`: the number of unsaved file entries in `unsaved_files`.
* `options`: A bitmask of options that affects how the translation unit is managed but not its compilation. This should be a bitwise OR of the CXTranslationUnit\\_XXX flags.
* `out_TU`:\\[out\\] A non-NULL pointer to store the created [`CXTranslationUnit`](@ref), describing the parsed code and containing any diagnostics produced by the compiler.
# Returns
Zero on success, otherwise returns an error code.
"""
function clang_parseTranslationUnit2(CIdx, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, options, out_TU)
    @ccall libclang.clang_parseTranslationUnit2(CIdx::CXIndex, source_filename::Cstring, command_line_args::Ptr{Cstring}, num_command_line_args::Cint, unsaved_files::Ptr{CXUnsavedFile}, num_unsaved_files::Cuint, options::Cuint, out_TU::Ptr{CXTranslationUnit})::CXErrorCode
end

"""
    clang_parseTranslationUnit2FullArgv(CIdx, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, options, out_TU)

Same as [`clang_parseTranslationUnit2`](@ref) but requires a full command line for `command_line_args` including argv[0]. This is useful if the standard library paths are relative to the binary.
"""
function clang_parseTranslationUnit2FullArgv(CIdx, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, options, out_TU)
    @ccall libclang.clang_parseTranslationUnit2FullArgv(CIdx::CXIndex, source_filename::Cstring, command_line_args::Ptr{Cstring}, num_command_line_args::Cint, unsaved_files::Ptr{CXUnsavedFile}, num_unsaved_files::Cuint, options::Cuint, out_TU::Ptr{CXTranslationUnit})::CXErrorCode
end

"""
    CXSaveTranslationUnit_Flags

Flags that control how translation units are saved.

The enumerators in this enumeration type are meant to be bitwise ORed together to specify which options should be used when saving the translation unit.

| Enumerator                   | Note                                                         |
| :--------------------------- | :----------------------------------------------------------- |
| CXSaveTranslationUnit\\_None | Used to indicate that no special saving options are needed.  |
"""
@cenum CXSaveTranslationUnit_Flags::UInt32 begin
    CXSaveTranslationUnit_None = 0
end

"""
    clang_defaultSaveOptions(TU)

Returns the set of flags that is suitable for saving a translation unit.

The set of flags returned provide options for [`clang_saveTranslationUnit`](@ref)() by default. The returned flag set contains an unspecified set of options that save translation units with the most commonly-requested data.
"""
function clang_defaultSaveOptions(TU)
    @ccall libclang.clang_defaultSaveOptions(TU::CXTranslationUnit)::Cuint
end

"""
    CXSaveError

Describes the kind of error that occurred (if any) in a call to [`clang_saveTranslationUnit`](@ref)().

| Enumerator                      | Note                                                                                                                                                                                                                                                      |
| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXSaveError\\_None              | Indicates that no error occurred while saving a translation unit.                                                                                                                                                                                         |
| CXSaveError\\_Unknown           | Indicates that an unknown error occurred while attempting to save the file.  This error typically indicates that file I/O failed when attempting to write the file.                                                                                       |
| CXSaveError\\_TranslationErrors | Indicates that errors during translation prevented this attempt to save the translation unit.  Errors that prevent the translation unit from being saved can be extracted using [`clang_getNumDiagnostics`](@ref)() and [`clang_getDiagnostic`](@ref)().  |
| CXSaveError\\_InvalidTU         | Indicates that the translation unit to be saved was somehow invalid (e.g., NULL).                                                                                                                                                                         |
"""
@cenum CXSaveError::UInt32 begin
    CXSaveError_None = 0
    CXSaveError_Unknown = 1
    CXSaveError_TranslationErrors = 2
    CXSaveError_InvalidTU = 3
end

"""
    clang_saveTranslationUnit(TU, FileName, options)

Saves a translation unit into a serialized representation of that translation unit on disk.

Any translation unit that was parsed without error can be saved into a file. The translation unit can then be deserialized into a new [`CXTranslationUnit`](@ref) with [`clang_createTranslationUnit`](@ref)() or, if it is an incomplete translation unit that corresponds to a header, used as a precompiled header when parsing other translation units.

# Arguments
* `TU`: The translation unit to save.
* `FileName`: The file to which the translation unit will be saved.
* `options`: A bitmask of options that affects how the translation unit is saved. This should be a bitwise OR of the CXSaveTranslationUnit\\_XXX flags.
# Returns
A value that will match one of the enumerators of the [`CXSaveError`](@ref) enumeration. Zero (CXSaveError\\_None) indicates that the translation unit was saved successfully, while a non-zero value indicates that a problem occurred.
"""
function clang_saveTranslationUnit(TU, FileName, options)
    @ccall libclang.clang_saveTranslationUnit(TU::CXTranslationUnit, FileName::Cstring, options::Cuint)::Cint
end

"""
    clang_suspendTranslationUnit(arg1)

Suspend a translation unit in order to free memory associated with it.

A suspended translation unit uses significantly less memory but on the other side does not support any other calls than [`clang_reparseTranslationUnit`](@ref) to resume it or [`clang_disposeTranslationUnit`](@ref) to dispose it completely.
"""
function clang_suspendTranslationUnit(arg1)
    @ccall libclang.clang_suspendTranslationUnit(arg1::CXTranslationUnit)::Cuint
end

"""
    clang_disposeTranslationUnit(arg1)

Destroy the specified [`CXTranslationUnit`](@ref) object.
"""
function clang_disposeTranslationUnit(arg1)
    @ccall libclang.clang_disposeTranslationUnit(arg1::CXTranslationUnit)::Cvoid
end

"""
    CXReparse_Flags

Flags that control the reparsing of translation units.

The enumerators in this enumeration type are meant to be bitwise ORed together to specify which options should be used when reparsing the translation unit.

| Enumerator       | Note                                                            |
| :--------------- | :-------------------------------------------------------------- |
| CXReparse\\_None | Used to indicate that no special reparsing options are needed.  |
"""
@cenum CXReparse_Flags::UInt32 begin
    CXReparse_None = 0
end

"""
    clang_defaultReparseOptions(TU)

Returns the set of flags that is suitable for reparsing a translation unit.

The set of flags returned provide options for [`clang_reparseTranslationUnit`](@ref)() by default. The returned flag set contains an unspecified set of optimizations geared toward common uses of reparsing. The set of optimizations enabled may change from one version to the next.
"""
function clang_defaultReparseOptions(TU)
    @ccall libclang.clang_defaultReparseOptions(TU::CXTranslationUnit)::Cuint
end

"""
    clang_reparseTranslationUnit(TU, num_unsaved_files, unsaved_files, options)

Reparse the source files that produced this translation unit.

This routine can be used to re-parse the source files that originally created the given translation unit, for example because those source files have changed (either on disk or as passed via `unsaved_files`). The source code will be reparsed with the same command-line options as it was originally parsed.

Reparsing a translation unit invalidates all cursors and source locations that refer into that translation unit. This makes reparsing a translation unit semantically equivalent to destroying the translation unit and then creating a new translation unit with the same command-line arguments. However, it may be more efficient to reparse a translation unit using this routine.

# Arguments
* `TU`: The translation unit whose contents will be re-parsed. The translation unit must originally have been built with [`clang_createTranslationUnitFromSourceFile`](@ref)().
* `num_unsaved_files`: The number of unsaved file entries in `unsaved_files`.
* `unsaved_files`: The files that have not yet been saved to disk but may be required for parsing, including the contents of those files. The contents and name of these files (as specified by [`CXUnsavedFile`](@ref)) are copied when necessary, so the client only needs to guarantee their validity until the call to this function returns.
* `options`: A bitset of options composed of the flags in [`CXReparse_Flags`](@ref). The function [`clang_defaultReparseOptions`](@ref)() produces a default set of options recommended for most uses, based on the translation unit.
# Returns
0 if the sources could be reparsed. A non-zero error code will be returned if reparsing was impossible, such that the translation unit is invalid. In such cases, the only valid call for `TU` is [`clang_disposeTranslationUnit`](@ref)(TU). The error codes returned by this routine are described by the [`CXErrorCode`](@ref) enum.
"""
function clang_reparseTranslationUnit(TU, num_unsaved_files, unsaved_files, options)
    @ccall libclang.clang_reparseTranslationUnit(TU::CXTranslationUnit, num_unsaved_files::Cuint, unsaved_files::Ptr{CXUnsavedFile}, options::Cuint)::Cint
end

"""
    CXTUResourceUsageKind

Categorizes how memory is being used by a translation unit.
"""
@cenum CXTUResourceUsageKind::UInt32 begin
    CXTUResourceUsage_AST = 1
    CXTUResourceUsage_Identifiers = 2
    CXTUResourceUsage_Selectors = 3
    CXTUResourceUsage_GlobalCompletionResults = 4
    CXTUResourceUsage_SourceManagerContentCache = 5
    CXTUResourceUsage_AST_SideTables = 6
    CXTUResourceUsage_SourceManager_Membuffer_Malloc = 7
    CXTUResourceUsage_SourceManager_Membuffer_MMap = 8
    CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc = 9
    CXTUResourceUsage_ExternalASTSource_Membuffer_MMap = 10
    CXTUResourceUsage_Preprocessor = 11
    CXTUResourceUsage_PreprocessingRecord = 12
    CXTUResourceUsage_SourceManager_DataStructures = 13
    CXTUResourceUsage_Preprocessor_HeaderSearch = 14
    CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN = 1
    CXTUResourceUsage_MEMORY_IN_BYTES_END = 14
    CXTUResourceUsage_First = 1
    CXTUResourceUsage_Last = 14
end

"""
    clang_getTUResourceUsageName(kind)

Returns the human-readable null-terminated C string that represents the name of the memory category. This string should never be freed.
"""
function clang_getTUResourceUsageName(kind)
    @ccall libclang.clang_getTUResourceUsageName(kind::CXTUResourceUsageKind)::Cstring
end

struct CXTUResourceUsageEntry
    kind::CXTUResourceUsageKind
    amount::Culong
end

"""
    CXTUResourceUsage

The memory usage of a [`CXTranslationUnit`](@ref), broken into categories.
"""
struct CXTUResourceUsage
    data::Ptr{Cvoid}
    numEntries::Cuint
    entries::Ptr{CXTUResourceUsageEntry}
end

"""
    clang_getCXTUResourceUsage(TU)

Return the memory usage of a translation unit. This object should be released with [`clang_disposeCXTUResourceUsage`](@ref)().
"""
function clang_getCXTUResourceUsage(TU)
    @ccall libclang.clang_getCXTUResourceUsage(TU::CXTranslationUnit)::CXTUResourceUsage
end

"""
    clang_disposeCXTUResourceUsage(usage)

*Documentation not found in headers.*
"""
function clang_disposeCXTUResourceUsage(usage)
    @ccall libclang.clang_disposeCXTUResourceUsage(usage::CXTUResourceUsage)::Cvoid
end

"""
    clang_getTranslationUnitTargetInfo(CTUnit)

Get target information for this translation unit.

The [`CXTargetInfo`](@ref) object cannot outlive the [`CXTranslationUnit`](@ref) object.
"""
function clang_getTranslationUnitTargetInfo(CTUnit)
    @ccall libclang.clang_getTranslationUnitTargetInfo(CTUnit::CXTranslationUnit)::CXTargetInfo
end

"""
    clang_TargetInfo_dispose(Info)

Destroy the [`CXTargetInfo`](@ref) object.
"""
function clang_TargetInfo_dispose(Info)
    @ccall libclang.clang_TargetInfo_dispose(Info::CXTargetInfo)::Cvoid
end

"""
    clang_TargetInfo_getTriple(Info)

Get the normalized target triple as a string.

Returns the empty string in case of any error.
"""
function clang_TargetInfo_getTriple(Info)
    @ccall libclang.clang_TargetInfo_getTriple(Info::CXTargetInfo)::CXString
end

"""
    clang_TargetInfo_getPointerWidth(Info)

Get the pointer width of the target in bits.

Returns -1 in case of error.
"""
function clang_TargetInfo_getPointerWidth(Info)
    @ccall libclang.clang_TargetInfo_getPointerWidth(Info::CXTargetInfo)::Cint
end

"""
    CXCursorKind

Describes the kind of entity that a cursor refers to.

| Enumerator                                                  | Note                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| :---------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXCursor\\_UnexposedDecl                                    | A declaration whose specific kind is not exposed via this interface.  Unexposed declarations have the same operations as any other kind of declaration; one can extract their location information, spelling, find their definitions, etc. However, the specific kind of the declaration is not reported.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_StructDecl                                       | A C or C++ struct.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_UnionDecl                                        | A C or C++ union.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_ClassDecl                                        | A C++ class.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_EnumDecl                                         | An enumeration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FieldDecl                                        | A field (in C) or non-static data member (in C++) in a struct, union, or C++ class.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_EnumConstantDecl                                 | An enumerator constant.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_FunctionDecl                                     | A function.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_VarDecl                                          | A variable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_ParmDecl                                         | A function or method parameter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCInterfaceDecl                                | An Objective-C @interface.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_ObjCCategoryDecl                                 | An Objective-C @interface for a category.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_ObjCProtocolDecl                                 | An Objective-C @protocol declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_ObjCPropertyDecl                                 | An Objective-C @property declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_ObjCIvarDecl                                     | An Objective-C instance variable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_ObjCInstanceMethodDecl                           | An Objective-C instance method.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCClassMethodDecl                              | An Objective-C class method.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_ObjCImplementationDecl                           | An Objective-C @implementation.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCCategoryImplDecl                             | An Objective-C @implementation for a category.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_TypedefDecl                                      | A typedef.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_CXXMethod                                        | A C++ class method.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_Namespace                                        | A C++ namespace.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_LinkageSpec                                      | A linkage specification, e.g. 'extern "C"'.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_Constructor                                      | A C++ constructor.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_Destructor                                       | A C++ destructor.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_ConversionFunction                               | A C++ conversion function.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_TemplateTypeParameter                            | A C++ template type parameter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_NonTypeTemplateParameter                         | A C++ non-type template parameter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_TemplateTemplateParameter                        | A C++ template template parameter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_FunctionTemplate                                 | A C++ function template.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_ClassTemplate                                    | A C++ class template.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_ClassTemplatePartialSpecialization               | A C++ class template partial specialization.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_NamespaceAlias                                   | A C++ namespace alias declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_UsingDirective                                   | A C++ using directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_UsingDeclaration                                 | A C++ using declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_TypeAliasDecl                                    | A C++ alias declaration                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_ObjCSynthesizeDecl                               | An Objective-C @synthesize definition.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_ObjCDynamicDecl                                  | An Objective-C @dynamic definition.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_CXXAccessSpecifier                               | An access specifier.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_FirstDecl                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_LastDecl                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FirstRef                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCSuperClassRef                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCProtocolRef                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCClassRef                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_TypeRef                                          | A reference to a type declaration.  A type reference occurs anywhere where a type is named but not declared. For example, given:  ```c++  typedef unsigned size_type;  size_type size; ```  The typedef is a declaration of size\\_type (CXCursor\\_TypedefDecl), while the type of the variable "size" is referenced. The cursor referenced by the type of size is the typedef for size\\_type.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_CXXBaseSpecifier                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_TemplateRef                                      | A reference to a class template, function template, template template parameter, or class template partial specialization.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_NamespaceRef                                     | A reference to a namespace or namespace alias.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_MemberRef                                        | A reference to a member of a struct, union, or class that occurs in some non-expression context, e.g., a designated initializer.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_LabelRef                                         | A reference to a labeled statement.  This cursor kind is used to describe the jump to "start\\_over" in the goto statement in the following example:  ```c++    start_over:      ++counter;      goto start_over; ```  A label reference cursor refers to a label statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_OverloadedDeclRef                                | A reference to a set of overloaded functions or function templates that has not yet been resolved to a specific function or function template.  An overloaded declaration reference cursor occurs in C++ templates where a dependent name refers to a function. For example:  ```c++  template<typename T> void swap(T&, T&);  struct X { ... };  void swap(X&, X&);  template<typename T>  void reverse(T* first, T* last) {    while (first < last - 1) {      swap(*first, *--last);      ++first;    }  }  struct Y { };  void swap(Y&, Y&); ```  Here, the identifier "swap" is associated with an overloaded declaration reference. In the template definition, "swap" refers to either of the two "swap" functions declared above, so both results will be available. At instantiation time, "swap" may also refer to other functions found via argument-dependent lookup (e.g., the "swap" function at the end of the example).  The functions [`clang_getNumOverloadedDecls`](@ref)() and [`clang_getOverloadedDecl`](@ref)() can be used to retrieve the definitions referenced by this cursor.  |
| CXCursor\\_VariableRef                                      | A reference to a variable that occurs in some non-expression context, e.g., a C++ lambda capture list.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_LastRef                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FirstInvalid                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_InvalidFile                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NoDeclFound                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NotImplemented                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_InvalidCode                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_LastInvalid                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FirstExpr                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_UnexposedExpr                                    | An expression whose specific kind is not exposed via this interface.  Unexposed expressions have the same operations as any other kind of expression; one can extract their location information, spelling, children, etc. However, the specific kind of the expression is not reported.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_DeclRefExpr                                      | An expression that refers to some value declaration, such as a function, variable, or enumerator.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_MemberRefExpr                                    | An expression that refers to a member of a struct, union, class, Objective-C class, etc.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_CallExpr                                         | An expression that calls a function.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_ObjCMessageExpr                                  | An expression that sends a message to an Objective-C object or class.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_BlockExpr                                        | An expression that represents a block literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_IntegerLiteral                                   | An integer literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_FloatingLiteral                                  | A floating point number literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_ImaginaryLiteral                                 | An imaginary number literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_StringLiteral                                    | A string literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_CharacterLiteral                                 | A character literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_ParenExpr                                        | A parenthesized expression, e.g. "(1)".  This AST node is only formed if full location information is requested.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_UnaryOperator                                    | This represents the unary-expression's (except sizeof and alignof).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_ArraySubscriptExpr                               | [C99 6.5.2.1] Array Subscripting.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_BinaryOperator                                   | A builtin binary operation expression such as "x + y" or "x <= y".                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_CompoundAssignOperator                           | Compound assignment such as "+=".                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_ConditionalOperator                              | The ?: ternary operator.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_CStyleCastExpr                                   | An explicit cast in C (C99 6.5.4) or a C-style cast in C++ (C++ [expr.cast]), which uses the syntax (Type)expr.  For example: (int)f.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_CompoundLiteralExpr                              | [C99 6.5.2.5]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| CXCursor\\_InitListExpr                                     | Describes an C or C++ initializer list.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_AddrLabelExpr                                    | The GNU address of label extension, representing &&label.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_StmtExpr                                         | This is the GNU Statement Expression extension: ({int X=4; X;})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_GenericSelectionExpr                             | Represents a C11 generic selection.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_GNUNullExpr                                      | Implements the GNU \\_\\_null extension, which is a name for a null pointer constant that has integral type (e.g., int or long) and is the same size and alignment as a pointer.  The \\_\\_null extension is typically only used by system headers, which define NULL as \\_\\_null in C++ rather than using 0 (which is an integer that may not match the size of a pointer).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CXXStaticCastExpr                                | C++'s static\\_cast<> expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_CXXDynamicCastExpr                               | C++'s dynamic\\_cast<> expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_CXXReinterpretCastExpr                           | C++'s reinterpret\\_cast<> expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_CXXConstCastExpr                                 | C++'s const\\_cast<> expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_CXXFunctionalCastExpr                            | Represents an explicit C++ type conversion that uses "functional" notion (C++ [expr.type.conv]).  Example:  ```c++    x = int(0.5); ```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_CXXTypeidExpr                                    | A C++ typeid expression (C++ [expr.typeid]).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_CXXBoolLiteralExpr                               | [C++ 2.13.5] C++ Boolean Literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_CXXNullPtrLiteralExpr                            | [C++0x 2.14.7] C++ Pointer Literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_CXXThisExpr                                      | Represents the "this" expression in C++                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_CXXThrowExpr                                     | [C++ 15] C++ Throw Expression.  This handles 'throw' and 'throw' assignment-expression. When assignment-expression isn't present, Op will be null.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_CXXNewExpr                                       | A new expression for memory allocation and constructor calls, e.g: "new CXXNewExpr(foo)".                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_CXXDeleteExpr                                    | A delete expression for memory deallocation and destructor calls, e.g. "delete[] pArray".                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_UnaryExpr                                        | A unary expression. (noexcept, sizeof, or other traits)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_ObjCStringLiteral                                | An Objective-C string literal i.e. "foo".                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_ObjCEncodeExpr                                   | An Objective-C @encode expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_ObjCSelectorExpr                                 | An Objective-C @selector expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_ObjCProtocolExpr                                 | An Objective-C @protocol expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_ObjCBridgedCastExpr                              | An Objective-C "bridged" cast expression, which casts between Objective-C pointers and C pointers, transferring ownership in the process.  ```c++    NSString *str = (__bridge_transfer NSString *)CFCreateString(); ```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_PackExpansionExpr                                | Represents a C++0x pack expansion that produces a sequence of expressions.  A pack expansion expression contains a pattern (which itself is an expression) followed by an ellipsis. For example:  ```c++  template<typename F, typename ...Types>  void forward(F f, Types &&...args) {   f(static_cast<Types&&>(args)...);  } ```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_SizeOfPackExpr                                   | Represents an expression that computes the length of a parameter pack.  ```c++  template<typename ...Types>  struct count {    static const unsigned value = sizeof...(Types);  }; ```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_ObjCBoolLiteralExpr                              | Objective-c Boolean Literal.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_ObjCSelfExpr                                     | Represents the "self" expression in an Objective-C method.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPArraySectionExpr                              | OpenMP 5.0 [2.1.5, Array Section].                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_ObjCAvailabilityCheckExpr                        | Represents an (...) check.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_FixedPointLiteral                                | Fixed point literal                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_OMPArrayShapingExpr                              | OpenMP 5.0 [2.1.4, Array Shaping].                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_OMPIteratorExpr                                  | OpenMP 5.0 [2.1.6 Iterators]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_CXXAddrspaceCastExpr                             | OpenCL's addrspace\\_cast<> expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_ConceptSpecializationExpr                        | Expression that references a C++20 concept.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_RequiresExpr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CXXParenListInitExpr                             | Expression that references a C++20 parenthesized list aggregate initializer.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_LastExpr                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FirstStmt                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_UnexposedStmt                                    | A statement whose specific kind is not exposed via this interface.  Unexposed statements have the same operations as any other kind of statement; one can extract their location information, spelling, children, etc. However, the specific kind of the statement is not reported.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_LabelStmt                                        | A labelled statement in a function.  This cursor kind is used to describe the "start\\_over:" label statement in the following example:  ```c++    start_over:      ++counter; ```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_CompoundStmt                                     | A group of statements like { stmt stmt }.  This cursor kind is used to describe compound statements, e.g. function bodies.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_CaseStmt                                         | A case statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_DefaultStmt                                      | A default statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_IfStmt                                           | An if statement                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_SwitchStmt                                       | A switch statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_WhileStmt                                        | A while statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_DoStmt                                           | A do statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ForStmt                                          | A for statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCursor\\_GotoStmt                                         | A goto statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_IndirectGotoStmt                                 | An indirect goto statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_ContinueStmt                                     | A continue statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_BreakStmt                                        | A break statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_ReturnStmt                                       | A return statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_GCCAsmStmt                                       | A GCC inline assembly statement extension.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_AsmStmt                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCAtTryStmt                                    | Objective-C's overall @try-@catch-@finally statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_ObjCAtCatchStmt                                  | Objective-C's @catch statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCAtFinallyStmt                                | Objective-C's @finally statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_ObjCAtThrowStmt                                  | Objective-C's @throw statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCAtSynchronizedStmt                           | Objective-C's @synchronized statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_ObjCAutoreleasePoolStmt                          | Objective-C's autorelease pool statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_ObjCForCollectionStmt                            | Objective-C's collection statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_CXXCatchStmt                                     | C++'s catch statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_CXXTryStmt                                       | C++'s try statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_CXXForRangeStmt                                  | C++'s for (* : *) statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_SEHTryStmt                                       | Windows Structured Exception Handling's try statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_SEHExceptStmt                                    | Windows Structured Exception Handling's except statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_SEHFinallyStmt                                   | Windows Structured Exception Handling's finally statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_MSAsmStmt                                        | A MS inline assembly statement extension.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_NullStmt                                         | The null statement ";": C99 6.8.3p3.  This cursor kind is used to describe the null statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_DeclStmt                                         | Adaptor class for mixing declarations with statements and expressions.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPParallelDirective                             | OpenMP parallel directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPSimdDirective                                 | OpenMP SIMD directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPForDirective                                  | OpenMP for directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_OMPSectionsDirective                             | OpenMP sections directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPSectionDirective                              | OpenMP section directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_OMPSingleDirective                               | OpenMP single directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPParallelForDirective                          | OpenMP parallel for directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_OMPParallelSectionsDirective                     | OpenMP parallel sections directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_OMPTaskDirective                                 | OpenMP task directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPMasterDirective                               | OpenMP master directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPCriticalDirective                             | OpenMP critical directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPTaskyieldDirective                            | OpenMP taskyield directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_OMPBarrierDirective                              | OpenMP barrier directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_OMPTaskwaitDirective                             | OpenMP taskwait directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPFlushDirective                                | OpenMP flush directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_SEHLeaveStmt                                     | Windows Structured Exception Handling's leave statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPOrderedDirective                              | OpenMP ordered directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_OMPAtomicDirective                               | OpenMP atomic directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPForSimdDirective                              | OpenMP for SIMD directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPParallelForSimdDirective                      | OpenMP parallel for SIMD directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_OMPTargetDirective                               | OpenMP target directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPTeamsDirective                                | OpenMP teams directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_OMPTaskgroupDirective                            | OpenMP taskgroup directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_OMPCancellationPointDirective                    | OpenMP cancellation point directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_OMPCancelDirective                               | OpenMP cancel directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPTargetDataDirective                           | OpenMP target data directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| CXCursor\\_OMPTaskLoopDirective                             | OpenMP taskloop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPTaskLoopSimdDirective                         | OpenMP taskloop simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPDistributeDirective                           | OpenMP distribute directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_OMPTargetEnterDataDirective                      | OpenMP target enter data directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_OMPTargetExitDataDirective                       | OpenMP target exit data directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_OMPTargetParallelDirective                       | OpenMP target parallel directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPTargetParallelForDirective                    | OpenMP target parallel for directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_OMPTargetUpdateDirective                         | OpenMP target update directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPDistributeParallelForDirective                | OpenMP distribute parallel for directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_OMPDistributeParallelForSimdDirective            | OpenMP distribute parallel for simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_OMPDistributeSimdDirective                       | OpenMP distribute simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPTargetParallelForSimdDirective                | OpenMP target parallel for simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPTargetSimdDirective                           | OpenMP target simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| CXCursor\\_OMPTeamsDistributeDirective                      | OpenMP teams distribute directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCursor\\_OMPTeamsDistributeSimdDirective                  | OpenMP teams distribute simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_OMPTeamsDistributeParallelForSimdDirective       | OpenMP teams distribute parallel for simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCursor\\_OMPTeamsDistributeParallelForDirective           | OpenMP teams distribute parallel for directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPTargetTeamsDirective                          | OpenMP target teams directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_OMPTargetTeamsDistributeDirective                | OpenMP target teams distribute directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_OMPTargetTeamsDistributeParallelForDirective     | OpenMP target teams distribute parallel for directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPTargetTeamsDistributeParallelForSimdDirective | OpenMP target teams distribute parallel for simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| CXCursor\\_OMPTargetTeamsDistributeSimdDirective            | OpenMP target teams distribute simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_BuiltinBitCastExpr                               | C++2a std::bit\\_cast expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPMasterTaskLoopDirective                       | OpenMP master taskloop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPParallelMasterTaskLoopDirective               | OpenMP parallel master taskloop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPMasterTaskLoopSimdDirective                   | OpenMP master taskloop simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPParallelMasterTaskLoopSimdDirective           | OpenMP parallel master taskloop simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPParallelMasterDirective                       | OpenMP parallel master directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPDepobjDirective                               | OpenMP depobj directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPScanDirective                                 | OpenMP scan directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPTileDirective                                 | OpenMP tile directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPCanonicalLoop                                 | OpenMP canonical loop.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPInteropDirective                              | OpenMP interop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCursor\\_OMPDispatchDirective                             | OpenMP dispatch directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPMaskedDirective                               | OpenMP masked directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPUnrollDirective                               | OpenMP unroll directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| CXCursor\\_OMPMetaDirective                                 | OpenMP metadirective directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPGenericLoopDirective                          | OpenMP loop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPTeamsGenericLoopDirective                     | OpenMP teams loop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_OMPTargetTeamsGenericLoopDirective               | OpenMP target teams loop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_OMPParallelGenericLoopDirective                  | OpenMP parallel loop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPTargetParallelGenericLoopDirective            | OpenMP target parallel loop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPParallelMaskedDirective                       | OpenMP parallel masked directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPMaskedTaskLoopDirective                       | OpenMP masked taskloop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCursor\\_OMPMaskedTaskLoopSimdDirective                   | OpenMP masked taskloop simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_OMPParallelMaskedTaskLoopDirective               | OpenMP parallel masked taskloop directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCursor\\_OMPParallelMaskedTaskLoopSimdDirective           | OpenMP parallel masked taskloop simd directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OMPErrorDirective                                | OpenMP error directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_OMPScopeDirective                                | OpenMP scope directive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCursor\\_LastStmt                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_TranslationUnit                                  | Cursor that represents the translation unit itself.  The translation unit cursor exists primarily to act as the root cursor for traversing the contents of a translation unit.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCursor\\_FirstAttr                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_UnexposedAttr                                    | An attribute whose specific kind is not exposed via this interface.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCursor\\_IBActionAttr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_IBOutletAttr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_IBOutletCollectionAttr                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CXXFinalAttr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CXXOverrideAttr                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_AnnotateAttr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_AsmLabelAttr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_PackedAttr                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_PureAttr                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ConstAttr                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NoDuplicateAttr                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CUDAConstantAttr                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CUDADeviceAttr                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CUDAGlobalAttr                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CUDAHostAttr                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_CUDASharedAttr                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_VisibilityAttr                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_DLLExport                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_DLLImport                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NSReturnsRetained                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NSReturnsNotRetained                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NSReturnsAutoreleased                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NSConsumesSelf                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_NSConsumed                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCException                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCNSObject                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCIndependentClass                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCPreciseLifetime                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCReturnsInnerPointer                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCRequiresSuper                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCRootClass                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCSubclassingRestricted                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCExplicitProtocolImpl                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCDesignatedInitializer                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCRuntimeVisible                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ObjCBoxable                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FlagEnum                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ConvergentAttr                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_WarnUnusedAttr                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_WarnUnusedResultAttr                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_AlignedAttr                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_LastAttr                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_PreprocessingDirective                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_MacroDefinition                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_MacroExpansion                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_MacroInstantiation                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_InclusionDirective                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_FirstPreprocessing                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_LastPreprocessing                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_ModuleImportDecl                                 | A module import declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_TypeAliasTemplateDecl                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_StaticAssert                                     | A static\\_assert or \\_Static\\_assert node                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCursor\\_FriendDecl                                       | a friend declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCursor\\_ConceptDecl                                      | a concept declaration.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCursor\\_FirstExtraDecl                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_LastExtraDecl                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCursor\\_OverloadCandidate                                | A code completion overload candidate.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
"""
@cenum CXCursorKind::UInt32 begin
    CXCursor_UnexposedDecl = 1
    CXCursor_StructDecl = 2
    CXCursor_UnionDecl = 3
    CXCursor_ClassDecl = 4
    CXCursor_EnumDecl = 5
    CXCursor_FieldDecl = 6
    CXCursor_EnumConstantDecl = 7
    CXCursor_FunctionDecl = 8
    CXCursor_VarDecl = 9
    CXCursor_ParmDecl = 10
    CXCursor_ObjCInterfaceDecl = 11
    CXCursor_ObjCCategoryDecl = 12
    CXCursor_ObjCProtocolDecl = 13
    CXCursor_ObjCPropertyDecl = 14
    CXCursor_ObjCIvarDecl = 15
    CXCursor_ObjCInstanceMethodDecl = 16
    CXCursor_ObjCClassMethodDecl = 17
    CXCursor_ObjCImplementationDecl = 18
    CXCursor_ObjCCategoryImplDecl = 19
    CXCursor_TypedefDecl = 20
    CXCursor_CXXMethod = 21
    CXCursor_Namespace = 22
    CXCursor_LinkageSpec = 23
    CXCursor_Constructor = 24
    CXCursor_Destructor = 25
    CXCursor_ConversionFunction = 26
    CXCursor_TemplateTypeParameter = 27
    CXCursor_NonTypeTemplateParameter = 28
    CXCursor_TemplateTemplateParameter = 29
    CXCursor_FunctionTemplate = 30
    CXCursor_ClassTemplate = 31
    CXCursor_ClassTemplatePartialSpecialization = 32
    CXCursor_NamespaceAlias = 33
    CXCursor_UsingDirective = 34
    CXCursor_UsingDeclaration = 35
    CXCursor_TypeAliasDecl = 36
    CXCursor_ObjCSynthesizeDecl = 37
    CXCursor_ObjCDynamicDecl = 38
    CXCursor_CXXAccessSpecifier = 39
    CXCursor_FirstDecl = 1
    CXCursor_LastDecl = 39
    CXCursor_FirstRef = 40
    CXCursor_ObjCSuperClassRef = 40
    CXCursor_ObjCProtocolRef = 41
    CXCursor_ObjCClassRef = 42
    CXCursor_TypeRef = 43
    CXCursor_CXXBaseSpecifier = 44
    CXCursor_TemplateRef = 45
    CXCursor_NamespaceRef = 46
    CXCursor_MemberRef = 47
    CXCursor_LabelRef = 48
    CXCursor_OverloadedDeclRef = 49
    CXCursor_VariableRef = 50
    CXCursor_LastRef = 50
    CXCursor_FirstInvalid = 70
    CXCursor_InvalidFile = 70
    CXCursor_NoDeclFound = 71
    CXCursor_NotImplemented = 72
    CXCursor_InvalidCode = 73
    CXCursor_LastInvalid = 73
    CXCursor_FirstExpr = 100
    CXCursor_UnexposedExpr = 100
    CXCursor_DeclRefExpr = 101
    CXCursor_MemberRefExpr = 102
    CXCursor_CallExpr = 103
    CXCursor_ObjCMessageExpr = 104
    CXCursor_BlockExpr = 105
    CXCursor_IntegerLiteral = 106
    CXCursor_FloatingLiteral = 107
    CXCursor_ImaginaryLiteral = 108
    CXCursor_StringLiteral = 109
    CXCursor_CharacterLiteral = 110
    CXCursor_ParenExpr = 111
    CXCursor_UnaryOperator = 112
    CXCursor_ArraySubscriptExpr = 113
    CXCursor_BinaryOperator = 114
    CXCursor_CompoundAssignOperator = 115
    CXCursor_ConditionalOperator = 116
    CXCursor_CStyleCastExpr = 117
    CXCursor_CompoundLiteralExpr = 118
    CXCursor_InitListExpr = 119
    CXCursor_AddrLabelExpr = 120
    CXCursor_StmtExpr = 121
    CXCursor_GenericSelectionExpr = 122
    CXCursor_GNUNullExpr = 123
    CXCursor_CXXStaticCastExpr = 124
    CXCursor_CXXDynamicCastExpr = 125
    CXCursor_CXXReinterpretCastExpr = 126
    CXCursor_CXXConstCastExpr = 127
    CXCursor_CXXFunctionalCastExpr = 128
    CXCursor_CXXTypeidExpr = 129
    CXCursor_CXXBoolLiteralExpr = 130
    CXCursor_CXXNullPtrLiteralExpr = 131
    CXCursor_CXXThisExpr = 132
    CXCursor_CXXThrowExpr = 133
    CXCursor_CXXNewExpr = 134
    CXCursor_CXXDeleteExpr = 135
    CXCursor_UnaryExpr = 136
    CXCursor_ObjCStringLiteral = 137
    CXCursor_ObjCEncodeExpr = 138
    CXCursor_ObjCSelectorExpr = 139
    CXCursor_ObjCProtocolExpr = 140
    CXCursor_ObjCBridgedCastExpr = 141
    CXCursor_PackExpansionExpr = 142
    CXCursor_SizeOfPackExpr = 143
    CXCursor_LambdaExpr = 144
    CXCursor_ObjCBoolLiteralExpr = 145
    CXCursor_ObjCSelfExpr = 146
    CXCursor_OMPArraySectionExpr = 147
    CXCursor_ObjCAvailabilityCheckExpr = 148
    CXCursor_FixedPointLiteral = 149
    CXCursor_OMPArrayShapingExpr = 150
    CXCursor_OMPIteratorExpr = 151
    CXCursor_CXXAddrspaceCastExpr = 152
    CXCursor_ConceptSpecializationExpr = 153
    CXCursor_RequiresExpr = 154
    CXCursor_CXXParenListInitExpr = 155
    CXCursor_LastExpr = 155
    CXCursor_FirstStmt = 200
    CXCursor_UnexposedStmt = 200
    CXCursor_LabelStmt = 201
    CXCursor_CompoundStmt = 202
    CXCursor_CaseStmt = 203
    CXCursor_DefaultStmt = 204
    CXCursor_IfStmt = 205
    CXCursor_SwitchStmt = 206
    CXCursor_WhileStmt = 207
    CXCursor_DoStmt = 208
    CXCursor_ForStmt = 209
    CXCursor_GotoStmt = 210
    CXCursor_IndirectGotoStmt = 211
    CXCursor_ContinueStmt = 212
    CXCursor_BreakStmt = 213
    CXCursor_ReturnStmt = 214
    CXCursor_GCCAsmStmt = 215
    CXCursor_AsmStmt = 215
    CXCursor_ObjCAtTryStmt = 216
    CXCursor_ObjCAtCatchStmt = 217
    CXCursor_ObjCAtFinallyStmt = 218
    CXCursor_ObjCAtThrowStmt = 219
    CXCursor_ObjCAtSynchronizedStmt = 220
    CXCursor_ObjCAutoreleasePoolStmt = 221
    CXCursor_ObjCForCollectionStmt = 222
    CXCursor_CXXCatchStmt = 223
    CXCursor_CXXTryStmt = 224
    CXCursor_CXXForRangeStmt = 225
    CXCursor_SEHTryStmt = 226
    CXCursor_SEHExceptStmt = 227
    CXCursor_SEHFinallyStmt = 228
    CXCursor_MSAsmStmt = 229
    CXCursor_NullStmt = 230
    CXCursor_DeclStmt = 231
    CXCursor_OMPParallelDirective = 232
    CXCursor_OMPSimdDirective = 233
    CXCursor_OMPForDirective = 234
    CXCursor_OMPSectionsDirective = 235
    CXCursor_OMPSectionDirective = 236
    CXCursor_OMPSingleDirective = 237
    CXCursor_OMPParallelForDirective = 238
    CXCursor_OMPParallelSectionsDirective = 239
    CXCursor_OMPTaskDirective = 240
    CXCursor_OMPMasterDirective = 241
    CXCursor_OMPCriticalDirective = 242
    CXCursor_OMPTaskyieldDirective = 243
    CXCursor_OMPBarrierDirective = 244
    CXCursor_OMPTaskwaitDirective = 245
    CXCursor_OMPFlushDirective = 246
    CXCursor_SEHLeaveStmt = 247
    CXCursor_OMPOrderedDirective = 248
    CXCursor_OMPAtomicDirective = 249
    CXCursor_OMPForSimdDirective = 250
    CXCursor_OMPParallelForSimdDirective = 251
    CXCursor_OMPTargetDirective = 252
    CXCursor_OMPTeamsDirective = 253
    CXCursor_OMPTaskgroupDirective = 254
    CXCursor_OMPCancellationPointDirective = 255
    CXCursor_OMPCancelDirective = 256
    CXCursor_OMPTargetDataDirective = 257
    CXCursor_OMPTaskLoopDirective = 258
    CXCursor_OMPTaskLoopSimdDirective = 259
    CXCursor_OMPDistributeDirective = 260
    CXCursor_OMPTargetEnterDataDirective = 261
    CXCursor_OMPTargetExitDataDirective = 262
    CXCursor_OMPTargetParallelDirective = 263
    CXCursor_OMPTargetParallelForDirective = 264
    CXCursor_OMPTargetUpdateDirective = 265
    CXCursor_OMPDistributeParallelForDirective = 266
    CXCursor_OMPDistributeParallelForSimdDirective = 267
    CXCursor_OMPDistributeSimdDirective = 268
    CXCursor_OMPTargetParallelForSimdDirective = 269
    CXCursor_OMPTargetSimdDirective = 270
    CXCursor_OMPTeamsDistributeDirective = 271
    CXCursor_OMPTeamsDistributeSimdDirective = 272
    CXCursor_OMPTeamsDistributeParallelForSimdDirective = 273
    CXCursor_OMPTeamsDistributeParallelForDirective = 274
    CXCursor_OMPTargetTeamsDirective = 275
    CXCursor_OMPTargetTeamsDistributeDirective = 276
    CXCursor_OMPTargetTeamsDistributeParallelForDirective = 277
    CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective = 278
    CXCursor_OMPTargetTeamsDistributeSimdDirective = 279
    CXCursor_BuiltinBitCastExpr = 280
    CXCursor_OMPMasterTaskLoopDirective = 281
    CXCursor_OMPParallelMasterTaskLoopDirective = 282
    CXCursor_OMPMasterTaskLoopSimdDirective = 283
    CXCursor_OMPParallelMasterTaskLoopSimdDirective = 284
    CXCursor_OMPParallelMasterDirective = 285
    CXCursor_OMPDepobjDirective = 286
    CXCursor_OMPScanDirective = 287
    CXCursor_OMPTileDirective = 288
    CXCursor_OMPCanonicalLoop = 289
    CXCursor_OMPInteropDirective = 290
    CXCursor_OMPDispatchDirective = 291
    CXCursor_OMPMaskedDirective = 292
    CXCursor_OMPUnrollDirective = 293
    CXCursor_OMPMetaDirective = 294
    CXCursor_OMPGenericLoopDirective = 295
    CXCursor_OMPTeamsGenericLoopDirective = 296
    CXCursor_OMPTargetTeamsGenericLoopDirective = 297
    CXCursor_OMPParallelGenericLoopDirective = 298
    CXCursor_OMPTargetParallelGenericLoopDirective = 299
    CXCursor_OMPParallelMaskedDirective = 300
    CXCursor_OMPMaskedTaskLoopDirective = 301
    CXCursor_OMPMaskedTaskLoopSimdDirective = 302
    CXCursor_OMPParallelMaskedTaskLoopDirective = 303
    CXCursor_OMPParallelMaskedTaskLoopSimdDirective = 304
    CXCursor_OMPErrorDirective = 305
    CXCursor_OMPScopeDirective = 306
    CXCursor_LastStmt = 306
    CXCursor_TranslationUnit = 350
    CXCursor_FirstAttr = 400
    CXCursor_UnexposedAttr = 400
    CXCursor_IBActionAttr = 401
    CXCursor_IBOutletAttr = 402
    CXCursor_IBOutletCollectionAttr = 403
    CXCursor_CXXFinalAttr = 404
    CXCursor_CXXOverrideAttr = 405
    CXCursor_AnnotateAttr = 406
    CXCursor_AsmLabelAttr = 407
    CXCursor_PackedAttr = 408
    CXCursor_PureAttr = 409
    CXCursor_ConstAttr = 410
    CXCursor_NoDuplicateAttr = 411
    CXCursor_CUDAConstantAttr = 412
    CXCursor_CUDADeviceAttr = 413
    CXCursor_CUDAGlobalAttr = 414
    CXCursor_CUDAHostAttr = 415
    CXCursor_CUDASharedAttr = 416
    CXCursor_VisibilityAttr = 417
    CXCursor_DLLExport = 418
    CXCursor_DLLImport = 419
    CXCursor_NSReturnsRetained = 420
    CXCursor_NSReturnsNotRetained = 421
    CXCursor_NSReturnsAutoreleased = 422
    CXCursor_NSConsumesSelf = 423
    CXCursor_NSConsumed = 424
    CXCursor_ObjCException = 425
    CXCursor_ObjCNSObject = 426
    CXCursor_ObjCIndependentClass = 427
    CXCursor_ObjCPreciseLifetime = 428
    CXCursor_ObjCReturnsInnerPointer = 429
    CXCursor_ObjCRequiresSuper = 430
    CXCursor_ObjCRootClass = 431
    CXCursor_ObjCSubclassingRestricted = 432
    CXCursor_ObjCExplicitProtocolImpl = 433
    CXCursor_ObjCDesignatedInitializer = 434
    CXCursor_ObjCRuntimeVisible = 435
    CXCursor_ObjCBoxable = 436
    CXCursor_FlagEnum = 437
    CXCursor_ConvergentAttr = 438
    CXCursor_WarnUnusedAttr = 439
    CXCursor_WarnUnusedResultAttr = 440
    CXCursor_AlignedAttr = 441
    CXCursor_LastAttr = 441
    CXCursor_PreprocessingDirective = 500
    CXCursor_MacroDefinition = 501
    CXCursor_MacroExpansion = 502
    CXCursor_MacroInstantiation = 502
    CXCursor_InclusionDirective = 503
    CXCursor_FirstPreprocessing = 500
    CXCursor_LastPreprocessing = 503
    CXCursor_ModuleImportDecl = 600
    CXCursor_TypeAliasTemplateDecl = 601
    CXCursor_StaticAssert = 602
    CXCursor_FriendDecl = 603
    CXCursor_ConceptDecl = 604
    CXCursor_FirstExtraDecl = 600
    CXCursor_LastExtraDecl = 604
    CXCursor_OverloadCandidate = 700
end

"""
    CXCursor

A cursor representing some element in the abstract syntax tree for a translation unit.

The cursor abstraction unifies the different kinds of entities in a program--declaration, statements, expressions, references to declarations, etc.--under a single "cursor" abstraction with a common set of operations. Common operation for a cursor include: getting the physical location in a source file where the cursor points, getting the name associated with a cursor, and retrieving cursors for any child nodes of a particular cursor.

Cursors can be produced in two specific ways. [`clang_getTranslationUnitCursor`](@ref)() produces a cursor for a translation unit, from which one can use [`clang_visitChildren`](@ref)() to explore the rest of the translation unit. [`clang_getCursor`](@ref)() maps from a physical source location to the entity that resides at that location, allowing one to map from the source code into the AST.
"""
struct CXCursor
    kind::CXCursorKind
    xdata::Cint
    data::NTuple{3, Ptr{Cvoid}}
end

"""
    clang_getNullCursor()

Retrieve the NULL cursor, which represents no entity.
"""
function clang_getNullCursor()
    @ccall libclang.clang_getNullCursor()::CXCursor
end

"""
    clang_getTranslationUnitCursor(arg1)

Retrieve the cursor that represents the given translation unit.

The translation unit cursor can be used to start traversing the various declarations within the given translation unit.
"""
function clang_getTranslationUnitCursor(arg1)
    @ccall libclang.clang_getTranslationUnitCursor(arg1::CXTranslationUnit)::CXCursor
end

"""
    clang_equalCursors(arg1, arg2)

Determine whether two cursors are equivalent.
"""
function clang_equalCursors(arg1, arg2)
    @ccall libclang.clang_equalCursors(arg1::CXCursor, arg2::CXCursor)::Cuint
end

"""
    clang_Cursor_isNull(cursor)

Returns non-zero if `cursor` is null.
"""
function clang_Cursor_isNull(cursor)
    @ccall libclang.clang_Cursor_isNull(cursor::CXCursor)::Cint
end

"""
    clang_hashCursor(arg1)

Compute a hash value for the given cursor.
"""
function clang_hashCursor(arg1)
    @ccall libclang.clang_hashCursor(arg1::CXCursor)::Cuint
end

"""
    clang_getCursorKind(arg1)

Retrieve the kind of the given cursor.
"""
function clang_getCursorKind(arg1)
    @ccall libclang.clang_getCursorKind(arg1::CXCursor)::CXCursorKind
end

"""
    clang_isDeclaration(arg1)

Determine whether the given cursor kind represents a declaration.
"""
function clang_isDeclaration(arg1)
    @ccall libclang.clang_isDeclaration(arg1::CXCursorKind)::Cuint
end

"""
    clang_isInvalidDeclaration(arg1)

Determine whether the given declaration is invalid.

A declaration is invalid if it could not be parsed successfully.

# Returns
non-zero if the cursor represents a declaration and it is invalid, otherwise NULL.
"""
function clang_isInvalidDeclaration(arg1)
    @ccall libclang.clang_isInvalidDeclaration(arg1::CXCursor)::Cuint
end

"""
    clang_isReference(arg1)

Determine whether the given cursor kind represents a simple reference.

Note that other kinds of cursors (such as expressions) can also refer to other cursors. Use [`clang_getCursorReferenced`](@ref)() to determine whether a particular cursor refers to another entity.
"""
function clang_isReference(arg1)
    @ccall libclang.clang_isReference(arg1::CXCursorKind)::Cuint
end

"""
    clang_isExpression(arg1)

Determine whether the given cursor kind represents an expression.
"""
function clang_isExpression(arg1)
    @ccall libclang.clang_isExpression(arg1::CXCursorKind)::Cuint
end

"""
    clang_isStatement(arg1)

Determine whether the given cursor kind represents a statement.
"""
function clang_isStatement(arg1)
    @ccall libclang.clang_isStatement(arg1::CXCursorKind)::Cuint
end

"""
    clang_isAttribute(arg1)

Determine whether the given cursor kind represents an attribute.
"""
function clang_isAttribute(arg1)
    @ccall libclang.clang_isAttribute(arg1::CXCursorKind)::Cuint
end

"""
    clang_Cursor_hasAttrs(C)

Determine whether the given cursor has any attributes.
"""
function clang_Cursor_hasAttrs(C)
    @ccall libclang.clang_Cursor_hasAttrs(C::CXCursor)::Cuint
end

"""
    clang_isInvalid(arg1)

Determine whether the given cursor kind represents an invalid cursor.
"""
function clang_isInvalid(arg1)
    @ccall libclang.clang_isInvalid(arg1::CXCursorKind)::Cuint
end

"""
    clang_isTranslationUnit(arg1)

Determine whether the given cursor kind represents a translation unit.
"""
function clang_isTranslationUnit(arg1)
    @ccall libclang.clang_isTranslationUnit(arg1::CXCursorKind)::Cuint
end

"""
    clang_isPreprocessing(arg1)

* Determine whether the given cursor represents a preprocessing element, such as a preprocessor directive or macro instantiation.
"""
function clang_isPreprocessing(arg1)
    @ccall libclang.clang_isPreprocessing(arg1::CXCursorKind)::Cuint
end

"""
    clang_isUnexposed(arg1)

* Determine whether the given cursor represents a currently unexposed piece of the AST (e.g., CXCursor\\_UnexposedStmt).
"""
function clang_isUnexposed(arg1)
    @ccall libclang.clang_isUnexposed(arg1::CXCursorKind)::Cuint
end

"""
    CXLinkageKind

Describe the linkage of the entity referred to by a cursor.

| Enumerator                 | Note                                                                                                                                    |
| :------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| CXLinkage\\_Invalid        | This value indicates that no linkage information is available for a provided [`CXCursor`](@ref).                                        |
| CXLinkage\\_NoLinkage      | This is the linkage for variables, parameters, and so on that have automatic storage. This covers normal (non-extern) local variables.  |
| CXLinkage\\_Internal       | This is the linkage for static variables and static functions.                                                                          |
| CXLinkage\\_UniqueExternal | This is the linkage for entities with external linkage that live in C++ anonymous namespaces.                                           |
| CXLinkage\\_External       | This is the linkage for entities with true, external linkage.                                                                           |
"""
@cenum CXLinkageKind::UInt32 begin
    CXLinkage_Invalid = 0
    CXLinkage_NoLinkage = 1
    CXLinkage_Internal = 2
    CXLinkage_UniqueExternal = 3
    CXLinkage_External = 4
end

"""
    clang_getCursorLinkage(cursor)

Determine the linkage of the entity referred to by a given cursor.
"""
function clang_getCursorLinkage(cursor)
    @ccall libclang.clang_getCursorLinkage(cursor::CXCursor)::CXLinkageKind
end

"""
    CXVisibilityKind

| Enumerator               | Note                                                                                                 |
| :----------------------- | :--------------------------------------------------------------------------------------------------- |
| CXVisibility\\_Invalid   | This value indicates that no visibility information is available for a provided [`CXCursor`](@ref).  |
| CXVisibility\\_Hidden    | Symbol not seen by the linker.                                                                       |
| CXVisibility\\_Protected | Symbol seen by the linker but resolves to a symbol inside this object.                               |
| CXVisibility\\_Default   | Symbol seen by the linker and acts like a normal symbol.                                             |
"""
@cenum CXVisibilityKind::UInt32 begin
    CXVisibility_Invalid = 0
    CXVisibility_Hidden = 1
    CXVisibility_Protected = 2
    CXVisibility_Default = 3
end

"""
    clang_getCursorVisibility(cursor)

Describe the visibility of the entity referred to by a cursor.

This returns the default visibility if not explicitly specified by a visibility attribute. The default visibility may be changed by commandline arguments.

# Arguments
* `cursor`: The cursor to query.
# Returns
The visibility of the cursor.
"""
function clang_getCursorVisibility(cursor)
    @ccall libclang.clang_getCursorVisibility(cursor::CXCursor)::CXVisibilityKind
end

"""
    clang_getCursorAvailability(cursor)

Determine the availability of the entity that this cursor refers to, taking the current target platform into account.

# Arguments
* `cursor`: The cursor to query.
# Returns
The availability of the cursor.
"""
function clang_getCursorAvailability(cursor)
    @ccall libclang.clang_getCursorAvailability(cursor::CXCursor)::CXAvailabilityKind
end

"""
    CXPlatformAvailability

Describes the availability of a given entity on a particular platform, e.g., a particular class might only be available on Mac OS 10.7 or newer.

| Field       | Note                                                                                                                                     |
| :---------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| Platform    | A string that describes the platform for which this structure provides availability information.  Possible values are "ios" or "macos".  |
| Introduced  | The version number in which this entity was introduced.                                                                                  |
| Deprecated  | The version number in which this entity was deprecated (but is still available).                                                         |
| Obsoleted   | The version number in which this entity was obsoleted, and therefore is no longer available.                                             |
| Unavailable | Whether the entity is unconditionally unavailable on this platform.                                                                      |
| Message     | An optional message to provide to a user of this API, e.g., to suggest replacement APIs.                                                 |
"""
struct CXPlatformAvailability
    Platform::CXString
    Introduced::CXVersion
    Deprecated::CXVersion
    Obsoleted::CXVersion
    Unavailable::Cint
    Message::CXString
end

"""
    clang_getCursorPlatformAvailability(cursor, always_deprecated, deprecated_message, always_unavailable, unavailable_message, availability, availability_size)

Determine the availability of the entity that this cursor refers to on any platforms for which availability information is known.

Note that the client is responsible for calling [`clang_disposeCXPlatformAvailability`](@ref) to free each of the platform-availability structures returned. There are `min`(N, availability\\_size) such structures.

# Arguments
* `cursor`: The cursor to query.
* `always_deprecated`: If non-NULL, will be set to indicate whether the entity is deprecated on all platforms.
* `deprecated_message`: If non-NULL, will be set to the message text provided along with the unconditional deprecation of this entity. The client is responsible for deallocating this string.
* `always_unavailable`: If non-NULL, will be set to indicate whether the entity is unavailable on all platforms.
* `unavailable_message`: If non-NULL, will be set to the message text provided along with the unconditional unavailability of this entity. The client is responsible for deallocating this string.
* `availability`: If non-NULL, an array of [`CXPlatformAvailability`](@ref) instances that will be populated with platform availability information, up to either the number of platforms for which availability information is available (as returned by this function) or `availability_size`, whichever is smaller.
* `availability_size`: The number of elements available in the `availability` array.
# Returns
The number of platforms (N) for which availability information is available (which is unrelated to `availability_size`).
"""
function clang_getCursorPlatformAvailability(cursor, always_deprecated, deprecated_message, always_unavailable, unavailable_message, availability, availability_size)
    @ccall libclang.clang_getCursorPlatformAvailability(cursor::CXCursor, always_deprecated::Ptr{Cint}, deprecated_message::Ptr{CXString}, always_unavailable::Ptr{Cint}, unavailable_message::Ptr{CXString}, availability::Ptr{CXPlatformAvailability}, availability_size::Cint)::Cint
end

"""
    clang_disposeCXPlatformAvailability(availability)

Free the memory associated with a [`CXPlatformAvailability`](@ref) structure.
"""
function clang_disposeCXPlatformAvailability(availability)
    @ccall libclang.clang_disposeCXPlatformAvailability(availability::Ptr{CXPlatformAvailability})::Cvoid
end

"""
    clang_Cursor_getVarDeclInitializer(cursor)

If cursor refers to a variable declaration and it has initializer returns cursor referring to the initializer otherwise return null cursor.
"""
function clang_Cursor_getVarDeclInitializer(cursor)
    @ccall libclang.clang_Cursor_getVarDeclInitializer(cursor::CXCursor)::CXCursor
end

"""
    clang_Cursor_hasVarDeclGlobalStorage(cursor)

If cursor refers to a variable declaration that has global storage returns 1. If cursor refers to a variable declaration that doesn't have global storage returns 0. Otherwise returns -1.
"""
function clang_Cursor_hasVarDeclGlobalStorage(cursor)
    @ccall libclang.clang_Cursor_hasVarDeclGlobalStorage(cursor::CXCursor)::Cint
end

"""
    clang_Cursor_hasVarDeclExternalStorage(cursor)

If cursor refers to a variable declaration that has external storage returns 1. If cursor refers to a variable declaration that doesn't have external storage returns 0. Otherwise returns -1.
"""
function clang_Cursor_hasVarDeclExternalStorage(cursor)
    @ccall libclang.clang_Cursor_hasVarDeclExternalStorage(cursor::CXCursor)::Cint
end

"""
    CXLanguageKind

Describe the "language" of the entity referred to by a cursor.
"""
@cenum CXLanguageKind::UInt32 begin
    CXLanguage_Invalid = 0
    CXLanguage_C = 1
    CXLanguage_ObjC = 2
    CXLanguage_CPlusPlus = 3
end

"""
    clang_getCursorLanguage(cursor)

Determine the "language" of the entity referred to by a given cursor.
"""
function clang_getCursorLanguage(cursor)
    @ccall libclang.clang_getCursorLanguage(cursor::CXCursor)::CXLanguageKind
end

"""
    CXTLSKind

Describe the "thread-local storage (TLS) kind" of the declaration referred to by a cursor.
"""
@cenum CXTLSKind::UInt32 begin
    CXTLS_None = 0
    CXTLS_Dynamic = 1
    CXTLS_Static = 2
end

"""
    clang_getCursorTLSKind(cursor)

Determine the "thread-local storage (TLS) kind" of the declaration referred to by a cursor.
"""
function clang_getCursorTLSKind(cursor)
    @ccall libclang.clang_getCursorTLSKind(cursor::CXCursor)::CXTLSKind
end

"""
    clang_Cursor_getTranslationUnit(arg1)

Returns the translation unit that a cursor originated from.
"""
function clang_Cursor_getTranslationUnit(arg1)
    @ccall libclang.clang_Cursor_getTranslationUnit(arg1::CXCursor)::CXTranslationUnit
end

mutable struct CXCursorSetImpl end

"""
A fast container representing a set of CXCursors.
"""
const CXCursorSet = Ptr{CXCursorSetImpl}

"""
    clang_createCXCursorSet()

Creates an empty [`CXCursorSet`](@ref).
"""
function clang_createCXCursorSet()
    @ccall libclang.clang_createCXCursorSet()::CXCursorSet
end

"""
    clang_disposeCXCursorSet(cset)

Disposes a [`CXCursorSet`](@ref) and releases its associated memory.
"""
function clang_disposeCXCursorSet(cset)
    @ccall libclang.clang_disposeCXCursorSet(cset::CXCursorSet)::Cvoid
end

"""
    clang_CXCursorSet_contains(cset, cursor)

Queries a [`CXCursorSet`](@ref) to see if it contains a specific [`CXCursor`](@ref).

# Returns
non-zero if the set contains the specified cursor.
"""
function clang_CXCursorSet_contains(cset, cursor)
    @ccall libclang.clang_CXCursorSet_contains(cset::CXCursorSet, cursor::CXCursor)::Cuint
end

"""
    clang_CXCursorSet_insert(cset, cursor)

Inserts a [`CXCursor`](@ref) into a [`CXCursorSet`](@ref).

# Returns
zero if the [`CXCursor`](@ref) was already in the set, and non-zero otherwise.
"""
function clang_CXCursorSet_insert(cset, cursor)
    @ccall libclang.clang_CXCursorSet_insert(cset::CXCursorSet, cursor::CXCursor)::Cuint
end

"""
    clang_getCursorSemanticParent(cursor)

Determine the semantic parent of the given cursor.

The semantic parent of a cursor is the cursor that semantically contains the given `cursor`. For many declarations, the lexical and semantic parents are equivalent (the lexical parent is returned by [`clang_getCursorLexicalParent`](@ref)()). They diverge when declarations or definitions are provided out-of-line. For example:

```c++
 class C {
  void f();
 };
 void C::f() { }
```

In the out-of-line definition of `C`::f, the semantic parent is the class `C`, of which this function is a member. The lexical parent is the place where the declaration actually occurs in the source code; in this case, the definition occurs in the translation unit. In general, the lexical parent for a given entity can change without affecting the semantics of the program, and the lexical parent of different declarations of the same entity may be different. Changing the semantic parent of a declaration, on the other hand, can have a major impact on semantics, and redeclarations of a particular entity should all have the same semantic context.

In the example above, both declarations of `C`::f have `C` as their semantic context, while the lexical context of the first `C`::f is `C` and the lexical context of the second `C`::f is the translation unit.

For global declarations, the semantic parent is the translation unit.
"""
function clang_getCursorSemanticParent(cursor)
    @ccall libclang.clang_getCursorSemanticParent(cursor::CXCursor)::CXCursor
end

"""
    clang_getCursorLexicalParent(cursor)

Determine the lexical parent of the given cursor.

The lexical parent of a cursor is the cursor in which the given `cursor` was actually written. For many declarations, the lexical and semantic parents are equivalent (the semantic parent is returned by [`clang_getCursorSemanticParent`](@ref)()). They diverge when declarations or definitions are provided out-of-line. For example:

```c++
 class C {
  void f();
 };
 void C::f() { }
```

In the out-of-line definition of `C`::f, the semantic parent is the class `C`, of which this function is a member. The lexical parent is the place where the declaration actually occurs in the source code; in this case, the definition occurs in the translation unit. In general, the lexical parent for a given entity can change without affecting the semantics of the program, and the lexical parent of different declarations of the same entity may be different. Changing the semantic parent of a declaration, on the other hand, can have a major impact on semantics, and redeclarations of a particular entity should all have the same semantic context.

In the example above, both declarations of `C`::f have `C` as their semantic context, while the lexical context of the first `C`::f is `C` and the lexical context of the second `C`::f is the translation unit.

For declarations written in the global scope, the lexical parent is the translation unit.
"""
function clang_getCursorLexicalParent(cursor)
    @ccall libclang.clang_getCursorLexicalParent(cursor::CXCursor)::CXCursor
end

"""
    clang_getOverriddenCursors(cursor, overridden, num_overridden)

Determine the set of methods that are overridden by the given method.

In both Objective-C and C++, a method (aka virtual member function, in C++) can override a virtual method in a base class. For Objective-C, a method is said to override any method in the class's base class, its protocols, or its categories' protocols, that has the same selector and is of the same kind (class or instance). If no such method exists, the search continues to the class's superclass, its protocols, and its categories, and so on. A method from an Objective-C implementation is considered to override the same methods as its corresponding method in the interface.

For C++, a virtual member function overrides any virtual member function with the same signature that occurs in its base classes. With multiple inheritance, a virtual member function can override several virtual member functions coming from different base classes.

In all cases, this function determines the immediate overridden method, rather than all of the overridden methods. For example, if a method is originally declared in a class A, then overridden in B (which in inherits from A) and also in C (which inherited from B), then the only overridden method returned from this function when invoked on C's method will be B's method. The client may then invoke this function again, given the previously-found overridden methods, to map out the complete method-override set.

# Arguments
* `cursor`: A cursor representing an Objective-C or C++ method. This routine will compute the set of methods that this method overrides.
* `overridden`: A pointer whose pointee will be replaced with a pointer to an array of cursors, representing the set of overridden methods. If there are no overridden methods, the pointee will be set to NULL. The pointee must be freed via a call to [`clang_disposeOverriddenCursors`](@ref)().
* `num_overridden`: A pointer to the number of overridden functions, will be set to the number of overridden functions in the array pointed to by `overridden`.
"""
function clang_getOverriddenCursors(cursor, overridden, num_overridden)
    @ccall libclang.clang_getOverriddenCursors(cursor::CXCursor, overridden::Ptr{Ptr{CXCursor}}, num_overridden::Ptr{Cuint})::Cvoid
end

"""
    clang_disposeOverriddenCursors(overridden)

Free the set of overridden cursors returned by [`clang_getOverriddenCursors`](@ref)().
"""
function clang_disposeOverriddenCursors(overridden)
    @ccall libclang.clang_disposeOverriddenCursors(overridden::Ptr{CXCursor})::Cvoid
end

"""
    clang_getIncludedFile(cursor)

Retrieve the file that is included by the given inclusion directive cursor.
"""
function clang_getIncludedFile(cursor)
    @ccall libclang.clang_getIncludedFile(cursor::CXCursor)::CXFile
end

"""
    clang_getCursor(arg1, arg2)

Map a source location to the cursor that describes the entity at that location in the source code.

[`clang_getCursor`](@ref)() maps an arbitrary source location within a translation unit down to the most specific cursor that describes the entity at that location. For example, given an expression `x` + y, invoking [`clang_getCursor`](@ref)() with a source location pointing to "x" will return the cursor for "x"; similarly for "y". If the cursor points anywhere between "x" or "y" (e.g., on the + or the whitespace around it), [`clang_getCursor`](@ref)() will return a cursor referring to the "+" expression.

# Returns
a cursor representing the entity at the given source location, or a NULL cursor if no such entity can be found.
"""
function clang_getCursor(arg1, arg2)
    @ccall libclang.clang_getCursor(arg1::CXTranslationUnit, arg2::CXSourceLocation)::CXCursor
end

"""
    clang_getCursorLocation(arg1)

Retrieve the physical location of the source constructor referenced by the given cursor.

The location of a declaration is typically the location of the name of that declaration, where the name of that declaration would occur if it is unnamed, or some keyword that introduces that particular declaration. The location of a reference is where that reference occurs within the source code.
"""
function clang_getCursorLocation(arg1)
    @ccall libclang.clang_getCursorLocation(arg1::CXCursor)::CXSourceLocation
end

"""
    clang_getCursorExtent(arg1)

Retrieve the physical extent of the source construct referenced by the given cursor.

The extent of a cursor starts with the file/line/column pointing at the first character within the source construct that the cursor refers to and ends with the last character within that source construct. For a declaration, the extent covers the declaration itself. For a reference, the extent covers the location of the reference (e.g., where the referenced entity was actually used).
"""
function clang_getCursorExtent(arg1)
    @ccall libclang.clang_getCursorExtent(arg1::CXCursor)::CXSourceRange
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
| CXType\\_FirstBuiltin                                         |                                                                                                                                                |
| CXType\\_LastBuiltin                                          |                                                                                                                                                |
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
| CXType\\_OCLIntelSubgroupAVCImeResultSingleReferenceStreamout |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeResultDualReferenceStreamout   |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeSingleReferenceStreamin        |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeDualReferenceStreamin          |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeResultSingleRefStreamout       |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeResultDualRefStreamout         |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeSingleRefStreamin              |                                                                                                                                                |
| CXType\\_OCLIntelSubgroupAVCImeDualRefStreamin                |                                                                                                                                                |
| CXType\\_ExtVector                                            |                                                                                                                                                |
| CXType\\_Atomic                                               |                                                                                                                                                |
| CXType\\_BTFTagAttributed                                     |                                                                                                                                                |
"""
@cenum CXTypeKind::UInt32 begin
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
    CXType_FirstBuiltin = 2
    CXType_LastBuiltin = 40
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
    CXType_OCLIntelSubgroupAVCImeResultSingleReferenceStreamout = 172
    CXType_OCLIntelSubgroupAVCImeResultDualReferenceStreamout = 173
    CXType_OCLIntelSubgroupAVCImeSingleReferenceStreamin = 174
    CXType_OCLIntelSubgroupAVCImeDualReferenceStreamin = 175
    CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout = 172
    CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout = 173
    CXType_OCLIntelSubgroupAVCImeSingleRefStreamin = 174
    CXType_OCLIntelSubgroupAVCImeDualRefStreamin = 175
    CXType_ExtVector = 176
    CXType_Atomic = 177
    CXType_BTFTagAttributed = 178
end

"""
    CXCallingConv

Describes the calling convention of a function type
"""
@cenum CXCallingConv::UInt32 begin
    CXCallingConv_Default = 0
    CXCallingConv_C = 1
    CXCallingConv_X86StdCall = 2
    CXCallingConv_X86FastCall = 3
    CXCallingConv_X86ThisCall = 4
    CXCallingConv_X86Pascal = 5
    CXCallingConv_AAPCS = 6
    CXCallingConv_AAPCS_VFP = 7
    CXCallingConv_X86RegCall = 8
    CXCallingConv_IntelOclBicc = 9
    CXCallingConv_Win64 = 10
    CXCallingConv_X86_64Win64 = 10
    CXCallingConv_X86_64SysV = 11
    CXCallingConv_X86VectorCall = 12
    CXCallingConv_Swift = 13
    CXCallingConv_PreserveMost = 14
    CXCallingConv_PreserveAll = 15
    CXCallingConv_AArch64VectorCall = 16
    CXCallingConv_SwiftAsync = 17
    CXCallingConv_AArch64SVEPCS = 18
    CXCallingConv_M68kRTD = 19
    CXCallingConv_Invalid = 100
    CXCallingConv_Unexposed = 200
end

"""
    CXType

The type of an element in the abstract syntax tree.
"""
struct CXType
    kind::CXTypeKind
    data::NTuple{2, Ptr{Cvoid}}
end

"""
    clang_getCursorType(C)

Retrieve the type of a [`CXCursor`](@ref) (if any).
"""
function clang_getCursorType(C)
    @ccall libclang.clang_getCursorType(C::CXCursor)::CXType
end

"""
    clang_getTypeSpelling(CT)

Pretty-print the underlying type using the rules of the language of the translation unit from which it came.

If the type is invalid, an empty string is returned.
"""
function clang_getTypeSpelling(CT)
    @ccall libclang.clang_getTypeSpelling(CT::CXType)::CXString
end

"""
    clang_getTypedefDeclUnderlyingType(C)

Retrieve the underlying type of a typedef declaration.

If the cursor does not reference a typedef declaration, an invalid type is returned.
"""
function clang_getTypedefDeclUnderlyingType(C)
    @ccall libclang.clang_getTypedefDeclUnderlyingType(C::CXCursor)::CXType
end

"""
    clang_getEnumDeclIntegerType(C)

Retrieve the integer type of an enum declaration.

If the cursor does not reference an enum declaration, an invalid type is returned.
"""
function clang_getEnumDeclIntegerType(C)
    @ccall libclang.clang_getEnumDeclIntegerType(C::CXCursor)::CXType
end

"""
    clang_getEnumConstantDeclValue(C)

Retrieve the integer value of an enum constant declaration as a signed long long.

If the cursor does not reference an enum constant declaration, LLONG\\_MIN is returned. Since this is also potentially a valid constant value, the kind of the cursor must be verified before calling this function.
"""
function clang_getEnumConstantDeclValue(C)
    @ccall libclang.clang_getEnumConstantDeclValue(C::CXCursor)::Clonglong
end

"""
    clang_getEnumConstantDeclUnsignedValue(C)

Retrieve the integer value of an enum constant declaration as an unsigned long long.

If the cursor does not reference an enum constant declaration, ULLONG\\_MAX is returned. Since this is also potentially a valid constant value, the kind of the cursor must be verified before calling this function.
"""
function clang_getEnumConstantDeclUnsignedValue(C)
    @ccall libclang.clang_getEnumConstantDeclUnsignedValue(C::CXCursor)::Culonglong
end

"""
    clang_Cursor_isBitField(C)

Returns non-zero if the cursor specifies a Record member that is a bit-field.
"""
function clang_Cursor_isBitField(C)
    @ccall libclang.clang_Cursor_isBitField(C::CXCursor)::Cuint
end

"""
    clang_getFieldDeclBitWidth(C)

Retrieve the bit width of a bit-field declaration as an integer.

If the cursor does not reference a bit-field, or if the bit-field's width expression cannot be evaluated, -1 is returned.

For example:

```c++
 if (clang_Cursor_isBitField(Cursor)) {
   int Width = clang_getFieldDeclBitWidth(Cursor);
   if (Width != -1) {
     // The bit-field width is not value-dependent.
   }
 }
```
"""
function clang_getFieldDeclBitWidth(C)
    @ccall libclang.clang_getFieldDeclBitWidth(C::CXCursor)::Cint
end

"""
    clang_Cursor_getNumArguments(C)

Retrieve the number of non-variadic arguments associated with a given cursor.

The number of arguments can be determined for calls as well as for declarations of functions or methods. For other cursors -1 is returned.
"""
function clang_Cursor_getNumArguments(C)
    @ccall libclang.clang_Cursor_getNumArguments(C::CXCursor)::Cint
end

"""
    clang_Cursor_getArgument(C, i)

Retrieve the argument cursor of a function or method.

The argument cursor can be determined for calls as well as for declarations of functions or methods. For other cursors and for invalid indices, an invalid cursor is returned.
"""
function clang_Cursor_getArgument(C, i)
    @ccall libclang.clang_Cursor_getArgument(C::CXCursor, i::Cuint)::CXCursor
end

"""
    CXTemplateArgumentKind

Describes the kind of a template argument.

See the definition of llvm::clang::TemplateArgument::ArgKind for full element descriptions.
"""
@cenum CXTemplateArgumentKind::UInt32 begin
    CXTemplateArgumentKind_Null = 0
    CXTemplateArgumentKind_Type = 1
    CXTemplateArgumentKind_Declaration = 2
    CXTemplateArgumentKind_NullPtr = 3
    CXTemplateArgumentKind_Integral = 4
    CXTemplateArgumentKind_Template = 5
    CXTemplateArgumentKind_TemplateExpansion = 6
    CXTemplateArgumentKind_Expression = 7
    CXTemplateArgumentKind_Pack = 8
    CXTemplateArgumentKind_Invalid = 9
end

"""
    clang_Cursor_getNumTemplateArguments(C)

Returns the number of template args of a function, struct, or class decl representing a template specialization.

If the argument cursor cannot be converted into a template function declaration, -1 is returned.

For example, for the following declaration and specialization: template <typename T, int kInt, bool kBool> void foo() { ... }

template <> void foo<float, -7, true>();

The value 3 would be returned from this call.
"""
function clang_Cursor_getNumTemplateArguments(C)
    @ccall libclang.clang_Cursor_getNumTemplateArguments(C::CXCursor)::Cint
end

"""
    clang_Cursor_getTemplateArgumentKind(C, I)

Retrieve the kind of the I'th template argument of the [`CXCursor`](@ref) C.

If the argument [`CXCursor`](@ref) does not represent a FunctionDecl, StructDecl, or ClassTemplatePartialSpecialization, an invalid template argument kind is returned.

For example, for the following declaration and specialization: template <typename T, int kInt, bool kBool> void foo() { ... }

template <> void foo<float, -7, true>();

For I = 0, 1, and 2, Type, Integral, and Integral will be returned, respectively.
"""
function clang_Cursor_getTemplateArgumentKind(C, I)
    @ccall libclang.clang_Cursor_getTemplateArgumentKind(C::CXCursor, I::Cuint)::CXTemplateArgumentKind
end

"""
    clang_Cursor_getTemplateArgumentType(C, I)

Retrieve a [`CXType`](@ref) representing the type of a TemplateArgument of a function decl representing a template specialization.

If the argument [`CXCursor`](@ref) does not represent a FunctionDecl, StructDecl, ClassDecl or ClassTemplatePartialSpecialization whose I'th template argument has a kind of CXTemplateArgKind\\_Integral, an invalid type is returned.

For example, for the following declaration and specialization: template <typename T, int kInt, bool kBool> void foo() { ... }

template <> void foo<float, -7, true>();

If called with I = 0, "float", will be returned. Invalid types will be returned for I == 1 or 2.
"""
function clang_Cursor_getTemplateArgumentType(C, I)
    @ccall libclang.clang_Cursor_getTemplateArgumentType(C::CXCursor, I::Cuint)::CXType
end

"""
    clang_Cursor_getTemplateArgumentValue(C, I)

Retrieve the value of an Integral TemplateArgument (of a function decl representing a template specialization) as a signed long long.

It is undefined to call this function on a [`CXCursor`](@ref) that does not represent a FunctionDecl, StructDecl, ClassDecl or ClassTemplatePartialSpecialization whose I'th template argument is not an integral value.

For example, for the following declaration and specialization: template <typename T, int kInt, bool kBool> void foo() { ... }

template <> void foo<float, -7, true>();

If called with I = 1 or 2, -7 or true will be returned, respectively. For I == 0, this function's behavior is undefined.
"""
function clang_Cursor_getTemplateArgumentValue(C, I)
    @ccall libclang.clang_Cursor_getTemplateArgumentValue(C::CXCursor, I::Cuint)::Clonglong
end

"""
    clang_Cursor_getTemplateArgumentUnsignedValue(C, I)

Retrieve the value of an Integral TemplateArgument (of a function decl representing a template specialization) as an unsigned long long.

It is undefined to call this function on a [`CXCursor`](@ref) that does not represent a FunctionDecl, StructDecl, ClassDecl or ClassTemplatePartialSpecialization or whose I'th template argument is not an integral value.

For example, for the following declaration and specialization: template <typename T, int kInt, bool kBool> void foo() { ... }

template <> void foo<float, 2147483649, true>();

If called with I = 1 or 2, 2147483649 or true will be returned, respectively. For I == 0, this function's behavior is undefined.
"""
function clang_Cursor_getTemplateArgumentUnsignedValue(C, I)
    @ccall libclang.clang_Cursor_getTemplateArgumentUnsignedValue(C::CXCursor, I::Cuint)::Culonglong
end

"""
    clang_equalTypes(A, B)

Determine whether two CXTypes represent the same type.

# Returns
non-zero if the CXTypes represent the same type and zero otherwise.
"""
function clang_equalTypes(A, B)
    @ccall libclang.clang_equalTypes(A::CXType, B::CXType)::Cuint
end

"""
    clang_getCanonicalType(T)

Return the canonical type for a [`CXType`](@ref).

Clang's type system explicitly models typedefs and all the ways a specific type can be represented. The canonical type is the underlying type with all the "sugar" removed. For example, if 'T' is a typedef for 'int', the canonical type for 'T' would be 'int'.
"""
function clang_getCanonicalType(T)
    @ccall libclang.clang_getCanonicalType(T::CXType)::CXType
end

"""
    clang_isConstQualifiedType(T)

Determine whether a [`CXType`](@ref) has the "const" qualifier set, without looking through typedefs that may have added "const" at a different level.
"""
function clang_isConstQualifiedType(T)
    @ccall libclang.clang_isConstQualifiedType(T::CXType)::Cuint
end

"""
    clang_Cursor_isMacroFunctionLike(C)

Determine whether a [`CXCursor`](@ref) that is a macro, is function like.
"""
function clang_Cursor_isMacroFunctionLike(C)
    @ccall libclang.clang_Cursor_isMacroFunctionLike(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isMacroBuiltin(C)

Determine whether a [`CXCursor`](@ref) that is a macro, is a builtin one.
"""
function clang_Cursor_isMacroBuiltin(C)
    @ccall libclang.clang_Cursor_isMacroBuiltin(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isFunctionInlined(C)

Determine whether a [`CXCursor`](@ref) that is a function declaration, is an inline declaration.
"""
function clang_Cursor_isFunctionInlined(C)
    @ccall libclang.clang_Cursor_isFunctionInlined(C::CXCursor)::Cuint
end

"""
    clang_isVolatileQualifiedType(T)

Determine whether a [`CXType`](@ref) has the "volatile" qualifier set, without looking through typedefs that may have added "volatile" at a different level.
"""
function clang_isVolatileQualifiedType(T)
    @ccall libclang.clang_isVolatileQualifiedType(T::CXType)::Cuint
end

"""
    clang_isRestrictQualifiedType(T)

Determine whether a [`CXType`](@ref) has the "restrict" qualifier set, without looking through typedefs that may have added "restrict" at a different level.
"""
function clang_isRestrictQualifiedType(T)
    @ccall libclang.clang_isRestrictQualifiedType(T::CXType)::Cuint
end

"""
    clang_getAddressSpace(T)

Returns the address space of the given type.
"""
function clang_getAddressSpace(T)
    @ccall libclang.clang_getAddressSpace(T::CXType)::Cuint
end

"""
    clang_getTypedefName(CT)

Returns the typedef name of the given type.
"""
function clang_getTypedefName(CT)
    @ccall libclang.clang_getTypedefName(CT::CXType)::CXString
end

"""
    clang_getPointeeType(T)

For pointer types, returns the type of the pointee.
"""
function clang_getPointeeType(T)
    @ccall libclang.clang_getPointeeType(T::CXType)::CXType
end

"""
    clang_getUnqualifiedType(CT)

Retrieve the unqualified variant of the given type, removing as little sugar as possible.

For example, given the following series of typedefs:

```c++
 typedef int Integer;
 typedef const Integer CInteger;
 typedef CInteger DifferenceType;
```

Executing [`clang_getUnqualifiedType`](@ref)() on a [`CXType`](@ref) that represents `DifferenceType`, will desugar to a type representing `Integer`, that has no qualifiers.

And, executing [`clang_getUnqualifiedType`](@ref)() on the type of the first argument of the following function declaration:

```c++
 void foo(const int);
```

Will return a type representing `int`, removing the `const` qualifier.

Sugar over array types is not desugared.

A type can be checked for qualifiers with [`clang_isConstQualifiedType`](@ref)(), [`clang_isVolatileQualifiedType`](@ref)() and [`clang_isRestrictQualifiedType`](@ref)().

A type that resulted from a call to [`clang_getUnqualifiedType`](@ref) will return `false` for all of the above calls.
"""
function clang_getUnqualifiedType(CT)
    @ccall libclang.clang_getUnqualifiedType(CT::CXType)::CXType
end

"""
    clang_getNonReferenceType(CT)

For reference types (e.g., "const int&"), returns the type that the reference refers to (e.g "const int").

Otherwise, returns the type itself.

A type that has kind `CXType_LValueReference` or `CXType_RValueReference` is a reference type.
"""
function clang_getNonReferenceType(CT)
    @ccall libclang.clang_getNonReferenceType(CT::CXType)::CXType
end

"""
    clang_getTypeDeclaration(T)

Return the cursor for the declaration of the given type.
"""
function clang_getTypeDeclaration(T)
    @ccall libclang.clang_getTypeDeclaration(T::CXType)::CXCursor
end

"""
    clang_getDeclObjCTypeEncoding(C)

Returns the Objective-C type encoding for the specified declaration.
"""
function clang_getDeclObjCTypeEncoding(C)
    @ccall libclang.clang_getDeclObjCTypeEncoding(C::CXCursor)::CXString
end

"""
    clang_Type_getObjCEncoding(type)

Returns the Objective-C type encoding for the specified [`CXType`](@ref).
"""
function clang_Type_getObjCEncoding(type)
    @ccall libclang.clang_Type_getObjCEncoding(type::CXType)::CXString
end

"""
    clang_getTypeKindSpelling(K)

Retrieve the spelling of a given [`CXTypeKind`](@ref).
"""
function clang_getTypeKindSpelling(K)
    @ccall libclang.clang_getTypeKindSpelling(K::CXTypeKind)::CXString
end

"""
    clang_getFunctionTypeCallingConv(T)

Retrieve the calling convention associated with a function type.

If a non-function type is passed in, CXCallingConv\\_Invalid is returned.
"""
function clang_getFunctionTypeCallingConv(T)
    @ccall libclang.clang_getFunctionTypeCallingConv(T::CXType)::CXCallingConv
end

"""
    clang_getResultType(T)

Retrieve the return type associated with a function type.

If a non-function type is passed in, an invalid type is returned.
"""
function clang_getResultType(T)
    @ccall libclang.clang_getResultType(T::CXType)::CXType
end

"""
    clang_getExceptionSpecificationType(T)

Retrieve the exception specification type associated with a function type. This is a value of type [`CXCursor_ExceptionSpecificationKind`](@ref).

If a non-function type is passed in, an error code of -1 is returned.
"""
function clang_getExceptionSpecificationType(T)
    @ccall libclang.clang_getExceptionSpecificationType(T::CXType)::Cint
end

"""
    clang_getNumArgTypes(T)

Retrieve the number of non-variadic parameters associated with a function type.

If a non-function type is passed in, -1 is returned.
"""
function clang_getNumArgTypes(T)
    @ccall libclang.clang_getNumArgTypes(T::CXType)::Cint
end

"""
    clang_getArgType(T, i)

Retrieve the type of a parameter of a function type.

If a non-function type is passed in or the function does not have enough parameters, an invalid type is returned.
"""
function clang_getArgType(T, i)
    @ccall libclang.clang_getArgType(T::CXType, i::Cuint)::CXType
end

"""
    clang_Type_getObjCObjectBaseType(T)

Retrieves the base type of the ObjCObjectType.

If the type is not an ObjC object, an invalid type is returned.
"""
function clang_Type_getObjCObjectBaseType(T)
    @ccall libclang.clang_Type_getObjCObjectBaseType(T::CXType)::CXType
end

"""
    clang_Type_getNumObjCProtocolRefs(T)

Retrieve the number of protocol references associated with an ObjC object/id.

If the type is not an ObjC object, 0 is returned.
"""
function clang_Type_getNumObjCProtocolRefs(T)
    @ccall libclang.clang_Type_getNumObjCProtocolRefs(T::CXType)::Cuint
end

"""
    clang_Type_getObjCProtocolDecl(T, i)

Retrieve the decl for a protocol reference for an ObjC object/id.

If the type is not an ObjC object or there are not enough protocol references, an invalid cursor is returned.
"""
function clang_Type_getObjCProtocolDecl(T, i)
    @ccall libclang.clang_Type_getObjCProtocolDecl(T::CXType, i::Cuint)::CXCursor
end

"""
    clang_Type_getNumObjCTypeArgs(T)

Retrieve the number of type arguments associated with an ObjC object.

If the type is not an ObjC object, 0 is returned.
"""
function clang_Type_getNumObjCTypeArgs(T)
    @ccall libclang.clang_Type_getNumObjCTypeArgs(T::CXType)::Cuint
end

"""
    clang_Type_getObjCTypeArg(T, i)

Retrieve a type argument associated with an ObjC object.

If the type is not an ObjC or the index is not valid, an invalid type is returned.
"""
function clang_Type_getObjCTypeArg(T, i)
    @ccall libclang.clang_Type_getObjCTypeArg(T::CXType, i::Cuint)::CXType
end

"""
    clang_isFunctionTypeVariadic(T)

Return 1 if the [`CXType`](@ref) is a variadic function type, and 0 otherwise.
"""
function clang_isFunctionTypeVariadic(T)
    @ccall libclang.clang_isFunctionTypeVariadic(T::CXType)::Cuint
end

"""
    clang_getCursorResultType(C)

Retrieve the return type associated with a given cursor.

This only returns a valid type if the cursor refers to a function or method.
"""
function clang_getCursorResultType(C)
    @ccall libclang.clang_getCursorResultType(C::CXCursor)::CXType
end

"""
    clang_getCursorExceptionSpecificationType(C)

Retrieve the exception specification type associated with a given cursor. This is a value of type [`CXCursor_ExceptionSpecificationKind`](@ref).

This only returns a valid result if the cursor refers to a function or method.
"""
function clang_getCursorExceptionSpecificationType(C)
    @ccall libclang.clang_getCursorExceptionSpecificationType(C::CXCursor)::Cint
end

"""
    clang_isPODType(T)

Return 1 if the [`CXType`](@ref) is a POD (plain old data) type, and 0 otherwise.
"""
function clang_isPODType(T)
    @ccall libclang.clang_isPODType(T::CXType)::Cuint
end

"""
    clang_getElementType(T)

Return the element type of an array, complex, or vector type.

If a type is passed in that is not an array, complex, or vector type, an invalid type is returned.
"""
function clang_getElementType(T)
    @ccall libclang.clang_getElementType(T::CXType)::CXType
end

"""
    clang_getNumElements(T)

Return the number of elements of an array or vector type.

If a type is passed in that is not an array or vector type, -1 is returned.
"""
function clang_getNumElements(T)
    @ccall libclang.clang_getNumElements(T::CXType)::Clonglong
end

"""
    clang_getArrayElementType(T)

Return the element type of an array type.

If a non-array type is passed in, an invalid type is returned.
"""
function clang_getArrayElementType(T)
    @ccall libclang.clang_getArrayElementType(T::CXType)::CXType
end

"""
    clang_getArraySize(T)

Return the array size of a constant array.

If a non-array type is passed in, -1 is returned.
"""
function clang_getArraySize(T)
    @ccall libclang.clang_getArraySize(T::CXType)::Clonglong
end

"""
    clang_Type_getNamedType(T)

Retrieve the type named by the qualified-id.

If a non-elaborated type is passed in, an invalid type is returned.
"""
function clang_Type_getNamedType(T)
    @ccall libclang.clang_Type_getNamedType(T::CXType)::CXType
end

"""
    clang_Type_isTransparentTagTypedef(T)

Determine if a typedef is 'transparent' tag.

A typedef is considered 'transparent' if it shares a name and spelling location with its underlying tag type, as is the case with the NS\\_ENUM macro.

# Returns
non-zero if transparent and zero otherwise.
"""
function clang_Type_isTransparentTagTypedef(T)
    @ccall libclang.clang_Type_isTransparentTagTypedef(T::CXType)::Cuint
end

"""
    CXTypeNullabilityKind

| Enumerator                         | Note                                                                                                                                                                                                                                                                   |
| :--------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXTypeNullability\\_NonNull        | Values of this type can never be null.                                                                                                                                                                                                                                 |
| CXTypeNullability\\_Nullable       | Values of this type can be null.                                                                                                                                                                                                                                       |
| CXTypeNullability\\_Unspecified    | Whether values of this type can be null is (explicitly) unspecified. This captures a (fairly rare) case where we can't conclude anything about the nullability of the type even though it has been considered.                                                         |
| CXTypeNullability\\_Invalid        | Nullability is not applicable to this type.                                                                                                                                                                                                                            |
| CXTypeNullability\\_NullableResult | Generally behaves like Nullable, except when used in a block parameter that was imported into a swift async method. There, swift will assume that the parameter can get null even if no error occurred. \\_Nullable parameters are assumed to only get null on error.  |
"""
@cenum CXTypeNullabilityKind::UInt32 begin
    CXTypeNullability_NonNull = 0
    CXTypeNullability_Nullable = 1
    CXTypeNullability_Unspecified = 2
    CXTypeNullability_Invalid = 3
    CXTypeNullability_NullableResult = 4
end

"""
    clang_Type_getNullability(T)

Retrieve the nullability kind of a pointer type.
"""
function clang_Type_getNullability(T)
    @ccall libclang.clang_Type_getNullability(T::CXType)::CXTypeNullabilityKind
end

"""
    CXTypeLayoutError

List the possible error codes for [`clang_Type_getSizeOf`](@ref), [`clang_Type_getAlignOf`](@ref), [`clang_Type_getOffsetOf`](@ref) and `clang_Cursor_getOffsetOf`.

A value of this enumeration type can be returned if the target type is not a valid argument to sizeof, alignof or offsetof.

| Enumerator                           | Note                                          |
| :----------------------------------- | :-------------------------------------------- |
| CXTypeLayoutError\\_Invalid          | Type is of kind CXType\\_Invalid.             |
| CXTypeLayoutError\\_Incomplete       | The type is an incomplete Type.               |
| CXTypeLayoutError\\_Dependent        | The type is a dependent Type.                 |
| CXTypeLayoutError\\_NotConstantSize  | The type is not a constant size type.         |
| CXTypeLayoutError\\_InvalidFieldName | The Field name is not valid for this record.  |
| CXTypeLayoutError\\_Undeduced        | The type is undeduced.                        |
"""
@cenum CXTypeLayoutError::Int32 begin
    CXTypeLayoutError_Invalid = -1
    CXTypeLayoutError_Incomplete = -2
    CXTypeLayoutError_Dependent = -3
    CXTypeLayoutError_NotConstantSize = -4
    CXTypeLayoutError_InvalidFieldName = -5
    CXTypeLayoutError_Undeduced = -6
end

"""
    clang_Type_getAlignOf(T)

Return the alignment of a type in bytes as per C++[expr.alignof] standard.

If the type declaration is invalid, CXTypeLayoutError\\_Invalid is returned. If the type declaration is an incomplete type, CXTypeLayoutError\\_Incomplete is returned. If the type declaration is a dependent type, CXTypeLayoutError\\_Dependent is returned. If the type declaration is not a constant size type, CXTypeLayoutError\\_NotConstantSize is returned.
"""
function clang_Type_getAlignOf(T)
    @ccall libclang.clang_Type_getAlignOf(T::CXType)::Clonglong
end

"""
    clang_Type_getClassType(T)

Return the class type of an member pointer type.

If a non-member-pointer type is passed in, an invalid type is returned.
"""
function clang_Type_getClassType(T)
    @ccall libclang.clang_Type_getClassType(T::CXType)::CXType
end

"""
    clang_Type_getSizeOf(T)

Return the size of a type in bytes as per C++[expr.sizeof] standard.

If the type declaration is invalid, CXTypeLayoutError\\_Invalid is returned. If the type declaration is an incomplete type, CXTypeLayoutError\\_Incomplete is returned. If the type declaration is a dependent type, CXTypeLayoutError\\_Dependent is returned.
"""
function clang_Type_getSizeOf(T)
    @ccall libclang.clang_Type_getSizeOf(T::CXType)::Clonglong
end

"""
    clang_Type_getOffsetOf(T, S)

Return the offset of a field named S in a record of type T in bits as it would be returned by \\_\\_offsetof\\_\\_ as per C++11[18.2p4]

If the cursor is not a record field declaration, CXTypeLayoutError\\_Invalid is returned. If the field's type declaration is an incomplete type, CXTypeLayoutError\\_Incomplete is returned. If the field's type declaration is a dependent type, CXTypeLayoutError\\_Dependent is returned. If the field's name S is not found, CXTypeLayoutError\\_InvalidFieldName is returned.
"""
function clang_Type_getOffsetOf(T, S)
    @ccall libclang.clang_Type_getOffsetOf(T::CXType, S::Cstring)::Clonglong
end

"""
    clang_Type_getModifiedType(T)

Return the type that was modified by this attributed type.

If the type is not an attributed type, an invalid type is returned.
"""
function clang_Type_getModifiedType(T)
    @ccall libclang.clang_Type_getModifiedType(T::CXType)::CXType
end

"""
    clang_Type_getValueType(CT)

Gets the type contained by this atomic type.

If a non-atomic type is passed in, an invalid type is returned.
"""
function clang_Type_getValueType(CT)
    @ccall libclang.clang_Type_getValueType(CT::CXType)::CXType
end

"""
    clang_Cursor_getOffsetOfField(C)

Return the offset of the field represented by the Cursor.

If the cursor is not a field declaration, -1 is returned. If the cursor semantic parent is not a record field declaration, CXTypeLayoutError\\_Invalid is returned. If the field's type declaration is an incomplete type, CXTypeLayoutError\\_Incomplete is returned. If the field's type declaration is a dependent type, CXTypeLayoutError\\_Dependent is returned. If the field's name S is not found, CXTypeLayoutError\\_InvalidFieldName is returned.
"""
function clang_Cursor_getOffsetOfField(C)
    @ccall libclang.clang_Cursor_getOffsetOfField(C::CXCursor)::Clonglong
end

"""
    clang_Cursor_isAnonymous(C)

Determine whether the given cursor represents an anonymous tag or namespace
"""
function clang_Cursor_isAnonymous(C)
    @ccall libclang.clang_Cursor_isAnonymous(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isAnonymousRecordDecl(C)

Determine whether the given cursor represents an anonymous record declaration.
"""
function clang_Cursor_isAnonymousRecordDecl(C)
    @ccall libclang.clang_Cursor_isAnonymousRecordDecl(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isInlineNamespace(C)

Determine whether the given cursor represents an inline namespace declaration.
"""
function clang_Cursor_isInlineNamespace(C)
    @ccall libclang.clang_Cursor_isInlineNamespace(C::CXCursor)::Cuint
end

"""
    CXRefQualifierKind

| Enumerator              | Note                                          |
| :---------------------- | :-------------------------------------------- |
| CXRefQualifier\\_None   | No ref-qualifier was provided.                |
| CXRefQualifier\\_LValue | An lvalue ref-qualifier was provided (`&).`   |
| CXRefQualifier\\_RValue | An rvalue ref-qualifier was provided (`&&).`  |
"""
@cenum CXRefQualifierKind::UInt32 begin
    CXRefQualifier_None = 0
    CXRefQualifier_LValue = 1
    CXRefQualifier_RValue = 2
end

"""
    clang_Type_getNumTemplateArguments(T)

Returns the number of template arguments for given template specialization, or -1 if type `T` is not a template specialization.
"""
function clang_Type_getNumTemplateArguments(T)
    @ccall libclang.clang_Type_getNumTemplateArguments(T::CXType)::Cint
end

"""
    clang_Type_getTemplateArgumentAsType(T, i)

Returns the type template argument of a template class specialization at given index.

This function only returns template type arguments and does not handle template template arguments or variadic packs.
"""
function clang_Type_getTemplateArgumentAsType(T, i)
    @ccall libclang.clang_Type_getTemplateArgumentAsType(T::CXType, i::Cuint)::CXType
end

"""
    clang_Type_getCXXRefQualifier(T)

Retrieve the ref-qualifier kind of a function or method.

The ref-qualifier is returned for C++ functions or methods. For other types or non-C++ declarations, CXRefQualifier\\_None is returned.
"""
function clang_Type_getCXXRefQualifier(T)
    @ccall libclang.clang_Type_getCXXRefQualifier(T::CXType)::CXRefQualifierKind
end

"""
    clang_isVirtualBase(arg1)

Returns 1 if the base class specified by the cursor with kind CX\\_CXXBaseSpecifier is virtual.
"""
function clang_isVirtualBase(arg1)
    @ccall libclang.clang_isVirtualBase(arg1::CXCursor)::Cuint
end

"""
    CX_CXXAccessSpecifier

Represents the C++ access control level to a base class for a cursor with kind CX\\_CXXBaseSpecifier.
"""
@cenum CX_CXXAccessSpecifier::UInt32 begin
    CX_CXXInvalidAccessSpecifier = 0
    CX_CXXPublic = 1
    CX_CXXProtected = 2
    CX_CXXPrivate = 3
end

"""
    clang_getCXXAccessSpecifier(arg1)

Returns the access control level for the referenced object.

If the cursor refers to a C++ declaration, its access control level within its parent scope is returned. Otherwise, if the cursor refers to a base specifier or access specifier, the specifier itself is returned.
"""
function clang_getCXXAccessSpecifier(arg1)
    @ccall libclang.clang_getCXXAccessSpecifier(arg1::CXCursor)::CX_CXXAccessSpecifier
end

"""
    CX_StorageClass

Represents the storage classes as declared in the source. CX\\_SC\\_Invalid was added for the case that the passed cursor in not a declaration.
"""
@cenum CX_StorageClass::UInt32 begin
    CX_SC_Invalid = 0
    CX_SC_None = 1
    CX_SC_Extern = 2
    CX_SC_Static = 3
    CX_SC_PrivateExtern = 4
    CX_SC_OpenCLWorkGroupLocal = 5
    CX_SC_Auto = 6
    CX_SC_Register = 7
end

"""
    clang_Cursor_getStorageClass(arg1)

Returns the storage class for a function or variable declaration.

If the passed in Cursor is not a function or variable declaration, CX\\_SC\\_Invalid is returned else the storage class.
"""
function clang_Cursor_getStorageClass(arg1)
    @ccall libclang.clang_Cursor_getStorageClass(arg1::CXCursor)::CX_StorageClass
end

"""
    clang_getNumOverloadedDecls(cursor)

Determine the number of overloaded declarations referenced by a `CXCursor_OverloadedDeclRef` cursor.

# Arguments
* `cursor`: The cursor whose overloaded declarations are being queried.
# Returns
The number of overloaded declarations referenced by `cursor`. If it is not a `CXCursor_OverloadedDeclRef` cursor, returns 0.
"""
function clang_getNumOverloadedDecls(cursor)
    @ccall libclang.clang_getNumOverloadedDecls(cursor::CXCursor)::Cuint
end

"""
    clang_getOverloadedDecl(cursor, index)

Retrieve a cursor for one of the overloaded declarations referenced by a `CXCursor_OverloadedDeclRef` cursor.

# Arguments
* `cursor`: The cursor whose overloaded declarations are being queried.
* `index`: The zero-based index into the set of overloaded declarations in the cursor.
# Returns
A cursor representing the declaration referenced by the given `cursor` at the specified `index`. If the cursor does not have an associated set of overloaded declarations, or if the index is out of bounds, returns [`clang_getNullCursor`](@ref)();
"""
function clang_getOverloadedDecl(cursor, index)
    @ccall libclang.clang_getOverloadedDecl(cursor::CXCursor, index::Cuint)::CXCursor
end

"""
    clang_getIBOutletCollectionType(arg1)

For cursors representing an iboutletcollection attribute, this function returns the collection element type.
"""
function clang_getIBOutletCollectionType(arg1)
    @ccall libclang.clang_getIBOutletCollectionType(arg1::CXCursor)::CXType
end

"""
    CXChildVisitResult

Describes how the traversal of the children of a particular cursor should proceed after visiting a particular child cursor.

A value of this enumeration type should be returned by each [`CXCursorVisitor`](@ref) to indicate how [`clang_visitChildren`](@ref)() proceed.

| Enumerator              | Note                                                                                                             |
| :---------------------- | :--------------------------------------------------------------------------------------------------------------- |
| CXChildVisit\\_Break    | Terminates the cursor traversal.                                                                                 |
| CXChildVisit\\_Continue | Continues the cursor traversal with the next sibling of the cursor just visited, without visiting its children.  |
| CXChildVisit\\_Recurse  | Recursively traverse the children of this cursor, using the same visitor and client data.                        |
"""
@cenum CXChildVisitResult::UInt32 begin
    CXChildVisit_Break = 0
    CXChildVisit_Continue = 1
    CXChildVisit_Recurse = 2
end

# typedef enum CXChildVisitResult ( * CXCursorVisitor ) ( CXCursor cursor , CXCursor parent , CXClientData client_data )
"""
Visitor invoked for each cursor found by a traversal.

This visitor function will be invoked for each cursor found by clang\\_visitCursorChildren(). Its first argument is the cursor being visited, its second argument is the parent visitor for that cursor, and its third argument is the client data provided to clang\\_visitCursorChildren().

The visitor should return one of the [`CXChildVisitResult`](@ref) values to direct clang\\_visitCursorChildren().
"""
const CXCursorVisitor = Ptr{Cvoid}

"""
    clang_visitChildren(parent, visitor, client_data)

Visit the children of a particular cursor.

This function visits all the direct children of the given cursor, invoking the given `visitor` function with the cursors of each visited child. The traversal may be recursive, if the visitor returns `CXChildVisit_Recurse`. The traversal may also be ended prematurely, if the visitor returns `CXChildVisit_Break`.

# Arguments
* `parent`: the cursor whose child may be visited. All kinds of cursors can be visited, including invalid cursors (which, by definition, have no children).
* `visitor`: the visitor function that will be invoked for each child of `parent`.
* `client_data`: pointer data supplied by the client, which will be passed to the visitor each time it is invoked.
# Returns
a non-zero value if the traversal was terminated prematurely by the visitor returning `CXChildVisit_Break`.
"""
function clang_visitChildren(parent, visitor, client_data)
    @ccall libclang.clang_visitChildren(parent::CXCursor, visitor::CXCursorVisitor, client_data::CXClientData)::Cuint
end

"""
    clang_getCursorUSR(arg1)

Retrieve a Unified Symbol Resolution (USR) for the entity referenced by the given cursor.

A Unified Symbol Resolution (USR) is a string that identifies a particular entity (function, class, variable, etc.) within a program. USRs can be compared across translation units to determine, e.g., when references in one translation refer to an entity defined in another translation unit.
"""
function clang_getCursorUSR(arg1)
    @ccall libclang.clang_getCursorUSR(arg1::CXCursor)::CXString
end

"""
    clang_constructUSR_ObjCClass(class_name)

Construct a USR for a specified Objective-C class.
"""
function clang_constructUSR_ObjCClass(class_name)
    @ccall libclang.clang_constructUSR_ObjCClass(class_name::Cstring)::CXString
end

"""
    clang_constructUSR_ObjCCategory(class_name, category_name)

Construct a USR for a specified Objective-C category.
"""
function clang_constructUSR_ObjCCategory(class_name, category_name)
    @ccall libclang.clang_constructUSR_ObjCCategory(class_name::Cstring, category_name::Cstring)::CXString
end

"""
    clang_constructUSR_ObjCProtocol(protocol_name)

Construct a USR for a specified Objective-C protocol.
"""
function clang_constructUSR_ObjCProtocol(protocol_name)
    @ccall libclang.clang_constructUSR_ObjCProtocol(protocol_name::Cstring)::CXString
end

"""
    clang_constructUSR_ObjCIvar(name, classUSR)

Construct a USR for a specified Objective-C instance variable and the USR for its containing class.
"""
function clang_constructUSR_ObjCIvar(name, classUSR)
    @ccall libclang.clang_constructUSR_ObjCIvar(name::Cstring, classUSR::CXString)::CXString
end

"""
    clang_constructUSR_ObjCMethod(name, isInstanceMethod, classUSR)

Construct a USR for a specified Objective-C method and the USR for its containing class.
"""
function clang_constructUSR_ObjCMethod(name, isInstanceMethod, classUSR)
    @ccall libclang.clang_constructUSR_ObjCMethod(name::Cstring, isInstanceMethod::Cuint, classUSR::CXString)::CXString
end

"""
    clang_constructUSR_ObjCProperty(property, classUSR)

Construct a USR for a specified Objective-C property and the USR for its containing class.
"""
function clang_constructUSR_ObjCProperty(property, classUSR)
    @ccall libclang.clang_constructUSR_ObjCProperty(property::Cstring, classUSR::CXString)::CXString
end

"""
    clang_getCursorSpelling(arg1)

Retrieve a name for the entity referenced by this cursor.
"""
function clang_getCursorSpelling(arg1)
    @ccall libclang.clang_getCursorSpelling(arg1::CXCursor)::CXString
end

"""
    clang_Cursor_getSpellingNameRange(arg1, pieceIndex, options)

Retrieve a range for a piece that forms the cursors spelling name. Most of the times there is only one range for the complete spelling but for Objective-C methods and Objective-C message expressions, there are multiple pieces for each selector identifier.

# Arguments
* `pieceIndex`: the index of the spelling name piece. If this is greater than the actual number of pieces, it will return a NULL (invalid) range.
* `options`: Reserved.
"""
function clang_Cursor_getSpellingNameRange(arg1, pieceIndex, options)
    @ccall libclang.clang_Cursor_getSpellingNameRange(arg1::CXCursor, pieceIndex::Cuint, options::Cuint)::CXSourceRange
end

"""
Opaque pointer representing a policy that controls pretty printing for [`clang_getCursorPrettyPrinted`](@ref).
"""
const CXPrintingPolicy = Ptr{Cvoid}

"""
    CXPrintingPolicyProperty

Properties for the printing policy.

See `clang`::PrintingPolicy for more information.
"""
@cenum CXPrintingPolicyProperty::UInt32 begin
    CXPrintingPolicy_Indentation = 0
    CXPrintingPolicy_SuppressSpecifiers = 1
    CXPrintingPolicy_SuppressTagKeyword = 2
    CXPrintingPolicy_IncludeTagDefinition = 3
    CXPrintingPolicy_SuppressScope = 4
    CXPrintingPolicy_SuppressUnwrittenScope = 5
    CXPrintingPolicy_SuppressInitializers = 6
    CXPrintingPolicy_ConstantArraySizeAsWritten = 7
    CXPrintingPolicy_AnonymousTagLocations = 8
    CXPrintingPolicy_SuppressStrongLifetime = 9
    CXPrintingPolicy_SuppressLifetimeQualifiers = 10
    CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors = 11
    CXPrintingPolicy_Bool = 12
    CXPrintingPolicy_Restrict = 13
    CXPrintingPolicy_Alignof = 14
    CXPrintingPolicy_UnderscoreAlignof = 15
    CXPrintingPolicy_UseVoidForZeroParams = 16
    CXPrintingPolicy_TerseOutput = 17
    CXPrintingPolicy_PolishForDeclaration = 18
    CXPrintingPolicy_Half = 19
    CXPrintingPolicy_MSWChar = 20
    CXPrintingPolicy_IncludeNewlines = 21
    CXPrintingPolicy_MSVCFormatting = 22
    CXPrintingPolicy_ConstantsAsWritten = 23
    CXPrintingPolicy_SuppressImplicitBase = 24
    CXPrintingPolicy_FullyQualifiedName = 25
    CXPrintingPolicy_LastProperty = 25
end

"""
    clang_PrintingPolicy_getProperty(Policy, Property)

Get a property value for the given printing policy.
"""
function clang_PrintingPolicy_getProperty(Policy, Property)
    @ccall libclang.clang_PrintingPolicy_getProperty(Policy::CXPrintingPolicy, Property::CXPrintingPolicyProperty)::Cuint
end

"""
    clang_PrintingPolicy_setProperty(Policy, Property, Value)

Set a property value for the given printing policy.
"""
function clang_PrintingPolicy_setProperty(Policy, Property, Value)
    @ccall libclang.clang_PrintingPolicy_setProperty(Policy::CXPrintingPolicy, Property::CXPrintingPolicyProperty, Value::Cuint)::Cvoid
end

"""
    clang_getCursorPrintingPolicy(arg1)

Retrieve the default policy for the cursor.

The policy should be released after use with [`clang_PrintingPolicy_dispose`](@ref).
"""
function clang_getCursorPrintingPolicy(arg1)
    @ccall libclang.clang_getCursorPrintingPolicy(arg1::CXCursor)::CXPrintingPolicy
end

"""
    clang_PrintingPolicy_dispose(Policy)

Release a printing policy.
"""
function clang_PrintingPolicy_dispose(Policy)
    @ccall libclang.clang_PrintingPolicy_dispose(Policy::CXPrintingPolicy)::Cvoid
end

"""
    clang_getCursorPrettyPrinted(Cursor, Policy)

Pretty print declarations.

# Arguments
* `Cursor`: The cursor representing a declaration.
* `Policy`: The policy to control the entities being printed. If NULL, a default policy is used.
# Returns
The pretty printed declaration or the empty string for other cursors.
"""
function clang_getCursorPrettyPrinted(Cursor, Policy)
    @ccall libclang.clang_getCursorPrettyPrinted(Cursor::CXCursor, Policy::CXPrintingPolicy)::CXString
end

"""
    clang_getCursorDisplayName(arg1)

Retrieve the display name for the entity referenced by this cursor.

The display name contains extra information that helps identify the cursor, such as the parameters of a function or template or the arguments of a class template specialization.
"""
function clang_getCursorDisplayName(arg1)
    @ccall libclang.clang_getCursorDisplayName(arg1::CXCursor)::CXString
end

"""
    clang_getCursorReferenced(arg1)

For a cursor that is a reference, retrieve a cursor representing the entity that it references.

Reference cursors refer to other entities in the AST. For example, an Objective-C superclass reference cursor refers to an Objective-C class. This function produces the cursor for the Objective-C class from the cursor for the superclass reference. If the input cursor is a declaration or definition, it returns that declaration or definition unchanged. Otherwise, returns the NULL cursor.
"""
function clang_getCursorReferenced(arg1)
    @ccall libclang.clang_getCursorReferenced(arg1::CXCursor)::CXCursor
end

"""
    clang_getCursorDefinition(arg1)

For a cursor that is either a reference to or a declaration of some entity, retrieve a cursor that describes the definition of that entity.

Some entities can be declared multiple times within a translation unit, but only one of those declarations can also be a definition. For example, given:

```c++
  int f(int, int);
  int g(int x, int y) { return f(x, y); }
  int f(int a, int b) { return a + b; }
  int f(int, int);
```

there are three declarations of the function "f", but only the second one is a definition. The [`clang_getCursorDefinition`](@ref)() function will take any cursor pointing to a declaration of "f" (the first or fourth lines of the example) or a cursor referenced that uses "f" (the call to "f' inside "g") and will return a declaration cursor pointing to the definition (the second "f" declaration).

If given a cursor for which there is no corresponding definition, e.g., because there is no definition of that entity within this translation unit, returns a NULL cursor.
"""
function clang_getCursorDefinition(arg1)
    @ccall libclang.clang_getCursorDefinition(arg1::CXCursor)::CXCursor
end

"""
    clang_isCursorDefinition(arg1)

Determine whether the declaration pointed to by this cursor is also a definition of that entity.
"""
function clang_isCursorDefinition(arg1)
    @ccall libclang.clang_isCursorDefinition(arg1::CXCursor)::Cuint
end

"""
    clang_getCanonicalCursor(arg1)

Retrieve the canonical cursor corresponding to the given cursor.

In the C family of languages, many kinds of entities can be declared several times within a single translation unit. For example, a structure type can be forward-declared (possibly multiple times) and later defined:

```c++
 struct X;
 struct X;
 struct X {
   int member;
 };
```

The declarations and the definition of `X` are represented by three different cursors, all of which are declarations of the same underlying entity. One of these cursor is considered the "canonical" cursor, which is effectively the representative for the underlying entity. One can determine if two cursors are declarations of the same underlying entity by comparing their canonical cursors.

# Returns
The canonical cursor for the entity referred to by the given cursor.
"""
function clang_getCanonicalCursor(arg1)
    @ccall libclang.clang_getCanonicalCursor(arg1::CXCursor)::CXCursor
end

"""
    clang_Cursor_getObjCSelectorIndex(arg1)

If the cursor points to a selector identifier in an Objective-C method or message expression, this returns the selector index.

After getting a cursor with #[`clang_getCursor`](@ref), this can be called to determine if the location points to a selector identifier.

# Returns
The selector index if the cursor is an Objective-C method or message expression and the cursor is pointing to a selector identifier, or -1 otherwise.
"""
function clang_Cursor_getObjCSelectorIndex(arg1)
    @ccall libclang.clang_Cursor_getObjCSelectorIndex(arg1::CXCursor)::Cint
end

"""
    clang_Cursor_isDynamicCall(C)

Given a cursor pointing to a C++ method call or an Objective-C message, returns non-zero if the method/message is "dynamic", meaning:

For a C++ method: the call is virtual. For an Objective-C message: the receiver is an object instance, not 'super' or a specific class.

If the method/message is "static" or the cursor does not point to a method/message, it will return zero.
"""
function clang_Cursor_isDynamicCall(C)
    @ccall libclang.clang_Cursor_isDynamicCall(C::CXCursor)::Cint
end

"""
    clang_Cursor_getReceiverType(C)

Given a cursor pointing to an Objective-C message or property reference, or C++ method call, returns the [`CXType`](@ref) of the receiver.
"""
function clang_Cursor_getReceiverType(C)
    @ccall libclang.clang_Cursor_getReceiverType(C::CXCursor)::CXType
end

"""
    CXObjCPropertyAttrKind

Property attributes for a `CXCursor_ObjCPropertyDecl`.
"""
@cenum CXObjCPropertyAttrKind::UInt32 begin
    CXObjCPropertyAttr_noattr = 0
    CXObjCPropertyAttr_readonly = 1
    CXObjCPropertyAttr_getter = 2
    CXObjCPropertyAttr_assign = 4
    CXObjCPropertyAttr_readwrite = 8
    CXObjCPropertyAttr_retain = 16
    CXObjCPropertyAttr_copy = 32
    CXObjCPropertyAttr_nonatomic = 64
    CXObjCPropertyAttr_setter = 128
    CXObjCPropertyAttr_atomic = 256
    CXObjCPropertyAttr_weak = 512
    CXObjCPropertyAttr_strong = 1024
    CXObjCPropertyAttr_unsafe_unretained = 2048
    CXObjCPropertyAttr_class = 4096
end

"""
    clang_Cursor_getObjCPropertyAttributes(C, reserved)

Given a cursor that represents a property declaration, return the associated property attributes. The bits are formed from [`CXObjCPropertyAttrKind`](@ref).

# Arguments
* `reserved`: Reserved for future use, pass 0.
"""
function clang_Cursor_getObjCPropertyAttributes(C, reserved)
    @ccall libclang.clang_Cursor_getObjCPropertyAttributes(C::CXCursor, reserved::Cuint)::Cuint
end

"""
    clang_Cursor_getObjCPropertyGetterName(C)

Given a cursor that represents a property declaration, return the name of the method that implements the getter.
"""
function clang_Cursor_getObjCPropertyGetterName(C)
    @ccall libclang.clang_Cursor_getObjCPropertyGetterName(C::CXCursor)::CXString
end

"""
    clang_Cursor_getObjCPropertySetterName(C)

Given a cursor that represents a property declaration, return the name of the method that implements the setter, if any.
"""
function clang_Cursor_getObjCPropertySetterName(C)
    @ccall libclang.clang_Cursor_getObjCPropertySetterName(C::CXCursor)::CXString
end

"""
    CXObjCDeclQualifierKind

'Qualifiers' written next to the return and parameter types in Objective-C method declarations.
"""
@cenum CXObjCDeclQualifierKind::UInt32 begin
    CXObjCDeclQualifier_None = 0
    CXObjCDeclQualifier_In = 1
    CXObjCDeclQualifier_Inout = 2
    CXObjCDeclQualifier_Out = 4
    CXObjCDeclQualifier_Bycopy = 8
    CXObjCDeclQualifier_Byref = 16
    CXObjCDeclQualifier_Oneway = 32
end

"""
    clang_Cursor_getObjCDeclQualifiers(C)

Given a cursor that represents an Objective-C method or parameter declaration, return the associated Objective-C qualifiers for the return type or the parameter respectively. The bits are formed from [`CXObjCDeclQualifierKind`](@ref).
"""
function clang_Cursor_getObjCDeclQualifiers(C)
    @ccall libclang.clang_Cursor_getObjCDeclQualifiers(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isObjCOptional(C)

Given a cursor that represents an Objective-C method or property declaration, return non-zero if the declaration was affected by "\\@optional". Returns zero if the cursor is not such a declaration or it is "\\@required".
"""
function clang_Cursor_isObjCOptional(C)
    @ccall libclang.clang_Cursor_isObjCOptional(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isVariadic(C)

Returns non-zero if the given cursor is a variadic function or method.
"""
function clang_Cursor_isVariadic(C)
    @ccall libclang.clang_Cursor_isVariadic(C::CXCursor)::Cuint
end

"""
    clang_Cursor_isExternalSymbol(C, language, definedIn, isGenerated)

Returns non-zero if the given cursor points to a symbol marked with external\\_source\\_symbol attribute.

# Arguments
* `language`: If non-NULL, and the attribute is present, will be set to the 'language' string from the attribute.
* `definedIn`: If non-NULL, and the attribute is present, will be set to the 'definedIn' string from the attribute.
* `isGenerated`: If non-NULL, and the attribute is present, will be set to non-zero if the 'generated\\_declaration' is set in the attribute.
"""
function clang_Cursor_isExternalSymbol(C, language, definedIn, isGenerated)
    @ccall libclang.clang_Cursor_isExternalSymbol(C::CXCursor, language::Ptr{CXString}, definedIn::Ptr{CXString}, isGenerated::Ptr{Cuint})::Cuint
end

"""
    clang_Cursor_getCommentRange(C)

Given a cursor that represents a declaration, return the associated comment's source range. The range may include multiple consecutive comments with whitespace in between.
"""
function clang_Cursor_getCommentRange(C)
    @ccall libclang.clang_Cursor_getCommentRange(C::CXCursor)::CXSourceRange
end

"""
    clang_Cursor_getRawCommentText(C)

Given a cursor that represents a declaration, return the associated comment text, including comment markers.
"""
function clang_Cursor_getRawCommentText(C)
    @ccall libclang.clang_Cursor_getRawCommentText(C::CXCursor)::CXString
end

"""
    clang_Cursor_getBriefCommentText(C)

Given a cursor that represents a documentable entity (e.g., declaration), return the associated

`; otherwise return the`

first paragraph.
"""
function clang_Cursor_getBriefCommentText(C)
    @ccall libclang.clang_Cursor_getBriefCommentText(C::CXCursor)::CXString
end

"""
    clang_Cursor_getMangling(arg1)

Retrieve the [`CXString`](@ref) representing the mangled name of the cursor.
"""
function clang_Cursor_getMangling(arg1)
    @ccall libclang.clang_Cursor_getMangling(arg1::CXCursor)::CXString
end

"""
    clang_Cursor_getCXXManglings(arg1)

Retrieve the CXStrings representing the mangled symbols of the C++ constructor or destructor at the cursor.
"""
function clang_Cursor_getCXXManglings(arg1)
    @ccall libclang.clang_Cursor_getCXXManglings(arg1::CXCursor)::Ptr{CXStringSet}
end

"""
    clang_Cursor_getObjCManglings(arg1)

Retrieve the CXStrings representing the mangled symbols of the ObjC class interface or implementation at the cursor.
"""
function clang_Cursor_getObjCManglings(arg1)
    @ccall libclang.clang_Cursor_getObjCManglings(arg1::CXCursor)::Ptr{CXStringSet}
end

"""
` CINDEX_MODULE Module introspection`

The functions in this group provide access to information about modules.

@{
"""
const CXModule = Ptr{Cvoid}

"""
    clang_Cursor_getModule(C)

Given a CXCursor\\_ModuleImportDecl cursor, return the associated module.
"""
function clang_Cursor_getModule(C)
    @ccall libclang.clang_Cursor_getModule(C::CXCursor)::CXModule
end

"""
    clang_getModuleForFile(arg1, arg2)

Given a [`CXFile`](@ref) header file, return the module that contains it, if one exists.
"""
function clang_getModuleForFile(arg1, arg2)
    @ccall libclang.clang_getModuleForFile(arg1::CXTranslationUnit, arg2::CXFile)::CXModule
end

"""
    clang_Module_getASTFile(Module)

# Arguments
* `Module`: a module object.
# Returns
the module file where the provided module object came from.
"""
function clang_Module_getASTFile(Module)
    @ccall libclang.clang_Module_getASTFile(Module::CXModule)::CXFile
end

"""
    clang_Module_getParent(Module)

# Arguments
* `Module`: a module object.
# Returns
the parent of a sub-module or NULL if the given module is top-level, e.g. for 'std.vector' it will return the 'std' module.
"""
function clang_Module_getParent(Module)
    @ccall libclang.clang_Module_getParent(Module::CXModule)::CXModule
end

"""
    clang_Module_getName(Module)

# Arguments
* `Module`: a module object.
# Returns
the name of the module, e.g. for the 'std.vector' sub-module it will return "vector".
"""
function clang_Module_getName(Module)
    @ccall libclang.clang_Module_getName(Module::CXModule)::CXString
end

"""
    clang_Module_getFullName(Module)

# Arguments
* `Module`: a module object.
# Returns
the full name of the module, e.g. "std.vector".
"""
function clang_Module_getFullName(Module)
    @ccall libclang.clang_Module_getFullName(Module::CXModule)::CXString
end

"""
    clang_Module_isSystem(Module)

# Arguments
* `Module`: a module object.
# Returns
non-zero if the module is a system one.
"""
function clang_Module_isSystem(Module)
    @ccall libclang.clang_Module_isSystem(Module::CXModule)::Cint
end

"""
    clang_Module_getNumTopLevelHeaders(arg1, Module)

# Arguments
* `Module`: a module object.
# Returns
the number of top level headers associated with this module.
"""
function clang_Module_getNumTopLevelHeaders(arg1, Module)
    @ccall libclang.clang_Module_getNumTopLevelHeaders(arg1::CXTranslationUnit, Module::CXModule)::Cuint
end

"""
    clang_Module_getTopLevelHeader(arg1, Module, Index)

# Arguments
* `Module`: a module object.
* `Index`: top level header index (zero-based).
# Returns
the specified top level header associated with the module.
"""
function clang_Module_getTopLevelHeader(arg1, Module, Index)
    @ccall libclang.clang_Module_getTopLevelHeader(arg1::CXTranslationUnit, Module::CXModule, Index::Cuint)::CXFile
end

"""
    clang_CXXConstructor_isConvertingConstructor(C)

Determine if a C++ constructor is a converting constructor.
"""
function clang_CXXConstructor_isConvertingConstructor(C)
    @ccall libclang.clang_CXXConstructor_isConvertingConstructor(C::CXCursor)::Cuint
end

"""
    clang_CXXConstructor_isCopyConstructor(C)

Determine if a C++ constructor is a copy constructor.
"""
function clang_CXXConstructor_isCopyConstructor(C)
    @ccall libclang.clang_CXXConstructor_isCopyConstructor(C::CXCursor)::Cuint
end

"""
    clang_CXXConstructor_isDefaultConstructor(C)

Determine if a C++ constructor is the default constructor.
"""
function clang_CXXConstructor_isDefaultConstructor(C)
    @ccall libclang.clang_CXXConstructor_isDefaultConstructor(C::CXCursor)::Cuint
end

"""
    clang_CXXConstructor_isMoveConstructor(C)

Determine if a C++ constructor is a move constructor.
"""
function clang_CXXConstructor_isMoveConstructor(C)
    @ccall libclang.clang_CXXConstructor_isMoveConstructor(C::CXCursor)::Cuint
end

"""
    clang_CXXField_isMutable(C)

Determine if a C++ field is declared 'mutable'.
"""
function clang_CXXField_isMutable(C)
    @ccall libclang.clang_CXXField_isMutable(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isDefaulted(C)

Determine if a C++ method is declared '= default'.
"""
function clang_CXXMethod_isDefaulted(C)
    @ccall libclang.clang_CXXMethod_isDefaulted(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isDeleted(C)

Determine if a C++ method is declared '= delete'.
"""
function clang_CXXMethod_isDeleted(C)
    @ccall libclang.clang_CXXMethod_isDeleted(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isPureVirtual(C)

Determine if a C++ member function or member function template is pure virtual.
"""
function clang_CXXMethod_isPureVirtual(C)
    @ccall libclang.clang_CXXMethod_isPureVirtual(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isStatic(C)

Determine if a C++ member function or member function template is declared 'static'.
"""
function clang_CXXMethod_isStatic(C)
    @ccall libclang.clang_CXXMethod_isStatic(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isVirtual(C)

Determine if a C++ member function or member function template is explicitly declared 'virtual' or if it overrides a virtual method from one of the base classes.
"""
function clang_CXXMethod_isVirtual(C)
    @ccall libclang.clang_CXXMethod_isVirtual(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isCopyAssignmentOperator(C)

Determine if a C++ member function is a copy-assignment operator, returning 1 if such is the case and 0 otherwise.

> A copy-assignment operator `X::operator=` is a non-static, > non-template member function of \\_class\\_ `X` with exactly one > parameter of type `X`, `X&`, `const X&`, `volatile X&` or `const > volatile X&`.

That is, for example, the `operator=` in:

class Foo { bool operator=(const volatile Foo&); };

Is a copy-assignment operator, while the `operator=` in:

class Bar { bool operator=(const int&); };

Is not.
"""
function clang_CXXMethod_isCopyAssignmentOperator(C)
    @ccall libclang.clang_CXXMethod_isCopyAssignmentOperator(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isMoveAssignmentOperator(C)

Determine if a C++ member function is a move-assignment operator, returning 1 if such is the case and 0 otherwise.

> A move-assignment operator `X::operator=` is a non-static, > non-template member function of \\_class\\_ `X` with exactly one > parameter of type `X&&`, `const X&&`, `volatile X&&` or `const > volatile X&&`.

That is, for example, the `operator=` in:

class Foo { bool operator=(const volatile Foo&&); };

Is a move-assignment operator, while the `operator=` in:

class Bar { bool operator=(const int&&); };

Is not.
"""
function clang_CXXMethod_isMoveAssignmentOperator(C)
    @ccall libclang.clang_CXXMethod_isMoveAssignmentOperator(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isExplicit(C)

Determines if a C++ constructor or conversion function was declared explicit, returning 1 if such is the case and 0 otherwise.

Constructors or conversion functions are declared explicit through the use of the explicit specifier.

For example, the following constructor and conversion function are not explicit as they lack the explicit specifier:

class Foo { Foo(); operator int(); };

While the following constructor and conversion function are explicit as they are declared with the explicit specifier.

class Foo { explicit Foo(); explicit operator int(); };

This function will return 0 when given a cursor pointing to one of the former declarations and it will return 1 for a cursor pointing to the latter declarations.

The explicit specifier allows the user to specify a conditional compile-time expression whose value decides whether the marked element is explicit or not.

For example:

constexpr bool foo(int i) { return i % 2 == 0; }

class Foo { explicit(foo(1)) Foo(); explicit(foo(2)) operator int(); }

This function will return 0 for the constructor and 1 for the conversion function.
"""
function clang_CXXMethod_isExplicit(C)
    @ccall libclang.clang_CXXMethod_isExplicit(C::CXCursor)::Cuint
end

"""
    clang_CXXRecord_isAbstract(C)

Determine if a C++ record is abstract, i.e. whether a class or struct has a pure virtual member function.
"""
function clang_CXXRecord_isAbstract(C)
    @ccall libclang.clang_CXXRecord_isAbstract(C::CXCursor)::Cuint
end

"""
    clang_EnumDecl_isScoped(C)

Determine if an enum declaration refers to a scoped enum.
"""
function clang_EnumDecl_isScoped(C)
    @ccall libclang.clang_EnumDecl_isScoped(C::CXCursor)::Cuint
end

"""
    clang_CXXMethod_isConst(C)

Determine if a C++ member function or member function template is declared 'const'.
"""
function clang_CXXMethod_isConst(C)
    @ccall libclang.clang_CXXMethod_isConst(C::CXCursor)::Cuint
end

"""
    clang_getTemplateCursorKind(C)

Given a cursor that represents a template, determine the cursor kind of the specializations would be generated by instantiating the template.

This routine can be used to determine what flavor of function template, class template, or class template partial specialization is stored in the cursor. For example, it can describe whether a class template cursor is declared with "struct", "class" or "union".

# Arguments
* `C`: The cursor to query. This cursor should represent a template declaration.
# Returns
The cursor kind of the specializations that would be generated by instantiating the template `C`. If `C` is not a template, returns `CXCursor_NoDeclFound`.
"""
function clang_getTemplateCursorKind(C)
    @ccall libclang.clang_getTemplateCursorKind(C::CXCursor)::CXCursorKind
end

"""
    clang_getSpecializedCursorTemplate(C)

Given a cursor that may represent a specialization or instantiation of a template, retrieve the cursor that represents the template that it specializes or from which it was instantiated.

This routine determines the template involved both for explicit specializations of templates and for implicit instantiations of the template, both of which are referred to as "specializations". For a class template specialization (e.g., `std`::vector<bool>), this routine will return either the primary template (`std`::vector) or, if the specialization was instantiated from a class template partial specialization, the class template partial specialization. For a class template partial specialization and a function template specialization (including instantiations), this this routine will return the specialized template.

For members of a class template (e.g., member functions, member classes, or static data members), returns the specialized or instantiated member. Although not strictly "templates" in the C++ language, members of class templates have the same notions of specializations and instantiations that templates do, so this routine treats them similarly.

# Arguments
* `C`: A cursor that may be a specialization of a template or a member of a template.
# Returns
If the given cursor is a specialization or instantiation of a template or a member thereof, the template or member that it specializes or from which it was instantiated. Otherwise, returns a NULL cursor.
"""
function clang_getSpecializedCursorTemplate(C)
    @ccall libclang.clang_getSpecializedCursorTemplate(C::CXCursor)::CXCursor
end

"""
    clang_getCursorReferenceNameRange(C, NameFlags, PieceIndex)

Given a cursor that references something else, return the source range covering that reference.

# Arguments
* `C`: A cursor pointing to a member reference, a declaration reference, or an operator call.
* `NameFlags`: A bitset with three independent flags: CXNameRange\\_WantQualifier, CXNameRange\\_WantTemplateArgs, and CXNameRange\\_WantSinglePiece.
* `PieceIndex`: For contiguous names or when passing the flag CXNameRange\\_WantSinglePiece, only one piece with index 0 is available. When the CXNameRange\\_WantSinglePiece flag is not passed for a non-contiguous names, this index can be used to retrieve the individual pieces of the name. See also CXNameRange\\_WantSinglePiece.
# Returns
The piece of the name pointed to by the given cursor. If there is no name, or if the PieceIndex is out-of-range, a null-cursor will be returned.
"""
function clang_getCursorReferenceNameRange(C, NameFlags, PieceIndex)
    @ccall libclang.clang_getCursorReferenceNameRange(C::CXCursor, NameFlags::Cuint, PieceIndex::Cuint)::CXSourceRange
end

"""
    CXNameRefFlags

| Enumerator                     | Note                                                                                                                                                                                                                                                                                                    |
| :----------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CXNameRange\\_WantQualifier    | Include the nested-name-specifier, e.g. Foo:: in x.Foo::y, in the range.                                                                                                                                                                                                                                |
| CXNameRange\\_WantTemplateArgs | Include the explicit template arguments, e.g. <int> in x.f<int>, in the range.                                                                                                                                                                                                                          |
| CXNameRange\\_WantSinglePiece  | If the name is non-contiguous, return the full spanning range.  Non-contiguous names occur in Objective-C when a selector with two or more parameters is used, or in C++ when using an operator:  ```c++  [object doSomething:here withValue:there]; // Objective-C  return some_vector[1]; // C++ ```  |
"""
@cenum CXNameRefFlags::UInt32 begin
    CXNameRange_WantQualifier = 1
    CXNameRange_WantTemplateArgs = 2
    CXNameRange_WantSinglePiece = 4
end

"""
    CXTokenKind

Describes a kind of token.

| Enumerator            | Note                                             |
| :-------------------- | :----------------------------------------------- |
| CXToken\\_Punctuation | A token that contains some kind of punctuation.  |
| CXToken\\_Keyword     | A language keyword.                              |
| CXToken\\_Identifier  | An identifier (that is not a keyword).           |
| CXToken\\_Literal     | A numeric, string, or character literal.         |
| CXToken\\_Comment     | A comment.                                       |
"""
@cenum CXTokenKind::UInt32 begin
    CXToken_Punctuation = 0
    CXToken_Keyword = 1
    CXToken_Identifier = 2
    CXToken_Literal = 3
    CXToken_Comment = 4
end

"""
    CXToken

Describes a single preprocessing token.
"""
struct CXToken
    int_data::NTuple{4, Cuint}
    ptr_data::Ptr{Cvoid}
end

"""
    clang_getToken(TU, Location)

Get the raw lexical token starting with the given location.

# Arguments
* `TU`: the translation unit whose text is being tokenized.
* `Location`: the source location with which the token starts.
# Returns
The token starting with the given location or NULL if no such token exist. The returned pointer must be freed with [`clang_disposeTokens`](@ref) before the translation unit is destroyed.
"""
function clang_getToken(TU, Location)
    @ccall libclang.clang_getToken(TU::CXTranslationUnit, Location::CXSourceLocation)::Ptr{CXToken}
end

"""
    clang_getTokenKind(arg1)

Determine the kind of the given token.
"""
function clang_getTokenKind(arg1)
    @ccall libclang.clang_getTokenKind(arg1::CXToken)::CXTokenKind
end

"""
    clang_getTokenSpelling(arg1, arg2)

Determine the spelling of the given token.

The spelling of a token is the textual representation of that token, e.g., the text of an identifier or keyword.
"""
function clang_getTokenSpelling(arg1, arg2)
    @ccall libclang.clang_getTokenSpelling(arg1::CXTranslationUnit, arg2::CXToken)::CXString
end

"""
    clang_getTokenLocation(arg1, arg2)

Retrieve the source location of the given token.
"""
function clang_getTokenLocation(arg1, arg2)
    @ccall libclang.clang_getTokenLocation(arg1::CXTranslationUnit, arg2::CXToken)::CXSourceLocation
end

"""
    clang_getTokenExtent(arg1, arg2)

Retrieve a source range that covers the given token.
"""
function clang_getTokenExtent(arg1, arg2)
    @ccall libclang.clang_getTokenExtent(arg1::CXTranslationUnit, arg2::CXToken)::CXSourceRange
end

"""
    clang_tokenize(TU, Range, Tokens, NumTokens)

Tokenize the source code described by the given range into raw lexical tokens.

# Arguments
* `TU`: the translation unit whose text is being tokenized.
* `Range`: the source range in which text should be tokenized. All of the tokens produced by tokenization will fall within this source range,
* `Tokens`: this pointer will be set to point to the array of tokens that occur within the given source range. The returned pointer must be freed with [`clang_disposeTokens`](@ref)() before the translation unit is destroyed.
* `NumTokens`: will be set to the number of tokens in the `*Tokens` array.
"""
function clang_tokenize(TU, Range, Tokens, NumTokens)
    @ccall libclang.clang_tokenize(TU::CXTranslationUnit, Range::CXSourceRange, Tokens::Ptr{Ptr{CXToken}}, NumTokens::Ptr{Cuint})::Cvoid
end

"""
    clang_annotateTokens(TU, Tokens, NumTokens, Cursors)

Annotate the given set of tokens by providing cursors for each token that can be mapped to a specific entity within the abstract syntax tree.

This token-annotation routine is equivalent to invoking [`clang_getCursor`](@ref)() for the source locations of each of the tokens. The cursors provided are filtered, so that only those cursors that have a direct correspondence to the token are accepted. For example, given a function call `f`(x), [`clang_getCursor`](@ref)() would provide the following cursors:

* when the cursor is over the 'f', a DeclRefExpr cursor referring to 'f'. * when the cursor is over the '(' or the ')', a CallExpr referring to 'f'. * when the cursor is over the 'x', a DeclRefExpr cursor referring to 'x'.

Only the first and last of these cursors will occur within the annotate, since the tokens "f" and "x' directly refer to a function and a variable, respectively, but the parentheses are just a small part of the full syntax of the function call expression, which is not provided as an annotation.

# Arguments
* `TU`: the translation unit that owns the given tokens.
* `Tokens`: the set of tokens to annotate.
* `NumTokens`: the number of tokens in `Tokens`.
* `Cursors`: an array of `NumTokens` cursors, whose contents will be replaced with the cursors corresponding to each token.
"""
function clang_annotateTokens(TU, Tokens, NumTokens, Cursors)
    @ccall libclang.clang_annotateTokens(TU::CXTranslationUnit, Tokens::Ptr{CXToken}, NumTokens::Cuint, Cursors::Ptr{CXCursor})::Cvoid
end

"""
    clang_disposeTokens(TU, Tokens, NumTokens)

Free the given set of tokens.
"""
function clang_disposeTokens(TU, Tokens, NumTokens)
    @ccall libclang.clang_disposeTokens(TU::CXTranslationUnit, Tokens::Ptr{CXToken}, NumTokens::Cuint)::Cvoid
end

"""
    clang_getCursorKindSpelling(Kind)

` CINDEX_DEBUG Debugging facilities`

These routines are used for testing and debugging, only, and should not be relied upon.

@{
"""
function clang_getCursorKindSpelling(Kind)
    @ccall libclang.clang_getCursorKindSpelling(Kind::CXCursorKind)::CXString
end

function clang_getDefinitionSpellingAndExtent(arg1, startBuf, endBuf, startLine, startColumn, endLine, endColumn)
    @ccall libclang.clang_getDefinitionSpellingAndExtent(arg1::CXCursor, startBuf::Ptr{Cstring}, endBuf::Ptr{Cstring}, startLine::Ptr{Cuint}, startColumn::Ptr{Cuint}, endLine::Ptr{Cuint}, endColumn::Ptr{Cuint})::Cvoid
end

function clang_enableStackTraces()
    @ccall libclang.clang_enableStackTraces()::Cvoid
end

function clang_executeOnThread(fn, user_data, stack_size)
    @ccall libclang.clang_executeOnThread(fn::Ptr{Cvoid}, user_data::Ptr{Cvoid}, stack_size::Cuint)::Cvoid
end

"""
A semantic string that describes a code-completion result.

A semantic string that describes the formatting of a code-completion result as a single "template" of text that should be inserted into the source buffer when a particular code-completion result is selected. Each semantic string is made up of some number of "chunks", each of which contains some text along with a description of what that text means, e.g., the name of the entity being referenced, whether the text chunk is part of the template, or whether it is a "placeholder" that the user should replace with actual code,of a specific kind. See [`CXCompletionChunkKind`](@ref) for a description of the different kinds of chunks.
"""
const CXCompletionString = Ptr{Cvoid}

"""
    CXCompletionResult

A single result of code completion.

| Field            | Note                                                                                                                                                                                                                                                                                                                                               |
| :--------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CursorKind       | The kind of entity that this completion refers to.  The cursor kind will be a macro, keyword, or a declaration (one of the *Decl cursor kinds), describing the entity that the completion is referring to.  \\todo In the future, we would like to provide a full cursor, to allow the client to extract additional information from declaration.  |
| CompletionString | The code-completion string that describes how to insert this code-completion result into the editing buffer.                                                                                                                                                                                                                                       |
"""
struct CXCompletionResult
    CursorKind::CXCursorKind
    CompletionString::CXCompletionString
end

"""
    CXCompletionChunkKind

Describes a single piece of text within a code-completion string.

Each "chunk" within a code-completion string ([`CXCompletionString`](@ref)) is either a piece of text with a specific "kind" that describes how that text should be interpreted by the client or is another completion string.

| Enumerator                           | Note                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| :----------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXCompletionChunk\\_Optional         | A code-completion string that describes "optional" text that could be a part of the template (but is not required).  The Optional chunk is the only kind of chunk that has a code-completion string for its representation, which is accessible via [`clang_getCompletionChunkCompletionString`](@ref)(). The code-completion string describes an additional part of the template that is completely optional. For example, optional chunks can be used to describe the placeholders for arguments that match up with defaulted function parameters, e.g. given:  ```c++  void f(int x, float y = 3.14, double z = 2.71828); ```  The code-completion string for this function would contain: - a TypedText chunk for "f". - a LeftParen chunk for "(". - a Placeholder chunk for "int x" - an Optional chunk containing the remaining defaulted arguments, e.g., - a Comma chunk for "," - a Placeholder chunk for "float y" - an Optional chunk containing the last defaulted argument: - a Comma chunk for "," - a Placeholder chunk for "double z" - a RightParen chunk for ")"  There are many ways to handle Optional chunks. Two simple approaches are: - Completely ignore optional chunks, in which case the template for the function "f" would only include the first parameter ("int x"). - Fully expand all optional chunks, in which case the template for the function "f" would have all of the parameters.  |
| CXCompletionChunk\\_TypedText        | Text that a user would be expected to type to get this code-completion result.  There will be exactly one "typed text" chunk in a semantic string, which will typically provide the spelling of a keyword or the name of a declaration that could be used at the current code point. Clients are expected to filter the code-completion results based on the text in this chunk.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCompletionChunk\\_Text             | Text that should be inserted as part of a code-completion result.  A "text" chunk represents text that is part of the template to be inserted into user code should this particular code-completion result be selected.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCompletionChunk\\_Placeholder      | Placeholder text that should be replaced by the user.  A "placeholder" chunk marks a place where the user should insert text into the code-completion template. For example, placeholders might mark the function parameters for a function declaration, to indicate that the user should provide arguments for each of those parameters. The actual text in a placeholder is a suggestion for the text to display before the user replaces the placeholder with real code.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCompletionChunk\\_Informative      | Informative text that should be displayed but never inserted as part of the template.  An "informative" chunk contains annotations that can be displayed to help the user decide whether a particular code-completion result is the right option, but which is not part of the actual template to be inserted by code completion.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| CXCompletionChunk\\_CurrentParameter | Text that describes the current parameter when code-completion is referring to function call, message send, or template specialization.  A "current parameter" chunk occurs when code-completion is providing information about a parameter corresponding to the argument at the code-completion point. For example, given a function  ```c++  int add(int x, int y); ```  and the source code `add`(, where the code-completion point is after the "(", the code-completion string will contain a "current parameter" chunk for "int x", indicating that the current argument will initialize that parameter. After typing further, to `add`(17, (where the code-completion point is after the ","), the code-completion string will contain a "current parameter" chunk to "int y".                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCompletionChunk\\_LeftParen        | A left parenthesis ('('), used to initiate a function call or signal the beginning of a function parameter list.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| CXCompletionChunk\\_RightParen       | A right parenthesis (')'), used to finish a function call or signal the end of a function parameter list.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| CXCompletionChunk\\_LeftBracket      | A left bracket ('[').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| CXCompletionChunk\\_RightBracket     | A right bracket (']').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| CXCompletionChunk\\_LeftBrace        | A left brace ('{').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| CXCompletionChunk\\_RightBrace       | A right brace ('}').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| CXCompletionChunk\\_LeftAngle        | A left angle bracket ('<').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| CXCompletionChunk\\_RightAngle       | A right angle bracket ('>').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCompletionChunk\\_Comma            | A comma separator (',').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| CXCompletionChunk\\_ResultType       | Text that specifies the result type of a given result.  This special kind of informative chunk is not meant to be inserted into the text buffer. Rather, it is meant to illustrate the type that an expression using the given completion string would have.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCompletionChunk\\_Colon            | A colon (':').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| CXCompletionChunk\\_SemiColon        | A semicolon (';').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| CXCompletionChunk\\_Equal            | An '=' sign.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| CXCompletionChunk\\_HorizontalSpace  | Horizontal space (' ').                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| CXCompletionChunk\\_VerticalSpace    | Vertical space ('\\n'), after which it is generally a good idea to perform indentation.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
"""
@cenum CXCompletionChunkKind::UInt32 begin
    CXCompletionChunk_Optional = 0
    CXCompletionChunk_TypedText = 1
    CXCompletionChunk_Text = 2
    CXCompletionChunk_Placeholder = 3
    CXCompletionChunk_Informative = 4
    CXCompletionChunk_CurrentParameter = 5
    CXCompletionChunk_LeftParen = 6
    CXCompletionChunk_RightParen = 7
    CXCompletionChunk_LeftBracket = 8
    CXCompletionChunk_RightBracket = 9
    CXCompletionChunk_LeftBrace = 10
    CXCompletionChunk_RightBrace = 11
    CXCompletionChunk_LeftAngle = 12
    CXCompletionChunk_RightAngle = 13
    CXCompletionChunk_Comma = 14
    CXCompletionChunk_ResultType = 15
    CXCompletionChunk_Colon = 16
    CXCompletionChunk_SemiColon = 17
    CXCompletionChunk_Equal = 18
    CXCompletionChunk_HorizontalSpace = 19
    CXCompletionChunk_VerticalSpace = 20
end

"""
    clang_getCompletionChunkKind(completion_string, chunk_number)

Determine the kind of a particular chunk within a completion string.

# Arguments
* `completion_string`: the completion string to query.
* `chunk_number`: the 0-based index of the chunk in the completion string.
# Returns
the kind of the chunk at the index `chunk_number`.
"""
function clang_getCompletionChunkKind(completion_string, chunk_number)
    @ccall libclang.clang_getCompletionChunkKind(completion_string::CXCompletionString, chunk_number::Cuint)::CXCompletionChunkKind
end

"""
    clang_getCompletionChunkText(completion_string, chunk_number)

Retrieve the text associated with a particular chunk within a completion string.

# Arguments
* `completion_string`: the completion string to query.
* `chunk_number`: the 0-based index of the chunk in the completion string.
# Returns
the text associated with the chunk at index `chunk_number`.
"""
function clang_getCompletionChunkText(completion_string, chunk_number)
    @ccall libclang.clang_getCompletionChunkText(completion_string::CXCompletionString, chunk_number::Cuint)::CXString
end

"""
    clang_getCompletionChunkCompletionString(completion_string, chunk_number)

Retrieve the completion string associated with a particular chunk within a completion string.

# Arguments
* `completion_string`: the completion string to query.
* `chunk_number`: the 0-based index of the chunk in the completion string.
# Returns
the completion string associated with the chunk at index `chunk_number`.
"""
function clang_getCompletionChunkCompletionString(completion_string, chunk_number)
    @ccall libclang.clang_getCompletionChunkCompletionString(completion_string::CXCompletionString, chunk_number::Cuint)::CXCompletionString
end

"""
    clang_getNumCompletionChunks(completion_string)

Retrieve the number of chunks in the given code-completion string.
"""
function clang_getNumCompletionChunks(completion_string)
    @ccall libclang.clang_getNumCompletionChunks(completion_string::CXCompletionString)::Cuint
end

"""
    clang_getCompletionPriority(completion_string)

Determine the priority of this code completion.

The priority of a code completion indicates how likely it is that this particular completion is the completion that the user will select. The priority is selected by various internal heuristics.

# Arguments
* `completion_string`: The completion string to query.
# Returns
The priority of this completion string. Smaller values indicate higher-priority (more likely) completions.
"""
function clang_getCompletionPriority(completion_string)
    @ccall libclang.clang_getCompletionPriority(completion_string::CXCompletionString)::Cuint
end

"""
    clang_getCompletionAvailability(completion_string)

Determine the availability of the entity that this code-completion string refers to.

# Arguments
* `completion_string`: The completion string to query.
# Returns
The availability of the completion string.
"""
function clang_getCompletionAvailability(completion_string)
    @ccall libclang.clang_getCompletionAvailability(completion_string::CXCompletionString)::CXAvailabilityKind
end

"""
    clang_getCompletionNumAnnotations(completion_string)

Retrieve the number of annotations associated with the given completion string.

# Arguments
* `completion_string`: the completion string to query.
# Returns
the number of annotations associated with the given completion string.
"""
function clang_getCompletionNumAnnotations(completion_string)
    @ccall libclang.clang_getCompletionNumAnnotations(completion_string::CXCompletionString)::Cuint
end

"""
    clang_getCompletionAnnotation(completion_string, annotation_number)

Retrieve the annotation associated with the given completion string.

# Arguments
* `completion_string`: the completion string to query.
* `annotation_number`: the 0-based index of the annotation of the completion string.
# Returns
annotation string associated with the completion at index `annotation_number`, or a NULL string if that annotation is not available.
"""
function clang_getCompletionAnnotation(completion_string, annotation_number)
    @ccall libclang.clang_getCompletionAnnotation(completion_string::CXCompletionString, annotation_number::Cuint)::CXString
end

"""
    clang_getCompletionParent(completion_string, kind)

Retrieve the parent context of the given completion string.

The parent context of a completion string is the semantic parent of the declaration (if any) that the code completion represents. For example, a code completion for an Objective-C method would have the method's class or protocol as its context.

# Arguments
* `completion_string`: The code completion string whose parent is being queried.
* `kind`: DEPRECATED: always set to CXCursor\\_NotImplemented if non-NULL.
# Returns
The name of the completion parent, e.g., "NSObject" if the completion string represents a method in the NSObject class.
"""
function clang_getCompletionParent(completion_string, kind)
    @ccall libclang.clang_getCompletionParent(completion_string::CXCompletionString, kind::Ptr{CXCursorKind})::CXString
end

"""
    clang_getCompletionBriefComment(completion_string)

Retrieve the brief documentation comment attached to the declaration that corresponds to the given completion string.
"""
function clang_getCompletionBriefComment(completion_string)
    @ccall libclang.clang_getCompletionBriefComment(completion_string::CXCompletionString)::CXString
end

"""
    clang_getCursorCompletionString(cursor)

Retrieve a completion string for an arbitrary declaration or macro definition cursor.

# Arguments
* `cursor`: The cursor to query.
# Returns
A non-context-sensitive completion string for declaration and macro definition cursors, or NULL for other kinds of cursors.
"""
function clang_getCursorCompletionString(cursor)
    @ccall libclang.clang_getCursorCompletionString(cursor::CXCursor)::CXCompletionString
end

"""
    CXCodeCompleteResults

Contains the results of code-completion.

This data structure contains the results of code completion, as produced by [`clang_codeCompleteAt`](@ref)(). Its contents must be freed by [`clang_disposeCodeCompleteResults`](@ref).

| Field      | Note                                                                  |
| :--------- | :-------------------------------------------------------------------- |
| Results    | The code-completion results.                                          |
| NumResults | The number of code-completion results stored in the `Results` array.  |
"""
struct CXCodeCompleteResults
    Results::Ptr{CXCompletionResult}
    NumResults::Cuint
end

"""
    clang_getCompletionNumFixIts(results, completion_index)

Retrieve the number of fix-its for the given completion index.

Calling this makes sense only if CXCodeComplete\\_IncludeCompletionsWithFixIts option was set.

# Arguments
* `results`: The structure keeping all completion results
* `completion_index`: The index of the completion
# Returns
The number of fix-its which must be applied before the completion at completion\\_index can be applied
"""
function clang_getCompletionNumFixIts(results, completion_index)
    @ccall libclang.clang_getCompletionNumFixIts(results::Ptr{CXCodeCompleteResults}, completion_index::Cuint)::Cuint
end

"""
    clang_getCompletionFixIt(results, completion_index, fixit_index, replacement_range)

Fix-its that *must* be applied before inserting the text for the corresponding completion.

By default, [`clang_codeCompleteAt`](@ref)() only returns completions with empty fix-its. Extra completions with non-empty fix-its should be explicitly requested by setting CXCodeComplete\\_IncludeCompletionsWithFixIts.

For the clients to be able to compute position of the cursor after applying fix-its, the following conditions are guaranteed to hold for replacement\\_range of the stored fix-its: - Ranges in the fix-its are guaranteed to never contain the completion point (or identifier under completion point, if any) inside them, except at the start or at the end of the range. - If a fix-it range starts or ends with completion point (or starts or ends after the identifier under completion point), it will contain at least one character. It allows to unambiguously recompute completion point after applying the fix-it.

The intuition is that provided fix-its change code around the identifier we complete, but are not allowed to touch the identifier itself or the completion point. One example of completions with corrections are the ones replacing '.' with '->' and vice versa:

std::unique\\_ptr<std::vector<int>> vec\\_ptr; In 'vec\\_ptr.^', one of the completions is 'push\\_back', it requires replacing '.' with '->'. In 'vec\\_ptr->^', one of the completions is 'release', it requires replacing '->' with '.'.

# Arguments
* `results`: The structure keeping all completion results
* `completion_index`: The index of the completion
* `fixit_index`: The index of the fix-it for the completion at completion\\_index
* `replacement_range`: The fix-it range that must be replaced before the completion at completion\\_index can be applied
# Returns
The fix-it string that must replace the code at replacement\\_range before the completion at completion\\_index can be applied
"""
function clang_getCompletionFixIt(results, completion_index, fixit_index, replacement_range)
    @ccall libclang.clang_getCompletionFixIt(results::Ptr{CXCodeCompleteResults}, completion_index::Cuint, fixit_index::Cuint, replacement_range::Ptr{CXSourceRange})::CXString
end

"""
    CXCodeComplete_Flags

Flags that can be passed to [`clang_codeCompleteAt`](@ref)() to modify its behavior.

The enumerators in this enumeration can be bitwise-OR'd together to provide multiple options to [`clang_codeCompleteAt`](@ref)().

| Enumerator                                    | Note                                                                                                                                                                                                                   |
| :-------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXCodeComplete\\_IncludeMacros                | Whether to include macros within the set of code completions returned.                                                                                                                                                 |
| CXCodeComplete\\_IncludeCodePatterns          | Whether to include code patterns for language constructs within the set of code completions, e.g., for loops.                                                                                                          |
| CXCodeComplete\\_IncludeBriefComments         | Whether to include brief documentation within the set of code completions returned.                                                                                                                                    |
| CXCodeComplete\\_SkipPreamble                 | Whether to speed up completion by omitting top- or namespace-level entities defined in the preamble. There's no guarantee any particular entity is omitted. This may be useful if the headers are indexed externally.  |
| CXCodeComplete\\_IncludeCompletionsWithFixIts | Whether to include completions with small fix-its, e.g. change '.' to '->' on member access, etc.                                                                                                                      |
"""
@cenum CXCodeComplete_Flags::UInt32 begin
    CXCodeComplete_IncludeMacros = 1
    CXCodeComplete_IncludeCodePatterns = 2
    CXCodeComplete_IncludeBriefComments = 4
    CXCodeComplete_SkipPreamble = 8
    CXCodeComplete_IncludeCompletionsWithFixIts = 16
end

"""
    CXCompletionContext

Bits that represent the context under which completion is occurring.

The enumerators in this enumeration may be bitwise-OR'd together if multiple contexts are occurring simultaneously.

| Enumerator                                | Note                                                                                                                                     |
| :---------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| CXCompletionContext\\_Unexposed           | The context for completions is unexposed, as only Clang results should be included. (This is equivalent to having no context bits set.)  |
| CXCompletionContext\\_AnyType             | Completions for any possible type should be included in the results.                                                                     |
| CXCompletionContext\\_AnyValue            | Completions for any possible value (variables, function calls, etc.) should be included in the results.                                  |
| CXCompletionContext\\_ObjCObjectValue     | Completions for values that resolve to an Objective-C object should be included in the results.                                          |
| CXCompletionContext\\_ObjCSelectorValue   | Completions for values that resolve to an Objective-C selector should be included in the results.                                        |
| CXCompletionContext\\_CXXClassTypeValue   | Completions for values that resolve to a C++ class type should be included in the results.                                               |
| CXCompletionContext\\_DotMemberAccess     | Completions for fields of the member being accessed using the dot operator should be included in the results.                            |
| CXCompletionContext\\_ArrowMemberAccess   | Completions for fields of the member being accessed using the arrow operator should be included in the results.                          |
| CXCompletionContext\\_ObjCPropertyAccess  | Completions for properties of the Objective-C object being accessed using the dot operator should be included in the results.            |
| CXCompletionContext\\_EnumTag             | Completions for enum tags should be included in the results.                                                                             |
| CXCompletionContext\\_UnionTag            | Completions for union tags should be included in the results.                                                                            |
| CXCompletionContext\\_StructTag           | Completions for struct tags should be included in the results.                                                                           |
| CXCompletionContext\\_ClassTag            | Completions for C++ class names should be included in the results.                                                                       |
| CXCompletionContext\\_Namespace           | Completions for C++ namespaces and namespace aliases should be included in the results.                                                  |
| CXCompletionContext\\_NestedNameSpecifier | Completions for C++ nested name specifiers should be included in the results.                                                            |
| CXCompletionContext\\_ObjCInterface       | Completions for Objective-C interfaces (classes) should be included in the results.                                                      |
| CXCompletionContext\\_ObjCProtocol        | Completions for Objective-C protocols should be included in the results.                                                                 |
| CXCompletionContext\\_ObjCCategory        | Completions for Objective-C categories should be included in the results.                                                                |
| CXCompletionContext\\_ObjCInstanceMessage | Completions for Objective-C instance messages should be included in the results.                                                         |
| CXCompletionContext\\_ObjCClassMessage    | Completions for Objective-C class messages should be included in the results.                                                            |
| CXCompletionContext\\_ObjCSelectorName    | Completions for Objective-C selector names should be included in the results.                                                            |
| CXCompletionContext\\_MacroName           | Completions for preprocessor macro names should be included in the results.                                                              |
| CXCompletionContext\\_NaturalLanguage     | Natural language completions should be included in the results.                                                                          |
| CXCompletionContext\\_IncludedFile        | #include file completions should be included in the results.                                                                             |
| CXCompletionContext\\_Unknown             | The current context is unknown, so set all contexts.                                                                                     |
"""
@cenum CXCompletionContext::UInt32 begin
    CXCompletionContext_Unexposed = 0
    CXCompletionContext_AnyType = 1
    CXCompletionContext_AnyValue = 2
    CXCompletionContext_ObjCObjectValue = 4
    CXCompletionContext_ObjCSelectorValue = 8
    CXCompletionContext_CXXClassTypeValue = 16
    CXCompletionContext_DotMemberAccess = 32
    CXCompletionContext_ArrowMemberAccess = 64
    CXCompletionContext_ObjCPropertyAccess = 128
    CXCompletionContext_EnumTag = 256
    CXCompletionContext_UnionTag = 512
    CXCompletionContext_StructTag = 1024
    CXCompletionContext_ClassTag = 2048
    CXCompletionContext_Namespace = 4096
    CXCompletionContext_NestedNameSpecifier = 8192
    CXCompletionContext_ObjCInterface = 16384
    CXCompletionContext_ObjCProtocol = 32768
    CXCompletionContext_ObjCCategory = 65536
    CXCompletionContext_ObjCInstanceMessage = 131072
    CXCompletionContext_ObjCClassMessage = 262144
    CXCompletionContext_ObjCSelectorName = 524288
    CXCompletionContext_MacroName = 1048576
    CXCompletionContext_NaturalLanguage = 2097152
    CXCompletionContext_IncludedFile = 4194304
    CXCompletionContext_Unknown = 8388607
end

"""
    clang_defaultCodeCompleteOptions()

Returns a default set of code-completion options that can be passed to[`clang_codeCompleteAt`](@ref)().
"""
function clang_defaultCodeCompleteOptions()
    @ccall libclang.clang_defaultCodeCompleteOptions()::Cuint
end

"""
    clang_codeCompleteAt(TU, complete_filename, complete_line, complete_column, unsaved_files, num_unsaved_files, options)

Perform code completion at a given location in a translation unit.

This function performs code completion at a particular file, line, and column within source code, providing results that suggest potential code snippets based on the context of the completion. The basic model for code completion is that Clang will parse a complete source file, performing syntax checking up to the location where code-completion has been requested. At that point, a special code-completion token is passed to the parser, which recognizes this token and determines, based on the current location in the C/Objective-C/C++ grammar and the state of semantic analysis, what completions to provide. These completions are returned via a new [`CXCodeCompleteResults`](@ref) structure.

Code completion itself is meant to be triggered by the client when the user types punctuation characters or whitespace, at which point the code-completion location will coincide with the cursor. For example, if `p` is a pointer, code-completion might be triggered after the "-" and then after the ">" in `p`->. When the code-completion location is after the ">", the completion results will provide, e.g., the members of the struct that "p" points to. The client is responsible for placing the cursor at the beginning of the token currently being typed, then filtering the results based on the contents of the token. For example, when code-completing for the expression `p`->get, the client should provide the location just after the ">" (e.g., pointing at the "g") to this code-completion hook. Then, the client can filter the results based on the current token text ("get"), only showing those results that start with "get". The intent of this interface is to separate the relatively high-latency acquisition of code-completion results from the filtering of results on a per-character basis, which must have a lower latency.

# Arguments
* `TU`: The translation unit in which code-completion should occur. The source files for this translation unit need not be completely up-to-date (and the contents of those source files may be overridden via `unsaved_files`). Cursors referring into the translation unit may be invalidated by this invocation.
* `complete_filename`: The name of the source file where code completion should be performed. This filename may be any file included in the translation unit.
* `complete_line`: The line at which code-completion should occur.
* `complete_column`: The column at which code-completion should occur. Note that the column should point just after the syntactic construct that initiated code completion, and not in the middle of a lexical token.
* `unsaved_files`: the Files that have not yet been saved to disk but may be required for parsing or code completion, including the contents of those files. The contents and name of these files (as specified by [`CXUnsavedFile`](@ref)) are copied when necessary, so the client only needs to guarantee their validity until the call to this function returns.
* `num_unsaved_files`: The number of unsaved file entries in `unsaved_files`.
* `options`: Extra options that control the behavior of code completion, expressed as a bitwise OR of the enumerators of the [`CXCodeComplete_Flags`](@ref) enumeration. The [`clang_defaultCodeCompleteOptions`](@ref)() function returns a default set of code-completion options.
# Returns
If successful, a new [`CXCodeCompleteResults`](@ref) structure containing code-completion results, which should eventually be freed with [`clang_disposeCodeCompleteResults`](@ref)(). If code completion fails, returns NULL.
"""
function clang_codeCompleteAt(TU, complete_filename, complete_line, complete_column, unsaved_files, num_unsaved_files, options)
    @ccall libclang.clang_codeCompleteAt(TU::CXTranslationUnit, complete_filename::Cstring, complete_line::Cuint, complete_column::Cuint, unsaved_files::Ptr{CXUnsavedFile}, num_unsaved_files::Cuint, options::Cuint)::Ptr{CXCodeCompleteResults}
end

"""
    clang_sortCodeCompletionResults(Results, NumResults)

Sort the code-completion results in case-insensitive alphabetical order.

# Arguments
* `Results`: The set of results to sort.
* `NumResults`: The number of results in `Results`.
"""
function clang_sortCodeCompletionResults(Results, NumResults)
    @ccall libclang.clang_sortCodeCompletionResults(Results::Ptr{CXCompletionResult}, NumResults::Cuint)::Cvoid
end

"""
    clang_disposeCodeCompleteResults(Results)

Free the given set of code-completion results.
"""
function clang_disposeCodeCompleteResults(Results)
    @ccall libclang.clang_disposeCodeCompleteResults(Results::Ptr{CXCodeCompleteResults})::Cvoid
end

"""
    clang_codeCompleteGetNumDiagnostics(Results)

Determine the number of diagnostics produced prior to the location where code completion was performed.
"""
function clang_codeCompleteGetNumDiagnostics(Results)
    @ccall libclang.clang_codeCompleteGetNumDiagnostics(Results::Ptr{CXCodeCompleteResults})::Cuint
end

"""
    clang_codeCompleteGetDiagnostic(Results, Index)

Retrieve a diagnostic associated with the given code completion.

# Arguments
* `Results`: the code completion results to query.
* `Index`: the zero-based diagnostic number to retrieve.
# Returns
the requested diagnostic. This diagnostic must be freed via a call to [`clang_disposeDiagnostic`](@ref)().
"""
function clang_codeCompleteGetDiagnostic(Results, Index)
    @ccall libclang.clang_codeCompleteGetDiagnostic(Results::Ptr{CXCodeCompleteResults}, Index::Cuint)::CXDiagnostic
end

"""
    clang_codeCompleteGetContexts(Results)

Determines what completions are appropriate for the context the given code completion.

# Arguments
* `Results`: the code completion results to query
# Returns
the kinds of completions that are appropriate for use along with the given code completion results.
"""
function clang_codeCompleteGetContexts(Results)
    @ccall libclang.clang_codeCompleteGetContexts(Results::Ptr{CXCodeCompleteResults})::Culonglong
end

"""
    clang_codeCompleteGetContainerKind(Results, IsIncomplete)

Returns the cursor kind for the container for the current code completion context. The container is only guaranteed to be set for contexts where a container exists (i.e. member accesses or Objective-C message sends); if there is not a container, this function will return CXCursor\\_InvalidCode.

# Arguments
* `Results`: the code completion results to query
* `IsIncomplete`: on return, this value will be false if Clang has complete information about the container. If Clang does not have complete information, this value will be true.
# Returns
the container kind, or CXCursor\\_InvalidCode if there is not a container
"""
function clang_codeCompleteGetContainerKind(Results, IsIncomplete)
    @ccall libclang.clang_codeCompleteGetContainerKind(Results::Ptr{CXCodeCompleteResults}, IsIncomplete::Ptr{Cuint})::CXCursorKind
end

"""
    clang_codeCompleteGetContainerUSR(Results)

Returns the USR for the container for the current code completion context. If there is not a container for the current context, this function will return the empty string.

# Arguments
* `Results`: the code completion results to query
# Returns
the USR for the container
"""
function clang_codeCompleteGetContainerUSR(Results)
    @ccall libclang.clang_codeCompleteGetContainerUSR(Results::Ptr{CXCodeCompleteResults})::CXString
end

"""
    clang_codeCompleteGetObjCSelector(Results)

Returns the currently-entered selector for an Objective-C message send, formatted like "initWithFoo:bar:". Only guaranteed to return a non-empty string for CXCompletionContext\\_ObjCInstanceMessage and CXCompletionContext\\_ObjCClassMessage.

# Arguments
* `Results`: the code completion results to query
# Returns
the selector (or partial selector) that has been entered thus far for an Objective-C message send.
"""
function clang_codeCompleteGetObjCSelector(Results)
    @ccall libclang.clang_codeCompleteGetObjCSelector(Results::Ptr{CXCodeCompleteResults})::CXString
end

"""
    clang_getClangVersion()

Return a version string, suitable for showing to a user, but not intended to be parsed (the format is not guaranteed to be stable).
"""
function clang_getClangVersion()
    @ccall libclang.clang_getClangVersion()::CXString
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

# typedef void ( * CXInclusionVisitor ) ( CXFile included_file , CXSourceLocation * inclusion_stack , unsigned include_len , CXClientData client_data )
"""
Visitor invoked for each file in a translation unit (used with [`clang_getInclusions`](@ref)()).

This visitor function will be invoked by [`clang_getInclusions`](@ref)() for each file included (either at the top-level or by #include directives) within a translation unit. The first argument is the file being included, and the second and third arguments provide the inclusion stack. The array is sorted in order of immediate inclusion. For example, the first element refers to the location that included 'included\\_file'.
"""
const CXInclusionVisitor = Ptr{Cvoid}

"""
    clang_getInclusions(tu, visitor, client_data)

Visit the set of preprocessor inclusions in a translation unit. The visitor function is called with the provided data for every included file. This does not include headers included by the PCH file (unless one is inspecting the inclusions in the PCH file itself).
"""
function clang_getInclusions(tu, visitor, client_data)
    @ccall libclang.clang_getInclusions(tu::CXTranslationUnit, visitor::CXInclusionVisitor, client_data::CXClientData)::Cvoid
end

@cenum CXEvalResultKind::UInt32 begin
    CXEval_Int = 1
    CXEval_Float = 2
    CXEval_ObjCStrLiteral = 3
    CXEval_StrLiteral = 4
    CXEval_CFStr = 5
    CXEval_Other = 6
    CXEval_UnExposed = 0
end

"""
Evaluation result of a cursor
"""
const CXEvalResult = Ptr{Cvoid}

"""
    clang_Cursor_Evaluate(C)

If cursor is a statement declaration tries to evaluate the statement and if its variable, tries to evaluate its initializer, into its corresponding type. If it's an expression, tries to evaluate the expression.
"""
function clang_Cursor_Evaluate(C)
    @ccall libclang.clang_Cursor_Evaluate(C::CXCursor)::CXEvalResult
end

"""
    clang_EvalResult_getKind(E)

Returns the kind of the evaluated result.
"""
function clang_EvalResult_getKind(E)
    @ccall libclang.clang_EvalResult_getKind(E::CXEvalResult)::CXEvalResultKind
end

"""
    clang_EvalResult_getAsInt(E)

Returns the evaluation result as integer if the kind is Int.
"""
function clang_EvalResult_getAsInt(E)
    @ccall libclang.clang_EvalResult_getAsInt(E::CXEvalResult)::Cint
end

"""
    clang_EvalResult_getAsLongLong(E)

Returns the evaluation result as a long long integer if the kind is Int. This prevents overflows that may happen if the result is returned with [`clang_EvalResult_getAsInt`](@ref).
"""
function clang_EvalResult_getAsLongLong(E)
    @ccall libclang.clang_EvalResult_getAsLongLong(E::CXEvalResult)::Clonglong
end

"""
    clang_EvalResult_isUnsignedInt(E)

Returns a non-zero value if the kind is Int and the evaluation result resulted in an unsigned integer.
"""
function clang_EvalResult_isUnsignedInt(E)
    @ccall libclang.clang_EvalResult_isUnsignedInt(E::CXEvalResult)::Cuint
end

"""
    clang_EvalResult_getAsUnsigned(E)

Returns the evaluation result as an unsigned integer if the kind is Int and [`clang_EvalResult_isUnsignedInt`](@ref) is non-zero.
"""
function clang_EvalResult_getAsUnsigned(E)
    @ccall libclang.clang_EvalResult_getAsUnsigned(E::CXEvalResult)::Culonglong
end

"""
    clang_EvalResult_getAsDouble(E)

Returns the evaluation result as double if the kind is double.
"""
function clang_EvalResult_getAsDouble(E)
    @ccall libclang.clang_EvalResult_getAsDouble(E::CXEvalResult)::Cdouble
end

"""
    clang_EvalResult_getAsStr(E)

Returns the evaluation result as a constant string if the kind is other than Int or float. User must not free this pointer, instead call [`clang_EvalResult_dispose`](@ref) on the [`CXEvalResult`](@ref) returned by [`clang_Cursor_Evaluate`](@ref).
"""
function clang_EvalResult_getAsStr(E)
    @ccall libclang.clang_EvalResult_getAsStr(E::CXEvalResult)::Cstring
end

"""
    clang_EvalResult_dispose(E)

Disposes the created Eval memory.
"""
function clang_EvalResult_dispose(E)
    @ccall libclang.clang_EvalResult_dispose(E::CXEvalResult)::Cvoid
end

"""
A remapping of original source files and their translated files.
"""
const CXRemapping = Ptr{Cvoid}

"""
    clang_getRemappings(path)

Retrieve a remapping.

# Arguments
* `path`: the path that contains metadata about remappings.
# Returns
the requested remapping. This remapping must be freed via a call to [`clang_remap_dispose`](@ref)(). Can return NULL if an error occurred.
"""
function clang_getRemappings(path)
    @ccall libclang.clang_getRemappings(path::Cstring)::CXRemapping
end

"""
    clang_getRemappingsFromFileList(filePaths, numFiles)

Retrieve a remapping.

# Arguments
* `filePaths`: pointer to an array of file paths containing remapping info.
* `numFiles`: number of file paths.
# Returns
the requested remapping. This remapping must be freed via a call to [`clang_remap_dispose`](@ref)(). Can return NULL if an error occurred.
"""
function clang_getRemappingsFromFileList(filePaths, numFiles)
    @ccall libclang.clang_getRemappingsFromFileList(filePaths::Ptr{Cstring}, numFiles::Cuint)::CXRemapping
end

"""
    clang_remap_getNumFiles(arg1)

Determine the number of remappings.
"""
function clang_remap_getNumFiles(arg1)
    @ccall libclang.clang_remap_getNumFiles(arg1::CXRemapping)::Cuint
end

"""
    clang_remap_getFilenames(arg1, index, original, transformed)

Get the original and the associated filename from the remapping.

# Arguments
* `original`: If non-NULL, will be set to the original filename.
* `transformed`: If non-NULL, will be set to the filename that the original is associated with.
"""
function clang_remap_getFilenames(arg1, index, original, transformed)
    @ccall libclang.clang_remap_getFilenames(arg1::CXRemapping, index::Cuint, original::Ptr{CXString}, transformed::Ptr{CXString})::Cvoid
end

"""
    clang_remap_dispose(arg1)

Dispose the remapping.
"""
function clang_remap_dispose(arg1)
    @ccall libclang.clang_remap_dispose(arg1::CXRemapping)::Cvoid
end

"""
    CXVisitorResult

` CINDEX_HIGH Higher level API functions`

@{
"""
@cenum CXVisitorResult::UInt32 begin
    CXVisit_Break = 0
    CXVisit_Continue = 1
end

struct CXCursorAndRangeVisitor
    context::Ptr{Cvoid}
    visit::Ptr{Cvoid}
end

"""
    CXResult

| Enumerator            | Note                                                                          |
| :-------------------- | :---------------------------------------------------------------------------- |
| CXResult\\_Success    | Function returned successfully.                                               |
| CXResult\\_Invalid    | One of the parameters was invalid for the function.                           |
| CXResult\\_VisitBreak | The function was terminated by a callback (e.g. it returned CXVisit\\_Break)  |
"""
@cenum CXResult::UInt32 begin
    CXResult_Success = 0
    CXResult_Invalid = 1
    CXResult_VisitBreak = 2
end

"""
    clang_findReferencesInFile(cursor, file, visitor)

Find references of a declaration in a specific file.

# Arguments
* `cursor`: pointing to a declaration or a reference of one.
* `file`: to search for references.
* `visitor`: callback that will receive pairs of [`CXCursor`](@ref)/[`CXSourceRange`](@ref) for each reference found. The [`CXSourceRange`](@ref) will point inside the file; if the reference is inside a macro (and not a macro argument) the [`CXSourceRange`](@ref) will be invalid.
# Returns
one of the [`CXResult`](@ref) enumerators.
"""
function clang_findReferencesInFile(cursor, file, visitor)
    @ccall libclang.clang_findReferencesInFile(cursor::CXCursor, file::CXFile, visitor::CXCursorAndRangeVisitor)::CXResult
end

"""
    clang_findIncludesInFile(TU, file, visitor)

Find #import/#include directives in a specific file.

# Arguments
* `TU`: translation unit containing the file to query.
* `file`: to search for #import/#include directives.
* `visitor`: callback that will receive pairs of [`CXCursor`](@ref)/[`CXSourceRange`](@ref) for each directive found.
# Returns
one of the [`CXResult`](@ref) enumerators.
"""
function clang_findIncludesInFile(TU, file, visitor)
    @ccall libclang.clang_findIncludesInFile(TU::CXTranslationUnit, file::CXFile, visitor::CXCursorAndRangeVisitor)::CXResult
end

"""
The client's data object that is associated with a [`CXFile`](@ref).
"""
const CXIdxClientFile = Ptr{Cvoid}

"""
The client's data object that is associated with a semantic entity.
"""
const CXIdxClientEntity = Ptr{Cvoid}

"""
The client's data object that is associated with a semantic container of entities.
"""
const CXIdxClientContainer = Ptr{Cvoid}

"""
The client's data object that is associated with an AST file (PCH or module).
"""
const CXIdxClientASTFile = Ptr{Cvoid}

"""
    CXIdxLoc

Source location passed to index callbacks.
"""
struct CXIdxLoc
    ptr_data::NTuple{2, Ptr{Cvoid}}
    int_data::Cuint
end

"""
    CXIdxIncludedFileInfo

Data for ppIncludedFile callback.

| Field          | Note                                                                      |
| :------------- | :------------------------------------------------------------------------ |
| hashLoc        | Location of '#' in the #include/#import directive.                        |
| filename       | Filename as written in the #include/#import directive.                    |
| file           | The actual file that the #include/#import directive resolved to.          |
| isModuleImport | Non-zero if the directive was automatically turned into a module import.  |
"""
struct CXIdxIncludedFileInfo
    hashLoc::CXIdxLoc
    filename::Cstring
    file::CXFile
    isImport::Cint
    isAngled::Cint
    isModuleImport::Cint
end

"""
    CXIdxImportedASTFileInfo

Data for [`IndexerCallbacks`](@ref)#importedASTFile.

| Field      | Note                                                                                                            |
| :--------- | :-------------------------------------------------------------------------------------------------------------- |
| file       | Top level AST file containing the imported PCH, module or submodule.                                            |
| module     | The imported module or NULL if the AST file is a PCH.                                                           |
| loc        | Location where the file is imported. Applicable only for modules.                                               |
| isImplicit | Non-zero if an inclusion directive was automatically turned into a module import. Applicable only for modules.  |
"""
struct CXIdxImportedASTFileInfo
    file::CXFile
    _module::CXModule
    loc::CXIdxLoc
    isImplicit::Cint
end

@cenum CXIdxEntityKind::UInt32 begin
    CXIdxEntity_Unexposed = 0
    CXIdxEntity_Typedef = 1
    CXIdxEntity_Function = 2
    CXIdxEntity_Variable = 3
    CXIdxEntity_Field = 4
    CXIdxEntity_EnumConstant = 5
    CXIdxEntity_ObjCClass = 6
    CXIdxEntity_ObjCProtocol = 7
    CXIdxEntity_ObjCCategory = 8
    CXIdxEntity_ObjCInstanceMethod = 9
    CXIdxEntity_ObjCClassMethod = 10
    CXIdxEntity_ObjCProperty = 11
    CXIdxEntity_ObjCIvar = 12
    CXIdxEntity_Enum = 13
    CXIdxEntity_Struct = 14
    CXIdxEntity_Union = 15
    CXIdxEntity_CXXClass = 16
    CXIdxEntity_CXXNamespace = 17
    CXIdxEntity_CXXNamespaceAlias = 18
    CXIdxEntity_CXXStaticVariable = 19
    CXIdxEntity_CXXStaticMethod = 20
    CXIdxEntity_CXXInstanceMethod = 21
    CXIdxEntity_CXXConstructor = 22
    CXIdxEntity_CXXDestructor = 23
    CXIdxEntity_CXXConversionFunction = 24
    CXIdxEntity_CXXTypeAlias = 25
    CXIdxEntity_CXXInterface = 26
    CXIdxEntity_CXXConcept = 27
end

@cenum CXIdxEntityLanguage::UInt32 begin
    CXIdxEntityLang_None = 0
    CXIdxEntityLang_C = 1
    CXIdxEntityLang_ObjC = 2
    CXIdxEntityLang_CXX = 3
    CXIdxEntityLang_Swift = 4
end

"""
    CXIdxEntityCXXTemplateKind

Extra C++ template information for an entity. This can apply to: CXIdxEntity\\_Function CXIdxEntity\\_CXXClass CXIdxEntity\\_CXXStaticMethod CXIdxEntity\\_CXXInstanceMethod CXIdxEntity\\_CXXConstructor CXIdxEntity\\_CXXConversionFunction CXIdxEntity\\_CXXTypeAlias
"""
@cenum CXIdxEntityCXXTemplateKind::UInt32 begin
    CXIdxEntity_NonTemplate = 0
    CXIdxEntity_Template = 1
    CXIdxEntity_TemplatePartialSpecialization = 2
    CXIdxEntity_TemplateSpecialization = 3
end

@cenum CXIdxAttrKind::UInt32 begin
    CXIdxAttr_Unexposed = 0
    CXIdxAttr_IBAction = 1
    CXIdxAttr_IBOutlet = 2
    CXIdxAttr_IBOutletCollection = 3
end

struct CXIdxAttrInfo
    kind::CXIdxAttrKind
    cursor::CXCursor
    loc::CXIdxLoc
end

struct CXIdxEntityInfo
    kind::CXIdxEntityKind
    templateKind::CXIdxEntityCXXTemplateKind
    lang::CXIdxEntityLanguage
    name::Cstring
    USR::Cstring
    cursor::CXCursor
    attributes::Ptr{Ptr{CXIdxAttrInfo}}
    numAttributes::Cuint
end

struct CXIdxContainerInfo
    cursor::CXCursor
end

struct CXIdxIBOutletCollectionAttrInfo
    attrInfo::Ptr{CXIdxAttrInfo}
    objcClass::Ptr{CXIdxEntityInfo}
    classCursor::CXCursor
    classLoc::CXIdxLoc
end

@cenum CXIdxDeclInfoFlags::UInt32 begin
    CXIdxDeclFlag_Skipped = 1
end

"""
    CXIdxDeclInfo

| Field            | Note                                                                                                                                 |
| :--------------- | :----------------------------------------------------------------------------------------------------------------------------------- |
| lexicalContainer | Generally same as #semanticContainer but can be different in cases like out-of-line C++ member functions.                            |
| isImplicit       | Whether the declaration exists in code or was created implicitly by the compiler, e.g. implicit Objective-C methods for properties.  |
"""
struct CXIdxDeclInfo
    entityInfo::Ptr{CXIdxEntityInfo}
    cursor::CXCursor
    loc::CXIdxLoc
    semanticContainer::Ptr{CXIdxContainerInfo}
    lexicalContainer::Ptr{CXIdxContainerInfo}
    isRedeclaration::Cint
    isDefinition::Cint
    isContainer::Cint
    declAsContainer::Ptr{CXIdxContainerInfo}
    isImplicit::Cint
    attributes::Ptr{Ptr{CXIdxAttrInfo}}
    numAttributes::Cuint
    flags::Cuint
end

@cenum CXIdxObjCContainerKind::UInt32 begin
    CXIdxObjCContainer_ForwardRef = 0
    CXIdxObjCContainer_Interface = 1
    CXIdxObjCContainer_Implementation = 2
end

struct CXIdxObjCContainerDeclInfo
    declInfo::Ptr{CXIdxDeclInfo}
    kind::CXIdxObjCContainerKind
end

struct CXIdxBaseClassInfo
    base::Ptr{CXIdxEntityInfo}
    cursor::CXCursor
    loc::CXIdxLoc
end

struct CXIdxObjCProtocolRefInfo
    protocol::Ptr{CXIdxEntityInfo}
    cursor::CXCursor
    loc::CXIdxLoc
end

struct CXIdxObjCProtocolRefListInfo
    protocols::Ptr{Ptr{CXIdxObjCProtocolRefInfo}}
    numProtocols::Cuint
end

struct CXIdxObjCInterfaceDeclInfo
    containerInfo::Ptr{CXIdxObjCContainerDeclInfo}
    superInfo::Ptr{CXIdxBaseClassInfo}
    protocols::Ptr{CXIdxObjCProtocolRefListInfo}
end

struct CXIdxObjCCategoryDeclInfo
    containerInfo::Ptr{CXIdxObjCContainerDeclInfo}
    objcClass::Ptr{CXIdxEntityInfo}
    classCursor::CXCursor
    classLoc::CXIdxLoc
    protocols::Ptr{CXIdxObjCProtocolRefListInfo}
end

struct CXIdxObjCPropertyDeclInfo
    declInfo::Ptr{CXIdxDeclInfo}
    getter::Ptr{CXIdxEntityInfo}
    setter::Ptr{CXIdxEntityInfo}
end

struct CXIdxCXXClassDeclInfo
    declInfo::Ptr{CXIdxDeclInfo}
    bases::Ptr{Ptr{CXIdxBaseClassInfo}}
    numBases::Cuint
end

"""
    CXIdxEntityRefKind

Data for [`IndexerCallbacks`](@ref)#indexEntityReference.

This may be deprecated in a future version as this duplicates the `CXSymbolRole_Implicit` bit in [`CXSymbolRole`](@ref).

| Enumerator                | Note                                                                                  |
| :------------------------ | :------------------------------------------------------------------------------------ |
| CXIdxEntityRef\\_Direct   | The entity is referenced directly in user's code.                                     |
| CXIdxEntityRef\\_Implicit | An implicit reference, e.g. a reference of an Objective-C method via the dot syntax.  |
"""
@cenum CXIdxEntityRefKind::UInt32 begin
    CXIdxEntityRef_Direct = 1
    CXIdxEntityRef_Implicit = 2
end

"""
    CXSymbolRole

Roles that are attributed to symbol occurrences.

Internal: this currently mirrors low 9 bits of clang::index::SymbolRole with higher bits zeroed. These high bits may be exposed in the future.
"""
@cenum CXSymbolRole::UInt32 begin
    CXSymbolRole_None = 0
    CXSymbolRole_Declaration = 1
    CXSymbolRole_Definition = 2
    CXSymbolRole_Reference = 4
    CXSymbolRole_Read = 8
    CXSymbolRole_Write = 16
    CXSymbolRole_Call = 32
    CXSymbolRole_Dynamic = 64
    CXSymbolRole_AddressOf = 128
    CXSymbolRole_Implicit = 256
end

"""
    CXIdxEntityRefInfo

Data for [`IndexerCallbacks`](@ref)#indexEntityReference.

| Field            | Note                                                                                                                                                                                                                                               |
| :--------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| cursor           | Reference cursor.                                                                                                                                                                                                                                  |
| referencedEntity | The entity that gets referenced.                                                                                                                                                                                                                   |
| parentEntity     | Immediate "parent" of the reference. For example:  ```c++  Foo *var; ```  The parent of reference of type 'Foo' is the variable 'var'. For references inside statement bodies of functions/methods, the parentEntity will be the function/method.  |
| container        | Lexical container context of the reference.                                                                                                                                                                                                        |
| role             | Sets of symbol roles of the reference.                                                                                                                                                                                                             |
"""
struct CXIdxEntityRefInfo
    kind::CXIdxEntityRefKind
    cursor::CXCursor
    loc::CXIdxLoc
    referencedEntity::Ptr{CXIdxEntityInfo}
    parentEntity::Ptr{CXIdxEntityInfo}
    container::Ptr{CXIdxContainerInfo}
    role::CXSymbolRole
end

"""
    IndexerCallbacks

A group of callbacks used by #[`clang_indexSourceFile`](@ref) and #[`clang_indexTranslationUnit`](@ref).

| Field                  | Note                                                                                                                                                                                                                                                                                            |
| :--------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| abortQuery             | Called periodically to check whether indexing should be aborted. Should return 0 to continue, and non-zero to abort.                                                                                                                                                                            |
| diagnostic             | Called at the end of indexing; passes the complete diagnostic set.                                                                                                                                                                                                                              |
| ppIncludedFile         | Called when a file gets #included/#imported.                                                                                                                                                                                                                                                    |
| importedASTFile        | Called when a AST file (PCH or module) gets imported.  AST files will not get indexed (there will not be callbacks to index all the entities in an AST file). The recommended action is that, if the AST file is not already indexed, to initiate a new indexing job specific to the AST file.  |
| startedTranslationUnit | Called at the beginning of indexing a translation unit.                                                                                                                                                                                                                                         |
| indexEntityReference   | Called to index a reference of an entity.                                                                                                                                                                                                                                                       |
"""
struct IndexerCallbacks
    abortQuery::Ptr{Cvoid}
    diagnostic::Ptr{Cvoid}
    enteredMainFile::Ptr{Cvoid}
    ppIncludedFile::Ptr{Cvoid}
    importedASTFile::Ptr{Cvoid}
    startedTranslationUnit::Ptr{Cvoid}
    indexDeclaration::Ptr{Cvoid}
    indexEntityReference::Ptr{Cvoid}
end

function clang_index_isEntityObjCContainerKind(arg1)
    @ccall libclang.clang_index_isEntityObjCContainerKind(arg1::CXIdxEntityKind)::Cint
end

function clang_index_getObjCContainerDeclInfo(arg1)
    @ccall libclang.clang_index_getObjCContainerDeclInfo(arg1::Ptr{CXIdxDeclInfo})::Ptr{CXIdxObjCContainerDeclInfo}
end

function clang_index_getObjCInterfaceDeclInfo(arg1)
    @ccall libclang.clang_index_getObjCInterfaceDeclInfo(arg1::Ptr{CXIdxDeclInfo})::Ptr{CXIdxObjCInterfaceDeclInfo}
end

function clang_index_getObjCCategoryDeclInfo(arg1)
    @ccall libclang.clang_index_getObjCCategoryDeclInfo(arg1::Ptr{CXIdxDeclInfo})::Ptr{CXIdxObjCCategoryDeclInfo}
end

function clang_index_getObjCProtocolRefListInfo(arg1)
    @ccall libclang.clang_index_getObjCProtocolRefListInfo(arg1::Ptr{CXIdxDeclInfo})::Ptr{CXIdxObjCProtocolRefListInfo}
end

function clang_index_getObjCPropertyDeclInfo(arg1)
    @ccall libclang.clang_index_getObjCPropertyDeclInfo(arg1::Ptr{CXIdxDeclInfo})::Ptr{CXIdxObjCPropertyDeclInfo}
end

function clang_index_getIBOutletCollectionAttrInfo(arg1)
    @ccall libclang.clang_index_getIBOutletCollectionAttrInfo(arg1::Ptr{CXIdxAttrInfo})::Ptr{CXIdxIBOutletCollectionAttrInfo}
end

function clang_index_getCXXClassDeclInfo(arg1)
    @ccall libclang.clang_index_getCXXClassDeclInfo(arg1::Ptr{CXIdxDeclInfo})::Ptr{CXIdxCXXClassDeclInfo}
end

"""
    clang_index_getClientContainer(arg1)

For retrieving a custom [`CXIdxClientContainer`](@ref) attached to a container.
"""
function clang_index_getClientContainer(arg1)
    @ccall libclang.clang_index_getClientContainer(arg1::Ptr{CXIdxContainerInfo})::CXIdxClientContainer
end

"""
    clang_index_setClientContainer(arg1, arg2)

For setting a custom [`CXIdxClientContainer`](@ref) attached to a container.
"""
function clang_index_setClientContainer(arg1, arg2)
    @ccall libclang.clang_index_setClientContainer(arg1::Ptr{CXIdxContainerInfo}, arg2::CXIdxClientContainer)::Cvoid
end

"""
    clang_index_getClientEntity(arg1)

For retrieving a custom [`CXIdxClientEntity`](@ref) attached to an entity.
"""
function clang_index_getClientEntity(arg1)
    @ccall libclang.clang_index_getClientEntity(arg1::Ptr{CXIdxEntityInfo})::CXIdxClientEntity
end

"""
    clang_index_setClientEntity(arg1, arg2)

For setting a custom [`CXIdxClientEntity`](@ref) attached to an entity.
"""
function clang_index_setClientEntity(arg1, arg2)
    @ccall libclang.clang_index_setClientEntity(arg1::Ptr{CXIdxEntityInfo}, arg2::CXIdxClientEntity)::Cvoid
end

"""
An indexing action/session, to be applied to one or multiple translation units.
"""
const CXIndexAction = Ptr{Cvoid}

"""
    clang_IndexAction_create(CIdx)

An indexing action/session, to be applied to one or multiple translation units.

# Arguments
* `CIdx`: The index object with which the index action will be associated.
"""
function clang_IndexAction_create(CIdx)
    @ccall libclang.clang_IndexAction_create(CIdx::CXIndex)::CXIndexAction
end

"""
    clang_IndexAction_dispose(arg1)

Destroy the given index action.

The index action must not be destroyed until all of the translation units created within that index action have been destroyed.
"""
function clang_IndexAction_dispose(arg1)
    @ccall libclang.clang_IndexAction_dispose(arg1::CXIndexAction)::Cvoid
end

"""
    CXIndexOptFlags

| Enumerator                                       | Note                                                                                                                                                                                                            |
| :----------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CXIndexOpt\\_None                                | Used to indicate that no special indexing options are needed.                                                                                                                                                   |
| CXIndexOpt\\_SuppressRedundantRefs               | Used to indicate that [`IndexerCallbacks`](@ref)#indexEntityReference should be invoked for only one reference of an entity per source file that does not also include a declaration/definition of the entity.  |
| CXIndexOpt\\_IndexFunctionLocalSymbols           | Function-local symbols should be indexed. If this is not set function-local symbols will be ignored.                                                                                                            |
| CXIndexOpt\\_IndexImplicitTemplateInstantiations | Implicit function/class template instantiations should be indexed. If this is not set, implicit instantiations will be ignored.                                                                                 |
| CXIndexOpt\\_SuppressWarnings                    | Suppress all compiler warnings when parsing for indexing.                                                                                                                                                       |
| CXIndexOpt\\_SkipParsedBodiesInSession           | Skip a function/method body that was already parsed during an indexing session associated with a [`CXIndexAction`](@ref) object. Bodies in system headers are always skipped.                                   |
"""
@cenum CXIndexOptFlags::UInt32 begin
    CXIndexOpt_None = 0
    CXIndexOpt_SuppressRedundantRefs = 1
    CXIndexOpt_IndexFunctionLocalSymbols = 2
    CXIndexOpt_IndexImplicitTemplateInstantiations = 4
    CXIndexOpt_SuppressWarnings = 8
    CXIndexOpt_SkipParsedBodiesInSession = 16
end

"""
    clang_indexSourceFile(arg1, client_data, index_callbacks, index_callbacks_size, index_options, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, out_TU, TU_options)

Index the given source file and the translation unit corresponding to that file via callbacks implemented through #[`IndexerCallbacks`](@ref).

The rest of the parameters are the same as #[`clang_parseTranslationUnit`](@ref).

# Arguments
* `client_data`: pointer data supplied by the client, which will be passed to the invoked callbacks.
* `index_callbacks`: Pointer to indexing callbacks that the client implements.
* `index_callbacks_size`: Size of #[`IndexerCallbacks`](@ref) structure that gets passed in index\\_callbacks.
* `index_options`: A bitmask of options that affects how indexing is performed. This should be a bitwise OR of the CXIndexOpt\\_XXX flags.
* `out_TU`:\\[out\\] pointer to store a [`CXTranslationUnit`](@ref) that can be reused after indexing is finished. Set to `NULL` if you do not require it.
# Returns
0 on success or if there were errors from which the compiler could recover. If there is a failure from which there is no recovery, returns a non-zero [`CXErrorCode`](@ref).
"""
function clang_indexSourceFile(arg1, client_data, index_callbacks, index_callbacks_size, index_options, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, out_TU, TU_options)
    @ccall libclang.clang_indexSourceFile(arg1::CXIndexAction, client_data::CXClientData, index_callbacks::Ptr{IndexerCallbacks}, index_callbacks_size::Cuint, index_options::Cuint, source_filename::Cstring, command_line_args::Ptr{Cstring}, num_command_line_args::Cint, unsaved_files::Ptr{CXUnsavedFile}, num_unsaved_files::Cuint, out_TU::Ptr{CXTranslationUnit}, TU_options::Cuint)::Cint
end

"""
    clang_indexSourceFileFullArgv(arg1, client_data, index_callbacks, index_callbacks_size, index_options, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, out_TU, TU_options)

Same as [`clang_indexSourceFile`](@ref) but requires a full command line for `command_line_args` including argv[0]. This is useful if the standard library paths are relative to the binary.
"""
function clang_indexSourceFileFullArgv(arg1, client_data, index_callbacks, index_callbacks_size, index_options, source_filename, command_line_args, num_command_line_args, unsaved_files, num_unsaved_files, out_TU, TU_options)
    @ccall libclang.clang_indexSourceFileFullArgv(arg1::CXIndexAction, client_data::CXClientData, index_callbacks::Ptr{IndexerCallbacks}, index_callbacks_size::Cuint, index_options::Cuint, source_filename::Cstring, command_line_args::Ptr{Cstring}, num_command_line_args::Cint, unsaved_files::Ptr{CXUnsavedFile}, num_unsaved_files::Cuint, out_TU::Ptr{CXTranslationUnit}, TU_options::Cuint)::Cint
end

"""
    clang_indexTranslationUnit(arg1, client_data, index_callbacks, index_callbacks_size, index_options, arg6)

Index the given translation unit via callbacks implemented through #[`IndexerCallbacks`](@ref).

The order of callback invocations is not guaranteed to be the same as when indexing a source file. The high level order will be:

-Preprocessor callbacks invocations -Declaration/reference callbacks invocations -Diagnostic callback invocations

The parameters are the same as #[`clang_indexSourceFile`](@ref).

# Returns
If there is a failure from which there is no recovery, returns non-zero, otherwise returns 0.
"""
function clang_indexTranslationUnit(arg1, client_data, index_callbacks, index_callbacks_size, index_options, arg6)
    @ccall libclang.clang_indexTranslationUnit(arg1::CXIndexAction, client_data::CXClientData, index_callbacks::Ptr{IndexerCallbacks}, index_callbacks_size::Cuint, index_options::Cuint, arg6::CXTranslationUnit)::Cint
end

"""
    clang_indexLoc_getFileLocation(loc, indexFile, file, line, column, offset)

Retrieve the CXIdxFile, file, line, column, and offset represented by the given [`CXIdxLoc`](@ref).

If the location refers into a macro expansion, retrieves the location of the macro expansion and if it refers into a macro argument retrieves the location of the argument.
"""
function clang_indexLoc_getFileLocation(loc, indexFile, file, line, column, offset)
    @ccall libclang.clang_indexLoc_getFileLocation(loc::CXIdxLoc, indexFile::Ptr{CXIdxClientFile}, file::Ptr{CXFile}, line::Ptr{Cuint}, column::Ptr{Cuint}, offset::Ptr{Cuint})::Cvoid
end

"""
    clang_indexLoc_getCXSourceLocation(loc)

Retrieve the [`CXSourceLocation`](@ref) represented by the given [`CXIdxLoc`](@ref).
"""
function clang_indexLoc_getCXSourceLocation(loc)
    @ccall libclang.clang_indexLoc_getCXSourceLocation(loc::CXIdxLoc)::CXSourceLocation
end

# typedef enum CXVisitorResult ( * CXFieldVisitor ) ( CXCursor C , CXClientData client_data )
"""
Visitor invoked for each field found by a traversal.

This visitor function will be invoked for each field found by [`clang_Type_visitFields`](@ref). Its first argument is the cursor being visited, its second argument is the client data provided to [`clang_Type_visitFields`](@ref).

The visitor should return one of the [`CXVisitorResult`](@ref) values to direct [`clang_Type_visitFields`](@ref).
"""
const CXFieldVisitor = Ptr{Cvoid}

"""
    clang_Type_visitFields(T, visitor, client_data)

Visit the fields of a particular type.

This function visits all the direct fields of the given cursor, invoking the given `visitor` function with the cursors of each visited field. The traversal may be ended prematurely, if the visitor returns `CXFieldVisit_Break`.

# Arguments
* `T`: the record type whose field may be visited.
* `visitor`: the visitor function that will be invoked for each field of `T`.
* `client_data`: pointer data supplied by the client, which will be passed to the visitor each time it is invoked.
# Returns
a non-zero value if the traversal was terminated prematurely by the visitor returning `CXFieldVisit_Break`.
"""
function clang_Type_visitFields(T, visitor, client_data)
    @ccall libclang.clang_Type_visitFields(T::CXType, visitor::CXFieldVisitor, client_data::CXClientData)::Cuint
end

"""
    CXBinaryOperatorKind

Describes the kind of binary operators.

| Enumerator                   | Note                                                          |
| :--------------------------- | :------------------------------------------------------------ |
| CXBinaryOperator\\_Invalid   | This value describes cursors which are not binary operators.  |
| CXBinaryOperator\\_PtrMemD   | C++ Pointer - to - member operator.                           |
| CXBinaryOperator\\_PtrMemI   |                                                               |
| CXBinaryOperator\\_Mul       | Multiplication operator.                                      |
| CXBinaryOperator\\_Div       | Division operator.                                            |
| CXBinaryOperator\\_Rem       | Remainder operator.                                           |
| CXBinaryOperator\\_Add       | Addition operator.                                            |
| CXBinaryOperator\\_Sub       | Subtraction operator.                                         |
| CXBinaryOperator\\_Shl       | Bitwise shift left operator.                                  |
| CXBinaryOperator\\_Shr       | Bitwise shift right operator.                                 |
| CXBinaryOperator\\_Cmp       | C++ three-way comparison (spaceship) operator.                |
| CXBinaryOperator\\_LT        | Less than operator.                                           |
| CXBinaryOperator\\_GT        | Greater than operator.                                        |
| CXBinaryOperator\\_LE        | Less or equal operator.                                       |
| CXBinaryOperator\\_GE        | Greater or equal operator.                                    |
| CXBinaryOperator\\_EQ        | Equal operator.                                               |
| CXBinaryOperator\\_NE        | Not equal operator.                                           |
| CXBinaryOperator\\_And       | Bitwise AND operator.                                         |
| CXBinaryOperator\\_Xor       | Bitwise XOR operator.                                         |
| CXBinaryOperator\\_Or        | Bitwise OR operator.                                          |
| CXBinaryOperator\\_LAnd      | Logical AND operator.                                         |
| CXBinaryOperator\\_LOr       | Logical OR operator.                                          |
| CXBinaryOperator\\_Assign    | Assignment operator.                                          |
| CXBinaryOperator\\_MulAssign | Multiplication assignment operator.                           |
| CXBinaryOperator\\_DivAssign | Division assignment operator.                                 |
| CXBinaryOperator\\_RemAssign | Remainder assignment operator.                                |
| CXBinaryOperator\\_AddAssign | Addition assignment operator.                                 |
| CXBinaryOperator\\_SubAssign | Subtraction assignment operator.                              |
| CXBinaryOperator\\_ShlAssign | Bitwise shift left assignment operator.                       |
| CXBinaryOperator\\_ShrAssign | Bitwise shift right assignment operator.                      |
| CXBinaryOperator\\_AndAssign | Bitwise AND assignment operator.                              |
| CXBinaryOperator\\_XorAssign | Bitwise XOR assignment operator.                              |
| CXBinaryOperator\\_OrAssign  | Bitwise OR assignment operator.                               |
| CXBinaryOperator\\_Comma     | Comma operator.                                               |
"""
@cenum CXBinaryOperatorKind::UInt32 begin
    CXBinaryOperator_Invalid = 0
    CXBinaryOperator_PtrMemD = 1
    CXBinaryOperator_PtrMemI = 2
    CXBinaryOperator_Mul = 3
    CXBinaryOperator_Div = 4
    CXBinaryOperator_Rem = 5
    CXBinaryOperator_Add = 6
    CXBinaryOperator_Sub = 7
    CXBinaryOperator_Shl = 8
    CXBinaryOperator_Shr = 9
    CXBinaryOperator_Cmp = 10
    CXBinaryOperator_LT = 11
    CXBinaryOperator_GT = 12
    CXBinaryOperator_LE = 13
    CXBinaryOperator_GE = 14
    CXBinaryOperator_EQ = 15
    CXBinaryOperator_NE = 16
    CXBinaryOperator_And = 17
    CXBinaryOperator_Xor = 18
    CXBinaryOperator_Or = 19
    CXBinaryOperator_LAnd = 20
    CXBinaryOperator_LOr = 21
    CXBinaryOperator_Assign = 22
    CXBinaryOperator_MulAssign = 23
    CXBinaryOperator_DivAssign = 24
    CXBinaryOperator_RemAssign = 25
    CXBinaryOperator_AddAssign = 26
    CXBinaryOperator_SubAssign = 27
    CXBinaryOperator_ShlAssign = 28
    CXBinaryOperator_ShrAssign = 29
    CXBinaryOperator_AndAssign = 30
    CXBinaryOperator_XorAssign = 31
    CXBinaryOperator_OrAssign = 32
    CXBinaryOperator_Comma = 33
end

"""
    clang_getBinaryOperatorKindSpelling(kind)

Retrieve the spelling of a given [`CXBinaryOperatorKind`](@ref).
"""
function clang_getBinaryOperatorKindSpelling(kind)
    @ccall libclang.clang_getBinaryOperatorKindSpelling(kind::CXBinaryOperatorKind)::CXString
end

"""
    clang_getCursorBinaryOperatorKind(cursor)

Retrieve the binary operator kind of this cursor.

If this cursor is not a binary operator then returns Invalid.
"""
function clang_getCursorBinaryOperatorKind(cursor)
    @ccall libclang.clang_getCursorBinaryOperatorKind(cursor::CXCursor)::CXBinaryOperatorKind
end

"""
    CXUnaryOperatorKind

Describes the kind of unary operators.

| Enumerator                  | Note                                                         |
| :-------------------------- | :----------------------------------------------------------- |
| CXUnaryOperator\\_Invalid   | This value describes cursors which are not unary operators.  |
| CXUnaryOperator\\_PostInc   | Postfix increment operator.                                  |
| CXUnaryOperator\\_PostDec   | Postfix decrement operator.                                  |
| CXUnaryOperator\\_PreInc    | Prefix increment operator.                                   |
| CXUnaryOperator\\_PreDec    | Prefix decrement operator.                                   |
| CXUnaryOperator\\_AddrOf    | Address of operator.                                         |
| CXUnaryOperator\\_Deref     | Dereference operator.                                        |
| CXUnaryOperator\\_Plus      | Plus operator.                                               |
| CXUnaryOperator\\_Minus     | Minus operator.                                              |
| CXUnaryOperator\\_Not       | Not operator.                                                |
| CXUnaryOperator\\_LNot      | LNot operator.                                               |
| CXUnaryOperator\\_Real      | "\\_\\_real expr" operator.                                  |
| CXUnaryOperator\\_Imag      | "\\_\\_imag expr" operator.                                  |
| CXUnaryOperator\\_Extension | \\_\\_extension\\_\\_ marker operator.                       |
| CXUnaryOperator\\_Coawait   | C++ co\\_await operator.                                     |
"""
@cenum CXUnaryOperatorKind::UInt32 begin
    CXUnaryOperator_Invalid = 0
    CXUnaryOperator_PostInc = 1
    CXUnaryOperator_PostDec = 2
    CXUnaryOperator_PreInc = 3
    CXUnaryOperator_PreDec = 4
    CXUnaryOperator_AddrOf = 5
    CXUnaryOperator_Deref = 6
    CXUnaryOperator_Plus = 7
    CXUnaryOperator_Minus = 8
    CXUnaryOperator_Not = 9
    CXUnaryOperator_LNot = 10
    CXUnaryOperator_Real = 11
    CXUnaryOperator_Imag = 12
    CXUnaryOperator_Extension = 13
    CXUnaryOperator_Coawait = 14
end

"""
    clang_getUnaryOperatorKindSpelling(kind)

Retrieve the spelling of a given [`CXUnaryOperatorKind`](@ref).
"""
function clang_getUnaryOperatorKindSpelling(kind)
    @ccall libclang.clang_getUnaryOperatorKindSpelling(kind::CXUnaryOperatorKind)::CXString
end

"""
    clang_getCursorUnaryOperatorKind(cursor)

Retrieve the unary operator kind of this cursor.

If this cursor is not a unary operator then returns Invalid.
"""
function clang_getCursorUnaryOperatorKind(cursor)
    @ccall libclang.clang_getCursorUnaryOperatorKind(cursor::CXCursor)::CXUnaryOperatorKind
end

"""
    CXComment

A parsed comment.
"""
struct CXComment
    ASTNode::Ptr{Cvoid}
    TranslationUnit::CXTranslationUnit
end

"""
    clang_Cursor_getParsedComment(C)

Given a cursor that represents a documentable entity (e.g., declaration), return the associated parsed comment as a `CXComment_FullComment` AST node.
"""
function clang_Cursor_getParsedComment(C)
    @ccall libclang.clang_Cursor_getParsedComment(C::CXCursor)::CXComment
end

"""
    CXCommentKind

Describes the type of the comment AST node ([`CXComment`](@ref)). A comment node can be considered block content (e. g., paragraph), inline content (plain text) or neither (the root AST node).

| Enumerator                       | Note                                                                                                                                                                                                                                                                                                                                                                                                          |
| :------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CXComment\\_Null                 | Null comment. No AST node is constructed at the requested location because there is no text or a syntax error.                                                                                                                                                                                                                                                                                                |
| CXComment\\_Text                 | Plain text. Inline content.                                                                                                                                                                                                                                                                                                                                                                                   |
| CXComment\\_InlineCommand        | A command with word-like arguments that is considered inline content.  For example: \\c command.                                                                                                                                                                                                                                                                                                              |
| CXComment\\_HTMLStartTag         | HTML start tag with attributes (name-value pairs). Considered inline content.  For example:  ```c++  <br> <br /> <a href="http://example.org/"> ```                                                                                                                                                                                                                                                           |
| CXComment\\_HTMLEndTag           | HTML end tag. Considered inline content.  For example:  ```c++  </a> ```                                                                                                                                                                                                                                                                                                                                      |
| CXComment\\_Paragraph            | A paragraph, contains inline comment. The paragraph itself is block content.                                                                                                                                                                                                                                                                                                                                  |
| CXComment\\_BlockCommand         | A command that has zero or more word-like arguments (number of word-like arguments depends on command name) and a paragraph as an argument. Block command is block content.  Paragraph argument is also a child of the block command.  For example:  0 word-like arguments and a paragraph argument.  AST nodes of special kinds that parser knows about (e. g., \\param command) have their own node kinds.  |
| CXComment\\_ParamCommand         | A \\param or \\arg command that describes the function parameter (name, passing direction, description).  For example: \\param [in] ParamName description.                                                                                                                                                                                                                                                    |
| CXComment\\_TParamCommand        | A \\tparam command that describes a template parameter (name and description).  For example: \\tparam T description.                                                                                                                                                                                                                                                                                          |
| CXComment\\_VerbatimBlockCommand | A verbatim block command (e. g., preformatted code). Verbatim block has an opening and a closing command and contains multiple lines of text (`CXComment_VerbatimBlockLine` child nodes).  For example: \\verbatim aaa \\endverbatim                                                                                                                                                                          |
| CXComment\\_VerbatimBlockLine    | A line of text that is contained within a CXComment\\_VerbatimBlockCommand node.                                                                                                                                                                                                                                                                                                                              |
| CXComment\\_VerbatimLine         | A verbatim line command. Verbatim line has an opening command, a single line of text (up to the newline after the opening command) and has no closing command.                                                                                                                                                                                                                                                |
| CXComment\\_FullComment          | A full comment attached to a declaration, contains block content.                                                                                                                                                                                                                                                                                                                                             |
"""
@cenum CXCommentKind::UInt32 begin
    CXComment_Null = 0
    CXComment_Text = 1
    CXComment_InlineCommand = 2
    CXComment_HTMLStartTag = 3
    CXComment_HTMLEndTag = 4
    CXComment_Paragraph = 5
    CXComment_BlockCommand = 6
    CXComment_ParamCommand = 7
    CXComment_TParamCommand = 8
    CXComment_VerbatimBlockCommand = 9
    CXComment_VerbatimBlockLine = 10
    CXComment_VerbatimLine = 11
    CXComment_FullComment = 12
end

"""
    CXCommentInlineCommandRenderKind

The most appropriate rendering mode for an inline command, chosen on command semantics in Doxygen.

| Enumerator                                    | Note                                                                        |
| :-------------------------------------------- | :-------------------------------------------------------------------------- |
| CXCommentInlineCommandRenderKind\\_Normal     | Command argument should be rendered in a normal font.                       |
| CXCommentInlineCommandRenderKind\\_Bold       | Command argument should be rendered in a bold font.                         |
| CXCommentInlineCommandRenderKind\\_Monospaced | Command argument should be rendered in a monospaced font.                   |
| CXCommentInlineCommandRenderKind\\_Emphasized | Command argument should be rendered emphasized (typically italic font).     |
| CXCommentInlineCommandRenderKind\\_Anchor     | Command argument should not be rendered (since it only defines an anchor).  |
"""
@cenum CXCommentInlineCommandRenderKind::UInt32 begin
    CXCommentInlineCommandRenderKind_Normal = 0
    CXCommentInlineCommandRenderKind_Bold = 1
    CXCommentInlineCommandRenderKind_Monospaced = 2
    CXCommentInlineCommandRenderKind_Emphasized = 3
    CXCommentInlineCommandRenderKind_Anchor = 4
end

"""
    CXCommentParamPassDirection

Describes parameter passing direction for \\param or \\arg command.

| Enumerator                          | Note                                             |
| :---------------------------------- | :----------------------------------------------- |
| CXCommentParamPassDirection\\_In    | The parameter is an input parameter.             |
| CXCommentParamPassDirection\\_Out   | The parameter is an output parameter.            |
| CXCommentParamPassDirection\\_InOut | The parameter is an input and output parameter.  |
"""
@cenum CXCommentParamPassDirection::UInt32 begin
    CXCommentParamPassDirection_In = 0
    CXCommentParamPassDirection_Out = 1
    CXCommentParamPassDirection_InOut = 2
end

"""
    clang_Comment_getKind(Comment)

# Arguments
* `Comment`: AST node of any kind.
# Returns
the type of the AST node.
"""
function clang_Comment_getKind(Comment)
    @ccall libclang.clang_Comment_getKind(Comment::CXComment)::CXCommentKind
end

"""
    clang_Comment_getNumChildren(Comment)

# Arguments
* `Comment`: AST node of any kind.
# Returns
number of children of the AST node.
"""
function clang_Comment_getNumChildren(Comment)
    @ccall libclang.clang_Comment_getNumChildren(Comment::CXComment)::Cuint
end

"""
    clang_Comment_getChild(Comment, ChildIdx)

# Arguments
* `Comment`: AST node of any kind.
* `ChildIdx`: child index (zero-based).
# Returns
the specified child of the AST node.
"""
function clang_Comment_getChild(Comment, ChildIdx)
    @ccall libclang.clang_Comment_getChild(Comment::CXComment, ChildIdx::Cuint)::CXComment
end

"""
    clang_Comment_isWhitespace(Comment)

A `CXComment_Paragraph` node is considered whitespace if it contains only `CXComment_Text` nodes that are empty or whitespace.

Other AST nodes (except `CXComment_Paragraph` and `CXComment_Text`) are never considered whitespace.

# Returns
non-zero if `Comment` is whitespace.
"""
function clang_Comment_isWhitespace(Comment)
    @ccall libclang.clang_Comment_isWhitespace(Comment::CXComment)::Cuint
end

"""
    clang_InlineContentComment_hasTrailingNewline(Comment)

# Returns
non-zero if `Comment` is inline content and has a newline immediately following it in the comment text. Newlines between paragraphs do not count.
"""
function clang_InlineContentComment_hasTrailingNewline(Comment)
    @ccall libclang.clang_InlineContentComment_hasTrailingNewline(Comment::CXComment)::Cuint
end

"""
    clang_TextComment_getText(Comment)

# Arguments
* `Comment`: a `CXComment_Text` AST node.
# Returns
text contained in the AST node.
"""
function clang_TextComment_getText(Comment)
    @ccall libclang.clang_TextComment_getText(Comment::CXComment)::CXString
end

"""
    clang_InlineCommandComment_getCommandName(Comment)

# Arguments
* `Comment`: a `CXComment_InlineCommand` AST node.
# Returns
name of the inline command.
"""
function clang_InlineCommandComment_getCommandName(Comment)
    @ccall libclang.clang_InlineCommandComment_getCommandName(Comment::CXComment)::CXString
end

"""
    clang_InlineCommandComment_getRenderKind(Comment)

# Arguments
* `Comment`: a `CXComment_InlineCommand` AST node.
# Returns
the most appropriate rendering mode, chosen on command semantics in Doxygen.
"""
function clang_InlineCommandComment_getRenderKind(Comment)
    @ccall libclang.clang_InlineCommandComment_getRenderKind(Comment::CXComment)::CXCommentInlineCommandRenderKind
end

"""
    clang_InlineCommandComment_getNumArgs(Comment)

# Arguments
* `Comment`: a `CXComment_InlineCommand` AST node.
# Returns
number of command arguments.
"""
function clang_InlineCommandComment_getNumArgs(Comment)
    @ccall libclang.clang_InlineCommandComment_getNumArgs(Comment::CXComment)::Cuint
end

"""
    clang_InlineCommandComment_getArgText(Comment, ArgIdx)

# Arguments
* `Comment`: a `CXComment_InlineCommand` AST node.
* `ArgIdx`: argument index (zero-based).
# Returns
text of the specified argument.
"""
function clang_InlineCommandComment_getArgText(Comment, ArgIdx)
    @ccall libclang.clang_InlineCommandComment_getArgText(Comment::CXComment, ArgIdx::Cuint)::CXString
end

"""
    clang_HTMLTagComment_getTagName(Comment)

# Arguments
* `Comment`: a `CXComment_HTMLStartTag` or `CXComment_HTMLEndTag` AST node.
# Returns
HTML tag name.
"""
function clang_HTMLTagComment_getTagName(Comment)
    @ccall libclang.clang_HTMLTagComment_getTagName(Comment::CXComment)::CXString
end

"""
    clang_HTMLStartTagComment_isSelfClosing(Comment)

# Arguments
* `Comment`: a `CXComment_HTMLStartTag` AST node.
# Returns
non-zero if tag is self-closing (for example, <br />).
"""
function clang_HTMLStartTagComment_isSelfClosing(Comment)
    @ccall libclang.clang_HTMLStartTagComment_isSelfClosing(Comment::CXComment)::Cuint
end

"""
    clang_HTMLStartTag_getNumAttrs(Comment)

# Arguments
* `Comment`: a `CXComment_HTMLStartTag` AST node.
# Returns
number of attributes (name-value pairs) attached to the start tag.
"""
function clang_HTMLStartTag_getNumAttrs(Comment)
    @ccall libclang.clang_HTMLStartTag_getNumAttrs(Comment::CXComment)::Cuint
end

"""
    clang_HTMLStartTag_getAttrName(Comment, AttrIdx)

# Arguments
* `Comment`: a `CXComment_HTMLStartTag` AST node.
* `AttrIdx`: attribute index (zero-based).
# Returns
name of the specified attribute.
"""
function clang_HTMLStartTag_getAttrName(Comment, AttrIdx)
    @ccall libclang.clang_HTMLStartTag_getAttrName(Comment::CXComment, AttrIdx::Cuint)::CXString
end

"""
    clang_HTMLStartTag_getAttrValue(Comment, AttrIdx)

# Arguments
* `Comment`: a `CXComment_HTMLStartTag` AST node.
* `AttrIdx`: attribute index (zero-based).
# Returns
value of the specified attribute.
"""
function clang_HTMLStartTag_getAttrValue(Comment, AttrIdx)
    @ccall libclang.clang_HTMLStartTag_getAttrValue(Comment::CXComment, AttrIdx::Cuint)::CXString
end

"""
    clang_BlockCommandComment_getCommandName(Comment)

# Arguments
* `Comment`: a `CXComment_BlockCommand` AST node.
# Returns
name of the block command.
"""
function clang_BlockCommandComment_getCommandName(Comment)
    @ccall libclang.clang_BlockCommandComment_getCommandName(Comment::CXComment)::CXString
end

"""
    clang_BlockCommandComment_getNumArgs(Comment)

# Arguments
* `Comment`: a `CXComment_BlockCommand` AST node.
# Returns
number of word-like arguments.
"""
function clang_BlockCommandComment_getNumArgs(Comment)
    @ccall libclang.clang_BlockCommandComment_getNumArgs(Comment::CXComment)::Cuint
end

"""
    clang_BlockCommandComment_getArgText(Comment, ArgIdx)

# Arguments
* `Comment`: a `CXComment_BlockCommand` AST node.
* `ArgIdx`: argument index (zero-based).
# Returns
text of the specified word-like argument.
"""
function clang_BlockCommandComment_getArgText(Comment, ArgIdx)
    @ccall libclang.clang_BlockCommandComment_getArgText(Comment::CXComment, ArgIdx::Cuint)::CXString
end

"""
    clang_BlockCommandComment_getParagraph(Comment)

# Arguments
* `Comment`: a `CXComment_BlockCommand` or `CXComment_VerbatimBlockCommand` AST node.
# Returns
paragraph argument of the block command.
"""
function clang_BlockCommandComment_getParagraph(Comment)
    @ccall libclang.clang_BlockCommandComment_getParagraph(Comment::CXComment)::CXComment
end

"""
    clang_ParamCommandComment_getParamName(Comment)

# Arguments
* `Comment`: a `CXComment_ParamCommand` AST node.
# Returns
parameter name.
"""
function clang_ParamCommandComment_getParamName(Comment)
    @ccall libclang.clang_ParamCommandComment_getParamName(Comment::CXComment)::CXString
end

"""
    clang_ParamCommandComment_isParamIndexValid(Comment)

# Arguments
* `Comment`: a `CXComment_ParamCommand` AST node.
# Returns
non-zero if the parameter that this AST node represents was found in the function prototype and [`clang_ParamCommandComment_getParamIndex`](@ref) function will return a meaningful value.
"""
function clang_ParamCommandComment_isParamIndexValid(Comment)
    @ccall libclang.clang_ParamCommandComment_isParamIndexValid(Comment::CXComment)::Cuint
end

"""
    clang_ParamCommandComment_getParamIndex(Comment)

# Arguments
* `Comment`: a `CXComment_ParamCommand` AST node.
# Returns
zero-based parameter index in function prototype.
"""
function clang_ParamCommandComment_getParamIndex(Comment)
    @ccall libclang.clang_ParamCommandComment_getParamIndex(Comment::CXComment)::Cuint
end

"""
    clang_ParamCommandComment_isDirectionExplicit(Comment)

# Arguments
* `Comment`: a `CXComment_ParamCommand` AST node.
# Returns
non-zero if parameter passing direction was specified explicitly in the comment.
"""
function clang_ParamCommandComment_isDirectionExplicit(Comment)
    @ccall libclang.clang_ParamCommandComment_isDirectionExplicit(Comment::CXComment)::Cuint
end

"""
    clang_ParamCommandComment_getDirection(Comment)

# Arguments
* `Comment`: a `CXComment_ParamCommand` AST node.
# Returns
parameter passing direction.
"""
function clang_ParamCommandComment_getDirection(Comment)
    @ccall libclang.clang_ParamCommandComment_getDirection(Comment::CXComment)::CXCommentParamPassDirection
end

"""
    clang_TParamCommandComment_getParamName(Comment)

# Arguments
* `Comment`: a `CXComment_TParamCommand` AST node.
# Returns
template parameter name.
"""
function clang_TParamCommandComment_getParamName(Comment)
    @ccall libclang.clang_TParamCommandComment_getParamName(Comment::CXComment)::CXString
end

"""
    clang_TParamCommandComment_isParamPositionValid(Comment)

# Arguments
* `Comment`: a `CXComment_TParamCommand` AST node.
# Returns
non-zero if the parameter that this AST node represents was found in the template parameter list and [`clang_TParamCommandComment_getDepth`](@ref) and [`clang_TParamCommandComment_getIndex`](@ref) functions will return a meaningful value.
"""
function clang_TParamCommandComment_isParamPositionValid(Comment)
    @ccall libclang.clang_TParamCommandComment_isParamPositionValid(Comment::CXComment)::Cuint
end

"""
    clang_TParamCommandComment_getDepth(Comment)

For example,

```c++
     template<typename C, template<typename T> class TT>
     void test(TT<int> aaa);
```

for C and TT nesting depth is 0, for T nesting depth is 1.

# Arguments
* `Comment`: a `CXComment_TParamCommand` AST node.
# Returns
zero-based nesting depth of this parameter in the template parameter list.
"""
function clang_TParamCommandComment_getDepth(Comment)
    @ccall libclang.clang_TParamCommandComment_getDepth(Comment::CXComment)::Cuint
end

"""
    clang_TParamCommandComment_getIndex(Comment, Depth)

For example,

```c++
     template<typename C, template<typename T> class TT>
     void test(TT<int> aaa);
```

for C and TT nesting depth is 0, so we can ask for index at depth 0: at depth 0 C's index is 0, TT's index is 1.

For T nesting depth is 1, so we can ask for index at depth 0 and 1: at depth 0 T's index is 1 (same as TT's), at depth 1 T's index is 0.

# Arguments
* `Comment`: a `CXComment_TParamCommand` AST node.
# Returns
zero-based parameter index in the template parameter list at a given nesting depth.
"""
function clang_TParamCommandComment_getIndex(Comment, Depth)
    @ccall libclang.clang_TParamCommandComment_getIndex(Comment::CXComment, Depth::Cuint)::Cuint
end

"""
    clang_VerbatimBlockLineComment_getText(Comment)

# Arguments
* `Comment`: a `CXComment_VerbatimBlockLine` AST node.
# Returns
text contained in the AST node.
"""
function clang_VerbatimBlockLineComment_getText(Comment)
    @ccall libclang.clang_VerbatimBlockLineComment_getText(Comment::CXComment)::CXString
end

"""
    clang_VerbatimLineComment_getText(Comment)

# Arguments
* `Comment`: a `CXComment_VerbatimLine` AST node.
# Returns
text contained in the AST node.
"""
function clang_VerbatimLineComment_getText(Comment)
    @ccall libclang.clang_VerbatimLineComment_getText(Comment::CXComment)::CXString
end

"""
    clang_HTMLTagComment_getAsString(Comment)

Convert an HTML tag AST node to string.

# Arguments
* `Comment`: a `CXComment_HTMLStartTag` or `CXComment_HTMLEndTag` AST node.
# Returns
string containing an HTML tag.
"""
function clang_HTMLTagComment_getAsString(Comment)
    @ccall libclang.clang_HTMLTagComment_getAsString(Comment::CXComment)::CXString
end

"""
    clang_FullComment_getAsHTML(Comment)

Convert a given full parsed comment to an HTML fragment.

Specific details of HTML layout are subject to change. Don't try to parse this HTML back into an AST, use other APIs instead.

Currently the following CSS classes are used:

* "para-brief" for

` and equivalent commands;`

* "para-returns" for \\returns paragraph and equivalent commands;

* "word-returns" for the "Returns" word in \\returns paragraph.

Function argument documentation is rendered as a <dl> list with arguments sorted in function prototype order. CSS classes used:

* "param-name-index-NUMBER" for parameter name (<dt>);

* "param-descr-index-NUMBER" for parameter description (<dd>);

* "param-name-index-invalid" and "param-descr-index-invalid" are used if parameter index is invalid.

Template parameter documentation is rendered as a <dl> list with parameters sorted in template parameter list order. CSS classes used:

* "tparam-name-index-NUMBER" for parameter name (<dt>);

* "tparam-descr-index-NUMBER" for parameter description (<dd>);

* "tparam-name-index-other" and "tparam-descr-index-other" are used for names inside template template parameters;

* "tparam-name-index-invalid" and "tparam-descr-index-invalid" are used if parameter position is invalid.

# Arguments
* `Comment`: a `CXComment_FullComment` AST node.
# Returns
string containing an HTML fragment.
"""
function clang_FullComment_getAsHTML(Comment)
    @ccall libclang.clang_FullComment_getAsHTML(Comment::CXComment)::CXString
end

"""
    clang_FullComment_getAsXML(Comment)

Convert a given full parsed comment to an XML document.

A Relax NG schema for the XML can be found in comment-xml-schema.rng file inside clang source tree.

# Arguments
* `Comment`: a `CXComment_FullComment` AST node.
# Returns
string containing an XML document.
"""
function clang_FullComment_getAsXML(Comment)
    @ccall libclang.clang_FullComment_getAsXML(Comment::CXComment)::CXString
end

mutable struct CXAPISetImpl end

"""
[`CXAPISet`](@ref) is an opaque type that represents a data structure containing all the API information for a given translation unit. This can be used for a single symbol symbol graph for a given symbol.
"""
const CXAPISet = Ptr{CXAPISetImpl}

"""
    clang_createAPISet(tu, out_api)

Traverses the translation unit to create a [`CXAPISet`](@ref).

# Arguments
* `tu`: is the [`CXTranslationUnit`](@ref) to build the [`CXAPISet`](@ref) for.
* `out_api`: is a pointer to the output of this function. It is needs to be disposed of by calling [`clang_disposeAPISet`](@ref).
# Returns
Error code indicating success or failure of the APISet creation.
"""
function clang_createAPISet(tu, out_api)
    @ccall libclang.clang_createAPISet(tu::CXTranslationUnit, out_api::Ptr{CXAPISet})::CXErrorCode
end

"""
    clang_disposeAPISet(api)

Dispose of an APISet.

The provided [`CXAPISet`](@ref) can not be used after this function is called.
"""
function clang_disposeAPISet(api)
    @ccall libclang.clang_disposeAPISet(api::CXAPISet)::Cvoid
end

"""
    clang_getSymbolGraphForUSR(usr, api)

Generate a single symbol symbol graph for the given USR. Returns a null string if the associated symbol can not be found in the provided [`CXAPISet`](@ref).

The output contains the symbol graph as well as some additional information about related symbols.

# Arguments
* `usr`: is a string containing the USR of the symbol to generate the symbol graph for.
* `api`: the [`CXAPISet`](@ref) to look for the symbol in.
# Returns
a string containing the serialized symbol graph representation for the symbol being queried or a null string if it can not be found in the APISet.
"""
function clang_getSymbolGraphForUSR(usr, api)
    @ccall libclang.clang_getSymbolGraphForUSR(usr::Cstring, api::CXAPISet)::CXString
end

"""
    clang_getSymbolGraphForCursor(cursor)

Generate a single symbol symbol graph for the declaration at the given cursor. Returns a null string if the AST node for the cursor isn't a declaration.

The output contains the symbol graph as well as some additional information about related symbols.

# Arguments
* `cursor`: the declaration for which to generate the single symbol symbol graph.
# Returns
a string containing the serialized symbol graph representation for the symbol being queried or a null string if it can not be found in the APISet.
"""
function clang_getSymbolGraphForCursor(cursor)
    @ccall libclang.clang_getSymbolGraphForCursor(cursor::CXCursor)::CXString
end

"""
    clang_install_aborting_llvm_fatal_error_handler()

Installs error handler that prints error message to stderr and calls abort(). Replaces currently installed error handler (if any).
"""
function clang_install_aborting_llvm_fatal_error_handler()
    @ccall libclang.clang_install_aborting_llvm_fatal_error_handler()::Cvoid
end

"""
    clang_uninstall_llvm_fatal_error_handler()

Removes currently installed error handler (if any). If no error handler is intalled, the default strategy is to print error message to stderr and call exit(1).
"""
function clang_uninstall_llvm_fatal_error_handler()
    @ccall libclang.clang_uninstall_llvm_fatal_error_handler()::Cvoid
end

"""
*Documentation not found in headers.*
"""
const CXRewriter = Ptr{Cvoid}

"""
    clang_CXRewriter_create(TU)

Create [`CXRewriter`](@ref).
"""
function clang_CXRewriter_create(TU)
    @ccall libclang.clang_CXRewriter_create(TU::CXTranslationUnit)::CXRewriter
end

"""
    clang_CXRewriter_insertTextBefore(Rew, Loc, Insert)

Insert the specified string at the specified location in the original buffer.
"""
function clang_CXRewriter_insertTextBefore(Rew, Loc, Insert)
    @ccall libclang.clang_CXRewriter_insertTextBefore(Rew::CXRewriter, Loc::CXSourceLocation, Insert::Cstring)::Cvoid
end

"""
    clang_CXRewriter_replaceText(Rew, ToBeReplaced, Replacement)

Replace the specified range of characters in the input with the specified replacement.
"""
function clang_CXRewriter_replaceText(Rew, ToBeReplaced, Replacement)
    @ccall libclang.clang_CXRewriter_replaceText(Rew::CXRewriter, ToBeReplaced::CXSourceRange, Replacement::Cstring)::Cvoid
end

"""
    clang_CXRewriter_removeText(Rew, ToBeRemoved)

Remove the specified range.
"""
function clang_CXRewriter_removeText(Rew, ToBeRemoved)
    @ccall libclang.clang_CXRewriter_removeText(Rew::CXRewriter, ToBeRemoved::CXSourceRange)::Cvoid
end

"""
    clang_CXRewriter_overwriteChangedFiles(Rew)

Save all changed files to disk. Returns 1 if any files were not saved successfully, returns 0 otherwise.
"""
function clang_CXRewriter_overwriteChangedFiles(Rew)
    @ccall libclang.clang_CXRewriter_overwriteChangedFiles(Rew::CXRewriter)::Cint
end

"""
    clang_CXRewriter_writeMainFileToStdOut(Rew)

Write out rewritten version of the main file to stdout.
"""
function clang_CXRewriter_writeMainFileToStdOut(Rew)
    @ccall libclang.clang_CXRewriter_writeMainFileToStdOut(Rew::CXRewriter)::Cvoid
end

"""
    clang_CXRewriter_dispose(Rew)

Free the given [`CXRewriter`](@ref).
"""
function clang_CXRewriter_dispose(Rew)
    @ccall libclang.clang_CXRewriter_dispose(Rew::CXRewriter)::Cvoid
end
