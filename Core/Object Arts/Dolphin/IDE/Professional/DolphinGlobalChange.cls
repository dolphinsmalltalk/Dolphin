"Filed out from Dolphin Smalltalk"!

RefactoryChange subclass: #DolphinGlobalChange
	instanceVariableNames: 'variable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinGlobalChange guid: (GUID fromString: '{bf918303-56e4-4280-8d26-657909a74246}')!
DolphinGlobalChange isAbstract: true!
DolphinGlobalChange comment: 'DolphinGlobalChange is the class of Dolphin specific <RefactoryChange>s that add, remove, etc global variables in the system dictionary

Instance Variables:
	variable		<String>. Name of the variable to operate on

'!
!DolphinGlobalChange categoriesForClass!Refactory-Change Objects! !
!DolphinGlobalChange methodsFor!

= aDolphinGlobalChange 
	self class = aDolphinGlobalChange class ifFalse: [^false].
	^variable = aDolphinGlobalChange variable!

asUndoOperation
	^self subclassResponsibility!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

primitiveExecute
	^self subclassResponsibility!

variable
	^variable!

variable: aString 
	variable := aString! !
!DolphinGlobalChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
executeNotifying:!private! !
primitiveExecute!operations!private! !
variable!accessing!private! !
variable:!accessing!private! !
!

