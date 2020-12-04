"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.DatePresenter'
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.TextEdit) 34 16 nil nil 34 2 8 1140916224 1025 416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 nil 8 1920675248 853062 1 ##(UI.DateToText) nil 8 '' nil nil 1 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 690 251 39 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 29 0 0 0] 8 #() 690 193 193 nil 27)! !
!UI.DatePresenter class categoriesFor: #defaultModel!models!public! !
!UI.DatePresenter class categoriesFor: #defaultView!constants!public!views! !
!UI.DatePresenter class categoriesFor: #icon!constants!public! !
!UI.DatePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

