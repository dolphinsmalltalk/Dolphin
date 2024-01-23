"Filed out from Dolphin Smalltalk"!

Core.SharedIdentityDictionary
	variableSubclass: #'Kernel.EventsCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.EventsCollection guid: (Core.GUID fromString: '{87b4c533-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.EventsCollection comment: ''!
!Kernel.EventsCollection categoriesForClass!Collections-Unordered!System-Support! !
!Kernel.EventsCollection methodsFor!

addEvent: aSymbol action: aValuable
	"Private - Adds the <valuable> argument as the action for 
	aSymbol, but only if it is not already present."

	mutex critical: 
			[| messages |
			messages := self at: aSymbol ifAbsent: [EventMessageSequence new].
			"Check for existing registration"
			(messages includes: aValuable)
				ifFalse: 
					[messages add: aValuable.
					self at: aSymbol put: messages]]!

asMinimumRepresentation
	"Private - Answers nil if the receiver is empty, otherwise self."

	^self isEmpty ifFalse: [self]!

hasActionsForEvent: aSymbol
	^mutex critical: [(self at: aSymbol ifAbsent: #()) notEmpty]!

removeActionsForEvent: aSymbol
	^mutex critical: [self removeKey: aSymbol ifAbsent: nil]!

removeEventsTriggeredFor: anObject
	"Private - Removes all events where the target is anObject. If the receiver becomes empty answers nil, otherwise answers self."

	^mutex critical: 
			[| empty |
			empty := IdentitySet new.
			self keysAndValuesDo: 
					[:eachKey :eachValue |
					eachValue isNil
						ifFalse: [(eachValue removeMessagesFor: anObject) == 0 ifTrue: [empty add: eachKey]]].
			self
				removeAllKeys: empty;
				asMinimumRepresentation]!

shrink
	"Private - Removes all empty message sequences."

	mutex critical: 
			[| empty |
			empty := OrderedCollection new.
			self 
				keysAndValuesDo: [:eachKey :eachValue | (eachValue isNil or: [eachValue isEmpty]) ifTrue: [empty add: eachKey]].
			self removeAllKeys: empty]!

triggerEvent: anEventSymbol
	"Private - Evaluate the sequence of MessageSends registered for the event, 
	anEventSymbol.  Answer the result of the last evaluation, or nil if none."

	^(self lookup: anEventSymbol) value!

triggerEvent: aSymbol with: anObject
	"Private - Evaluate the sequence of MessageSends registered for the event named by
	the <Symbol> argument, with a single argument, anObject..
	 Answer the result of the last evaluation, or nil if none."

	^(self at: aSymbol ifAbsent: [[:arg | nil]]) valueWithArguments: {anObject}!

triggerEvent: aSymbol with: anObject with: anotherObject
	"Private - Evaluate the sequence of MessageSends registered for the event named by
	the <Symbol> argument, with the pair of arguments, anObject, and, anotherObject.
	 Answer the result of the last evaluation, or nil if none."

	^(self at: aSymbol ifAbsent: [[:arg1 :arg2 | nil]]) valueWithArguments: {anObject. anotherObject}!

triggerEvent: aSymbol withArguments: anArray
	"Private - Evaluate the sequence of MessageSends registered for the event named by
	the <Symbol> argument, with the <Array> of arguments, anArray.
	with the specified arguments. Answer the result of the last evaluation, or nil if none."

	^(self lookup: aSymbol) ifNotNil: [:msgs | msgs valueWithArguments: anArray]! !
!Kernel.EventsCollection categoriesForMethods!
addEvent:action:!adding!private! !
asMinimumRepresentation!converting!private! !
hasActionsForEvent:!private!testing! !
removeActionsForEvent:!adding!private! !
removeEventsTriggeredFor:!private!removing! !
shrink!private!removing! !
triggerEvent:!debugger-step through!private!triggering! !
triggerEvent:with:!debugger-step through!private!triggering! !
triggerEvent:with:with:!debugger-step through!private!triggering! !
triggerEvent:withArguments:!debugger-step through!private!triggering! !
!

Kernel.EventsCollection methodProtocol: #eventsCollection attributes: #(#readOnly) selectors: #(#addEvent:action: #asMinimumRepresentation #hasActionsForEvent: #removeActionsForEvent: #removeEventsTriggeredFor: #shrink #triggerEvent: #triggerEvent:with: #triggerEvent:with:with: #triggerEvent:withArguments:)!

