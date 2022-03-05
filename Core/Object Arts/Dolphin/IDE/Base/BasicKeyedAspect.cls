"Filed out from Dolphin Smalltalk"!

AnonymousKeyedAspect subclass: #BasicKeyedAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BasicKeyedAspect guid: (GUID fromString: '{493bbe17-de57-4c11-8d61-e0494b76a1f6}')!
BasicKeyedAspect comment: 'Part of the PublishedAspectorInspector framework. BasicKeyedAspect instances are used to describe the published aspects of an object that can be accessed via #basicAt: and #basicAt:put: messages as governed by the BasicKeyedAspectAccessor class'!
!BasicKeyedAspect categoriesForClass!Attribute-Definition! !
!BasicKeyedAspect methodsFor!

getSelector
	"Private - Answers the selector used for getting the aspect value from the subject"

	^#basicAt:
!

putSelector
	^#basicAt:put:!

readFrom: anObject
	^anObject basicAt: self key!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	^subjectObject basicAt: self key put: valueObject! !
!BasicKeyedAspect categoriesForMethods!
getSelector!accessing!private! !
putSelector!accessing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

