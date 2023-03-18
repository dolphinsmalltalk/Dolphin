"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.RegionInitializer
	subclass: #'Graphics.Gdiplus.RegionFromPathInitializer'
	instanceVariableNames: 'path'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionFromPathInitializer guid: (Core.GUID fromString: '{2e7c1bb2-37d2-4d8b-9135-3eb9ab2ed1bb}')!
Graphics.Gdiplus.RegionFromPathInitializer comment: ''!
!Graphics.Gdiplus.RegionFromPathInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateRegionPath: path asParameter region: gpHandle.
	^gpHandle!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore."

	^path isPersistent!

path: aPath
	path := aPath.
	^self!

printAttributesOn: aStream
	aStream
		nextPutAll: 'fromPath: ';
		print: path! !
!Graphics.Gdiplus.RegionFromPathInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
isPersistent!public!testing! !
path:!initializing!private! !
printAttributesOn:!attributes!printing!private! !
!

!Graphics.Gdiplus.RegionFromPathInitializer class methodsFor!

fromPath: aPath
	^self new path: aPath! !
!Graphics.Gdiplus.RegionFromPathInitializer class categoriesForMethods!
fromPath:!instance creation!public! !
!

