"Filed out from Dolphin Smalltalk 7"!

GeneralBindingReference subclass: #LiteralBindingReference
	instanceVariableNames: 'method'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LiteralBindingReference guid: (GUID fromString: '{d74ca6b9-93a4-4d7b-b774-1078b109aaa8}')!
LiteralBindingReference comment: 'Binding references created by the compiler and considered to be a reference relative to the namespace of the method (which is normally that of the class that owns the method).'!
!LiteralBindingReference categoriesForClass!System-Namespaces! !
!LiteralBindingReference methodsFor!

home
	"Answer the home <Namespace> to which this binding reference is relative."

	^method environment!

isLiteral
	"Answer whether or not the receiver has a literal representation (probably its printString) which is directly recognised by the Compiler"

	^true!

method
	"Answer the <CompiledCode> that owns this literal binding reference."

	^method!

method: aCompiledCode
	method := aCompiledCode!

species
	"Answer the generic class of the receiver."

	^BindingReference! !
!LiteralBindingReference categoriesFor: #home!accessing!public! !
!LiteralBindingReference categoriesFor: #isLiteral!public!testing! !
!LiteralBindingReference categoriesFor: #method!accessing!public! !
!LiteralBindingReference categoriesFor: #method:!accessing!private! !
!LiteralBindingReference categoriesFor: #species!accessing!public! !

!LiteralBindingReference class methodsFor!

initialize
	VMLibrary default
		registryAt: self name put: self;
		primRegistryAt: 65 put: #pathString:!

uninitialize
	VMLibrary default
		registryAt: self name put: nil;
		primRegistryAt: 65 put: nil! !
!LiteralBindingReference class categoriesFor: #initialize!class initialization!development!public! !
!LiteralBindingReference class categoriesFor: #uninitialize!class hierarchy-removing!private! !

