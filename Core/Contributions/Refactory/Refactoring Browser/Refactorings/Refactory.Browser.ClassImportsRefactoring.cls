"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring subclass: #'Refactory.Browser.ClassImportsRefactoring'
	instanceVariableNames: 'class import'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassImportsRefactoring guid: (Core.GUID fromString: '{7e59c514-a85b-4274-afc0-5e70cad7b638}')!
Refactory.Browser.ClassImportsRefactoring isNonInstantiable: true!
Refactory.Browser.ClassImportsRefactoring comment: ''!
!Refactory.Browser.ClassImportsRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ClassImportsRefactoring methodsFor!

className: aString
	super className: aString.
	class := self model classNamed: aString!

import: aBindingReference class: aClass
	class := self classObjectFor: aClass.
	className := class fullName.
	import := (aBindingReference referenceInModel: self model) asFullyQualifiedReference!

importsPrecondition
	^self subclassResponsibility!

modifyClassImports
	self subclassResponsibility!

preconditions
	^((RBCondition isMetaclass: class) errorMacro: 'Class must <1?not :>be a metaclass') not
		& (RBCondition isClassBinding: import)
			& (RBCondition withBlock: 
						[| ns |
						ns := import value.
						ns ~~ self model rootNamespace and: [ns metaclass conformsToProtocol: #importableNamespace]]
					errorString: import displayString , ' is <1?:not >an importable namespace')
			& self importsPrecondition!

transform
	| externalRefs |
	externalRefs := OrderedCollection new.
	class withAllSubclasses do: 
			[:each |
			externalRefs
				addAll: each methodsReferencingExternals;
				addAll: each metaclass methodsReferencingExternals].
	externalRefs do: [:each | each boundParseTree].
	self modifyClassImports.
	self rewriteStaleVariableReferences: externalRefs! !
!Refactory.Browser.ClassImportsRefactoring categoriesForMethods!
className:!initializing!public! !
import:class:!initializing!private! !
importsPrecondition!private! !
modifyClassImports!private!transforming! !
preconditions!public! !
transform!public!transforming! !
!

