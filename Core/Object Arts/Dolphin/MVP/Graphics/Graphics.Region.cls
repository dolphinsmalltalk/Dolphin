"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.Region'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Region guid: (Core.GUID fromString: '{87b4c638-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Region comment: ''!

!Graphics.Region categoriesForClass!Graphics-Tools! !

!Graphics.Region methodsFor!

combine: aRegion mode: anInteger
	"Private - Answers a new region which is the combination of the receiver with aRegion
	using anInteger mode"

	| result |
	result := Region empty.
	Gdi32
		combineRgn: result asParameter
		hrgnSrc1: self asParameter
		hrgnSrc2: aRegion asParameter
		fnCombineMode: anInteger.
	^result!

containsPoint: aPoint
	"Answer whether aPoint is contained by the receiver"

	^(Gdi32
		ptInRegion: self asParameter
		x: aPoint x
		y: aPoint y) asBoolean!

createHandle
	^self shouldNotImplement!

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
	mechanism. Generally this ability corresponds to a useful implementation
	of #basicRealize"

	^false!

union: aRegion
	"Answers a new region which is the union of the receiver with aRegion"

	^self combine: aRegion mode: RGN_OR! !

!Graphics.Region categoriesForMethods!
combine:mode:!operations!private! !
containsPoint:!operations!public!testing! !
createHandle!private!realizing/unrealizing! !
exclude:!operations!public! !
intersection:!operations!public! !
isPersistent!private!testing! !
union:!operations!public! !
!

!Graphics.Region class methodsFor!

ellipse: aRectangle
	"Answer an elliptic region defined by aRectangle"

	^self fromOwnedHandle: (Gdi32 createEllipticRgnIndirect: aRectangle asParameter)!

empty
	"Answer an empty rectangular region"

	^self rectangle: Rectangle.Empty!

rectangle: aRectangle
	"Answer a rectangular region defined by aRectangle"

	^self fromOwnedHandle: (Gdi32 createRectRgnIndirect: aRectangle asParameter)! !

!Graphics.Region class categoriesForMethods!
ellipse:!instance creation!public! !
empty!instance creation!public! !
rectangle:!instance creation!public! !
!

