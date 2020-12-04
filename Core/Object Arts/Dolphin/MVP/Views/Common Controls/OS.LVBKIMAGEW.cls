"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.LVBKIMAGEW'
	instanceVariableNames: 'buf'
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cchImageMax' -> 16rC.
		'_OffsetOf_hbm' -> 16r4.
		'_OffsetOf_pszImage' -> 16r8.
		'_OffsetOf_ulFlags' -> 16r0.
		'_OffsetOf_xOffsetPercent' -> 16r10.
		'_OffsetOf_yOffsetPercent' -> 16r14
	}!
OS.LVBKIMAGEW guid: (Core.GUID fromString: '{33fccb1a-f5ba-4ae8-93ad-63d00b9aa869}')!
OS.LVBKIMAGEW comment: ''!
!OS.LVBKIMAGEW categoriesForClass!External-Data-Structured-Win32! !
!OS.LVBKIMAGEW methodsFor!

bitmap: aBitmapOrNil 
	buf := aBitmapOrNil.
	aBitmapOrNil notNil 
		ifTrue: 
			[self
				hbm: aBitmapOrNil asParameter;
				imageSource: LVBKIF_SOURCE_HBITMAP]
		ifFalse: [self imageSource: LVBKIF_SOURCE_NONE]!

cchImageMax: anInteger
	"Set the receiver's 'cchImageMax' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cchImageMax put: anInteger!

hbm
	"Answer the <ExternalHandle> value of the receiver's 'hbm' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbm) asExternalHandle!

hbm: anExternalHandle
	"Set the receiver's 'hbm' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbm put: anExternalHandle!

imageSource: anInteger 
	self ulFlags: ((self ulFlags maskClear: LVBKIF_SOURCE_MASK) maskSet: anInteger)!

imageUrl: aString 
	buf := aString asUtf16String.
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
	self
		xOffsetPercent: aPoint x;
		yOffsetPercent: aPoint y!

pszImage
	"Answer the <Utf16String> value of the receiver's 'pszImage' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszImage)!

pszImage: anUtf16String
	"Set the receiver's 'pszImage' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszImage put: anUtf16String yourAddress!

ulFlags
	"Answer the <Integer> value of the receiver's 'ulFlags' field."

	^bytes dwordAtOffset: _OffsetOf_ulFlags!

ulFlags: anInteger
	"Set the receiver's 'ulFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ulFlags put: anInteger!

xOffsetPercent
	"Answer the <Integer> value of the receiver's 'xOffsetPercent' field."

	^bytes sdwordAtOffset: _OffsetOf_xOffsetPercent!

xOffsetPercent: anInteger
	"Set the receiver's 'xOffsetPercent' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xOffsetPercent put: anInteger!

yOffsetPercent
	"Answer the <Integer> value of the receiver's 'yOffsetPercent' field."

	^bytes sdwordAtOffset: _OffsetOf_yOffsetPercent!

yOffsetPercent: anInteger
	"Set the receiver's 'yOffsetPercent' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yOffsetPercent put: anInteger! !
!OS.LVBKIMAGEW categoriesFor: #bitmap:!accessing!public! !
!OS.LVBKIMAGEW categoriesFor: #cchImageMax:!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #hbm!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #hbm:!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #imageSource:!accessing!private! !
!OS.LVBKIMAGEW categoriesFor: #imageUrl:!accessing!public! !
!OS.LVBKIMAGEW categoriesFor: #isTiled!public!testing! !
!OS.LVBKIMAGEW categoriesFor: #isTiled:!accessing!public! !
!OS.LVBKIMAGEW categoriesFor: #isWatermark!public!testing! !
!OS.LVBKIMAGEW categoriesFor: #isWatermark:!accessing!public! !
!OS.LVBKIMAGEW categoriesFor: #offsetPercent:!accessing!public! !
!OS.LVBKIMAGEW categoriesFor: #offsetTile:!public! !
!OS.LVBKIMAGEW categoriesFor: #position:!accessing!public! !
!OS.LVBKIMAGEW categoriesFor: #pszImage!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #pszImage:!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #ulFlags!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #ulFlags:!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #xOffsetPercent!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #xOffsetPercent:!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #yOffsetPercent!**compiled accessors**!public! !
!OS.LVBKIMAGEW categoriesFor: #yOffsetPercent:!**compiled accessors**!public! !

!OS.LVBKIMAGEW class methodsFor!

defineFields
	"Define the fields of the Win32 LVBKIMAGE structure
		self compileDefinition
	"

	self
		defineField: #ulFlags type: DWORDField new;
		defineField: #hbm type: HANDLEField new;
		defineField: #pszImage type: (PointerField type: Utf16String);
		defineField: #cchImageMax type: DWORDField writeOnly;
		defineField: #xOffsetPercent type: SDWORDField new;
		defineField: #yOffsetPercent type: SDWORDField new!

getFieldNames
	^#(#ulFlags #hbm #pszImage #cchImageMax #xOffsetPercent #yOffsetPercent)! !
!OS.LVBKIMAGEW class categoriesFor: #defineFields!public!template definition! !
!OS.LVBKIMAGEW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

