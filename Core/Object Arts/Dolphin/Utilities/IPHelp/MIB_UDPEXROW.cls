"Filed out from Dolphin Smalltalk"!

MIB_UDPROW subclass: #MIB_UDPEXROW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwProcessId'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPEXROW guid: (GUID fromString: '{fda0765b-395f-447b-881b-26155c88393a}')!
MIB_UDPEXROW addClassConstant: '_OffsetOf_dwProcessId' value: 16r8!
MIB_UDPEXROW comment: '<MIB_UDPEXROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPEXROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!MIB_UDPEXROW categoriesForClass!Win32-Structs! !
!MIB_UDPEXROW methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes dwordAtOffset: _OffsetOf_dwProcessId! !
!MIB_UDPEXROW categoriesForMethods!
dwProcessId!**compiled accessors**!public! !
!

!MIB_UDPEXROW class methodsFor!

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
		type: DWORDField readOnly
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#dwLocalAddr #dwLocalPort #dwProcessId)! !
!MIB_UDPEXROW class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

