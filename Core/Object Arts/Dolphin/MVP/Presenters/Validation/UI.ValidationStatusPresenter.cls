"Filed out from Dolphin Smalltalk"!

UI.ValidationResultPresenter
	subclass: #'UI.ValidationStatusPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ValidationStatusPresenter guid: (Core.GUID fromString: '{209cf8e4-b98e-4d6d-9036-8e6b396d5509}')!

UI.ValidationStatusPresenter comment: '`ValidationStatusPresenter` is a `ValidationResultPresenter` that displays a `ValidationResult` using a sub-view. The sub-view is assumed to be named ''validationStatus'' and is typically a `StatusBarItem`.'!

!UI.ValidationStatusPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.StatusBar} 38 #{Core.Array} 21 nil nil 50 2 8 1409288204 1 32 nil nil nil 5 nil nil nil 32 nil nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 32 nil 518 #{Core.Message} #displayString 8 #() 194 #iconImageIndex 8 #() nil 8 'validationResult' nil nil nil 50 1 176 1094 1 #{UI.StatusBarNullItem} 8705 1 32 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 87 16 0 0 30 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 29)! !

!UI.ValidationStatusPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

