"Filed out from Dolphin Smalltalk"!

ILExportIcon subclass: #ILExportExe
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILExportExe guid: (GUID fromString: '{c4413a4b-200d-48a9-b406-16b894b6c3ce}')!

ILExportExe comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILExportExe categoriesForClass!IDB Goodies! !

!ILExportExe methodsFor!

createIconImages
	| bitmapInfoHeader |
	super createIconImages.
	"must be 2 images"
	iconImages size = 2 ifFalse: [^false].
	"first must be 32x32@16"
	bitmapInfoHeader := iconImages first at: 2.
	bitmapInfoHeader biWidth = 32 & (bitmapInfoHeader biHeight = 64) ifFalse: [^false].
	bitmapInfoHeader biBitCount = 4 ifFalse: [^false].
	"last must be 32x32@256"
	bitmapInfoHeader := iconImages last at: 2.
	bitmapInfoHeader biWidth = 32 & (bitmapInfoHeader biHeight = 64) ifFalse: [^false].
	bitmapInfoHeader biBitCount = 8 ifFalse: [self upgradeTo256: iconImages last].
	^true!

errorMessage
	MessageBox 
		notify: 'Unable to export icons to Exe file because of one (or more) of the following.

The file named is not a exe file.
The file named was not created by Dolphin V5.
There must be 2 images selected.
The selection does not provide 2 icons with the following attributes and in the following order
	32 x 32 using 3 to 16 colours.
	32 x 32 using 3 to 256 colours'!

exportTo: aStream
	| importClass |
	self createIconImages ifFalse: [^self errorMessage].
	importClass := (OrderedCollection with: ILImportStandardExe with: ILImportToGoExe) 
				detect: [:each | [each isResponsibleFor: aStream] ensure: [aStream reset]]
				ifNone: [^self errorMessage].
	aStream position: importClass iconsStartAddress.
	iconImages do: 
			[:each | 
			aStream
				nextPutAll: (each at: 2) bytes;
				nextPutAll: (each at: 4) asByteArray;
				nextPutAll: (each at: 3);
				nextPutAll: (each at: 5)].
	self assert: [aStream position = importClass iconsEndAddress]!

upgradeTo256: anIconImage
	| colorBitmap maskBitmap header |
	colorBitmap := self createColorBitmapFor: (anIconImage at: 1) force256: true.
	maskBitmap := self createMaskBitmapFor: (anIconImage at: 1) updating: colorBitmap.
	header := colorBitmap bitmapInfoStruct bmiHeader copy.
	header
		biHeight: header biHeight * 2;
		biSizeImage: header biSizeImage + maskBitmap bitmapInfoStruct bmiHeader biSizeImage;
		biClrUsed: 0;
		biClrImportant: 0.
	anIconImage
		at: 2 put: header;
		at: 3 put: colorBitmap imageBytes copy;
		at: 4 put: colorBitmap getColorTable copy;
		at: 5 put: maskBitmap imageBytes copy! !

!ILExportExe categoriesForMethods!
createIconImages!operations!public! !
errorMessage!helpers!public! !
exportTo:!operations!public! !
upgradeTo256:!operations!public! !
!

