"Filed out from Dolphin Smalltalk X6"!

AbstractToTextConverter subclass: #DurationToText
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DurationToText guid: (GUID fromString: '{B7C9EDE3-D5D2-494F-8569-58EC71E88B89}')!
DurationToText comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DurationToText categoriesForClass!IDB Goodies!MVP-Type Converters-Text! !
!DurationToText methodsFor!

defaultFormat
	^'d:h:m:s'!

format
	format isNil ifTrue: [^self defaultFormat].
	^format!

format: aStringOrNil 
	format := aStringOrNil!

formatDaysIn: aDuration onto: aStream using: aString 
	| string |
	string := aDuration days printString.
	string size < aString size 
		ifTrue: [string := ((String new: aString size - string size) atAllPut: $0) , string].
	aStream nextPutAll: string!

formatHoursIn: aDuration onto: aStream using: aString 
	| hours string |
	hours := aString first isUppercase 
				ifTrue: 
					[self assert: [aStream position = 0].
					aDuration days * 24 + aDuration hours]
				ifFalse: [aDuration hours].
	string := hours printString.
	string size < aString size 
		ifTrue: [string := ((String new: aString size - string size) atAllPut: $0) , string].
	aStream nextPutAll: string!

formatMinutesIn: aDuration onto: aStream using: aString 
	| minutes string |
	minutes := aString first isUppercase 
				ifTrue: 
					[self assert: [aStream position = 0].
					(aDuration days * 24 + aDuration hours) * 60 + aDuration minutes]
				ifFalse: [aDuration minutes].
	string := minutes printString.
	string size < aString size 
		ifTrue: [string := ((String new: aString size - string size) atAllPut: $0) , string].
	aStream nextPutAll: string!

formatSecondsIn: aDuration onto: aStream using: aString 
	| string |
	string := aDuration seconds asFloat printString.
	string size < aString size 
		ifTrue: [string := ((String new: aString size - string size) atAllPut: $0) , string].
	aStream nextPutAll: string!

formatSelectorFor: aString 
	^##((LookupTable new)
		at: $d put: #formatDaysIn:onto:using:;
		at: $h put: #formatHoursIn:onto:using:;
		at: $m put: #formatMinutesIn:onto:using:;
		at: $s put: #formatSecondsIn:onto:using:;
		yourself) at: aString trimBlanks first asLowercase ifAbsent: [#formatError]!

leftToRight: aDuration 
	| stream |
	stream := String writeStream.
	(self format subStrings: $:) do: 
			[:each | 
			| formatString |
			formatString := each trimBlanks.
			self 
				perform: (self formatSelectorFor: formatString)
				with: aDuration
				with: stream
				with: formatString]
		separatedBy: [stream nextPut: $:].
	^stream contents!

rightToLeft: aString 
	"Convert aString into a Duration.  
		Expected format is day:hour:minute:seconds
			- any argument can have a sign
			- days hours and minutes are truncated to integers, seconds are not
			- arguments can be omitted from the left so 12:34 iseqivalent to 0:0:12:34
			- 0, more than 4 values , illegal characters answers nil"

	| values |
	(aString allSatisfy: [:each | '0123456789+-:.' includes: each]) ifFalse: [^self leftNullValue].
	values := OrderedCollection new.
	(aString subStrings: $:) reverseDo: [:each | values add: (Number fromString: each)].
	values isEmpty | (values size > 4) ifTrue: [^self leftNullValue].
	[values size < 4] whileTrue: [values add: 0].
	^Duration 
		days: (values at: 4) truncated
		hours: (values at: 3) truncated
		minutes: (values at: 2) truncated
		seconds: (values at: 1)! !
!DurationToText categoriesFor: #defaultFormat!accessing!public! !
!DurationToText categoriesFor: #format!accessing!public! !
!DurationToText categoriesFor: #format:!accessing!public! !
!DurationToText categoriesFor: #formatDaysIn:onto:using:!operations!public! !
!DurationToText categoriesFor: #formatHoursIn:onto:using:!operations!public! !
!DurationToText categoriesFor: #formatMinutesIn:onto:using:!operations!public! !
!DurationToText categoriesFor: #formatSecondsIn:onto:using:!operations!public! !
!DurationToText categoriesFor: #formatSelectorFor:!operations!public! !
!DurationToText categoriesFor: #leftToRight:!operations!public! !
!DurationToText categoriesFor: #rightToLeft:!operations!public! !

