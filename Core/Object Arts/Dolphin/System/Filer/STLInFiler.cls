"Filed out from Dolphin Smalltalk X6"!

STBInFiler subclass: #STLInFiler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STLInFiler guid: (GUID fromString: '{0EB5F19A-A120-4002-83D9-C520F502DE6D}')!
STLInFiler comment: ''!
!STLInFiler categoriesForClass!System-Binary storage! !
!STLInFiler methodsFor!

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

resetAndValidateStream
	(self class peekForSignatureIn: stream) ifFalse: [self class errorNotSTB].
	version := self stream next.
	version > self class version ifTrue: [self class errorVersion: version]! !
!STLInFiler categoriesFor: #readClassLocator:!helpers!private! !
!STLInFiler categoriesFor: #readInteger!helpers!private! !
!STLInFiler categoriesFor: #readLiteralData!private! !
!STLInFiler categoriesFor: #resetAndValidateStream!initializing!private! !

!STLInFiler class methodsFor!

peekForSignatureIn: aReadStream 
	"Answer whether the <readableStream> argument, aReadStream, appears to
	be an STL stream (or is positioned at the start of an STL stream). If the STL
	signature is found, then the stream is left positioned immediately after it, 
	otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^aReadStream next = self signature or: 
			[aReadStream position: position.
			false]!

signature
	"Private - Answer the signature that identifies the data as
	being in Smalltalk Literal (STL) format."

	^STLOutFiler signature! !
!STLInFiler class categoriesFor: #peekForSignatureIn:!public!testing! !
!STLInFiler class categoriesFor: #signature!constants!private! !

