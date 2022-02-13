"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSemanticAnalyser subclass: #'Refactory.Browser.RBVariableAnalyser'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBVariableAnalyser guid: (Core.GUID fromString: '{2371b1c5-ddd9-47e2-8c5f-aafdc9c4407d}')!
Refactory.Browser.RBVariableAnalyser comment: '`RBVariableAnalyser` is a specialised semantic analyser used by refactorings to bind variable references in parse trees. Although the full `StSemanticAnalyser` could be used for this purpose, this class performs only the variable binding so runs much more quickly and doesn''t throw errors for other code issues. An example application is in the `RenameClassRefactoring`, where it is necessary to resolve the original binding of any static variables before the rename so any affected static variable references can be rewritten to bind to the same variable after the rename is complete. '!
!Refactory.Browser.RBVariableAnalyser categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBVariableAnalyser methodsFor!

visitQualifiedReferenceNode: aQualifiedReferenceNode
	aQualifiedReferenceNode binding.
	^aQualifiedReferenceNode!

visitSelfVariableNode: anStSelfVariableNode
	"Do nothing as we don't care about self references."!

visitSpecialVariableNode: anStSpecialVariableNode
	"Do nothing as we don't care about special variable references."!

visitVariableNode: aStVariableNode
	(aStVariableNode lookupInScope: currentScope) ifNotNil: [:var | aStVariableNode variable: var]! !
!Refactory.Browser.RBVariableAnalyser categoriesForMethods!
visitQualifiedReferenceNode:!public!visiting! !
visitSelfVariableNode:!public!visiting! !
visitSpecialVariableNode:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

