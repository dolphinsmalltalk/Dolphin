"Filed out from Dolphin Smalltalk"!

Kernel.StaticVariableBinder
	subclass: #'Refactory.Browser.RBVariableAnalyser'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBVariableAnalyser guid: (Core.GUID fromString: '{2371b1c5-ddd9-47e2-8c5f-aafdc9c4407d}')!
Refactory.Browser.RBVariableAnalyser comment: '`Refactory.Browser.RBVariableAnalyser` is a specialised semantic analyser used by refactorings in Dolphin to bind variable references in parse trees. This is required to be able to detect variable binding differences before and after the application of refactoring changes, and allows the need for additional (or reduced) qualification of static variable names to be detected. Although the full `StSemanticAnalyser` could be used for this purpose, this class performs only the variable binding so runs more quickly and doesn''t throw errors for other code issues. Qualified references are also resolved where possible. An example application is in the `RenameClassRefactoring`, where it is necessary to resolve the original binding of any static variables and qualified references before the rename so that any affected static references can be rewritten to bind to the same variable after the rename is complete. '!
!Refactory.Browser.RBVariableAnalyser methodsFor!

undeclaredVariable: aVariableNode
	RefactoringError signal: 'Variable not bindable: ' , aVariableNode name!

visitQualifiedReferenceNode: aQualifiedReferenceNode
	aQualifiedReferenceNode binding.
	^aQualifiedReferenceNode! !
!Refactory.Browser.RBVariableAnalyser categoriesForMethods!
undeclaredVariable:!error handling!private! !
visitQualifiedReferenceNode:!public!visiting! !
!

