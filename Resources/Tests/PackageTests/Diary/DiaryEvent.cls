"Filed out from Intuitive Smalltalk"!

Object subclass: #DiaryEvent
	instanceVariableNames: 'description triggerTime '
	classVariableNames: ''
	poolDictionaries: ''!

DiaryEvent class instanceVariableNames: ''!

DiaryEvent comment: 'The DiaryEvent class is part of the sample Diary application.
DiaryEvent is a domain level class whose instances are used to represent
a generic event that can be added to a Diary. Each DiaryEvent holds 
a textual description and a trigger TimeStamp to indicate when the event
should be scheduled to fire.

Associated domain classes are:
	Diary - Maintains a collection of pending DiaryEvents and fires them
	as they become due.

Assocated tool classes are:
	DiaryEventEditor - A user interface capable of editing the contents of
	a DiaryEvent
'!

!DiaryEvent categoriesForClass!Applications-Tutorial!No application! !

!DiaryEvent methodsFor!

<= anotherDiaryEvent
	"Answer true if the receiver is considered <= anotherDiaryEvent. 
	Compares the two based on triggerTime. 

	By implementing this method we allow DiaryEvents to be added to a 
	SortedCollection and be sorted into ascending sequence based on their 
	trigger times. The next event to be scheduled will be first in the c
	ollection. The Diary class maintains its #diaryEvents as such a 
	SortedCollection"

	^self triggerTime <= anotherDiaryEvent triggerTime!

description
	"Answer the String description for this event"

	^description!

description: aString
	"Set the description for this event to aString"

	description := aString!

fire
	"Perform some activity when the triggerTime is passed. 
	By default we display a MessageBox containing the receiver's description. 
	Subclasses can override this message to provide more specialized
	activity"

	MessageBox notify: 
		self description, String lineDelimiter, self triggerTime asString!

hasPassed
	"Answer true if the receiver's triggerTime has been passed and the event
	should be fired"

	^self triggerTime <= TimeStamp current!

initialize
	"Private - Initialize the receiver"

	"Set the description to a blank String"
	description := String new.

	"Set the trigger time to now; not much use but at least
	it then contains a genuine TimeStamp object"
	triggerTime := TimeStamp current!

printOn: aStream
	"Append a short textual description of the receiver to aStream. 
	It is this description that will appear when displaying or inspecting
	the receiver.	Although by no means essential, it is quite often useful 
	to define this method so that some details of the receiver can be readily 
	seen during debugging"

	aStream 
		basicPrint: self;
		nextPut: $(;
		nextPutAll: self triggerTime asString;
		nextPut: $,;
		nextPutAll: self description;
		nextPut: $)!

triggerDate
	"Answer the triggering Date for the receiver"

	^self triggerTime date!

triggerDate: aDate
	"Set the triggering date for the receiver to aDate"

	^self triggerTime date: aDate!

triggerSoon
	"Private - Set the triggerTime for the receiver to be in 10 seconds.
	Only for debugging purposes"

	| soon |
	soon := Time now addTime: (Time fromSeconds: 10).
	self triggerTime: (TimeStamp date: Date today time: soon)!

triggerTime
	"Answer the triggering TimeStamp for the receiver. This contains the date and
	time after which the receiver should fire"

	^triggerTime!

triggerTime: aTimeStamp
	"Set the triggering time for the receiver to aTimeStamp. This contains
	the date and time after which the receive should fire"

	triggerTime := aTimeStamp!

triggerTimeOfDay
	"Answer the triggering Time of day for the receiver"

	^self triggerTime time!

triggerTimeOfDay: aTime
	"Set the triggering time of day for the receiver to aTime"

	^self triggerTime time: aTime!

triggerTomorrow
	"Private - Set the triggerTime for the receiver to be this time tomorrow.
	Only for debugging purposes"

	| tomorrow |
	tomorrow := Date today addDays: 1.
	self triggerTime: (TimeStamp date: tomorrow time: Time now)! !

!DiaryEvent categoriesFor: #<=!comparing! !
!DiaryEvent categoriesFor: #description!accessing! !
!DiaryEvent categoriesFor: #description:!accessing! !
!DiaryEvent categoriesFor: #fire!operations! !
!DiaryEvent categoriesFor: #hasPassed!testing! !
!DiaryEvent categoriesFor: #initialize!initializing! !
!DiaryEvent categoriesFor: #printOn:!printing! !
!DiaryEvent categoriesFor: #triggerDate!accessing! !
!DiaryEvent categoriesFor: #triggerDate:!accessing! !
!DiaryEvent categoriesFor: #triggerSoon!development! !
!DiaryEvent categoriesFor: #triggerTime!accessing! !
!DiaryEvent categoriesFor: #triggerTime:!accessing! !
!DiaryEvent categoriesFor: #triggerTimeOfDay!accessing! !
!DiaryEvent categoriesFor: #triggerTimeOfDay:!accessing! !
!DiaryEvent categoriesFor: #triggerTomorrow!development! !

!DiaryEvent class methodsFor!

new
	"Answer an instance of the receiver, after first initializing it"

	^super new initialize; yourself! !

!DiaryEvent class categoriesFor: #new!instance creation! !

