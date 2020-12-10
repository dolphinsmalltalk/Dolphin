"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.MenuPainter'
	instanceVariableNames: 'menu conflictingMnemonics conflictingAccelerators'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MenuPainter guid: (Core.GUID fromString: '{50ca5bf4-97c5-4fba-a59f-fb43f0a962f9}')!
Tools.MenuPainter isNonInstantiable: true!
Tools.MenuPainter comment: ''!
!Tools.MenuPainter categoriesForClass!Kernel-Objects! !
!Tools.MenuPainter methodsFor!

borderInset
	"Private - Answer a Point indicating the inset at eah corner of the
	receiver filled by the border."

	^self subclassResponsibility!

calculateGeometry: aCanvas 
	"Calculate the extent required to render the receiver's menu on the specified
	<Canvas>."

	^self subclassResponsibility!

conflictingAccelerators: aCollection 
	conflictingAccelerators := aCollection!

createDragImage: anInteger using: aCanvas 
	| bitmap rectangle bmpCanvas extent |
	rectangle := self itemRect: anInteger using: aCanvas.
	extent := rectangle extent.
	bitmap := DIBSection 
				compatible: aCanvas
				width: extent x
				height: extent y.
	bmpCanvas := bitmap canvas.
	bmpCanvas save.
	
	[| rect |
	rect := Point zero extent: extent.
	self initializeCanvas: bmpCanvas.
	self
		paintBackgroundOn: bmpCanvas in: rect;
		paint: (menu itemAt: anInteger)
			on: bmpCanvas
			in: rect] 
			ensure: [bmpCanvas restore].
	bitmap freeDC.
	^bitmap!

drawArrawOn: aCanvas in: aRectangle 
	self 
		drawGlyph: aRectangle
		on: aCanvas
		in: DFCS_MENUARROW!

drawBulletOn: aCanvas in: aRectangle 
	"Private - Draw the menu bullet (radio-button) glyph on the specified <Canvas> within the
	specified <Rectangle."

	self 
		drawGlyph: aRectangle
		on: aCanvas
		in: DFCS_MENUBULLET!

drawCheckOn: aCanvas in: aRectangle 
	"Private - Draw the menu checkmark glyph on the specified <Canvas> within the specified
	<Rectangle."

	self 
		drawGlyph: aRectangle
		on: aCanvas
		in: DFCS_MENUCHECK!

drawGlyph: aRectangle on: aCanvas in: anInteger 
	"Implementation Note: DrawFrameControl draws a black on white mask bitmap on the destination
	context. We convert this to the correct colours by using an intermediate mono bitmap, which,
	when blt'd onto a colour bitmap has white pixels translated to the destination's background
	colour, and black pixels translated to its foreground colour, hey presto!!"

	| mono rect extent |
	extent := aRectangle extent.
	mono := Bitmap 
				width: extent x
				height: extent y
				depth: 1.
	rect := 0 @ 0 extent: extent.
	UserLibrary default 
		drawFrameControl: mono canvas asParameter
		lprc: rect asParameter
		uType: DFC_MENU
		uState: anInteger.
	aCanvas 
		bitBlt: mono canvas
		rectangle: rect
		to: aRectangle origin
		rop: SRCCOPY.
	mono free!

drawTextFlags
	^##(DT_SINGLELINE | DT_VCENTER)!

findMnemonicConflicts
	"Private - Find the set of menu items with conflicting mnemonic keys in the receiver's menu."

	| mns |
	mns := LookupTable new.
	conflictingMnemonics := IdentitySet new.
	menu itemsDo: 
			[:item |
			| part |
			part := (self splitMenuText: item text) second.
			part isEmpty
				ifFalse: 
					[| mnemonic |
					mnemonic := part first asUppercase.
					(mns includesKey: mnemonic)
						ifTrue: 
							[conflictingMnemonics
								add: (mns at: mnemonic);
								add: item]
						ifFalse: [mns at: mnemonic put: item]]]!

horizontalSpacer
	"Private - Answer a number of pixels used as a unit for separation between
	horizontal elements."

	^7!

imageExtent
	"Private - Answer the width and height of menu item images."

	^SystemMetrics current menuImageExtent!

imageMargin
	^2!

initializeCanvas: canvas 
	"Private - Set up the <Canvas> argument for drawing the menu items."

	| foreColour |
	foreColour := self menuTextColor.
	canvas
		font: self menuFont;
		backcolor: self menuColor;
		pen: foreColour pen;
		brush: foreColour brush!

insertBefore: anInteger position: aPoint canvas: aCanvas 
	"Answer whether an insertion at the <Point>, aPoint, should 
	place the new object before or after the item with the specified <integer> index."

	^self subclassResponsibility!

itemHeight
	"Private - Answer the height of a menu item as currently configured."

	^self subclassResponsibility!

itemRect: anInteger using: aCanvas 
	"Answer the <Rectangle> of the indexed menu item relative to the receiver's origin."

	^self subclassResponsibility!

menu: aMenu 
	menu := aMenu.
	self findMnemonicConflicts.
	conflictingAccelerators := IdentitySet new!

menuColor
	^self subclassResponsibility!

menuFont
	"Private - Answer the currently configured menu font."

	^SystemMetrics current menuFont!

menuTextColor
	^Color menuText!

offsetForSubmenu: anInteger canvas: aCanvas 
	^self subclassResponsibility!

paint: aMenuItem on: aCanvas in: aRectangle 
	"Private - Paint the menuItem on the supplied <Canvas> within the specified <Rectangle>."

	| oldFont |
	aMenuItem isDivider 
		ifTrue: 
			[self paintSeparatorOn: aCanvas in: aRectangle.
			^self].
	
	[aMenuItem isDefault 
		ifTrue: 
			[| menuFont |
			menuFont := self menuFont copy.
			menuFont isBold: true.
			oldFont := aCanvas font: menuFont].
	self 
		paintItem: aMenuItem
		on: aCanvas
		in: aRectangle] 
			ensure: [oldFont notNil ifTrue: [aCanvas font: oldFont]]!

paintBackgroundOn: aCanvas in: aRectangle 
	aCanvas fillRectangle: aRectangle color: aCanvas backcolor!

paintEdgeOn: aCanvas in: aRectangle 
	"Private - Paint the receiver's 3-d shadow border."

	UserLibrary default 
		drawEdge: aCanvas asParameter
		qrc: aRectangle asParameter
		edge: EDGE_RAISED
		grfFlags: BF_RECT!

paintItem: aMenuItem on: aCanvas in: aRectangle 
	^self subclassResponsibility!

paintItemImage: aMenuItem on: aCanvas at: aPoint 
	"Private - If the menu item has an icon, paint it and answer true. Else answer false."

	aMenuItem image 
		ifNil: 
			[aMenuItem isRadioButtonStyle ifFalse: [^false].
			self drawBulletOn: aCanvas
				in: ((aPoint extent: self imageExtent) insetBy: 0 @ ((self itemHeight - self imageExtent y) // 2))]
		ifNotNil: 
			[:image | 
			| imageManager |
			imageManager := menu imageManager.
			(imageManager imageListWithExtent: self imageExtent) 
				draw: (imageManager indexOfImage: image)
				on: aCanvas
				at: aPoint + (0 @ ((self itemHeight - self imageExtent y) // 2))].
	^true!

paintItemsOn: aCanvas selected: anInteger 
	1 to: menu size
		do: 
			[:i | 
			| each rect |
			each := menu itemAt: i.
			rect := self itemRect: i using: aCanvas.
			(aCanvas isRectangleVisible: rect) 
				ifTrue: 
					[i == anInteger 
						ifTrue: 
							[self 
								paintSelectedItem: each
								on: aCanvas
								in: rect]
						ifFalse: 
							[self 
								paint: each
								on: aCanvas
								in: rect]]]!

paintItemText: aMenuItem on: aCanvas in: aRectangle
	"Private - Paint the menu items text at the specified position."

	| text firstTab |
	text := aMenuItem text.
	firstTab := text indexOf: Character tab.
	firstTab == 0
		ifFalse: 
			["Any text after a tab is ignored"
			text := text copyFrom: 1 to: firstTab - 1].
	(conflictingMnemonics includes: aMenuItem)
		ifTrue: 
			[self
				paintSmudgeFor: text
				on: aCanvas
				in: aRectangle].
	aCanvas
		formatText: text
		in: aRectangle
		flags: self drawTextFlags!

paintMenuOn: aCanvas in: aRectangle selected: anInteger 
	aCanvas save.
	
	[self initializeCanvas: aCanvas.
	self paintBackgroundOn: aCanvas in: aRectangle.
	self paintEdgeOn: aCanvas in: aRectangle.
	"We need transparent mode for the smudges"
	aCanvas backgroundMode: TRANSPARENT.
	self paintItemsOn: aCanvas selected: anInteger] 
			ensure: [aCanvas restore]!

paintSelectedItem: aMenuItem on: aCanvas in: aRectangle 
	aCanvas save.
	
	[self setHighlightColors: aCanvas.
	self paintBackgroundOn: aCanvas in: aRectangle.
	aCanvas backgroundMode: TRANSPARENT.
	self 
		paint: aMenuItem
		on: aCanvas
		in: aRectangle] 
			ensure: [aCanvas restore]!

paintSeparatorOn: aCanvas in: aRectangle 
	^self subclassResponsibility!

paintSmudge: aRectangle on: aCanvas 
	| oldPen smudge |
	smudge := aRectangle leftCenter.
	oldPen := aCanvas pen.
	aCanvas
		pen: (Pen 
					withStyle: PS_SOLID
					width: aRectangle height
					color: Color red);
		lineFrom: smudge to: smudge + (aRectangle width @ 0);
		pen: oldPen!

paintSmudgeFor: aString on: aCanvas in: aRectangle
	| parts rect mnemonic smudgeOrigin origin text |
	text := aString asUtf16String.
	parts := self splitMenuText: text.
	mnemonic := parts second.
	mnemonic isEmpty ifTrue: [^self].
	rect := aRectangle asParameter.
	aCanvas
		formatText: text
		in: rect
		flags: (self drawTextFlags bitOr: DT_CALCRECT).
	origin := (self drawTextFlags allMask: DT_CENTER)
				ifTrue: [rect center - (rect extent / 2) rounded]
				ifFalse: [aRectangle origin + (0 @ ((aRectangle height - rect height) / 2) rounded)].
	smudgeOrigin := origin
				+ ((aCanvas
						textExtent: parts first
						width: 0
						flags: self drawTextFlags) x @ 0).
	self
		paintSmudge: (smudgeOrigin extent: (aCanvas
						textExtent: mnemonic
						width: 0
						flags: DT_SINGLELINE))
		on: aCanvas.
	^rect!

setHighlightColors: canvas
	"Private - Set up the <Canvas> argument for drawing the highlighted item."

	| txtHighlight |
	txtHighlight := Color named: #highlightText.
	canvas
		backcolor: Color menuHilight;
		forecolor: txtHighlight;
		pen: txtHighlight pen;
		brush: txtHighlight brush!

splitMenuText: aString
	"Private - Split the menu text into 3 components; the text before the mnemonic, the mnemonic character, and the text after the mnemonic."

	| len index stream |
	len := aString size.
	index := 1.
	
	[index := aString
				nextIndexOf: $&
				from: index
				to: len.
	(index == 0 or: [index == len]) ifTrue: [^{aString. ''. ''}].
	(aString at: index + 1) == $&]
			whileTrue: [index := index + 2].
	stream := aString readStream.
	^{stream basicNext: index - 1.
		stream
			next;
			next: 1.
		stream upToEnd}!

widthOfItemAccelerator: aMenuItem using: aCanvas
	| text tabIndex menuFont size oldFont |
	text := aMenuItem text.
	tabIndex := text indexOf: Character tab.
	tabIndex == 0 ifTrue: [^0].
	menuFont := self menuFont.
	aMenuItem isDefault
		ifTrue: 
			[menuFont := menuFont copy.
			menuFont isBold: true].
	oldFont := aCanvas font: menuFont.
	size := 
			[text := text copyFrom: tabIndex + 1 to: text size.
			aCanvas
				textExtent: text
				width: 0
				flags: self drawTextFlags | DT_NOPREFIX]
					ensure: [aCanvas font: oldFont].
	^size x!

widthOfItemText: aMenuItem using: aCanvas
	"Private - Answer the width of the text part of menuItem in pixels."

	| size menuFont oldFont |
	menuFont := self menuFont.
	aMenuItem isDefault
		ifTrue: 
			[menuFont := menuFont copy.
			menuFont isBold: true].
	oldFont := aCanvas font: menuFont.
	size := 
			[| text |
			text := aMenuItem text upTo: Character tab.
			aCanvas
				textExtent: text
				width: 0
				flags: self drawTextFlags]
					ensure: [aCanvas font: oldFont].
	^size x! !
!Tools.MenuPainter categoriesFor: #borderInset!constants!private! !
!Tools.MenuPainter categoriesFor: #calculateGeometry:!public!updating! !
!Tools.MenuPainter categoriesFor: #conflictingAccelerators:!accessing!public! !
!Tools.MenuPainter categoriesFor: #createDragImage:using:!painting!public! !
!Tools.MenuPainter categoriesFor: #drawArrawOn:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #drawBulletOn:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #drawCheckOn:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #drawGlyph:on:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #drawTextFlags!painting!private! !
!Tools.MenuPainter categoriesFor: #findMnemonicConflicts!helpers!private! !
!Tools.MenuPainter categoriesFor: #horizontalSpacer!constants!private! !
!Tools.MenuPainter categoriesFor: #imageExtent!constants!private! !
!Tools.MenuPainter categoriesFor: #imageMargin!constants!private! !
!Tools.MenuPainter categoriesFor: #initializeCanvas:!painting!private! !
!Tools.MenuPainter categoriesFor: #insertBefore:position:canvas:!public!testing! !
!Tools.MenuPainter categoriesFor: #itemHeight!constants!private! !
!Tools.MenuPainter categoriesFor: #itemRect:using:!helpers!public! !
!Tools.MenuPainter categoriesFor: #menu:!initializing!private! !
!Tools.MenuPainter categoriesFor: #menuColor!constants!private! !
!Tools.MenuPainter categoriesFor: #menuFont!constants!private! !
!Tools.MenuPainter categoriesFor: #menuTextColor!constants!private! !
!Tools.MenuPainter categoriesFor: #offsetForSubmenu:canvas:!helpers!public! !
!Tools.MenuPainter categoriesFor: #paint:on:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintBackgroundOn:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintEdgeOn:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintItem:on:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintItemImage:on:at:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintItemsOn:selected:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintItemText:on:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintMenuOn:in:selected:!painting!public! !
!Tools.MenuPainter categoriesFor: #paintSelectedItem:on:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintSeparatorOn:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintSmudge:on:!painting!private! !
!Tools.MenuPainter categoriesFor: #paintSmudgeFor:on:in:!painting!private! !
!Tools.MenuPainter categoriesFor: #setHighlightColors:!painting!private! !
!Tools.MenuPainter categoriesFor: #splitMenuText:!helpers!private! !
!Tools.MenuPainter categoriesFor: #widthOfItemAccelerator:using:!helpers!private! !
!Tools.MenuPainter categoriesFor: #widthOfItemText:using:!helpers!private! !

Tools.MenuPainter methodProtocol: #menuPainter attributes: #() selectors: #(#calculateGeometry: #conflictingAccelerators: #createDragImage:using: #insertBefore:position:canvas: #itemRect:using: #offsetForSubmenu:canvas: #paintMenuOn:in:selected:)!

!Tools.MenuPainter class methodsFor!

forMenu: aMenu 
	^(self new)
		menu: aMenu;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^Menu icon! !
!Tools.MenuPainter class categoriesFor: #forMenu:!public! !
!Tools.MenuPainter class categoriesFor: #icon!constants!public! !

