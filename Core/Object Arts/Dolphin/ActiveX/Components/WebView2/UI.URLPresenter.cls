"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.URLPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.URLPresenter guid: (Core.GUID fromString: '{a98215d9-bda9-4b36-8443-c6a72c049d71}')!
UI.URLPresenter comment: ''!
!UI.URLPresenter categoriesForClass!MVP-Presenters! !
!UI.URLPresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_WebView2)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.WebView2View} 38 #{Core.Array} 26 nil nil 50 2 8 1140916224 1 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 7 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 262145 nil nil nil nil nil 1286 #{WebView2.WebView2EnvironmentOptions} nil 15 nil 8 '110.0.1549.0' 5 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 354 1179 289 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 76 14 0 0 154 0 0 0] 8 #() 354 193 193 nil 29)! !
!UI.URLPresenter class categoriesForMethods!
defaultModel!models!public! !
defaultView!constants!public! !
resource_WebView2!public!resources-views! !
!

