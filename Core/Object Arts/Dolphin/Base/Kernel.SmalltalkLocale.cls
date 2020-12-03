"Filed out from Dolphin Smalltalk 7"!

Core.Locale subclass: #'Kernel.SmalltalkLocale'
	instanceVariableNames: 'integerBase'
	classVariableNames: 'Current Hex'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SmalltalkLocale guid: (Core.GUID fromString: '{06088e6e-01bc-4518-a4a5-73088615fdd8}')!
Kernel.SmalltalkLocale comment: ''!
!Kernel.SmalltalkLocale categoriesForClass!Unclassified! !
!Kernel.SmalltalkLocale methodsFor!

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
	"Append, to aStream, a String whose characters are a representation of the receiver in the base, anInteger, as a Smalltalk developer would want to see it.
	The representation used is a valid literal representation for floating point numbers, recognised by the Smalltalk compiler. Inifinity, negative infinity,
	and not-a-number (NaN) are printed as the names of the corresponding Float constants, so will also evaluate back to the same value."

	| classification |
	classification := aFloat fpClass.
	(classification anyMask: Float.FpClassNaN)
		ifTrue: [aStream nextPutAll: self nan]
		ifFalse: 
			[(classification anyMask: Float.FpClassInfinite)
				ifTrue: 
					[aStream nextPutAll: ((classification anyMask: Float.FpClassNegative)
								ifTrue: [self negativeInfinity]
								ifFalse: [self infinity])]
				ifFalse: 
					[(classification anyMask: Float.FpClassZero)
						ifTrue: 
							[(classification anyMask: Float.FpClassNegative)
								ifTrue: [aStream nextPutAll: '-0.0']
								ifFalse: [aStream nextPutAll: '0.0']]
						ifFalse: 
							[((classification anyMask: Float.FpClassNegative)
								ifTrue: 
									[aStream nextPut: $-.
									aFloat abs]
								ifFalse: [aFloat]) absPrintExactlyOn: aStream base: 10]]]!

displayInteger: anInteger on: aStream
	"Append, to aStream, a String whose characters are a representation of the <Integer> first argument as a Smalltalk user would want to see it."

	integerBase == 10
		ifTrue: [anInteger printOn: aStream base: 10]
		ifFalse: 
			[anInteger
				printOn: aStream
				base: integerBase
				showRadix: true]!

displayName
	"The name of the locale in its native language."

	^'Smalltalk'!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self displayName!

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

integerBase
	^integerBase!

integerBase: anInteger
	integerBase := anInteger!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^true!

iso639LanguageName
	"The two-charater <String> name of the language of the primary language of the locale as defined in ISO-369."

	^'en'!

isValid
	"Answer whether the receiver is a recognised (valid) Locale."

	^true!

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

localizedDisplayName
	"Answer the <String> name of the Locale in the current UI language of the host system."

	^self name!

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
	"Answer the <String> unique name of the Locale."

	^'smalltalk'!

nameOfDay: anInteger
	"Answer a <String> that is the localised full name of the day whose index is the <integer> argument, anInteger, where Monday is always 1 and Sunday is always 7."

	^#('Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' 'Sunday') at: anInteger!

nan
	"Answer the <String> used to represent <Float> not-a-number values in this locale."

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

primary
	"Answer the primary language locale for this Locale. For example fr-Fr is the primary locale for all the various French locales such as fr-CA."

	^Locale named: 'en'!

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

printOn: target
	target
		print: Locale;
		space;
		display: #smalltalk!

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
!Kernel.SmalltalkLocale categoriesFor: #amDesignator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #code!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #dayOfWeek:!mapping!public! !
!Kernel.SmalltalkLocale categoriesFor: #dayOfWeekAbbreviation:!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #dayOfWeekName:!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #dayOfWeekShortAbbreviation:!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #decimalPlaces!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #decimalSeparator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #displayDuration:on:!printing!public! !
!Kernel.SmalltalkLocale categoriesFor: #displayFloat:on:!printing!public! !
!Kernel.SmalltalkLocale categoriesFor: #displayInteger:on:!printing!public! !
!Kernel.SmalltalkLocale categoriesFor: #displayName!displaying!public! !
!Kernel.SmalltalkLocale categoriesFor: #displayOn:!displaying!public! !
!Kernel.SmalltalkLocale categoriesFor: #durationFormat!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #englishDisplayName!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #englishLanguageName!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #firstDayOfWeek!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #hasLeadingZero!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #indexOfMonth:!enquiries!public! !
!Kernel.SmalltalkLocale categoriesFor: #infinity!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #integerBase!accessing!public! !
!Kernel.SmalltalkLocale categoriesFor: #integerBase:!accessing!public! !
!Kernel.SmalltalkLocale categoriesFor: #isInstalled!public!testing! !
!Kernel.SmalltalkLocale categoriesFor: #iso639LanguageName!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #isValid!public!testing! !
!Kernel.SmalltalkLocale categoriesFor: #lastTwoDigitYear!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #lcid!accessing!public! !
!Kernel.SmalltalkLocale categoriesFor: #listSeparator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #localizedDisplayName!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #longDateFormat!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #longTimeFormat!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #monthAbbreviation:!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #monthName:!enquiries!public! !
!Kernel.SmalltalkLocale categoriesFor: #monthNames!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #name!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #nameOfDay:!enquiries!public! !
!Kernel.SmalltalkLocale categoriesFor: #nan!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #nativeDigits!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #negativeInfinity!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #negativeNumberMode!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #negativeSign!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #numberGrouping!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #percentSymbol!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #pmDesignator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #primary!accessing!public! !
!Kernel.SmalltalkLocale categoriesFor: #printFloat:!printing!public! !
!Kernel.SmalltalkLocale categoriesFor: #printFloat:on:format:!printing!public! !
!Kernel.SmalltalkLocale categoriesFor: #printOn:!printing!public! !
!Kernel.SmalltalkLocale categoriesFor: #shortAmDesignator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #shortDateFormat!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #shortPmDesignator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #shortTimeFormat!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #tag!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #thousandSeparator!constants!public! !
!Kernel.SmalltalkLocale categoriesFor: #yearMonthFormat!constants!public! !

!Kernel.SmalltalkLocale class methodsFor!

current
	^Current!

initialize
	Current := self new
				integerBase: 10;
				numberFormat;
				isImmutable: true;
				yourself.
	Hex := self new
				integerBase: 16;
				numberFormat;
				isImmutable: true;
				yourself!

reset
	Current numberFormat: nil! !
!Kernel.SmalltalkLocale class categoriesFor: #current!instance creation!public! !
!Kernel.SmalltalkLocale class categoriesFor: #initialize!class initialization!public! !
!Kernel.SmalltalkLocale class categoriesFor: #reset!initializing!private! !

