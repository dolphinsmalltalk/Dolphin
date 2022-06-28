"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSemanticAnalyser subclass: #'Kernel.StaticVariableBinder'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StaticVariableBinder guid: (Core.GUID fromString: '{ccf3dd67-8cdf-4b9e-98cf-37b83cfb8319}')!
Kernel.StaticVariableBinder comment: ''!
!Kernel.StaticVariableBinder methodsFor!

visitSelfVariableNode: aSelfVariableNode
	"Do nothing as we don't care about self references."

	!

visitSpecialVariableNode: aSpecialVariableNode
	"Do nothing as we don't care about special variable references."

	!

visitVariableNode: aVariableNode
	self bindVariable: aVariableNode! !
!Kernel.StaticVariableBinder categoriesForMethods!
visitSelfVariableNode:!public!visiting! !
visitSpecialVariableNode:!public!visiting! !
visitVariableNode:!public!visitor/double dispatching! !
!

