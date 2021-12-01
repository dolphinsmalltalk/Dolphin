"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.StSemanticScope'
	instanceVariableNames: 'outer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSemanticScope guid: (Core.GUID fromString: '{6613bf75-bf16-4a7f-92f0-72a8a84738c9}')!
Kernel.StSemanticScope isNonInstantiable: true!
Kernel.StSemanticScope comment: ''!
!Kernel.StSemanticScope categoriesForClass!Kernel-Objects! !
!Kernel.StSemanticScope methodsFor!

classScope
	^outer classScope!

environment: aNamespace
	outer environment: aNamespace!

isInlined
	^false!

lookupVariable: anStVariableNode
	"Lookup and return an <StVariable> describing the variable definition in this scope matching
	the variable reference specified by the <StVariableNode> argument."

	^self subclassResponsibility!

outer
	^outer!

outer: anStSemanticScope
	outer := anStSemanticScope!

selfVariable
	^outer selfVariable!

superVariable
	^outer superVariable!

thisContextVariable
	^self shouldNotImplement! !
!Kernel.StSemanticScope categoriesForMethods!
classScope!accessing!public! !
environment:!accessing!public! !
isInlined!accessing!public! !
lookupVariable:!operations!public! !
outer!accessing!public! !
outer:!accessing!public! !
selfVariable!public! !
superVariable!public! !
thisContextVariable!public! !
!

