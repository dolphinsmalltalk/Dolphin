"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.ColorPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ColorPresenter guid: (Core.GUID fromString: '{87b4c6cd-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ColorPresenter comment: 'ColorPresenter is a <valuePresenter> that displays a <valueModel> onto a <color> value. A ColorPresenter can be connected to any <valueView> capable of displaying <color> values. Normally, this will be a <ColorView> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!

!UI.ColorPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Colour displays! !

!UI.ColorPresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ColorView} 38 #{Core.Array} 16 nil nil 50 2 8 1409286400 1 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.NeverSearchPolicy} 6 #{Graphics.Color} #blue 192 nil 5 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 124 15 0 0 50 0 0 0] 193 80 nil 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 27)! !

!UI.ColorPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

