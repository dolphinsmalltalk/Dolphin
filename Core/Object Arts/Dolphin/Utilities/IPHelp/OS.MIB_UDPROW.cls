"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.MIB_UDPROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MIB_UDPROW_Size' -> 16r8.
		'_OffsetOf_dwLocalAddr' -> 16r0.
		'_OffsetOf_dwLocalPort' -> 16r4
	}!
OS.MIB_UDPROW guid: (Core.GUID fromString: '{3247a36f-48e5-4e25-ae9a-2e76f029e521}')!
OS.MIB_UDPROW comment: '<MIB_UDPROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPROW {
	unsigned long dwLocalAddr;
	unsigned long dwLocalPort;
} MIB_UDPROW;
'!
!OS.MIB_UDPROW categoriesForClass!Win32-Structs! !
!OS.MIB_UDPROW methodsFor!

dwLocalAddr
	"Answer the <Integer> value of the receiver's 'dwLocalAddr' field."

	^bytes uint32AtOffset: _OffsetOf_dwLocalAddr!

dwLocalPort
	"Answer the <Integer> value of the receiver's 'dwLocalPort' field."

	^bytes uint32AtOffset: _OffsetOf_dwLocalPort! !
!OS.MIB_UDPROW categoriesForMethods!
dwLocalAddr!**compiled accessors**!public! !
dwLocalPort!**compiled accessors**!public! !
!

!OS.MIB_UDPROW class methodsFor!

byteSize
	^_MIB_UDPROW_Size!

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
			type: UInt32Field readOnly
			offset: 0;
		defineField: #dwLocalPort
			type: UInt32Field readOnly
			offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#dwLocalAddr #dwLocalPort)! !
!OS.MIB_UDPROW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

