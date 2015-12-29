"Filed out from Dolphin Smalltalk X6.2"!

KeyedAspect subclass: #AnonymousKeyedAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AnonymousKeyedAspect guid: (GUID fromString: '{C64B85F4-37C0-4DD2-9F9D-7539C2F99594}')!
AnonymousKeyedAspect comment: 'Part of the PublishedAspectorInspector framework. AnonymouseKeyedAspect instances are used to describe the published aspects of a keyed collection where the key name is anonymous and should not be displayed. '!
!AnonymousKeyedAspect categoriesForClass!Development! !
!AnonymousKeyedAspect methodsFor!

displayAspectNameOf: anObject on: aStream 
	"Don't display the anonymouse key name"
!

displayAspectText: anObject on: aStream 
	"Don't display the anonymouse key name"

	(self readFrom: anObject) aspectDisplayOn: aStream! !
!AnonymousKeyedAspect categoriesFor: #displayAspectNameOf:on:!displaying!private! !
!AnonymousKeyedAspect categoriesFor: #displayAspectText:on:!displaying!private! !

