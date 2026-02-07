"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'External.FinalizableStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.FinalizableStructure guid: (Core.GUID fromString: '{87b4c5b9-026e-11d3-9fd7-00a0cc3e4a32}')!

External.FinalizableStructure isNonInstantiable: true!

External.FinalizableStructure comment: ''!

!External.FinalizableStructure categoriesForClass!External-Data-Structured-COM! !

!External.FinalizableStructure methodsFor!

initialize
	"Private - Initialize the receiver which is an internal [value] buffer.
	These objects are finalizable since they may reference owned external
	resources."

	super initialize.
	self beFinalizable!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources. Non-reference subinstances are assumed to require finalization."

	^self isValueStruct!

onStartup
	"Private - The system is starting. Modify the state of the receiver to account for the fact than any external memory allocated for the receiver during the previous session is no longer accessible."

	self beUnfinalizable.
	bytes := nil! !

!External.FinalizableStructure categoriesForMethods!
initialize!initializing!private! !
needsFree!private!realizing/unrealizing! !
onStartup!event handling!private! !
!

!External.FinalizableStructure class methodsFor!

clear: addressOrBytes
	"Free external resources referenced by the structure
	of the receiver's element type at the specified address."

	^self subclassResponsibility!

requiresFinalization
	"Answer whether instances of the receiver that own their own resources will require free'ing either explicitly or by finalization."

	^true! !

!External.FinalizableStructure class categoriesForMethods!
clear:!public!realizing/unrealizing! !
requiresFinalization!public!realizing/unrealizing!testing! !
!

