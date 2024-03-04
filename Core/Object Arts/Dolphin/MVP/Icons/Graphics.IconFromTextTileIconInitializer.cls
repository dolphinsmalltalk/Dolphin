"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.IconFromTextTileIconInitializer'
	instanceVariableNames: 'extent textTile'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus})
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.IconFromTextTileIconInitializer guid: (Core.GUID fromString: '{53a894b4-e429-4ab9-ae95-a2a1e56cb506}')!

Graphics.IconFromTextTileIconInitializer comment: ''!

!Graphics.IconFromTextTileIconInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent. Two Images loaded by identifier are equal if they are of the same species, and have the same id and are from the same resource modules."

	^self == anObject or: [self species == anObject species and: [textTile = anObject textTile]]!

createImage: anImage extent: aPoint
	| hIcon gdipBitmap |
	gdipBitmap := textTile bitmapWithExtent: aPoint.
	hIcon := Handle new.
	Gdip gdipCreateHICONFromBitmap: gdipBitmap asParameter hbmReturn: hIcon.
	gdipBitmap free.
	^hIcon!

extent
	^extent!

extent: aPoint
	extent := aPoint!

hash
	"Answer the <integer> hash value for the receiver."

	^textTile hash!

printImage: anImage on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		print: anImage class;
		nextPutAll: ' fromTextTile: ';
		print: textTile.
	extent = SystemMetrics default largeIconExtent
		ifFalse: 
			[aWriteStream
				nextPutAll: ' extent: ';
				print: extent]!

textTile
	^textTile!

textTile: aTextTileIcon
	textTile := aTextTileIcon! !

!Graphics.IconFromTextTileIconInitializer categoriesForMethods!
=!comparing!public! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:!accessing!public! !
hash!comparing!public! !
printImage:on:!printing!private! !
textTile!accessing!public! !
textTile:!initializing!private! !
!

!Graphics.IconFromTextTileIconInitializer class methodsFor!

extent: aPoint textTile: aTextTileIcon
	<primitive: 157>
	^self new
		extent: aPoint;
		textTile: aTextTileIcon;
		yourself! !

!Graphics.IconFromTextTileIconInitializer class categoriesForMethods!
extent:textTile:!public! !
!

