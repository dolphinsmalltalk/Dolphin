"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MenuPainter
	instanceVariableNames: 'menu conflictingMnemonics conflictingAccelerators'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
MenuPainter guid: (GUID fromString: '{50ca5bf4-97c5-4fba-a59f-fb43f0a962f9}')!
MenuPainter isAbstract: true!
MenuPainter comment: ''!
!MenuPainter categoriesForClass!Kernel-Objects! !
!MenuPainter methodsFor!

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
	mns := IdentityDictionary new.
	conflictingMnemonics := IdentitySet new.
	menu itemsDo: 
			[:item | 
			| string index |
			string := item text.
			((index := string indexOf: $&) ~~ 0 and: [index < string size]) 
				ifTrue: 
					[| mnemonic |
					mnemonic := (string at: index + 1) asUppercase.
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

	| string firstTab |
	string := aMenuItem text.
	firstTab := string indexOf: Character tab.
	firstTab == 0 
		ifFalse: 
			["Any text after a tab is ignored"
			string := string copyFrom: 1 to: firstTab - 1].
	(conflictingMnemonics includes: aMenuItem) 
		ifTrue: 
			[self 
				paintSmudgeFor: string
				on: aCanvas
				in: aRectangle].
	aCanvas 
		formatText: string
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
	| smudgeOrigin rect smudgeExtent origin dtFlags text |
	rect := aRectangle asParameter.
	(aString includes: $&) ifFalse: [^rect].
	dtFlags := self drawTextFlags.
	text := aString asUtf16String.
	aCanvas
		formatText: text
		in: rect
		flags: dtFlags | DT_CALCRECT.
	origin := (dtFlags allMask: DT_CENTER)
				ifTrue: [rect center - (rect extent / 2) rounded]
				ifFalse: [aRectangle origin + (0 @ ((aRectangle height - rect height) / 2) rounded)].
	text := text readStream.
	smudgeOrigin := origin + ((aCanvas textExtent: (text upTo: $&)) x @ 0).
	smudgeExtent := aCanvas textExtent: (Utf16String with: text next).
	self paintSmudge: (smudgeOrigin extent: smudgeExtent) on: aCanvas.
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

widthOfItemAccelerator: aMenuItem using: aCanvas 
	| string tabIndex menuFont size oldFont |
	string := aMenuItem text.
	tabIndex := string indexOf: Character tab.
	tabIndex == 0 ifTrue: [^0].
	menuFont := self menuFont.
	aMenuItem isDefault 
		ifTrue: 
			[menuFont := menuFont copy.
			menuFont isBold: true].
	oldFont := aCanvas font: menuFont.
	size := 
			[string := string copyFrom: tabIndex + 1 to: string size.
			aCanvas textExtent: string] 
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
			[| string tabIndex |
			string := aMenuItem text copyWithout: $&.
			(tabIndex := string indexOf: Character tab) isZero ifTrue: [tabIndex := string size + 1].
			string := string copyFrom: 1 to: tabIndex - 1.
			aCanvas textExtent: string] 
					ensure: [aCanvas font: oldFont].
	^size x! !
!MenuPainter categoriesFor: #borderInset!constants!private! !
!MenuPainter categoriesFor: #calculateGeometry:!public!updating! !
!MenuPainter categoriesFor: #conflictingAccelerators:!accessing!public! !
!MenuPainter categoriesFor: #createDragImage:using:!painting!public! !
!MenuPainter categoriesFor: #drawArrawOn:in:!painting!private! !
!MenuPainter categoriesFor: #drawBulletOn:in:!painting!private! !
!MenuPainter categoriesFor: #drawCheckOn:in:!painting!private! !
!MenuPainter categoriesFor: #drawGlyph:on:in:!painting!private! !
!MenuPainter categoriesFor: #drawTextFlags!painting!private! !
!MenuPainter categoriesFor: #findMnemonicConflicts!helpers!private! !
!MenuPainter categoriesFor: #horizontalSpacer!constants!private! !
!MenuPainter categoriesFor: #imageExtent!constants!private! !
!MenuPainter categoriesFor: #imageMargin!constants!private! !
!MenuPainter categoriesFor: #initializeCanvas:!painting!private! !
!MenuPainter categoriesFor: #insertBefore:position:canvas:!public!testing! !
!MenuPainter categoriesFor: #itemHeight!constants!private! !
!MenuPainter categoriesFor: #itemRect:using:!helpers!public! !
!MenuPainter categoriesFor: #menu:!initializing!private! !
!MenuPainter categoriesFor: #menuColor!constants!private! !
!MenuPainter categoriesFor: #menuFont!constants!private! !
!MenuPainter categoriesFor: #menuTextColor!constants!private! !
!MenuPainter categoriesFor: #offsetForSubmenu:canvas:!helpers!public! !
!MenuPainter categoriesFor: #paint:on:in:!painting!private! !
!MenuPainter categoriesFor: #paintBackgroundOn:in:!painting!private! !
!MenuPainter categoriesFor: #paintEdgeOn:in:!painting!private! !
!MenuPainter categoriesFor: #paintItem:on:in:!painting!private! !
!MenuPainter categoriesFor: #paintItemImage:on:at:!painting!private! !
!MenuPainter categoriesFor: #paintItemsOn:selected:!painting!private! !
!MenuPainter categoriesFor: #paintItemText:on:in:!painting!private! !
!MenuPainter categoriesFor: #paintMenuOn:in:selected:!painting!public! !
!MenuPainter categoriesFor: #paintSelectedItem:on:in:!painting!private! !
!MenuPainter categoriesFor: #paintSeparatorOn:in:!painting!private! !
!MenuPainter categoriesFor: #paintSmudge:on:!painting!private! !
!MenuPainter categoriesFor: #paintSmudgeFor:on:in:!painting!private! !
!MenuPainter categoriesFor: #setHighlightColors:!painting!private! !
!MenuPainter categoriesFor: #widthOfItemAccelerator:using:!helpers!private! !
!MenuPainter categoriesFor: #widthOfItemText:using:!helpers!private! !

MenuPainter methodProtocol: #menuPainter attributes: #() selectors: #(#calculateGeometry: #conflictingAccelerators: #createDragImage:using: #insertBefore:position:canvas: #itemRect:using: #offsetForSubmenu:canvas: #paintMenuOn:in:selected:)!

!MenuPainter class methodsFor!

forMenu: aMenu 
	^(self new)
		menu: aMenu;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^Menu icon! !
!MenuPainter class categoriesFor: #forMenu:!public! !
!MenuPainter class categoriesFor: #icon!constants!public! !

