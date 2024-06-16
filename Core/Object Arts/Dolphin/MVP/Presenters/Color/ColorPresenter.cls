"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #ColorPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ColorPresenter guid: (GUID fromString: '{87b4c6cd-026e-11d3-9fd7-00a0cc3e4a32}')!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ColorView) 34 16 nil nil 34 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1114118 ##(Smalltalk.NeverSearchPolicy) 327686 ##(Smalltalk.Color) #blue 560 nil 5 nil nil nil 416 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 252 7 0 0 50 0 0 0] 193 448 nil 416 690 #text: 34 1 8 '' 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )! !

!ColorPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

