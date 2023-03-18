"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BitmapInitializer
	subclass: #'Graphics.Gdiplus.BitmapFromIconInitializer'
	instanceVariableNames: 'icon'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromIconInitializer guid: (Core.GUID fromString: '{c320278a-5152-4eda-8a58-6911de50cc40}')!
Graphics.Gdiplus.BitmapFromIconInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromIconInitializer methodsFor!

= anObject
	^self == anObject or: [self species = anObject species and: [icon = anObject icon]]!

basicCreateHandle
	"Private -  Bitmap::FromHICON(
	    IN HICON hicon
	    )
	{
	    return new Bitmap(hicon);
	}"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateBitmapFromHICON: icon asParameter bitmap: gpHandle.
	^gpHandle!

hash
	^(self species hash + icon hash) hashMultiply!

icon
	^icon!

icon: anIcon
	icon := anIcon.
	^self!

printImage: aGdiplusBitmap on: aWriteStream
	aWriteStream
		nextPut: $(;
		print: aGdiplusBitmap class;
		nextPutAll: ' fromIcon: ';
		print: icon;
		nextPut: $)! !
!Graphics.Gdiplus.BitmapFromIconInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
hash!comparing!public! !
icon!accessing!private! !
icon:!initializing!private! !
printImage:on:!printing!public! !
!

!Graphics.Gdiplus.BitmapFromIconInitializer class methodsFor!

icon: anIcon
	"Creates a Bitmap object based on an icon."

	^self new icon: anIcon! !
!Graphics.Gdiplus.BitmapFromIconInitializer class categoriesForMethods!
icon:!instance creation!public! !
!

