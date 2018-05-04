"Filed out from Dolphin Smalltalk 7"!

AbstractCardContainer subclass: #WizardCardContainer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WizardCardContainer guid: (GUID fromString: '{87b4c71d-026e-11d3-9fd7-00a0cc3e4a32}')!
WizardCardContainer comment: 'A WizardCardContainer is a <cardView> intended for the creation of "wizard" style dialog boxes. No explicit visible navigation features are presented as they are with a CardContainer. Instead, a WizardCardContainer relies on its interception of navigation commands sent programmatically, from menus, or from buttons placed within the container.

Typically a WizardCardContainer will be used for wizard-style dialogs. For example, the ActiveX Component Wizard is implemented using a WizardCardContainer.'!
!WizardCardContainer categoriesForClass!MVP-Views! !
!WizardCardContainer class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(WizardCardContainer)  98 15 0 0 98 2 8 1140850688 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 416 655878 ##(CardLayout)  202 208 98 0 0 234 256 592 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  1 1 754 701 501 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 754 193 193 0 27 )! !
!WizardCardContainer class categoriesFor: #resource_Default_view!public!resources-views! !

