"Filed out from Dolphin Smalltalk X6"!

MenuComposerView subclass: #ContextMenuComposerView
	instanceVariableNames: 'itemWidth acceleratorOffset submenuOffset textOffset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ContextMenuComposerView guid: (GUID fromString: '{87B4C749-026E-11D3-9FD7-00A0CC3E4A32}')!
ContextMenuComposerView comment: 'ContextMenuComposerView is a <valueView> for displaying and editing a pop up <Menu>. The <valueModel> associated with a ContextMenuComposerView must always yield a <Menu> value when mapped through the installed type converter. In general, therefore, the type converter installed is usually a NullConverter. A ContextMenuComposerView will normally be used in conjunction with a <MenuComposer> dialog presenter.

Instance Variables:
	itemWidth		<integer> width of a standard menu item in pixels.
	acceleratorOffset	<integer> horizontal pixel offset at which to paint accelerator.
	submenuOffset	<integer> horizontal pixel offset at which to paint a sub menu.
	textOffset		<integer> horizontal pixel offset at which to paint menu item text.

'!
!ContextMenuComposerView categoriesForClass!Development!MVP-Views! !
!ContextMenuComposerView methodsFor!

borderInset
	"Private - Answer a <Rectangle> indicating the inset at each corner of the receiver filled by the
	border and any 3d edge."

	| extent |
	extent := SystemMetrics current borderExtent + SystemMetrics current edgeExtent.
	^extent corner: extent!

dividerHeight
	^SystemMetrics current menuDividerHeight!

insertBefore: index position: localPoint
	"Private - Answer whether an insertion at the <Point>, localPoint, should 
	place the new object before or after the item with the specified <integer> index."

	^localPoint y <= (self itemRect: index) centerY!

itemHeight
	"Private - Answer the height of a menu item as currently configured."

	^SystemMetrics current menuHeight!

itemRect: anInteger 
	"Private - Answer the <Rectangle> of the menu item relative to the receiver's origin."

	| y menu itemHeight dividerHeight item |
	menu := self menu.
	itemHeight := self itemHeight.
	dividerHeight := self dividerHeight.
	y := (1 to: anInteger - 1) inject: 0
				into: 
					[:past :index | 
					| each |
					each := menu itemAt: index.
					past + (each isDivider ifTrue: [dividerHeight] ifFalse: [itemHeight])].
	item := menu itemAt: anInteger.
	^0 @ y + self borderInset origin 
		extent: itemWidth @ (item isDivider ifTrue: [dividerHeight] ifFalse: [itemHeight])!

menuColor
	^Color systemColor: COLOR_MENU!

originForSubmenu: itemIndex 
	"Private - Answer the position in the receivers parent view at
	which aMenuItems submenu should be opened."

	^self position + (self itemRect: itemIndex) topRight - self borderInset origin!

paintEdgeOn: aCanvas 
	"Private - Paint the receiver's 3-d shadow border."

	SystemMetrics current hasFlatMenus 
		ifTrue: 
			[| extent cx cy oldPen |
			oldPen := aCanvas pen.
			extent := self extent.
			cx := extent x.
			cy := extent y.
			aCanvas
				pen: Color shadow3d pen;
				lineFrom: (cx - 1) @ 0 to: 0 @ 0;
				lineTo: 0 @ (cy - 1);
				lineTo: cx @ cy - 1;
				lineTo: (cx - 1) @ 0.
			aCanvas pen: oldPen]
		ifFalse: 
			[UserLibrary default 
				drawEdge: aCanvas asParameter
				qrc: self clientRectangle asParameter
				edge: EDGE_RAISED
				grfFlags: BF_RECT]!

paintItem: aMenuItem on: aCanvas in: aRectangle 
	| aPoint offset |
	aPoint := aRectangle origin.
	offset := self menu hasSharedImageColumn ifTrue: [0] ifFalse: [self imageExtent x].
	self 
		paintItemImage: aMenuItem
		on: aCanvas
		at: aPoint + (offset @ 1).
	self 
		paintItemText: aMenuItem
		on: aCanvas
		in: (aRectangle insetOriginBy: textOffset @ 1).
	self 
		paintItemAccelerator: aMenuItem
		on: aCanvas
		in: (aRectangle insetOriginBy: acceleratorOffset @ 1).
	aMenuItem size = 0 
		ifFalse: [self drawArrowOn: aCanvas in: (aRectangle insetOriginBy: submenuOffset @ 0)]!

paintItemAccelerator: aMenuItem on: aCanvas in: aRectangle 
	"Private - Paint the accelerator key at origin."

	| keyCode text |
	keyCode := aMenuItem acceleratorKey.
	keyCode isNull ifTrue: [^self].
	text := AcceleratorTable keyStringFromCode: keyCode.
	text isEmpty ifTrue: [^self].
	(self conflictingAccelerators includes: aMenuItem) 
		ifTrue: [self paintSmudge: (aRectangle extent: (aCanvas textExtent: text)) on: aCanvas].
	aCanvas 
		formatText: text
		in: aRectangle
		flags: self drawTextFlags!

paintSeparatorOn: aCanvas in: aRectangle 
	"Private - Paint a separator on origin."

	UserLibrary default 
		drawEdge: aCanvas asParameter
		qrc: (RECT 
				left: aRectangle left + 1
				top: aRectangle centerY
				right: aRectangle right - 1
				bottom: aRectangle bottom)
		edge: EDGE_ETCHED
		grfFlags: BF_TOP!

updateGeometry
	| menu items menuButtonWidth |
	menu := self menu.
	items := menu items.
	menuButtonWidth := self imageExtent x.
	textOffset := menuButtonWidth + SystemMetrics current menuImageTextGap.
	menu hasSharedImageColumn 
		ifFalse: 
			[(items anySatisfy: [:each | each image notNil]) 
				ifTrue: [textOffset := textOffset + menuButtonWidth]].
	acceleratorOffset := textOffset + self horizontalSpacer 
				+ (items inject: 0 into: [:max :each | max max: (self widthOfItemText: each)]).
	submenuOffset := acceleratorOffset 
				+ (items inject: 0 into: [:max :each | max max: (self widthOfItemAccelerator: each)]).
	"Note that even when the checkmark column is turned off altogether, that Windows allows for
	the width of the check mark column to the right hand side. This makes for better symmetry
	when the checkmark column is present, but is a cosmetic bug when the checkmark column is
	disabled. Partly because of that we don't support the no-checkmark mode."
	itemWidth := submenuOffset + menuButtonWidth!

updateMenu
	"The contents of the receivers menu has changed. This could cause the view to resize, etc."

	| last |
	super updateMenu.
	self updateGeometry.
	last := self itemRect: self menu size.
	self extent: last bottomRight + self borderInset corner! !
!ContextMenuComposerView categoriesFor: #borderInset!constants!private! !
!ContextMenuComposerView categoriesFor: #dividerHeight!accessing!private! !
!ContextMenuComposerView categoriesFor: #insertBefore:position:!private!testing! !
!ContextMenuComposerView categoriesFor: #itemHeight!constants!private! !
!ContextMenuComposerView categoriesFor: #itemRect:!accessing!private! !
!ContextMenuComposerView categoriesFor: #menuColor!private!tracking! !
!ContextMenuComposerView categoriesFor: #originForSubmenu:!accessing!public! !
!ContextMenuComposerView categoriesFor: #paintEdgeOn:!painting!private! !
!ContextMenuComposerView categoriesFor: #paintItem:on:in:!painting!private! !
!ContextMenuComposerView categoriesFor: #paintItemAccelerator:on:in:!painting!private! !
!ContextMenuComposerView categoriesFor: #paintSeparatorOn:in:!painting!private! !
!ContextMenuComposerView categoriesFor: #updateGeometry!private!updating! !
!ContextMenuComposerView categoriesFor: #updateMenu!public!updating! !

