"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.ColorPresenter'
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ColorView) 34 16 nil nil 34 2 8 1409286400 1 416 918598 2 ##(UI.ValueHolder) nil false 1441798 ##(Kernel.NeverSearchPolicy) 917510 ##(Graphics.Color) #blue 560 nil 5 nil nil nil 416 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 738 251 81 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 50 0 0 0] 8 #() 738 193 193 nil 27)! !
!UI.ColorPresenter class categoriesFor: #defaultModel!models!public! !
!UI.ColorPresenter class categoriesFor: #icon!constants!public! !
!UI.ColorPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

