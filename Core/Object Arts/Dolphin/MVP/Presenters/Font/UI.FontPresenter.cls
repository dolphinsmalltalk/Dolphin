"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.FontPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FontPresenter guid: (Core.GUID fromString: '{87b4c6cf-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FontPresenter comment: 'FontPresenter is a <valuePresenter> that displays a <valueModel> onto a <Font> value. A FontPresenter can be connected to any <valueView> capable of displaying <Font> values. Normally, this will be a <FontView> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!UI.FontPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Font displays! !
!UI.FontPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Font system asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.FontView} 34 17 nil nil 34 2 8 1409286400 1 416 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 416 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 690 571 51 416 642 #text: 34 1 8 'Default' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 28 25 0 0 35 0 0 0] 8 #() 690 193 193 nil 27)! !
!UI.FontPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

