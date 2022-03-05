"Filed out from Dolphin Smalltalk"!

Object subclass: #STBClassConversion
	instanceVariableNames: 'version instSize dataClass isVariable converterBlock filer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBClassConversion guid: (GUID fromString: '{87b4c4c0-026e-11d3-9fd7-00a0cc3e4a32}')!
STBClassConversion comment: ''!
!STBClassConversion categoriesForClass!System-Binary storage! !
!STBClassConversion methodsFor!

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

dataClass
	^dataClass!

instSize
	"Answer the receiver's instSize inst var."

	^instSize!

isBytes
	"Answer whether the target class is a byte class."

	^dataClass isBytes!

isBytes: aBoolean
	dataClass := aBoolean ifTrue: [ByteArray] ifFalse: [Array]!

isUpgrading
	^filer isUpgrading!

isVariable
	"Answer the receiver's isVariable inst var."

	^isVariable!

prefix: anSTBPrefix
	"Initialise the receiver from the details contained in anSTBPrefix."

	| aBoolean |
	instSize := anSTBPrefix instSize.
	aBoolean := anSTBPrefix isBytes.
	self isBytes: aBoolean.
	isVariable := anSTBPrefix isVariable!

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
!STBClassConversion categoriesForMethods!
converterBlock!accessing!public! !
converterBlock:!accessing!public! !
dataClass!accessing!public! !
instSize!accessing!public! !
isBytes!public!testing! !
isBytes:!accessing!public! !
isUpgrading!public!testing! !
isVariable!public!testing! !
prefix:!accessing!public! !
version!accessing!public! !
version:prefix:filer:!accessing!private! !
!

!STBClassConversion class methodsFor!

forFiler: anSTBInFiler class: aClass version: oldVersion prefix: anInteger 
	"Answer a new instance representing the STB format of oldVersion of aClass."

	| format |
	format := self new 
				version: oldVersion
				prefix: anInteger
				filer: anSTBInFiler.
	format converterBlock: (aClass stbConvertFrom: format).
	^format! !
!STBClassConversion class categoriesForMethods!
forFiler:class:version:prefix:!instance creation!public! !
!

