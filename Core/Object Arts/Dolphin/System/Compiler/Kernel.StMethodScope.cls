"Filed out from Dolphin Smalltalk 7"!

Kernel.StLexicalScope subclass: #'Kernel.StMethodScope'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StMethodScope guid: (Core.GUID fromString: '{c3f6496d-702b-4c3b-91b9-3864d62dbca8}')!
Kernel.StMethodScope comment: ''!
!Kernel.StMethodScope categoriesForClass!Kernel-Objects! !
!Kernel.StMethodScope class methodsFor!

forScopeNode: anStMethodNode outer: anStLexicalScope
	^(self new)
		setNode: anStMethodNode outer: anStLexicalScope;
		yourself! !
!Kernel.StMethodScope class categoriesFor: #forScopeNode:outer:!instance creation!public! !

