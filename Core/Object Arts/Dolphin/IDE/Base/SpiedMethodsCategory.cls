"Filed out from Dolphin Smalltalk 7"!

VirtualMethodCategory subclass: #SpiedMethodsCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SpiedMethodsCategory guid: (GUID fromString: '{9CF1D5A1-51EA-11D6-87E7-0010A70883E2}')!
SpiedMethodsCategory comment: ''!
!SpiedMethodsCategory categoriesForClass!Unclassified! !
!SpiedMethodsCategory methodsFor!

"sswI"includesMethod: aMethod

	^aMethod isSpy! !
!SpiedMethodsCategory categoriesFor: #includesMethod:!public! !

!SpiedMethodsCategory class methodsFor!

initialize
	"Private - Initialize the receiver.
		SSWSpiedMethodsCategory initialize.
	"

	self addPseud: (self newNamed: self pseudPrefix, 'method spies')!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self removePseud: self pseudPrefix, 'method spies'! !
!SpiedMethodsCategory class categoriesFor: #initialize!initializing!private! !
!SpiedMethodsCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

