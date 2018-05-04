"Filed out from Dolphin Smalltalk 7"!

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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(TextEdit)  98 16 0 0 98 2 8 1140916224 1025 416 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294906635 787206 ##(NumberToText)  0 8 '' 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 738 241 39 416 674 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 416 674 8 #isTextModified: 98 1 32 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 125 0 0 0 24 0 0 0] 98 0 738 193 193 0 27 )!

resource_Integer_text
	"Answer the literal data from which the 'Integer text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Integer_text)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(TextEdit)  98 16 0 0 98 2 8 1140924416 1025 416 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294906635 852742 ##(IntegerToText)  0 8 '' 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 738 231 39 416 674 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 416 674 8 #isTextModified: 98 1 32 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 120 0 0 0 24 0 0 0] 98 0 738 193 193 0 27 )! !
!NumberPresenter class categoriesFor: #defaultModel!models!public! !
!NumberPresenter class categoriesFor: #icon!constants!public! !
!NumberPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!NumberPresenter class categoriesFor: #resource_Integer_text!public!resources-views! !

