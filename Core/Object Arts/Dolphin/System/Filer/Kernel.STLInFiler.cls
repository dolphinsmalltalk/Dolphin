"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler subclass: #'Kernel.STLInFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLInFiler guid: (Core.GUID fromString: '{0eb5f19a-a120-4002-83d9-c520f502de6d}')!
Kernel.STLInFiler comment: ''!
!Kernel.STLInFiler categoriesForClass!System-Binary storage! !
!Kernel.STLInFiler methodsFor!

basicNext
	| prefixOrLiteral |
	prefixOrLiteral := stream next.
	^prefixOrLiteral isInteger
		ifTrue: 
			[prefixOrLiteral == STBPrefix.LiteralPrefixMask
				ifTrue: [self readLiteralData]
				ifFalse: [self readObjectWithPrefix: prefixOrLiteral]]
		ifFalse: [prefixOrLiteral]!

readClassLocator: anIntegerFlags 
	^stream next!

readInteger
	"Private - Answer the next 32-bit integer in the stream."

	^stream next!

readLiteralData
	| newObject |
	newObject := stream next.
	newObject isImmutable ifTrue: [newObject := newObject copy].
	self register: newObject.
	^newObject!

readVersion
	version := stream next.
	^true!

registerPredefinedObjects
	"Private - Post version 3 the out filer stores everything."

	version < 4 ifTrue: [super registerPredefinedObjects] ifFalse: [self registerPredefinedClasses]!

sizeForNext: aClass
	^(aClass isVariable or: [version < 3]) ifTrue: [stream next] ifFalse: [0]! !
!Kernel.STLInFiler categoriesForMethods!
basicNext!accessing!private! !
readClassLocator:!helpers!private! !
readInteger!helpers!private! !
readLiteralData!private! !
readVersion!initializing!private! !
registerPredefinedObjects!initializing!private! !
sizeForNext:!operations!private! !
!

!Kernel.STLInFiler class methodsFor!

peekForSignatureIn: aReadStream 
	"Answer whether the <readableStream> argument, aReadStream, appears to
	be an STL stream (or is positioned at the start of an STL stream). If the STL
	signature is found, then the stream is left positioned immediately after it, 
	otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^aReadStream nextAvailable = self signature or: 
			[aReadStream position: position.
			false]!

signature
	"Private - Answer the signature that identifies the data as
	being in Smalltalk Literal (STL) format."

	^#'!!STL'! !
!Kernel.STLInFiler class categoriesForMethods!
peekForSignatureIn:!public!testing! !
signature!constants!private! !
!

