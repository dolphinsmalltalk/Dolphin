"Filed out from Dolphin Smalltalk"!

Kernel.NullEventsCollection
	variableSubclass: #'Kernel.EventsCollection'
	instanceVariableNames: 'mutex register'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.EventsCollection guid: (Core.GUID fromString: '{c94a291b-1622-4c8e-bc64-fa397458d052}')!

Kernel.EventsCollection comment: ''!

!Kernel.EventsCollection methodsFor!

addEvent: aSymbol action: aValuable
	"Adds the <valuable> argument as the action for aSymbol, but only if it is not already present."

	mutex critical: 
			[| messages |
			messages := register at: aSymbol ifAbsentPutClean: [EventMessageSequence new].
			"Check for existing registration"
			(messages includes: aValuable) ifFalse: [messages add: aValuable]]!

hasActionsForEvent: aSymbol
	"Answer whether there are any registered actions for the named event."

	^mutex critical: [(register at: aSymbol ifAbsent: #()) notEmpty]!

isEmpty
	"Answer whether the receiver contains no elements."

	^mutex critical: [register isEmpty]
!

removeActionsForEvent: aSymbol
	^mutex critical: [register removeKey: aSymbol ifAbsent: nil]!

removeEventsTriggeredFor: anObject
	"Removes all events where the target is anObject. If the receiver becomes empty answers nil, otherwise answers self."

	^mutex critical: 
			[| empty |
			empty := OrderedCollection new.
			register keysAndValuesDo: 
					[:eachKey :eachValue |
					eachValue isNil
						ifFalse: [(eachValue removeMessagesFor: anObject) == 0 ifTrue: [empty add: eachKey]]].
			empty size = register size
				ifTrue: 
					[register := IdentityDictionary new.
					nil]
				ifFalse: 
					[register removeAllKeys: empty.
					self]]!

setRegister: anIdentityDictionary
	mutex := Semaphore forMutualExclusion.
	register := anIdentityDictionary.
	^self!

shrink
	"Removes all empty message sequences."

	mutex critical: 
			[| empty |
			empty := OrderedCollection new.
			register
				keysAndValuesDo: [:eachKey :eachValue | (eachValue isNil or: [eachValue isEmpty]) ifTrue: [empty add: eachKey]].
			register removeAllKeys: empty]!

size
	"Answer the number of different events for which there are registered interests."

	^register size!

triggerEvent: anEventSymbol
	"Evaluate the sequence of MessageSends registered for the event, anEventSymbol.  Answer the result of the last evaluation, or nil if none."

	^(mutex critical: [register lookup: anEventSymbol]) value!

triggerEvent: aSymbol with: anObject
	"Evaluate the sequence of MessageSends registered for the event named by the <Symbol> argument, with a single argument, anObject. Answer the result of the last evaluation, or nil if none."

	^(mutex critical: [register at: aSymbol ifAbsent: [[:arg | nil]]]) valueWithArguments: { anObject }!

triggerEvent: aSymbol with: anObject with: anotherObject
	"Evaluate the sequence of MessageSends registered for the event named by the <Symbol> argument, with the pair of arguments, anObject, and, anotherObject. Answer the result of the last evaluation, or nil if none."

	^(mutex critical: [register at: aSymbol ifAbsent: [[:arg1 :arg2 | nil]]])
		valueWithArguments: { anObject. anotherObject }!

triggerEvent: aSymbol withArguments: anArray
	"Evaluate the sequence of MessageSends registered for the event named by the <Symbol> argument, with the <Array> of arguments, anArray with the specified arguments. Answer the result of the last evaluation, or nil if none."

	^(mutex critical: [register lookup: aSymbol]) ifNotNil: [:msgs | msgs valueWithArguments: anArray]! !

!Kernel.EventsCollection categoriesForMethods!
addEvent:action:!adding!public! !
hasActionsForEvent:!public!testing! !
isEmpty!public!testing! !
removeActionsForEvent:!public!removing! !
removeEventsTriggeredFor:!public!removing! !
setRegister:!initializing!private! !
shrink!public!removing! !
size!public! !
triggerEvent:!debugger-step through!public!triggering! !
triggerEvent:with:!debugger-step through!public!triggering! !
triggerEvent:with:with:!debugger-step through!public!triggering! !
triggerEvent:withArguments:!debugger-step through!public!triggering! !
!

!Kernel.EventsCollection class methodsFor!

new
	"Answer a new instance of the receiver."

	^self basicNew setRegister: IdentityDictionary new!

withEvent: aSymbol action: aValuable
	"Answer a new instance of the receiver."

	^self basicNew setRegister: (IdentityDictionary new
				at: aSymbol
					put: (EventMessageSequence new
							add: aValuable;
							yourself);
				yourself)! !

!Kernel.EventsCollection class categoriesForMethods!
new!instance creation!public! !
withEvent:action:!instance creation!public! !
!

