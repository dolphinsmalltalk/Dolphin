"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.Ball'
	instanceVariableNames: 'position velocity icon'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.Ball guid: (Core.GUID fromString: '{09652d38-e87c-4cb5-b5fd-2d093fae268b}')!

UI.Examples.Ball comment: ''!

!UI.Examples.Ball methodsFor!

drawOn: aCanvas
	| image extent |
	image := self icon.
	extent := 48 @ 48.
	image
		alphaBlendOn: aCanvas
		at: (self position - (extent / 2)) truncated
		extent: extent
		from: Point.Zero
		extent: extent!

icon
	^icon isNil ifTrue: [self class icon] ifFalse: [icon]!

icon: anIcon 
	icon := anIcon asSharedBitmap: 48@48!

position
	^position!

position: anObject 
	position := anObject!

velocity
	^velocity!

velocity: anObject 
	velocity := anObject! !

!UI.Examples.Ball categoriesForMethods!
drawOn:!drawing!public! !
icon!accessing!public! !
icon:!accessing!private! !
position!accessing!public! !
position:!accessing!private! !
velocity!accessing!public! !
velocity:!accessing!private! !
!

!UI.Examples.Ball class methodsFor!

blueIcon
	^Locale icon!

greenIcon
	^##((TextTileIcon text: $\xE774 fontName: 'Segoe Fluent Icons')
		textcolor: Color darkGreen;
		yourself)!

icon
	^##(TextTileIcon text: $\x1F3B1 fontName: 'Segoe UI Emoji')
		margin: -1;
		yourself!

redIcon
	^##((TextTileIcon text: $\xE899 fontName: 'Segoe Fluent Icons')
		textcolor: Color crimson;
		yourself)!

yellowIcon
	^##((TextTileIcon text: $\x1F3B1 fontName: 'Segoe UI Emoji')
		textcolor: Color goldenrod;
		margin: -1;
		yourself)! !

!UI.Examples.Ball class categoriesForMethods!
blueIcon!constants!public! !
greenIcon!constants!public! !
icon!constants!public! !
redIcon!constants!public! !
yellowIcon!constants!public! !
!

