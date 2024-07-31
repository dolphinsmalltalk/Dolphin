"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.AcceleratorPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AcceleratorPresenter guid: (Core.GUID fromString: '{87b4c6ca-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.AcceleratorPresenter comment: 'AcceleratorPresenter is a <valuePresenter> that displays a <valueModel> onto an <integer> key code that represening an accelerator key depression. Normally, an AcceleratorPresenter is connected to a <HotKey> view.'!

!UI.AcceleratorPresenter categoriesForClass!MVP-Presenters! !

!UI.AcceleratorPresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.HotKey} 38 #{Core.Array} 17 nil nil 50 2 8 1409351680 1 32 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 1 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{UI.AccelToHotKey} nil nil 1 1 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 104 15 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 27)! !

!UI.AcceleratorPresenter class categoriesForMethods!
defaultModel!constants!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

