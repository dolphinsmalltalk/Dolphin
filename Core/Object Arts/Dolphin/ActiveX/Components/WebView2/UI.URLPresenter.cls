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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.WebView2View} 34 26 nil nil 34 2 8 1140916224 1 416 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 7 nil nil nil 416 nil nil 1049094 #{UI.NullConverter} nil nil 262145 nil nil nil nil nil 2295046 #{WebView2.WebView2EnvironmentOptions} nil 15 nil 8 '110.0.1549.0' 5 nil nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 6143 21 722 1179 289 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 76 14 0 0 154 0 0 0] 8 #() 722 193 193 nil 29)! !
!UI.URLPresenter class categoriesForMethods!
defaultModel!models!public! !
defaultView!constants!public! !
resource_WebView2!public!resources-views! !
!

