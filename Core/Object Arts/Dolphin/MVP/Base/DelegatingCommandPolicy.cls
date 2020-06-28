"Filed out from Dolphin Smalltalk 7"!

CommandPolicy subclass: #DelegatingCommandPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DelegatingCommandPolicy guid: (GUID fromString: '{aba1d303-40c8-44b1-8bc7-bd99e0efa423}')!
DelegatingCommandPolicy comment: ''!
!DelegatingCommandPolicy categoriesForClass!Unclassified! !
!DelegatingCommandPolicy methodsFor!

visitPresenter: presenter
	"Visit the <presenter>, presenter, as the next in the chain-of-command, 
	adding its contributions to that chain. Answer the next <presenter> to visit,
	or answer the argument to get the default behaviour which is to move up
	to the parent presenter."

	^presenter addToCommandRoute: self! !
!DelegatingCommandPolicy categoriesFor: #visitPresenter:!operations!private! !

