"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.DatePresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DatePresenter guid: (Core.GUID fromString: '{87b4c6ce-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.DatePresenter comment: 'DatePresenter is a <valuePresenter> that displays a <valueModel> onto a <Date> value. A DatePresenter can be connected to any <valueView> capable of displaying <Date> values. When the ''Dolphin DateTimePicker Control'' package is installed this will be a <DateTimePicker>, but alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!UI.DatePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Date fields! !
!UI.DatePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Date today!

defaultView
	^'Picker view'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.TextEdit} 38 #{Core.Array} 20 nil nil 50 2 8 1140916224 1025 32 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 32 nil 8 1853175488 1094 1 #{UI.DateToText} nil 8 '' nil nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 306 251 39 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 29 0 0 0] 8 #() 306 193 193 nil 45)! !
!UI.DatePresenter class categoriesForMethods!
defaultModel!models!public! !
defaultView!constants!public!views! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

