"Filed out from Dolphin Smalltalk 7"!

Dictionary variableSubclass: #PoolDictionary
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PoolDictionary guid: (GUID fromString: '{87b4c52a-026e-11d3-9fd7-00a0cc3e4a32}')!
PoolDictionary comment: ''!
!PoolDictionary categoriesForClass!Collections-Unordered!System-Support! !
!PoolDictionary methodsFor!

anonymousName
	^'Anon'!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."
	
	^VariableBinding!

bindingsDo: aMonadicValuable
	self associationsDo: aMonadicValuable!

convertToSharedPool
	| package name tempName poolClass pool |
	package := self owningPackage.
	name := self name.
	self owningPackage: nil.
	tempName := (name , '_newPool') asSymbol.
	poolClass := SharedPool subclass: tempName.
	pool := poolClass classPool.
	self bindingsDo: 
			[:each |
			each environment: poolClass.
			pool add: each].
	poolClass basicClassPool: pool.
	(Smalltalk associationAt: name) value: poolClass.
	Smalltalk removeKey: tempName.
	poolClass setName: name.
	poolClass owningPackage: package!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self name displayOn: aPuttableStream!

environment
	"Answer the receiver's <Namespace> scope."

	^environment!

environment: aNamespace
	"Private - Set the environment to be used for new bindings in the receiver. This should be set on initialization, and not changed subsequently."

	environment := aNamespace!

initialize
	super initialize.
	environment := self!

initializerFor: aString
	"Answer a chunk reader to read and evaluate an initializer for the receiver's named variable"

	^ChunkReader
		do: 
			[:chunkString |
			(self bindingFor: aString)
				ifNil: 
					[Warning signal: ('Ignoring initializer for undefined variable <1S>.<2S>: <3S>'
								expandMacrosWith: self
								with: aString
								with: chunkString)]
				ifNotNil: 
					[:var |
					| value |
					(Compiler compileExpression: chunkString in: nil)
						ifNotNil: 
							[:expr |
							value := [expr method value] on: Error
										do: 
											[:ex |
											ex resignalAsWarning.
											nil].
							var setValue: value]]]
		inContext: self
		atEnd: []!

isChanged
	"Answer true if the receiver or any of it's contents have been changed since
	their changed flag was last reset."

	^self propertyAt: #isChanged ifAbsent: [false]!

isChanged: aBoolean
	"Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument. If the receiver is marked as changed, then
	its owning package (if any) is also so marked."

	"Note that we don't test the existing value of the change flag here, because
	 we want to inform the package regardless (in case it isn't currently changed
	 for some reason)"
	aBoolean 
		ifTrue: [ | package |
			self propertyAt: #isChanged put: true.
			(package := self owningPackage) notNil ifTrue: [
				package isChanged: true]]
		ifFalse: [self removePropertyAt: #isChanged ifAbsent: []]!

localEnvironment
	"Private - Answer the nearest <Namespace> scope."

	^self
!

name
	"Answer the receiver's name."

	^self environment keyAtValue: self ifAbsent: [self anonymousName]!

name: aSymbol 
	!

newAssociation: keyObject value: valueObject
	^(super newAssociation: keyObject value: valueObject)
		environment: self environment;
		yourself!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned by any package"

	| identifier |
	identifier := self name.
	^identifier = self anonymousName
		ifFalse: [Package manager packageOfVariableNamed: identifier asQualifiedReference]!

owningPackage: aPackage
	"Set the receiver's <Package> to be the argument. Any current package association is lost."

	| identifier |
	identifier := self name.
	identifier = self anonymousName
		ifTrue: [self error: 'Anonymous pools cannot be packaged independently'].
	Package manager addVariableNamed: identifier asQualifiedReference to: aPackage!

preResize: newMe
	"Private - This message is sent by the receiver when resizing, before the receiver's elements are added to newMe. We must assign across any fixed fields."

	newMe environment: environment! !
!PoolDictionary categoriesFor: #anonymousName!accessing!public! !
!PoolDictionary categoriesFor: #associationClass!constants!private! !
!PoolDictionary categoriesFor: #bindingsDo:!enumerating!public! !
!PoolDictionary categoriesFor: #convertToSharedPool!development!private! !
!PoolDictionary categoriesFor: #displayOn:!public! !
!PoolDictionary categoriesFor: #environment!accessing!public! !
!PoolDictionary categoriesFor: #environment:!initializing!private! !
!PoolDictionary categoriesFor: #initialize!initializing!private! !
!PoolDictionary categoriesFor: #initializerFor:!development!public!source filing-sif! !
!PoolDictionary categoriesFor: #isChanged!development!public!source filing!testing! !
!PoolDictionary categoriesFor: #isChanged:!development!public!source filing! !
!PoolDictionary categoriesFor: #localEnvironment!accessing!private! !
!PoolDictionary categoriesFor: #name!accessing!public! !
!PoolDictionary categoriesFor: #name:!accessing!private! !
!PoolDictionary categoriesFor: #newAssociation:value:!helpers!private! !
!PoolDictionary categoriesFor: #owningPackage!development!public!source filing! !
!PoolDictionary categoriesFor: #owningPackage:!accessing!development!public! !
!PoolDictionary categoriesFor: #preResize:!adding!private! !

!PoolDictionary class methodsFor!

forClass: aClass
	^self new
		environment: aClass;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!PoolDictionary class categoriesFor: #forClass:!instance creation!public! !
!PoolDictionary class categoriesFor: #named:!instance creation!public! !

