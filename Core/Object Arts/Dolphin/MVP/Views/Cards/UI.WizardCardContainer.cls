"Filed out from Dolphin Smalltalk"!

UI.AbstractCardContainer
	subclass: #'UI.WizardCardContainer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.WizardCardContainer guid: (Core.GUID fromString: '{87b4c71d-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.WizardCardContainer comment: 'A WizardCardContainer is a <cardView> intended for the creation of "wizard" style dialog boxes. No explicit visible navigation features are presented as they are with a CardContainer. Instead, a WizardCardContainer relies on its interception of navigation commands sent programmatically, from menus, or from buttons placed within the container.

Typically a WizardCardContainer will be used for wizard-style dialogs. For example, the ActiveX Component Wizard is implemented using a WizardCardContainer.'!
!UI.WizardCardContainer categoriesForClass!MVP-Views! !
!UI.WizardCardContainer class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.WizardCardContainer} 34 15 nil nil 34 2 8 1140850688 131073 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 853318 1 #{UI.CardLayout} 138 144 8 #() nil nil nil nil 170 192 560 nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 690 701 501 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 4 1 0 0] 8 #() 690 193 193 nil 27)! !
!UI.WizardCardContainer class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

