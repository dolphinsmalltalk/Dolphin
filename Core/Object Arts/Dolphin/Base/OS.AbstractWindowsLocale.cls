"Filed out from Dolphin Smalltalk"!

Core.Locale subclass: #'OS.AbstractWindowsLocale'
	instanceVariableNames: 'info'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.AbstractWindowsLocale guid: (Core.GUID fromString: '{f4f1e93b-efe9-4ae4-a610-a5f9fcb791f0}')!
OS.AbstractWindowsLocale isNonInstantiable: true!
OS.AbstractWindowsLocale comment: ''!
!OS.AbstractWindowsLocale categoriesForClass!System-Localization! !
!OS.AbstractWindowsLocale methodsFor!

amDesignator
	"Answer the <String> used in the receiver locale to designate AM (morning)."

	^self getStringInfo: LOCALE_SAM!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (the Win32 representation of a Locale, is the LCID)."

	^self lcid!

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
				at: (self lowercaseString: longName) put: i;
				at: (self lowercaseString: shortName) put: i].
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
				at: (self lowercaseString: longName) put: i;
				at: (self lowercaseString: shortName) put: i].
	^map!

calendarId
	^self getIntegerInfo: LOCALE_ICALENDARTYPE!

code
	"Answer the RFC4646 locale code (aka tag) for this locale."

	^self getStringInfo: LOCALE_SNAME!

currency
	"Answer the currency symbol <String> used in the receiver locale, e.g. '£' in 2057/en-GB."

	^self getStringInfo: LOCALE_SCURRENCY!

dayNames
	"Answer a <LookupTable> keyed by lower-cased <readableString> locale-specific day names (and abbreviated day names), with the corresponding day number as values. The names are in lowercase. The day numbering convention is that Sunday is 1, Saturday is 7."

	^(info lookup: #dayNames)
		ifNil: 
			["Note that buildDayNamesMap may modify the info dictionary by populating it with the day names"
			info at: #dayNames put: self buildDayNamesMap]!

dayOfWeekAbbreviation: anInteger
	"Answer a <String> that is the localised abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SABBREVDAYNAME1 + ((anInteger + 5) \\ 7)!

dayOfWeekName: anInteger
	"Answer a <String> that is the name of the day of the week in this Locale whose index is the <integer> argument following US conventions, i.e. Sunday is indexed 1 and Saturday is indexed 7, regardless of the day that is considered the first day of the week in the locale."

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

	| buf |
	buf := UInt32Bytes new.
	(Kernel32
		getCalendarInfo: self lcid
		calendar: self calendarId
		calType: (anInteger bitOr: (self noUserOverrides
						ifTrue: [##(CAL_RETURN_NUMBER | CAL_NOUSEROVERRIDE)]
						ifFalse: [CAL_RETURN_NUMBER]))
		lpCalData: nil
		cchData: 0
		lpValue: buf) == 0
		ifTrue: [^Kernel32 systemError].
	^buf value!

getCalendarInfoString: anIntegerLcType
	"Private - Get the specified <Utf8String> calendar information from Windows."

	^(Kernel32
		getCalendarInfoString: self lcid
		calendar: self calendarId
		calType: (self noUserOverrides
				ifTrue: [anIntegerLcType bitOr: CAL_NOUSEROVERRIDE]
				ifFalse: [anIntegerLcType]))
			asUtf8String!

getDateFormats: aBoolean
	"Private - Answer a collection of the date formats for the specified locale, with short
	or long formats according to the argument, aBoolean."

	^Kernel32 enumDateFormats: self asParameter
		dwFlags: (aBoolean ifTrue: [DATE_LONGDATE] ifFalse: [DATE_SHORTDATE])!

getIntegerInfo: anIntegerLcType
	"Private - Get the specified <integer> locale information from Windows, caching for subsequent use."

	^(info lookup: anIntegerLcType)
		ifNil: [info at: anIntegerLcType put: (self getLocaleInfoInteger: anIntegerLcType)]!

getLocaleInfoInteger: anIntegerLcType
	^Kernel32 getLocaleInfo: self lcid
		integer: (self noUserOverrides
				ifTrue: [anIntegerLcType bitOr: LOCALE_NOUSEROVERRIDE]
				ifFalse: [anIntegerLcType])!

getLocaleInfoString: anIntegerLcType
	"Private - Get the specified <Utf8String> locale information from Windows."

	^(Kernel32 getLocaleInfo: self lcid
		string: (self noUserOverrides
				ifTrue: [anIntegerLcType bitOr: LOCALE_NOUSEROVERRIDE]
				ifFalse: [anIntegerLcType]))
			asUtf8String!

getStringInfo: anIntegerLcType
	"Private - Answer a locale specific date String of the specified type for the receiver's locale."

	^(info lookup: anIntegerLcType)
		ifNil: [info at: anIntegerLcType put: (self getLocaleInfoString: anIntegerLcType)]!

getTimeFormats
	^Kernel32 enumTimeFormats: self asParameter dwFlags: 0!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^(self getIntegerInfo: LOCALE_ILZERO) ~~ 0!

infinity
	"Answer the <String> representation for positive infinity in this locale (e.g the '∞' symbol)"

	^self getStringInfo: LOCALE_SPOSINFINITY!

initialize
	info := IdentityDictionary new!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^Kernel32 isValidLocale: self lcid dwFlags: LCID_INSTALLED!

iso639LanguageName
	"The abbreviated (two-character) <String> name of the language of the primary language of the locale as defined in ISO-639."

	^self getStringInfo: LOCALE_SISO639LANGNAME!

isValidLocale
	"Answer whether the receiver is a recognised (valid) Locale."

	^Kernel32 isValidLocale: self lcid dwFlags: LCID_SUPPORTED!

lastTwoDigitYear
	"Answer the <integer> year that is the end of the 100 year interval into which 2-digit years are interpreted.
	For example if this is 2049, then 49 is interpreter as 2049, and 50 as 1950."

	^self getCalendarInfoInteger: CAL_ITWODIGITYEARMAX!

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

	^(info lookup: #longDateFormats)
		ifNil: [info at: #longDateFormats put: (self getDateFormats: true)]!

longTimeFormat
	"Answer the long time format for the receiver locale."

	^self getStringInfo: LOCALE_STIMEFORMAT!

mapLowercaseFlags
	^##(LCMAP_LOWERCASE | LCMAP_LINGUISTIC_CASING)!

mapTitlecaseFlags
	^##(LCMAP_TITLECASE | LCMAP_LINGUISTIC_CASING)!

mapUppercaseFlags
	^##(LCMAP_UPPERCASE | LCMAP_LINGUISTIC_CASING)!

monthAbbreviation: anInteger
	"Answer a String that is the localised short name of the month whose index is the argument, anInteger, where January is 1 and December is 12."

	^self getStringInfo: LOCALE_SABBREVMONTHNAME1 +  anInteger - 1!

monthName: anInteger
	"Answer a String that is the localised long name of the month whose index is the 
	argument, anInteger, where January is 1 and December is 12."

	^self getStringInfo: LOCALE_SMONTHNAME1 + anInteger - 1!

monthNames
	"Answer a <LookupTable> keyed by lower-cased <readableString> locale-specific month names (and abbreviated month names), with the corresponding month number as values. The names are in lowercase."

	^(info lookup: #monthNamesMap)
		ifNil: 
			["Building the month names map will need to query the names, which may update the info dictionary."
			info at: #monthNamesMap put: self buildMonthNamesMap]!

name
	"Answer the <String> unique name of the Locale, e.g. 'fr-FR'"

	self lcid == LOCALE_CUSTOM_DEFAULT ifTrue: [^'default'].
	^self tag!

nameOfDay: anInteger
	"Answer a <String> that is the localised full name of the day whose index is the <integer> argument, anInteger, where regardless of locale Monday is always 1 and Sunday is always 7.
	See also #dayOfWeekName:"

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
	"Answer an <Integer> describing the way in which negative numbers should be displayed in this locale."

	^self getIntegerInfo: LOCALE_INEGNUMBER!

negativeSign
	^self getStringInfo: LOCALE_SNEGATIVESIGN!

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

	self lcid == LOCALE_CUSTOM_DEFAULT ifTrue: [^self class userDefault].
	^self class named: self parentName!

shortAmDesignator
	"Answer the short <String> used in the receiver locale to designate AM (morning)."

	^(info lookup: LOCALE_SSHORTESTAM)
		ifNil: 
			[info at: LOCALE_SSHORTESTAM
				put: (Kernel32 isWindows10OrGreater
						ifTrue: [self getLocaleInfoString: LOCALE_SSHORTESTAM]
						ifFalse: [self amDesignator first])]!

shortDateFormat
	"Answer the short date format for the receiver locale."

	^self getStringInfo: LOCALE_SSHORTDATE!

shortDateFormats
	"Answer a collection of the short date formats for this locale."

	^(info lookup: #shortDateFormats)
		ifNil: [info at: #shortDateFormats put: (self getDateFormats: false)]!

shortPmDesignator
	"Answer the short <String> used in the receiver locale to designate PM (afternoon)."

	^(info lookup: LOCALE_SSHORTESTPM)
		ifNil: 
			[info at: LOCALE_SSHORTESTPM
				put: (Kernel32 isWindows10OrGreater
						ifTrue: [self getLocaleInfoString: LOCALE_SSHORTESTPM]
						ifFalse: [self pmDesignator first])]!

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

	^(info lookup: #timeFormats) ifNil: [info at: #timeFormats put: self getTimeFormats]!

timeSeparator
	"Answer the character used in the receiver locale to separate time components."

	Notification deprecated.	"Use timeFormat"
	^self getStringInfo: LOCALE_STIME!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^self getStringInfo: LOCALE_SYEARMONTH! !
!OS.AbstractWindowsLocale categoriesForMethods!
amDesignator!constants!public! !
asParameter!converting!public! !
buildDayNamesMap!helpers!private! !
buildMonthNamesMap!helpers!private! !
calendarId!constants!public! !
code!constants!public! !
currency!constants!public! !
dayNames!constants!public! !
dayOfWeekAbbreviation:!constants!public! !
dayOfWeekName:!constants!public! !
dayOfWeekShortAbbreviation:!constants!public! !
decimalPlaces!constants!public! !
decimalSeparator!constants!public! !
displayName!displaying!public! !
displayOn:!displaying!public! !
durationFormat!constants!public! !
englishDisplayName!displaying!public! !
englishLanguageName!constants!public! !
firstDayOfWeek!constants!public! !
getCalendarInfoInteger:!helpers!private! !
getCalendarInfoString:!helpers!private! !
getDateFormats:!helpers!private! !
getIntegerInfo:!helpers!private! !
getLocaleInfoInteger:!helpers!private! !
getLocaleInfoString:!helpers!private! !
getStringInfo:!helpers!private! !
getTimeFormats!helpers!private! !
hasLeadingZero!constants!public! !
infinity!constants!public! !
initialize!initializing!private! !
isInstalled!public!testing! !
iso639LanguageName!constants!public! !
isValidLocale!public!testing! !
lastTwoDigitYear!constants!public! !
listSeparator!constants!public! !
localizedDisplayName!constants!public! !
longDateFormat!constants!public! !
longDateFormats!constants!public! !
longTimeFormat!constants!public! !
mapLowercaseFlags!constants!private! !
mapTitlecaseFlags!constants!private! !
mapUppercaseFlags!constants!private! !
monthAbbreviation:!constants!public! !
monthName:!enquiries!public! !
monthNames!enquiries!public! !
name!constants!public! !
nameOfDay:!enquiries!public! !
nan!constants!public! !
nativeDigits!constants!public! !
negativeInfinity!constants!public! !
negativeNumberMode!constants!public! !
negativeSign!constants!public! !
numberGrouping!constants!public! !
parentName!constants!public! !
percentSymbol!constants!public! !
pmDesignator!constants!public! !
primary!printing!public! !
shortAmDesignator!constants!public! !
shortDateFormat!constants!public! !
shortDateFormats!constants!public! !
shortPmDesignator!constants!public! !
shortTimeFormat!constants!public! !
tag!constants!public! !
thousandSeparator!constants!public! !
timeFormats!constants!public! !
timeSeparator!constants!public! !
yearMonthFormat!constants!public! !
!

!OS.AbstractWindowsLocale class methodsFor!

installedUILanguages: anInteger
	"Private - Answer a collection of UI languages installed on the system.
		self installedUILanguages: MUI_LANGUAGE_LICENSED.
	"

	^(Kernel32 enumUILanguages: (MUI_LANGUAGE_NAME bitOr: anInteger))
		collect: [:each | self named: each]!

lcid: anInteger
	"Answer an instance of the receiver to represent the Locale with the specified LCID."

	^self lcid: anInteger withOverrides: true!

lcid: anInteger withOverrides: aBoolean
	"Private - Answer an instance of the receiver to represent the Locale with the specified LCID."

	^anInteger == LOCALE_INVARIANT
		ifTrue: [self invariant]
		ifFalse: 
			[WindowsLocale new
				lcid: (aBoolean ifTrue: [anInteger] ifFalse: [anInteger bitOr: NoUserOverrideMask])]!

reset
	SystemDefault := nil.
	self userDefault: nil!

systemLocales: anInteger
	"Private - Answer a collection of system locales, depending on the flags argument, anInteger."

	^(Kernel32 enumSystemLocales: anInteger)
		collect: [:s | self lcid: (Integer readFrom: s asUppercase readStream radix: 16)]! !
!OS.AbstractWindowsLocale class categoriesForMethods!
installedUILanguages:!enquiries!private! !
lcid:!instance creation!public! !
lcid:withOverrides:!instance creation!private! !
reset!initializing!private! !
systemLocales:!enquiries!private! !
!

