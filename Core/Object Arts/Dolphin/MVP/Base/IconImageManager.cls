"Filed out from Dolphin Smalltalk"!

ImageManager subclass: #IconImageManager
	instanceVariableNames: 'bitmaps'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IconImageManager guid: (GUID fromString: '{87b4c645-026e-11d3-9fd7-00a0cc3e4a32}')!

IconImageManager comment: ''!

!IconImageManager categoriesForClass!Graphics-Tools! !

!IconImageManager methodsFor!

bitmapForIcon: anIcon extent: aPoint
	| forExtent |
	forExtent := bitmaps at: aPoint ifAbsentPut: [LookupTable new].
	^forExtent at: anIcon ifAbsentPut: [anIcon asAlphaBitmap: aPoint]!

initialize
	"Private - Initialize the receiver."

	super initialize.
	maskcolor := Color none.
	bitmaps := LookupTable new!

menuBitmapForIcon: anIcon
	"Answer a 32-bit bitmap with alpha channel created from the <Icon> argument, with the
	correct extent to display as a menu image."

	^self bitmapForIcon: anIcon extent: SystemMetrics current menuImageExtent!

newImages
	bitmaps := LookupTable new.
	^super newImages!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !

!IconImageManager categoriesForMethods!
bitmapForIcon:extent:!public!searching! !
initialize!initializing!private! !
menuBitmapForIcon:!public!searching! !
newImages!private!removing! !
stbSaveOn:!binary filing!public! !
!

!IconImageManager class methodsFor!

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

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| singleton |
	singleton := self current.
	anSTBInFiler register: singleton.
	^singleton!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil! !

!IconImageManager class categoriesForMethods!
current!instance creation!public! !
new!instance creation!private! !
onPreStripImage!class hierarchy-removing!private! !
reset!operations!public! !
stbReadFrom:format:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

