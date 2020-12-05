"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryChange subclass: #'Refactory.Browser.DolphinGlobalChange'
	instanceVariableNames: 'variable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.DolphinGlobalChange guid: (Core.GUID fromString: '{bf918303-56e4-4280-8d26-657909a74246}')!
Refactory.Browser.DolphinGlobalChange isNonInstantiable: true!
Refactory.Browser.DolphinGlobalChange comment: 'DolphinGlobalChange is the class of Dolphin specific <RefactoryChange>s that add, remove, etc global variables in the system dictionary

Instance Variables:
	variable		<String>. Name of the variable to operate on

'!
!Refactory.Browser.DolphinGlobalChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.DolphinGlobalChange methodsFor!

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
!Refactory.Browser.DolphinGlobalChange categoriesFor: #=!comparing!public! !
!Refactory.Browser.DolphinGlobalChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.DolphinGlobalChange categoriesFor: #executeNotifying:!private! !
!Refactory.Browser.DolphinGlobalChange categoriesFor: #primitiveExecute!operations!private! !
!Refactory.Browser.DolphinGlobalChange categoriesFor: #variable!accessing!private! !
!Refactory.Browser.DolphinGlobalChange categoriesFor: #variable:!accessing!private! !

