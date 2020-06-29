"Filed out from Dolphin Smalltalk 7"!

StatusBarItemAbstract subclass: #StatusBarItem
	instanceVariableNames: 'getTextBlock getImageBlock reserved1'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
StatusBarItem guid: (GUID fromString: '{87b4c6e6-026e-11d3-9fd7-00a0cc3e4a32}')!
StatusBarItem comment: 'StatusItem is a class describing the standard items that can be held by a <StatusBar>. These can have both text and an image associated with them.

Instance Variables:
	getTextBlock	<monadicValuable> for mapping a list item to its display text.
	getImageBlock	<monadicValuable> for mapping a list item to an <integer> image index.
	imageManager	<IconImageManager>

'!
!StatusBarItem categoriesForClass!MVP-Views-Support! !
!StatusBarItem methodsFor!

defaultGetImageBlock
	"Private - Answer a default block to use to find out the image index of an object 
	that will be placed in the receiver. By default we assume icons can be used
	for images"

	^[:each | each iconImageIndex]!

defaultGetTextBlock
	"Private - Answer a default block to use to find out the children of an object
	that will be placed in the receiver"

	^Message selector: #displayString!

drawImageOn: aCanvas in: aRectangle 
	^(self getImageBlock ifNotNil: [:getImage | getImage value: model value]) 
		ifNotNil: 
			[:image | 
			(self imageManager imageListWithExtent: aRectangle extent) 
				draw: image
				on: aCanvas
				at: aRectangle origin.
			aRectangle width + (aCanvas textExtent: ' ') x]
		ifNil: [0]!

drawItem: aCanvas bounding: aRectangle 
	"Private - Draw the receiver's current model's value onto the <Canvas> argument."

	| textOffset imageRect minHeight imageHeight |
	(model isNil or: [model value isNil]) ifTrue: [^self].
	aCanvas save.
	aCanvas font: self parentView actualFont.
	"The image is drawn in one of the system icon sizes (the largest that will fit). It's
	possible that the status bar is too small to draw even a 16x16 icon (most likely it is less
	than 15 pixels high due to a design-time error. In this case draw a 16x16 icon and just let
	the system truncate it."
	minHeight := Icon smallExtent y.
	imageHeight := aRectangle height.
	imageHeight := imageHeight < minHeight 
				ifTrue: [minHeight]
				ifFalse: [imageHeight truncateTo: minHeight].
	imageRect := aRectangle origin extent: imageHeight.
	textOffset := 1 + (self drawImageOn: aCanvas in: imageRect).
	self drawTextOn: aCanvas offset: textOffset.
	aCanvas restore!

drawTextOn: aCanvas offset: anInteger
	| text |
	text := self getTextBlock ifNil: [''] ifNotNil: [:getText | getText value: model value].
	text isEmpty ifTrue: [^self].
	aCanvas
		backgroundMode: TRANSPARENT;
		formatText: text
			in: (self rectangle insetOriginBy: anInteger @ 0)
			flags: ##(DT_SINGLELINE | DT_VCENTER | DT_NOPREFIX)!

getImageBlock
	"Answer the <monadicValuable> to use to find out the image index of an object that will
	be placed in the receiver. The answer may be nil if no icon is required."

	^getImageBlock
!

getImageBlock: monad
	"Set the <monadicValuable> to be used to get the image index of an object that will
	be displayed in the receiver to the argument, monad. The block can also be set to nil if 
	no icon is required."

	getImageBlock := monad.
	self refreshContents
!

getText
	"Private - Answer the text for this item."

	| value getText |
	^(model isNil or: [(getText := self getTextBlock) isNil
			or: [(value := self model value) isNil]])
		ifTrue: ['']
		ifFalse: [getText value: value]!

getTextBlock
	"Answer the <monadicValuable> used to determine the text to display for an 
	object placed in the receiver."

	^getTextBlock

!

getTextBlock: monad
	"Set the <monadicValuable> used to determine the text to display for an object that will
	placed in the receiver to the argument, monad."

	getTextBlock := monad.
	self refreshContents
!

imageManager
	"Answer the imageManager which holds the icons."

	^IconImageManager current!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self getImageBlock: self defaultGetImageBlock.
	self getTextBlock: self defaultGetTextBlock.!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: (self parentView notNil ifTrue: [self name]);
		nextPut: $)! !
!StatusBarItem categoriesFor: #defaultGetImageBlock!adapters!constants!private! !
!StatusBarItem categoriesFor: #defaultGetTextBlock!adapters!constants!private! !
!StatusBarItem categoriesFor: #drawImageOn:in:!drawing!private! !
!StatusBarItem categoriesFor: #drawItem:bounding:!drawing!private! !
!StatusBarItem categoriesFor: #drawTextOn:offset:!drawing!private! !
!StatusBarItem categoriesFor: #getImageBlock!adapters!public! !
!StatusBarItem categoriesFor: #getImageBlock:!adapters!public! !
!StatusBarItem categoriesFor: #getText!private!updating! !
!StatusBarItem categoriesFor: #getTextBlock!adapters!public! !
!StatusBarItem categoriesFor: #getTextBlock:!adapters!public! !
!StatusBarItem categoriesFor: #imageManager!accessing!public! !
!StatusBarItem categoriesFor: #initialize!initializing!private! !
!StatusBarItem categoriesFor: #printOn:!development!printing!public! !

!StatusBarItem class methodsFor!

value: anObject 
	"#deprecated."

	^anObject iconImageIndex! !
!StatusBarItem class categoriesFor: #value:!evaluating!private! !

