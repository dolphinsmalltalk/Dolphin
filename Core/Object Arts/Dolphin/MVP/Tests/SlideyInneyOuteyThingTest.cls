﻿"Filed out from Dolphin Smalltalk"!

SelectableItemsTest subclass: #SlideyInneyOuteyThingTest
	instanceVariableNames: 'allowCardChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SlideyInneyOuteyThingTest guid: (GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

SlideyInneyOuteyThingTest comment: ''!

!SlideyInneyOuteyThingTest categoriesForClass!Unclassified! !

!SlideyInneyOuteyThingTest methodsFor!

classToTest
	^SlideyInneyOuteyThing!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view animation identicalTo: #roll.
	self assert: view isEnabled.
	self assert: view isCardChangeAnimated.
	self assert: view isTrayResizable.
	self assert: view isHiddenOnUnpin.
	self assert: view inheritContextMenu! !

!SlideyInneyOuteyThingTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!SlideyInneyOuteyThingTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.SlideyInneyOuteyThing)  98 23 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 0 0 416 655878 ##(Smalltalk.CardLayout)  202 208 98 0 0 234 256 592 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 416 98 2 8 1140916864 1 624 590662 2 ##(Smalltalk.ListModel)  202 208 592 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 1 0 0 0 624 0 8 4294903589 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 8 #noIcons 0 0 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1026 701 501 624 962 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 624 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 1026 193 193 0 27 410 8 ##(Smalltalk.SlidingCardTray)  98 22 0 416 98 2 8 1140850688 131073 1200 0 498 528 0 5 0 0 0 1200 560 234 256 592 0 624 0 416 1026 33 33 1049862 ##(Smalltalk.ButtonInteractor)  1200 0 590342 ##(Smalltalk.Rectangle)  1026 649 3 1026 681 35 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #togglePin 8 'Pin or Unpin the tray' 1 1 0 0 0 898 202 208 98 1 962 992 98 2 1026 9 9 1026 685 485 1200 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 246 0 0 0] 98 0 1184 0 27 1026 201 201 401 0 31 0 0 898 202 208 98 1 962 992 98 2 1026 2799 21 1026 701 501 416 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 4 1 0 0] 98 2 1200 624 1184 0 27 )!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 656710 1 ##(Smalltalk.CardLayout) 138 144 8 #() nil nil nil nil 170 192 560 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 416 34 2 8 1140916864 1 592 590662 2 ##(Smalltalk.ListModel) 138 144 560 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 496 nil 1 nil nil nil 592 nil 8 1921705120 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 898 701 501 592 850 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 898 193 193 nil 27 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 416 34 2 8 1140850688 131073 1056 nil 496 nil 5 nil nil nil 1056 528 170 192 560 nil 592 nil 416 898 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 1056 nil 1 590342 ##(Smalltalk.Rectangle) 898 649 3 898 681 35 nil 1180998 4 ##(Smalltalk.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 9 9 898 685 485 1056 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 246 0 0 0] 8 #() 1040 nil 27 898 201 201 401 nil 31 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 3839 21 898 701 501 416 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 2 1056 592 1040 nil 27 )! !

!SlideyInneyOuteyThingTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!
