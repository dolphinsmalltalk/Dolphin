"Filed out from Dolphin Smalltalk 7"!

Kernel.STBOutFiler subclass: #'Kernel.STLOutFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLOutFiler guid: (Core.GUID fromString: '{72dee7e2-3402-4813-99f6-379ffc717b86}')!
Kernel.STLOutFiler comment: ''!
!Kernel.STLOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STLOutFiler methodsFor!

putCharacter: aCharacter
	stream nextPut: aCharacter!

putLiteral: anObject 
	self writeInteger: STBPrefix.LiteralPrefixMask.
	self stream nextPut: anObject.
	self register: anObject!

registerPredefinedObjects
	"Private - "

	"Post version 3, don't pre-register standard objects with literal representation as we write these directly to the stream."

	version < 4 ifTrue: [super registerPredefinedObjects] ifFalse: [self registerPredefinedClasses]!

resetStream
	stream
		nextPut: self class signature;
		nextPut: self class version!

serializeObject: anObject
	anObject isAtomic
		ifTrue: [stream nextPut: anObject]
		ifFalse: 
			["Certain other objects with literal representations can also be saved to the stream directly, but need to be registered in case they are shared in the object graph being serialized. Note that with the exception of LargeInteger, these are literal collections of atomic objects (e.g. Strings are collections of Characters)."
			(anObject isString or: 
					[| class |
					class := anObject class.
					class == LargeInteger
						or: [class == ByteArray or: [class == Array and: [anObject allSatisfy: [:each | each isAtomic]]]]])
				ifTrue: [self putLiteral: anObject]
				ifFalse: 
					["No literal form, need to break it down"
					anObject stbSaveOn: self]]!

writeClass: aClass withLocator: locatorString 
	stream nextPut: aClass!

writeInteger: anInteger 
	"Private - Write anInteger to the stream."

	stream nextPut: anInteger!

writeNil
	stream nextPut: nil! !
!Kernel.STLOutFiler categoriesFor: #putCharacter:!helpers!private! !
!Kernel.STLOutFiler categoriesFor: #putLiteral:!private! !
!Kernel.STLOutFiler categoriesFor: #registerPredefinedObjects!initializing!private! !
!Kernel.STLOutFiler categoriesFor: #resetStream!initializing!private! !
!Kernel.STLOutFiler categoriesFor: #serializeObject:!operations!private! !
!Kernel.STLOutFiler categoriesFor: #writeClass:withLocator:!operations!private! !
!Kernel.STLOutFiler categoriesFor: #writeInteger:!helpers!private! !
!Kernel.STLOutFiler categoriesFor: #writeNil!operations!private! !

!Kernel.STLOutFiler class methodsFor!

signature
	"Private - Answer the signature that identifies the data as
	being in Smalltalk Literal (STL) format."

	^#'!!STL'! !
!Kernel.STLOutFiler class categoriesFor: #signature!constants!private! !

