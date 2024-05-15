"Filed out from Intuitive Smalltalk"!

Object subclass: #Diary
	instanceVariableNames: 'diaryEvents monitorProcess mutex '
	classVariableNames: ''
	poolDictionaries: ''!

Diary class instanceVariableNames: ''!

Diary comment: 'The Diary class is part of the sample Diary application.
Diary is a domain level class that maintains a list of DiaryEvents
that are scheduled to occur at some time in the future. 

Associated domain classes are:
	DiaryEvent - A general purpose event object to store in the diary

Assocated tool classes are:
	DiaryTool - A simple user interface capable of maintaining a diary'!

!Diary categoriesForClass!No category! !

!Diary methodsFor!

addDiaryEvent: aDiaryEvent
	"Add aDiaryEvent to the receiver's list of pending events. We also trigger
	an event (#diaryEvents) to indicate to any observers that this aspect of
	the receiver has been changed"

	"In order to ensure that the monitor process is not fiddling around with the
	internals of our diaryEvents collection at the same time we are, we protect
	the access inside a Mutex semaphore"
	self mutex critical: [
		self diaryEvents add: aDiaryEvent.
		self trigger: #diaryEvents ].

	"It is convention to answer the object added from most methods
	that add to a collection"
	^aDiaryEvent !

diaryEvents
	"Answer the collection of DiaryEvents pending in the receiver"

	^diaryEvents!

free
	"Release the receiver. Here we have to terminate the monitor process to ensure that
	the diary has no remaining references and will correctly disappear"

	self stopMonitor!

initialize
	"Private - Initialize the receiver"

	"Create the collection of pending DiaryEvents. This is a SortedCollection
	where the events will be sorted into the order in which they must be scheduled.
	The sort sequence is determined by the #>= method in DiaryEvent"
	diaryEvents := SortedCollection new.

	"We will start a new process to periodically monitor whether the nextScheduledDiaryEvent
	has passed and needs to be fired. Since this monitor process can potentially be accessing 
	the diary contents at the same time that the user interface process (this one) is, then
	we have to prevent this using a mutual exclusion semaphore (Mutex)"
	mutex := Mutex new.
	self startMonitor!

monitor
	"Private - Monitor the nextScheduledDiaryEvent to see if it's scheduled time is passed and it
	should be fired. If so, we fire it here and install a new nextScheduledDiaryEvent (if any). This
	method is called only from within the monitorProcess"

	| event |
	event := self nextScheduledDiaryEvent.

	"First ensure that there is such an event (the diary may be empty)"
	event notNil ifTrue: [
		"Now ask the event if its time has passed and if so fire it.
		Once complete discard the event which in turn will install
		the next in line"
		event hasPassed ifTrue: [
			event fire.
			self removeDiaryEvent: event ]]!

monitorPeriod
	"Private - Answer the period, in seconds, after which the monitor wakes"

	^5!

monitorProcess
	"Private - Answer the monitor process"

	^monitorProcess!

mutex
	"Private - Answer the mutual exclusion semaphore used to protect the receiver's contents
	from simultaneous access by the user interface process and the monitor process. In particular,
	since SortedCollections are not inherrently process safe, the diaryEvents collection is
	especially vunerable. 

	The mutex can be sent #critical: aBlock to execute aBlock to the exclusion of all other processes"

	^mutex!

nextScheduledDiaryEvent
	"Answer the next DiaryEvent pending this will be the first one in the
	diaryEvents SortedCollection. If there are no events then answer nil"

	self diaryEvents isEmpty ifTrue: [ ^nil ].
	^self diaryEvents first
!

removeDiaryEvent: aDiaryEvent
	"Remove aDiaryEvent from the receiver's list of pending events.
	We also trigger an event (#diaryEvents) to indicate to any observers that 
	this aspect of the receiver has been changed"

	"In order to ensure that the monitor process is not fiddling around with the
	internals of our diaryEvents collection at the same time we are, we protect
	the access inside a Mutex semaphore"

	| nextEvent |
	self mutex critical: [
		self diaryEvents remove: aDiaryEvent.
		self trigger: #diaryEvents ].

	"It is convention to answer the object removed from most methods
	that remove from a collection"
	^aDiaryEvent!

replaceDiaryEvent: aDiaryEvent with: anotherDiaryEvent
	"Replace aDiaryEvent in the receiver's list of pending events with
	anotherDiaryEvent. We also trigger an event (#diaryEvents) to indicate 
	to any observers that this aspect of 	the receiver has been changed"

	"In order to ensure that the monitor process is not fiddling around with the
	internals of our diaryEvents collection at the same time we are, we protect
	the access inside a Mutex semaphore"
	self mutex critical: [
		self diaryEvents remove: aDiaryEvent.
		self diaryEvents add: anotherDiaryEvent.
		self trigger: #diaryEvents ].

!

show
	"Creates a DiaryTool on the receiver and display a default view of this in a Shell window.
	The tool becomes a user interface in the diary. Several tools can be open at once onto the
	same diary"

	(DiaryTool on: self) inShell!

startMonitor
	"Private - Start a new process that will monitor the nextScheduledDiaryEvent
	periodically to see if its scheduled time has passed. If so, the event will
	be fired. After each delay period the monitor process terminates and a new one is
	restarted"

	| delay |
	delay := Delay forSeconds: self monitorPeriod.
	monitorProcess := [ 
		delay wait. 	"Wait on the delay"
		self monitor. 	"Monitor the nextScheduledDiaryEvent"
		self startMonitor. "Restart the monitor process"
		"This one is about to end"
		] forkAt: Processor userBackgroundPriority
!

stopMonitor
	"Private - Forcibly stop the monitor process. It should not be necesary
	to call this method; it is provided solely for emergencies during
	development"

	self monitorProcess terminate.
	monitorProcess := nil! !

!Diary categoriesFor: #addDiaryEvent:!adding! !
!Diary categoriesFor: #diaryEvents!accessing! !
!Diary categoriesFor: #free!operations! !
!Diary categoriesFor: #initialize!initializing! !
!Diary categoriesFor: #monitor!operations! !
!Diary categoriesFor: #monitorPeriod!constants! !
!Diary categoriesFor: #monitorProcess!accessing! !
!Diary categoriesFor: #mutex!accessing! !
!Diary categoriesFor: #nextScheduledDiaryEvent!accessing! !
!Diary categoriesFor: #removeDiaryEvent:!removing! !
!Diary categoriesFor: #replaceDiaryEvent:with:!adding! !
!Diary categoriesFor: #show!tools! !
!Diary categoriesFor: #startMonitor!operations! !
!Diary categoriesFor: #stopMonitor!operations! !

!Diary class methodsFor!

new
	"Answer an instance of the receiver. The instance contains instance variables that
	require initialization away from their original nil values so ensure that
	#initialize is sent to it here"

	^super new initialize; yourself! !

!Diary class categoriesFor: #new!instance creation! !

