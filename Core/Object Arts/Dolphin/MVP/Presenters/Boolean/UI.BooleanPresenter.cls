"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.BooleanPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.BooleanPresenter guid: (Core.GUID fromString: '{87b4c6cb-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.BooleanPresenter comment: 'BooleanPresenter is a <valuePresenter> that displays a <valueModel> onto a <boolean> value. A BooleanPresenter can be connected to any <valueView> capable of displaying <boolean> values.  Often, this will be a <CheckBox> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!

!UI.BooleanPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Check boxes! !

!UI.BooleanPresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_CheckBox_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.CheckBox} 38 #{Core.Array} 16 nil nil 50 2 8 1409363203 1 32 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 517 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 306 227 43 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 112 12 0 0 31 0 0 0] 8 #() 306 193 193 nil 27)!

resource_Push_to_toggle
	"Answer the literal data from which the 'Push to toggle' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Push_to_toggle)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.CheckBox} 38 #{Core.Array} 16 nil nil 50 2 8 1409367811 1 32 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 306 131 61 32 258 #text: 50 1 8 'Toggle' 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 64 12 0 0 40 0 0 0] 8 #() 306 193 193 nil 27)!

resource_Three_state_view
	"Answer the literal data from which the 'Three state view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Three_state_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.CheckBox} 38 #{Core.Array} 16 nil nil 50 2 8 1409363206 1 32 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 517 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 306 227 51 32 258 #text: 50 1 8 'Yes/no/maybe?' 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 112 12 0 0 35 0 0 0] 8 #() 306 193 193 nil 27)!

resource_Truefalse_text
	"Answer the literal data from which the 'Truefalse text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Truefalse_text)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.StaticText} 38 #{Core.Array} 16 nil nil 50 2 8 1140850945 1 32 nil nil nil 5 nil nil nil 32 nil nil 1094 1 #{UI.BooleanToText} nil 8 '' 326 1 #{Core.Locale} #userDefault 50 2 8 'False' 8 'True' nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 338 241 51 32 290 #text: 50 1 8 'True' 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 35 0 0 0] 8 #() 338 193 193 nil 27)!

resource_Yesno_text
	"Answer the literal data from which the 'Yesno text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Yesno_text)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.StaticText} 38 #{Core.Array} 16 nil nil 50 2 8 1140850945 1 32 nil nil nil 5 nil nil nil 32 nil nil 1094 1 #{UI.BooleanToText} nil 8 '' 326 1 #{Core.Locale} #userDefault 50 2 8 'No' 8 'Yes' nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 338 241 51 32 290 #text: 50 1 8 'Yes
' 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 35 0 0 0] 8 #() 338 193 193 nil 27)!

threeStateView
	"Answer the view to be used for presentation of  three states (true, false and indeterminate)."

	^'Three state view'! !

!UI.BooleanPresenter class categoriesForMethods!
defaultModel!models!public! !
defaultView!constants!public! !
resource_CheckBox_view!public!resources-views! !
resource_Push_to_toggle!public!resources-views! !
resource_Three_state_view!public!resources-views! !
resource_Truefalse_text!public!resources-views! !
resource_Yesno_text!public!resources-views! !
threeStateView!public! !
!

