"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Model'
	instanceVariableNames: 'events'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Model guid: (Core.GUID fromString: '{87b4c4a3-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Model isNonInstantiable: true!
Core.Model comment: 'Model is an abstract class whose subclasses implement the <model> protocol and represent domain level data that is likely to be observed by other objects. The Model hierarchy is part of the MVP framework although <model> classes may well be used outside of this framework. 

SmalltalkSystem help: ''Overviews/ModelViewPresenter''.

In general, <models> differ from other objects which would otherwise be simply subclasses of Object by triggering change events when aspects of their data are modified. This enables the Observers of this data to keep up-to-date with the changes. In the MVP framework a <view> is typically an Observer of a <model>''s data. 

The Model class provides a faster means of event triggering for its subclasses than is available in standard objects but, apart from this it supplies, no new facilities other than to conveniently group classes that be considered to act as models and place them within the <model> protocol.

Instance Variables:
	events	<EventsCollection> holding the model''s event registrations.



'!
!Core.Model categoriesForClass!MVP-Models! !
!Core.Model methodsFor!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

isValid
	"Answer true if the model state is valid."

	^true!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original. Answer the receiver."

	events := nil.
	^self!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil! !
!Core.Model categoriesForMethods!
getEvents!events!private! !
isValid!public!testing! !
postCopy!copying!public! !
setEvents:!events!private! !
!

Core.Model methodProtocol: #model attributes: #(#readOnly) selectors: #()!

!Core.Model class methodsFor!

new
	"Answer a new initialize instance of the receiver."

	^super new initialize!

stbConvert: anArray fromVersion: anInteger 
	"Private - Convert from earlier version view by updating and answering the array of instance
	variables, instVarArray. "

	| instVars |
	instVars := anArray.
	anInteger < 1 ifTrue: [instVars := self stbConvertFromVersion0: instVars].
	anInteger < 2 ifTrue: [instVars := self stbConvertFromVersion1: instVars].
	anInteger < 3 ifTrue: [instVars := self stbConvertFromVersion2: instVars].
	^instVars!

stbConvertFromVersion0: anArray
	"Private - Perform an STB conversion from a version 0 <Model> to version 1.
	i.e. insert 'events' instance variable (which should always be nil in an STB stream)."

	^(Array new: anArray size + 1)
		replaceFrom: 2
			to: anArray size + 1
			with: anArray
			startingAt: 1;
		yourself!

stbConvertFromVersion1: anArray 
	"Private - Perform an STB conversion from a version 1 <Model> to version 2.
	No change at this level."

	^anArray!

stbConvertFromVersion2: anArray 
	"Private - Perform an STB conversion from a version 2 <Model> to version 3.
	No change at this level."

	^anArray! !
!Core.Model class categoriesForMethods!
new!instance creation!public! !
stbConvert:fromVersion:!binary filing!private! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbConvertFromVersion2:!binary filing!private! !
!

