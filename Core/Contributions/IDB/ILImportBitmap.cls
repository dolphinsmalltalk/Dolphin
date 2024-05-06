"Filed out from Dolphin Smalltalk"!

ILImport subclass: #ILImportBitmap
	instanceVariableNames: 'bitmapFileHeader bitmap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILImportBitmap guid: (GUID fromString: '{a969d8db-1959-4401-b80d-65349a755bc2}')!

ILImportBitmap comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILImportBitmap categoriesForClass!IDB Goodies! !

!ILImportBitmap methodsFor!

images
	| imageSize images |
	images := OrderedCollection new.
	imageSize := self requestImageSize.
	imageSize isNil ifTrue: [^images].

	"Cursor needed here cos of the dialog just opened"
	Cursor wait showWhile: 
			[0 to: bitmap width - 1
				by: imageSize x
				do: 
					[:offset | 
					| colors |
					colors := Array writeStream.
					1 to: imageSize y
						do: 
							[:y | 
							1 to: imageSize x
								do: [:x | colors nextPut: (self colorAtPoint: (x + offset) @ y in: bitmap)]].
					images add: (ILImage extent: imageSize colors: colors contents)]].
	^images!

initializeFrom: aStream
	bitmapFileHeader := BITMAPFILEHEADER fromBytes: (aStream next: BITMAPFILEHEADER byteSize).
	bitmap := self getBitmapFrom: aStream upToEnd!

proxyClass
	^ILImportBitmapProxy!

requestImageSize
	^(ILBitmapExtentDialog create)
		bitmapExtent: bitmap width @ bitmap height;
		showModal! !

!ILImportBitmap categoriesForMethods!
images!operations!public! !
initializeFrom:!initializing!public! !
proxyClass!constants!public! !
requestImageSize!helpers!public! !
!

!ILImportBitmap class methodsFor!

isResponsibleFor: aStream
	^(aStream next: 2) = 'BM' asByteArray! !

!ILImportBitmap class categoriesForMethods!
isResponsibleFor:!public!testing! !
!

