import CppInterOp as Cpp

args = ["-isystem/Users/gnimuc/.julia/artifacts/fbb170fa64a06b66dd9a16aaa21bf12848042d9a/lib/gcc/aarch64-apple-darwin20/11.0.0/include", "-isystem/Users/gnimuc/.julia/artifacts/fbb170fa64a06b66dd9a16aaa21bf12848042d9a/lib/gcc/aarch64-apple-darwin20/11.0.0/include-fixed", "-isystem/Users/gnimuc/.julia/artifacts/fbb170fa64a06b66dd9a16aaa21bf12848042d9a/aarch64-apple-darwin20/include", "-isystem/Users/gnimuc/.julia/artifacts/fbb170fa64a06b66dd9a16aaa21bf12848042d9a/aarch64-apple-darwin20/sys-root/usr/include", "-isystem/Users/gnimuc/.julia/artifacts/fbb170fa64a06b66dd9a16aaa21bf12848042d9a/aarch64-apple-darwin20/sys-root/System/Library/Frameworks", "--target=aarch64-apple-darwin20"]
push!(args, "-isystem" * Cpp.CLANG_INC)
push!(args, "-nostdinc++", "-nostdlib++")
push!(args, "-nostdinc", "-nostdlib")
push!(args, "-v")

Cpp.CreateInterpreter(args)
EXPECT_FALSE(Cpp::IsDebugOutputEnabled());
std::string cerrs;
testing::internal::CaptureStderr();
Cpp::Process("int a = 12;");
cerrs = testing::internal::GetCapturedStderr();
EXPECT_STREQ(cerrs.c_str(), "");
Cpp::EnableDebugOutput();
EXPECT_TRUE(Cpp::IsDebugOutputEnabled());
testing::internal::CaptureStderr();
Cpp::Process("int b = 12;");
cerrs = testing::internal::GetCapturedStderr();
EXPECT_STRNE(cerrs.c_str(), "");

Cpp::EnableDebugOutput(false);
EXPECT_FALSE(Cpp::IsDebugOutputEnabled());
testing::internal::CaptureStderr();
Cpp::Process("int c = 12;");
cerrs = testing::internal::GetCapturedStderr();
EXPECT_STREQ(cerrs.c_str(), "");
