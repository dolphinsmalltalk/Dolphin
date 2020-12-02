"Filed out from Dolphin Smalltalk 7"!

Object subclass: #AbstractNamespace
	instanceVariableNames: ''
	classVariableNames: 'AbsentCookie'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractNamespace guid: (GUID fromString: '{e40d6edd-5883-4edc-b117-c508f7c8d47c}')!
AbstractNamespace comment: 'Behavior common to all <Namespace>s.

Not sure it will be necessary to retain this. Classes are namespaces, so it should be possible to push most functionality up to Class.

Terminology:

Absolute name - Fully qualified name including ''Root.Smalltalk''
Fully qualified name - Fully qualified name from ''Smalltalk''
'!
!AbstractNamespace categoriesForClass!Kernel-Objects! !
!AbstractNamespace class methodsFor!

newBindingContextForIdentifier: aString
	^BindingContext source: self identifier: aString!

resolveImportedBinding: aBindingContext
	"Private - Search imported namespaces for a binding that matches the identifier in the <BindingContext> supplied."

	^(self resolveLocallyImportedBinding: aBindingContext)
		ifNil: [self environment resolveImportedBinding: aBindingContext]!

resolveLocalIdentifier: aString
	"Private - Attempt to find a binding for the specified unqualified name in the scope of the receiver or any of its enclosing namespace, ignoring imports."

	^(self bindingFor: aString) ifNil: [self environment resolveLocalIdentifier: aString]!

resolveLocallyImportedBinding: aBindingContext
	"Private - Search the directly imported namespaces for a binding that matches the identifier in the <BindingContext> supplied."

	^1 to: imports size
		do: 
			[:i |
			| each |
			each := imports at: i.
			(aBindingContext visitImport: each from: self)
				ifNotNil: [:namespace | (namespace resolvePublicBinding: aBindingContext) ifNotNil: [:binding | ^binding]]].
	^nil!

resolveUnqualifiedName: aString
	"Private - Attempt to find a binding for the specified unqualified name in the scope of the receiver. The binding resolution rules are:
		1. Locally defined variables
		2. Locally defined variables of enclosing namespace
		3. The local and superclass variables of imported namespaces (shared pools in old money)
		4. The local and superclass variables of the imported namespaces of enclosing namespaces.
	The search for a locally defined variable in the namespace hierarchy cannot encounter cycles. Once the imported namespaces are brought into the mix, however, we can end up revisiting the same namespace more than once, and there might also be cycles in the import paths. Obviously we only ever want to visit each reachable namespace once for each type of search. This is achieved by maintaining a visited set in a binding context object.
	Namespace imports can be public or private. Private imports are only visited for searches initiated in the importee. Variables can also be private, in which case they can only be resolved locally."

	^(self resolveLocalIdentifier: aString)
		ifNil: [self resolveImportedBinding: (self newBindingContextForIdentifier: name)]! !
!AbstractNamespace class categoriesFor: #newBindingContextForIdentifier:!binding!private! !
!AbstractNamespace class categoriesFor: #resolveImportedBinding:!binding!private! !
!AbstractNamespace class categoriesFor: #resolveLocalIdentifier:!binding!private! !
!AbstractNamespace class categoriesFor: #resolveLocallyImportedBinding:!binding!private! !
!AbstractNamespace class categoriesFor: #resolveUnqualifiedName:!binding!private! !

