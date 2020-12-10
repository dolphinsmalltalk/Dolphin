"Filed out from Dolphin Smalltalk 7"!

Tools.Aspect subclass: #'Tools.KeyedAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.KeyedAspect guid: (Core.GUID fromString: '{87b4c4d9-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.KeyedAspect comment: 'Part of the PublishedAspectorInspector framework. KeyedAspect instances are used to describe the published aspects of a keyed collection. Typically these are accessed via #at: and #at:put: messages as governed by the KeyedAspectAccessor class.'!
!Tools.KeyedAspect categoriesForClass!Attribute-Definition! !
!Tools.KeyedAspect methodsFor!

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
!Tools.KeyedAspect categoriesFor: #=!comparing!public! !
!Tools.KeyedAspect categoriesFor: #displayAspectNameOf:on:!displaying!private! !
!Tools.KeyedAspect categoriesFor: #displayAspectText:on:!displaying!private! !
!Tools.KeyedAspect categoriesFor: #getSelector!accessing!private! !
!Tools.KeyedAspect categoriesFor: #hash!comparing!public! !
!Tools.KeyedAspect categoriesFor: #objectRefName:!helpers!private! !
!Tools.KeyedAspect categoriesFor: #putSelector!accessing!private! !
!Tools.KeyedAspect categoriesFor: #readFrom:!indirect accessing!private! !
!Tools.KeyedAspect categoriesFor: #writeInto:value:!indirect accessing!private! !

!Tools.KeyedAspect class methodsFor!

key: aKey 
	"Answer an instance of the receiver created with aKey"

	^self name: aKey! !
!Tools.KeyedAspect class categoriesFor: #key:!instance creation!public! !

