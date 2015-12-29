"Filed out from Dolphin Smalltalk X6"!

STBOutFiler subclass: #STLOutFiler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STLOutFiler guid: (GUID fromString: '{72DEE7E2-3402-4813-99F6-379FFC717B86}')!
STLOutFiler comment: ''!
!STLOutFiler categoriesForClass!System-Binary storage! !
!STLOutFiler methodsFor!

objectIsLiteral: anObject 
	"Private - Override hook for the STL filter"

	anObject class == Symbol ifTrue: [^true].
	anObject class == String ifTrue: [^true].
	anObject class == LargeInteger ifTrue: [^true].
	anObject class == ByteArray ifTrue: [^true].
	anObject class == PoolConstantsDictionary ifTrue: [^true].
	anObject class isMeta ifTrue: [^true].
	^false!

putLiteral: anObject 
	self writeInteger: LiteralPrefixMask.
	self stream nextPut: anObject.
	self register: anObject!

resetStream
	stream
		nextPut: self class signature;
		nextPut: self class version!

writeClass: aClass withLocator: locatorString 
	stream nextPut: aClass!

writeInteger: anInteger 
	"Private - Write anInteger to the stream."

	stream nextPut: anInteger! !
!STLOutFiler categoriesFor: #objectIsLiteral:!private! !
!STLOutFiler categoriesFor: #putLiteral:!private! !
!STLOutFiler categoriesFor: #resetStream!initializing!private! !
!STLOutFiler categoriesFor: #writeClass:withLocator:!operations!private! !
!STLOutFiler categoriesFor: #writeInteger:!helpers!private! !

!STLOutFiler class methodsFor!

signature
	"Private - Answer the signature that identifies the data as
	being in Smalltalk Literal (STL) format."

	^#'!!STL'! !
!STLOutFiler class categoriesFor: #signature!constants!private! !

