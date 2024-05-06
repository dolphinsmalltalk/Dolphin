"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #LocaleTest
	instanceVariableNames: 'savedLocale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LocaleTest guid: (GUID fromString: '{85b9dbfa-a1e2-46f3-ae44-d016f209b03b}')!

LocaleTest isAbstract: true!

LocaleTest comment: ''!

!LocaleTest categoriesForClass!Unclassified! !

!LocaleTest methodsFor!

defaultSubject
	^self subclassResponsibility!

setUp
	super setUp.
	savedLocale := Locale userDefault.
	Locale userDefault: (Locale lcid: 1081)!

tearDown
	savedLocale ifNotNil: [Locale userDefault: savedLocale. savedLocale := nil].
	super tearDown!

testPrintDateTimeOnFormat
	| subject now expected |
	now := DateAndTime
				year: 2019
				day: 97
				hour: 18
				minute: 26
				second: 21 + (827 / 1000).
	subject := self defaultSubject.
	expected := '6:26 ', subject pmDesignator, ' (and 21.827 seconds) on Sunday, 7 of April 2019 somewhere'.
	{now. now asParameter. TimeStamp fromDateAndTime: now} do: 
			[:each |
			| actual |
			actual := String streamContents: 
							[:s |
							subject
								printDateTime: each
								on: s
								format: 'h:mm tt (an\d ssffffff \secon\d\s) on dddd, d ''of'' MMMM yyyy ''somewhere'''].
			self assert: actual equals: expected]!

testPrintDurationOnFormat
	| subject actual |
	subject := self defaultSubject.
	actual := String streamContents: 
					[:s |
					subject
						printDuration: 1.75 hours
						on: s
						format: '+hh:mm'].
	self assert: actual equals: '+01:45'.
	actual := String streamContents: 
					[:s |
					subject
						printDuration: -1.75 hours
						on: s
						format: '+hh:mm'].
	self assert: actual equals: '-01:45'.
	actual := String streamContents: 
					[:s |
					subject
						printDuration: 12.1 hours
						on: s
						format: '-hh:mm'].
	self assert: actual equals: '12:06'.
	actual := String streamContents: 
					[:s |
					subject
						printDuration: -12.1 hours
						on: s
						format: '+hh:mm'].
	self assert: actual equals: '-12:06'!

testPrintFloat
	self subclassResponsibility!

testPrintFloatGrouping
	"Test printing with different number grouping."

	self subclassResponsibility!

testPrintFloatNumDigits
	"Test printing different numbers of decimal places, and also what happens beyond the limits as the GetNumberFormatAPI only supports 0..9 decimal digits."

	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	"Only up to 9 decimal places can be requested"
	0 to: 9
		do: 
			[:each |
			format decimalPlaces: each.
			self assert: (subject printFloat: 0.123404321 format: format)
				equals: ('0.123404321' copyFrom: 1 to: each + (each > 0 ifTrue: [2] ifFalse: [1]))].
	self assert: (subject printFloat: 0.0123456789 format: format) equals: '0.012345679'.
	format grouping: 0.
	"Of course we may still not have enough precision to display the result accurately as the precision of a 64-bit Float is at most 17 decimal digits"
	self assert: (subject printFloat: 123456789.0123456789 format: format) equals: '123456789.012345660'.
	"Attempting to specify more digits than 9 is an error as it is not supported by the GetNumberFormat API"
	#(-1 10) do: 
			[:each |
			self should: [format decimalPlaces: each] raise: Error.
			"If we force it in, we expect an invalid parameter error from GetNumberFormat"
			format NumDigits: each.
			self
				should: [subject printFloat: 0.0123456789 format: format]
				raise: Win32Error
				matching: [:ex | ex tag = (HRESULT win32Error: Win32Errors.ERROR_INVALID_PARAMETER)]]!

testPrintFloatSeparators
	"Test printing with specific decimal and group separators."

	self subclassResponsibility! !

!LocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
setUp!private!running! !
tearDown!private!running! !
testPrintDateTimeOnFormat!public!unit tests! !
testPrintDurationOnFormat!public!unit tests! !
testPrintFloat!public!unit tests! !
testPrintFloatGrouping!public!unit tests! !
testPrintFloatNumDigits!public!unit tests! !
testPrintFloatSeparators!public!unit tests! !
!

