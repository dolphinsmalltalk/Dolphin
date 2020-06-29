"Filed out from Dolphin Smalltalk 7"!

EventsCollection variableSubclass: #NullEventsCollection
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NullEventsCollection guid: (GUID fromString: '{9d0ad247-c847-4473-9195-be26bea0567b}')!
NullEventsCollection comment: 'NullEventsCollection is a special events collection used when a receiver has no event subscriptions. Its purpose is to increase performance for this common case.'!
!NullEventsCollection categoriesForClass!Kernel-Objects! !
!NullEventsCollection methodsFor!

asMinimumRepresentation
	"Private - Answers nil if the receiver is empty, otherwise self."

	^nil!

hasActionsForEvent: aSymbol 
	^false!

initialize
	super initialize.
	"Mark the receiver as read-only, as this avoids the need to override a lot of inherited methods with error traps"
	self isImmutable: true.!

removeActionsForEvent: aSymbol 
	^nil!

removeEventsTriggeredFor: anObject 
	"Private - Removes all events where the target is anObject. If the receiver becomes empty,
	answers nil, otherwise answers self."

	^nil!

shrink
	"Private - Removes all empty message sequences."

	!

triggerEvent: anEventSymbol 
	"Private - Evaluate the sequence of MessageSends registered for the event, 
	anEventSymbol.  Answer the result of the last evaluation, or nil if none."

	^nil!

triggerEvent: aSymbol with: anObject 
	"Private - Evaluate the sequence of MessageSends registered for the event named by
	the <Symbol> argument, with a single argument, anObject..
	 Answer the result of the last evaluation, or nil if none."

	^nil!

triggerEvent: aSymbol with: anObject with: anotherObject 
	"Private - Evaluate the sequence of MessageSends registered for the event named by
	the <Symbol> argument, with the pair of arguments, anObject, and, anotherObject.
	 Answer the result of the last evaluation, or nil if none."

	^nil!

triggerEvent: aSymbol withArguments: anArray
	"Private - Evaluate the sequence of MessageSends registered for the event named by
	the <Symbol> argument, with the <Array> of arguments, anArray.
	with the specified arguments. Answer the result of the last evaluation, or nil if none."

	^nil! !
!NullEventsCollection categoriesFor: #asMinimumRepresentation!converting!private! !
!NullEventsCollection categoriesFor: #hasActionsForEvent:!private!testing! !
!NullEventsCollection categoriesFor: #initialize!initializing!private! !
!NullEventsCollection categoriesFor: #removeActionsForEvent:!adding!private! !
!NullEventsCollection categoriesFor: #removeEventsTriggeredFor:!private!removing! !
!NullEventsCollection categoriesFor: #shrink!private!removing! !
!NullEventsCollection categoriesFor: #triggerEvent:!private!triggering! !
!NullEventsCollection categoriesFor: #triggerEvent:with:!private!triggering! !
!NullEventsCollection categoriesFor: #triggerEvent:with:with:!private!triggering! !
!NullEventsCollection categoriesFor: #triggerEvent:withArguments:!private!triggering! !

!NullEventsCollection class methodsFor!

current
	^Current!

initialize
	Current := self new! !
!NullEventsCollection class categoriesFor: #current!accessing!public! !
!NullEventsCollection class categoriesFor: #initialize!initializing!public! !

