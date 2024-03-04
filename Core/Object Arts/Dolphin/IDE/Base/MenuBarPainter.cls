"Filed out from Dolphin Smalltalk"!

MenuPainter subclass: #MenuBarPainter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MenuBarPainter guid: (GUID fromString: '{b83154cc-4e8d-4ee0-9b6e-b8c6826bab88}')!

MenuBarPainter comment: ''!

!MenuBarPainter categoriesForClass!Kernel-Objects! !

!MenuBarPainter methodsFor!

borderInset
	"Private - Answer a <Rectangle> indicating the inset at each corner of the receiver filled by
	the border."

	^0 @ 0 corner: 0 @ self metrics borderExtent y!

calculateGeometry: anObject 
	^5000 @ self itemHeight!

drawTextFlags
	^super drawTextFlags bitOr: DT_CENTER!

insertBefore: anInteger position: aPoint canvas: aCanvas 
	"Answer whether an insertion at aPoint should place the new object before or after
	index."

	^aPoint x <= (self itemRect: anInteger using: aCanvas) centerX!

itemHeight
	"Private - Answer the height of a menu item as currently configured."

	^self metrics menuBarHeight!

itemRect: anInteger using: aCanvas
	"Answer the <Rectangle> of the indexed menu item relative to the receiver's origin."

	| space height inset imageWidth |
	space := self horizontalSpacer * 2.
	inset := self borderInset.
	height := self itemHeight - inset corner y.
	imageWidth := self imageExtent x.
	^(1 to: anInteger) inject: (inset origin extent: Point zero)
		into: 
			[:sum :index |
			| width item |
			item := menu itemAt: index.
			width := self widthOfItemText: item using: aCanvas.
			item image ifNotNil: [width := width + imageWidth].
			sum topRight extent: (space + width) @ height]!

menuColor
	^self metrics menuBarColor!

offsetForSubmenu: anInteger canvas: aCanvas 
	^(self itemRect: anInteger using: aCanvas) bottomLeft!

paintEdgeOn: aCanvas in: aRectangle 
	| cx cy oldPen |
	cx := aRectangle width.
	cy := aRectangle height.
	oldPen := aCanvas pen.
	aCanvas
		pen: Color highlight3d pen;
		lineFrom: 0 @ cy - 1 to: cx @ cy - 1;
		pen: oldPen!

paintItem: aMenuItem on: aCanvas in: aRectangle
	"Private - Paint the menu item on the canvas in the specified <Rectangle>."

	| textRect margin |
	margin := self imageMargin.
	textRect := (self
				paintItemImage: aMenuItem
				on: aCanvas
				at: aRectangle origin + (margin @ 0))
					ifTrue: [aRectangle insetOriginBy: (self imageExtent x + (margin * 2)) @ 0]
					ifFalse: [aRectangle].
	self
		paintItemText: aMenuItem
		on: aCanvas
		in: textRect!

paintSeparatorOn: aCanvas in: aRectangle 
	| position cy oldPen |
	position := aRectangle origin + (self horizontalSpacer @ 0).
	cy := aRectangle height.
	oldPen := aCanvas pen.
	
	[aCanvas
		pen: Color shadow3d pen;
		lineFrom: position to: position + (0 @ cy);
		pen: Color highlight3d pen;
		lineFrom: position + (1 @ 0) to: position + (1 @ cy)] 
			ensure: [aCanvas pen: oldPen]! !

!MenuBarPainter categoriesForMethods!
borderInset!constants!private! !
calculateGeometry:!public!updating! !
drawTextFlags!painting!private! !
insertBefore:position:canvas:!public!testing! !
itemHeight!constants!private! !
itemRect:using:!helpers!public! !
menuColor!private!tracking! !
offsetForSubmenu:canvas:!helpers!public! !
paintEdgeOn:in:!painting!private! !
paintItem:on:in:!painting!private! !
paintSeparatorOn:in:!painting!private! !
!

