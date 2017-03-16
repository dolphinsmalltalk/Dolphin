"Filed out from Dolphin Smalltalk 7"!

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

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_CheckBox_view
	"Answer the literal data from which the 'CheckBox view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_CheckBox_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.CheckBox)  98 16 0 0 98 2 8 1409363203 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 0 0 5 0 0 0 416 0 8 4294903631 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 738 227 43 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 232 5 0 0 31 0 0 0] 98 0 738 193 193 0 27 )!

resource_Push_to_toggle
	"Answer the literal data from which the 'Push to toggle' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_to_toggle)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.CheckBox)  98 16 0 0 98 2 8 1409367811 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294903631 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 786 131 61 416 722 8 #text: 98 1 8 'Toggle' 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 184 5 0 0 40 0 0 0] 98 0 786 193 193 0 27 )!

resource_Three_state_view
	"Answer the literal data from which the 'Three state view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Three_state_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.CheckBox)  98 16 0 0 98 2 8 1409363206 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 0 0 5 0 0 0 416 0 8 4294903631 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 738 227 51 416 674 8 #text: 98 1 8 'Yes/no/maybe?' 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 232 5 0 0 35 0 0 0] 98 0 738 193 193 0 27 )!

resource_Truefalse_text
	"Answer the literal data from which the 'Truefalse text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Truefalse_text)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(StaticText)  98 16 0 0 98 2 8 1140850945 1 416 0 0 0 7 0 0 0 416 0 8 4294906439 852742 ##(BooleanToText)  0 8 '' 98 2 8 'False' 8 'True' 0 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  2961 2223 738 241 51 416 674 8 #text: 98 1 8 'True' 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 5 0 0 87 4 0 0 64 6 0 0 112 4 0 0] 98 0 738 193 193 0 27 )!

resource_Yesno_text
	"Answer the literal data from which the 'Yesno text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Yesno_text)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(StaticText)  98 16 0 0 98 2 8 1140850945 1 416 0 0 0 7 0 0 0 416 0 8 4294906439 852742 ##(BooleanToText)  0 8 '' 98 2 8 'No' 8 'Yes' 0 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  2961 2223 738 241 51 416 674 8 #text: 98 1 8 'Yes
' 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 5 0 0 87 4 0 0 64 6 0 0 112 4 0 0] 98 0 738 193 193 0 27 )!

threeStateView
	"Answer the view to be used for presentation of  three states (true, false and indeterminate)."

	^'Three state view'! !
!BooleanPresenter class categoriesFor: #defaultModel!models!public! !
!BooleanPresenter class categoriesFor: #defaultView!constants!public! !
!BooleanPresenter class categoriesFor: #icon!constants!public! !
!BooleanPresenter class categoriesFor: #resource_CheckBox_view!public!resources-views! !
!BooleanPresenter class categoriesFor: #resource_Push_to_toggle!public!resources-views! !
!BooleanPresenter class categoriesFor: #resource_Three_state_view!public!resources-views! !
!BooleanPresenter class categoriesFor: #resource_Truefalse_text!public!resources-views! !
!BooleanPresenter class categoriesFor: #resource_Yesno_text!public!resources-views! !
!BooleanPresenter class categoriesFor: #threeStateView!public! !

