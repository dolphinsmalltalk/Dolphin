"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.DATETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.DATETest guid: (Core.GUID fromString: '{3c124064-e61a-4110-a40e-406fd1be6658}')!

OS.COM.Tests.DATETest comment: ''!

!OS.COM.Tests.DATETest methodsFor!

exampleValueAndUkStringPairs
	"Note the weird behaviour of VarBstrFromDate whereby it emits the date part if the day is the OLE date epoch, which looks like a bug. Similarly the time is omitted if the fraction is 0. VarBstrFromDate does accept flags that can be used to request just the date or time portions, but it seems incorrect to return these implicitly for certain boundaries.
	Also note how for negative dates, the fraction part still represents a positive time offset. Mathematically this is rather odd, and means the two parts must be handled separately in conversions."

	^#(-1.25 '29/12/1899 06:00:00' -0.75 '18:00:00' -1 '29/12/1899' -2.756 '28/12/1899 18:08:38' -0.0 '00:00:00' 0.0 '00:00:00' 1 '31/12/1899' 1.25 '31/12/1899 06:00:00' 3.756 '02/01/1900 18:08:38' 2.958465999988426e6 '31/12/9999 23:59:59' -657434.9999884259 '01/01/100 23:59:59' -657434.0 '01/01/100')!

testAsString
	"Converts to/from invariant form, which uses the US date format."

	| parsed dateVal |
	#(-1.25 '12/29/1899 06:00:00' -0.75 '18:00:00' -1 '12/29/1899' -2.756 '12/28/1899 18:08:38' 0 '00:00:00' 1 '12/31/1899' 1.25 '12/31/1899 06:00:00' 3.756 '01/02/1900 18:08:38' 2.958465999988426e6 '12/31/9999 23:59:59' -657434.9999884259 '01/01/100 23:59:59' -657434.0 '01/01/100')
		pairsDo: 
			[:each :expected |
			| string oledate |
			oledate := DATE fromFloat: each.
			string := oledate asString.
			self assert: string equals: expected.
			parsed := Locale invariant parseDATE: string.
			"DATE values in the interval (-1, 0) are equivalent to those in the interval (0, 1) because of the way the fraction of a day is always a positive offset."
			dateVal := (each < 0 and: [each > -1]) ifTrue: [each abs] ifFalse: [each].
			self
				assert: parsed asFloat
				closeTo: dateVal
				precision: 1e-5].
	{ DATE.MinBound. DATE.MaxBound } do: 
			[:invalid |
			| date |
			date := DATE new.
			"We have to bypass the mutator, which would throw for invalid oledate values"
			date bytes doubleAtOffset: 0 put: invalid.
			self should: [date asString] raise: HRESULTError]!

testDateAndTimeConversions
	| onesec |
	onesec := 1.0 / Duration.SecondsPerDay.
	{
		#('1899-12-30T00:00:00.0Z' 0.0).
		#('1899-12-30T06:00:00.0Z' 0.25).
		#('1899-12-30T12:00:00.0Z' 0.5).
		#('1899-12-30T18:00:00.0Z' 0.75).
		#('1899-12-31T00:00:00Z' 1.0).
		#('1899-12-31T06:00:00Z' 1.25).
		#('1899-12-31T18:00:00Z' 1.75).
		#('1900-01-09T12:00:00Z' 10.5).
		#('2000-02-29T12:59:59.666666666-12:30' 36586.062496141974).
		#('1899-12-30T00:00:00.0Z' -0.0).
		#('1899-12-30T06:00:00Z' -0.25).
		#('1899-12-30T12:00:00Z' -0.5).
		#('1899-12-30T18:00:00Z' -0.75).
		#('1899-12-29T00:00:00Z' -1.0).
		#('1899-12-29T06:00:00Z' -1.25).
		#('1899-12-29T18:00:00Z' -1.75).
		#('1899-12-20T12:00:00Z' -10.5).
		#('1899-12-29T12:34:56+00:00' -1.5242592592592592).
		{ '1899-12-31T00:00:01Z'. 1.0 + onesec }.
		{ '1899-12-29T00:00:01Z'. -1.0 - onesec }.
		{ '0100-01-01T23:59:59Z'. DATE.MinBound + onesec }.
		{ '9999-12-31T23:59:59Z'. DATE.MaxBound - onesec }.
		{ '9999-12-31T23:59:59.999919534Z'. DATE.MaxBound - 1.0e-9 }.
		{ '1899-12-30T00:00:01.0Z'. onesec }.
		{ '1899-12-30T00:00:01Z'. onesec negated }.
		{ '1899-12-30T23:59:59Z'. 1.0 - onesec }.
		{ '1899-12-30T23:59:59Z'. -1.0 + onesec }.
		{ '1900-01-01T23:59:59.6Z'. 2.0 + (86399.6 / Duration.SecondsPerDay) }.
		{ '1899-12-28T23:59:59.6Z'. -2.0 - (86399.6 / Duration.SecondsPerDay) }.
		#('1900-01-01T12:00:10.6665984Z' 2.500123456).
		#('1899-12-28T12:01:25.3333056Z' -2.500987654).
		#('1900-01-09T00:00:00.000000009' 10.0000000000001)
	} do: 
				[:pair |
				| each value oledate rounded local actual |
				each := DateAndTime fromString: pair first.
				value := pair second.
				local := each asLocal.
				"DATE>>fromString: uses VarDateFromStr(), so it should be correct"
				rounded := local roundTo: 1 seconds.
				oledate := local asDATE.
				self
					assert: oledate asFloat
					closeTo: ((value < 0 and: [value > -1])
							ifTrue: 
								["Ambiguous region: |date| < 1"
								value abs]
							ifFalse: [value])
					precision: 1e-12.
				"VariantTimeToSystemTime rounds any fractional seconds in the ole date"
				rounded year < 10000 ifTrue: [self assert: oledate asSYSTEMTIME equals: rounded asSYSTEMTIME].
				actual := (DATE fromFloat: value) asDateAndTime.
				self assert: (actual closeTo: local precision: 1 milliseconds).
				self assert: actual asDATE equals: oledate.
				"DATEs are considered to be in local time"
				self assert: actual offset equals: Locale timeZoneInformation offset].

	"Out of range. OLE DATEs are limited to a documented range more restrictive than the representation would allow."
	{
		(DateAndTime fromString: ' 9999-12-31T23:59:59Z') + 1 seconds.
		(DateAndTime fromString: ' 0100-01-01T00:00:00Z') - 1 days.
		(DateAndTime fromString: ' 0100-01-01T00:00:00Z') - 1 seconds
	} do: [:each | self should: [each asDATE] raise: InvalidArgumentError]!

testDisplayString
	| stream |
	stream := (Locale named: 'en-GB') writeStream.
	self exampleValueAndUkStringPairs pairsDo: 
			[:oledate :expected |
			(DATE fromFloat: oledate) displayOn: stream.
			self assert: stream contents equals: expected.
			stream reset].
	{ Float fmax. Float infinity. Float negativeInfinity. DATE.MinBound. DATE.MaxBound } do: 
			[:invalid |
			| date |
			date := DATE new.
			date bytes doubleAtOffset: 0 put: invalid.
			self should: [date displayOn: stream] raise: HRESULTError]!

testFromInvalidFloat
	{ Float fmax. Float infinity. Float negativeInfinity. Float nan. DATE.MinBound. DATE.MaxBound }
		do: [:invalid | self should: [DATE fromFloat: invalid] raise: InvalidArgumentError]! !

!OS.COM.Tests.DATETest categoriesForMethods!
exampleValueAndUkStringPairs!constants!private! !
testAsString!public!unit tests! !
testDateAndTimeConversions!public!unit tests! !
testDisplayString!public!unit tests! !
testFromInvalidFloat!public!unit tests! !
!

