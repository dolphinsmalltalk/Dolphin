"Filed out from Dolphin Smalltalk 7"!

ImageManager subclass: #IconImageManager
	instanceVariableNames: 'menuBitmaps'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IconImageManager guid: (GUID fromString: '{87B4C645-026E-11D3-9FD7-00A0CC3E4A32}')!
IconImageManager comment: ''!
!IconImageManager categoriesForClass!Graphics-Tools! !
!IconImageManager methodsFor!

initialize
	"Private - Initialize the receiver."

	super initialize.
	maskcolor := Color none.
	menuBitmaps := LookupTable new!

menuBitmapForIcon: anIcon 
	^menuBitmaps at: anIcon ifAbsentPut: [anIcon asAlphaBitmap: SystemMetrics current menuImageExtent]!

newImages
	menuBitmaps := LookupTable new.
	^super newImages!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!IconImageManager categoriesFor: #initialize!initializing!private! !
!IconImageManager categoriesFor: #menuBitmapForIcon:!public! !
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

	Current := nil!

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

	Current := nil.! !
!IconImageManager class categoriesFor: #current!instance creation!public! !
!IconImageManager class categoriesFor: #new!instance creation!private! !
!IconImageManager class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!IconImageManager class categoriesFor: #reset!operations!public! !
!IconImageManager class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!IconImageManager class categoriesFor: #uninitialize!class hierarchy-removing!private! !

