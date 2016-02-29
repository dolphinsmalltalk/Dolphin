"Filed out from Dolphin Smalltalk 7"!

View subclass: #MenuComposerView
	instanceVariableNames: 'selectionIndex conflictingAccelerators conflictingMnemonics'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
MenuComposerView guid: (GUID fromString: '{87B4C710-026E-11D3-9FD7-00A0CC3E4A32}')!
MenuComposerView comment: 'MenuComposerView is an abstract superclass for a <valueView> used to emulate a <Menu> in the <MenuComposer>.

Instance Variables:
	selectionIndex		<integer> holding the index of the currently selected menu item.
	conflictingAccelerators	<IdentitySet> of <CommandMenuItem>s that have conflicting accelerator keys.
	conflictingMnemonics	<IdentitySet> of <CommandMenuItem>s that have conflicting mnemonics.'!
!MenuComposerView categoriesForClass!Development!MVP-Views! !
!MenuComposerView methodsFor!

arena
	^self creationParentView!

borderInset
	"Private - Answer a Point indicating the inset at eah corner of the
	receiver filled by the border."

	^self subclassResponsibility!

conflictingAccelerators
	"Private - Answer a Set of the receivers menu items which have conflicting
	accelerator keys defined."

	^conflictingAccelerators!

conflictingAccelerators: menuItems
	"Private - Set the Set of menu items with conflicting accelerator keys."

	conflictingAccelerators := menuItems!

createDragImage: anInteger 
	| bitmap bmpCanvas rectangle rect |
	rectangle := self itemRect: anInteger.
	bitmap := Bitmap 
				compatible: self canvas
				width: rectangle width
				height: rectangle height.
	bmpCanvas := bitmap canvas.
	rect := Point zero extent: rectangle extent.
	bmpCanvas backgroundMode: TRANSPARENT.
	bmpCanvas font: self menuFont.
	bmpCanvas forecolor: self menuTextColor.
	bmpCanvas fillRectangle: rect color: self backcolor.
	self 
		paint: (self itemAtIndex: anInteger)
		on: bmpCanvas
		in: rect.
	^bitmap!

defaultWindowStyle
	"Private - Answer the default basic window creation style.
	If the view is later given a parent then WS_CHILD will be set."

	^super defaultWindowStyle | WS_CHILD!

drawArrowOn: aCanvas in: aRectangle 
	self 
		drawGlyph: DFCS_MENUARROW
		on: aCanvas
		in: aRectangle!

drawBulletOn: aCanvas in: aRectangle 
	"Private - Draw the menu bullet (radio-button) glyph on the specified <Canvas> within the specified
	<Rectangle."

	self 
		drawGlyph: DFCS_MENUBULLET
		on: aCanvas
		in: aRectangle!

drawCheckOn: aCanvas in: aRectangle 
	"Private - Draw the menu checkmark glyph on the specified <Canvas> within the specified <Rectangle."

	self 
		drawGlyph: DFCS_MENUCHECK
		on: aCanvas
		in: aRectangle!

drawGlyph: anInteger on: aCanvas in: aRectangle 
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

generateMnemonicConflicts
	"Private - Generate the set of menu items with conflicting mnemonic keys in the receiver's menu."

	| mns |
	mns := IdentityDictionary new.
	conflictingMnemonics := conflictingMnemonics class new.
	self menu itemsDo: 
			[:item | 
			| string index |
			string := item text.
			(index := string indexOf: $&) == 0 
				ifFalse: 
					[| mnemonic |
					mnemonic := (string at: index + 1) asUppercase.
					(mns includesKey: mnemonic) 
						ifTrue: 
							[conflictingMnemonics
								add: (mns at: mnemonic);
								add: item]
						ifFalse: [mns at: mnemonic put: item]]]!

hasSelection
	"Answer whether the receiver has an item selected."

	^self selectionOrNil notNil!

horizontalSpacer
	"Private - Answer a number of pixels used as a unit for separation between
	horizontal elements."

	^7!

imageExtent
	"Private - Answer the width and height of menu item images."

	^SystemMetrics current menuImageExtent!

indexOfItem: menuItem
	"Private - Answer the index of menuItem in the receivers model."

	^self menu items indexOf: menuItem!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	selectionIndex := 0.
	conflictingAccelerators := IdentitySet new.
	conflictingMnemonics := IdentitySet new.
	backcolor := self menuColor!

initializeCanvas: canvas
	"Private - Set up the <Canvas> argument for drawing the menu items."

	| foreColour |
	foreColour := self menuTextColor.
	canvas
		font: self menuFont;
		backcolor: self backcolor;
		pen: foreColour pen;
		brush: foreColour brush!

itemAt: position 
	"Private - Answer the menu item of the model which spatially coincides
	with position or 0 if there is none."

	^(1 to: self menu size) detect: [:itemIndex | (self itemRect: itemIndex) containsPoint: position]
		ifNone: [0]!

itemAtIndex: itemIndex
	"Private - Answer the menu item which is the index'd entry of the receivers menu."

	^self menu itemAt: itemIndex!

itemHeight
	"Private - Answer the height of a menu item as currently configured."

	^self subclassResponsibility!

itemRect: itemIndex
	"Private - Answer the Rectangle of the menu item relative to the
	receivers origin."

	^self subclassResponsibility!

menu
	"Answer the menu which the receiver is displaying."

	^self model value!

menuColor
	^self subclassResponsibility!

menuFont
	"Private - Answer the currently configured menu font."

	^SystemMetrics current menuFont!

menuTextColor
	^Color systemColor: COLOR_MENUTEXT!

onEraseRequired: aColorEvent
	"Handler for erase background. Note that we do not fill the background here,
	it is drawn in onPaintRequired: in a flicker reduction attempt."

	^1!

onInputMaskRequired: anEvent 
	"Handler for a WM_GETDLGCODE request from Windows."

	"Implementation Note: We need to request all keys in order to get WM_SYSCHAR messages for
	shortcut key navigation, which we then use for selecting the relevant command or sub-menu."

	^DLGC_WANTALLKEYS!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double click event."

	self hasSelection ifTrue: [
		self creationParentView presenter trigger: #actionPerformed with: self].
	^0!

onPaintRequired: aPaintEvent 
	self model isNil ifTrue: [^self].
	self arena hideDragCursor.
	
	[| canvas |
	canvas := aPaintEvent canvas.
	canvas save.
	
	[self initializeCanvas: canvas.
	canvas fillRectangle: self clientRectangle color: canvas backcolor.
	self paintEdgeOn: canvas.
	"We need transparent mode for the smudges"
	canvas backgroundMode: TRANSPARENT.
	self paintItemsOn: canvas] 
			ensure: [canvas restore]] 
			ensure: [self arena showDragCursor]!

originForSubmenu: aMenuItem
	"Private - Answer the position in the receivers parent view for
	which aMenuItems submenu should be opened at."

	^self subclassResponsibility!

paint: aMenuItem on: aCanvas in: aRectangle 
	"Private - Paint the menuItem on the supplied <Canvas> within the specified <Rectangle>."

	aMenuItem isDivider 
		ifTrue: [self paintSeparatorOn: aCanvas in: aRectangle]
		ifFalse: 
			[| oldFont |
			
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
					ensure: [oldFont notNil ifTrue: [(aCanvas font: oldFont) free]]]!

paintEdgeOn: aCanvas 
	"Private - Paint a suitable border for the receiver."

	^self!

paintItem: aMenuItem on: aCanvas in: aRectangle 
	^self subclassResponsibility!

paintItemImage: aMenuItem on: aCanvas at: aPoint 
	^aMenuItem image 
		ifNil: [false]
		ifNotNil: 
			[:image | 
			"The image has to be vertically centred, but other than that we can use the
			same image drawing routine that we use for the real menus."
			self menu 
				drawItemImage: image
				on: aCanvas
				at: aPoint + (0 @ ((self itemHeight - self imageExtent y) // 2))
				disabled: false.
			true]!

paintItemsOn: aCanvas 
	| menu |
	menu := self menu.
	1 to: menu size
		do: 
			[:i | 
			| each rect |
			each := menu itemAt: i.
			rect := self itemRect: i.
			(aCanvas isRectangleVisible: rect) 
				ifTrue: 
					[selectionIndex == i 
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
	"Text is vertically centred"
	aCanvas 
		formatText: string
		in: aRectangle
		flags: self drawTextFlags!

paintSelectedItem: aMenuItem on: aCanvas in: aRectangle 
	aCanvas save.
	
	[self setHighlightColors: aCanvas.
	aCanvas fillRectangle: aRectangle color: aCanvas backcolor.
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

paintSmudgeFor: string on: aCanvas in: aRectangle 
	| smudgeOrigin rect underlineIndex smudgeExtent origin dtFlags |
	underlineIndex := string indexOf: $&.
	rect := aRectangle asParameter.
	underlineIndex = 0 ifTrue: [^rect].
	dtFlags := self drawTextFlags.
	aCanvas 
		formatText: string
		in: rect
		flags: dtFlags | DT_CALCRECT.
	origin := (dtFlags allMask: DT_CENTER) 
				ifTrue: [rect center - (rect extent / 2) rounded]
				ifFalse: [aRectangle origin + (0 @ ((aRectangle height - rect height) / 2) rounded)].
	smudgeOrigin := origin + ((aCanvas textExtent: (string copyFrom: 1 to: underlineIndex - 1)) x @ 0).
	smudgeExtent := aCanvas textExtent: (String with: (string at: underlineIndex + 1)).
	self paintSmudge: (smudgeOrigin extent: smudgeExtent) on: aCanvas.
	^rect!

refreshContents
	"The model held by the associated presenter has been replaced"

	self menu notNil ifTrue: [self updateGeometry].
	self invalidateRect: nil erase: false!

selectionByIndex
	"Answer the index of the item currently selected or 0 if there
	is no selection."

	^selectionIndex!

selectionByIndex: index
	"Set the index of the selected item. This will not update the receivers
	on screen appearance."

	selectionIndex := index!

selectionOrNil
	"Answer the selected menu item of the receiver or nil if there is none."

	^selectionIndex isZero ifFalse: [
		self menu itemAt: selectionIndex]!

setHighlightColors: canvas 
	"Private - Set up the <Canvas> argument for drawing the highlighted item."

	| txtHighlight |
	txtHighlight := Color systemColor: COLOR_HIGHLIGHTTEXT.
	canvas
		backcolor: (Color systemColor: COLOR_MENUHILIGHT);
		forecolor: txtHighlight;
		pen: txtHighlight pen;
		brush: txtHighlight brush!

updateGeometry
	"Private - The contents of the receivers menu has changed. This could cause the view to
	resize, etc."

	^self subclassResponsibility!

widthOfItemAccelerator: aMenuItem 
	| string tabIndex menuFont size canvas |
	string := aMenuItem text.
	tabIndex := string indexOf: Character tab.
	tabIndex == 0 ifTrue: [^0].
	canvas := self canvas.
	menuFont := self menuFont.
	aMenuItem isDefault 
		ifTrue: 
			[menuFont := menuFont copy.
			menuFont isBold: true].
	canvas font: menuFont.
	string := string copyFrom: tabIndex + 1 to: string size.
	size := canvas textExtent: string.
	canvas free.
	^size x!

widthOfItemText: aMenuItem 
	"Private - Answer the width of the text part of menuItem in pixels."

	| size canvas string tabIndex menuFont |
	canvas := self canvas.
	menuFont := self menuFont.
	aMenuItem isDefault 
		ifTrue: 
			[menuFont := menuFont copy.
			menuFont isBold: true].
	canvas font: menuFont.
	string := aMenuItem text copyWithout: $&.
	(tabIndex := string indexOf: Character tab) isZero ifTrue: [tabIndex := string size + 1].
	string := string copyFrom: 1 to: tabIndex - 1.
	size := canvas textExtent: string.
	canvas free.
	^size x!

wmSysChar: message wParam: wParam lParam: lParam 
	"Private - Handles a WM_SYSCOMMAND message. From MSDN:
	The WM_SYSCHAR message is posted to the window with the keyboard focus when a WM_SYSKEYDOWN
	message is translated by the TranslateMessage function. It specifies the character code of a
	system character key that is, a character key that is pressed while the ALT key is down. "

	| char selected |
	char := (Character codePoint: wParam) asUppercase.
	selected := self menu items findFirst: 
					[:each | 
					| string index |
					string := each text.
					(index := string indexOf: $&) ~~ 0 and: 
							[| mnemonic |
							mnemonic := (string at: index + 1) asUppercase.
							mnemonic == char]].
	^selected == 0 
		ifFalse: 
			[self arena onItemIn: self selectedAtIndex: selected.
			0]! !
!MenuComposerView categoriesFor: #arena!accessing!private! !
!MenuComposerView categoriesFor: #borderInset!constants!private! !
!MenuComposerView categoriesFor: #conflictingAccelerators!accessing!private! !
!MenuComposerView categoriesFor: #conflictingAccelerators:!accessing!private! !
!MenuComposerView categoriesFor: #createDragImage:!private!tracking! !
!MenuComposerView categoriesFor: #defaultWindowStyle!constants!private! !
!MenuComposerView categoriesFor: #drawArrowOn:in:!painting!private! !
!MenuComposerView categoriesFor: #drawBulletOn:in:!painting!private! !
!MenuComposerView categoriesFor: #drawCheckOn:in:!painting!private! !
!MenuComposerView categoriesFor: #drawGlyph:on:in:!painting!private! !
!MenuComposerView categoriesFor: #drawTextFlags!painting!private! !
!MenuComposerView categoriesFor: #generateMnemonicConflicts!operations!private! !
!MenuComposerView categoriesFor: #hasSelection!public!testing! !
!MenuComposerView categoriesFor: #horizontalSpacer!constants!private! !
!MenuComposerView categoriesFor: #imageExtent!constants!private! !
!MenuComposerView categoriesFor: #indexOfItem:!private!searching! !
!MenuComposerView categoriesFor: #initialize!initializing!private! !
!MenuComposerView categoriesFor: #initializeCanvas:!painting!private! !
!MenuComposerView categoriesFor: #itemAt:!private!searching! !
!MenuComposerView categoriesFor: #itemAtIndex:!accessing!private! !
!MenuComposerView categoriesFor: #itemHeight!constants!private! !
!MenuComposerView categoriesFor: #itemRect:!accessing!private! !
!MenuComposerView categoriesFor: #menu!accessing!public! !
!MenuComposerView categoriesFor: #menuColor!private!tracking! !
!MenuComposerView categoriesFor: #menuFont!constants!private! !
!MenuComposerView categoriesFor: #menuTextColor!private!tracking! !
!MenuComposerView categoriesFor: #onEraseRequired:!event handling!painting!public! !
!MenuComposerView categoriesFor: #onInputMaskRequired:!event handling!public! !
!MenuComposerView categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!MenuComposerView categoriesFor: #onPaintRequired:!event handling!painting!public! !
!MenuComposerView categoriesFor: #originForSubmenu:!enquiries!private! !
!MenuComposerView categoriesFor: #paint:on:in:!painting!private! !
!MenuComposerView categoriesFor: #paintEdgeOn:!painting!private! !
!MenuComposerView categoriesFor: #paintItem:on:in:!painting!private! !
!MenuComposerView categoriesFor: #paintItemImage:on:at:!painting!private! !
!MenuComposerView categoriesFor: #paintItemsOn:!painting!private! !
!MenuComposerView categoriesFor: #paintItemText:on:in:!painting!private! !
!MenuComposerView categoriesFor: #paintSelectedItem:on:in:!event handling!painting!private! !
!MenuComposerView categoriesFor: #paintSeparatorOn:in:!painting!private! !
!MenuComposerView categoriesFor: #paintSmudge:on:!painting!private! !
!MenuComposerView categoriesFor: #paintSmudgeFor:on:in:!painting!private! !
!MenuComposerView categoriesFor: #refreshContents!public!updating! !
!MenuComposerView categoriesFor: #selectionByIndex!public!selection! !
!MenuComposerView categoriesFor: #selectionByIndex:!public!selection! !
!MenuComposerView categoriesFor: #selectionOrNil!public!selection! !
!MenuComposerView categoriesFor: #setHighlightColors:!painting!private! !
!MenuComposerView categoriesFor: #updateGeometry!private!updating! !
!MenuComposerView categoriesFor: #widthOfItemAccelerator:!accessing!private! !
!MenuComposerView categoriesFor: #widthOfItemText:!accessing!private! !
!MenuComposerView categoriesFor: #wmSysChar:wParam:lParam:!event handling-win32!private! !

!MenuComposerView class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class."

	^MenuComposer icon
!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #actionPerformed;
		yourself.
! !
!MenuComposerView class categoriesFor: #icon!constants!public! !
!MenuComposerView class categoriesFor: #publishedEventsOfInstances!development!events!public! !

