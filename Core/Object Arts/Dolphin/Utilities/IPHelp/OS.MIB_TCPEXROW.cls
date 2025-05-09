﻿"Filed out from Dolphin Smalltalk"!

OS.MIB_TCPROW
	subclass: #'OS.MIB_TCPEXROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_MIB_TCPEXROW_Size' -> 16r18. '_OffsetOf_dwProcessId' -> 16r14 }!

OS.MIB_TCPEXROW guid: (Core.GUID fromString: '{f2b03657-a3d2-486f-9d24-d597de178487}')!

OS.MIB_TCPEXROW comment: '<MIB_TCPEXROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_TCPEXROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.MIB_TCPEXROW categoriesForClass!Win32-Structs! !

!OS.MIB_TCPEXROW methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes uint32AtOffset: _OffsetOf_dwProcessId! !

!OS.MIB_TCPEXROW categoriesForMethods!
dwProcessId!**compiled accessors**!public! !
!

!OS.MIB_TCPEXROW class methodsFor!

byteSize
	^_MIB_TCPEXROW_Size!

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
		type: UInt32Field readOnly
		offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#dwState #dwLocalAddr #dwLocalPort #dwRemoteAddr #dwRemotePort #dwProcessId)! !

!OS.MIB_TCPEXROW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

