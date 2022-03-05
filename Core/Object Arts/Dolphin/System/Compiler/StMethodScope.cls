"Filed out from Dolphin Smalltalk"!

StLexicalScope subclass: #StMethodScope
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StMethodScope guid: (GUID fromString: '{c3f6496d-702b-4c3b-91b9-3864d62dbca8}')!
StMethodScope comment: ''!
!StMethodScope categoriesForClass!Kernel-Objects! !
!StMethodScope class methodsFor!

forScopeNode: anStMethodNode outer: anStLexicalScope
	^(self new)
		setNode: anStMethodNode outer: anStLexicalScope;
		yourself! !
!StMethodScope class categoriesForMethods!
forScopeNode:outer:!instance creation!public! !
!

