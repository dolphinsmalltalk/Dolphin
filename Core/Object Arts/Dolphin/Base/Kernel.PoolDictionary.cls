"Filed out from Dolphin Smalltalk"!

Core.Dictionary variableSubclass: #'Kernel.PoolDictionary'
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
	^self name asQualifiedReference!

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

	^Smalltalk!

fullNameFor: aString 
	^aString!

includesEnvironment: anImportableNamespace
	^self == anImportableNamespace!

name
	"Answer the receiver's name."

	^self unqualifiedName!

name: aSymbol 
	!

newAssociation: keyObject value: valueObject
	^(super newAssociation: keyObject value: valueObject)
		environment: self;
		yourself!

resolvePublicBinding: aBindingContext
	"Private - Resolve a binding with public visibility in the receiver's hierarchy, or among its local imports.
	This is used to find bindings for second and subsequent components of qualified names."

	^self bindingFor: aBindingContext identifier!

unqualifiedName
	^self anonymousName! !
!Kernel.PoolDictionary categoriesForMethods!
anonymousName!constants!private! !
asQualifiedReference!private! !
associationClass!constants!private! !
convertToSharedPool!development!private! !
displayOn:!public! !
environment!accessing!public! !
fullNameFor:!helpers!private! !
includesEnvironment:!public!testing! !
name!accessing!public! !
name:!accessing!private! !
newAssociation:value:!helpers!private! !
resolvePublicBinding:!private! !
unqualifiedName!accessing!private! !
!

Kernel.PoolDictionary methodProtocol: #importableNamespace attributes: #(#readOnly) selectors: #(#asQualifiedReference #includesEnvironment: #resolvePublicBinding:)!

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

