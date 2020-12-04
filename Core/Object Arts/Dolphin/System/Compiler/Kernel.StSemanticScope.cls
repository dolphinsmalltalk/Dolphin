"Filed out from Dolphin Smalltalk 7"!

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

temps
	self subclassResponsibility!

thisContextVariable
	^self shouldNotImplement! !
!Kernel.StSemanticScope categoriesFor: #isInlined!accessing!public! !
!Kernel.StSemanticScope categoriesFor: #lookupVariable:!operations!public! !
!Kernel.StSemanticScope categoriesFor: #outer!accessing!public! !
!Kernel.StSemanticScope categoriesFor: #outer:!accessing!public! !
!Kernel.StSemanticScope categoriesFor: #selfVariable!public! !
!Kernel.StSemanticScope categoriesFor: #superVariable!public! !
!Kernel.StSemanticScope categoriesFor: #temps!accessing!private! !
!Kernel.StSemanticScope categoriesFor: #thisContextVariable!public! !

