"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSCALEVIEWPORTEXTEX'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRSCALEVIEWPORTEXTEX_Size' -> 16r18.
			'_OffsetOf_xDenom' -> 16rC.
			'_OffsetOf_xNum' -> 16r8.
			'_OffsetOf_yDenom' -> 16r14.
			'_OffsetOf_yNum' -> 16r10
		}!
OS.EMRSCALEVIEWPORTEXTEX guid: (Core.GUID fromString: '{cb3c696e-59b6-4d1f-9413-f0a1fd89aaeb}')!
OS.EMRSCALEVIEWPORTEXTEX comment: '<EMRSCALEVIEWPORTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSCALEVIEWPORTEXTEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRSCALEVIEWPORTEXTEX categoriesForClass!Win32-Structs! !
!OS.EMRSCALEVIEWPORTEXTEX methodsFor!

xDenom
	"Answer the <Integer> value of the receiver's 'xDenom' field."

	^bytes int32AtOffset: _OffsetOf_xDenom!

xDenom: anInteger
	"Set the receiver's 'xDenom' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_xDenom put: anInteger!

xNum
	"Answer the <Integer> value of the receiver's 'xNum' field."

	^bytes int32AtOffset: _OffsetOf_xNum!

xNum: anInteger
	"Set the receiver's 'xNum' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_xNum put: anInteger!

yDenom
	"Answer the <Integer> value of the receiver's 'yDenom' field."

	^bytes int32AtOffset: _OffsetOf_yDenom!

yDenom: anInteger
	"Set the receiver's 'yDenom' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_yDenom put: anInteger!

yNum
	"Answer the <Integer> value of the receiver's 'yNum' field."

	^bytes int32AtOffset: _OffsetOf_yNum!

yNum: anInteger
	"Set the receiver's 'yNum' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_yNum put: anInteger! !
!OS.EMRSCALEVIEWPORTEXTEX categoriesForMethods!
xDenom!**compiled accessors**!public! !
xDenom:!**compiled accessors**!public! !
xNum!**compiled accessors**!public! !
xNum:!**compiled accessors**!public! !
yDenom!**compiled accessors**!public! !
yDenom:!**compiled accessors**!public! !
yNum!**compiled accessors**!public! !
yNum:!**compiled accessors**!public! !
!

!OS.EMRSCALEVIEWPORTEXTEX class methodsFor!

byteSize
	^_EMRSCALEVIEWPORTEXTEX_Size!

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
			type: Int32Field new
			offset: 8;
		defineField: #xDenom
			type: Int32Field new
			offset: 12;
		defineField: #yNum
			type: Int32Field new
			offset: 16;
		defineField: #yDenom
			type: Int32Field new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #xNum #xDenom #yNum #yDenom)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SCALEVIEWPORTEXTEX. EMR_SCALEWINDOWEXTEX}! !
!OS.EMRSCALEVIEWPORTEXTEX class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

