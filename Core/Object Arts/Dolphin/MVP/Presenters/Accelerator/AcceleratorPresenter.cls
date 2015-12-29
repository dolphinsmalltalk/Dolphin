"Filed out from Dolphin Smalltalk X6"!

ValuePresenter subclass: #AcceleratorPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AcceleratorPresenter guid: (GUID fromString: '{87B4C6CA-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.HotKey)  98 17 0 0 98 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  1 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294904951 852486 ##(Smalltalk.AccelToHotKey)  0 0 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 786 211 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 224 5 0 0 35 0 0 0] 98 0 786 193 193 0 27 )! !
!AcceleratorPresenter class categoriesFor: #defaultModel!constants!public! !
!AcceleratorPresenter class categoriesFor: #icon!constants!public! !
!AcceleratorPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

