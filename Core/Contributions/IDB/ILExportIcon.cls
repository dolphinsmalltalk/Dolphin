"Filed out from Dolphin Smalltalk"!

ILExport subclass: #ILExportIcon
	instanceVariableNames: 'iconImages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILExportIcon guid: (GUID fromString: '{bf2bc3ca-d2ed-4656-8742-c4437f7398fb}')!
ILExportIcon comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILExportIcon categoriesForClass!IDB Goodies! !
!ILExportIcon methodsFor!

createColorBitmapFor: anImage force256: aBoolean
	self createColorTable: anImage colorsUsed force256: aBoolean.
	self createBitmap: anImage extent.
	anImage drawBitmapOn: bitmap canvas at: Point zero.
	^bitmap!

createICONDIR
	^(ICONDIR for: iconImages size)
		idType: self icondirType;
		idCount: iconImages size!

createIconImages
	iconImages := OrderedCollection new.
	images keysAndValuesDo: 
			[:index :each | 
			| maskBitmap colorBitmap iconImage header |
			iconImage := Array new: 5.
			colorBitmap := self createColorBitmapFor: each force256: false.
			maskBitmap := self createMaskBitmapFor: each updating: colorBitmap.
			header := colorBitmap bitmapInfoStruct bmiHeader copy.
			header
				biHeight: header biHeight * 2;
				biSizeImage: header biSizeImage + maskBitmap bitmapInfoStruct bmiHeader biSizeImage;
				biClrUsed: 0;
				biClrImportant: 0.
			iconImage
				at: 1 put: each;
				at: 2 put: header;
				at: 3 put: colorBitmap imageBytes copy;
				at: 4 put: colorBitmap getColorTable copy;
				at: 5 put: maskBitmap imageBytes copy.
			iconImages add: iconImage].
	^iconImages!

createMaskBitmapFor: anImage updating: aBitmap
	| canvas colorCanvas |
	self createColorTable: (Array with: Color black with: Color white) force256: false.
	self createBitmap: anImage extent.
	canvas := bitmap canvas.
	colorCanvas := aBitmap canvas.
	0 to: anImage extent x - 1
		do: 
			[:x | 
			0 to: anImage extent y - 1
				do: 
					[:y | 
					(anImage isTransparentAt: x @ y + 1) 
						ifTrue: 
							[colorCanvas pixelAt: x @ y put: Color black.
							canvas pixelAt: x @ y put: Color white]
						ifFalse: [canvas pixelAt: x @ y put: Color black]]].
	^bitmap!

exportTo: aStream
	| iconDir offset |
	self createIconImages.
	iconDir := self createICONDIR.
	offset := ICONDIR byteSize + ((iconImages size - 1) * ICONDIRENTRY byteSize).
	iconImages keysAndValuesDo: 
			[:index :each | 
			(iconDir idEntries at: index)
				bWidth: (each at: 1) extent x;
				bHeight: (each at: 1) extent y;
				bColorCount: ((each at: 4) size bitAnd: 255);
				dwBytesInRes: BITMAPINFOHEADER byteSize + (each at: 3) size + (each at: 4) byteSize 
							+ (each at: 5) size;
				dwImageOffset: offset.
			(self hotSpotFor: (each at: 1)) notNil 
				ifTrue: 
					["HotSpots are 0 based"

					(iconDir idEntries at: index)
						wPlanes: (self hotSpotFor: (each at: 1)) x - 1;
						wBitCount: (self hotSpotFor: (each at: 1)) y - 1].
			offset := offset + (iconDir idEntries at: index) dwBytesInRes].
	aStream nextPutAll: iconDir bytes.
	iconImages do: 
			[:each | 
			aStream
				nextPutAll: (each at: 2) bytes;
				nextPutAll: (each at: 4) asByteArray;
				nextPutAll: (each at: 3);
				nextPutAll: (each at: 5)]!

hotSpotFor: anImage
	^nil!

icondirType
	^1! !
!ILExportIcon categoriesForMethods!
createColorBitmapFor:force256:!operations!public! !
createICONDIR!operations!public! !
createIconImages!operations!public! !
createMaskBitmapFor:updating:!operations!public! !
exportTo:!operations!public! !
hotSpotFor:!accessing!public! !
icondirType!constants!public! !
!

