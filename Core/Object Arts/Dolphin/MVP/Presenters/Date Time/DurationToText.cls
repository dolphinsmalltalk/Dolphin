"Filed out from Dolphin Smalltalk 7"!

AbstractToTextConverter subclass: #DurationToText
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DurationToText guid: (GUID fromString: '{b7c9ede3-d5d2-494f-8569-58ec71e88b89}')!
DurationToText comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DurationToText categoriesForClass!IDB Goodies!MVP-Type Converters-Text! !
!DurationToText methodsFor!

format
	^format!

format: aStringOrNil 
	format := aStringOrNil!

leftToRight: aDuration
	| fmt stream |
	fmt := self format ?? 'd:hh:mm:ssfff'.
	stream := String writeStream: fmt size.
	Locale default
		printDuration: aDuration
		on: stream
		format: fmt.
	^stream grabContents!

rightToLeft: aString
	"Convert aString into a Duration.  
		Expected format is day:hour:minute:seconds
			- any argument can have a sign
			- days, hours, and minutes are truncated to integers, seconds are not
			- arguments can be omitted from the left so 12:34 is equivalent to 0:0:12:34
			- 0, more than 4 values , illegal characters answers nil"

	| values |
	(aString allSatisfy: [:each | '0123456789+-:.' includes: each]) ifFalse: [^self leftNullValue].
	values := OrderedCollection new.
	($: split: aString) reverseDo: [:each | values add: (Number fromString: each)].
	(values isEmpty or: [values size > 4]) ifTrue: [^self leftNullValue].
	[values size < 4] whileTrue: [values add: 0].
	^Duration
		days: (values at: 4) truncated
		hours: (values at: 3) truncated
		minutes: (values at: 2) truncated
		seconds: (values at: 1)! !
!DurationToText categoriesFor: #format!accessing!public! !
!DurationToText categoriesFor: #format:!accessing!public! !
!DurationToText categoriesFor: #leftToRight:!operations!public! !
!DurationToText categoriesFor: #rightToLeft:!operations!public! !

