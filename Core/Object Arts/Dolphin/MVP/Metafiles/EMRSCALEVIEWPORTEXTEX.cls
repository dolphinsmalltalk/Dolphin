"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRSCALEVIEWPORTEXTEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSCALEVIEWPORTEXTEX guid: (GUID fromString: '{CB3C696E-59B6-4D1F-9413-F0A1FD89AAEB}')!
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
	"Answer the receiver's xDenom field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #xDenom)!

xDenom: anObject 
	"Set the receiver's xDenom field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #xDenom) put: anObject!

xNum
	"Answer the receiver's xNum field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #xNum)!

xNum: anObject 
	"Set the receiver's xNum field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #xNum) put: anObject!

yDenom
	"Answer the receiver's yDenom field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #yDenom)!

yDenom: anObject 
	"Set the receiver's yDenom field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #yDenom) put: anObject!

yNum
	"Answer the receiver's yNum field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #yNum)!

yNum: anObject 
	"Set the receiver's yNum field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #yNum) put: anObject! !
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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SCALEVIEWPORTEXTEX with: EMR_SCALEWINDOWEXTEX! !
!EMRSCALEVIEWPORTEXTEX class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSCALEVIEWPORTEXTEX class categoriesFor: #iTypes!constants!public! !

