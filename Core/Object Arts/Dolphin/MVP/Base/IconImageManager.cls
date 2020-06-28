"Filed out from Dolphin Smalltalk 7"!

ImageManager subclass: #IconImageManager
	instanceVariableNames: 'bitmaps'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!IconImageManager categoriesFor: #bitmapForIcon:extent:!public!searching! !
!IconImageManager categoriesFor: #initialize!initializing!private! !
!IconImageManager categoriesFor: #menuBitmapForIcon:!public!searching! !
!IconImageManager categoriesFor: #newImages!private!removing! !
!IconImageManager categoriesFor: #stbSaveOn:!binary filing!public! !

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
!IconImageManager class categoriesFor: #current!instance creation!public! !
!IconImageManager class categoriesFor: #new!instance creation!private! !
!IconImageManager class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!IconImageManager class categoriesFor: #reset!operations!public! !
!IconImageManager class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!IconImageManager class categoriesFor: #uninitialize!class hierarchy-removing!private! !

