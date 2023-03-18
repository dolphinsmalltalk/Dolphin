"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSTBInFiler
	subclass: #'Kernel.STLInFiler'
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
	prefixOrLiteral isInteger
		ifFalse: 
			["Atomic values, or an indirection to them; classes are represented by BindingReferences as these have a literal form that can be embedded in literal arrays. This will not include integers, but does include nil, true, false, Symbols, BindingReferences (except as an indirection to a class object), and (in old version STL content) class objects. It cannot include arrays, even of atomic objects, because the array itself is not atomic and may be shared."
			^prefixOrLiteral value].
	STBPrefix.LiteralPrefixMask == prefixOrLiteral
		ifFalse: [^self readObjectWithPrefix: prefixOrLiteral].
	^self readLiteralData!

newClassLocator
	^self defaultClassLocatorClass new!

readClassLocator: anIntegerFlags
	"Private - The class might be present directly (STL version 4) or as a BindingReference (STL version 5)"

	^stream next value!

readInteger
	"Private - Answer the next 32-bit integer in the stream."

	^stream next!

readLiteralData
	| newObject |
	newObject := stream next.
	newObject basicClass == Array
		ifTrue: 
			[| array size |
			array := Array basicNew: (size := newObject size).
			1 to: size do: [:i | array at: i put: (newObject at: i) value].
			newObject := array]
		ifFalse: [newObject isImmutable ifTrue: [newObject := newObject copy]].
	self register: newObject.
	^newObject!

readSizeBlock
	^version < 3
		ifTrue: [[:class | stream next]]
		ifFalse: [[:class | class isVariable ifTrue: [stream next] ifFalse: [0]]]!

readVersion
	version := stream next.
	^true!

registerPredefinedObjects
	"Private - Post version 3 the out filer stores everything."

	version < 4 ifTrue: [super registerPredefinedObjects] ifFalse: [self registerPredefinedClasses]! !
!Kernel.STLInFiler categoriesForMethods!
basicNext!accessing!private! !
newClassLocator!helpers!private! !
readClassLocator:!helpers!private! !
readInteger!helpers!private! !
readLiteralData!helpers!private! !
readSizeBlock!operations!private! !
readVersion!initializing!private! !
registerPredefinedObjects!initializing!private! !
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

	^#'!!STL'!

version
	"Private - Answer the version number of the format produced by the receiver.
		Version 5 - Literal filer saves class locators as BindingReferences"

	^STLFilerVersion! !
!Kernel.STLInFiler class categoriesForMethods!
peekForSignatureIn:!public!testing! !
signature!constants!private! !
version!public! !
!

