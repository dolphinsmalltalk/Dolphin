"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.LocaleTest'
	instanceVariableNames: 'savedLocale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.LocaleTest guid: (Core.GUID fromString: '{85b9dbfa-a1e2-46f3-ae44-d016f209b03b}')!
Core.Tests.LocaleTest isNonInstantiable: true!
Core.Tests.LocaleTest comment: ''!
!Core.Tests.LocaleTest methodsFor!

defaultSubject
	^self subclassResponsibility!

displayScaledDecimal: aScaledDecimal in: aLocale 
	| stream |
	stream := String writeStream.
	aLocale displayScaledDecimal: aScaledDecimal on: stream.
	^stream contents!

setUp
	super setUp.
	savedLocale := Locale userDefault.
	"Deliberately switch to another default locale to catch any reliance on Locale specific dependencies in the test"
	Locale userDefault: (Locale named: 'tr-Tr')!

tearDown
	savedLocale
		ifNotNil: 
			[Locale userDefault: savedLocale.
			savedLocale := nil].
	super tearDown!

testDisplayFloatOn
	self subclassResponsibility!

testDisplayName
	self subclassResponsibility!

testDisplayScaledDecimainOn
	| subject |
	subject := self defaultSubject.
	self assert: (self displayScaledDecimal: 0.0s2 in: subject) equals: '0.00'.
	self assert: (self displayScaledDecimal: -1.25s in: subject) equals: '-1.25'.
	self assert: (self displayScaledDecimal: -0.0001s in: subject) equals: '-0.0001'.
	"ScaledDecimals support arbitrary precision"
	self
		assert: (self displayScaledDecimal: -123456789123456789123456789.1234567890987654321s in: subject)
		equals: '-123456789123456789123456789.1234567890987654321'!

testIsTurkic
	self deny: self defaultSubject isTurkic!

testName
	self subclassResponsibility!

testNoUserOverrides
	self assert: self defaultSubject noUserOverrides.
	self deny: (Locale named: 'en-US') noUserOverrides!

testPrimary
	"Sad, but true"

	self assert: (Locale named: 'en-GB') primary equals: (Locale named: 'en-US').
	self assert: (Locale named: 'fr-CA') primary equals: (Locale named: 'fr-FR').
	self assert: Locale invariant primary equals: Locale invariant.
	self assert: (Locale lcid: OS.NlsConstants.LOCALE_CUSTOM_DEFAULT) primary
		equals: Locale userDefault primary.
	self assert: Locale smalltalk primary equals: (Locale named: 'en-US')!

testPrintDateTimeOnFormat
	| subject now expected |
	now := DateAndTime
				year: 2019
				day: 97
				hour: 18
				minute: 26
				second: 21 + (827 / 1000).
	subject := self defaultSubject.
	expected := '6:26 ' , subject pmDesignator
				, ' (and 21.827 seconds) on Sunday, 7 of April 2019 somewhere'.
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

testPrintFloatGrouping
	"Test printing with different number grouping."

	| format subject |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	#(#(0 '0' '1234567890.12') #(1 '1' '1,2,3,4,5,6,7,8,9,0.12') #(2 '2' '12,34,56,78,90.12') #(3 '3' '1,234,567,890.12') #(4 '4' '12,3456,7890.12') #(5 '5' '12345,67890.12') #(6 '6' '1234,567890.12') #(7 '7' '123,4567890.12') #(8 '8' '12,34567890.12') #(9 '9' '1,234567890.12') #(10 '1;0;0' '123456789,0.12') #(11 '1;1' '1,2,3,4,5,6,7,8,9,0.12') #(12 '1;2' '1,23,45,67,89,0.12') #(32 '3;2' '1,23,45,67,890.12') #(92 '9;2' '1,234567890.12'))
		do: 
			[:each |
			format grouping: each first.
			self assert: format numberGrouping equals: each second.
			format numberGrouping: each second.
			self assert: format grouping equals: each first.
			self assert: (subject printFloat: 1234567890.123 format: format) equals: each last].	"The grouping is actually much more flexible than the documentation suggests. Up to four number groups are supported (the last repeating)."
	#(#(98 '9;8' '2,00000000,00000000,00000000,000000000.00') #(89 '8;9' '20000000,000000000,000000000,00000000.00') #(99 '9;9' '2000000,000000000,000000000,000000000.00') #(120 '1;2;0;0' '2000000000000000000000000000000,00,0.00') #(123 '1;2;3' '2,000,000,000,000,000,000,000,000,000,000,00,0.00') #(1230 '1;2;3;0;0' '2000000000000000000000000000,000,00,0.00') #(1234 '1;2;3;4' '2000,0000,0000,0000,0000,0000,0000,000,00,0.00') #(4321 '4;3;2;1' '2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,00,000,0000.00') #(9999 '9;9;9;9' '2000000,000000000,000000000,000000000.00'))
		do: 
			[:each |
			format grouping: each first.
			self assert: format numberGrouping equals: each second.
			format numberGrouping: each second.
			self assert: format grouping equals: each first.
			self assert: (subject printFloat: 2.0e33 format: format) equals: each last].
	#(-1 10000) do: 
			[:each |
			self should: [format grouping: each] raise: Error.
			format Grouping: each.
			self
				should: [subject printFloat: 1.23 format: format]
				raise: OS.HRESULTError
				matching: [:ex | ex tag = (OS.HRESULT win32Error: OS.Win32Errors.ERROR_INVALID_PARAMETER)]].
	self should: [format numberGrouping: '1;2;3;4;5'] raise: Error!

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
				raise: OS.Win32Error
				matching: [:ex | ex tag = (OS.HRESULT win32Error: OS.Win32Errors.ERROR_INVALID_PARAMETER)]]!

testPrintFloatSeparators
	"Test printing with different number grouping."

	| format subject |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	format
		decimalPlaces: 3;
		grouping: 43;
		decimalSeparator: $@;
		thousandSeparator: $^.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '123^456^7890@123'!

testStbRoundTrip
	| rehydrated bytes subject |
	subject := self defaultSubject.
	bytes := {subject. {subject}} binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated first identicalTo: subject.
	self assert: rehydrated second first identicalTo: subject.!

verifyEnglishDayOfWeek: aLocale
	"Note that this test is not sensitive to the configured first day of the week, because Locale>>dayOfWeek: always uses the US convention that Sunday is day 1. This is for interoperability with `Core.Date`."

	^#('SUnday' 'MONDAY' 'Tue' 'Wednesday' 'THU' 'friday' 'sat')
		keysAndValuesDo: [:eachKey :eachValue | self assert: (aLocale dayOfWeek: eachValue) equals: eachKey]!

verifyEnglishDayOfWeekNames: aLocale
	"Note that this test is not sensitive to the configured first day of the week, because Locale>>dayOfWeekName: always uses the US convention that Sunday is day 1. This is for interoperability with `Core.Date`."

	^self assert: ((1 to: 7) collect: [:i | aLocale dayOfWeekName: i])
		equals: #('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday')!

verifyEnglishMonthAbbreviations: aLocale
	^self assert: ((1 to: 12) collect: [:i | aLocale monthAbbreviation: i])
		equals: #('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')!

verifyEnglishMonthNames: aLocale
	^self assert: ((1 to: 12) collect: [:i | aLocale monthName: i])
		equals: #('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December')!

verifyEnglishNamesOfDays: aLocale
	"Note that this test is not sensitive to the configured first day of the week, because Locale>>nameOfDay: always uses the convention that Monday is day 1. For reasons of backwards compatibility with a historic Core.Date API, this is not consistent with some other Locale APIs that use the US convention. Locale>>dayOfWeekName: is a similar API that follows the US convention."

	^self assert: ((1 to: 7) collect: [:i | aLocale nameOfDay: i])
		equals: #('Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' 'Sunday')!

verifyIndexOfEnglishMonths: aLocale
	#('january' 'feb' 'march' 'apr' 'may' 'jun' 'july' 'aug' 'september' 'oct' 'november' 'dec')
		keysAndValuesDo: [:eachKey :eachValue | self assert: (aLocale indexOfMonth: eachValue) equals: eachKey]! !
!Core.Tests.LocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
displayScaledDecimal:in:!helpers!private! !
setUp!private!running! !
tearDown!private!running! !
testDisplayFloatOn!public!unit tests! !
testDisplayName!public!unit tests! !
testDisplayScaledDecimainOn!public!unit tests! !
testIsTurkic!public!unit tests! !
testName!public!unit tests! !
testNoUserOverrides!public!unit tests! !
testPrimary!public!unit tests! !
testPrintDateTimeOnFormat!public!unit tests! !
testPrintDurationOnFormat!public!unit tests! !
testPrintFloatGrouping!public!unit tests! !
testPrintFloatNumDigits!public!unit tests! !
testPrintFloatSeparators!public!unit tests! !
testStbRoundTrip!public!unit tests! !
verifyEnglishDayOfWeek:!helpers!private! !
verifyEnglishDayOfWeekNames:!helpers!private! !
verifyEnglishMonthAbbreviations:!helpers!private! !
verifyEnglishMonthNames:!helpers!private! !
verifyEnglishNamesOfDays:!helpers!private! !
verifyIndexOfEnglishMonths:!helpers!private! !
!

