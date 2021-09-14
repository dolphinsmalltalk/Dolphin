"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBClass subclass: #'Refactory.Browser.RBNamespaceClass'
	instanceVariableNames: 'removedVariables newVariables'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBNamespaceClass guid: (Core.GUID fromString: '{35f11892-77d8-41e3-b3b1-679396a71df6}')!
Refactory.Browser.RBNamespaceClass comment: ''!
!Refactory.Browser.RBNamespaceClass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBNamespaceClass methodsFor!

addClass: aRBClass
	self addVariableNamed: aRBClass unqualifiedName value: aRBClass!

addVariableNamed: aSymbol value: anObject
	removedVariables remove: aSymbol ifAbsent: nil.
	newVariables add: (VariableBinding key: aSymbol value: anObject)!

baseEnvironmentName
	"See Class>>baseEnvironment"
	
	^name = 'Root' ifFalse: [#Root]!

environment
	^self environmentName ifNotNil: [:envName | model classNamed: envName]!

hierarchyBindingFor: aString
	"Private - Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses."

	^self localBindingFor: aString!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^(removedVariables includes: aString)
		ifFalse: 
			[(newVariables bindingFor: aString)
				ifNil: 
					[(self realClass localBindingFor: aString)
						ifNotNil: 
							[:realBinding |
							(VariableBinding key: realBinding key value: (model classFor: realBinding value))
								environment: self;
								setFlags: realBinding flags;
								yourself]]]!

removeClass: aRBClass
	self removeVariableNamed: aRBClass unqualifiedName!

removeVariableNamed: aSymbol
	newVariables removeKey: aSymbol ifAbsent: nil.
	removedVariables add: aSymbol!

resolveImportedBinding: aBindingContext
	"Private - Search imported namespaces for a binding that matches the identifier in the <BindingContext> supplied. The search proceeds up through the class hierarchy (i.e. imports in the class hierarchy are inherited), and then out to the imports of the enclosing namespace. Imports into the enclosing namespaces of superclasses are not searched."

	(self resolveLocallyImportedBinding: aBindingContext) ifNotNil: [:binding | ^binding].
	^self environment ifNotNil: [:env | env resolveImportedBinding: aBindingContext]!

setName: aSymbol 
	name := aSymbol.
	newVariables := Dictionary new.
	removedVariables := Set new! !
!Refactory.Browser.RBNamespaceClass categoriesForMethods!
addClass:!public! !
addVariableNamed:value:!public! !
baseEnvironmentName!accessing!public! !
environment!accessing!public! !
hierarchyBindingFor:!bindings!private! !
localBindingFor:!bindings!public! !
removeClass:!public! !
removeVariableNamed:!public! !
resolveImportedBinding:!binding!private! !
setName:!initializing!private! !
!

