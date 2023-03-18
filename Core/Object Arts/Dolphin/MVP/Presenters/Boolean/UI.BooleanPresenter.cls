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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.CheckBox} 34 16 nil nil 34 2 8 1409363203 1 416 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 416 nil 8 1815097472 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 690 227 43 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 112 24 0 0 31 0 0 0] 8 #() 690 193 193 nil 27)!

resource_Push_to_toggle
	"Answer the literal data from which the 'Push to toggle' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Push_to_toggle)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.CheckBox} 34 16 nil nil 34 2 8 1409367811 1 416 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 416 nil 8 1815097472 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 690 131 61 416 642 #text: 34 1 8 'Toggle' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 64 24 0 0 40 0 0 0] 8 #() 690 193 193 nil 27)!

resource_Three_state_view
	"Answer the literal data from which the 'Three state view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Three_state_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.CheckBox} 34 16 nil nil 34 2 8 1409363206 1 416 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 416 nil 8 1815097472 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 690 227 51 416 642 #text: 34 1 8 'Yes/no/maybe?' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 112 24 0 0 35 0 0 0] 8 #() 690 193 193 nil 27)!

resource_Truefalse_text
	"Answer the literal data from which the 'Truefalse text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Truefalse_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.StaticText} 34 16 nil nil 34 2 8 1140850945 1 416 nil nil nil 7 nil nil nil 416 nil 8 1815137184 1049670 1 #{UI.BooleanToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault 34 2 8 'False' 8 'True' nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 722 241 51 416 674 #text: 34 1 8 'True' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 119 24 0 0 35 0 0 0] 8 #() 722 193 193 nil 27)!

resource_Yesno_text
	"Answer the literal data from which the 'Yesno text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Yesno_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.StaticText} 34 16 nil nil 34 2 8 1140850945 1 416 nil nil nil 7 nil nil nil 416 nil 8 1815137184 1049670 1 #{UI.BooleanToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault 34 2 8 'No' 8 'Yes' nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 722 241 51 416 674 #text: 34 1 8 'Yes
' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 119 24 0 0 35 0 0 0] 8 #() 722 193 193 nil 27)!

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

