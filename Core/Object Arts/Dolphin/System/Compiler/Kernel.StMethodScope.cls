"Filed out from Dolphin Smalltalk"!

Kernel.StLexicalScope
	subclass: #'Kernel.StMethodScope'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StMethodScope guid: (Core.GUID fromString: '{c3f6496d-702b-4c3b-91b9-3864d62dbca8}')!
Kernel.StMethodScope comment: ''!
!Kernel.StMethodScope categoriesForClass!Kernel-Objects! !
!Kernel.StMethodScope methodsFor!

environment: aNamespace
	super environment: aNamespace.
	node environment: aNamespace!

methodScope
	^self! !
!Kernel.StMethodScope categoriesForMethods!
environment:!accessing!public! !
methodScope!accessing!public! !
!

!Kernel.StMethodScope class methodsFor!

forScopeNode: aStMethodNode outer: aStLexicalScope
	^self new
		node: aStMethodNode outer: aStLexicalScope;
		yourself! !
!Kernel.StMethodScope class categoriesForMethods!
forScopeNode:outer:!instance creation!public! !
!

