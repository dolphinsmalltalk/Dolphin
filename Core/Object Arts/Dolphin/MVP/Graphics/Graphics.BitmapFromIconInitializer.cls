"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.BitmapFromIconInitializer'
	instanceVariableNames: 'extent icon'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.BitmapFromIconInitializer guid: (Core.GUID fromString: '{cbd63799-b451-40d7-bd4e-a64a38e1860c}')!

Graphics.BitmapFromIconInitializer comment: ''!

!Graphics.BitmapFromIconInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent. Two Images loaded by identifier are equal if they are of the same species, and have the same id and are from the same resource modules."

	^self == anObject
		or: [self species == anObject species and: [icon = anObject icon and: [extent = anObject extent]]]!

createImage: aBitmap extent: aPoint
	"Answer the handle of a 32-bpp RGBA bitmap (i.e. with Alpha channel) of the same native type as that expected by<Bitmap> argument, which represents the best rendering of the receiver's <icon> at the extent specified by the <Point>, aPoint."

	| bmp iconSize |
	bmp := aBitmap class extent: aPoint depth: 32.
	"Use the services of an ImageList to get the correct sized icon automagically, and to provide an alpha channel even if the original icon had no more than a simple mask."
	#todo.	"If we could determine that the icon is 32-bit (with alpha) then we could just draw it directly with DrawIconEx, which would save rendering the icons into an image list at the desired extent."
	iconSize := Icon standardSizeFor: aPoint.
	(icon imageManager imageListWithExtent: iconSize)
		draw: icon imageIndex
		on: bmp hdc
		at: (aPoint - iconSize) // 2
		flags: ImageList.ILD_PRESERVEALPHA.
	^bmp detachHandle!

extent
	^extent!

extent: aPoint icon: anIcon
	icon := anIcon.
	extent := aPoint.
	^self!

hash
	"Answer the <integer> hash value for the receiver."

	^icon hash!

icon
	^icon!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^icon isPersistent!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: icon;
		nextPut: $);
		nextPutAll: ' asAlphaBitmap: ';
		print: extent! !

!Graphics.BitmapFromIconInitializer categoriesForMethods!
=!comparing!public! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:icon:!initializing!private! !
hash!comparing!public! !
icon!accessing!public! !
isPersistent!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.BitmapFromIconInitializer class methodsFor!

extent: aPoint icon: anIcon
	<primitive: 157>
	^self new
		extent: aPoint icon: anIcon;
		yourself! !

!Graphics.BitmapFromIconInitializer class categoriesForMethods!
extent:icon:!instance creation!public! !
!

