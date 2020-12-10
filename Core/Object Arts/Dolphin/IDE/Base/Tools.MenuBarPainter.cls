"Filed out from Dolphin Smalltalk 7"!

Tools.MenuPainter subclass: #'Tools.MenuBarPainter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MenuBarPainter guid: (Core.GUID fromString: '{b83154cc-4e8d-4ee0-9b6e-b8c6826bab88}')!
Tools.MenuBarPainter comment: ''!
!Tools.MenuBarPainter categoriesForClass!Kernel-Objects! !
!Tools.MenuBarPainter methodsFor!

borderInset
	"Private - Answer a <Rectangle> indicating the inset at each corner of the receiver filled by
	the border."

	^0 @ 0 corner: 0 @ SystemMetrics current borderExtent y!

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

	^SystemMetrics current menuBarHeight!

itemRect: anInteger using: aCanvas 
	"Answer the <Rectangle> of the indexed menu item relative to the receiver's origin."

	| space height inset |
	space := self horizontalSpacer * 2.
	inset := self borderInset.
	height := self itemHeight - inset corner y.
	^(1 to: anInteger) inject: (inset origin extent: Point zero)
		into: 
			[:sum :index | 
			| width item |
			item := menu itemAt: index.
			width := self widthOfItemText: item using: aCanvas.
			item image ifNotNil: [width := width + self imageExtent x].
			sum topRight extent: (space + width) @ height]!

menuColor
	^SystemMetrics current menuBarColor!

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

	| textRect |
	textRect := (self 
				paintItemImage: aMenuItem
				on: aCanvas
				at: aRectangle origin + (self imageMargin @ 0)) 
					ifTrue: [aRectangle insetOriginBy: (self imageExtent x + (self imageMargin * 2)) @ 0]
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
!Tools.MenuBarPainter categoriesFor: #borderInset!constants!private! !
!Tools.MenuBarPainter categoriesFor: #calculateGeometry:!public!updating! !
!Tools.MenuBarPainter categoriesFor: #drawTextFlags!painting!private! !
!Tools.MenuBarPainter categoriesFor: #insertBefore:position:canvas:!public!testing! !
!Tools.MenuBarPainter categoriesFor: #itemHeight!constants!private! !
!Tools.MenuBarPainter categoriesFor: #itemRect:using:!helpers!public! !
!Tools.MenuBarPainter categoriesFor: #menuColor!private!tracking! !
!Tools.MenuBarPainter categoriesFor: #offsetForSubmenu:canvas:!helpers!public! !
!Tools.MenuBarPainter categoriesFor: #paintEdgeOn:in:!painting!private! !
!Tools.MenuBarPainter categoriesFor: #paintItem:on:in:!painting!private! !
!Tools.MenuBarPainter categoriesFor: #paintSeparatorOn:in:!painting!private! !

