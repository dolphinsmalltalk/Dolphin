"Filed out from Dolphin Smalltalk 7"!

StLexicalScope subclass: #StBlockScope
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StBlockScope guid: (GUID fromString: '{ee914772-f4ae-4569-87aa-95cdd445d7ef}')!
StBlockScope comment: ''!
!StBlockScope categoriesForClass!Kernel-Objects! !
!StBlockScope class methodsFor!

forScopeNode: anStBlockNode outer: anStLexicalScope
	^((anStBlockNode isInlined ifTrue: [StOptimizedBlockScope] ifFalse: [self]) new)
		setNode: anStBlockNode outer: anStLexicalScope;
		yourself! !
!StBlockScope class categoriesFor: #forScopeNode:outer:!instance creation!public! !

