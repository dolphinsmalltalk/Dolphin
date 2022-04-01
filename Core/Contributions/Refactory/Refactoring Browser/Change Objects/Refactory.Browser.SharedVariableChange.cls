"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryChange subclass: #'Refactory.Browser.SharedVariableChange'
	instanceVariableNames: 'variable environmentName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.SharedVariableChange guid: (Core.GUID fromString: '{bf918303-56e4-4280-8d26-657909a74246}')!
Refactory.Browser.SharedVariableChange isNonInstantiable: true!
Refactory.Browser.SharedVariableChange comment: '`SharedVariableChange` is the class of Dolphin specific `RefactoryChange`s that add, remove, etc shared variables in namespaces. Shared, aka namespace, variables are static variables of classes/namespaces that are not owned by the class/namespace in which they reside (i.e. not class variables). They are typically independently owned by a package.

##Instance Variables:
  variable				`String`. Unqualified name of the shared variable to operate on
  environmentName	`BindingReference` to the `Namespace` for the shared variable

'!
!Refactory.Browser.SharedVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.SharedVariableChange methodsFor!

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
!Refactory.Browser.SharedVariableChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
environment!accessing!private! !
environmentName!accessing!private! !
executeNotifying:!applying!private! !
primitiveExecute!applying!private! !
setVariable:environment:!initializing!private! !
variable!accessing!private! !
!

