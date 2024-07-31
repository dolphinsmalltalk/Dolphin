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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.WizardCardContainer} 38 #{Core.Array} 15 nil nil 50 2 8 1140850688 131073 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 0 nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 93 16 0 0 4 1 0 0] 193 80 8 '' 32 3 8 #() 518 #{Graphics.Point} 193 193 nil 27)! !

!UI.WizardCardContainer class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

