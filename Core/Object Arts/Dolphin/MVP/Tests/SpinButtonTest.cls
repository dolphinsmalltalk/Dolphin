"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #SpinButtonTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SpinButtonTest guid: (GUID fromString: '{7befb3d7-8dc5-4dbb-92c2-7edaab76f305}')!

SpinButtonTest comment: ''!

!SpinButtonTest categoriesForClass!Unclassified! !

!SpinButtonTest methodsFor!

classToTest
	^SpinButton!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view interactor identicalTo: view.
	self assert: view isEnabled.
	self assert: view isVertical.
	self assert: view range equals: (1 to: 100)! !

!SpinButtonTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:!helpers!private! !
!

!SpinButtonTest class methodsFor!

resource_Spin_button_D6
	"Answer the literal data from which the 'Spin button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Spin_button)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(SpinButton) 98 15 0 0 98 2 8 1140916240 1 416 721990 2 ##(ValueHolder) 0 0 1376774 ##(PluggableSearchPolicy) 459270 ##(Message) 8 #= 98 0 562 8 #hash 98 0 1 524550 ##(ColorRef) 8 4278190080 0 7 0 0 0 416 0 8 4294906895 852486 ##(NullConverter) 0 0 983302 ##(MessageSequence) 202 208 98 3 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 898 51 51 416 834 8 #setRange: 98 1 525062 ##(Interval) 3 201 3 416 834 8 #udmSetAccel: 98 1 918854 1 ##(StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 8 ##(UDACCEL) 0 17 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 30 0 0 0 30 0 0 0] 98 0 898 193 193 0 27)!

resource_Spin_button_D7
	"Answer the literal data from which the 'Spin button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Spin_button)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.SpinButton) 34 15 nil nil 34 2 8 1140916240 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 546 #hash 8 #() 1 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903809120 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 818 35 51 416 770 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 201 3 416 770 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 144 7 0 0 35 0 0 0] 8 #() 818 193 193 nil 27 )! !

!SpinButtonTest class categoriesForMethods!
resource_Spin_button_D6!public!resources-views! !
resource_Spin_button_D7!public!resources-views! !
!

