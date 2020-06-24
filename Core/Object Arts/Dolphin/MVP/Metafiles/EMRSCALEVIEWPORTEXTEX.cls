"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSCALEVIEWPORTEXTEX
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_xDenom _OffsetOf_xNum _OffsetOf_yDenom _OffsetOf_yNum'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSCALEVIEWPORTEXTEX guid: (GUID fromString: '{cb3c696e-59b6-4d1f-9413-f0a1fd89aaeb}')!
EMRSCALEVIEWPORTEXTEX addClassConstant: '_OffsetOf_xDenom' value: 16rC!
EMRSCALEVIEWPORTEXTEX addClassConstant: '_OffsetOf_xNum' value: 16r8!
EMRSCALEVIEWPORTEXTEX addClassConstant: '_OffsetOf_yDenom' value: 16r14!
EMRSCALEVIEWPORTEXTEX addClassConstant: '_OffsetOf_yNum' value: 16r10!
EMRSCALEVIEWPORTEXTEX comment: '<EMRSCALEVIEWPORTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSCALEVIEWPORTEXTEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(CB3C696E-59B6-4D1F-9413-F0A1FD89AAEB)]
struct tagEMRSCALEVIEWPORTEXTEX {
	EMR EMR;
	long xNum;
	long xDenom;
	long yNum;
	long yDenom;
} EMRSCALEVIEWPORTEXTEX;
'!
!EMRSCALEVIEWPORTEXTEX categoriesForClass!Win32-Structs! !
!EMRSCALEVIEWPORTEXTEX methodsFor!

xDenom
	"Answer the <Integer> value of the receiver's 'xDenom' field."

	^bytes sdwordAtOffset: _OffsetOf_xDenom!

xDenom: anInteger
	"Set the receiver's 'xDenom' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xDenom put: anInteger!

xNum
	"Answer the <Integer> value of the receiver's 'xNum' field."

	^bytes sdwordAtOffset: _OffsetOf_xNum!

xNum: anInteger
	"Set the receiver's 'xNum' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xNum put: anInteger!

yDenom
	"Answer the <Integer> value of the receiver's 'yDenom' field."

	^bytes sdwordAtOffset: _OffsetOf_yDenom!

yDenom: anInteger
	"Set the receiver's 'yDenom' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yDenom put: anInteger!

yNum
	"Answer the <Integer> value of the receiver's 'yNum' field."

	^bytes sdwordAtOffset: _OffsetOf_yNum!

yNum: anInteger
	"Set the receiver's 'yNum' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yNum put: anInteger! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #xDenom!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #xDenom:!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #xNum!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #xNum:!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #yDenom!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #yDenom:!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #yNum!**compiled accessors**!public! !
!EMRSCALEVIEWPORTEXTEX categoriesFor: #yNum:!**compiled accessors**!public! !

!EMRSCALEVIEWPORTEXTEX class methodsFor!

defineFields
	"Define the fields of the EMRSCALEVIEWPORTEXTEX structure.

	EMRSCALEVIEWPORTEXTEX  compileDefinition

		typedef [uuid(CB3C696E-59B6-4D1F-9413-F0A1FD89AAEB)]
		struct tagEMRSCALEVIEWPORTEXTEX {
			EMR EMR;
			long xNum;
			long xDenom;
			long yNum;
			long yDenom;
		} EMRSCALEVIEWPORTEXTEX;
"

	super defineFields.
	self
		defineField: #xNum
			type: SDWORDField new
			offset: 8;
		defineField: #xDenom
			type: SDWORDField new
			offset: 12;
		defineField: #yNum
			type: SDWORDField new
			offset: 16;
		defineField: #yDenom
			type: SDWORDField new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #xNum #xDenom #yNum #yDenom)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SCALEVIEWPORTEXTEX. EMR_SCALEWINDOWEXTEX}! !
!EMRSCALEVIEWPORTEXTEX class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSCALEVIEWPORTEXTEX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSCALEVIEWPORTEXTEX class categoriesFor: #iTypes!constants!public! !

