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
	PrefixLiteralMask == prefixOrLiteral
		ifFalse: [^policy readObject: self withPrefix: prefixOrLiteral].
	^self readLiteralData!

classLocator
	"Answer a <ClassLocator> for use in resolving classes from the receiver's input stream."

	"No longer required for STL, but older resources may contain STBClassProxy or STBMetaclassProxy objects"

	^ClassLocator new!

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
	^newObject! !
!Kernel.STLInFiler categoriesForMethods!
basicNext!accessing!private! !
classLocator!accessing!public! !
readLiteralData!helpers!private! !
!

!Kernel.STLInFiler class methodsFor!

formatName
	"Private - Answer the format name."

	^STLFormatName!

version
	"Private - Answer the version number of the format produced by the receiver.
		Version 5 - Literal filer saves class locators as BindingReferences"

	^STLFilerVersion!

versionPolicyClass
	^STLVersionPolicy! !
!Kernel.STLInFiler class categoriesForMethods!
formatName!constants!private! !
version!public! !
versionPolicyClass!constants!private! !
!

