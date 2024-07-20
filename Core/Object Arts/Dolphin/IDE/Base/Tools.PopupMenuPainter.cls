"Filed out from Dolphin Smalltalk"!

Tools.MenuPainter
	subclass: #'Tools.PopupMenuPainter'
	instanceVariableNames: 'itemWidth textOffset submenuOffset acceleratorOffset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.PopupMenuPainter guid: (Core.GUID fromString: '{bebdf8c9-6967-41d3-92af-046ec7b3bff7}')!

Tools.PopupMenuPainter comment: ''!

!Tools.PopupMenuPainter categoriesForClass!Kernel-Objects! !

!Tools.PopupMenuPainter methodsFor!

borderInset
	"Private - Answer a <Rectangle> indicating the inset at each corner of the receiver filled by the
	border and any 3d edge."

	| extent metrics |
	metrics := self metrics.
	extent := metrics borderExtent + metrics edgeExtent.
	^extent corner: extent!

calculateGeometry: aCanvas 
	| last items imageWidth |
	items := menu items.
	textOffset := self gutterWidth.
	imageWidth := self imageExtent x.
	menu hasSharedImageColumn 
		ifFalse: 
			[(items anySatisfy: [:each | each image notNil]) ifTrue: [textOffset := textOffset + imageWidth]].
	acceleratorOffset := textOffset + self metrics menuTextAcceleratorGap 
				+ (items inject: 0 into: [:max :each | max max: (self widthOfItemText: each using: aCanvas)]).
	submenuOffset := acceleratorOffset 
				+ (items inject: 0 into: [:max :each | max max: (self widthOfItemAccelerator: each using: aCanvas)]).
	itemWidth := submenuOffset + imageWidth + (self imageMargin * 2).
	last := self itemRect: menu size using: aCanvas.
	^last bottomRight + self borderInset corner!

dividerHeight
	^self metrics menuDividerHeight!

gutterWidth
	^(self imageExtent x + self imageMargin) * 2!

heightOfItem: index 
	^(menu itemAt: index) isDivider ifTrue: [self dividerHeight] ifFalse: [self itemHeight]!

insertBefore: index position: localPoint canvas: aCanvas 
	"Answer whether an insertion at the <Point>, localPoint, should 
	place the new object before or after the item with the specified <integer> index."

	^localPoint y <= (self itemRect: index using: aCanvas) centerY!

itemHeight
	"Private - Answer the height of a menu item as currently configured."

	^self metrics menuHeight!

itemRect: anInteger using: aCanvas 
	"Answer the <Rectangle> of the indexed menu item relative to the receiver's origin."

	| y |
	y := (1 to: anInteger - 1) inject: 0 into: [:sum :index | sum + (self heightOfItem: index)].
	^0 @ y + self borderInset origin extent: itemWidth @ (self heightOfItem: anInteger)!

menuColor
	^Color menu!

offsetForSubmenu: itemIndex canvas: aCanvas 
	^(self itemRect: itemIndex using: aCanvas) topRight - self borderInset origin!

paintEdgeOn: aCanvas in: aRectangle
	"Private - Paint the receiver's 3-d shadow border."

	| cx cy oldPen |
	self metrics hasFlatMenus ifFalse: [^super paintEdgeOn: aCanvas in: aRectangle].
	cx := aRectangle width.
	cy := aRectangle height.
	oldPen := aCanvas pen: Color shadow3d pen.
	aCanvas
		lineFrom: (cx - 1) @ 0 to: 0 @ 0;
		lineTo: 0 @ (cy - 1);
		lineTo: cx @ cy - 1;
		lineTo: (cx - 1) @ 0.
	(aCanvas pen: oldPen) free!

paintItem: aMenuItem on: aCanvas in: aRectangle
	| aPoint offset border imageWidth |
	aPoint := aRectangle origin.
	border := self metrics paddedBorderThickness.
	imageWidth := self imageExtent x.
	offset := border + (menu hasSharedImageColumn ifTrue: [0] ifFalse: [imageWidth]).
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
		in: (aRectangle insetOriginBy: acceleratorOffset @ 1 cornerBy: (imageWidth + border) @ 0).
	aMenuItem size = 0
		ifFalse: [self drawArrawOn: aCanvas in: (aRectangle insetOriginBy: submenuOffset @ 0)]!

paintItemAccelerator: aMenuItem on: aCanvas in: aRectangle
	"Private - Paint the accelerator key in the specified Rectangle."

	| keyCode text |
	keyCode := aMenuItem acceleratorKey.
	keyCode isNull ifTrue: [^self].
	text := AcceleratorTable keyStringFromCode: keyCode.
	text isEmpty ifTrue: [^self].
	(conflictingAccelerators includes: aMenuItem)
		ifTrue: 
			[self paintSmudge: (aRectangle
						insetOriginBy: (aCanvas
								textExtent: text
								width: 0
								flags: self drawTextFlags | DT_NOPREFIX) x
								@ 0)
				on: aCanvas].
	aCanvas
		formatText: text
		in: aRectangle
		flags: self drawTextFlags | ##(DT_NOPREFIX | DT_RIGHT)!

paintSeparatorOn: aCanvas in: aRectangle
	"Private - Paint a menu item separator in the specified Rectangle."

	| offset |
	offset := textOffset - self metrics paddedBorderThickness.
	User32
		drawEdge: aCanvas asParameter
		qrc: (RECTL
				left: aRectangle left + offset
				top: aRectangle centerY
				right: aRectangle right - 1
				bottom: aRectangle bottom)
		edge: EDGE_ETCHED
		grfFlags: BF_TOP! !

!Tools.PopupMenuPainter categoriesForMethods!
borderInset!constants!private! !
calculateGeometry:!public!updating! !
dividerHeight!constants!private! !
gutterWidth!constants!private! !
heightOfItem:!accessing!private! !
insertBefore:position:canvas:!public!testing! !
itemHeight!constants!private! !
itemRect:using:!accessing!public! !
menuColor!constants!private! !
offsetForSubmenu:canvas:!accessing!public! !
paintEdgeOn:in:!painting!private! !
paintItem:on:in:!painting!private! !
paintItemAccelerator:on:in:!painting!private! !
paintSeparatorOn:in:!painting!private! !
!

