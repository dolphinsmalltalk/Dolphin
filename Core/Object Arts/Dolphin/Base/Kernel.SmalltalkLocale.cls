﻿"Filed out from Dolphin Smalltalk"!

Core.Locale
	subclass: #'Kernel.SmalltalkLocale'
	instanceVariableNames: 'integerBase'
	classVariableNames: 'Current Hex'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ControlCodePictures'
				-> (IdentityDictionary withAll: {
								$\0 -> $␀.
								$\x1 -> $␁.
								$\x2 -> $␂.
								$\x3 -> $␃.
								$\x4 -> $␄.
								$\x5 -> $␅.
								$\x6 -> $␆.
								$\a -> $␇.
								$\b -> $␈.
								$\t -> $␉.
								$\n -> $␊.
								$\v -> $␋.
								$\f -> $␌.
								$\r -> $␍.
								$\xE -> $␎.
								$\xF -> $␏.
								$\x10 -> $␐.
								$\x11 -> $␑.
								$\x12 -> $␒.
								$\x13 -> $␓.
								$\x14 -> $␔.
								$\x15 -> $␕.
								$\x16 -> $␖.
								$\x17 -> $␗.
								$\x18 -> $␘.
								$\x19 -> $␙.
								$\x1A -> $␚.
								$\x1B -> $␛.
								$\x1C -> $␜.
								$\x1D -> $␝.
								$\x1E -> $␞.
								$\x1F -> $␟.
								$\x20 -> $␣.
								$\x7F -> $␡
							}).
			'DayIndices'
				-> (LookupTable withAll: {
								'fri' -> 16r6.
								'friday' -> 16r6.
								'mon' -> 16r2.
								'monday' -> 16r2.
								'sat' -> 16r7.
								'saturday' -> 16r7.
								'sun' -> 16r1.
								'sunday' -> 16r1.
								'thu' -> 16r5.
								'thursday' -> 16r5.
								'tue' -> 16r3.
								'tuesday' -> 16r3.
								'wed' -> 16r4.
								'wednesday' -> 16r4
							}).
			'MonthIndices'
				-> (LookupTable withAll: {
								'apr' -> 16r4.
								'april' -> 16r4.
								'aug' -> 16r8.
								'august' -> 16r8.
								'dec' -> 16rC.
								'december' -> 16rC.
								'feb' -> 16r2.
								'february' -> 16r2.
								'jan' -> 16r1.
								'january' -> 16r1.
								'jul' -> 16r7.
								'july' -> 16r7.
								'jun' -> 16r6.
								'june' -> 16r6.
								'mar' -> 16r3.
								'march' -> 16r3.
								'may' -> 16r5.
								'nov' -> 16rB.
								'november' -> 16rB.
								'oct' -> 16rA.
								'october' -> 16rA.
								'sep' -> 16r9.
								'september' -> 16r9
							})
		}!

Kernel.SmalltalkLocale guid: (Core.GUID fromString: '{06088e6e-01bc-4518-a4a5-73088615fdd8}')!

Kernel.SmalltalkLocale comment: ''!

!Kernel.SmalltalkLocale categoriesForClass!System-Localization! !

!Kernel.SmalltalkLocale methodsFor!

amDesignator
	"Answer the String used in the receiver locale to designate AM (morning)."

	^'am'!

basicLcid
	"Private - Answer the <integer> id (LCID) of the receiver, including any flags encoded in the high order bits outside the 24-bit range of LCIDs."

	"The receiver is not a Windows locale, but it is basically the same as LOCALE_INVARIANT."

	^##(LOCALE_INVARIANT bitOr: NoUserOverrideMask)!

code
	"Answer the RFC4646 locale code (aka tag) for this locale."

	^''!

dayNames
	"Answer a <LookupTable> keyed by lower-cased <readableString> locale-specific day names (and abbreviated day names), with the corresponding day number as values. The names are in lowercase. The day numbering convention is that Sunday is 1, Saturday is 7."

	^DayIndices!

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

displayCharacter: aCharacter on: aStream
	aCharacter isGraph
		ifTrue: [aStream nextPut: aCharacter]
		ifFalse: 
			[(ControlCodePictures lookup: aCharacter)
				ifNil: 
					[aStream
						nextPut: $(;
						nextPutAll: aCharacter codePointString;
						nextPut: $)]
				ifNotNil: [:alternate | aStream nextPut: alternate]]!

displayDuration: aDuration on: aPuttableStream
	"Display a friendly but concise representation of the <Duration> argument onto the <puttableStream> argument.
	The result will be expressed in a single unit, potentially as a decimal fraction with limited precision appropriate to the scale of the unit."

	| seconds formats |
	seconds := aDuration asSeconds.
	seconds negative
		ifTrue: 
			[aPuttableStream nextPutAll: self negativeSign.
			seconds := seconds negated].

	"Each choice of format is described by a four/five element array where the elements are respectively:
		1. The minimum duration in seconds for which this format should be used.
		2. The number of seconds per unit.
		3. The precision to be used displaying the duration in this unit.
		4. The suffix for a single unit.
		5. The suffix for multiple units."
	formats := ##({{172800. 86400. 1 / 100. ' day'. ' days'}.
				{7200. 3600. 1 / 100. ' hour'. ' hours'}.
				{120. 60. 1 / 100. ' minute'. ' minutes'}.
				{1. 1. 1 / 100. ' s'. ' s'}.
				{1 / 1000. 1 / 1000. 1 / 10. ' ms'. ' ms'}.
				{1 / 1000000. 1 / 1000000. 1 / 10. ' µs'. ' µs'}.
				{1 / 1000000000. 1 / 1000000000. 1. ' ns'. ' ns'}}).
	1 to: formats size
		do: 
			[:i |
			| unitDetails |
			unitDetails := formats at: i.
			seconds < (unitDetails at: 1)
				ifFalse: 
					[| value |
					value := seconds / (unitDetails at: 2) roundTo: (unitDetails at: 3).
					value isInteger
						ifTrue: 
							[value printOn: aPuttableStream base: 10.
							aPuttableStream nextPutAll: (value == 1 ifTrue: [unitDetails at: 4] ifFalse: [unitDetails at: 5])]
						ifFalse: 
							[self displayFloat: value asFloat on: aPuttableStream.
							aPuttableStream nextPutAll: unitDetails last].
					^self]].
	aPuttableStream nextPutAll: '0 s'!

displayFloat: aFloat on: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver in the base, anInteger, as a Smalltalk developer would want to see it.
	The representation used is a valid literal representation for floating point numbers, recognised by the Smalltalk compiler. Inifinity, negative infinity,
	and not-a-number (NaN) are printed as the names of the corresponding Float constants, so will also evaluate back to the same value."

	| classification |
	classification := aFloat fpClass.
	(classification anyMask: ##(Float.FpClassNaN | Float.FpClassInfinite | Float.FpClassZero))
		ifTrue: 
			[(classification anyMask: Float.FpClassZero)
				ifTrue: 
					[(classification anyMask: Float.FpClassNegative)
						ifTrue: [aStream nextPutAll: '-0.0']
						ifFalse: [aStream nextPutAll: '0.0']]
				ifFalse: 
					[(classification anyMask: Float.FpClassInfinite)
						ifTrue: 
							[aStream nextPutAll: ((classification anyMask: Float.FpClassNegative)
										ifTrue: [self negativeInfinity]
										ifFalse: [self infinity])]
						ifFalse: 
							["Must be NaN"
							aStream nextPutAll: self nan]]]
		ifFalse: 
			[(classification anyMask: Float.FpClassNegative)
				ifTrue: 
					[aStream nextPut: $-.
					aFloat abs absPrintExactlyOn: aStream base: 10]
				ifFalse: [aFloat absPrintExactlyOn: aStream base: 10]]!

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

displayScaledDecimal: aScaledDecimal on: aPuttableStream
	"Append to the <puttableStream> 2nd argument, a String whose characters are a representation of the <ScaledDecimal> first argument that a user in this <Locale> might expect to see."

	aScaledDecimal basicDisplayOn: aPuttableStream!

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

	^7!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^true!

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
	"The two-charater <String> name of the language of the primary language of the locale as defined in ISO-639."

	^'en'!

isValidLocale
	"Answer whether the receiver is a recognised (valid) Locale."

	^true!

lastTwoDigitYear
	"Answer the <integer> year that is the end of the 100 year interval into which 2-digit years are interpreted.
	For example if this is 2049, then 49 is interpreter as 2049, and 50 as 1950."

	"For backwards compatibility with original Dolphin year pivot (30)"
	^29!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists, typically a comma. In Smalltalk no separator is used."

	^''!

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
	"Answer a <LookupTable> keyed by lower-cased <readableString> locale-specific month names (and abbreviated month names), with the corresponding month number as values. The names are in lowercase."

	^MonthIndices!

name
	"Answer the <String> unique name of the Locale."

	^'smalltalk'!

nameOfDay: anInteger
	"Answer a <String> that is the localised full name of the day whose index is the <integer> argument, anInteger, where regardless of locale Monday is always 1 and Sunday is always 7.
	See also #dayOfWeekName:"

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
	"Answer an <Integer> describing the way in which negative numbers should be displayed in this locale. For Smalltalk we want a leading minus without space, which is mode 1."

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

	^LOCALE_NAME_INVARIANT!

thousandSeparator
	"Answer the thousands separator String used in the receiver locale."

	^''!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^'MMMM yyyy'! !

!Kernel.SmalltalkLocale categoriesForMethods!
amDesignator!constants!public! !
basicLcid!constants!private! !
code!constants!public! !
dayNames!constants!public! !
dayOfWeekAbbreviation:!constants!public! !
dayOfWeekName:!constants!public! !
dayOfWeekShortAbbreviation:!constants!public! !
decimalPlaces!constants!public! !
decimalSeparator!constants!public! !
displayCharacter:on:!displaying!public! !
displayDuration:on:!displaying!public! !
displayFloat:on:!displaying!public! !
displayInteger:on:!displaying!public! !
displayName!displaying!public! !
displayOn:!displaying!public! !
displayScaledDecimal:on:!displaying!public! !
durationFormat!constants!public! !
englishDisplayName!constants!public! !
englishLanguageName!constants!public! !
firstDayOfWeek!constants!public! !
hasLeadingZero!constants!public! !
infinity!constants!public! !
integerBase!accessing!public! !
integerBase:!accessing!public! !
isInstalled!public!testing! !
iso639LanguageName!constants!public! !
isValidLocale!public!testing! !
lastTwoDigitYear!constants!public! !
listSeparator!constants!public! !
localizedDisplayName!constants!public! !
longDateFormat!constants!public! !
longTimeFormat!constants!public! !
monthAbbreviation:!constants!public! !
monthName:!enquiries!public! !
monthNames!constants!public! !
name!constants!public! !
nameOfDay:!enquiries!public! !
nan!constants!public! !
nativeDigits!constants!public! !
negativeInfinity!constants!public! !
negativeNumberMode!constants!public! !
negativeSign!constants!public! !
numberGrouping!constants!public! !
percentSymbol!constants!public! !
pmDesignator!constants!public! !
primary!accessing!public! !
printFloat:!printing!public! !
printFloat:on:format:!printing!public! !
printOn:!printing!public! !
shortAmDesignator!constants!public! !
shortDateFormat!constants!public! !
shortPmDesignator!constants!public! !
shortTimeFormat!constants!public! !
tag!constants!public! !
thousandSeparator!constants!public! !
yearMonthFormat!constants!public! !
!

!Kernel.SmalltalkLocale class methodsFor!

current
	^Current!

initialize
	| controlPictures |
	Current := self new
				integerBase: 10;
				numberFormat;
				beImmutableObject;
				yourself.
	Hex := self new
				integerBase: 16;
				numberFormat;
				beImmutableObject;
				yourself.
	controlPictures := IdentityDictionary new.
	($\x0 to: $\x1F)
		do: [:ch | controlPictures at: ch put: (Character codePoint: 16r2400 + ch codePoint)].
	controlPictures at: $\x20 put: $\x2423.
	controlPictures at: $\x7F put: $\x2421.
	self addClassConstant: 'ControlCodePictures' value: controlPictures.
	self addClassConstant: 'MonthIndices'
		value: (LookupTable withAll: {
						'january' -> 1.
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
						'dec' -> 12
					}).
	self addClassConstant: 'DayIndices'
		value: (LookupTable withAll: {
						'monday' -> 2.
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
						'sun' -> 1
					})!

reset
	Current ifNotNil: [:current | current numberFormat: nil]! !

!Kernel.SmalltalkLocale class categoriesForMethods!
current!instance creation!public! !
initialize!class initialization!public! !
reset!initializing!private! !
!

