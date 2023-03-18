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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.HotKey} 34 17 nil nil 34 2 8 1409351680 1 416 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 1 917510 #{Graphics.Color} #default nil 5 nil nil nil 416 nil 8 1815486448 1049094 #{UI.AccelToHotKey} nil nil 1 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 722 211 51 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 104 24 0 0 35 0 0 0] 8 #() 722 193 193 nil 27)! !
!UI.AcceleratorPresenter class categoriesForMethods!
defaultModel!constants!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

