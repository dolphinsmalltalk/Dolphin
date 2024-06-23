"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.MIBICMPSTATS_EX'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MIBICMPSTATS_EX_Size' -> 16r408.
			'_OffsetOf_dwErrors' -> 16r4.
			'_OffsetOf_dwMsgs' -> 16r0.
			'_OffsetOf_rgdwTypeCount' -> 16r8
		}!

OS.MIBICMPSTATS_EX guid: (Core.GUID fromString: '{82731d6f-0e73-4221-9881-7172ae7d82cd}')!

OS.MIBICMPSTATS_EX comment: '<MIBICMPSTATS_EX> is an <ExternalStructure> class to wrap the struct ''Win32.MIBICMPSTATS_EX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIBICMPSTATS_EX {
	unsigned long dwMsgs;
	unsigned long dwErrors;
	unsigned long rgdwTypeCount[256];
} MIBICMPSTATS_EX;
'!

!OS.MIBICMPSTATS_EX categoriesForClass!Win32-Structs! !

!OS.MIBICMPSTATS_EX methodsFor!

dwErrors
	"Answer the <Integer> value of the receiver's 'dwErrors' field."

	^bytes uint32AtOffset: _OffsetOf_dwErrors!

dwMsgs
	"Answer the <Integer> value of the receiver's 'dwMsgs' field."

	^bytes uint32AtOffset: _OffsetOf_dwMsgs!

rgdwTypeCount
	"Answer the <UInt32Array> value of the receiver's 'rgdwTypeCount' field."

	^UInt32Array fromAddress: bytes yourAddress + _OffsetOf_rgdwTypeCount length: 256! !

!OS.MIBICMPSTATS_EX categoriesForMethods!
dwErrors!**compiled accessors**!public! !
dwMsgs!**compiled accessors**!public! !
rgdwTypeCount!**compiled accessors**!public! !
!

!OS.MIBICMPSTATS_EX class methodsFor!

byteSize
	^_MIBICMPSTATS_EX_Size!

defineFields
	"Define the fields of the MIBICMPSTATS_EX structure.
		MIBICMPSTATS_EX compileDefinition
	
		typedef 
		struct tagMIBICMPSTATS_EX {
			unsigned long dwMsgs;
			unsigned long dwErrors;
			unsigned long rgdwTypeCount[256];
		} MIBICMPSTATS_EX;
"

	self
		defineField: #dwMsgs
			type: UInt32Field readOnly
			offset: 0;
		defineField: #dwErrors
			type: UInt32Field readOnly
			offset: 4;
		defineField: #rgdwTypeCount
			type: ((ArrayField type: UInt32Array length: 256)
					beReadOnly;
					yourself)
			offset: 8.
	self byteSize: 1032!

getFieldNames
	^#(#dwMsgs #dwErrors #rgdwTypeCount)! !

!OS.MIBICMPSTATS_EX class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

