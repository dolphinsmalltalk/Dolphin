"Filed out from Dolphin Smalltalk 7"!

Kernel.EventsCollection variableSubclass: #'Kernel.NullEventsCollection'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.NullEventsCollection guid: (Core.GUID fromString: '{9d0ad247-c847-4473-9195-be26bea0567b}')!
Kernel.NullEventsCollection comment: 'NullEventsCollection is a special events collection used when a receiver has no event subscriptions. Its purpose is to increase performance for this common case.'!
!Kernel.NullEventsCollection categoriesForClass!Kernel-Objects! !
!Kernel.NullEventsCollection methodsFor!

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
!Kernel.NullEventsCollection categoriesFor: #asMinimumRepresentation!converting!private! !
!Kernel.NullEventsCollection categoriesFor: #hasActionsForEvent:!private!testing! !
!Kernel.NullEventsCollection categoriesFor: #initialize!initializing!private! !
!Kernel.NullEventsCollection categoriesFor: #removeActionsForEvent:!adding!private! !
!Kernel.NullEventsCollection categoriesFor: #removeEventsTriggeredFor:!private!removing! !
!Kernel.NullEventsCollection categoriesFor: #shrink!private!removing! !
!Kernel.NullEventsCollection categoriesFor: #triggerEvent:!private!triggering! !
!Kernel.NullEventsCollection categoriesFor: #triggerEvent:with:!private!triggering! !
!Kernel.NullEventsCollection categoriesFor: #triggerEvent:with:with:!private!triggering! !
!Kernel.NullEventsCollection categoriesFor: #triggerEvent:withArguments:!private!triggering! !

!Kernel.NullEventsCollection class methodsFor!

current
	^Current!

initialize
	Current := self new! !
!Kernel.NullEventsCollection class categoriesFor: #current!accessing!public! !
!Kernel.NullEventsCollection class categoriesFor: #initialize!initializing!public! !

