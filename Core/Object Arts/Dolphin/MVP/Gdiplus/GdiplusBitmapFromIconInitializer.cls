"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusBitmapFromIconInitializer
	instanceVariableNames: 'icon'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBitmapFromIconInitializer guid: (GUID fromString: '{c320278a-5152-4eda-8a58-6911de50cc40}')!

GdiplusBitmapFromIconInitializer comment: ''!

!GdiplusBitmapFromIconInitializer categoriesForClass!Unclassified! !

!GdiplusBitmapFromIconInitializer methodsFor!

createHandle
	"Private -  Bitmap::FromHICON(
	    IN HICON hicon
	    )
	{
	    return new Bitmap(hicon);
	}"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateBitmapFromHICON: icon asParameter bitmap: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'!

icon: anIcon
	icon := anIcon! !

!GdiplusBitmapFromIconInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
icon:!initializing!private! !
!

!GdiplusBitmapFromIconInitializer class methodsFor!

icon: anIcon
	"Creates a Bitmap object based on an icon."

	^self new icon: anIcon! !

!GdiplusBitmapFromIconInitializer class categoriesForMethods!
icon:!instance creation!public! !
!

