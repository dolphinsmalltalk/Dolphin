"Filed out from Dolphin Smalltalk 7"!

Association subclass: #VariableBinding
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VariableBinding guid: (GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!
VariableBinding comment: ''!
!VariableBinding categoriesForClass!Collections-Support! !
!VariableBinding methodsFor!

= anAssociation
	"Answer whether the receiver is equal to the argument."

	^super = anAssociation and: [environment == anAssociation environment]!

displayOn: aStream 
	"Append a short textual description of the receiver to aStream."

	aStream display: key!

displayString
	^key!

environment
	^environment!

environment: aNamespace 
	<mutable>
	environment := aNamespace!

fullName
	"Placeholder for answering fully qualified name (relative to Smalltalk)."
	
	^key!

fullyQualifiedReference
	^self fullName asQualifiedReference!

refersToLiteral: anObject
	^anObject == environment or: [self = anObject]!

targetVariable
	^self! !
!VariableBinding categoriesFor: #=!comparing!public! !
!VariableBinding categoriesFor: #displayOn:!printing!public! !
!VariableBinding categoriesFor: #displayString!displaying!public! !
!VariableBinding categoriesFor: #environment!public! !
!VariableBinding categoriesFor: #environment:!public! !
!VariableBinding categoriesFor: #fullName!accessing!public! !
!VariableBinding categoriesFor: #fullyQualifiedReference!accessing!public! !
!VariableBinding categoriesFor: #refersToLiteral:!private!testing! !
!VariableBinding categoriesFor: #targetVariable!accessing!public! !

!VariableBinding class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Convert from previous version resource. 
	Version Changes:
		1) Adds 'environment'"

	^
	[:data |
	| answer value |
	answer := self basicNew.
	1 to: data size do: [:i | answer instVarAt: i put: (data at: i)].
	"In most cases a VariableBinding will be in STB because it is referenced from the literal frame of a method. For those cases where the reference is to a class, it is very likely that the variable is from the Smalltalk dictionary, so we patch the environment to that. For other cases, we don't have enough context here to be able to determine the correct environment, so we leave it nil."
	value := answer value.
	(value class isMeta and: [answer key == value name]) ifTrue: [answer environment: Smalltalk].
	answer]!

stbVersion
	^1! !
!VariableBinding class categoriesFor: #stbConvertFrom:!public! !
!VariableBinding class categoriesFor: #stbVersion!public! !

