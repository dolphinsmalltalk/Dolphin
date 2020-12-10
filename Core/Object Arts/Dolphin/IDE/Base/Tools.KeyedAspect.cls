"Filed out from Dolphin Smalltalk 7"!

Aspect subclass: #KeyedAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!KeyedAspect categoriesFor: #=!comparing!public! !
!KeyedAspect categoriesFor: #displayAspectNameOf:on:!displaying!private! !
!KeyedAspect categoriesFor: #displayAspectText:on:!displaying!private! !
!KeyedAspect categoriesFor: #getSelector!accessing!private! !
!KeyedAspect categoriesFor: #hash!comparing!public! !
!KeyedAspect categoriesFor: #objectRefName:!helpers!private! !
!KeyedAspect categoriesFor: #putSelector!accessing!private! !
!KeyedAspect categoriesFor: #readFrom:!indirect accessing!private! !
!KeyedAspect categoriesFor: #writeInto:value:!indirect accessing!private! !

!KeyedAspect class methodsFor!

key: aKey 
	"Answer an instance of the receiver created with aKey"

	^self name: aKey! !
!KeyedAspect class categoriesFor: #key:!instance creation!public! !

