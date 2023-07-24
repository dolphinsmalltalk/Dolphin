"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STBFiler'
	instanceVariableNames: 'stream context policy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'PrefixBytesMask' -> 16r30.
			'PrefixCharacterMask' -> 16r4.
			'PrefixClassMask' -> 16r6.
			'PrefixDataMask' -> 16r2.
			'PrefixInstSizeMask' -> 16rFF.
			'PrefixInstSizeShift' -> 16r8.
			'PrefixInstSizeUnshift' -> -16r8.
			'PrefixLiteralMask' -> 16r8.
			'PrefixLocatorLenShift' -> 16r10.
			'PrefixLocatorLenUnshift' -> -16r10.
			'PrefixNonZeroVersionMask' -> 16r40.
			'PrefixRefShift' -> 16r4.
			'PrefixRefUnshift' -> -16r4.
			'PrefixSmallIntegerMask' -> 16r1.
			'PrefixVariableMask' -> 16r20.
			'STLFormatName' -> 'STL'
		}!
Kernel.STBFiler guid: (Core.GUID fromString: '{87b4c4c1-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBFiler isNonInstantiable: true!
Kernel.STBFiler comment: ''!
!Kernel.STBFiler categoriesForClass!System-Binary storage! !
!Kernel.STBFiler methodsFor!

atEnd
	"Answer true if the receiver is positioned at end of its stream."

	^stream atEnd

!

context
	"Answers the context for objects read by the receiver"

	^context!

context: anObject
	"Sets the context for objects read by the receiver to anObject. This may be,
	for example, the parent window of a window being read."

	context := anObject!

initialize
	self reset.
	^self!

initializeObjectMap
	^self subclassResponsibility!

policy
	^policy!

position: anInteger
	"Position the receiver's stream to anInteger, read/write a header at this
	place and prepare it for a new input or output session."

	stream position: anInteger.
	self reset.!

register: anObject 
	"Register an object has having been seen before in the STB stream. Answer the unique object reference."

	^self subclassResponsibility!

registerAllClasses: anArray
	anArray do: [:each | self register: each]!

reset
	"Private - Reset the instance."

	self subclassResponsibility!

setRefOffset: anInteger
	^self subclassResponsibility!

stream
	"Answer the stream to which the receiver is attached."

	^stream!

version
	"Answer the format version of the STB stream."

	^policy version! !
!Kernel.STBFiler categoriesForMethods!
atEnd!public!testing! !
context!accessing!public! !
context:!accessing!public! !
initialize!initializing!private! !
initializeObjectMap!initializing!private! !
policy!accessing!public! !
position:!operations!public! !
register:!helpers!public! !
registerAllClasses:!initializing!private! !
reset!initializing!private! !
setRefOffset:!initializing!private! !
stream!accessing!public! !
version!accessing!public! !
!

!Kernel.STBFiler class methodsFor!

formatName
	"Private - Answer the format name."

	^'STB'!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self subclassResponsibility!

versionPolicyClass
	^self subclassResponsibility! !
!Kernel.STBFiler class categoriesForMethods!
formatName!constants!private! !
on:!instance creation!public! !
versionPolicyClass!constants!private! !
!

