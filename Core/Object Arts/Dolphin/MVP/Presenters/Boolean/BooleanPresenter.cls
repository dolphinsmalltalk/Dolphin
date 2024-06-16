"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #BooleanPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BooleanPresenter guid: (GUID fromString: '{87b4c6cb-026e-11d3-9fd7-00a0cc3e4a32}')!

BooleanPresenter comment: 'BooleanPresenter is a <valuePresenter> that displays a <valueModel> onto a <boolean> value. A BooleanPresenter can be connected to any <valueView> capable of displaying <boolean> values.  Often, this will be a <CheckBox> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!

!BooleanPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Check boxes! !

!BooleanPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^false asValue!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'CheckBox view'!

resource_CheckBox_view
	"Answer the literal data from which the 'CheckBox view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_CheckBox_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.CheckBox) 34 16 nil nil 34 2 8 1409363203 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[119 5 0 0 10 0 0 0 232 5 0 0 31 0 0 0] 193 448 8 '' 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

resource_Push_to_toggle
	"Answer the literal data from which the 'Push to toggle' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_to_toggle)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.CheckBox) 34 16 nil nil 34 2 8 1409367811 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 192 7 0 0 40 0 0 0] 193 448 8 'Toggle' 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

resource_Three_state_view
	"Answer the literal data from which the 'Three state view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Three_state_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.CheckBox) 34 16 nil nil 34 2 8 1409363206 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[119 5 0 0 10 0 0 0 232 5 0 0 35 0 0 0] 193 448 8 'Yes/no/maybe?' 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

resource_Truefalse_text
	"Answer the literal data from which the 'Truefalse text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Truefalse_text)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticText) 34 16 nil nil 34 2 8 1140850945 1 416 nil nil nil 7 nil nil nil 416 nil 8 1759212608 852742 ##(Smalltalk.BooleanToText) nil 8 '' 34 2 8 'False' 8 'True' nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[200 5 0 0 247 3 0 0 64 6 0 0 16 4 0 0] 193 448 nil 416 658 #text: 34 1 8 'True' 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

resource_Yesno_text
	"Answer the literal data from which the 'Yesno text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Yesno_text)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticText) 34 16 nil nil 34 2 8 1140850945 1 416 nil nil nil 7 nil nil nil 416 nil 8 1759212608 852742 ##(Smalltalk.BooleanToText) nil 8 '' 34 2 8 'No' 8 'Yes' nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[200 5 0 0 247 3 0 0 64 6 0 0 16 4 0 0] 193 448 nil 416 658 #text: 34 1 8 'Yes
' 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

threeStateView
	"Answer the view to be used for presentation of  three states (true, false and indeterminate)."

	^'Three state view'! !

!BooleanPresenter class categoriesForMethods!
defaultModel!models!public! !
defaultView!constants!public! !
resource_CheckBox_view!public!resources-views! !
resource_Push_to_toggle!public!resources-views! !
resource_Three_state_view!public!resources-views! !
resource_Truefalse_text!public!resources-views! !
resource_Yesno_text!public!resources-views! !
threeStateView!public! !
!

