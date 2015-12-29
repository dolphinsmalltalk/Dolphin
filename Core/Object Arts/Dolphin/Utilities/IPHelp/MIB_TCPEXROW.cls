"Filed out from Dolphin Smalltalk X6"!

MIB_TCPROW subclass: #MIB_TCPEXROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_TCPEXROW guid: (GUID fromString: '{F2B03657-A3D2-486F-9D24-D597DE178487}')!
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
	"Answer the receiver's dwProcessId field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)! !
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
	self byteSize: 24! !
!MIB_TCPEXROW class categoriesFor: #defineFields!initializing!public! !

