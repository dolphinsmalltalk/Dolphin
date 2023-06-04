"Filed out from Dolphin Smalltalk"!

Kernel.SemanticAnalyser
	subclass: #'Kernel.StaticVariableBinder'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StaticVariableBinder guid: (Core.GUID fromString: '{ccf3dd67-8cdf-4b9e-98cf-37b83cfb8319}')!
Kernel.StaticVariableBinder comment: '`Kernel.StaticVariableAnalyser` is a class of fast /minimal semantic analysers that guarantee only to bind any static variable references in the parse tree. In order to do this they do have to record all instance and local variable definitions (since these bind with higher priority than ambiguously defined static variables). Local local variables are bound as a side effect, but this should not be assumed and may change in a future release.'!
!Kernel.StaticVariableBinder methodsFor!

visitSelfVariableNode: aSelfVariableNode
	"Do nothing as we don't care about self references."

	!

visitSpecialVariableNode: aSpecialVariableNode
	"Do nothing as we don't care about special variable references."

	! !
!Kernel.StaticVariableBinder categoriesForMethods!
visitSelfVariableNode:!public!visiting! !
visitSpecialVariableNode:!public!visiting! !
!

