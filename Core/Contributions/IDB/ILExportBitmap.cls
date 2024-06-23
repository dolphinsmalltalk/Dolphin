"Filed out from Dolphin Smalltalk"!

ILExport subclass: #ILExportBitmap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILExportBitmap guid: (GUID fromString: '{91828d5f-ba46-43ae-858e-f89635cf232e}')!

ILExportBitmap comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILExportBitmap categoriesForClass!IDB Goodies! !

!ILExportBitmap methodsFor!

exportTo: aStream
	| imageExtent canvas |
	imageExtent := self maximumSize extent.
	self createColorTable: (images inject: Bag new
				into: 
					[:colors :each | 
					colors addAll: each colorsUsed.
					colors])
		force256: false.
	self createBitmap: images size @ 1 * imageExtent.
	canvas := bitmap canvas.
	images 
		keysAndValuesDo: [:index :each | each drawBitmapOn: canvas at: ((index - 1) * imageExtent x) @ 0].
	bitmap saveToStream: aStream!

maximumSize
	^images inject: Rectangle new
		into: [:rect :each | rect merge: (Point zero extent: each extent)]! !

!ILExportBitmap categoriesForMethods!
exportTo:!operations!public! !
maximumSize!helpers!public! !
!

