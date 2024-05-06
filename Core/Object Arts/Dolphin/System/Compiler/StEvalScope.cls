"Filed out from Dolphin Smalltalk"!

StSemanticScope subclass: #StEvalScope
	instanceVariableNames: 'pools'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StEvalScope guid: (GUID fromString: '{c90dad3d-8211-445e-aa23-907eee35e6b8}')!

StEvalScope comment: ''!

!StEvalScope categoriesForClass!Kernel-Objects! !

!StEvalScope methodsFor!

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

!StEvalScope categoriesForMethods!
lookupVariable:!operations!public! !
setPools:!initializing!private! !
!

!StEvalScope class methodsFor!

pools: pools
	^self new setPools: pools! !

!StEvalScope class categoriesForMethods!
pools:!instance creation!public! !
!

