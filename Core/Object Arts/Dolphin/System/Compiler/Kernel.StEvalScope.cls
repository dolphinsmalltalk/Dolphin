"Filed out from Dolphin Smalltalk 7"!

Kernel.StSemanticScope subclass: #'Kernel.StEvalScope'
	instanceVariableNames: 'pools'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StEvalScope guid: (Core.GUID fromString: '{c90dad3d-8211-445e-aa23-907eee35e6b8}')!
Kernel.StEvalScope comment: ''!
!Kernel.StEvalScope categoriesForClass!Kernel-Objects! !
!Kernel.StEvalScope methodsFor!

lookupVariable: anStVariableNode
	"Lookup and return an <StVariable> describing the variable definition in this scope matching
	the variable reference specified by the <StVariableNode> argument."

	| identifier |
	identifier := anStVariableNode name.
	pools do: 
			[:each |
			(each bindingFor: identifier) ifNotNil: [:binding | ^StStaticVariable scope: self binding: binding]].
	^outer lookupVariable: anStVariableNode!

setPools: anArray
	pools := anArray! !
!Kernel.StEvalScope categoriesFor: #lookupVariable:!operations!public! !
!Kernel.StEvalScope categoriesFor: #setPools:!initializing!private! !

!Kernel.StEvalScope class methodsFor!

pools: pools
	^self new setPools: pools! !
!Kernel.StEvalScope class categoriesFor: #pools:!instance creation!public! !

