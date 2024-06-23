"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #ICONDIRENTRY
	instanceVariableNames: ''
	classVariableNames: '_ICONDIRENTRY_Size _OffsetOf_bColorCount _OffsetOf_bHeight _OffsetOf_bReserved _OffsetOf_bWidth _OffsetOf_dwBytesInRes _OffsetOf_dwImageOffset _OffsetOf_wBitCount _OffsetOf_wPlanes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICONDIRENTRY guid: (GUID fromString: '{c37d878b-52cb-41c6-a356-cc780f4eac95}')!

ICONDIRENTRY addClassConstant: '_ICONDIRENTRY_Size' value: 16r10!
ICONDIRENTRY addClassConstant: '_OffsetOf_bColorCount' value: 16r2!
ICONDIRENTRY addClassConstant: '_OffsetOf_bHeight' value: 16r1!
ICONDIRENTRY addClassConstant: '_OffsetOf_bReserved' value: 16r3!
ICONDIRENTRY addClassConstant: '_OffsetOf_bWidth' value: 16r0!
ICONDIRENTRY addClassConstant: '_OffsetOf_dwBytesInRes' value: 16r8!
ICONDIRENTRY addClassConstant: '_OffsetOf_dwImageOffset' value: 16rC!
ICONDIRENTRY addClassConstant: '_OffsetOf_wBitCount' value: 16r6!
ICONDIRENTRY addClassConstant: '_OffsetOf_wPlanes' value: 16r4!
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

!ICONDIRENTRY categoriesForMethods!
bColorCount!**compiled accessors**!public! !
bColorCount:!**compiled accessors**!public! !
bHeight!**compiled accessors**!public! !
bHeight:!**compiled accessors**!public! !
bReserved!**compiled accessors**!public! !
bWidth!**compiled accessors**!public! !
bWidth:!**compiled accessors**!public! !
dwBytesInRes!**compiled accessors**!public! !
dwBytesInRes:!**compiled accessors**!public! !
dwImageOffset!**compiled accessors**!public! !
dwImageOffset:!**compiled accessors**!public! !
wBitCount!**compiled accessors**!public! !
wBitCount:!**compiled accessors**!public! !
wPlanes!**compiled accessors**!public! !
wPlanes:!**compiled accessors**!public! !
!

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

!ICONDIRENTRY class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

