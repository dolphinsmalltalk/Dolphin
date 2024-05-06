"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #AcceleratorPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AcceleratorPresenter guid: (GUID fromString: '{87b4c6ca-026e-11d3-9fd7-00a0cc3e4a32}')!

AcceleratorPresenter comment: 'AcceleratorPresenter is a <valuePresenter> that displays a <valueModel> onto an <integer> key code that represening an accelerator key depression. Normally, an AcceleratorPresenter is connected to a <HotKey> view.'!

!AcceleratorPresenter categoriesForClass!MVP-Presenters! !

!AcceleratorPresenter class methodsFor!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.HotKey) 34 17 nil nil 34 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1904328048 852486 ##(Smalltalk.AccelToHotKey) nil nil 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 738 211 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 232 7 0 0 35 0 0 0] 8 #() 738 193 193 nil 27 )! !

!AcceleratorPresenter class categoriesForMethods!
defaultModel!constants!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

