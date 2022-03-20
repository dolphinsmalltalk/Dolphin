"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring subclass: #'Refactory.Browser.AddImportRefactoring'
	instanceVariableNames: 'class import'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddImportRefactoring guid: (Core.GUID fromString: '{cb2e95e5-b56c-42ab-8b49-9d6c81248d43}')!
Refactory.Browser.AddImportRefactoring comment: ''!
!Refactory.Browser.AddImportRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AddImportRefactoring methodsFor!

addImport: aBindingReference to: aClass
	class := self classObjectFor: aClass.
	className := class fullName.
	import := (aBindingReference referenceInModel: self model) asFullyQualifiedReference!

addImportToClass
	class addImport: import!

className: aString
	super className: aString.
	class := self model classNamed: aString!

import: aNamespace into: aClass
	self addImport: (self classObjectFor: aNamespace) fullyQualifiedReference to: aClass!

preconditions
	^((RBCondition isMetaclass: class) errorMacro: 'Class must <1?not :>be a metaclass') not
		& (RBCondition isClassBinding: import)
			& (RBCondition withBlock: 
						[| ns |
						ns := import value.
						ns ~~ self model rootNamespace and: [ns metaclass conformsToProtocol: #importableNamespace]]
					errorString: import displayString , ' is <1?:not >an importable namespace')
			& (RBCondition withBlock: [(class importsNamespace: import) not]
					errorString: class displayString , ' <1?does not import:already imports> ' , import printString)!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addImport: ';
		print: import;
		nextPutAll: ' to: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	| externalRefs |
	externalRefs := OrderedCollection new.
	class withAllSubclasses do: 
			[:each |
			externalRefs
				addAll: each methodsReferencingExternals;
				addAll: each metaclass methodsReferencingExternals].
	externalRefs do: [:each | each boundParseTree].
	self addImportToClass.
	self rewriteStaleVariableReferences: externalRefs! !
!Refactory.Browser.AddImportRefactoring categoriesForMethods!
addImport:to:!initializing!private! !
addImportToClass!private!transforming! !
className:!initializing!public! !
import:into:!initializing!private! !
preconditions!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.AddImportRefactoring class methodsFor!

addImport: aBindingReference to: aClass
	^self new addImport: aBindingReference to: aClass!

import: aNamespace into: aClass
	^self new import: aNamespace into: aClass!

model: aRBModel addImport: aBindingReference to: aClass
	^self new
		model: aRBModel;
		addImport: aBindingReference to: aClass!

model: aRBModel import: aNamespace into: aClass
	
	^self new
		model: aRBModel;
		import: aNamespace into: aClass! !
!Refactory.Browser.AddImportRefactoring class categoriesForMethods!
addImport:to:!public! !
import:into:!public! !
model:addImport:to:!public! !
model:import:into:!public! !
!

