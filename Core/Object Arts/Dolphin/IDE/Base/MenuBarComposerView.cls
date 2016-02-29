"Filed out from Dolphin Smalltalk 7"!

MenuComposerView subclass: #MenuBarComposerView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MenuBarComposerView guid: (GUID fromString: '{87B4C74A-026E-11D3-9FD7-00A0CC3E4A32}')!
MenuBarComposerView comment: 'MenuBarComposerView is a <valueView> for displaying and editing a <MenuBar>. The <valueModel> associated with a MenuBarComposerView must always yield a <MenuBar> value when mapped through the installed type converter. In general, therefore, the type converter installed is usually a NullConverter. A MenuBarComposerView will normally be used in conjunction with a <MenuBarComposer> dialog presenter.'!
!MenuBarComposerView categoriesForClass!Development!MVP-Views! !
!MenuBarComposerView methodsFor!

borderInset
	"Private - Answer a Rectangle indicating the inset at each corner of the receiver filled by
	the border."

	^0 @ 0 corner: 0 @ SystemMetrics current borderExtent y!

drawTextFlags
	^super drawTextFlags bitOr: DT_CENTER!

insertBefore: index position: localPoint
	"Private - Answer whether an insertion at localPoint should place the new
	object before or after index."

	^localPoint x <= (self itemRect: index) centerX!

itemHeight
	"Private - Answer the height of a menu item as currently configured."

	^SystemMetrics current menuBarHeight!

itemRect: itemIndex 
	"Private - Answer the <Rectangle> of the menu item relative to the receiver's origin."

	| space height |
	space := self horizontalSpacer * 2.
	height := self itemHeight - self borderInset corner y.
	^(1 to: itemIndex) inject: (self borderInset origin extent: Point zero)
		into: 
			[:sum :index | 
			| width item |
			item := self itemAtIndex: index.
			width := self widthOfItemText: item.
			item image isNil ifFalse: [width := width + self imageExtent x].
			sum topRight extent: (space + width) @ height]!

menuColor
	^SystemMetrics current menuBarColor!

originForSubmenu: itemIndex 
	"Private - Answer the position in the receivers parent view for
	which aMenuItems submenu should be opened at."

	^self position + (self itemRect: itemIndex) bottomLeft!

paintEdgeOn: aCanvas 
	"Private - Paint the receiver's edging."

	| extent cx cy oldPen |
	extent := self extent.
	cx := extent x.
	cy := extent y.
	oldPen := aCanvas pen.
	aCanvas
		pen: Color highlight3d pen;
		lineFrom: 0 @ cy - 1 to: cx @ cy - 1;
		pen: oldPen!

paintItem: aMenuItem on: aCanvas in: aRectangle 
	"Private - Paint the menu item at origin."

	| textRect |
	textRect := (self 
				paintItemImage: aMenuItem
				on: aCanvas
				at: aRectangle origin + (2 @ 0)) 
					ifTrue: [aRectangle insetOriginBy: self imageExtent x @ 0]
					ifFalse: [aRectangle].
	self 
		paintItemText: aMenuItem
		on: aCanvas
		in: textRect!

paintSeparatorOn: canvas in: aRectangle 
	| position cy oldPen |
	position := aRectangle origin + (self horizontalSpacer @ 0).
	cy := aRectangle height.
	oldPen := canvas pen.
	canvas
		pen: Color shadow3d pen;
		lineFrom: position to: position + (0 @ cy);
		pen: Color highlight3d pen;
		lineFrom: position + (1 @ 0) to: position + (1 @ cy);
		pen: oldPen!

updateGeometry
	"Private - The contents of the receivers menu has changed. This could cause the view to resize, etc."

	self extent: 5000 @ self itemHeight! !
!MenuBarComposerView categoriesFor: #borderInset!constants!private! !
!MenuBarComposerView categoriesFor: #drawTextFlags!painting!private! !
!MenuBarComposerView categoriesFor: #insertBefore:position:!private!testing! !
!MenuBarComposerView categoriesFor: #itemHeight!constants!private! !
!MenuBarComposerView categoriesFor: #itemRect:!accessing!private! !
!MenuBarComposerView categoriesFor: #menuColor!private!tracking! !
!MenuBarComposerView categoriesFor: #originForSubmenu:!accessing!private! !
!MenuBarComposerView categoriesFor: #paintEdgeOn:!painting!private! !
!MenuBarComposerView categoriesFor: #paintItem:on:in:!painting!private! !
!MenuBarComposerView categoriesFor: #paintSeparatorOn:in:!painting!private! !
!MenuBarComposerView categoriesFor: #updateGeometry!private!updating! !

