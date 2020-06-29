"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #ICONDIRENTRY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bColorCount' -> 16r2.
		'_OffsetOf_bHeight' -> 16r1.
		'_OffsetOf_bReserved' -> 16r3.
		'_OffsetOf_bWidth' -> 16r0.
		'_OffsetOf_dwBytesInRes' -> 16r8.
		'_OffsetOf_dwImageOffset' -> 16rC.
		'_OffsetOf_wBitCount' -> 16r6.
		'_OffsetOf_wPlanes' -> 16r4
	}!
ICONDIRENTRY guid: (GUID fromString: '{c37d878b-52cb-41c6-a356-cc780f4eac95}')!
ICONDIRENTRY comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ICONDIRENTRY categoriesForClass!IDB Goodies! !
!ICONDIRENTRY methodsFor!

bColorCount
	"Answer the <Integer> value of the receiver's 'bColorCount' field."

	^bytes byteAtOffset: _OffsetOf_bColorCount!

bColorCount: anInteger
	"Set the receiver's 'bColorCount' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bColorCount put: anInteger!

bHeight
	"Answer the <Integer> value of the receiver's 'bHeight' field."

	^bytes byteAtOffset: _OffsetOf_bHeight!

bHeight: anInteger
	"Set the receiver's 'bHeight' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bHeight put: anInteger!

bReserved
	"Answer the <Integer> value of the receiver's 'bReserved' field."

	^bytes byteAtOffset: _OffsetOf_bReserved!

bWidth
	"Answer the <Integer> value of the receiver's 'bWidth' field."

	^bytes byteAtOffset: _OffsetOf_bWidth!

bWidth: anInteger
	"Set the receiver's 'bWidth' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bWidth put: anInteger!

dwBytesInRes
	"Answer the <Integer> value of the receiver's 'dwBytesInRes' field."

	^bytes dwordAtOffset: _OffsetOf_dwBytesInRes!

dwBytesInRes: anInteger
	"Set the receiver's 'dwBytesInRes' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwBytesInRes put: anInteger!

dwImageOffset
	"Answer the <Integer> value of the receiver's 'dwImageOffset' field."

	^bytes dwordAtOffset: _OffsetOf_dwImageOffset!

dwImageOffset: anInteger
	"Set the receiver's 'dwImageOffset' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwImageOffset put: anInteger!

wBitCount
	"Answer the <Integer> value of the receiver's 'wBitCount' field."

	^bytes wordAtOffset: _OffsetOf_wBitCount!

wBitCount: anInteger
	"Set the receiver's 'wBitCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wBitCount put: anInteger!

wPlanes
	"Answer the <Integer> value of the receiver's 'wPlanes' field."

	^bytes wordAtOffset: _OffsetOf_wPlanes!

wPlanes: anInteger
	"Set the receiver's 'wPlanes' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wPlanes put: anInteger! !
!ICONDIRENTRY categoriesFor: #bColorCount!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #bColorCount:!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #bHeight!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #bHeight:!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #bReserved!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #bWidth!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #bWidth:!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #dwBytesInRes!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #dwBytesInRes:!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #dwImageOffset!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #dwImageOffset:!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #wBitCount!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #wBitCount:!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #wPlanes!**compiled accessors**!public! !
!ICONDIRENTRY categoriesFor: #wPlanes:!**compiled accessors**!public! !

!ICONDIRENTRY class methodsFor!

defineFields
	self
		defineField: #bWidth type: BYTEField new;
		defineField: #bHeight type: BYTEField new;
		defineField: #bColorCount type: BYTEField new;
		defineField: #bReserved type: BYTEField readOnly;
		defineField: #wPlanes type: WORDField new;
		defineField: #wBitCount type: WORDField new;
		defineField: #dwBytesInRes type: DWORDField new;
		defineField: #dwImageOffset type: DWORDField new!

getFieldNames
	^#(#bWidth #bHeight #bColorCount #bReserved #wPlanes #wBitCount #dwBytesInRes #dwImageOffset)!

packing
	^1! !
!ICONDIRENTRY class categoriesFor: #defineFields!initializing!public! !
!ICONDIRENTRY class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!ICONDIRENTRY class categoriesFor: #packing!constants!public! !

