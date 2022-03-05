"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #URLPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
URLPresenter guid: (GUID fromString: '{a98215d9-bda9-4b36-8443-c6a72c049d71}')!
URLPresenter comment: ''!
!URLPresenter categoriesForClass!MVP-Presenters! !
!URLPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^'about:blank' copy asValue!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'WebView2'!

resource_WebView2
	"Answer the literal data from which the 'WebView2' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_WebView2)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.WebView2View) 34 21 nil nil 34 2 8 1140916224 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 7 nil nil nil 416 nil nil 852486 ##(Smalltalk.NullConverter) nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 12287 21 690 1179 289 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 76 26 0 0 154 0 0 0] 8 #() 690 193 193 nil 27 )! !
!URLPresenter class categoriesForMethods!
defaultModel!models!public! !
defaultView!constants!public! !
resource_WebView2!public!resources-views! !
!

