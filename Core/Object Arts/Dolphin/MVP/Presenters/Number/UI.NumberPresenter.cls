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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.TextEdit} 34 16 nil nil 34 2 8 1140916224 1025 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1815092992 984134 1 #{UI.NumberToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 706 241 39 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 119 24 0 0 29 0 0 0] 8 #() 706 193 193 nil 27)!

resource_Integer_text
	"Answer the literal data from which the 'Integer text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Integer_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.TextEdit} 34 16 nil nil 34 2 8 1140924416 1025 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1815092992 1049670 1 #{UI.IntegerToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 706 231 39 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 114 24 0 0 29 0 0 0] 8 #() 706 193 193 nil 27)! !
!UI.NumberPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Integer_text!public!resources-views! !
!

