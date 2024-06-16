"Filed out from Dolphin Smalltalk"!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.WizardCardContainer) 34 15 nil nil 34 2 8 1140850688 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 656710 1 ##(Smalltalk.CardLayout) 138 144 8 #() nil nil nil nil 170 192 560 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 193 448 8 '' 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )! !

!WizardCardContainer class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

