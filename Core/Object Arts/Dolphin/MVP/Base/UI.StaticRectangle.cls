"Filed out from Dolphin Smalltalk"!

UI.ControlView
	subclass: #'UI.StaticRectangle'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'StyleMap'
				-> (IdentityDictionary withAll: {
								#blackFrame -> 16r7.
								#blackRectangle -> 16r4.
								#etchedFrame -> 16r12.
								#etchedHorizontal -> 16r10.
								#etchedVertical -> 16r11.
								#grayFrame -> 16r8.
								#grayRectangle -> 16r5.
								#whiteFrame -> 16r9.
								#whiteRectangle -> 16r6
							})
		}!
UI.StaticRectangle guid: (Core.GUID fromString: '{aad4f3a9-dc68-42b2-bedc-0a4fc49880f2}')!
UI.StaticRectangle comment: '`StaticRectangle` is a simple `ControlView` class which wraps the Windows STATIC control for simple rectangles and frames.

The rectangle styles paint a solid block of colour filling the client area. The frame styles draw a border/frame around the edge of the client area of the control allowing the background colour to show through.

Apart from its uses for background rectangles and frames, StaticRectangle can also be used for horizontal and vertical lines by setting the width or height appropriately. When using in conjunction with a `ProportionalLayout` to add some kind of divider, set the arrangement to 0 to maintain the specified width/height.

## Class Variables:
  `StyleMap`		`LookupTable` of `Symbol` rectangle/frame style names Windows styles.'!
!UI.StaticRectangle categoriesForClass!MVP-Views! !
!UI.StaticRectangle methodsFor!

setStyle: rectangleStyleBits
	"Private - Sets the rectangle style of this static control."

	self baseStyle: rectangleStyleBits maskedBy: SS_TYPEMASK recreateIfChanged: true!

style
	"Answer the style of rectangle currently adopted by the receiver."

	| styleFlags |
	styleFlags := self baseStyle bitAnd: SS_TYPEMASK.
	^StyleMap keyAtValue: styleFlags ifAbsent: #blackFrame!

style: rectangleStyleName
	"Set the style of rectangle required of the receiver to that identifier by the symbolic
	name, rectangleStyleName."

	self setStyle: (StyleMap at: rectangleStyleName)! !
!UI.StaticRectangle categoriesForMethods!
setStyle:!accessing!private! !
style!accessing!public! !
style:!accessing!public! !
!

!UI.StaticRectangle class methodsFor!

initialize
	"Private - Initialise the receiver's class variables:

			self initialize
	"

	self addClassConstant: 'StyleMap'
		value: (IdentityDictionary withAll: {
						#blackFrame -> SS_BLACKFRAME.
						#blackRectangle -> SS_BLACKRECT.
						#grayFrame -> SS_GRAYFRAME.
						#grayRectangle -> SS_GRAYRECT.
						#whiteFrame -> SS_WHITEFRAME.
						#whiteRectangle -> SS_WHITERECT.
						#etchedFrame -> SS_ETCHEDFRAME.
						#etchedHorizontal -> SS_ETCHEDHORZ.
						#etchedVertical -> SS_ETCHEDVERT
					})!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.StaticRectangle} 38 #{Core.Array} 14 nil nil 50 2 8 1140850951 1 32 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 32 nil 8 1853387904 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 258 211 51 32 210 #isEnabled: 8 #(false) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 104 12 0 0 35 0 0 0] 8 #() 258 193 193 nil 27)!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'STATIC'
! !
!UI.StaticRectangle class categoriesForMethods!
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
winClassName!constants!private! !
!

