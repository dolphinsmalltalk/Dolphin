"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.CachedBitmapInitializer'
	instanceVariableNames: 'bitmap graphics'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.CachedBitmapInitializer guid: (Core.GUID fromString: '{615de21c-61b0-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.CachedBitmapInitializer comment: ''!
!Graphics.Gdiplus.CachedBitmapInitializer methodsFor!

= anObject
	^self == anObject or: 
			[self species = anObject species and: [bitmap = anObject bitmap and: [graphics = anObject graphics]]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateCachedBitmap: bitmap asParameter
		graphics: graphics asParameter
		cachedBitmap: gpHandle.
	^gpHandle!

bitmap
	^bitmap!

bitmap: aBitmap graphics: aGraphics
	bitmap := aBitmap.
	graphics := aGraphics.
	^self!

graphics
	^graphics!

hash
	^((self species hash + bitmap hash) hashMultiply + graphics hash) hashMultiply!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^false!

printAttributesOn: aStream
	aStream
		nextPutAll: 'bitmap: ';
		print: bitmap;
		nextPutAll: ' graphics: ';
		print: graphics! !
!Graphics.Gdiplus.CachedBitmapInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
bitmap!accessing!private! !
bitmap:graphics:!initializing!private! !
graphics!accessing!private! !
hash!comparing!public! !
isPersistent!public!testing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.CachedBitmapInitializer class methodsFor!

bitmap: aBitmap graphics: aGraphics
	^self new bitmap: aBitmap graphics: aGraphics!

cloneHandle: aHandle
	"Cannot be cloned"

	^self shouldNotImplement!

freeHandle: aHandle
	Gdip gdipDisposeImage: aHandle! !
!Graphics.Gdiplus.CachedBitmapInitializer class categoriesForMethods!
bitmap:graphics:!instance creation!public! !
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
!

