"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BITMAPFILEHEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bfOffBits' -> 16rA.
		'_OffsetOf_bfReserved1' -> 16r6.
		'_OffsetOf_bfReserved2' -> 16r8.
		'_OffsetOf_bfSize' -> 16r2.
		'_OffsetOf_bfType' -> 16r0
	}!
BITMAPFILEHEADER guid: (GUID fromString: '{48f23680-5426-11d3-998b-bca753d3b065}')!
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
!BITMAPFILEHEADER categoriesFor: #bfOffBits!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfOffBits:!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfReserved1!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfReserved1:!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfReserved2!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfReserved2:!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfSize!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfSize:!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfType!**compiled accessors**!public! !
!BITMAPFILEHEADER categoriesFor: #bfType:!**compiled accessors**!public! !

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
!BITMAPFILEHEADER class categoriesFor: #defineFields!initializing!public! !
!BITMAPFILEHEADER class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!BITMAPFILEHEADER class categoriesFor: #packing!constants!public! !

