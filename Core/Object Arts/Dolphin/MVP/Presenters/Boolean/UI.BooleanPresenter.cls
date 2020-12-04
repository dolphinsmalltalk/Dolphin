"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.BooleanPresenter'
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_CheckBox_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.CheckBox) 34 16 nil nil 34 2 8 1409363203 1 416 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1920683440 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 706 227 43 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 112 12 0 0 31 0 0 0] 8 #() 706 193 193 nil 27)!

resource_Push_to_toggle
	"Answer the literal data from which the 'Push to toggle' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_to_toggle)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.CheckBox) 34 16 nil nil 34 2 8 1409367811 1 416 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1920683440 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 706 131 61 416 658 #text: 34 1 8 'Toggle' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 64 12 0 0 40 0 0 0] 8 #() 706 193 193 nil 27)!

resource_Three_state_view
	"Answer the literal data from which the 'Three state view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Three_state_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.CheckBox) 34 16 nil nil 34 2 8 1409363206 1 416 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1920683440 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 706 227 51 416 658 #text: 34 1 8 'Yes/no/maybe?' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 112 12 0 0 35 0 0 0] 8 #() 706 193 193 nil 27)!

resource_Truefalse_text
	"Answer the literal data from which the 'Truefalse text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Truefalse_text)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.StaticText) 34 16 nil nil 34 2 8 1140850945 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920531648 1049670 1 ##(UI.BooleanToText) nil 8 '' 1049350 ##(OS.WindowsLocale) 852998 ##(OS.NUMBERFMTW) 8 #[2 0 0 0 1 0 0 0 3 0 0 0 232 149 214 5 200 149 214 5 1 0 0 0] 8 '.' nil 8 ',' 4115 170 192 34 12 35 5 31 8 ',' 8225 3 37 3 33 8 '3;0' 29 8 '.' 34 2 8 'False' 8 'True' nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 898 241 51 416 850 #text: 34 1 8 'True' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 35 0 0 0] 8 #() 898 193 193 nil 27)!

resource_Yesno_text
	"Answer the literal data from which the 'Yesno text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Yesno_text)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.StaticText) 34 16 nil nil 34 2 8 1140850945 1 416 nil nil nil 7 nil nil nil 416 nil 8 1920531648 1049670 1 ##(UI.BooleanToText) nil 8 '' 1049350 ##(OS.WindowsLocale) 852998 ##(OS.NUMBERFMTW) 8 #[2 0 0 0 1 0 0 0 3 0 0 0 232 149 214 5 200 149 214 5 1 0 0 0] 8 '.' nil 8 ',' 4115 170 192 34 12 35 5 31 8 ',' 8225 3 37 3 33 8 '3;0' 29 8 '.' 34 2 8 'No' 8 'Yes' nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 898 241 51 416 850 #text: 34 1 8 'Yes
' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 35 0 0 0] 8 #() 898 193 193 nil 27)!

threeStateView
	"Answer the view to be used for presentation of  three states (true, false and indeterminate)."

	^'Three state view'! !
!UI.BooleanPresenter class categoriesFor: #defaultModel!models!public! !
!UI.BooleanPresenter class categoriesFor: #defaultView!constants!public! !
!UI.BooleanPresenter class categoriesFor: #resource_CheckBox_view!public!resources-views! !
!UI.BooleanPresenter class categoriesFor: #resource_Push_to_toggle!public!resources-views! !
!UI.BooleanPresenter class categoriesFor: #resource_Three_state_view!public!resources-views! !
!UI.BooleanPresenter class categoriesFor: #resource_Truefalse_text!public!resources-views! !
!UI.BooleanPresenter class categoriesFor: #resource_Yesno_text!public!resources-views! !
!UI.BooleanPresenter class categoriesFor: #threeStateView!public! !

