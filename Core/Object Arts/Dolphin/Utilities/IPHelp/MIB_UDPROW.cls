"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_UDPROW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwLocalAddr _OffsetOf_dwLocalPort'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPROW guid: (GUID fromString: '{3247a36f-48e5-4e25-ae9a-2e76f029e521}')!
MIB_UDPROW addClassConstant: '_OffsetOf_dwLocalAddr' value: 16r0!
MIB_UDPROW addClassConstant: '_OffsetOf_dwLocalPort' value: 16r4!
MIB_UDPROW comment: '<MIB_UDPROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPROW {
	unsigned long dwLocalAddr;
	unsigned long dwLocalPort;
} MIB_UDPROW;
'!
!MIB_UDPROW categoriesForClass!Win32-Structs! !
!MIB_UDPROW methodsFor!

dwLocalAddr
	"Answer the <Integer> value of the receiver's 'dwLocalAddr' field."

	^bytes dwordAtOffset: _OffsetOf_dwLocalAddr!

dwLocalPort
	"Answer the <Integer> value of the receiver's 'dwLocalPort' field."

	^bytes dwordAtOffset: _OffsetOf_dwLocalPort! !
!MIB_UDPROW categoriesForMethods!
dwLocalAddr!**compiled accessors**!public! !
dwLocalPort!**compiled accessors**!public! !
!

!MIB_UDPROW class methodsFor!

defineFields
	"Define the fields of the MIB_UDPROW structure.
		MIB_UDPROW compileDefinition
	
		typedef 
		struct tagMIB_UDPROW {
			unsigned long dwLocalAddr;
			unsigned long dwLocalPort;
		} MIB_UDPROW;
"

	self
		defineField: #dwLocalAddr
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwLocalPort
			type: DWORDField readOnly
			offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#dwLocalAddr #dwLocalPort)! !
!MIB_UDPROW class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

