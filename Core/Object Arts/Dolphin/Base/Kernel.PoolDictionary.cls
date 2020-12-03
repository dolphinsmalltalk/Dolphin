"Filed out from Dolphin Smalltalk 7"!

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
			each environment: poolClass.
			pool add: each].
	poolClass basicClassPool: pool.
	(Smalltalk localBindingFor: identifier) value: poolClass.
	Smalltalk removeLocalBindingFor: tempName.
	poolClass setName: identifier.
	^poolClass!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self name displayOn: aPuttableStream!

environment
	"Answer the receiver's <Namespace> scope."

	^self!

name
	"Answer the receiver's name."

	^self environment unqualifiedName!

name: aSymbol 
	!

newAssociation: keyObject value: valueObject
	^(super newAssociation: keyObject value: valueObject)
		environment: self;
		yourself!

unqualifiedName
	^self anonymousName! !
!Kernel.PoolDictionary categoriesFor: #anonymousName!constants!private! !
!Kernel.PoolDictionary categoriesFor: #associationClass!constants!private! !
!Kernel.PoolDictionary categoriesFor: #convertToSharedPool!development!private! !
!Kernel.PoolDictionary categoriesFor: #displayOn:!public! !
!Kernel.PoolDictionary categoriesFor: #environment!accessing!public! !
!Kernel.PoolDictionary categoriesFor: #name!accessing!public! !
!Kernel.PoolDictionary categoriesFor: #name:!accessing!private! !
!Kernel.PoolDictionary categoriesFor: #newAssociation:value:!helpers!private! !
!Kernel.PoolDictionary categoriesFor: #unqualifiedName!accessing!private! !

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

