"Filed out from Dolphin Smalltalk"!

GraphicsTool subclass: #Region
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Region guid: (GUID fromString: '{87b4c638-026e-11d3-9fd7-00a0cc3e4a32}')!

Region comment: ''!

!Region categoriesForClass!Graphics-Tools! !

!Region methodsFor!

combine: aRegion mode: anInteger
	"Private - Answers a new region which is the combination of the receiver with aRegion
	using anInteger mode"

	| result |
	result := Region empty.
	GDILibrary default 
		combineRgn: result asParameter 
			hrgnSrc1: self asParameter 
			hrgnSrc2: aRegion asParameter 
			fnCombineMode: anInteger.
	^result!

containsPoint: aPoint
	"Answer whether aPoint is contained by the receiver"

	^(GDILibrary default ptInRegion: self asParameter x: aPoint x y: aPoint y) asBoolean
!

exclude: aRegion
	"Answers a new region which is the receiver with aRegion excluded"

	^self combine: aRegion mode: RGN_DIFF!

intersection: aRegion
	"Answers a new region which is the intersection of the receiver with aRegion"

	^self combine: aRegion mode: RGN_AND!

isPersistent
	"Private - Answer true if the receiver holds sufficient information such that
	it can recreate itself when the image is saved and restored. This is also
	an indication as to whether the receiver can be filed out/in using the STB
	mechanism. Generally this ability corresponds to a useful implemenation
	of #basicRealize"

	^false!

union: aRegion
	"Answers a new region which is the union of the receiver with aRegion"

	^self combine: aRegion mode: RGN_OR! !

!Region categoriesForMethods!
combine:mode:!operations!private! !
containsPoint:!operations!public!testing! !
exclude:!operations!public! !
intersection:!operations!public! !
isPersistent!private!testing! !
union:!operations!public! !
!

!Region class methodsFor!

ellipse: aRectangle
	"Answer an elliptic region defined by aRectangle"

	^self fromOwnedHandle:
		(GDILibrary default createEllipticRgnIndirect: aRectangle asParameter)!

empty
	"Answer an empty rectangular region"

	^self rectangle: (Rectangle origin: Point zero extent: Point zero)!

rectangle: aRectangle
	"Answer a rectangular region defined by aRectangle"

	^self fromOwnedHandle:
		(GDILibrary default createRectRgnIndirect: aRectangle asParameter)! !

!Region class categoriesForMethods!
ellipse:!instance creation!public! !
empty!instance creation!public! !
rectangle:!instance creation!public! !
!

