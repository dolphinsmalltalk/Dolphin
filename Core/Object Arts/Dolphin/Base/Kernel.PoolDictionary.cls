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
	Smalltalk removeLocalBindingFor: tempName.
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
!Kernel.PoolDictionary categoriesFor: #anonymousName!constants!private! !
!Kernel.PoolDictionary categoriesFor: #asQualifiedReference!private! !
!Kernel.PoolDictionary categoriesFor: #associationClass!constants!private! !
!Kernel.PoolDictionary categoriesFor: #convertToSharedPool!development!private! !
!Kernel.PoolDictionary categoriesFor: #displayOn:!public! !
!Kernel.PoolDictionary categoriesFor: #environment!accessing!public! !
!Kernel.PoolDictionary categoriesFor: #fullNameFor:!public! !
!Kernel.PoolDictionary categoriesFor: #name!accessing!public! !
!Kernel.PoolDictionary categoriesFor: #name:!accessing!private! !
!Kernel.PoolDictionary categoriesFor: #newAssociation:value:!helpers!private! !
!Kernel.PoolDictionary categoriesFor: #resolvePublicBinding:!private! !
!Kernel.PoolDictionary categoriesFor: #unqualifiedName!accessing!private! !

Kernel.PoolDictionary methodProtocol: #importableNamespace attributes: #(#readOnly) selectors: #(#asQualifiedReference #resolvePublicBinding:)!

!Kernel.PoolDictionary class methodsFor!

forClass: aClass
	^self new
		environment: aClass;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!Kernel.PoolDictionary class categoriesFor: #forClass:!instance creation!public! !
!Kernel.PoolDictionary class categoriesFor: #named:!instance creation!public! !

