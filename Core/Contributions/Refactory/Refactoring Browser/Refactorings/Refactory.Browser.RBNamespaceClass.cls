"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBClass subclass: #'Refactory.Browser.RBNamespaceClass'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBNamespaceClass guid: (Core.GUID fromString: '{35f11892-77d8-41e3-b3b1-679396a71df6}')!
Refactory.Browser.RBNamespaceClass comment: ''!
!Refactory.Browser.RBNamespaceClass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBNamespaceClass methodsFor!

addClass: aRBClass
	self bindings add: ((RBVariableBinding name: aRBClass unqualifiedName environment: self)
				setFlags: 0;
				value: aRBClass;
				yourself)!

baseEnvironmentName
	"See Class>>baseEnvironment"
	
	^#Root!

environment
	^self unqualifiedName == #Root ifFalse: [self basicEnvironment]!

hierarchyBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses."

	^self localBindingFor: aString!

removeClass: aRBClass
	self removeBindingFor: aRBClass unqualifiedName!

resolveImportedBinding: aBindingContext
	"Private - Search imported namespaces for a binding that matches the identifier in the <BindingContext> supplied. The search proceeds up through the class hierarchy (i.e. imports in the class hierarchy are inherited), and then out to the imports of the enclosing namespace. Imports into the enclosing namespaces of superclasses are not searched."

	(self resolveLocallyImportedBinding: aBindingContext) ifNotNil: [:var | ^var].
	^self environment ifNotNil: [:env | env resolveImportedBinding: aBindingContext]! !
!Refactory.Browser.RBNamespaceClass categoriesForMethods!
addClass:!public! !
baseEnvironmentName!accessing!public! !
environment!accessing!public! !
hierarchyBindingFor:!bindings!public! !
removeClass:!public! !
resolveImportedBinding:!binding!private! !
!

Refactory.Browser.RBNamespaceClass methodProtocol: #bindingScope attributes: #(#readOnly) selectors: #(#environment #fullBindingFor: #localScope)!

