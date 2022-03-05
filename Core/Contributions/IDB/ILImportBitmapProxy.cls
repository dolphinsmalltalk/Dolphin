"Filed out from Dolphin Smalltalk"!

Object subclass: #ILImportBitmapProxy
	instanceVariableNames: 'bitmapInfoHeader colorTable imageBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILImportBitmapProxy guid: (GUID fromString: '{e7a42970-a8ac-4d70-81a2-7bcf6935cde4}')!
ILImportBitmapProxy comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILImportBitmapProxy categoriesForClass!IDB Goodies! !
!ILImportBitmapProxy methodsFor!

colorDepth
	^bitmapInfoHeader biBitCount!

colorTable
	^colorTable!

height
	^bitmapInfoHeader biHeight abs!

imageBytes
	^imageBytes!

isTopDown
	^bitmapInfoHeader biHeight < 0!

setBitmapInfoHeader: aBITMAPINFOHEADER colorTable: aStructureArray imageBytes: aByteArray
	bitmapInfoHeader := aBITMAPINFOHEADER.
	colorTable := aStructureArray.
	imageBytes := aByteArray!

width
	^bitmapInfoHeader biWidth! !
!ILImportBitmapProxy categoriesForMethods!
colorDepth!accessing!public! !
colorTable!accessing!public! !
height!accessing!public! !
imageBytes!accessing!public! !
isTopDown!public!testing! !
setBitmapInfoHeader:colorTable:imageBytes:!initializing!public! !
width!accessing!public! !
!

!ILImportBitmapProxy class methodsFor!

bitmapInfoHeader: aBITMAPINFOHEADER colorTable: aStructureArray imageBytes: aByteArray
	^self new 
		setBitmapInfoHeader: aBITMAPINFOHEADER
		colorTable: aStructureArray
		imageBytes: aByteArray! !
!ILImportBitmapProxy class categoriesForMethods!
bitmapInfoHeader:colorTable:imageBytes:!instance creation!public! !
!

