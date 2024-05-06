"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #BITMAPFILEHEADER
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bfOffBits _OffsetOf_bfReserved1 _OffsetOf_bfReserved2 _OffsetOf_bfSize _OffsetOf_bfType'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BITMAPFILEHEADER guid: (GUID fromString: '{48f23680-5426-11d3-998b-bca753d3b065}')!

BITMAPFILEHEADER addClassConstant: '_OffsetOf_bfOffBits' value: 16rA!
BITMAPFILEHEADER addClassConstant: '_OffsetOf_bfReserved1' value: 16r6!
BITMAPFILEHEADER addClassConstant: '_OffsetOf_bfReserved2' value: 16r8!
BITMAPFILEHEADER addClassConstant: '_OffsetOf_bfSize' value: 16r2!
BITMAPFILEHEADER addClassConstant: '_OffsetOf_bfType' value: 16r0!

BITMAPFILEHEADER comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!BITMAPFILEHEADER categoriesForClass!External-Data-Structured-Win32!IDB Goodies! !

!BITMAPFILEHEADER methodsFor!

bfOffBits
	"Answer the <Integer> value of the receiver's 'bfOffBits' field."

	^bytes dwordAtOffset: _OffsetOf_bfOffBits!

bfOffBits: anInteger
	"Set the receiver's 'bfOffBits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_bfOffBits put: anInteger!

bfReserved1
	"Answer the <Integer> value of the receiver's 'bfReserved1' field."

	^bytes wordAtOffset: _OffsetOf_bfReserved1!

bfReserved1: anInteger
	"Set the receiver's 'bfReserved1' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_bfReserved1 put: anInteger!

bfReserved2
	"Answer the <Integer> value of the receiver's 'bfReserved2' field."

	^bytes wordAtOffset: _OffsetOf_bfReserved2!

bfReserved2: anInteger
	"Set the receiver's 'bfReserved2' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_bfReserved2 put: anInteger!

bfSize
	"Answer the <Integer> value of the receiver's 'bfSize' field."

	^bytes dwordAtOffset: _OffsetOf_bfSize!

bfSize: anInteger
	"Set the receiver's 'bfSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_bfSize put: anInteger!

bfType
	"Answer the <Integer> value of the receiver's 'bfType' field."

	^bytes wordAtOffset: _OffsetOf_bfType!

bfType: anInteger
	"Set the receiver's 'bfType' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_bfType put: anInteger! !

!BITMAPFILEHEADER categoriesForMethods!
bfOffBits!**compiled accessors**!public! !
bfOffBits:!**compiled accessors**!public! !
bfReserved1!**compiled accessors**!public! !
bfReserved1:!**compiled accessors**!public! !
bfReserved2!**compiled accessors**!public! !
bfReserved2:!**compiled accessors**!public! !
bfSize!**compiled accessors**!public! !
bfSize:!**compiled accessors**!public! !
bfType!**compiled accessors**!public! !
bfType:!**compiled accessors**!public! !
!

!BITMAPFILEHEADER class methodsFor!

defineFields
	"Define the Win32 BITMAPFILEHEADER structure

		typedef struct tagBITMAPFILEHEADER {  // bmfh 
			   WORD   bfType; 
			   DWORD   bfSize; 
			   WORD   bfReserved1; 
			   WORD   bfReserved2; 
			   DWORD   bfOffBits; 
		} BITMAPFILEHEADER;"

	self
		defineField: #bfType type: WORDField new;
		defineField: #bfSize type: DWORDField new;
		defineField: #bfReserved1 type: WORDField new;
		defineField: #bfReserved2 type: WORDField new;
		defineField: #bfOffBits type: DWORDField new!

getFieldNames
	^#(#bfType #bfSize #bfReserved1 #bfReserved2 #bfOffBits)!

packing
	"Answer the default packing for instances of the receiver. 
	BITMAPFILEHEADER is unusual for a Windows structure in being packed to 
	1-byte boundaries - probably a 16-bit inheritance."

	^1! !

!BITMAPFILEHEADER class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

