"Filed out from Dolphin Smalltalk X6"!

ValuePresenter subclass: #ColorPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorPresenter guid: (GUID fromString: '{87B4C6CD-026E-11D3-9FD7-00A0CC3E4A32}')!
ColorPresenter comment: 'ColorPresenter is a <valuePresenter> that displays a <valueModel> onto a <color> value. A ColorPresenter can be connected to any <valueView> capable of displaying <color> values. Normally, this will be a <ColorView> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!ColorPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Colour displays! !
!ColorPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Color black asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ColorView)  98 16 0 0 98 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1114118 ##(Smalltalk.NeverSearchPolicy)  786694 ##(Smalltalk.IndexedColor)  33554465 576 0 5 0 0 0 416 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 770 251 81 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 244 5 0 0 50 0 0 0] 98 0 770 193 193 0 27 )! !
!ColorPresenter class categoriesFor: #defaultModel!models!public! !
!ColorPresenter class categoriesFor: #icon!constants!public! !
!ColorPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

