"Filed out from Dolphin Smalltalk"!

Object subclass: #StSemanticScope
	instanceVariableNames: 'outer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSemanticScope guid: (GUID fromString: '{6613bf75-bf16-4a7f-92f0-72a8a84738c9}')!
StSemanticScope isAbstract: true!
StSemanticScope comment: ''!
!StSemanticScope categoriesForClass!Kernel-Objects! !
!StSemanticScope methodsFor!

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
!StSemanticScope categoriesForMethods!
isInlined!accessing!public! !
lookupVariable:!operations!public! !
outer!accessing!public! !
outer:!accessing!public! !
selfVariable!public! !
superVariable!public! !
temps!accessing!private! !
thisContextVariable!public! !
!

