"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Brush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Brush guid: (Core.GUID fromString: '{9a229a16-873b-4102-946a-b33879a9b261}')!
Graphics.Gdiplus.Brush isNonInstantiable: true!
Graphics.Gdiplus.Brush comment: 'GdiplusBrush is an abstract class that defines an object used to paint the interior of graphics shapes, such as rectangles, ellipses, pies, polygons, strings, regions and paths.

'!
!Graphics.Gdiplus.Brush categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Brush methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteBrush: handle!

clone
	"Answer a copy of the receiver."

	| gpHandle |
	gpHandle := Handle new.
	GdiplusLibrary default gdipCloneBrush: self handle cloneBrush: gpHandle.
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself! !
!Graphics.Gdiplus.Brush categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.Brush categoriesFor: #clone!copying!public! !

!Graphics.Gdiplus.Brush class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Brush icon! !
!Graphics.Gdiplus.Brush class categoriesFor: #icon!constants!development!public! !

