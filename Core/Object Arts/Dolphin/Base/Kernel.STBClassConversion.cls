"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STBClassConversion'
	instanceVariableNames: 'version instSize isBytes isVariable converterBlock filer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBClassConversion guid: (Core.GUID fromString: '{87b4c4c0-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBClassConversion comment: ''!
!Kernel.STBClassConversion categoriesForClass!System-Binary storage! !
!Kernel.STBClassConversion methodsFor!

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
	"Answer the receiver's instSize inst var."

	^instSize!

isBytes
	"Answer whether the target class is a byte class."

	^isBytes!

isBytes: aBoolean
	isBytes := aBoolean!

isUpgrading
	^filer isUpgrading!

isVariable
	"Answer the receiver's isVariable inst var."

	^isVariable!

version
	"Answer the receiver's version inst var."

	^version!

version: versionInteger prefix: anInteger filer: anSTBInFiler
	"Private - Initialise the receiver from the arguments."

	version := versionInteger.
	instSize := (anInteger bitShift: STBPrefix.InstSizeShift) bitAnd: STBPrefix.InstSizeMask.
	self isBytes: (anInteger allMask: STBPrefix.BytesMask).
	isVariable := anInteger allMask: STBPrefix.VariableMask.
	filer := anSTBInFiler! !
!Kernel.STBClassConversion categoriesForMethods!
converterBlock!accessing!public! !
converterBlock:!accessing!public! !
instSize!accessing!public! !
isBytes!public!testing! !
isBytes:!accessing!public! !
isUpgrading!public!testing! !
isVariable!public!testing! !
version!accessing!public! !
version:prefix:filer:!accessing!private! !
!

!Kernel.STBClassConversion class methodsFor!

forFiler: anSTBInFiler class: aClass version: oldVersion prefix: anInteger 
	"Answer a new instance representing the STB format of oldVersion of aClass."

	| format |
	format := self new 
				version: oldVersion
				prefix: anInteger
				filer: anSTBInFiler.
	format converterBlock: (aClass stbConvertFrom: format).
	^format! !
!Kernel.STBClassConversion class categoriesForMethods!
forFiler:class:version:prefix:!instance creation!public! !
!

