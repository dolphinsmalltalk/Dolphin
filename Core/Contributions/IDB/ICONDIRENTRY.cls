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

packing
	^1! !
!ICONDIRENTRY class categoriesFor: #defineFields!initializing!public! !
!ICONDIRENTRY class categoriesFor: #packing!constants!public! !

