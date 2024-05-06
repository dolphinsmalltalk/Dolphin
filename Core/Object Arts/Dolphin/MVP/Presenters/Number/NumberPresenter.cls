"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #NumberPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NumberPresenter guid: (GUID fromString: '{87b4c6d1-026e-11d3-9fd7-00a0cc3e4a32}')!

NumberPresenter comment: 'NumberPresenter is a <valuePresenter> that displays a <valueModel> onto a <number> value. A NumberPresenter can be connected to any <valueView> capable of displaying <number> values. Often, this will be a <TextEdit> with a <NumberToText> converter installed although alternative views may be chosen after the installation of an appropriate <typeConverter>.'!

!NumberPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Numeric fields! !

!NumberPresenter class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140916224 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 690 241 39 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 247 7 0 0 29 0 0 0] 8 #() 690 193 193 nil 27 )!

resource_Integer_text
	"Answer the literal data from which the 'Integer text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Integer_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140924416 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 690 231 39 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 242 7 0 0 29 0 0 0] 8 #() 690 193 193 nil 27 )! !

!NumberPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Integer_text!public!resources-views! !
!

