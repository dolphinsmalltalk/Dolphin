"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.NumberPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.NumberPresenter guid: (Core.GUID fromString: '{87b4c6d1-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.NumberPresenter comment: 'NumberPresenter is a <valuePresenter> that displays a <valueModel> onto a <number> value. A NumberPresenter can be connected to any <valueView> capable of displaying <number> values. Often, this will be a <TextEdit> with a <NumberToText> converter installed although alternative views may be chosen after the installation of an appropriate <typeConverter>.'!

!UI.NumberPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Numeric fields! !

!UI.NumberPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^0 asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.TextEdit} 38 #{Core.Array} 20 nil nil 50 2 8 1140916224 1025 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 1094 1 #{UI.NumberToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 119 15 0 0 29 0 0 0] 193 80 nil 32 3 8 #() 518 #{Graphics.Point} 193 193 nil 45)!

resource_Integer_text
	"Answer the literal data from which the 'Integer text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Integer_text)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.TextEdit} 38 #{Core.Array} 20 nil nil 50 2 8 1140924416 1025 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 114 15 0 0 29 0 0 0] 193 80 nil 32 3 8 #() 518 #{Graphics.Point} 193 193 nil 45)! !

!UI.NumberPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Integer_text!public!resources-views! !
!

