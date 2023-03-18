"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRANGLEARC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRANGLEARC_Size' -> 16r1C.
		'_OffsetOf_eStartAngle' -> 16r14.
		'_OffsetOf_eSweepAngle' -> 16r18.
		'_OffsetOf_nRadius' -> 16r10.
		'_OffsetOf_ptlCenter' -> 16r8
	}!
OS.EMRANGLEARC guid: (Core.GUID fromString: '{76825af3-ec74-45d6-8539-0c31f3e069b9}')!
OS.EMRANGLEARC comment: '<EMRANGLEARC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRANGLEARC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(76825AF3-EC74-45D6-8539-0C31F3E069B9)]
struct tagEMRANGLEARC {
	EMR EMR;
	POINTL ptlCenter;
	DWORD nRadius;
	float eStartAngle;
	float eSweepAngle;
} EMRANGLEARC;
'!
!OS.EMRANGLEARC categoriesForClass!Win32-Structs! !
!OS.EMRANGLEARC methodsFor!

eStartAngle
	"Answer the <Float> value of the receiver's 'eStartAngle' field."

	^bytes floatAtOffset: _OffsetOf_eStartAngle!

eStartAngle: aFloat
	"Set the receiver's 'eStartAngle' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eStartAngle put: aFloat!

eSweepAngle
	"Answer the <Float> value of the receiver's 'eSweepAngle' field."

	^bytes floatAtOffset: _OffsetOf_eSweepAngle!

eSweepAngle: aFloat
	"Set the receiver's 'eSweepAngle' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eSweepAngle put: aFloat!

nRadius
	"Answer the <Integer> value of the receiver's 'nRadius' field."

	^bytes uint32AtOffset: _OffsetOf_nRadius!

nRadius: anInteger
	"Set the receiver's 'nRadius' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nRadius put: anInteger!

ptlCenter
	"Answer the <POINTL> value of the receiver's 'ptlCenter' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlCenter!

ptlCenter: aPOINTL
	"Set the receiver's 'ptlCenter' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlCenter + 1)
		to: ##(_OffsetOf_ptlCenter + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.EMRANGLEARC categoriesForMethods!
eStartAngle!**compiled accessors**!public! !
eStartAngle:!**compiled accessors**!public! !
eSweepAngle!**compiled accessors**!public! !
eSweepAngle:!**compiled accessors**!public! !
nRadius!**compiled accessors**!public! !
nRadius:!**compiled accessors**!public! !
ptlCenter!**compiled accessors**!public! !
ptlCenter:!**compiled accessors**!public! !
!

!OS.EMRANGLEARC class methodsFor!

byteSize
	^_EMRANGLEARC_Size!

defineFields
	"Define the fields of the EMRANGLEARC structure.

	EMRANGLEARC  compileDefinition

		typedef [uuid(76825AF3-EC74-45D6-8539-0C31F3E069B9)]
		struct tagEMRANGLEARC {
			EMR EMR;
			POINTL ptlCenter;
			DWORD nRadius;
			float eStartAngle;
			float eSweepAngle;
		} EMRANGLEARC;
"

	super defineFields.
	self
		defineField: #ptlCenter
			type: (StructureField type: POINTL)
			offset: 8;
		defineField: #nRadius
			type: UInt32Field new
			offset: 16;
		defineField: #eStartAngle
			type: FLOATField new
			offset: 20;
		defineField: #eSweepAngle
			type: FLOATField new
			offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#iType #nSize #ptlCenter #nRadius #eStartAngle #eSweepAngle)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_ANGLEARC}! !
!OS.EMRANGLEARC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

