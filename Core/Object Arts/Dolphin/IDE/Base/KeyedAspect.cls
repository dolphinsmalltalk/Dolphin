"Filed out from Dolphin Smalltalk"!

Aspect subclass: #KeyedAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

KeyedAspect guid: (GUID fromString: '{87b4c4d9-026e-11d3-9fd7-00a0cc3e4a32}')!

KeyedAspect comment: 'Part of the PublishedAspectorInspector framework. KeyedAspect instances are used to describe the published aspects of a keyed collection. Typically these are accessed via #at: and #at:put: messages as governed by the KeyedAspectAccessor class.'!

!KeyedAspect categoriesForClass!Attribute-Definition! !

!KeyedAspect methodsFor!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self == comperand or: [self species == comperand species and: [self key == comperand key]]!

displayAspectNameOf: anObject on: aStream 
	aStream display: self key!

displayAspectText: anObject on: aStream
	aStream
		display: self key;
		nextPut: $=.
	[(self readFrom: anObject) aspectDisplayOn: aStream] on: Error do: [:ex | ex displayOn: aStream]!

getSelector
	"Private - Answers the selector used for getting the aspect value from the subject"

	^#at:
!

hash
	"Answer the <Integer> hash value for the receiver."

	^self key hash!

objectRefName: anObject
	^(self readFrom: anObject) basicPrintString , self key displayString copyWithout: Character space!

putSelector
	^#at:put:!

readFrom: anObject
	^anObject at: self key!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	^subjectObject at: self key put: valueObject! !

!KeyedAspect categoriesForMethods!
=!comparing!public! !
displayAspectNameOf:on:!displaying!private! !
displayAspectText:on:!displaying!private! !
getSelector!accessing!private! !
hash!comparing!public! !
objectRefName:!helpers!private! !
putSelector!accessing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!KeyedAspect class methodsFor!

key: aKey 
	"Answer an instance of the receiver created with aKey"

	^self name: aKey! !

!KeyedAspect class categoriesForMethods!
key:!instance creation!public! !
!

