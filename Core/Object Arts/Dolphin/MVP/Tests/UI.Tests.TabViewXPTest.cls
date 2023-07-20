"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractTabViewTest
	subclass: #'UI.Tests.TabViewXPTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.TabViewXPTest guid: (Core.GUID fromString: '{f55d0ba3-f595-4d2c-bfc2-65de737b4fcb}')!
UI.Tests.TabViewXPTest comment: ''!
!UI.Tests.TabViewXPTest methodsFor!

classToTest
	^TabViewXP!

testLabelWithAmpersand
	"Test that labels containing ampersands are not (normally) ellipsised.
	We have to use a bit of sleight of hand to test this, as the public effect is purely visual. Luckily the underlying API is able to modify the drawn text in place with any ellipsis that it adds. We can exploit this capability to capture the actual text it decides to draw."

	| rect anon canvas actual expected extent text |
	self addTestTabs.
	rect := presenter itemRect: 3.
	text := self objectsToTest at: 3.
	"About time we did a port of MethodWrappers really"
	anon := (ClassBuilder forAnonymousSubclassOf: Canvas)
				classVariableString: 'DrawnText Rect';
				createNewClass.
	anon
		basicCompile: 'formatText: aString in: aRectangle flags: anInteger
		"Double the size to avoid any chance of buffer overrun"
		DrawnText := aString asUtf16String, (Utf16String new: aString size).
		Rect := aRectangle.
		^super formatText: DrawnText in: aRectangle flags: anInteger | DT_MODIFYSTRING'.
	canvas := presenter canvas.
	canvas becomeAn: anon.
	canvas font: presenter actualFont.
	extent := canvas
				textExtent: text
				width: 0
				flags: DT_SINGLELINE.
	presenter
		paintLabel: 3
		on: canvas
		in: rect.
	canvas free.
	actual := (anon classPool at: 'DrawnText') upTo: Character null.
	expected := self objectsToTest at: 3.
	self assert: actual equals: expected.
	actual := (anon classPool at: 'Rect') extent.
	self assert: actual equals: extent!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assertIsNil: (view instVarNamed: 'lastSelection')!

view
	| view |
	view := presenter view.
	^(view isKindOf: self classToTest)
		ifTrue: [view]
		ifFalse: 
			["CardContainer"
			view subViews first]! !
!UI.Tests.TabViewXPTest categoriesForMethods!
classToTest!helpers!private! !
testLabelWithAmpersand!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
view!accessing!private! !
!

!UI.Tests.TabViewXPTest class methodsFor!

resource_Card_container_D6
	"Answer the literal data from which the 'Tab view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tab_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.CardContainer) 98 16 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 655878 ##(Smalltalk.CardLayout) 202 208 98 0 0 234 256 592 0 410 8 ##(Smalltalk.TabViewXP) 98 28 0 416 98 2 8 1140916736 1 624 590662 2 ##(Smalltalk.ListModel) 202 208 592 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 0 0 1 0 0 0 624 0 8 4294903589 787814 3 ##(Smalltalk.BlockClosure) 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 8 ##(Smalltalk.ListControlView) 8 #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] 8 #displayString 816 7 257 0 802 0 0 834 2 3 8 ##(Smalltalk.IconicListAbstract) 8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 928 7 257 0 1049670 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 8 #noIcons 0 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 1202 701 501 624 1138 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 624 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 1202 193 193 0 27 1074 202 208 98 1 1138 1168 98 2 1202 2799 21 1202 701 501 416 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 4 1 0 0] 98 1 624 1360 0 27)!

resource_Tab_view_D7
	"Answer the literal data from which the 'Tab view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tab_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TabViewXP) 34 28 nil nil 34 2 8 1409352192 1 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #face3d nil 5 nil nil nil 416 nil 8 1904010400 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 818 701 61 416 770 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 40 0 0 0] 8 #() 818 193 193 nil 27)! !
!UI.Tests.TabViewXPTest class categoriesForMethods!
resource_Card_container_D6!public!resources-views! !
resource_Tab_view_D7!public!resources-views! !
!

