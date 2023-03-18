"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRCREATEPEN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRCREATEPEN_Size' -> 16r1C.
			'_OffsetOf_ihPen' -> 16r8.
			'_OffsetOf_lopn' -> 16rC
		}!
OS.EMRCREATEPEN guid: (Core.GUID fromString: '{f7e241d3-4c87-4409-a235-94cd95523c94}')!
OS.EMRCREATEPEN comment: '<EMRCREATEPEN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEPEN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F7E241D3-4C87-4409-A235-94CD95523C94)]
struct tagEMRCREATEPEN {
	EMR EMR;
	[helpstring("Pen handle index")] DWORD ihPen;
	LOGPEN lopn;
} EMRCREATEPEN;
'!
!OS.EMRCREATEPEN categoriesForClass!Win32-Structs! !
!OS.EMRCREATEPEN methodsFor!

ihPen
	"Answer the <Integer> value of the receiver's 'ihPen' field."

	^bytes uint32AtOffset: _OffsetOf_ihPen!

ihPen: anInteger
	"Set the receiver's 'ihPen' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihPen put: anInteger!

lopn
	"Answer the <LOGPEN> value of the receiver's 'lopn' field."

	^LOGPEN fromAddress: bytes yourAddress + _OffsetOf_lopn!

lopn: aLOGPEN
	"Set the receiver's 'lopn' field to the value of the argument, aLOGPEN"

	aLOGPEN
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lopn + 1)
		to: ##(_OffsetOf_lopn + LOGPEN._LOGPEN_Size)
		startingAt: 1! !
!OS.EMRCREATEPEN categoriesForMethods!
ihPen!**compiled accessors**!public! !
ihPen:!**compiled accessors**!public! !
lopn!**compiled accessors**!public! !
lopn:!**compiled accessors**!public! !
!

!OS.EMRCREATEPEN class methodsFor!

byteSize
	^_EMRCREATEPEN_Size!

defineFields
	"Define the fields of the EMRCREATEPEN structure.

	EMRCREATEPEN  compileDefinition

		typedef [uuid(F7E241D3-4C87-4409-A235-94CD95523C94)]
		struct tagEMRCREATEPEN {
			EMR EMR;
			[helpstring('Pen handle index')] DWORD ihPen;
			LOGPEN lopn;
		} EMRCREATEPEN;
"

	super defineFields.
	self
		defineField: #ihPen
			type: UInt32Field new
			offset: 8;
		defineField: #lopn
			type: (StructureField type: LOGPEN)
			offset: 12.
	self byteSize: 28!

getFieldNames
	^#(#iType #nSize #ihPen #lopn)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_CREATEPEN}! !
!OS.EMRCREATEPEN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

