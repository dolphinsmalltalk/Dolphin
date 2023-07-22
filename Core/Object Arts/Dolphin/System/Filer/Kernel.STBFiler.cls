"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STBFiler'
	instanceVariableNames: 'stream context policy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'PredefinedClassOffset' -> 16r4.
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
			'STBFormatName' -> 'STB'.
			'STLFilerVersion' -> 16r6.
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

errorInconsistentSTB: anObject
	"Private - Signal an STBError indicating that the stream being
	read contains inconsistent STB data."

	STBError
		signal: 'Input stream is inconsistent (object <1p> referenced but not yet defined)' << anObject!

errorUnrecognisedClass: aClass version: version
	"Private - Signal an STBError indicating that the STB data contains
	instances of aClass of version that we don't know how to convert."

	STBError signal: 'Input stream contains an unsupported version <1d> of <2p>' << { version. aClass }!

formatName
	"Private - Answer the format name."

	^STBFormatName!

initialize
	self addClassConstant: 'STBSignature' value: '!!STB ' asByteArray!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self subclassResponsibility!

version
	"Private - Answer the version number of the format produced by the receiver.
		Version 1 - Preregisters certain commonly occurring classes
		Version 2 - Delegates save/load to class, format changed for certain pre-registered classes.
		Version 3 - Only writes basicSize for objects of variable classes.
		Version 4 - Literal filer stores true, false, Smalltalk, etc as literals rather than special predefined object indices, and stores the full set of atomic objects, and arrays of atomic objects, as literals, not just Strings, Symbols, Integers, ByteArrays, classes and pool dictionaries.
		Version 5 - Fully-qualified class names written. Literal filer stores classes as fully-qualified BindingReferences."

	^5!

versionPolicyClass
	^self subclassResponsibility! !
!Kernel.STBFiler class categoriesForMethods!
errorInconsistentSTB:!exceptions!private! !
errorUnrecognisedClass:version:!exceptions!private! !
formatName!constants!private! !
initialize!constants!private! !
on:!instance creation!public! !
version!constants!private! !
versionPolicyClass!constants!private! !
!

