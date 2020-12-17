"Filed out from Dolphin Smalltalk 7"!

MIB_TCPROW subclass: #MIB_TCPEXROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwProcessId' -> 16r14
	}!
MIB_TCPEXROW guid: (GUID fromString: '{f2b03657-a3d2-486f-9d24-d597de178487}')!
MIB_TCPEXROW comment: '<MIB_TCPEXROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_TCPEXROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_TCPEXROW {
	unsigned long dwState;
	unsigned long dwLocalAddr;
	unsigned long dwLocalPort;
	unsigned long dwRemoteAddr;
	unsigned long dwRemotePort;
	unsigned long dwProcessId;
} MIB_TCPEXROW;
'!
!MIB_TCPEXROW categoriesForClass!Win32-Structs! !
!MIB_TCPEXROW methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes dwordAtOffset: _OffsetOf_dwProcessId! !
!MIB_TCPEXROW categoriesFor: #dwProcessId!**compiled accessors**!public! !

!MIB_TCPEXROW class methodsFor!

defineFields
	"Define the fields of the MIB_TCPEXROW structure.
		MIB_TCPEXROW compileDefinition
	
		typedef 
		struct tagMIB_TCPEXROW {
			unsigned long dwState;
			unsigned long dwLocalAddr;
			unsigned long dwLocalPort;
			unsigned long dwRemoteAddr;
			unsigned long dwRemotePort;
			unsigned long dwProcessId;
		} MIB_TCPEXROW;
"

	super defineFields.
	self 
		defineField: #dwProcessId
		type: DWORDField readOnly
		offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#dwState #dwLocalAddr #dwLocalPort #dwRemoteAddr #dwRemotePort #dwProcessId)! !
!MIB_TCPEXROW class categoriesFor: #defineFields!initializing!public! !
!MIB_TCPEXROW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

