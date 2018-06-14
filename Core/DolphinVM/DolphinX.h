// Definitions for Dolphin generic external call interface (shared by compiler)

#pragma once

namespace DolphinX {
	// Enums used for external call primitives

	// Location of data in the literal frame (first literal)
	enum { LibCallArgArray };

	// External call primitives
	enum { CallbackPrim=0, VirtualCallPrim=80, AsyncLibCallPrim=48, LibCallPrim=96 };

	// Calling conventions (fastcall not supported)
	enum ExtCallDeclSpecs { ExtCallStdCall, ExtCallCDecl, ExtCallThisCall, ExtCallFastCall, NumCallConventions };

	// Argument types
	// Note that differentiation between signed and unsigned types is only
	// really relevant to return values if using SmallIntegers
	// VOID is only supported as a return type 
	enum ExtCallArgTypes {
		ExtCallArgVOID			=0,
		ExtCallArgLPVOID,		//1
		ExtCallArgCHAR,			//2
		ExtCallArgBYTE,			//3
		ExtCallArgSBYTE,		//4
		ExtCallArgWORD,			//5
		ExtCallArgSWORD,		//6
		ExtCallArgDWORD,		//7
		ExtCallArgSDWORD,		//8
		ExtCallArgBOOL,			//9
		ExtCallArgHANDLE,		//10
		ExtCallArgDOUBLE,		//11
		ExtCallArgLPSTR,		//12
		ExtCallArgOOP,			//13
		ExtCallArgFLOAT,		//14
		ExtCallArgLPPVOID,		//15
		ExtCallArgHRESULT,		//16
		ExtCallArgLPWSTR,		//17		OLECHAR*, Unicode string
		ExtCallArgQWORD,		//18		Unsigned 64-bit LARGE_INTEGER
		ExtCallArgSQWORD,		//19		Signed 64-bit LARGE_INTEGER
		ExtCallArgOTE,			//20		Same as Oop, but disallows immediate objects
		ExtCallArgBSTR,			//21		VB String
		ExtCallArgVARIANT,		//22		VB Variant type
		ExtCallArgDATE,			//23		VB Date type
		ExtCallArgVARBOOL,		//24		VB Boolean type
		ExtCallArgGUID,			//25		GUID (128-bit unique number)
		ExtCallArgUINTPTR,		//26
		ExtCallArgINTPTR,		//27
								//28
								//29
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
		ExtCallArgSTRUCT=50,	//50	Was 26
		ExtCallArgSTRUCT4,		//51	Was 27
		ExtCallArgSTRUCT8,		//52	Was 28
		ExtCallArgLP,			//53	Was 29
		ExtCallArgLPP,			//54	Was 30
		ExtCallArgCOMPTR,		//55	Was 31
		ExtCallArgMax=63
	};

	#pragma pack(push, 1)


	// Disable warning about zero sized struct members
	#pragma warning(disable:4200)

	struct CallDescriptor
	{
		BYTE			m_callConv;
		BYTE			m_argsLen;
		BYTE			m_returnParm;
		BYTE			m_return;
		BYTE			m_args[];
	};

	struct ExternalMethodDescriptor
	{
		PROC			m_proc;
		CallDescriptor	m_descriptor;
	};

	#pragma pack(pop)
};