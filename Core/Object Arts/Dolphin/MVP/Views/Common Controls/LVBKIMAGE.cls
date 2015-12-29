"Filed out from Dolphin Smalltalk X6.2"!

Win32Structure subclass: #LVBKIMAGE
	instanceVariableNames: 'buf'
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
LVBKIMAGE guid: (GUID fromString: '{33FCCB1A-F5BA-4AE8-93AD-63D00B9AA869}')!
LVBKIMAGE comment: ''!
!LVBKIMAGE categoriesForClass!External-Data-Structured-Win32! !
!LVBKIMAGE methodsFor!

bitmap: aBitmapOrNil 
	buf := aBitmapOrNil.
	aBitmapOrNil notNil 
		ifTrue: 
			[self
				hbm: aBitmapOrNil asParameter;
				imageSource: LVBKIF_SOURCE_HBITMAP]
		ifFalse: [self imageSource: LVBKIF_SOURCE_NONE]!

cchImageMax: anObject 
	"Set the receiver's cchImageMax field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cchImageMax) put: anObject!

hbm
	"Answer the receiver's hbm field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hbm)) asExternalHandle!

hbm: anObject 
	"Set the receiver's hbm field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hbm) put: anObject!

imageSource: anInteger 
	self ulFlags: ((self ulFlags maskClear: LVBKIF_SOURCE_MASK) maskSet: anInteger)!

imageUrl: aString 
	buf := aString.
	self
		pszImage: aString;
		cchImageMax: aString size;
		imageSource: LVBKIF_SOURCE_URL!

isTiled
	^self ulFlags allMask: LVBKIF_STYLE_TILE!

isTiled: aBoolean 
	self ulFlags: (self ulFlags mask: LVBKIF_STYLE_TILE set: aBoolean)!

isWatermark
	^self ulFlags allMask: LVBKIF_TYPE_WATERMARK!

isWatermark: aBoolean
	self ulFlags: (self ulFlags mask: LVBKIF_TYPE_WATERMARK set: aBoolean)!

offset: aPoint 
	#deprecated.	"Use #offsetPercent: or #offsetTile:"
	self
		xOffsetPercent: aPoint x;
		yOffsetPercent: aPoint y!

offsetPercent: aPoint 
	"Set the position of the top-left corner of image in the background to be the specified
	absolute position, expressed as a percentage of the client area."

	self ulFlags: ((self ulFlags maskClear: LVBKIF_STYLE_MASK | LVBKIF_FLAG_TILEOFFSET) 
				maskSet: ##(LVBKIF_STYLE_NORMAL)).
	self
		xOffsetPercent: aPoint x;
		yOffsetPercent: aPoint y!

offsetTile: aPoint 
	self ulFlags: (self ulFlags mask: LVBKIF_FLAG_TILEOFFSET set: true).
	self
		xOffsetPercent: aPoint x;
		yOffsetPercent: aPoint y!

position: aPoint 
	"Set the position of the top-left corner of image in the background to be the specified
	absolute position, expressed in pixels."

	self 
		ulFlags: ((self ulFlags maskClear: LVBKIF_STYLE_MASK) maskSet: (aPoint = 0 
						ifTrue: [LVBKIF_STYLE_NORMAL]
						ifFalse: [##(LVBKIF_STYLE_TILE | LVBKIF_FLAG_TILEOFFSET)])).
	self offset: aPoint!

pszImage
	"Answer the receiver's pszImage field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszImage))!

pszImage: anObject 
	"Set the receiver's pszImage field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pszImage) put: anObject yourAddress!

ulFlags
	"Answer the receiver's ulFlags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

ulFlags: anObject 
	"Set the receiver's ulFlags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

xOffsetPercent
	"Answer the receiver's xOffsetPercent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #xOffsetPercent)!

xOffsetPercent: anObject 
	"Set the receiver's xOffsetPercent field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #xOffsetPercent) put: anObject!

yOffsetPercent
	"Answer the receiver's yOffsetPercent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #yOffsetPercent)!

yOffsetPercent: anObject 
	"Set the receiver's yOffsetPercent field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #yOffsetPercent) put: anObject! !
!LVBKIMAGE categoriesFor: #bitmap:!accessing!public! !
!LVBKIMAGE categoriesFor: #cchImageMax:!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #hbm!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #hbm:!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #imageSource:!accessing!private! !
!LVBKIMAGE categoriesFor: #imageUrl:!accessing!public! !
!LVBKIMAGE categoriesFor: #isTiled!public!testing! !
!LVBKIMAGE categoriesFor: #isTiled:!accessing!public! !
!LVBKIMAGE categoriesFor: #isWatermark!public!testing! !
!LVBKIMAGE categoriesFor: #isWatermark:!accessing!public! !
!LVBKIMAGE categoriesFor: #offset:!public! !
!LVBKIMAGE categoriesFor: #offsetPercent:!accessing!public! !
!LVBKIMAGE categoriesFor: #offsetTile:!public! !
!LVBKIMAGE categoriesFor: #position:!accessing!public! !
!LVBKIMAGE categoriesFor: #pszImage!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #pszImage:!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #ulFlags!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #ulFlags:!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #xOffsetPercent!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #xOffsetPercent:!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #yOffsetPercent!**compiled accessors**!public! !
!LVBKIMAGE categoriesFor: #yOffsetPercent:!**compiled accessors**!public! !

!LVBKIMAGE class methodsFor!

defineFields
	"Define the fields of the Win32 LVBKIMAGE structure
		self compileDefinition
	"

	self
		defineField: #ulFlags type: DWORDField new;
		defineField: #hbm type: HANDLEField new;
		defineField: #pszImage type: (PointerField type: String);
		defineField: #cchImageMax type: DWORDField writeOnly;
		defineField: #xOffsetPercent type: SDWORDField new;
		defineField: #yOffsetPercent type: SDWORDField new! !
!LVBKIMAGE class categoriesFor: #defineFields!initializing!public! !

