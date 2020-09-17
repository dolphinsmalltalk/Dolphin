"Filed out from Dolphin Smalltalk 7"!

Core.Locale subclass: #'OS.WindowsLocale'
	instanceVariableNames: 'lcid info'
	classVariableNames: 'EnumNamesDescriptor'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WindowsLocale guid: (Core.GUID fromString: '{72672414-3e98-4af9-a1af-684456e4529d}')!
OS.WindowsLocale comment: ''!
!OS.WindowsLocale categoriesForClass!Unclassified! !
!OS.WindowsLocale methodsFor!

amDesignator
	"Answer the <String> used in the receiver locale to designate AM (morning)."

	^self getStringInfo: LOCALE_SAM!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (the Win32 representation of a Locale, is the LCID)."

	^lcid!

buildDayNamesMap
	| map |
	map := LookupTable new: 14.
	1 to: 7
		do: 
			[:i |
			| longName shortName |
			longName := self dayOfWeekName: i.
			shortName := self dayOfWeekAbbreviation: i.
			map
				at: longName asLowercase put: i;
				at: shortName asLowercase put: i].
	^map!

buildMonthNamesMap
	| map |
	map := LookupTable new: 24.
	1 to: 12
		do: 
			[:i |
			| longName shortName |
			longName := self monthName: i.
			shortName := self monthAbbreviation: i.
			map
				at: longName asLowercase put: i;
				at: shortName asLowercase put: i].
	^map!

calendarId
	^self getIntegerInfo: LOCALE_ICALENDARTYPE!

code
	"Answer the RFC4646 locale code (aka tag) for this locale."

	^self getStringInfo: LOCALE_SNAME!

currency
	"Answer the currency symbol <String> used in the receiver locale, e.g. '£' in 2057/en-GB."

	^self getStringInfo: LOCALE_SCURRENCY!

dayOfWeek: aString
	"Answer the 1-based <integer> index in a week, of the day named by the <String> argument, aString.
	Note that Monday is always 1, and Sunday always 7 (but see #firstDayOfWeek)"

	^(info at: #dayNamesMap ifAbsentPutClean: [self buildDayNamesMap]) at: aString asLowercase!

dayOfWeekAbbreviation: anInteger
	"Answer a <String> that is the localised abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SABBREVDAYNAME1 + ((anInteger + 5) \\ 7)!

dayOfWeekName: anInteger
	"Answer a <String> that is the localised short name of the day whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SDAYNAME1 + ((anInteger + 5) \\ 7)
!

dayOfWeekShortAbbreviation: anInteger
	"Answer a <String> that is the localised shortest abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SSHORTESTDAYNAME1 + ((anInteger + 5) \\ 7)!

decimalPlaces
	"Answer the decimal <integer> number of decimal places to used in the receiver locale in the representation of numbers with a fractional part."

	^self getIntegerInfo: LOCALE_IDIGITS!

decimalSeparator
	"Answer the decimal separator <String> used in the receiver locale in the representation of numbers with a fractional part."

	^self getStringInfo: LOCALE_SDECIMAL!

displayName
	"The name of the locale in its native language."

	^self getStringInfo: LOCALE_SNATIVEDISPLAYNAME!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	"If displaying the Locale in its own language, we can used its native name, or in the default UI language (most likely) we can use the localized name. Failing that we have to display it in English as we have no general translation capability."

	| targetLangId |
	targetLangId := aPuttableStream locale languageId.
	targetLangId == self languageId
		ifTrue: [aPuttableStream nextPutAll: self displayName]
		ifFalse: 
			[targetLangId == self class uiDefault languageId
				ifTrue: [aPuttableStream nextPutAll: self localizedDisplayName]
				ifFalse: [aPuttableStream nextPutAll: self englishDisplayName]]!

durationFormat
	"Answer the format <String> used in this Locale (by default) for displaying a <Duration>.
	See Locale>>#durationFormat for details of the available formats characters."

	^'-', (self getStringInfo: LOCALE_SDURATION)!

englishDisplayName
	"The <String> full name of the locale in English."

	^self getStringInfo: LOCALE_SENGLISHDISPLAYNAME!

englishLanguageName
	"The <String> name of the language in English."

	^self getStringInfo: LOCALE_SENGLISHLANGUAGENAME!

firstDayOfWeek
	"Answer an <Integer> in the range 1..7 identifying the first day of the week, where 1 is Monday and 7 is Sunday."

	^(self getIntegerInfo: LOCALE_IFIRSTDAYOFWEEK) + 1!

getCalendarInfoInteger: anInteger
	"Private - Get the specified <integer> calendar information from Windows."

	| buf lib size |
	lib := self nlsLib.
	buf := DWORDBytes new.
	size := lib
				getCalendarInfo: lcid
				calendar: self calendarId
				calType: (anInteger bitOr: CAL_RETURN_NUMBER)
				lpCalData: nil
				cchData: 0
				lpValue: buf.
	size == 2 ifFalse: [^lib systemError].
	^buf value!

getCalendarInfoString: anIntegerLcType
	"Private - Get the specified <Utf8String> calendar information from Windows."

	| buf lib size |
	lib := self nlsLib.
	size := lib
				getCalendarInfo: lcid
				calendar: self calendarId
				calType: anIntegerLcType
				lpCalData: nil
				cchData: 0
				lpValue: nil.
	size == 0 ifTrue: [^lib systemError].
	"Strings allocate extra space for null automatically"
	buf := Utf16String newFixed: size - 1.
	lib
		getCalendarInfo: lcid
		calendar: self calendarId
		calType: anIntegerLcType
		lpCalData: buf
		cchData: size
		lpValue: nil.
	^buf asUtf8String!

getDateFormats: aBoolean
	"Private - Answer a collection of the date formats for the specified locale, with short
	or long formats according to the argument, aBoolean."

	| enum formats |
	formats := Array writeStream: 4.
	enum := Callback block: 
					[:format |
					formats nextPut: format.
					true]
				descriptor: EnumNamesDescriptor.
	(self nlsLib
		enumDateFormats: enum asParameter
		locale: self asParameter
		dwFlags: (aBoolean ifTrue: [DATE_LONGDATE] ifFalse: [DATE_SHORTDATE]))
			ifFalse: [self nlsLib systemError].
	enum free.
	^formats contents!

getIntegerInfo: anIntegerLcType
	"Private - Get the specified <integer> locale information from Windows, caching for subsequent use."

	^info at: anIntegerLcType ifAbsentPutClean: [self getLocaleInfoInteger: anIntegerLcType]!

getLocaleInfoInteger: anIntegerLcType
	| buf |
	buf := DWORDBytes new.
	(self nlsLib
		getLocaleInfo: lcid
		lCType: (anIntegerLcType bitOr: LOCALE_RETURN_NUMBER)
		lpLCData: buf
		cchData: 4) == 0
		ifTrue: [self nlsLib systemError].
	^buf value!

getLocaleInfoString: anIntegerLcType
	"Private - Get the specified <Utf8String> locale information from Windows."

	| buf lib size |
	lib := self nlsLib.
	size := lib
				getLocaleInfo: lcid
				lCType: anIntegerLcType
				lpLCData: nil
				cchData: 0.
	size == 0 ifTrue: [^lib systemError].
	"Strings allocate extra space for null automatically"
	buf := Utf16String newFixed: size - 1.
	lib
		getLocaleInfo: lcid
		lCType: anIntegerLcType
		lpLCData: buf
		cchData: size.
	^buf asUtf8String!

getStringInfo: anIntegerLcType
	"Private - Answer a locale specific date String of the specified type for the receiver's locale."

	^info at: anIntegerLcType ifAbsentPutClean: [self getLocaleInfoString: anIntegerLcType]!

getTimeFormats
	| formats enum |
	formats := Array writeStream: 4.
	enum := Callback block: 
					[:format |
					formats nextPut: format.
					true]
				descriptor: EnumNamesDescriptor.
	(self nlsLib
		enumTimeFormats: enum asParameter
		locale: self asParameter
		dwFlags: 0) ifFalse: [self nlsLib systemError].
	enum free.
	^formats contents!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^(self getIntegerInfo: LOCALE_ILZERO) asBoolean!

indexOfMonth: aString
	"Answer the 1-based <integer> index in a year (i.e. 1..12) of the month named by the <String> argument, asString, which is expected to be the full locale specific name of a month, or its abbreviated form, in upper or lower case."

	^(info at: #monthNamesMap ifAbsentPutClean: [self buildMonthNamesMap]) at: aString asLowercase!

infinity
	"Answer the <String> representation for positive infinity in this locale (e.g the '∞' symbol)"

	^self getStringInfo: LOCALE_SPOSINFINITY!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^self nlsLib isValidLocale: self lcid dwFlags: LCID_INSTALLED!

iso639LanguageName
	"The abbreviated (two-character) <String> name of the language of the primary language of the locale as defined in ISO-369."

	^self getStringInfo: LOCALE_SISO639LANGNAME!

isValid
	"Answer whether the receiver is a recognised (valid) Locale."

	^self nlsLib isValidLocale: self lcid dwFlags: LCID_SUPPORTED!

lastTwoDigitYear
	"Answer the <integer> year that is the end of the 100 year interval into which 2-digit years are interpreted.
	For example if this is 2049, then 49 is interpreter as 2049, and 50 as 1950."

	^self getCalendarInfoInteger: CAL_ITWODIGITYEARMAX!

lcid
	"Answer the <integer> Windows Locale Id."

	^lcid!

lcid: anLCID
	lcid := anLCID.
	info := IdentityDictionary new!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists, typically a comma."

	^self getStringInfo: LOCALE_SLIST!

localizedDisplayName
	"Answer the <String> name of the Locale in the current UI language of the host system."

	^self getStringInfo: LOCALE_SLOCALIZEDDISPLAYNAME!

longDateFormat
	"Answer the long date format for the receiver locale."

	^self getStringInfo: LOCALE_SLONGDATE!

longDateFormats
	"Answer a collection of the long date formats for the receiver locale."

	^info at: #longDateFormats ifAbsentPutClean: [self getDateFormats: true]!

longTimeFormat
	"Answer the long time format for the receiver locale."

	^self getStringInfo: LOCALE_STIMEFORMAT!

monthAbbreviation: anInteger
	"Answer a String that is the localised short name of the month whose index is the argument, anInteger, where January is 1 and December is 12."

	^self getStringInfo: LOCALE_SABBREVMONTHNAME1 +  anInteger - 1!

monthName: anInteger
	"Answer a String that is the localised long name of the month whose index is the 
	argument, anInteger, where January is 1 and December is 12."

	^self getStringInfo: LOCALE_SMONTHNAME1 + anInteger - 1!

name
	"Answer the <String> unique name of the Locale, e.g. 'fr-FR'"

	lcid == LOCALE_CUSTOM_DEFAULT ifTrue: [^'default'].
	^self tag!

nameOfDay: anInteger
	"Answer a String that is the localised full name of the day whose index is the argument, anInteger, where Monday is always 1 and Sunday is always 7."

	^self getStringInfo: LOCALE_SDAYNAME1 + anInteger - 1!

nan
	"Answer the <String> used to represen <Float> not-a-number values in this locale."

	^self getStringInfo: LOCALE_SNAN!

nativeDigits
	"Answer a <String> which is the digit characters for zero through nine."

	^self getStringInfo: LOCALE_SNATIVEDIGITS!

negativeInfinity
	"Answer the <String> used to represent numeric negative infinity in this locale."

	^self getStringInfo: LOCALE_SNEGINFINITY!

negativeNumberMode
	"Answer a <String> which is the symbol used to denote negative numbers in this locale."

	^self getIntegerInfo: LOCALE_INEGNUMBER!

negativeSign
	^self getStringInfo: LOCALE_SNEGATIVESIGN!

nlsLib
	"Private - Answer the library responsible for locale support."

	^KernelLibrary default!

numberGrouping
	"Answer a <string> which describes the way in which number digits should be grouped in the receiver locale. The format string consists of a series of integers specifying from left to right how many digits of the number should be formed into a group before the next group (if needed), each group being separated by the 'thousands' separator for the locale. There can be up to 9 characters in the string. If the last character is zero, then the preceding group specification is repeated.
	Some examples from MSDN:
		3;0		e.g. 1,234,567,890 (i.e. the traditional thousands grouping used in some locales such as en-US)
		3;2;0		e.g. 1,23,45,67,890
		3		e.g. 1234567,890
		3;2		e.g. 12345,67,890
	"

	^self getStringInfo: LOCALE_SGROUPING!

parentName
	"The name of the parent Locale that should be used as a fallback for resource lookup."

	^self getStringInfo: LOCALE_SPARENT!

percentSymbol
	"Answer a <String> containing the percent symbol for this local."

	^self getStringInfo: LOCALE_SPERCENT!

pmDesignator
	"Answer the character used in the receiver locale to designate PM (afternoon)."

	^self getStringInfo: LOCALE_SPM!

primary
	"Answer the primary language locale for this Locale. For example fr-Fr is the primary locale for all the various French locales such as fr-CA."

	lcid == LOCALE_INVARIANT ifTrue: [^self].
	lcid == LOCALE_CUSTOM_DEFAULT ifTrue: [^self class userDefault].
	^Locale named: self parentName!

printOn: aStream
	"Append a debug representation of the receiver to aStream."

	lcid == LOCALE_INVARIANT
		ifTrue: 
			[aStream
				print: Locale;
				space;
				display: #invariant.
			^self].
	lcid == LOCALE_CUSTOM_DEFAULT
		ifTrue: 
			[aStream
				print: Locale;
				space;
				display: #userDefault.
			^self].
	lcid == LOCALE_CUSTOM_UNSPECIFIED
		ifTrue: 
			[aStream basicPrint: self.
			^self].
	aStream
		nextPut: $(;
		print: Locale;
		space;
		display: #named:;
		space;
		print: self name;
		nextPut: $)!

shortAmDesignator
	"Answer the short <String> used in the receiver locale to designate AM (morning)."

	^info at: LOCALE_SSHORTESTAM
		ifAbsentPutClean: 
			[KernelLibrary default isWindows10OrGreater
				ifTrue: [self getLocaleInfoString: LOCALE_SSHORTESTAM]
				ifFalse: [self amDesignator first]]!

shortDateFormat
	"Answer the short date format for the receiver locale."

	^self getStringInfo: LOCALE_SSHORTDATE!

shortDateFormats
	"Answer a collection of the short date formats for this locale."

	^info at: #shortDateFormats ifAbsentPutClean: [self getDateFormats: false]!

shortPmDesignator
	"Answer the short <String> used in the receiver locale to designate PM (afternoon)."

	^info at: LOCALE_SSHORTESTPM
		ifAbsentPutClean: 
			[KernelLibrary default isWindows10OrGreater
				ifTrue: [self getLocaleInfoString: LOCALE_SSHORTESTPM]
				ifFalse: [self pmDesignator first]]!

shortTimeFormat
	"Answer the short time format for the receiver locale."

	^self getStringInfo: LOCALE_SSHORTTIME!

tag
	"Answer the RFC4646 language aka tag for this locale."

	^self getStringInfo: LOCALE_SNAME!

thousandSeparator
	"Answer the thousands separator String used in the receiver locale."

	^self getStringInfo: LOCALE_STHOUSAND!

timeFormats
	"Answer a collection of the time formats for the specified locale."

	^info at: #timeFormats ifAbsentPutClean: [self getTimeFormats]!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^self getStringInfo: LOCALE_SYEARMONTH! !
!OS.WindowsLocale categoriesFor: #amDesignator!constants!public! !
!OS.WindowsLocale categoriesFor: #asParameter!converting!public! !
!OS.WindowsLocale categoriesFor: #buildDayNamesMap!helpers!private! !
!OS.WindowsLocale categoriesFor: #buildMonthNamesMap!helpers!private! !
!OS.WindowsLocale categoriesFor: #calendarId!constants!public! !
!OS.WindowsLocale categoriesFor: #code!constants!public! !
!OS.WindowsLocale categoriesFor: #currency!constants!public! !
!OS.WindowsLocale categoriesFor: #dayOfWeek:!mapping!public! !
!OS.WindowsLocale categoriesFor: #dayOfWeekAbbreviation:!constants!public! !
!OS.WindowsLocale categoriesFor: #dayOfWeekName:!constants!public! !
!OS.WindowsLocale categoriesFor: #dayOfWeekShortAbbreviation:!constants!public! !
!OS.WindowsLocale categoriesFor: #decimalPlaces!constants!public! !
!OS.WindowsLocale categoriesFor: #decimalSeparator!constants!public! !
!OS.WindowsLocale categoriesFor: #displayName!displaying!public! !
!OS.WindowsLocale categoriesFor: #displayOn:!displaying!public! !
!OS.WindowsLocale categoriesFor: #durationFormat!constants!public! !
!OS.WindowsLocale categoriesFor: #englishDisplayName!displaying!public! !
!OS.WindowsLocale categoriesFor: #englishLanguageName!constants!public! !
!OS.WindowsLocale categoriesFor: #firstDayOfWeek!constants!public! !
!OS.WindowsLocale categoriesFor: #getCalendarInfoInteger:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getCalendarInfoString:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getDateFormats:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getIntegerInfo:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getLocaleInfoInteger:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getLocaleInfoString:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getStringInfo:!helpers!private! !
!OS.WindowsLocale categoriesFor: #getTimeFormats!helpers!private! !
!OS.WindowsLocale categoriesFor: #hasLeadingZero!constants!public! !
!OS.WindowsLocale categoriesFor: #indexOfMonth:!enquiries!public! !
!OS.WindowsLocale categoriesFor: #infinity!constants!public! !
!OS.WindowsLocale categoriesFor: #isInstalled!public!testing! !
!OS.WindowsLocale categoriesFor: #iso639LanguageName!constants!public! !
!OS.WindowsLocale categoriesFor: #isValid!public!testing! !
!OS.WindowsLocale categoriesFor: #lastTwoDigitYear!constants!public! !
!OS.WindowsLocale categoriesFor: #lcid!accessing!public! !
!OS.WindowsLocale categoriesFor: #lcid:!initializing!private! !
!OS.WindowsLocale categoriesFor: #listSeparator!constants!public! !
!OS.WindowsLocale categoriesFor: #localizedDisplayName!constants!public! !
!OS.WindowsLocale categoriesFor: #longDateFormat!constants!public! !
!OS.WindowsLocale categoriesFor: #longDateFormats!constants!public! !
!OS.WindowsLocale categoriesFor: #longTimeFormat!constants!public! !
!OS.WindowsLocale categoriesFor: #monthAbbreviation:!constants!public! !
!OS.WindowsLocale categoriesFor: #monthName:!enquiries!public! !
!OS.WindowsLocale categoriesFor: #name!constants!public! !
!OS.WindowsLocale categoriesFor: #nameOfDay:!enquiries!public! !
!OS.WindowsLocale categoriesFor: #nan!constants!public! !
!OS.WindowsLocale categoriesFor: #nativeDigits!constants!public! !
!OS.WindowsLocale categoriesFor: #negativeInfinity!constants!public! !
!OS.WindowsLocale categoriesFor: #negativeNumberMode!constants!public! !
!OS.WindowsLocale categoriesFor: #negativeSign!constants!public! !
!OS.WindowsLocale categoriesFor: #nlsLib!constants!private! !
!OS.WindowsLocale categoriesFor: #numberGrouping!constants!public! !
!OS.WindowsLocale categoriesFor: #parentName!constants!public! !
!OS.WindowsLocale categoriesFor: #percentSymbol!constants!public! !
!OS.WindowsLocale categoriesFor: #pmDesignator!constants!public! !
!OS.WindowsLocale categoriesFor: #primary!printing!public! !
!OS.WindowsLocale categoriesFor: #printOn:!development!printing!public! !
!OS.WindowsLocale categoriesFor: #shortAmDesignator!constants!public! !
!OS.WindowsLocale categoriesFor: #shortDateFormat!constants!public! !
!OS.WindowsLocale categoriesFor: #shortDateFormats!constants!public! !
!OS.WindowsLocale categoriesFor: #shortPmDesignator!constants!public! !
!OS.WindowsLocale categoriesFor: #shortTimeFormat!constants!public! !
!OS.WindowsLocale categoriesFor: #tag!constants!public! !
!OS.WindowsLocale categoriesFor: #thousandSeparator!constants!public! !
!OS.WindowsLocale categoriesFor: #timeFormats!constants!public! !
!OS.WindowsLocale categoriesFor: #yearMonthFormat!constants!public! !

!OS.WindowsLocale class methodsFor!

initialize
	EnumNamesDescriptor := FunctionDescriptor returnType: 'bool' argumentTypes: 'lpwstr'!

installedUILanguages: anInteger
	"Private - Answer a collection of UI languages installed on the system.
		self installedUILanguages: MUI_LANGUAGE_LICENSED.
	"

	| enum languages |
	languages := Array writeStream.
	enum := Callback block: 
					[:language :lParam |
					languages nextPut: language.
					true]
				descriptor: (FunctionDescriptor returnType: 'bool' argumentTypes: 'lpwstr uintptr').
	KernelLibrary default
		enumUILanguages: enum asParameter
		dwFlags: (MUI_LANGUAGE_NAME bitOr: anInteger)
		lParam: 0.
	enum free.
	^languages contents collect: [:each | self named: each]!

named: aString
	"Answer an instance of the receiver to represent the Locale with the specified name."

	| kernel lcid |
	kernel := KernelLibrary default.
	lcid := kernel localeNameToLCID: aString asUtf16String dwFlags: 0.
	lcid == 0 ifTrue: [kernel systemError].
	^self lcid: lcid!

reset
	SystemDefault := nil.
	self userDefault: nil!

systemLocales: anInteger 
	"Private - Answer a collection of system locales, depending on the flags argument, anInteger."

	| enum locales |
	locales := OrderedCollection new: 30.
	enum := Callback block: 
					[:locale |
					locales addLast: locale.
					true]
				descriptor: EnumNamesDescriptor.
	KernelLibrary default enumSystemLocales: enum asParameter dwFlags: anInteger.
	enum free.
	^locales collect: [:s | self lcid: (Integer readFrom: s asUppercase readStream radix: 16)]! !
!OS.WindowsLocale class categoriesFor: #initialize!class initialization!development!public! !
!OS.WindowsLocale class categoriesFor: #installedUILanguages:!enquiries!private! !
!OS.WindowsLocale class categoriesFor: #named:!instance creation!public! !
!OS.WindowsLocale class categoriesFor: #reset!initializing!private! !
!OS.WindowsLocale class categoriesFor: #systemLocales:!enquiries!private! !

