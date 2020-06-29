"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StSemanticScope
	instanceVariableNames: 'outer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StSemanticScope categoriesFor: #isInlined!accessing!public! !
!StSemanticScope categoriesFor: #lookupVariable:!operations!public! !
!StSemanticScope categoriesFor: #outer!accessing!public! !
!StSemanticScope categoriesFor: #outer:!accessing!public! !
!StSemanticScope categoriesFor: #selfVariable!public! !
!StSemanticScope categoriesFor: #superVariable!public! !
!StSemanticScope categoriesFor: #temps!accessing!private! !
!StSemanticScope categoriesFor: #thisContextVariable!public! !

