"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Locale
	instanceVariableNames: 'numberFormat'
	classVariableNames: 'Invariant SystemDefault TimeZoneInfo UserDefault'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Locale guid: (GUID fromString: '{87b4c49a-026e-11d3-9fd7-00a0cc3e4a32}')!
Locale isAbstract: true!
Locale comment: ''!
!Locale categoriesForClass!System-Support! !
!Locale methodsFor!

= anObject
	"Answer whether the receiver and argument are equivalent (i.e. represent the same Locale)."

	^self == anObject or: [anObject species == self species and: [anObject name = self name]]!

amDesignator
	"Answer the String used in the receiver locale to designate AM (morning)."

	^self subclassResponsibility!

boolFormat
	"Answer an <Array> of two <String>s, being the representations for false and true in this Locale."

	^#('false' 'true')!

dateAndTimeFormatters
	^##(| formatters yyyyFormater |
	formatters := LookupTable new.
	"Date formats"
	formatters
		at: 'd' put: [:locale :date :stream | date dayOfMonth printOn: stream];
		at: 'dd'
			put: 
				[:locale :date :stream |
				date dayOfMonth
					printOn: stream
					base: 10
					nDigits: 2];
		at: 'ddd'
			put: [:locale :date :stream | stream nextPutAll: (locale dayOfWeekAbbreviation: date dayOfWeek)];
		at: 'dddd' put: [:locale :date :stream | stream nextPutAll: (locale dayOfWeekName: date dayOfWeek)];
		at: 'M' put: [:locale :date :stream | date month printOn: stream];
		at: 'MM'
			put: 
				[:locale :date :stream |
				date month
					printOn: stream
					base: 10
					nDigits: 2];
		at: 'MMM' put: [:locale :date :stream | stream nextPutAll: (locale monthAbbreviation: date month)];
		at: 'MMMM' put: [:locale :date :stream | stream nextPutAll: (locale monthName: date month)];
		at: 'y' put: [:locale :date :stream | stream nextPut: date year printString last];
		at: 'yy'
			put: 
				[:locale :date :stream |
				| year |
				year := date year rem: 100.
				year
					printOn: stream
					base: 10
					nDigits: (year negative ifTrue: [3] ifFalse: [2])].
	yyyyFormater := 
			[:locale :date :stream |
			| year |
			year := date year.
			date year
				printOn: stream
				base: 10
				nDigits: (year negative ifTrue: [5] ifFalse: [4])].
	formatters
		at: 'yyyy' put: yyyyFormater;
		at: 'yyyyy' put: yyyyFormater.
	"Time formats"
	formatters
		at: 'h' put: [:locale :time :stream | time hour12 printOn: stream];
		at: 'hh'
			put: 
				[:locale :time :stream |
				time hour12
					printOn: stream
					base: 10
					nDigits: 2];
		at: 'H' put: [:locale :time :stream | time hour24 printOn: stream];
		at: 'HH'
			put: 
				[:locale :time :stream |
				time hour24
					printOn: stream
					base: 10
					nDigits: 2];
		at: 'm' put: [:locale :time :stream | time minute printOn: stream];
		at: 'mm'
			put: 
				[:locale :time :stream |
				time minute
					printOn: stream
					base: 10
					nDigits: 2];
		at: 's' put: [:locale :time :stream | time second truncated printOn: stream];
		at: 'ss'
			put: 
				[:locale :time :stream |
				time second truncated
					printOn: stream
					base: 10
					nDigits: 2];
		at: 't'
			put: 
				[:locale :time :stream |
				stream
					nextPutAll: (time hour24 < 12 ifTrue: [locale shortAmDesignator] ifFalse: [locale shortPmDesignator])];
		at: 'tt'
			put: [:locale :time :stream | stream nextPutAll: (time hour24 < 12 ifTrue: [locale amDesignator] ifFalse: [locale pmDesignator])].
	1 to: 9
		do: 
			[:i |
			formatters at: (String new: i withAll: $f)
				put: 
					[:locale :time :stream |
					locale
						printFractionalPart: time second
						on: stream
						places: i].
			formatters at: (String new: i withAll: $F)
				put: 
					[:locale :time :stream |
					stream nextPutAll: locale decimalSeparator.
					(time second abs fractionPart * i exp10) rounded
						printOn: stream
						base: 10
						nDigits: i]].
	formatters)!

dateFormat
	"Answer the default date format for the receiver locale.
	The format characters are as listed below. All other characters are treated as 'fillers' and copied into the output stream verbatim.

		d		- Day of the month number, 1..31 (max)
		dd		- Date of the month padded with a leading 0 (if necessary) to two digits
		ddd		- Short name of the day of the week
		dddd		- Full name of the day of the week
		M		- Month number, 1..12
		MM		- Month number padded with a leading 0 (if necessary) to two digits
		MMM	- Short name of the month
		MMMM	- Name of the month
		y		- Single digit of year, i.e. year in the decade, 0..9
		yy		- Two digit year, i.e. year in the century, 0..99
		yyyy		- Four digit year
		yyyyy	- Ditto
	If the formatted date is BC, then the year formats will output a leading negative sign (typically '-').
	"

	^self shortDateFormat!

dayOfWeek: aString
	"Answer the 1-based <integer> index in a week, of the day named by the <String> argument, aString.
	Note that Sunday is always 1, and Saturday always 7 (but see #firstDayOfWeek)"

	^self subclassResponsibility!

dayOfWeekAbbreviation: anInteger
	"Answer a <String> that is the abbreviated name for the day of the week in this Locale whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self subclassResponsibility!

dayOfWeekName: anInteger
	"Answer a <String> that is the name of the day of the week in this Locale whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self subclassResponsibility!

dayOfWeekShortAbbreviation: anInteger
	"Answer a <String> that is the shortest abbreviated name in this Locale for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self subclassResponsibility!

decimalPlaces
	"Answer the decimal <integer> number of decimal places used in the receiver locale in the representation of numbers with a fractional part."

	^self subclassResponsibility!

decimalSeparator
	"Answer the decimal separator <String> used in the receiver locale in the representation of numbers with a fractional part, e.g. '.' or ','."

	^self subclassResponsibility!

displayDate: aDate on: aWriteStream
	"Append to the <puttableStream> argument, aWriteStream, a String whose characters are a representation of the <Date>, aDate, that a user in this <Locale> might expect to see."

	self
		printDate: aDate
		on: aWriteStream
		format: nil!

displayDateTime: aDate on: aWriteStream
	"Append to the <puttableStream> argument, aWriteStream, a <String> whose characters are a representation of the DateAndTime/TimeStamp/SYSTEMTIME, aDateTime, that a user in this <Locale> might expect to see."

	self
		printDateTime: aDate
		on: aWriteStream
		format: nil!

displayDuration: aDuration on: aWriteStream
	"Append to the <puttableStream> argument, aWriteStream, a <String> whose characters are a representation of the <Duration>, aDuration, that a user in this <Locale> might expect to see."

	self
		printDuration: aDuration
		on: aWriteStream
		format: nil!

displayFloat: aFloat on: aWriteStream
	"Append to the <puttableStream> argument, aWriteStream, a <String> whose characters are a representation of the <Float>, aFloat, that a user in this <Locale> might expect to see."

	self
		printFloat: aFloat
		on: aWriteStream
		format: self numberFormat!

displayName
	"The name of the locale in its native language."

	^self subclassResponsibility!

displayTime: aTime on: aWriteStream
	"Append to the <puttableStream> argument, aWriteStream, a <String> whose characters are a representation of the <Time>, aTime, that a user in this <Locale> might expect to see."

	self
		printTime: aTime
		on: aWriteStream
		format: nil!

durationFormat
	"Answer the format <String> used in this Locale (by default) for displaying a <Duration>.
	The format characters are as listed below. All other characters are treated as 'fillers' and copied into the output stream verbatim.
		-		- A '-' sign if the Duration being display is negative, otherwise nothing (no output)
		+		- A '+' sign if the Duration is positive (or zero), or a '-' sign if negative
		d		- Whole days
		h		- Whole hours (excluding whole days)
		hh		- Whole hours (excluding whole days), with a leading zero if < 10
		m		- Whole minutes (excluding whole days and hours)
		mm		- Whole minutes (excluding whole days and hours), with a leading zero if < 10
		s		- Whole seconds (excluding whole days, hours and minutes)
		ss		- Whole seconds(excluding whole days, hours and minutes), with a leading zero if < 10
		f,ff,etc	- Fractions of a seconds remaining (if any) excluding all larger measures, preceded by a decimal separator. Can be up to nine (fffffffff) for nanosecond precision. If there is no fraction part, there is no output.
		F,FF,etc	- Fractions of a seconds remaining excluding all larger measures, preceded by a decimal separator. Can be up to nine (FFFFFFFFF) for nanosecond precision.
		S		- Total seconds (including whole days, hours and minutes)
	"

	^self subclassResponsibility!

durationFormatters
	^##(| formatters formatter |
	formatters := LookupTable new.
	formatters at: '-'
		put: [:locale :duration :stream | duration negative ifTrue: [stream nextPutAll: locale negativeSign]].
	formatters at: '+'
		put: [:locale :duration :stream | stream nextPut: (duration negative ifTrue: [$-] ifFalse: [$+])].
	formatters at: 'd' put: [:locale :duration :stream | duration days abs printOn: stream].
	formatter := [:locale :duration :stream | duration hours abs printOn: stream].
	formatters
		at: 'h' put: formatter;
		at: 'H' put: formatter.
	formatter := 
			[:locale :duration :stream |
			duration hours abs
				printOn: stream
				base: 10
				nDigits: 2].
	formatters
		at: 'hh' put: formatter;
		at: 'HH' put: formatter.
	formatters
		at: 'm' put: [:locale :duration :stream | duration minutes abs printOn: stream];
		at: 'mm'
			put: 
				[:locale :duration :stream |
				duration minutes abs
					printOn: stream
					base: 10
					nDigits: 2];
		at: 's' put: [:locale :duration :stream | duration seconds truncated abs printOn: stream];
		at: 'ss'
			put: 
				[:locale :time :stream |
				time seconds truncated abs
					printOn: stream
					base: 10
					nDigits: 2];
		at: 'S' put: [:locale :duration :stream | duration asSeconds truncated printOn: stream].
	1 to: 9
		do: 
			[:i |
			formatters at: (String new: i withAll: $f)
				put: 
					[:locale :duration :stream |
					locale
						printFractionalPart: duration seconds
						on: stream
						places: i].
			formatters at: (String new: i withAll: $F)
				put: 
					[:locale :duration :stream |
					stream nextPutAll: locale decimalSeparator.
					(duration seconds abs fractionPart * i exp10) rounded
						printOn: stream
						base: 10
						nDigits: i]].
	formatters)!

englishDisplayName
	"The <String> full name of the locale in English."

	^self subclassResponsibility!

englishLanguageName
	"The <String> name of the language in English."

	^self subclassResponsibility!

firstDayOfWeek
	"Answer an <Integer> in the range 1..7 identifying the first day of the week, where 1 is Monday and 7 is Sunday."

	^self subclassResponsibility!

getNumberFormat
	^NUMBERFMTW new
		decimalPlaces: self decimalPlaces;
		hasLeadingZero: self hasLeadingZero;
		numberGrouping: self numberGrouping;
		decimalSeparator: self decimalSeparator;
		thousandSeparator: self thousandSeparator;
		negativeNumberMode: self negativeNumberMode;
		yourself!

hash
	"Answer whether the receiver and argument are equivalent (i.e. represent the same Locale)."

	^self name hash!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^self subclassResponsibility!

indexOfMonth: aString
	"Answer the 1-based <integer> index in a year (i.e. 1..12) of the month named by the <String> argument, asString, which is expected to be the full locale specific name of a month, or its abbreviated form, in upper or lower case."

	^self subclassResponsibility!

infinity
	"Answer the <String> representation for positive infinity in this locale (e.g the '∞' symbol)"

	^self subclassResponsibility!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^self subclassResponsibility!

iso639LanguageName
	"The two-character <String> name of the language of the primary language of the locale as defined in ISO-369."

	^self subclassResponsibility!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^self lcid ~~ LOCALE_CUSTOM_UNSPECIFIED!

isValid
	"Answer whether the receiver is a recognised (valid) Locale."

	^self subclassResponsibility!

languageId
	"Answer the <integer> Windows primary language id (the 10 low-order bits of the LCID)."

	^self lcid bitAnd: 16r3FF!

lastTwoDigitYear
	"Answer the <integer> year that is the end of the 100 year interval into which 2-digit years are interpreted.
	For example if this is 2049, then 49 is interpreter as 2049, and 50 as 1950."

	^self subclassResponsibility!

lcid
	"Answer the <integer> Windows Locale Id."

	^self subclassResponsibility!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists, typically a comma."

	^self subclassResponsibility!

localizedDisplayName
	"Answer the <String> name of the Locale in the current UI language of the host system."

	^self subclassResponsibility!

longDateFormat
	"Answer the long date format for the receiver locale. See #dateFormat for a description of the available format tokens."

	^self subclassResponsibility!

longTimeFormat
	"Answer the long time format for the receiver locale. See #timeFormat for a description of the available format tokens."

	^self subclassResponsibility!

monthAbbreviation: anInteger
	"Answer a <String> that is the localised short name of the month whose index is the argument, anInteger, where January is 1 and December is 12."

	^self subclassResponsibility!

monthName: anInteger
	"Answer a <String> that is the localised long name of the month whose index is the <integer> argument, anInteger, where January is 1 and December is 12."

	^self subclassResponsibility!

name
	"Answer the <String> unique name of the Locale."

	^self subclassResponsibility!

nan
	"Answer the <String> used to represen <Float> not-a-number values in this locale."

	^self subclassResponsibility!

nativeDigits
	"Answer a <String> which is the digit characters for zero through nine."

	^self subclassResponsibility!

negativeInfinity
	"Answer the <String> used to represent numeric negative infinity in this locale."

	^self subclassResponsibility!

negativeNumberMode
	^self subclassResponsibility!

negativeSign
	"Answer a <String> which is the symbol used to denote negative numbers in this locale."

	^self subclassResponsibility!

numberFormat
	^numberFormat
		ifNil: 
			[self numberFormat: self getNumberFormat.
			numberFormat isImmutable: true.
			numberFormat bytes isImmutable: true.
			numberFormat]!

numberFormat: aNUMBERFORMATWOrNil
	<mutable>
	numberFormat := aNUMBERFORMATWOrNil!

numberGrouping
	"Answer a <string> which describes the way in which number digits should be grouped in the receiver locale. The format string consists of a series of integers specifying from left to right how many digits of the number should be formed into a group before the next group (if needed), each group being separated by the 'thousands' separator for the locale. There can be up to 9 characters in the string. If the last character is zero, then the preceding group specification is repeated.
	Note that some of the examples in MSDN are incorrect:
		0		e.g. 1234567890 (no grouping)
		3;0		e.g. 1,234,567,890 (i.e. the traditional thousands grouping used in some locales such as en-US)
		3;0;0		e.g. 1234567,890
		3;2;0		e.g. 1,23,45,67,890
		3;2;0;0	e.g. 12345,67,890
	"

	^self subclassResponsibility!

percentSymbol
	"Answer a <String> containing the percent symbol for this local."

	^self subclassResponsibility!

pmDesignator
	"Answer the character used in the receiver locale to designate PM (afternoon)."

	^self subclassResponsibility!

primary
	"Answer the primary language locale for this Locale. For example fr-Fr is the primary locale for all the various French locales such as fr-CA."

	^Locale named: (self name copyFrom: 1 to: 2)!

print: anObject on: aWriteStream format: formatString alphabet: formatChars formatters: aLookupTable
	
	| ch formatStream tokenStream |
	tokenStream := formatString class writeStream: 9.
	formatStream := formatString readStream.
	ch := formatStream nextAvailable.
	[ch isNil] whileFalse: 
		[(formatChars includes: ch)
			ifTrue: 
				[| start |
				tokenStream reset.
				start := ch.
				
				[tokenStream nextPut: ch.
				ch := formatStream nextAvailable.
				ch = start] whileTrue.
				(aLookupTable at: tokenStream contents)
					value: self
					value: anObject
					value: aWriteStream]
			ifFalse: 
				[(#($' $\) includes: ch) 
					ifTrue: [
						ch == $\ ifTrue: [ch := formatStream next. aWriteStream nextPut: ch].
						ch == $' ifTrue: [aWriteStream nextPutAll: (formatStream upTo: $')]]
					ifFalse:[aWriteStream nextPut: ch].
				ch := formatStream nextAvailable]]!

printDate: aDate on: aWriteStream format: aString
	"Append to the <puttableStream>, aWriteStream, a <String> whose characters are a representation of the <Date> argument, aDate, formatted according to the format characters listed in the <String>, aString.
	For example:
		String streamContents: [:s | Locale default printDate: Date today on: s format: 'dddd, d of MMMM yyyy']
	"

	self
		print: aDate
		on: aWriteStream
		format: (aString ifNil: [self dateFormat])
		alphabet: 'yMdg'
		formatters: self dateAndTimeFormatters!

printDateTime: aDateTime on: aWriteStream format: aString
	"Append to the <puttableStream>, aWriteStream, a <String> whose characters are a representation of the argument, aDateAndTime, formatted according to the format characters listed in the <String>, aString.
	The Date/Time argument can be a DateAndTime, a SYSTEMTIME, or a TimeStamp.
	For example:
		{DateAndTime now. SYSTEMTIME now. TimeStamp current} collect: [:each |	
			String streamContents: [:s | Locale default printDateTime: each on: s format: 'h:mm tt (an\d ssffffff \secon\d\s) on dddd, d o\f MMMM yyyy']]
	"

	self
		print: aDateTime
		on: aWriteStream
		format: (aString ifNil: [
			"Use the same display format as the system does, e.g. in Explorer, which is date followed by time separated by a space."
			self dateFormat , ' ' , self timeFormat])
		alphabet: 'yMdghHmstfF'
		formatters: self dateAndTimeFormatters!

printDuration: aDuration on: aWriteStream format: aString
	"Append to the <puttableStream>, aWriteStream, a <String> whose characters are a representation of the <Duration> argument, aDuration, formatted according to the format characters listed in the <String>, aString.
	See durationFormat for a description of the format characters that can be used in the format string."

	self
		print: aDuration
		on: aWriteStream
		format: (aString ifNil: [self durationFormat])
		alphabet: '-+dhHmsSfF'
		formatters: self durationFormatters!

printFloat: aFloat
	"Answer a <String> representation of the <Float> argument in the format defined for this locale."

	^self
		printFloat: aFloat
		format: self numberFormat
		lcid: self lcid!

printFloat: aFloat format: aNUMBERFMT
	^self
		printFloat: aFloat
		format: aNUMBERFMT
		lcid: self lcid!

printFloat: aFloat format: aNUMBERFMT lcid: lcidInteger
	"Answer a <String> representation of the <Float> first argument in the format defined by the <NUMBERFMTW> 2nd argument. 
	If the number is negative, then the negative sign used is that associated with the locale identified by the <integer> LCID 3rd argument."

	"Implementation Note: I tried adding a primitive for this with code similar to that below, although failing for NaNs and Infinities, using the CRT _gcvt function to perform the initial conversion of the Float to an invariant String before the locale specific formatting is applied. Interestingly it actually runs more slowly!! This suggests that _gcvt is not very efficient."

	| localized classification size lib invariant |
	classification := aFloat fpClass.
	(classification anyMask: Float.FpClassFinite)
		ifFalse: 
			[^(classification anyMask: Float.FpClassNaN)
				ifTrue: [self nan]
				ifFalse: 
					["Not a NaN, so must be infinite"
					(classification anyMask: Float.FpClassNegative)
						ifTrue: [self negativeInfinity]
						ifFalse: [self infinity]]].
	"The Windows API takes a string as input in a canonical form"
	invariant := (classification anyMask: Float.FpClassZero)
				ifTrue: 
					[(classification anyMask: Float.FpClassNegative)
						ifTrue: [##('-0.0' asUtf16String)]
						ifFalse: [##('0.0' asUtf16String)]]
				ifFalse: 
					[| stream |
					stream := WriteStream on: (Utf16String new: 18).
					((classification anyMask: Float.FpClassNegative)
						ifTrue: 
							[stream nextPut: $-.
							aFloat negated]
						ifFalse: [aFloat])
							absPrintOn: stream
							base: 10
							digitCount: 17
							decimalExponents: ##(SmallInteger minimum to: SmallInteger maximum).
					stream grabContents].
	lib := KernelLibrary default.
	size := lib
				getNumberFormat: lcidInteger
				dwFlags: 0
				lpValue: invariant
				lpFormat: aNUMBERFMT
				lpNumberStr: nil
				cchNumber: 0.
	size == 0 ifTrue: [^lib systemError].
	localized := Utf16String new: size - 1.
	lib
		getNumberFormat: lcidInteger
		dwFlags: 0
		lpValue: invariant
		lpFormat: aNUMBERFMT
		lpNumberStr: localized
		cchNumber: size.
	^localized!

printFloat: aFloat on: aStream format: aNUMBERFMT
	"Append, to aStream, a String whose characters are a representation of the <Float> argument, aFloat, in <integer> base, baseInteger, using the formatting instructions specified by the <NUMBERFMT>, aNUMBERFMT."

	aStream nextPutAll: (self
				printFloat: aFloat
				format: aNUMBERFMT
				lcid: self lcid)!

printFractionalPart: aFraction on: aStream places: anInteger
	| fractionPart |
	fractionPart := aFraction abs fractionPart.
	fractionPart == 0
		ifFalse: 
			[| digits count |
			digits := (fractionPart * anInteger exp10) rounded printStringBase: 10 nDigits: anInteger.
			count := digits size.
			[count > 1 and: [(digits at: count) = $0]] whileTrue: [count := count - 1].
			aStream
				nextPutAll: self decimalSeparator;
				next: count
					putAll: digits
					startingAt: 1]!

printTime: aTime on: aWriteStream format: aString
	"Append to the <puttableStream>, aWriteStream, a <String> whose characters are a representation of the <Time> argument, aTime, formatted according to the format characters listed in the <String>, aString.
	For example:
		String streamContents: [:s | Locale default printTime: Time now on: s format: 'H:mm:ss.fff']
	"

	self
		print: aTime
		on: aWriteStream
		format: (aString ifNil: [self timeFormat])
		alphabet: 'hHmstf'
		formatters: self dateAndTimeFormatters!

shortAmDesignator
	"Answer the short <String> used in the receiver locale to designate AM (morning)."

	^self subclassResponsibility!

shortDateFormat
	"Answer the short date format for the receiver locale. See #dateFormat for a description of the available format tokens."

	^self subclassResponsibility!

shortPmDesignator
	"Answer the short <String> used in the receiver locale to designate PM (afternoon)."

	^self subclassResponsibility!

shortTimeFormat
	"Answer the short time format for the receiver locale. See #timeFormat for a description of the available format tokens."

	^self subclassResponsibility!

subLanguageId
	"Answer the <integer> Windows sub-language id (the 6 high-order bits of the LCID)."

	^self lcid bitShift: -10!

tag
	"Answer the RFC4646 language tag for this locale."

	^self subclassResponsibility!

thousandSeparator
	"Answer the thousands separator String used in the receiver locale."

	^self subclassResponsibility!

timeFormat
	"Answer the default time format for the receiver locale.
	The format characters are as listed below. All other characters are treated as 'fillers' and copied into the output stream verbatim.
		h	- Hour of the day from the 12 hour clock
		hh	- Hour of the day from the 12 hour clock, with a leading zero if < 10
		H	- Hour of the day from the 24 hour clock
		HH	- Hour of the day from the 24 hour clock, with a leading zero if < 10
		m	- Whole minutes (excluding whole days and hours)
		mm	- Whole minutes (excluding whole days and hours), with a leading zero if < 10
		s	- Whole seconds (excluding whole days, hours and minutes)
		ss	- Whole seconds(excluding whole days, hours and minutes), with a leading zero if < 10
		f+	- Fractions of a seconds remaining excluding all larger measures. Can be up to nine (fffffffff) for a value in nanoseconds"

	^self longTimeFormat!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^self subclassResponsibility! !
!Locale categoriesFor: #=!comparing!public! !
!Locale categoriesFor: #amDesignator!constants!public! !
!Locale categoriesFor: #boolFormat!constants!public! !
!Locale categoriesFor: #dateAndTimeFormatters!printing!private! !
!Locale categoriesFor: #dateFormat!constants!public! !
!Locale categoriesFor: #dayOfWeek:!mapping!public! !
!Locale categoriesFor: #dayOfWeekAbbreviation:!constants!public! !
!Locale categoriesFor: #dayOfWeekName:!constants!public! !
!Locale categoriesFor: #dayOfWeekShortAbbreviation:!constants!public! !
!Locale categoriesFor: #decimalPlaces!constants!public! !
!Locale categoriesFor: #decimalSeparator!constants!public! !
!Locale categoriesFor: #displayDate:on:!printing!public! !
!Locale categoriesFor: #displayDateTime:on:!printing!public! !
!Locale categoriesFor: #displayDuration:on:!printing!public! !
!Locale categoriesFor: #displayFloat:on:!printing!public! !
!Locale categoriesFor: #displayName!displaying!public! !
!Locale categoriesFor: #displayTime:on:!printing!public! !
!Locale categoriesFor: #durationFormat!constants!public! !
!Locale categoriesFor: #durationFormatters!printing!private! !
!Locale categoriesFor: #englishDisplayName!constants!public! !
!Locale categoriesFor: #englishLanguageName!constants!public! !
!Locale categoriesFor: #firstDayOfWeek!constants!public! !
!Locale categoriesFor: #getNumberFormat!helpers!private! !
!Locale categoriesFor: #hash!comparing!public! !
!Locale categoriesFor: #hasLeadingZero!constants!public! !
!Locale categoriesFor: #indexOfMonth:!enquiries!public! !
!Locale categoriesFor: #infinity!constants!public! !
!Locale categoriesFor: #isInstalled!public!testing! !
!Locale categoriesFor: #iso639LanguageName!constants!public! !
!Locale categoriesFor: #isSelfEvaluating!public!testing! !
!Locale categoriesFor: #isValid!public!testing! !
!Locale categoriesFor: #languageId!accessing!public! !
!Locale categoriesFor: #lastTwoDigitYear!constants!public! !
!Locale categoriesFor: #lcid!accessing!public! !
!Locale categoriesFor: #listSeparator!constants!public! !
!Locale categoriesFor: #localizedDisplayName!constants!public! !
!Locale categoriesFor: #longDateFormat!constants!public! !
!Locale categoriesFor: #longTimeFormat!constants!public! !
!Locale categoriesFor: #monthAbbreviation:!enquiries!public! !
!Locale categoriesFor: #monthName:!enquiries!public! !
!Locale categoriesFor: #name!constants!public! !
!Locale categoriesFor: #nan!constants!public! !
!Locale categoriesFor: #nativeDigits!constants!public! !
!Locale categoriesFor: #negativeInfinity!constants!public! !
!Locale categoriesFor: #negativeNumberMode!constants!public! !
!Locale categoriesFor: #negativeSign!constants!public! !
!Locale categoriesFor: #numberFormat!constants!public! !
!Locale categoriesFor: #numberFormat:!accessing!private! !
!Locale categoriesFor: #numberGrouping!constants!public! !
!Locale categoriesFor: #percentSymbol!constants!public! !
!Locale categoriesFor: #pmDesignator!constants!public! !
!Locale categoriesFor: #primary!printing!public! !
!Locale categoriesFor: #print:on:format:alphabet:formatters:!printing!private! !
!Locale categoriesFor: #printDate:on:format:!printing!public! !
!Locale categoriesFor: #printDateTime:on:format:!printing!public! !
!Locale categoriesFor: #printDuration:on:format:!printing!public! !
!Locale categoriesFor: #printFloat:!printing!public! !
!Locale categoriesFor: #printFloat:format:!printing!public! !
!Locale categoriesFor: #printFloat:format:lcid:!printing!public! !
!Locale categoriesFor: #printFloat:on:format:!printing!public! !
!Locale categoriesFor: #printFractionalPart:on:places:!printing!private! !
!Locale categoriesFor: #printTime:on:format:!printing!public! !
!Locale categoriesFor: #shortAmDesignator!constants!public! !
!Locale categoriesFor: #shortDateFormat!constants!public! !
!Locale categoriesFor: #shortPmDesignator!constants!public! !
!Locale categoriesFor: #shortTimeFormat!constants!public! !
!Locale categoriesFor: #subLanguageId!accessing!public! !
!Locale categoriesFor: #tag!constants!public! !
!Locale categoriesFor: #thousandSeparator!constants!public! !
!Locale categoriesFor: #timeFormat!constants!public! !
!Locale categoriesFor: #yearMonthFormat!constants!public! !

!Locale class methodsFor!

default
	"Answer the instance of the receiver which represents the default user locale."

	^self userDefault!

getTimeZoneInfo
	| timeZoneInfo rc |
	timeZoneInfo := TIME_ZONE_INFORMATION new.
	rc := KernelLibrary default getTimeZoneInformation: timeZoneInfo.
	rc = -1 ifTrue: [^KernelLibrary default systemError].
	timeZoneInfo zoneId: rc.
	^timeZoneInfo!

initialize
	"We need to know if localisation settings are changed."

	SessionManager current
		when: #settingChanged:
		send: #onSettingChanged:
		to: self!

installedSystemLocales
	"Private - Answer the installed Win32 system locales.
		Locale installedSystemLocales
	"

	^WindowsLocale systemLocales: LCID_INSTALLED!

invariant
	"Answer the instance of the receiver which represents the invariant locale."

	^Invariant ifNil: [Invariant := self lcid: LOCALE_INVARIANT]!

lcid: anLCID
	"Answer an instance of the receiver to represent the Locale with the specified id."

	^WindowsLocale new lcid: anLCID!

makeLangId: langIdBits subLang: subLangIdBits
	"Private - Answer a Win32 language Id word constructed from langIdBits (10 bits
	are significant) and subLangIdBits (6 bits are significant)."

	^(subLangIdBits bitAnd: 63) << 10 bitOr: (langIdBits bitAnd: 1023)!

makeLcId: langIdWord sortId: sortIdBits
	"Private - Answer a Win32 Locale Id dword constructed from langIdWord and 
	sortIdBits (4 bits are significant).
		#define MAKELCID(lgid) ((unsigned long)(((unsigned short)(lgid)) | (((unsigned long)((unsigned short)(0))) << 16)))
	"

	^(sortIdBits bitAnd: 16rF) << 16 
		bitOr: (langIdWord bitAnd: 16rFFFF)!

named: aString
	"Answer a sub-instance of the receiver to represent the Locale with the specified name."

	^(aString sameAs: 'smalltalk') ifTrue: [self smalltalk] ifFalse: [WindowsLocale named: aString]!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any lazily initialized variables held by the receiver."

	Invariant := nil.
	self reset!

onSettingChanged: anArray
	"Private - A system setting has been changed. If it is anything to do with localisation, then clear the cached values."

	| setting |
	setting := anArray first.
	setting = 'Time'
		ifTrue: 
			["At least one WM_TIMECHANGE has been received. This happens when something (the user, an app) changes the system time or timezone, but also when entering/leaving daylight saving time."
			TimeZoneInfo := nil.
			^self].
	anArray first = 'intl' ifFalse: [^self].
	"International settings have been changed"
	self onStartup!

onStartup
	"Private - The system has just started. Adjust any locale specific
	information (e.g. Dates and Times). Can be sent at other times
	if the Locale has been changed."

	self withAllSubclassesDo: [:each | each reset]!

reset
	TimeZoneInfo := nil!

smalltalk
	"Answer the special 'Smalltalk' locale instance. This isn't a real Locale, but is configured to print Floats, etc, in Smalltalk syntax."

	^SmalltalkLocale.Current!

supportedSystemLocales
	"Private - Answer the supported Win32 system locales.
		Locale supportedSystemLocales
	"

	^WindowsLocale systemLocales: LCID_SUPPORTED!

systemDefault
	"Answer the instance of the receiver which represents the default system locale."

	^SystemDefault ifNil: [SystemDefault := self lcid: KernelLibrary default getSystemDefaultLCID]!

timeZoneInformation
	^TimeZoneInfo ifNil: [TimeZoneInfo := self getTimeZoneInfo]!

uiDefault
	^self lcid: KernelLibrary default getThreadUILanguage!

userDefault
	"Answer the instance of the receiver which represents the default user locale."

	^UserDefault!

userDefault: aLocale
	| oldDefault |
	oldDefault := UserDefault.
	UserDefault := aLocale ifNil: [self uiDefault].
	^oldDefault! !
!Locale class categoriesFor: #default!accessing!public! !
!Locale class categoriesFor: #getTimeZoneInfo!enquiries!public! !
!Locale class categoriesFor: #initialize!class initialization!public! !
!Locale class categoriesFor: #installedSystemLocales!enquiries!private! !
!Locale class categoriesFor: #invariant!instance creation!public! !
!Locale class categoriesFor: #lcid:!instance creation!public! !
!Locale class categoriesFor: #makeLangId:subLang:!enquiries!private! !
!Locale class categoriesFor: #makeLcId:sortId:!enquiries!private! !
!Locale class categoriesFor: #named:!instance creation!public! !
!Locale class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Locale class categoriesFor: #onSettingChanged:!event handling!private! !
!Locale class categoriesFor: #onStartup!event handling!private! !
!Locale class categoriesFor: #reset!initializing!private! !
!Locale class categoriesFor: #smalltalk!instance creation!public! !
!Locale class categoriesFor: #supportedSystemLocales!enquiries!private! !
!Locale class categoriesFor: #systemDefault!instance creation!public! !
!Locale class categoriesFor: #timeZoneInformation!enquiries!public! !
!Locale class categoriesFor: #uiDefault!instance creation!public! !
!Locale class categoriesFor: #userDefault!instance creation!public! !
!Locale class categoriesFor: #userDefault:!instance creation!public! !

