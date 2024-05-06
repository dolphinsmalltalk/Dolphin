"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #FontPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FontPresenter guid: (GUID fromString: '{87b4c6cf-026e-11d3-9fd7-00a0cc3e4a32}')!

FontPresenter comment: 'FontPresenter is a <valuePresenter> that displays a <valueModel> onto a <Font> value. A FontPresenter can be connected to any <valueView> capable of displaying <Font> values. Normally, this will be a <FontView> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!

!FontPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Font displays! !

!FontPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Font system asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.FontView) 34 17 nil nil 34 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) nil nil nil 5 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2799 21 706 571 51 416 658 #text: 34 1 8 'Default' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 148 6 0 0 35 0 0 0] 8 #() 706 193 193 nil 27 )! !

!FontPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

