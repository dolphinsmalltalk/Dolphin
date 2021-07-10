"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryChange subclass: #'Tools.SharedVariableChange'
	instanceVariableNames: 'variable environmentName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SharedVariableChange guid: (Core.GUID fromString: '{bf918303-56e4-4280-8d26-657909a74246}')!
Tools.SharedVariableChange isNonInstantiable: true!
Tools.SharedVariableChange comment: '`SharedVariableChange` is the class of Dolphin specific `RefactoryChange`s that add, remove, etc shared variables in namespaces.

Instance Variables:
	variable			`String`. Unqualified name of the shared variable to operate on
	environmentName	`BindingReference` to the `Namespace` for the shared variable

'!
!Tools.SharedVariableChange categoriesForClass!Refactory-Change Objects! !
!Tools.SharedVariableChange methodsFor!

= aDolphinGlobalChange
	self class = aDolphinGlobalChange class ifFalse: [^false].
	^variable = aDolphinGlobalChange variable and: [environmentName = aDolphinGlobalChange environmentName]!

asUndoOperation
	^self subclassResponsibility!

environment
	^environmentName value!

environmentName
	^environmentName!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

primitiveExecute
	^self subclassResponsibility!

setVariable: aString environment: aNamespace
	variable := aString.
	environmentName := aNamespace asQualifiedReference.
	^self!

variable
	^variable! !
!Tools.SharedVariableChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
environment!accessing!private! !
environmentName!accessing!private! !
executeNotifying:!private! !
primitiveExecute!operations!private! !
setVariable:environment:!initializing!private! !
variable!accessing!private! !
!

