"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRANGLEARC
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_eStartAngle _OffsetOf_eSweepAngle _OffsetOf_nRadius _OffsetOf_ptlCenter'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRANGLEARC guid: (GUID fromString: '{76825af3-ec74-45d6-8539-0c31f3e069b9}')!

EMRANGLEARC addClassConstant: '_OffsetOf_eStartAngle' value: 16r14!
EMRANGLEARC addClassConstant: '_OffsetOf_eSweepAngle' value: 16r18!
EMRANGLEARC addClassConstant: '_OffsetOf_nRadius' value: 16r10!
EMRANGLEARC addClassConstant: '_OffsetOf_ptlCenter' value: 16r8!

EMRANGLEARC comment: '<EMRANGLEARC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRANGLEARC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!EMRANGLEARC categoriesForClass!Win32-Structs! !

!EMRANGLEARC methodsFor!

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

	^bytes dwordAtOffset: _OffsetOf_nRadius!

nRadius: anInteger
	"Set the receiver's 'nRadius' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nRadius put: anInteger!

ptlCenter
	"Answer the <POINTL> value of the receiver's 'ptlCenter' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptlCenter!

ptlCenter: aPOINTL
	"Set the receiver's 'ptlCenter' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlCenter + 1)
		to: ##(_OffsetOf_ptlCenter + POINTL basicByteSize)
		startingAt: 1! !

!EMRANGLEARC categoriesForMethods!
eStartAngle!**compiled accessors**!public! !
eStartAngle:!**compiled accessors**!public! !
eSweepAngle!**compiled accessors**!public! !
eSweepAngle:!**compiled accessors**!public! !
nRadius!**compiled accessors**!public! !
nRadius:!**compiled accessors**!public! !
ptlCenter!**compiled accessors**!public! !
ptlCenter:!**compiled accessors**!public! !
!

!EMRANGLEARC class methodsFor!

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
		defineField: #ptlCenter type: (StructureField type: POINTL) offset: 8;
		defineField: #nRadius type: DWORDField new offset: 16;
		defineField: #eStartAngle type: FLOATField new offset: 20;
		defineField: #eSweepAngle type: FLOATField new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#iType #nSize #ptlCenter #nRadius #eStartAngle #eSweepAngle)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_ANGLEARC! !

!EMRANGLEARC class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

