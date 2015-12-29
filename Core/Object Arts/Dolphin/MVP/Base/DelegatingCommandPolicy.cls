"Filed out from Dolphin Smalltalk X6"!

CommandPolicy subclass: #DelegatingCommandPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DelegatingCommandPolicy guid: (GUID fromString: '{ABA1D303-40C8-44B1-8BC7-BD99E0EFA423}')!
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

