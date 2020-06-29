"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ILImportBitmapProxy
	instanceVariableNames: 'bitmapInfoHeader colorTable imageBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!ILImportBitmapProxy categoriesFor: #colorDepth!accessing!public! !
!ILImportBitmapProxy categoriesFor: #colorTable!accessing!public! !
!ILImportBitmapProxy categoriesFor: #height!accessing!public! !
!ILImportBitmapProxy categoriesFor: #imageBytes!accessing!public! !
!ILImportBitmapProxy categoriesFor: #isTopDown!public!testing! !
!ILImportBitmapProxy categoriesFor: #setBitmapInfoHeader:colorTable:imageBytes:!initializing!public! !
!ILImportBitmapProxy categoriesFor: #width!accessing!public! !

!ILImportBitmapProxy class methodsFor!

bitmapInfoHeader: aBITMAPINFOHEADER colorTable: aStructureArray imageBytes: aByteArray
	^self new 
		setBitmapInfoHeader: aBITMAPINFOHEADER
		colorTable: aStructureArray
		imageBytes: aByteArray! !
!ILImportBitmapProxy class categoriesFor: #bitmapInfoHeader:colorTable:imageBytes:!instance creation!public! !

