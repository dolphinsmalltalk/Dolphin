"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSemanticAnalyser subclass: #'Refactory.Browser.RBVariableAnalyser'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBVariableAnalyser guid: (Core.GUID fromString: '{2371b1c5-ddd9-47e2-8c5f-aafdc9c4407d}')!
Refactory.Browser.RBVariableAnalyser comment: ''!
!Refactory.Browser.RBVariableAnalyser categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBVariableAnalyser methodsFor!

visitQualifiedReferenceNode: aQualifiedReferenceNode
	aQualifiedReferenceNode binding.
	^aQualifiedReferenceNode!

visitVariableNode: aStVariableNode
	(currentScope lookupVariable: aStVariableNode)
		ifNotNil: 
			[:var |
			aStVariableNode variable: var.
			var]! !
!Refactory.Browser.RBVariableAnalyser categoriesForMethods!
visitQualifiedReferenceNode:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

