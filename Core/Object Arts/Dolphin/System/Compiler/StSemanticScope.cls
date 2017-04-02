"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StSemanticScope
	instanceVariableNames: 'outer flags'
	classVariableNames: 'EmptyBlockMask FarReturnMask NeedsOuter OptimizedBlockMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSemanticScope guid: (GUID fromString: '{6613bf75-bf16-4a7f-92f0-72a8a84738c9}')!
StSemanticScope addClassConstant: 'EmptyBlockMask' value: 2!
StSemanticScope addClassConstant: 'FarReturnMask' value: 8!
StSemanticScope addClassConstant: 'NeedsOuter' value: 16!
StSemanticScope addClassConstant: 'OptimizedBlockMask' value: 4!
StSemanticScope comment: ''!
!StSemanticScope categoriesForClass!Kernel-Objects! !
!StSemanticScope methodsFor!

initialize
	flags := 0!

isInlined
	^false!

lookupVariable: aString
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
!StSemanticScope categoriesFor: #initialize!initializing!private! !
!StSemanticScope categoriesFor: #isInlined!accessing!public! !
!StSemanticScope categoriesFor: #lookupVariable:!operations!public! !
!StSemanticScope categoriesFor: #outer!accessing!public! !
!StSemanticScope categoriesFor: #outer:!accessing!public! !
!StSemanticScope categoriesFor: #selfVariable!public! !
!StSemanticScope categoriesFor: #superVariable!public! !
!StSemanticScope categoriesFor: #temps!accessing!private! !
!StSemanticScope categoriesFor: #thisContextVariable!public! !

!StSemanticScope class methodsFor!

initialize
	self addClassConstant: 'EmptyBlockMask' value: 16r2.
	self addClassConstant: 'OptimizedBlockMask' value: 16r4.
	self addClassConstant: 'FarReturnMask' value: 16r8.
	self addClassConstant: 'NeedsOuter' value: 16r10! !
!StSemanticScope class categoriesFor: #initialize!class initialization!public! !

