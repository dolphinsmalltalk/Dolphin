"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STxClassConversion'
	instanceVariableNames: 'version instSize prefix converterBlock filer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STxClassConversion guid: (Core.GUID fromString: '{87b4c4c0-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STxClassConversion comment: ''!
!Kernel.STxClassConversion categoriesForClass!System-Binary storage! !
!Kernel.STxClassConversion methodsFor!

converterBlock
	"Answer the receiver's converterBlock.
	The block should expect a single argument being the old object
	represented by:
		an Array if it was stored as pointers, or
		a ByteArray if it was stored as bytes.
	The block should answer a new object initialised from the data
	contained in the block parameter."

	^converterBlock!

converterBlock: aBlock
	"Set the receiver's converterBlock inst var to aBlock.
	The block should expect a single argument being the old object
	represented by:
		an Array if it was stored as pointers, or
		a ByteArray if it was stored as bytes.
	The block should answer a new object initialised from the data
	contained in the block parameter."

	converterBlock := aBlock!

instSize
	"Answer the count of fixed (named) instance variables that were associated with the class of the object to be converted when originally serialized."

	^instSize!

isBytes
	"Answer whether the class being converted is a byte class."

	^prefix allMask: STxFiler.PrefixBytesMask!

isUpgrading
	^filer isUpgrading!

isVariable
	"Answer whether the class being converted can have indexed instance variables."

	^prefix allMask: STxFiler.PrefixVariableMask!

version
	"Answer the receiver's version inst var."

	^version!

version: versionInteger prefix: anInteger filer: anSTBInFiler
	"Private - Initialise the receiver from the arguments."

	version := versionInteger.
	instSize := ((prefix := anInteger) bitShift: STxFiler.PrefixInstSizeUnshift)
				bitAnd: STxFiler.PrefixInstSizeMask.
	filer := anSTBInFiler! !
!Kernel.STxClassConversion categoriesForMethods!
converterBlock!accessing!public! !
converterBlock:!accessing!public! !
instSize!accessing!public! !
isBytes!public!testing! !
isUpgrading!public!testing! !
isVariable!public!testing! !
version!accessing!public! !
version:prefix:filer:!accessing!private! !
!

!Kernel.STxClassConversion class methodsFor!

forFiler: anSTBInFiler class: aClass version: oldVersion prefix: anInteger 
	"Answer a new instance representing the STB format of oldVersion of aClass."

	| format |
	format := self new 
				version: oldVersion
				prefix: anInteger
				filer: anSTBInFiler.
	format converterBlock: (aClass stbConvertFrom: format).
	^format! !
!Kernel.STxClassConversion class categoriesForMethods!
forFiler:class:version:prefix:!instance creation!public! !
!

