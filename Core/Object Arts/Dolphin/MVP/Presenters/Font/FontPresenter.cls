"Filed out from Dolphin Smalltalk 7"!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.FontView)  98 17 0 0 98 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  0 0 0 5 0 0 0 416 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 738 571 51 416 674 8 #text: 98 1 8 'Default' 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 148 6 0 0 35 0 0 0] 98 0 738 193 193 0 27 )! !
!FontPresenter class categoriesFor: #defaultModel!models!public! !
!FontPresenter class categoriesFor: #icon!constants!public! !
!FontPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

