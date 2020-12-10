"Filed out from Dolphin Smalltalk 7"!

Tools.AnonymousKeyedAspect subclass: #'Tools.BasicKeyedAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.BasicKeyedAspect guid: (Core.GUID fromString: '{493bbe17-de57-4c11-8d61-e0494b76a1f6}')!
Tools.BasicKeyedAspect comment: 'Part of the PublishedAspectorInspector framework. BasicKeyedAspect instances are used to describe the published aspects of an object that can be accessed via #basicAt: and #basicAt:put: messages as governed by the BasicKeyedAspectAccessor class'!
!Tools.BasicKeyedAspect categoriesForClass!Attribute-Definition! !
!Tools.BasicKeyedAspect methodsFor!

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
!Tools.BasicKeyedAspect categoriesFor: #getSelector!accessing!private! !
!Tools.BasicKeyedAspect categoriesFor: #putSelector!accessing!private! !
!Tools.BasicKeyedAspect categoriesFor: #readFrom:!indirect accessing!private! !
!Tools.BasicKeyedAspect categoriesFor: #writeInto:value:!indirect accessing!private! !

