"Filed out from Dolphin Smalltalk 7"!

Association subclass: #VariableBinding
	instanceVariableNames: 'environment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
VariableBinding guid: (GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!
VariableBinding comment: ''!
!VariableBinding categoriesForClass!Collections-Support! !
!VariableBinding methodsFor!

= anAssociation
	"Answer whether the receiver is equal to the argument."

	^super = anAssociation and: [environment == anAssociation environment]!

absoluteName
	"Answer the <String> fully qualified name of this namespace, which is a dot-separated path to this binding from (but not including) Smalltalk."

	^self environment absoluteNameOfIdentifier: self key!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: key!

displayString
	^key!

environment
	^environment!

environment: aNamespace 
	<mutable>
	environment := aNamespace!

fullName
	"Answer the <String> fully qualified name of this namespace, which is a dot-separated path to this binding from (but not including) Smalltalk."

	^self environment fullNameOfIdentifier: self key!

fullyQualifiedReference
	#todo.	"Temporary definition while SystemDictionary is not a proper Namespace."
	^self environment == Smalltalk
		ifTrue: [BindingReference pathString: self key home: Smalltalk]
		ifFalse: [self environment fullyQualifiedReference append: self key]!

refersToLiteral: anObject
	^(anObject == environment and: 
			["Not useful to show ever variable in Smalltalk as an implicit reference to it. Probably true of all Namespaces except pools and classes."
			environment ~~ Smalltalk])
		or: [self = anObject]!

targetVariable
	^self! !
!VariableBinding categoriesFor: #=!comparing!public! !
!VariableBinding categoriesFor: #absoluteName!accessing!public! !
!VariableBinding categoriesFor: #displayOn:!printing!public! !
!VariableBinding categoriesFor: #displayString!displaying!public! !
!VariableBinding categoriesFor: #environment!accessing!public! !
!VariableBinding categoriesFor: #environment:!accessing!public! !
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
!VariableBinding class categoriesFor: #stbConvertFrom:!binary filing!public! !
!VariableBinding class categoriesFor: #stbVersion!binary filing!public! !

