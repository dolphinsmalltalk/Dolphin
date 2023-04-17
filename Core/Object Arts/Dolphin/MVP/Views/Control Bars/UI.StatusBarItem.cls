"Filed out from Dolphin Smalltalk"!

UI.StatusBarItemAbstract
	subclass: #'UI.StatusBarItem'
	instanceVariableNames: 'getTextBlock getImageBlock getTipTextBlock'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StatusBarItem guid: (Core.GUID fromString: '{87b4c6e6-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StatusBarItem comment: '`StatusItem` is a class describing the standard items that can be held by a `StatusBar`. These can have both text and an image associated with them.

## Instance Variables:
  getTextBlock		`<monadicValuable>` for mapping a list item to its display text.
  getImageBlock	`<monadicValuable>` for mapping a list item to an <integer> image index.
  getTipTextBlock	`<monadicValuable>` for mapping a list item to its tool-tip text.
'!
!UI.StatusBarItem categoriesForClass!MVP-Views-Support! !
!UI.StatusBarItem methodsFor!

defaultGetTextBlock
	"Private - Answer a default block to use to find out the children of an object
	that will be placed in the receiver"

	^View defaultGetTextBlock!

drawImageOn: aCanvas in: aRectangle
	^self getImage
		ifNotNil: 
			[:image |
			(self imageManager imageListWithExtent: aRectangle extent)
				draw: image
				on: aCanvas
				at: aRectangle origin.
			aRectangle width + (self textWidth: ' ' on: aCanvas)]
		ifNil: [0]!

drawItem: aCanvas bounding: aRectangle
	"Private - Draw the receiver's current model's value onto the <Canvas> argument."

	| textOffset imageRect imageSize |
	(model isNil or: [model value isNil]) ifTrue: [^self].
	aCanvas save.
	aCanvas font: parentView actualFont.
	parentView forecolor ifNotNil: [:textcolor | aCanvas forecolor: textcolor].
	"The image is drawn in one of the system icon sizes (the largest that will fit). It's
	possible that the status bar is too small to draw even a 16x16 icon (most likely it is less
	than 15 pixels high due to a design-time error. In this case draw a 16x16 icon and just let
	the system truncate it."
	imageSize := self imageSizeIn: aRectangle.
	imageRect := aRectangle origin extent: imageSize.
	textOffset := 1 + (self drawImageOn: aCanvas in: imageRect).
	self drawTextOn: aCanvas offset: textOffset.
	aCanvas restore!

drawTextFlags
	^##(DT_SINGLELINE | DT_VCENTER | DT_NOPREFIX)!

drawTextOn: aCanvas offset: anInteger
	| text |
	text := self getText.
	text isEmpty ifTrue: [^self].
	aCanvas
		backgroundMode: TRANSPARENT;
		formatText: text
			in: (self rectangle insetOriginBy: anInteger @ 0)
			flags: self drawTextFlags!

getImage
	^self getImageBlock ifNotNil: [:getImage | getImage value: model value]!

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
	"Private - Answer the text for this item. Note that there is no default text if the getTextBlock is nil. This is for icon-only items."

	| value |
	^(getTextBlock isNil or: [model isNil or: [(value := self model value) isNil]])
		ifTrue: ['']
		ifFalse: [(getTextBlock value: value) displayString]!

getTextBlock
	"Answer the <monadicValuable> used to determine the text to display for an 
	object placed in the receiver."

	^getTextBlock

!

getTextBlock: monad
	"Set the <monadicValuable> used to determine the text to display for an object that will
	be placed in the receiver to the argument, monad."

	getTextBlock := monad.
	self refreshContents
!

getTipText
	"Private - Answer the tool-tip text to be used for this item when required (but see #toolTipText)."

	^getTipTextBlock isNil
		ifTrue: [super getTipText]
		ifFalse: 
			[| value |
			(model isNil or: [(value := self model value) isNil])
				ifTrue: ['']
				ifFalse: [(getTipTextBlock value: value) displayString]]!

getTipTextBlock
	^getTipTextBlock!

getTipTextBlock: aMonadicValuableOrNil
	"Set (or clear if the argument is nil) the <monadicValuable> used to calculate the tip text to display for the receiver. See StatusBar>>tipTextAt: for details of when tooltips should be shown for an item."

	getTipTextBlock := aMonadicValuableOrNil!

imageManager
	"Answer the imageManager which holds the icons."

	^IconImageManager current!

imageSizeIn: aRectangle
	| minImageSize imageSize |
	minImageSize := Icon smallExtent y.
	imageSize := aRectangle height.
	^imageSize < minImageSize ifTrue: [minImageSize] ifFalse: [imageSize truncateTo: minImageSize]!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self getImageBlock: View defaultGetImageBlock.
	self getTextBlock: self defaultGetTextBlock.!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: (parentView notNil ifTrue: [self name]);
		nextPut: $)!

textWidth: aString on: aCanvas
	^(aCanvas
		textExtent: aString
		width: 0
		flags: self drawTextFlags) x!

toolTipText
	"Private - Answer the tool-tip text for the receiver. Answer nil if none, in which case no tip is shown."

	"A tool-tip should be displayed when either:
		1. the item has only an icon (no text); or
		2. the item text is truncated due to the size of its pane; or
		3. the tip text is different from the item text.
	The first two cases are the default behaviour of the control as documented at https://docs.microsoft.com/en-us/windows/win32/controls/sb-settiptext.
	The final behaviour of displaying a tip when the text is different is a Dolphin specific enhancement that makes the tips useful in a wider range of scenarios."

	| text tipText |
	tipText := self getTipText.
	tipText isEmpty ifTrue: [^nil].
	text := self getText.
	tipText = text
		ifTrue: 
			[| rect canvas requiredWidth availableWidth |
			"May be case 2: Tip text is the same as item text, display if item text truncated"
			rect := self rectangle.
			canvas := parentView canvas.
			canvas font: parentView actualFont.
			requiredWidth := 1 + (self getImage
								ifNil: [self textWidth: text on: canvas]
								ifNotNil: [(self imageSizeIn: rect) + (self textWidth: ' ' , text on: canvas)]).
			canvas free.
			availableWidth := rect width - (self hasBorder
								ifTrue: 
									["Have to use a magic number for the width of the vertical separator that is drawn for any border as there doesn't appear to be a metric"
									2]
								ifFalse: [0]).
			availableWidth >= requiredWidth
				ifTrue: 
					["Not truncated, so we don't want to display a tip."
					^nil]].
	^tipText! !
!UI.StatusBarItem categoriesForMethods!
defaultGetTextBlock!adapters!constants!private! !
drawImageOn:in:!drawing!private! !
drawItem:bounding:!drawing!private! !
drawTextFlags!constants!drawing!private! !
drawTextOn:offset:!drawing!private! !
getImage!drawing!private! !
getImageBlock!adapters!public! !
getImageBlock:!adapters!public! !
getText!private!updating! !
getTextBlock!adapters!public! !
getTextBlock:!adapters!public! !
getTipText!private!updating! !
getTipTextBlock!accessing!public! !
getTipTextBlock:!accessing!public! !
imageManager!accessing!public! !
imageSizeIn:!helpers!private! !
initialize!initializing!private! !
printOn:!development!printing!public! !
textWidth:on:!helpers!private! !
toolTipText!enquiries!private! !
!

!UI.StatusBarItem class methodsFor!

value: anObject 
	Notification deprecated.
	^anObject iconImageIndex! !
!UI.StatusBarItem class categoriesForMethods!
value:!evaluating!private! !
!

