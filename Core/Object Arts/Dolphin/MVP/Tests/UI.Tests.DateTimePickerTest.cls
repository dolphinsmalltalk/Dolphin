"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.DateTimePickerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.DateTimePickerTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

UI.Tests.DateTimePickerTest comment: ''!

!UI.Tests.DateTimePickerTest methodsFor!

classToTest
	^DateTimePicker!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view typeconverter isNullConverter.
	self assertIsNil: view displayFormat! !

!UI.Tests.DateTimePickerTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.DateTimePickerTest class methodsFor!

resource_Picker_view_D6
	"Answer the literal data from which the 'Picker view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Picker_view_D6)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(DateTimePicker) 98 16 0 0 98 2 8 1140916235 1 416 721990 2 ##(ValueHolder) 0 0 1376774 ##(PluggableSearchPolicy) 459270 ##(Message) 8 #= 98 0 562 8 #hash 98 0 262406 ##(Time) 1 524550 ##(ColorRef) 8 4278190080 0 7 0 0 0 416 0 8 4294907103 852486 ##(NullConverter) 0 0 0 983302 ##(MessageSequence) 202 208 98 3 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 930 251 51 416 866 8 #text: 98 1 8 '00:00:00' 416 866 8 #range: 98 1 98 2 0 0 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 130 0 0 0 30 0 0 0] 98 0 930 193 193 0 27)!

resource_Picker_view_D7
	"Answer the literal data from which the 'Picker view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Picker_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DateTimePicker) 34 16 nil nil 34 2 8 1140916235 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1904605520 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 738 251 51 416 690 #text: 34 1 8 '21:29:40' 416 690 #range: 34 1 8 #(nil nil) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 35 0 0 0] 8 #() 738 193 193 nil 27)! !

!UI.Tests.DateTimePickerTest class categoriesForMethods!
resource_Picker_view_D6!public!resources-views! !
resource_Picker_view_D7!public!resources-views! !
!

