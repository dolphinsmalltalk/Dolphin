"Filed out from Dolphin Smalltalk 7"!

Object subclass: #STBClassConversion
	instanceVariableNames: 'version instSize isBytes isVariable converterBlock filer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBClassConversion guid: (GUID fromString: '{87B4C4C0-026E-11D3-9FD7-00A0CC3E4A32}')!
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

instSize
	"Answer the receiver's instSize inst var."

	^instSize!

isBytes
	"Answer the receiver's isBytes inst var."

	^isBytes!

isUpgrading
	^filer isUpgrading!

isVariable
	"Answer the receiver's isVariable inst var."

	^isVariable!

prefix: anSTBPrefix
	"Initialise the receiver from the details contained in anSTBPrefix."

	instSize := anSTBPrefix instSize.
	isBytes := anSTBPrefix isBytes.
	isVariable := anSTBPrefix isVariable.!

version
	"Answer the receiver's version inst var."

	^version!

version: versionInteger prefix: anInteger filer: anSTBInFiler
	"Private - Initialise the receiver from the arguments."

	version := versionInteger.
	instSize := (anInteger bitShift: STBPrefix.InstSizeShift) bitAnd: STBPrefix.InstSizeMask.
	isBytes := anInteger allMask: STBPrefix.BytesMask.
	isVariable := anInteger allMask: STBPrefix.VariableMask.
	filer := anSTBInFiler! !
!STBClassConversion categoriesFor: #converterBlock!accessing!public! !
!STBClassConversion categoriesFor: #converterBlock:!accessing!public! !
!STBClassConversion categoriesFor: #instSize!accessing!public! !
!STBClassConversion categoriesFor: #isBytes!public!testing! !
!STBClassConversion categoriesFor: #isUpgrading!public!testing! !
!STBClassConversion categoriesFor: #isVariable!public!testing! !
!STBClassConversion categoriesFor: #prefix:!accessing!public! !
!STBClassConversion categoriesFor: #version!accessing!public! !
!STBClassConversion categoriesFor: #version:prefix:filer:!accessing!private! !

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
!STBClassConversion class categoriesFor: #forFiler:class:version:prefix:!instance creation!public! !

