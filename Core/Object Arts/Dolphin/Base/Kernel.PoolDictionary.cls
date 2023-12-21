"Filed out from Dolphin Smalltalk"!

Core.Dictionary
	variableSubclass: #'Kernel.PoolDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.PoolDictionary guid: (Core.GUID fromString: '{87b4c52a-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.PoolDictionary comment: ''!
!Kernel.PoolDictionary categoriesForClass!Collections-Unordered!System-Support! !
!Kernel.PoolDictionary methodsFor!

anonymousName
	^'Anon'!

asQualifiedReference
	^self fullName asQualifiedReference!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."

	^VariableBinding!

convertToSharedPool
	| identifier tempName poolClass pool |
	identifier := self name.
	tempName := (identifier , '_newPool') asSymbol.
	poolClass := SharedPool subclass: tempName.
	pool := poolClass classPool.
	self associationsDo: 
			[:each |
			each
				environment: poolClass;
				isClassVariable: true.
			pool add: each].
	poolClass basicClassPool: pool.
	(Smalltalk localBindingFor: identifier) value: poolClass.
	Smalltalk removeBindingFor: tempName.
	poolClass setName: identifier environment: poolClass environment.
	^poolClass!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self name displayOn: aPuttableStream!

environment
	"Answer the receiver's <Namespace> scope."

	^nil!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^self bindingFor: aString!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root."

	^nil!

fullNameFor: aString
	"Private - Answer the full name  of a variable with the specified local identifier, assumed to be in this namespace. This will be a (potentially) dot-separated path string that is bindable from any top-level namespace, including Smalltalk."

	^aString!

fullPath
	^nil!

includesEnvironment: anImportableNamespace
	^self == anImportableNamespace!

localScope
	"Answer the nearest name scope."

	^self!

name
	"Answer the receiver's name."

	^self unqualifiedName!

name: aSymbol 
	!

newAssociation: keyObject value: valueObject
	^(super newAssociation: keyObject value: valueObject)
		environment: self;
		yourself!

resolveLocalBindingPath: anArray
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the argument through nested namespaces, but considering only the directly defined variables.
	This is used for deterministic resolution of namespace imports."

	^self bindingFor: anArray single!

resolvePublicBinding: aBindingContext
	"Private - Resolve a binding with public visibility in the receiver's hierarchy, or among its local imports.
	This is used to find bindings for second and subsequent components of qualified names."

	^self bindingFor: aBindingContext identifier!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to the variable from a workspace for which the receiver is activing as a variable pool. Workspace variables are always unqualified."

	^aString!

unqualifiedName
	^self anonymousName! !
!Kernel.PoolDictionary categoriesForMethods!
anonymousName!constants!private! !
asQualifiedReference!converting!private! !
associationClass!constants!private! !
convertToSharedPool!development!private! !
displayOn:!displaying!public! !
environment!accessing!public! !
fullBindingFor:!binding!public! !
fullName!accessing!public! !
fullNameFor:!helpers!private! !
fullPath!accessing!namespaces!private! !
includesEnvironment:!public!testing! !
localScope!accessing!public! !
name!accessing!public! !
name:!accessing!private! !
newAssociation:value:!helpers!private! !
resolveLocalBindingPath:!bindings!private! !
resolvePublicBinding:!bindings!private! !
shortNameFor:!enquiries!private! !
unqualifiedName!accessing!private! !
!

Kernel.PoolDictionary methodProtocol: #bindingScope attributes: #(#readOnly) selectors: #(#environment #fullBindingFor: #localScope)!
Kernel.PoolDictionary methodProtocol: #importableNamespace attributes: #(#readOnly) selectors: #(#asQualifiedReference #fullName #includesEnvironment: #resolveLocalBindingPath: #resolvePublicBinding:)!

!Kernel.PoolDictionary class methodsFor!

forClass: aClass
	^self new
		environment: aClass;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!Kernel.PoolDictionary class categoriesForMethods!
forClass:!instance creation!public! !
named:!instance creation!public! !
!

