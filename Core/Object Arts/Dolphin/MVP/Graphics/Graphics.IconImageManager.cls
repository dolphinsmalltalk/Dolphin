﻿"Filed out from Dolphin Smalltalk"!

Graphics.ImageManager
	subclass: #'Graphics.IconImageManager'
	instanceVariableNames: 'bitmaps'
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.IconImageManager guid: (Core.GUID fromString: '{87b4c645-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.IconImageManager comment: ''!

!Graphics.IconImageManager categoriesForClass!Graphics-Tools! !

!Graphics.IconImageManager methodsFor!

bitmapForIcon: anIcon extent: aPoint
	| forExtent |
	forExtent := bitmaps at: aPoint ifAbsentPutClean: [LookupTable new].
	^(forExtent lookup: anIcon) ifNil: [forExtent at: anIcon asImageKey put: (anIcon asAlphaBitmap: aPoint)]!

initialize
	"Private - Initialize the receiver."

	super initialize.
	maskcolor := Color none.
	bitmaps := LookupTable new!

newImages
	bitmaps := LookupTable new.
	^super newImages!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveSingleton: self! !

!Graphics.IconImageManager categoriesForMethods!
bitmapForIcon:extent:!public!searching! !
initialize!initializing!private! !
newImages!private!removing! !
stbSaveOn:!binary filing!public! !
!

!Graphics.IconImageManager class methodsFor!

current
	"Answer the singleton instance of the receiver"

	Current isNil ifTrue: [Current := super new].
	^Current!

new
	"Private - The receiver is a singleton class"

	^self shouldNotImplement!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	Current ifNotNil: [Current purge]!

reset
	"Reset the receiver. Kill off the current singleton instance"

	Current := nil!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| singleton |
	singleton := self current.
	anSTBInFiler register: singleton.
	^singleton!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil! !

!Graphics.IconImageManager class categoriesForMethods!
current!instance creation!public! !
new!instance creation!private! !
onPreStripImage!class hierarchy-removing!private! !
reset!operations!public! !
stbReadFrom:format:size:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

