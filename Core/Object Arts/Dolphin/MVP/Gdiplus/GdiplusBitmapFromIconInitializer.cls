"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusBitmapFromIconInitializer
	instanceVariableNames: 'icon'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromIconInitializer guid: (GUID fromString: '{C320278A-5152-4EDA-8A58-6911DE50CC40}')!
GdiplusBitmapFromIconInitializer comment: ''!
!GdiplusBitmapFromIconInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromIconInitializer methodsFor!

createHandle
	" Bitmap::FromHICON(
	    IN HICON hicon
	    )
	{
	    return new Bitmap(hicon);
	}"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateBitmapFromHICON: icon asParameter bitmap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'!

icon: anIcon
	icon := anIcon! !
!GdiplusBitmapFromIconInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusBitmapFromIconInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusBitmapFromIconInitializer categoriesFor: #icon:!accessing!public! !

!GdiplusBitmapFromIconInitializer class methodsFor!

icon: anIcon
	"Creates a Bitmap object based on an icon."

	^self new icon: anIcon! !
!GdiplusBitmapFromIconInitializer class categoriesFor: #icon:!instance creation!public! !

