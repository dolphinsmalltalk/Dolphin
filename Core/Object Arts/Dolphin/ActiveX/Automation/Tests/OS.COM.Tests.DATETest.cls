"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.DATETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.DATE private})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.DATETest guid: (Core.GUID fromString: '{3c124064-e61a-4110-a40e-406fd1be6658}')!

OS.COM.Tests.DATETest comment: ''!

!OS.COM.Tests.DATETest methodsFor!

exampleValueAndUkStringPairs
	"Note the weird behaviour of VarBstrFromDate whereby it omits the date part for year 0, which looks like a bug. Similarly the time is omitted if the fraction is 0 (unless the whole date is zero). VarBstrFromDate does accept flags that can be used to request just the date or time portions, but it seems incorrect to return these implicitly for certain boundaries.
	Also note how for negative dates, the fraction part still represents a positive time offset. Mathematically this is rather odd, and means the two parts must be handled separately in conversions."

	^#(-1.25 '29/12/1899 06:00:00' -0.75 '18:00:00' -1 '29/12/1899' -2.756 '28/12/1899 18:08:38' -0.0 '00:00:00' 0.0 '00:00:00' 1 '31/12/1899' 1.25 '31/12/1899 06:00:00' 3.756 '02/01/1900 18:08:38' 2.958465999988426e6 '31/12/9999 23:59:59' -657434.9999884259 '01/01/100 23:59:59' -657434.0 '01/01/100' -109205.0 '01/01/1601')!

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
	{ LowerBound. UpperBound } do: 
			[:invalid |
			| date |
			date := DATE new.
			"We have to bypass the mutator, which would throw for invalid oledate values"
			date bytes doubleAtOffset: 0 put: invalid.
			self should: [date asString] raise: HRESULTError]!

testByteSize
	self assert: DATE byteSize equals: 8.
	self assert: DATE new byteSize equals: 8!

testDateAndTimeConversions
	| onesec tzo |
	onesec := 1.0 / Duration.SecondsPerDay.
				tzo := Locale timeZoneInformation offset.
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
		{ '0100-01-01T23:59:59Z'. LowerBound + onesec }.
		{ '9999-12-31T23:59:59Z'. UpperBound - onesec }.
		{ '9999-12-31T23:59:59.999919534Z'. UpperBound - 1.0e-9 }.
		{ '1899-12-30T00:00:01.0Z'. onesec }.
		{ '1899-12-30T00:00:01Z'. onesec negated }.
		{ '1899-12-30T23:59:59Z'. 1.0 - onesec }.
		{ '1899-12-30T23:59:59Z'. -1.0 + onesec }.
		{ '1900-01-01T23:59:59.6Z'. 2.0 + (86399.6 / Duration.SecondsPerDay) }.
		{ '1899-12-28T23:59:59.6Z'. -2.0 - (86399.6 / Duration.SecondsPerDay) }.
		#('1900-01-01T12:00:10.6665984Z' 2.500123456).
		#('1899-12-28T12:01:25.3333056Z' -2.500987654).
		#('1900-01-09T00:00:00.000000009Z' 10.0000000000001)
	} do: 
				[:pair |
				| each value oledate rounded local actual |

				each := (DateAndTime fromString: pair first) - tzo.
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
				rounded year <= MaxYear ifTrue: [self assert: oledate asSYSTEMTIME equals: rounded asSYSTEMTIME].
				actual := (DATE fromFloat: value) asDateAndTime.
				self assert: (actual closeTo: local precision: 1 milliseconds).
				self
					assert: actual asDATE asFloat
					closeTo: oledate asFloat
					precision: 1e-12.
				"DATEs are considered to be in local time"
				self assert: actual offset equals: Locale timeZoneInformation offset].

	"Out of range. OLE DATEs are limited to a documented range more restrictive than the representation would allow."
	{
		(DateAndTime fromString: ' 9999-12-31T23:59:59Z') + 1 seconds - tzo.
		(DateAndTime fromString: ' 0100-01-01T00:00:00Z') - 1 days - tzo.
		(DateAndTime fromString: ' 0100-01-01T00:00:00Z') - 1 seconds - tzo
	} do: [:each | self should: [each asDATE] raise: InvalidArgumentError]!

testDisplayString
	| stream |
	stream := (Locale named: 'en-GB') writeStream.
	self exampleValueAndUkStringPairs pairsDo: 
			[:oledate :expected |
			(DATE fromFloat: oledate) displayOn: stream.
			self assert: stream contents equals: expected.
			stream reset].
	{ Float fmax. Float infinity. Float negativeInfinity. LowerBound. UpperBound } do: 
			[:invalid |
			| date |
			date := DATE new.
			date bytes doubleAtOffset: 0 put: invalid.
			self should: [date displayOn: stream] raise: HRESULTError]!

testDisplayStringJustBeforeMidnight
	"Checking rollover for fractions of a day that round up to a whole day when converting to a DateAndTime (which rounds because the precision of the DATE representation is quite limited)"

	| beforeMidnight stream string |
	beforeMidnight := DATE fromFloat: 1521.9999999999998.
	"Smalltalk locale will translate to a DateAndTime precisely without rounding"
	stream := Locale smalltalk writeStream.
	beforeMidnight displayOn: stream.
	string := stream contents.
	self assert: string equals: '1904-02-29 23:59:59'.!

testDisplayStringMidnightBug
	"Just documenting a bug in the VarBstrFromDate API. If the time is very close to midnight, the API rounds up to 24 hours and then fails to rollover to the next day. In practice this is extremely unlikely to be encountered."

	<skip: 'Known Windows bug'>
	| beforeMidnight stream string |
	beforeMidnight := DATE fromFloat: 1521.9999999999998.
	"Windows Locale will use VarBstrFromDate API, and round up without rollover"
	stream := Locale invariant writeStream.
	beforeMidnight displayOn: stream.
	string := stream contents.
	self assert: string equals: '1904-02-29 23:59:59'.
!

testFromInvalidFloat
	{ Float fmax. Float infinity. Float negativeInfinity. Float nan. LowerBound. UpperBound }
		do: [:invalid | self should: [DATE fromFloat: invalid] raise: InvalidArgumentError]!

testMaximum
	| maxValue next |
	self assert: MaxYear equals: 9999.
	maxValue := DATE maximum.
	self assert: maxValue asString equals: '12/31/9999 23:59:59'.
	self assert: maxValue asDateAndTime
		equals: (DateAndTime
				rataDie: 3652059
				seconds: 86399.99995976686
				offsetSeconds: Locale timeZoneInformation offsetSeconds).
	"Even one ULP larger, the minimum should be invalid"
	next := (MaxValue bitRepresentation + 1) becomeA: Float.
	self assert: next equals: UpperBound.
	self should: [DATE fromFloat: next] raise: InvalidArgumentError!

testMinimum
	| minValue next realMin |
	self assert: MinYear equals: 100.
	minValue := DATE fromFloat: MinValue.
	self assert: minValue asString equals: '01/01/100 23:59:59'.
	"The minimum value is actually a later moment because of the fractional day being a positive offset even for negative DATE values. As the system time conversions truncate or round to seconds, it isn't possible to represent sub-second moments accurately within the last second of the first representable day, even though numerically DATE can do so."
	self
		assert: minValue asDateAndTime - DATE minimum asDateAndTime
		closeTo: 24 hours
		precision: 1 seconds.
	"Even one ULP larger, the minimum should roll to the next day"
	next := DATE fromFloat: (MinValue bitRepresentation + 1 becomeA: Float).
	self assert: next asString equals: '01/02/100'.
	"But note that in the more accurate DateAndTime representation it hasn't rolled yet. This is due to the design of the DATE representation."
	self assert: next value
		equals: (DateAndTime
				rataDie: 36160
				seconds: 86399.50000271201
				offsetSeconds: Locale timeZoneInformation offsetSeconds).
	"Due to the DATE representation of fractional days, where the offset is always positive, the real minimum DATE is a smaller magnitude."
	realMin := DATE minimum.
	self assert: realMin asString equals: '01/01/100'.
	self assert: realMin value
		equals: (DateAndTime
				year: 100
				day: 1
				offset: Locale timeZoneInformation offset).
	self should: [DATE fromFloat: LowerBound] raise: InvalidArgumentError! !

!OS.COM.Tests.DATETest categoriesForMethods!
exampleValueAndUkStringPairs!constants!private! !
testAsString!public!unit tests! !
testByteSize!public!unit tests! !
testDateAndTimeConversions!public!unit tests! !
testDisplayString!public!unit tests! !
testDisplayStringJustBeforeMidnight!public!unit tests! !
testDisplayStringMidnightBug!public!unit tests! !
testFromInvalidFloat!public!unit tests! !
testMaximum!public!unit tests! !
testMinimum!public!unit tests! !
!

