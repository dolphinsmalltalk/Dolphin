"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.NullEventsCollection'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.NullEventsCollection guid: (Core.GUID fromString: '{9d0ad247-c847-4473-9195-be26bea0567b}')!
Kernel.NullEventsCollection comment: 'Kernel.NullEventsCollection is a special <eventsCollection> used when a receiver has no event subscriptions. Its purpose is to increase performance for this common case.'!
!Kernel.NullEventsCollection categoriesForClass!Kernel-Objects! !
!Kernel.NullEventsCollection methodsFor!

addEvent: aSymbol action: aValuable
	"Adds the <valuable> argument as the action for aSymbol, but only if it is not already present."

	"Implementation Note: The NullEventsCollection is supposed to be used only for empty events collections, so this should never be received."

	self shouldNotImplement!

asMinimumRepresentation
	"Answers nil if the receiver is empty, otherwise self."

	^nil!

hasActionsForEvent: aSymbol 
	^false!

removeActionsForEvent: aSymbol
	"Implementation Note: It is not an error to attempt to remove an event from an <eventsCollection> when that event doesn't exist in the collection."

	^nil!

removeEventsTriggeredFor: anObject 
	"Removes all events where the target is anObject. If the receiver becomes empty, answers nil, otherwise answers self."

	"Implementation Note: It is not an error to attempt to remove events triggered for an Object when the events collection contains no subscriptions for that object."

	^nil!

shrink
	"Removes all events for which there are no subscriptions."

	!

triggerEvent: anEventSymbol 
	"Evaluate the sequence of MessageSends registered for the event, anEventSymbol.  
	Answer the result of the last evaluation, or nil if none."

	^nil!

triggerEvent: aSymbol with: anObject 
	"Evaluate the sequence of MessageSends registered for the event named by the <Symbol> argument, with the single argument, anObject.
	 Answer the result of the last evaluation, or nil if none."

	^nil!

triggerEvent: aSymbol with: anObject with: anotherObject 
	"Evaluate the sequence of MessageSends registered for the event named by the <Symbol> argument, with the pair of arguments, anObject and anotherObject.
	 Answer the result of the last evaluation, or nil if none."

	^nil!

triggerEvent: aSymbol withArguments: anArray
	"Evaluate the sequence of MessageSends registered for the event named by the <Symbol> argument, with the <Array> of arguments, anArray, with the specified arguments.
	Answer the result of the last evaluation, or nil if none."

	^nil! !
!Kernel.NullEventsCollection categoriesForMethods!
addEvent:action:!public! !
asMinimumRepresentation!converting!public! !
hasActionsForEvent:!public!testing! !
removeActionsForEvent:!adding!public! !
removeEventsTriggeredFor:!public!removing! !
shrink!public!removing! !
triggerEvent:!public!triggering! !
triggerEvent:with:!public!triggering! !
triggerEvent:with:with:!public!triggering! !
triggerEvent:withArguments:!public!triggering! !
!

Kernel.NullEventsCollection methodProtocol: #eventsCollection attributes: #(#readOnly) selectors: #(#addEvent:action: #asMinimumRepresentation #hasActionsForEvent: #removeActionsForEvent: #removeEventsTriggeredFor: #shrink #triggerEvent: #triggerEvent:with: #triggerEvent:with:with: #triggerEvent:withArguments:)!

!Kernel.NullEventsCollection class methodsFor!

current
	^Current!

initialize
	Current := self new! !
!Kernel.NullEventsCollection class categoriesForMethods!
current!accessing!public! !
initialize!initializing!public! !
!

