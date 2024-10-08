﻿"Filed out from Dolphin Smalltalk"!

OS.MIB_UDPROW
	subclass: #'OS.MIB_UDPEXROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_MIB_UDPEXROW_Size' -> 16rC. '_OffsetOf_dwProcessId' -> 16r8 }!

OS.MIB_UDPEXROW guid: (Core.GUID fromString: '{fda0765b-395f-447b-881b-26155c88393a}')!

OS.MIB_UDPEXROW comment: '<MIB_UDPEXROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPEXROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPEXROW {
	unsigned long dwLocalAddr;
	unsigned long dwLocalPort;
	unsigned long dwProcessId;
} MIB_UDPEXROW;
'!

!OS.MIB_UDPEXROW categoriesForClass!Win32-Structs! !

!OS.MIB_UDPEXROW methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes uint32AtOffset: _OffsetOf_dwProcessId! !

!OS.MIB_UDPEXROW categoriesForMethods!
dwProcessId!**compiled accessors**!public! !
!

!OS.MIB_UDPEXROW class methodsFor!

byteSize
	^_MIB_UDPEXROW_Size!

defineFields
	"Define the fields of the MIB_UDPEXROW structure.
		MIB_UDPEXROW compileDefinition
	
		typedef 
		struct tagMIB_UDPEXROW {
			unsigned long dwLocalAddr;
			unsigned long dwLocalPort;
			unsigned long dwProcessId;
		} MIB_UDPEXROW;
"

	super defineFields.
	self 
		defineField: #dwProcessId
		type: UInt32Field readOnly
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#dwLocalAddr #dwLocalPort #dwProcessId)! !

!OS.MIB_UDPEXROW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

