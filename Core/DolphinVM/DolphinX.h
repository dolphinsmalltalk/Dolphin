// Definitions for Dolphin generic external call interface (shared by compiler)

#pragma once

namespace DolphinX {
	// Enums used for external call primitives

	// Location of data in the literal frame (first literal)
	static constexpr size_t LibCallArgArray = 0;

	// External call primitives
	enum class ExtCallPrimitive : uint8_t { Callback=0, VirtualCall=80, AsyncLibCall=48, LibCall=96 };

	// Calling conventions (fastcall not supported)
	enum class ExtCallDeclSpec : uint8_t { StdCall, CDecl, ThisCall, FastCall, NumCallConventions };

	// Argument types
	// Note that differentiation between signed and unsigned types is only
	// really relevant to return values if using SmallIntegers
	// VOID is only supported as a return type 
	enum class ExtCallArgType : uint8_t {
		Void			=0,
		LPVoid,		//1
		Char,			//2
		UInt8,			//3
		Int8,		//4
		UInt16,			//5
		Int16,		//6
		UInt32,		//7
		Int32,		//8
		Bool,			//9
		Handle,		//10
		Double,		//11
		LPStr,		//12
		Oop,			//13
		Float,		//14
		LPPVoid,		//15
		HResult,		//16
		LPWStr,		//17		OLECHAR*, Unicode string
		UInt64,		//18		Unsigned 64-bit LARGE_INTEGER
		Int64,		//19		Signed 64-bit LARGE_INTEGER
		Ote,			//20		Same as Oop, but disallows immediate objects
		Bstr,			//21		VB String
		Variant,		//22		VB Variant type
		Date,			//23		VB Date type
		VarBool,		//24		VB Boolean type
		Guid,			//25		GUID (128-bit unique number)
		UIntPtr,		//26
		IntPtr,		//27
		NTStatus,		//28
		Errno,			//29	integer return code, fails external call if non-zero
								//30
								//31
								//32
								//33
								//34
								//35
								//36
								//37
								//38
								//39
								//40
								//41
								//42
								//43
								//44
								//45
								//46
								//47
								//48
								//49
		Struct=50,	//50	Was 26
		Struct32,		//51	Was 27
		Struct64,		//52	Was 28
		LPStruct,			//53	Was 29
		LPPStruct,			//54	Was 30
		ComPtr,		//55	Was 31
		ExtCallArgMax=63
	};

	#pragma pack(push, 1)


	// Disable warning about zero sized struct members
	#pragma warning(disable:4200)

	struct CallDescriptor
	{
		uint8_t			m_callConv;
		uint8_t			m_argsLen;
		uint8_t			m_returnParm;
		uint8_t			m_return;
		uint8_t			m_args[];
	};

	struct ExternalMethodDescriptor
	{
		PROC			m_proc;
		CallDescriptor	m_descriptor;
	};

	#pragma pack(pop)
};