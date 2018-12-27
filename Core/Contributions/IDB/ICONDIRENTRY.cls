"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #ICONDIRENTRY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICONDIRENTRY guid: (GUID fromString: '{c37d878b-52cb-41c6-a356-cc780f4eac95}')!
ICONDIRENTRY comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ICONDIRENTRY categoriesForClass!IDB Goodies! !
!ICONDIRENTRY methodsFor!

bColorCount
	"Answer the <Integer> value of the receiver's 'bColorCount' field."

	^bytes byteAtOffset: ##(self offsetOf: #bColorCount)!

bColorCount: anInteger
	"Set the receiver's 'bColorCount' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #bColorCount) put: anInteger!

bHeight
	"Answer the <Integer> value of the receiver's 'bHeight' field."

	^bytes byteAtOffset: ##(self offsetOf: #bHeight)!

bHeight: anInteger
	"Set the receiver's 'bHeight' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #bHeight) put: anInteger!

bReserved
	"Answer the <Integer> value of the receiver's 'bReserved' field."

	^bytes byteAtOffset: ##(self offsetOf: #bReserved)!

bWidth
	"Answer the <Integer> value of the receiver's 'bWidth' field."

	^bytes byteAtOffset: 0!

bWidth: anInteger
	"Set the receiver's 'bWidth' field to the value of the argument, anInteger"

	bytes byteAtOffset: 0 put: anInteger!

dwBytesInRes
	"Answer the <Integer> value of the receiver's 'dwBytesInRes' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwBytesInRes)!

dwBytesInRes: anInteger
	"Set the receiver's 'dwBytesInRes' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwBytesInRes) put: anInteger!

dwImageOffset
	"Answer the <Integer> value of the receiver's 'dwImageOffset' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwImageOffset)!

dwImageOffset: anInteger
	"Set the receiver's 'dwImageOffset' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwImageOffset) put: anInteger!

wBitCount
	"Answer the <Integer> value of the receiver's 'wBitCount' field."

	^bytes wordAtOffset: ##(self offsetOf: #wBitCount)!

wBitCount: anInteger
	"Set the receiver's 'wBitCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wBitCount) put: anInteger!

wPlanes
	"Answer the <Integer> value of the receiver's 'wPlanes' field."

	^bytes wordAtOffset: ##(self offsetOf: #wPlanes)!

wPlanes: anInteger
	"Set the receiver's 'wPlanes' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wPlanes) put: anInteger! !
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

