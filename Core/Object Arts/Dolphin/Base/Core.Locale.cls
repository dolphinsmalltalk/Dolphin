"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Locale'
	instanceVariableNames: 'numberFormat'
	classVariableNames: 'InstalledUILanguages Invariant SystemDefault TimeZoneInfo UserDefault'
	imports: #(#{OS.NlsConstants} #{OS.ICUConstants})
	classInstanceVariableNames: ''
	classConstants: { 'NoUserOverrideMask' -> 16r1000000 }!

Core.Locale guid: (Core.GUID fromString: '{87b4c49a-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Locale isNonInstantiable: true!

Core.Locale comment: ''!

!Core.Locale categoriesForClass!System-Localization! !

!Core.Locale methodsFor!

= anObject
	"Answer whether the receiver and argument are equivalent (i.e. represent the same Locale)."

	^self == anObject or: [anObject species == self species and: [anObject name = self name]]!

amDesignator
	"Answer the String used in the receiver locale to designate AM (morning)."

	^self subclassResponsibility!

basicLcid
	"Private - Answer the <integer> id (LCID) of the receiver, including any flags encoded in the high order bits outside the 24-bit range of LCIDs."

	^self subclassResponsibility!

boolFormat
	"Answer an <Array> of two <String>s, being the representations for false and true in this Locale."

	^#('false' 'true')!

code
	"Answer the RFC4646 locale code (aka tag) for this locale."

	^self subclassResponsibility!

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
			put: 
				[:locale :time :stream |
				stream nextPutAll: (time hour24 < 12 ifTrue: [locale amDesignator] ifFalse: [locale pmDesignator])].
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
	formatters)
	"Date formats"
	"Time formats"
	"Date formats"
	"Time formats"!

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

dayNames
	"Answer a <LookupTable> keyed by lower-cased <readableString> locale-specific day names (and abbreviated day names), with the corresponding day number as values. The names are in lowercase. The day numbering convention is that Sunday is 1, Saturday is 7."

	^self subclassResponsibility!

dayOfWeek: aString
	"Answer the 1-based <integer> index in a week, of the day named by the <String> argument, aString.
	Note that Sunday is always 1, and Saturday always 7 (but see #firstDayOfWeek)"

	^self dayNames at: (self lowercaseString: aString)!

dayOfWeekAbbreviation: anInteger
	"Answer a <String> that is the abbreviated name for the day of the week in this Locale whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self subclassResponsibility!

dayOfWeekName: anInteger
	"Answer a <String> that is the name of the day of the week in this Locale whose index is the <integer> argument following US conventions, i.e. Sunday is indexed 1 and Saturday is indexed 7, regardless of the day that is considered the first day of the week in the locale."

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

displayCharacter: aCharacter on: aPuttableStream
	aPuttableStream nextPut: aCharacter!

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

displayInteger: anInteger on: aStream
	"Append, to aStream, a String whose characters are a representation of the <Integer> first argument as a user would want to see it."

	anInteger printOn: aStream base: 10!

displayName
	"The name of the locale in its native language."

	^self subclassResponsibility!

displayScaledDecimal: aScaledDecimal on: aWriteStream
	"Append to the <puttableStream> argument, aWriteStream, a String whose characters are a representation of the <ScaledDecimal>, aScaled, that a user in this <Locale> might expect to see."

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

englishDisplayName
	"The <String> full name of the locale in English."

	^self subclassResponsibility!

englishLanguageName
	"The <String> name of the language in English."

	^self subclassResponsibility!

firstDayOfWeek
	"Answer an <Integer> in the range 1..7 identifying the first day of the week, where 1 is Monday and 7 is Sunday."

	^self subclassResponsibility!

foldcaseString: aString
	"Answer a <readableString> which is a copy of the argument, but with the contents case-folded following the Unicode folding rules appropriate for this locale."

	^OS.ICU u_strFoldCase: aString options: self icuCaseFoldingOptions!

getNumberFormat
	^OS.NUMBERFMTW new
		decimalPlaces: self decimalPlaces;
		hasLeadingZero: self hasLeadingZero;
		numberGrouping: self numberGrouping;
		decimalSeparator: self decimalSeparator;
		groupSeparator: self thousandSeparator;
		negativeOrder: self negativeNumberMode;
		yourself!

hash
	"Answer whether the receiver and argument are equivalent (i.e. represent the same Locale)."

	^self name hash!

hashString: aString
	"Answer a positive <SmallInteger> case-insensitive hash value for the <String> argument using the linguistic-casing conventions of this locale. The hash value is that generated by the Windows LCMapString API with the LCMAP_HASH flag, folded to 30 bits so that it is +ve SmallInteger. The LCMapString hash is not the same as the case-insensitive hash generated by the VM's primitive behind String>>hashOrdinalsIgnoringCase:. The VM primitive converts the string using ICU's Unicode case folding, which is not locale sensitive, and then applies FNV1a over the UTF-8 encoded bytes. LCMapString is here asked to use linguistic casing conventions, but even if that were not so the result is different. It is not known what algorithm is used for the LCMapString hash, but it is likely to be over the UTF16-encoding. Whatever hash algorithm it uses, it would appear to generate hash values of equivalent quality."

	^self hashString: aString flags: ##(NORM_IGNORECASE | NORM_LINGUISTIC_CASING)!

hashString: aString flags: anInteger
	"Answer a positive <SmallInteger> case-insensitive hash value for the <String> argument as generated by the LCMapString API when passed the LCMAP_XXX flags in the <Integer> argument."

	| hashBuf src hash count |
	src := aString asUtf16String.
	count := src size.
	count == 0 ifTrue: [^1039475471].
	"LCMAP_HASH expected an 'int' sized buffer"
	hashBuf := ByteArray new: 4.
	(OS.Kernel32
		lcMapString: self lcid
		dwMapFlags: (LCMAP_HASH bitOr: anInteger)
		lpScrStr: src
		cchSrc: count
		lpDestStr: hashBuf
		cchDest: 4) == 0
		ifTrue: [OS.Win32Error signal].
	hash := hashBuf uint32AtOffset: 0.
	"Fold to 30 bits so is always a positive SmallInteger"
	^(hash bitShift: ##(VMConstants.SmallIntegerMax highBit negated))
		bitXor: (hash bitAnd: VMConstants.SmallIntegerMax)!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^self subclassResponsibility!

icuCaseFoldingOptions
	^U_FOLD_CASE_DEFAULT!

indexOfMonth: aString
	"Answer the 1-based <integer> index in a year (i.e. 1..12) of the month named by the <String> argument, asString, which is expected to be the full locale specific name of a month, or its abbreviated form, in upper or lower case."

	^self monthNames at: (self lowercaseString: aString)!

infinity
	"Answer the <String> representation for positive infinity in this locale (e.g the '∞' symbol)"

	^self subclassResponsibility!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^self subclassResponsibility!

iso639LanguageName
	"The two-character <String> name of the language of the primary language of the locale as defined in ISO-639."

	^self subclassResponsibility!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^self lcid ~~ LOCALE_CUSTOM_UNSPECIFIED!

isTurkic
	"Answer whether the receiver is a turkic locale (tr or az language)."

	^false!

isValidLocale
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
	"Answer the <integer> Windows locale id (LCID) of the receiver."

	^self basicLcid bitAnd: ##(NLS_VALID_LOCALE_MASK bitOr: (16rF bitShift: 20)	"sort version")!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists, typically a comma."

	^self subclassResponsibility!

localizedDisplayName
	"Answer the <String> name of the Locale in the current UI language of the host system."

	^self subclassResponsibility!

localizeDecimal: aString format: aNUMBERFMT
	| lcid localized size |
	size := OS.Kernel32
				getNumberFormat: (lcid := self lcid)
				dwFlags: 0
				lpValue: aString
				lpFormat: aNUMBERFMT
				lpNumberStr: nil
				cchNumber: 0.
	size == 0 ifTrue: [^OS.Kernel32 systemError].
	localized := Utf16String new: size - 1.
	OS.Kernel32
		getNumberFormat: lcid
		dwFlags: 0
		lpValue: aString
		lpFormat: aNUMBERFMT
		lpNumberStr: localized
		cchNumber: size.
	^localized!

longDateFormat
	"Answer the long date format for the receiver locale. See #dateFormat for a description of the available format tokens."

	^self subclassResponsibility!

longTimeFormat
	"Answer the long time format for the receiver locale. See #timeFormat for a description of the available format tokens."

	^self subclassResponsibility!

lowercaseString: aString
	"Answer a <readableString> which is a copy of the argument, but with the contents converted to lowercase following the linguisitic case conventions of the receiver."

	^OS.ICU u_strToLower: aString locale: self tag!

monthAbbreviation: anInteger
	"Answer a <String> that is the localised short name of the month whose index is the argument, anInteger, where January is 1 and December is 12."

	^self subclassResponsibility!

monthName: anInteger
	"Answer a <String> that is the localised long name of the month whose index is the <integer> argument, anInteger, where January is 1 and December is 12."

	^self subclassResponsibility!

monthNames
	"Answer a <LookupTable> keyed by lower-cased <readableString> locale-specific month names (and abbreviated month names), with the corresponding month number as values. The names are in lowercase."

	^self subclassResponsibility!

name
	"Answer the <String> unique name of the Locale."

	^self subclassResponsibility!

nameOfDay: anInteger
	"Answer a <String> that is the localised full name of the day whose index is the <integer> argument, anInteger, where regardless of locale Monday is always 1 and Sunday is always 7.
	See also #dayOfWeekName:"

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

noUserOverrides
	^self basicLcid allMask: NoUserOverrideMask!

numberFormat
	^numberFormat
		ifNil: 
			[self numberFormat: self getNumberFormat.
			numberFormat beImmutableObject.
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

	^self class named: (self tag copyFrom: 1 to: 2)!

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
					[('''\' includes: ch)
						ifTrue: 
							[ch == $\
								ifTrue: 
									[ch := formatStream next.
									aWriteStream nextPut: ch].
							ch == $' ifTrue: [aWriteStream nextPutAll: (formatStream upTo: $')]]
						ifFalse: [aWriteStream nextPut: ch].
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
		formatters: aDuration formatters!

printFloat: aFloat
	"Answer a <String> representation of the <Float> argument in the format defined for this locale."

	^self printFloat: aFloat format: self numberFormat!

printFloat: aFloat format: aNUMBERFMT
	"Answer a <String> representation of the <Float> first argument in the format defined by the <NUMBERFMTW> 2nd argument. 
	If the number is negative, then the negative sign used is that associated with the locale identified by the <integer> LCID 3rd argument."

	"Implementation Note: I tried adding a primitive for this with code similar to that below, although failing for NaNs and Infinities, using the CRT _gcvt function to perform the initial conversion of the Float to an invariant String before the locale specific formatting is applied. Interestingly it actually runs more slowly!! This suggests that _gcvt is not very efficient."

	| classification |
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
	^self localizeDecimal: ((classification anyMask: Float.FpClassZero)
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
							decimalExponents: ##(VMConstants.SmallIntegerMin to: VMConstants.SmallIntegerMax).
					stream grabContents])
		format: aNUMBERFMT!

printFloat: aFloat on: aStream format: aNUMBERFMT
	"Append, to aStream, a String whose characters are a representation of the <Float> argument, aFloat, in <integer> base, baseInteger, using the formatting instructions specified by the <NUMBERFMT>, aNUMBERFMT."

	aStream nextPutAll: (self
				printFloat: aFloat
				format: aNUMBERFMT)!

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
		String streamContents: [:s | Locale default printTime: Time now on: s format: 'H:mm:ssFFF']
	"

	self
		print: aTime
		on: aWriteStream
		format: (aString ifNil: [self timeFormat])
		alphabet: 'hHmstfF'
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

	^(self lcid bitShift: -10) bitAnd: 16r3F!

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

titlecaseString: aString
	"Answer a <readableString> which is a copy of the argument but with the first letter of each major word capitalized following the linguisitc conventions of this locale."

	^OS.ICU u_strToTitle: aString locale: self tag!

uppercaseString: aString
	"Answer a <readableString> which is a copy of the argument, but with the contents converted to uppercase following the linguisitic conventions of the receiver."

	^OS.ICU u_strToUpper: aString locale: self tag!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^self subclassResponsibility! !

!Core.Locale categoriesForMethods!
=!comparing!public! !
amDesignator!constants!public! !
basicLcid!accessing!private! !
boolFormat!constants!public! !
code!constants!public! !
dateAndTimeFormatters!constants!private! !
dateFormat!constants!public! !
dayNames!constants!public! !
dayOfWeek:!mapping!public! !
dayOfWeekAbbreviation:!constants!public! !
dayOfWeekName:!constants!public! !
dayOfWeekShortAbbreviation:!constants!public! !
decimalPlaces!constants!public! !
decimalSeparator!constants!public! !
displayCharacter:on:!displaying!public! !
displayDate:on:!displaying!public! !
displayDateTime:on:!displaying!public! !
displayDuration:on:!displaying!public! !
displayFloat:on:!displaying!public! !
displayInteger:on:!displaying!public! !
displayName!displaying!public! !
displayScaledDecimal:on:!displaying!public! !
displayTime:on:!displaying!public! !
durationFormat!constants!public! !
englishDisplayName!constants!public! !
englishLanguageName!constants!public! !
firstDayOfWeek!constants!public! !
foldcaseString:!converting!public! !
getNumberFormat!helpers!private! !
hash!comparing!public! !
hashString:!comparing!public! !
hashString:flags:!comparing!public! !
hasLeadingZero!constants!public! !
icuCaseFoldingOptions!constants!private! !
indexOfMonth:!enquiries!public! !
infinity!constants!public! !
isInstalled!public!testing! !
iso639LanguageName!constants!public! !
isSelfEvaluating!public!testing! !
isTurkic!public!testing! !
isValidLocale!public!testing! !
languageId!accessing!public! !
lastTwoDigitYear!constants!public! !
lcid!accessing!public! !
listSeparator!constants!public! !
localizedDisplayName!constants!public! !
localizeDecimal:format:!printing!private! !
longDateFormat!constants!public! !
longTimeFormat!constants!public! !
lowercaseString:!converting!public! !
monthAbbreviation:!enquiries!public! !
monthName:!enquiries!public! !
monthNames!constants!public! !
name!constants!public! !
nameOfDay:!enquiries!public! !
nan!constants!public! !
nativeDigits!constants!public! !
negativeInfinity!constants!public! !
negativeNumberMode!constants!public! !
negativeSign!constants!public! !
noUserOverrides!public!testing! !
numberFormat!constants!public! !
numberFormat:!accessing!private! !
numberGrouping!constants!public! !
percentSymbol!constants!public! !
pmDesignator!constants!public! !
primary!accessing!public! !
print:on:format:alphabet:formatters:!printing!private! !
printDate:on:format:!printing!public! !
printDateTime:on:format:!printing!public! !
printDuration:on:format:!printing!public! !
printFloat:!printing!public! !
printFloat:format:!printing!public! !
printFloat:on:format:!printing!public! !
printFractionalPart:on:places:!printing!private! !
printTime:on:format:!printing!public! !
shortAmDesignator!constants!public! !
shortDateFormat!constants!public! !
shortPmDesignator!constants!public! !
shortTimeFormat!constants!public! !
subLanguageId!accessing!public! !
tag!constants!public! !
thousandSeparator!constants!public! !
timeFormat!constants!public! !
titlecaseString:!converting!public! !
uppercaseString:!converting!public! !
yearMonthFormat!constants!public! !
!

!Core.Locale class methodsFor!

default
	"Answer the instance of the receiver which represents the default user locale."

	^self userDefault!

getTimeZoneInfo
	| timeZoneInfo rc |
	timeZoneInfo := OS.TIME_ZONE_INFORMATION new.
	rc := OS.Kernel32 getTimeZoneInformation: timeZoneInfo.
	rc = -1 ifTrue: [^OS.Kernel32 systemError].
	timeZoneInfo zoneId: rc.
	^timeZoneInfo!

initialize
	"We need to know if localisation settings are changed."

	SessionManager current
		when: #settingChanged:
		send: #onSettingChanged:
		to: self!

installedSystemLocales
	"Answer the installed Win32 system locales.
		Locale installedSystemLocales
	"

	^OS.WindowsLocale systemLocales: LCID_INSTALLED!

installedUILanguages
	^InstalledUILanguages
		ifNil: [InstalledUILanguages := (OS.WindowsLocale installedUILanguages: MUI_LANGUAGE_NAME) asSet]!

invariant
	"Answer the instance of the receiver which represents the invariant locale."

	^Invariant ifNil: [Invariant := OS.InvariantLocale new initialize]!

lcid: anInteger
	"Answer an instance of the receiver to represent the Locale with the specified <integer> LCID."

	"This method is soft-deprecated. It will remain because it is needed in some cases, but in application code creating Locale's by name is to be preferred. For example instead of:
		Locale lcid: 1033
	prefer:
		Locale named: 'en-US'
	"

	^OS.WindowsLocale lcid: anInteger!

makeLangId: langIdBits subLang: subLangIdBits
	"Private - Answer a Win32 language Id word constructed from langIdBits (10 bits
	are significant) and subLangIdBits (6 bits are significant)."

	^(subLangIdBits bitAnd: 16r3F) << 10 bitOr: (langIdBits bitAnd: 16r3FF)!

makeLcId: langIdWord sortId: sortIdBits
	"Private - Answer a Win32 Locale Id dword constructed from langIdWord and 
	sortIdBits (4 bits are significant).
		#define MAKELCID(lgid) ((unsigned long)(((unsigned short)(lgid)) | (((unsigned long)((unsigned short)(0))) << 16)))
	"

	^(sortIdBits bitAnd: 16rF) << 16 
		bitOr: (langIdWord bitAnd: 16rFFFF)!

named: aString
	"Answer an instance of the receiver to represent the locale with the specified name, e.g. 'en-US', including any user customisation of the settings."

	^self named: aString withOverrides: true!

named: aString withOverrides: aBoolean
	"Private - Answer a sub-instance of the receiver to represent the Locale with the specified name."

	| lcid lower |
	lower := aString asLowercase.
	lower = 'smalltalk' ifTrue: [^self smalltalk].
	lower = 'invariant' ifTrue: [^self invariant].
	lcid := OS.Kernel32 localeNameToLCID: aString dwFlags: 0.
	lcid == 0 ifTrue: [OS.Kernel32 systemError].
	^OS.WindowsLocale lcid: lcid withOverrides: aBoolean!

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
	InstalledUILanguages := TimeZoneInfo := nil!

smalltalk
	"Answer the special 'Smalltalk' locale instance. This isn't a real Locale, but is configured to print Floats, etc, in Smalltalk syntax."

	^SmalltalkLocale.Current!

standard: aString
	"Answer an instance of the receiver to represent the locale with the specified name, e.g. 'en-US', ignoring any user customisation of the settings."

	^self named: aString withOverrides: false!

supportedSystemLocales
	"Private - Answer the supported Win32 system locales.
		Locale supportedSystemLocales
	"

	^OS.WindowsLocale systemLocales: LCID_SUPPORTED!

systemDefault
	"Answer the instance of the receiver which represents the default system locale."

	^SystemDefault ifNil: [SystemDefault := self lcid: OS.Kernel32 getSystemDefaultLCID]!

timeZoneInformation
	^TimeZoneInfo ifNil: [TimeZoneInfo := self getTimeZoneInfo]!

uiDefault
	^self lcid: OS.Kernel32 getThreadUILanguage!

userDefault
	"Answer the instance of the receiver which represents the default user locale."

	^UserDefault!

userDefault: aLocale
	| oldDefault |
	oldDefault := UserDefault.
	UserDefault := aLocale ifNil: [self uiDefault].
	^oldDefault! !

!Core.Locale class categoriesForMethods!
default!accessing!public! !
getTimeZoneInfo!enquiries!public! !
initialize!class initialization!public! !
installedSystemLocales!enquiries!public! !
installedUILanguages!enquiries!public! !
invariant!instance creation!public! !
lcid:!instance creation!public! !
makeLangId:subLang:!enquiries!private! !
makeLcId:sortId:!enquiries!private! !
named:!instance creation!public! !
named:withOverrides:!instance creation!private! !
onPreStripImage!class hierarchy-removing!private! !
onSettingChanged:!event handling!private! !
onStartup!event handling!private! !
reset!initializing!public! !
smalltalk!instance creation!public! !
standard:!instance creation!public! !
supportedSystemLocales!enquiries!private! !
systemDefault!instance creation!public! !
timeZoneInformation!enquiries!public! !
uiDefault!instance creation!public! !
userDefault!instance creation!public! !
userDefault:!instance creation!public! !
!

