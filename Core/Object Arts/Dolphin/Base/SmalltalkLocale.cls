"Filed out from Dolphin Smalltalk 7"!

Locale subclass: #SmalltalkLocale
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SmalltalkLocale guid: (GUID fromString: '{06088e6e-01bc-4518-a4a5-73088615fdd8}')!
SmalltalkLocale comment: ''!
!SmalltalkLocale categoriesForClass!Unclassified! !
!SmalltalkLocale methodsFor!

amDesignator
	"Answer the String used in the receiver locale to designate AM (morning)."

	^'am'!

code
	"Answer the RFC4646 locale code (aka tag) for this locale."

	^''!

dayOfWeek: aString
	"Answer the 1-based <integer> index in a week, of the day named by the <String> argument, aString.
	Note that Monday is always 1, and Sunday always 7 (but see #firstDayOfWeek)"

	^##(LookupTable withAll: {'monday' -> 2.
				'mon' -> 2.
				'tue' -> 3.
				'tuesday' -> 3.
				'wed' -> 4.
				'wednesday' -> 4.
				'thu' -> 5.
				'thursday' -> 5.
				'fri' -> 6.
				'friday' -> 6.
				'saturday' -> 7.
				'sat' -> 7.
				'sunday' -> 1.
				'sun' -> 1})
		at: aString asLowercase!

dayOfWeekAbbreviation: anInteger
	"Answer a <String> that is the localised abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^#('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat') at: anInteger!

dayOfWeekName: anInteger
	"Answer a <String> that is the localised name of the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^#('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday') at: anInteger!

dayOfWeekShortAbbreviation: anInteger
	"Answer a <String> that is the localised shortest abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^#('Su' 'Mo' 'Tu' 'We' 'Th' 'Fr' 'Sa') at: anInteger!

decimalPlaces
	^9!

decimalSeparator
	"Answer the decimal separator <String> used in the receiver locale in the representation of numbers with a fractional part."

	^'.'!

displayDuration: aDuration on: aPuttableStream
	"Display a friendly but concise representation of the <Duration> argument onto the <puttableStream> argument."

	| seconds |
	seconds := aDuration negative
				ifTrue: 
					[aPuttableStream nextPutAll: self negativeSign.
					aDuration asSeconds negated]
				ifFalse: [aDuration asSeconds].
	#(#(86400 'day' 2 ##(1 / 100)) #(3600 'hour' 2 ##(1 / 100)) #(60 'minute' 2 ##(1 / 100)) #(1 's' 1 ##(1
		/ 100)) #(0.001 'ms' 1 ##(1 / 10)) #(1.0e-6 'µs' 1 ##(1/10)) #(1.0e-9 'ns' 1 1)) detect: 
				[:each |
				| value |
				value := seconds / each first.
				value >= each third and: 
						[| units |
						units := each second.
						value := value roundTo: each last.
						aPuttableStream
							print: (value fractionPart = 0 ifTrue: [value] ifFalse: [value asFloat]);
							space;
							nextPutAll: units.
						(value = 1 or: [units last asLowercase = $s]) ifFalse: [aPuttableStream nextPut: $s].
						true]]
			ifNone: [aPuttableStream nextPutAll: '0 s']!

displayFloat: aFloat on: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver in the base, anInteger, as a user in the <Locale>, aLocale, would want to see it."

	aFloat printOn: aStream base: 10!

displayName
	"The name of the locale in its native language."

	^'Smalltalk'!

displayOn: aStream
	"Append a displayable representation of the receiver to aStream."

	aStream nextPutAll: self displayName!

durationFormat
	"Answer the format <String> used in this Locale (by default) for printing a <Duration>.
	See superclass method for a description of the available format characters."

	^'-d:hh:mm:ssfff'!

englishDisplayName
	"The <String> full name of the locale in English."

	^'English (Smalltalk)'!

englishLanguageName
	"The <String> name of the language in English."

	^'English'!

firstDayOfWeek
	"Answer an <Integer> in the range 1..7 identifying the first day of the week, where 1 is Monday and 7 is Sunday."

	^1!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^true!

indexOfMonth: aString
	"Answer the 1-based <integer> index in a year (i.e. 1..12) of the month named by the <String> argument, asString, which is expected to be the full locale specific name of a month, or its abbreviated form, in upper or lower case."

	^##(LookupTable withAll: {'january' -> 1.
				'jan' -> 1.
				'february' -> 2.
				'feb' -> 2.
				'mar' -> 3.
				'march' -> 3.
				'apr' -> 4.
				'april' -> 4.
				'may' -> 5.
				'june' -> 6.
				'jun' -> 6.
				'jul' -> 7.
				'july' -> 7.
				'aug' -> 8.
				'august' -> 8.
				'september' -> 9.
				'sep' -> 9.
				'oct' -> 10.
				'october' -> 10.
				'november' -> 11.
				'nov' -> 11.
				'december' -> 12.
				'dec' -> 12})
		at: aString asLowercase!

infinity
	"Answer the <String> representation for positive infinity in this locale (e.g the '∞' symbol)"

	^'Float.Infinity'!

lastTwoDigitYear
	"Answer the <integer> year that is the end of the 100 year interval into which 2-digit years are interpreted.
	For example if this is 2049, then 49 is interpreter as 2049, and 50 as 1950."

	"For backwards compatibility with original Dolphin year pivot (30)"
	^29!

lcid
	"Answer the <integer> Windows Locale Id. The Smalltalk locale is similar to the invariant locale"

	^127!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists, typically a comma."

	^','!

longDateFormat
	"Answer the long date format for the receiver locale. See #dateFormat for a description of the format tokens."

	^'dddd, dd MMMM yyyy'!

longTimeFormat
	"Answer the long time format for the receiver locale. See #timeFormat for a description of the format tokens."

	^'HH:mm:ss'!

monthAbbreviation: anInteger
	"Answer a <String> that is the localised short name of the month whose index is the <integer> argument, anInteger, where January is 1 and December is 12."

	^#('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec') at: anInteger!

monthName: anInteger
	"Answer a String that is the localised long name of the month whose index is the argument, anInteger, where January is 1 and December is 12."

	^#('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December')
		at: anInteger!

monthNames
	"Answer a map between <readableString> month names (and abbreviated month names) and the corresponding month number in the receiving locale."

	^##(LookupTable withAll: {'january' -> 1.
				'jan' -> 1.
				'february' -> 2.
				'feb' -> 2.
				'mar' -> 3.
				'march' -> 3.
				'apr' -> 4.
				'april' -> 4.
				'may' -> 5.
				'june' -> 6.
				'jun' -> 6.
				'jul' -> 7.
				'july' -> 7.
				'aug' -> 8.
				'august' -> 8.
				'september' -> 9.
				'sep' -> 9.
				'oct' -> 10.
				'october' -> 10.
				'november' -> 11.
				'nov' -> 11.
				'december' -> 12.
				'dec' -> 12})!

name
	"Answer the <String> name of the Locale in the current UI language of the host system."

	^'smalltalk'!

nameOfDay: anInteger
	"Answer a <String> that is the localised full name of the day whose index is the <integer> argument, anInteger, where Monday is always 1 and Sunday is always 7."

	^#('Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' 'Sunday') at: anInteger!

nan
	"Answer the <String> used to represen <Float> not-a-number values in this locale."

	^'Float.NaN'!

nativeDigits
	"Answer a <String> which is the digit characters for zero through nine."

	^'0123456789'!

negativeInfinity
	"Answer the <String> used to represent numeric negative infinity in this locale."

	^'Float.NegativeInfinity'!

negativeNumberMode
	"Answer a <Symbol> represent the mode for displaying negative numbers. For Smalltalk we want a leading minus without space, which is mode 1."

	^1!

negativeSign
	"Answer a <String> which is the symbol used to denote negative numbers in this locale."

	^'-'!

numberGrouping
	"Answer a <string> which describes the way in which number digits should be grouped in the receiver locale. The format string consists of a series of integers specifying from left to right how many digits of the number should be formed into a group before the next group (if needed), each group being separated by the 'thousands' separator for the locale. There can be up to 9 characters in the string. If the last character is zero, then the preceding group specification is repeated.
	Some examples from MSDN:
		3;0		e.g. 1,234,567,890 (i.e. the traditional thousands grouping used in some locales such as en-US)
		3;2;0		e.g. 1,23,45,67,890
		3		e.g. 1234567,890
		3;2		e.g. 12345,67,890
	"

	"No grouping"
	^'0'!

percentSymbol
	"Answer a <String> containing the percent symbol for this local."

	^'%'!

pmDesignator
	"Answer the character used in the receiver locale to designate PM (afternoon)."

	^'pm'!

printFloat: aFloat
	"Answer a <String> representation of the <Float> argument in the format defined for this locale."

	^aFloat printString!

printFloat: aFloat on: aStream format: aNUMBERFMTW
	"Append, to aStream, a String whose characters are a representation of the <Float> argument, aFloat, in <integer> base, baseInteger, using the formatting instructions specified by the <NUMBERFMT>, aNUMBERFMT."

	"Aside from the decimalPlaces, the rest of the format information is ignored so that the Floats are always printed in Smalltalk number syntax."

	aFloat
		printOn: aStream
		base: 10
		decimalPlaces: aNUMBERFMTW decimalPlaces!

shortAmDesignator
	"Answer the short <String> used in the receiver locale to designate AM (morning)."

	^'a'!

shortDateFormat
	"Answer the short date format for the receiver locale. See #dateFormat for a description of the format tokens."

	^'yyyy-MM-dd'!

shortPmDesignator
	"Answer the short <String> used in the receiver locale to designate PM (afternoon)."

	^'p'!

shortTimeFormat
	"Answer the short time format for the receiver locale. See #timeFormat for a description of the format tokens."

	^'HH:mm'!

tag
	"Answer the RFC4646 language tag for this locale."

	^''	"Treat as Invariant"!

thousandSeparator
	"Answer the thousands separator String used in the receiver locale."

	^''!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^'MMMM yyyy'! !
!SmalltalkLocale categoriesFor: #amDesignator!constants!public! !
!SmalltalkLocale categoriesFor: #code!constants!public! !
!SmalltalkLocale categoriesFor: #dayOfWeek:!mapping!public! !
!SmalltalkLocale categoriesFor: #dayOfWeekAbbreviation:!constants!public! !
!SmalltalkLocale categoriesFor: #dayOfWeekName:!constants!public! !
!SmalltalkLocale categoriesFor: #dayOfWeekShortAbbreviation:!constants!public! !
!SmalltalkLocale categoriesFor: #decimalPlaces!constants!public! !
!SmalltalkLocale categoriesFor: #decimalSeparator!constants!public! !
!SmalltalkLocale categoriesFor: #displayDuration:on:!printing!public! !
!SmalltalkLocale categoriesFor: #displayFloat:on:!printing!public! !
!SmalltalkLocale categoriesFor: #displayName!displaying!public! !
!SmalltalkLocale categoriesFor: #displayOn:!displaying!public! !
!SmalltalkLocale categoriesFor: #durationFormat!constants!public! !
!SmalltalkLocale categoriesFor: #englishDisplayName!constants!public! !
!SmalltalkLocale categoriesFor: #englishLanguageName!constants!public! !
!SmalltalkLocale categoriesFor: #firstDayOfWeek!constants!public! !
!SmalltalkLocale categoriesFor: #hasLeadingZero!constants!public! !
!SmalltalkLocale categoriesFor: #indexOfMonth:!enquiries!public! !
!SmalltalkLocale categoriesFor: #infinity!constants!public! !
!SmalltalkLocale categoriesFor: #lastTwoDigitYear!constants!public! !
!SmalltalkLocale categoriesFor: #lcid!accessing!public! !
!SmalltalkLocale categoriesFor: #listSeparator!constants!public! !
!SmalltalkLocale categoriesFor: #longDateFormat!constants!public! !
!SmalltalkLocale categoriesFor: #longTimeFormat!constants!public! !
!SmalltalkLocale categoriesFor: #monthAbbreviation:!constants!public! !
!SmalltalkLocale categoriesFor: #monthName:!enquiries!public! !
!SmalltalkLocale categoriesFor: #monthNames!constants!public! !
!SmalltalkLocale categoriesFor: #name!constants!public! !
!SmalltalkLocale categoriesFor: #nameOfDay:!enquiries!public! !
!SmalltalkLocale categoriesFor: #nan!constants!public! !
!SmalltalkLocale categoriesFor: #nativeDigits!constants!public! !
!SmalltalkLocale categoriesFor: #negativeInfinity!constants!public! !
!SmalltalkLocale categoriesFor: #negativeNumberMode!constants!public! !
!SmalltalkLocale categoriesFor: #negativeSign!constants!public! !
!SmalltalkLocale categoriesFor: #numberGrouping!constants!public! !
!SmalltalkLocale categoriesFor: #percentSymbol!constants!public! !
!SmalltalkLocale categoriesFor: #pmDesignator!constants!public! !
!SmalltalkLocale categoriesFor: #printFloat:!printing!public! !
!SmalltalkLocale categoriesFor: #printFloat:on:format:!printing!public! !
!SmalltalkLocale categoriesFor: #shortAmDesignator!constants!public! !
!SmalltalkLocale categoriesFor: #shortDateFormat!constants!public! !
!SmalltalkLocale categoriesFor: #shortPmDesignator!constants!public! !
!SmalltalkLocale categoriesFor: #shortTimeFormat!constants!public! !
!SmalltalkLocale categoriesFor: #tag!constants!public! !
!SmalltalkLocale categoriesFor: #thousandSeparator!constants!public! !
!SmalltalkLocale categoriesFor: #yearMonthFormat!constants!public! !

!SmalltalkLocale class methodsFor!

current
	^Current!

initialize
	Current := self new!

reset
	Current numberFormat: nil! !
!SmalltalkLocale class categoriesFor: #current!instance creation!public! !
!SmalltalkLocale class categoriesFor: #initialize!class initialization!public! !
!SmalltalkLocale class categoriesFor: #reset!initializing!private! !

