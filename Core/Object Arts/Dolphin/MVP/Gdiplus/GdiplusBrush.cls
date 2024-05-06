"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBrush guid: (GUID fromString: '{9a229a16-873b-4102-946a-b33879a9b261}')!

GdiplusBrush comment: 'GdiplusBrush is an abstract class that defines an object used to paint the interior of graphics shapes, such as rectangles, ellipses, pies, polygons, strings, regions and paths.

'!

!GdiplusBrush categoriesForClass!Unclassified! !

!GdiplusBrush methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteBrush: handle!

clone
	"Answer a copy of the receiver."

	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipCloneBrush: self handle cloneBrush: gpHandle) = Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipCloneBrush' with: status].
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself! !

!GdiplusBrush categoriesForMethods!
basicFree!private!realizing/unrealizing! !
clone!copying!public! !
!

!GdiplusBrush class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Brush icon! !

!GdiplusBrush class categoriesForMethods!
icon!constants!development!public! !
!

