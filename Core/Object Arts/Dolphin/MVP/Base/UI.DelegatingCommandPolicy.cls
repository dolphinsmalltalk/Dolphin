"Filed out from Dolphin Smalltalk 7"!

UI.CommandPolicy subclass: #'UI.DelegatingCommandPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DelegatingCommandPolicy guid: (Core.GUID fromString: '{aba1d303-40c8-44b1-8bc7-bd99e0efa423}')!
UI.DelegatingCommandPolicy comment: ''!
!UI.DelegatingCommandPolicy categoriesForClass!Unclassified! !
!UI.DelegatingCommandPolicy methodsFor!

visitPresenter: presenter
	"Visit the <presenter>, presenter, as the next in the chain-of-command, 
	adding its contributions to that chain. Answer the next <presenter> to visit,
	or answer the argument to get the default behaviour which is to move up
	to the parent presenter."

	^presenter addToCommandRoute: self! !
!UI.DelegatingCommandPolicy categoriesFor: #visitPresenter:!operations!private! !

