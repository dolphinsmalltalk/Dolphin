"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Locale
	instanceVariableNames: 'lcid dateSeparator decimalSeparator listSeparator timeSeparator currencySymbol amDesignator pmDesignator dayNames monthNames'
	classVariableNames: 'SystemDefault UserDefault'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Locale guid: (GUID fromString: '{87b4c49a-026e-11d3-9fd7-00a0cc3e4a32}')!
Locale comment: ''!
!Locale categoriesForClass!System-Support! !
!Locale methodsFor!

amDesignator
	"Answer the String used in the receiver locale to designate AM (morning)."

	amDesignator isNil ifTrue: [amDesignator := self getInfo: LOCALE_S1159].
	^amDesignator!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (the Win32 representation of a Locale, is the LCID)."

	^lcid!

currency
	"Answer the currency symbol String used in the receiver locale.
	Implementation Note: We cache this because it is used for printing, etc."

	currencySymbol isNil ifTrue: [currencySymbol := self getInfo: LOCALE_SCURRENCY].
	^currencySymbol
!

dateFormat
	"Answer the default date format for the receiver locale."

	^self getInfo: LOCALE_SSHORTDATE!

dateFormats: aBoolean 
	"Private - Answer a collection of the date formats for the specified locale, with short
	or long formats according to the argument, aBoolean."

	| enum formats |
	formats := OrderedCollection new: 4.
	enum := ExternalCallback block: 
					[:format | 
					formats add: format.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	(self nlsLib 
		enumDateFormats: enum asParameter
		locale: self asParameter
		dwFlags: (aBoolean ifTrue: [DATE_LONGDATE] ifFalse: [DATE_SHORTDATE])) 
			ifFalse: [self nlsLib systemError].
	enum free.
	^formats!

dateOrder
	"Answer the date ordering used in the receiver locale.
		0	Month - Day - Year
		1	Day - Month - Year
		2	Year - Month - Day."

	^self getIntegerInfo: LOCALE_IDATE!

dateSeparator
	"Answer the character used in the receiver locale to separate date components.
	Implementation Note: We cache this because it is used for printing Dates, etc."

	dateSeparator isNil ifTrue: [dateSeparator := self getInfo: LOCALE_SDATE].
	^dateSeparator!

dayNames
	"Answer a lookup table mapping abbreviated and normal day names in the
	receiver locale to the day number."

	dayNames isNil ifTrue: [
		dayNames := LookupTable new: 14.
		1 to: 7 do: [ :i |
			dayNames 
				at: (self nameOfDay: i abbrev: false) asLowercase put: i;
				at: (self nameOfDay: i abbrev: true) asLowercase put: i ]].
	^dayNames!

decimalSeparator
	"Answer the decimal separator String used in the receiver locale.
	Implementation Note: We cache this because it is used for printing Floats, etc."

	decimalSeparator isNil ifTrue: [decimalSeparator := self getInfo: LOCALE_SDECIMAL].
	^decimalSeparator!

displayOn: aStream
	"Append a displayable representation of the receiver to aStream."

	aStream nextPutAll: self name!

getInfo: anIntegerLcType
	"Private - Answer a locale specific date String of the specified type for the receiver's locale.
	Implementation Note: Try a default maximum size of 20, which will handle most locale info,
	and if that is not enough fall back on the slower mechanism of enquiring for the size first."

	| size buf lib |
	lib := self nlsLib.
	buf := Utf16String newFixed: 20.
	size := lib
				getLocaleInfo: lcid
				lCType: anIntegerLcType
				lpLCData: buf
				cchData: buf size + 1.
	size == 0
		ifTrue: 
			[size := lib
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
				cchData: size].
	^buf resize: size - 1!

getIntegerInfo: anIntegerLcType
	"Private - Answer a locale specific single character of the specified type for the 
	receiver's locale."

	| buf lib |
	lib := self nlsLib.
	buf := Utf16String newFixed: 15.
	(lib
		getLocaleInfo: lcid
		lCType: anIntegerLcType
		lpLCData: buf
		cchData: buf size) == 0
		ifTrue: [lib systemError].
	^CRTLibrary default atoi: buf!

isMonthBeforeDay
	"Answer true if the format for the receiver is expecting a month before a day"

	^self dateOrder ~= 1!

lcid: anLCID
	"Private - Set the receiver's Win32 LCID which identifies the locale the
	receiver is representing. Answer the receiver."

	lcid := anLCID!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists.
	Implementation Note: We cache this because it is used for printing, etc."

	listSeparator isNil ifTrue: [listSeparator := self getInfo: LOCALE_SLIST].
	^listSeparator!

longDateFormat
	"Answer the default long date format for the receiver locale."

	^self getInfo: LOCALE_SLONGDATE!

longDateFormats
	"Private - Answer a collection of the long date formats for the receiver locale."

	^self dateFormats: true!

monthNames
	"Answer a map between <readableString> month names (and abbreviated month
	names) and the corresponding month number in the receiving locale."

	monthNames isNil ifTrue: [
		monthNames := LookupTable new: 24.
		1 to: 12 do: [ :i |
			monthNames
				at: (self nameOfMonth: i abbrev: false) asLowercase put: i;
				at: (self nameOfMonth: i abbrev: true) asLowercase put: i]].
	^monthNames!

name
	"Answer the name of the receiver locale."

	^self getInfo: LOCALE_SLANGUAGE!

nameOfDay: dayIndex abbrev: aBoolean
	"Private - Answer a String that is the localised short/long name of the day whose index is the 
	argument, dayIndex, where Monday is 1 and Sunday is 7, depending on the abbrev argument.
	N.B. This is Win32 specific."

	^self getInfo: LOCALE_SDAYNAME1 + 
					(aBoolean ifTrue: [7] ifFalse: [0]) +
					dayIndex - 1!

nameOfMonth: monthIndex abbrev: aBoolean
	"Private - Answer a localised long/short String name for the month whose index is the argument, 
	monthIndex, where January is month 1, and December is month 12.
	N.B. This is Win32 specific."

	^self getInfo: LOCALE_SMONTHNAME1 + 
					(aBoolean ifTrue: [12] ifFalse: [0]) +
					monthIndex - 1!

nlsLib
	"Private - Answer the library responsible for locale support."

	^KernelLibrary default!

pmDesignator
	"Answer the character used in the receiver locale to designate PM (afternoon)."

	pmDesignator isNil ifTrue: [pmDesignator := self getInfo: LOCALE_S2359].
	^pmDesignator!

printDate: aDate format: aStringOrNil flags: dwFlags
	"Private - Answer a locale specific formatted date String generated from the arguments."

	| year |
	"If a Date is prior to 01 January 1601, or post 31 December 65535, then it cannot be
	formatted by Windows."
	^((year := aDate year) < 1601 or: [year > 65535])
		ifTrue: [self printUnboundedDate: aDate format: aStringOrNil flags: dwFlags]
		ifFalse: [self printSysDate: aDate asParameter format: aStringOrNil flags: dwFlags]!

printDuration: microsecondsInteger on: aPuttableStream
	"Display a friendly representation of the (assumed short) microsecond duration, anInteger, onto aPuttableStream."

	| mS |
	#todo. "Needs to be internationalized."
	mS := microsecondsInteger / 1000.0.
	mS < 1000.0
		ifTrue: 
			[mS printOn: aPuttableStream decimalPlaces: (mS < 1.0 ifTrue: [3] ifFalse: [0]).
			aPuttableStream nextPutAll: ' mS']
		ifFalse: 
			[| secs |
			secs := mS / 1000.0.
			secs printOn: aPuttableStream decimalPlaces: (secs < 10.0 ifTrue: [1] ifFalse: [0]).
			aPuttableStream nextPutAll: ' s']!

printOn: aStream
	"Append a debug representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self name; nextPut: $)!

printSysDate: aSYSTEMTIME format: aStringOrNil flags: dwFlags
	"Private - Answer a locale specific formatted date <String> generated from the arguments."

	| size buf lib |
	lib := self nlsLib.
	buf := Utf16String newFixed: 30.
	size := lib
				getDateFormat: self asParameter
				dwFlags: dwFlags
				lpDate: aSYSTEMTIME
				lpFormat: aStringOrNil
				lpDateStr: buf
				cchDate: buf size + 1.
	size == 0
		ifTrue: 
			["Probably too big, find out how big a buffer is needed"
			size := lib
						getDateFormat: self asParameter
						dwFlags: dwFlags
						lpDate: aSYSTEMTIME
						lpFormat: aStringOrNil
						lpDateStr: nil
						cchDate: 0.
			size == 0 ifTrue: [lib systemError].
			buf := Utf16String newFixed: size - 1.	"Strings allocate extra space for null terminator"
			lib
				getDateFormat: self asParameter
				dwFlags: dwFlags
				lpDate: aSYSTEMTIME
				lpFormat: aStringOrNil
				lpDateStr: buf
				cchDate: size].
	"size includes terminating null"
	^buf resize: size - 1!

printTime: aTime format: aStringOrNil flags: dwFlags
	"Private - Append a locale specific string representation of the argument, aTime, to,
	aStream, using the specified format String (the default is used if it is nil)."

	| size buf timeParm lib |
	timeParm := aTime asParameter.
	lib := self nlsLib.
	buf := Utf16String newFixed: 20.
	size := lib
				getTimeFormat: self asParameter
				dwFlags: dwFlags
				lpTime: timeParm
				lpFormat: aStringOrNil
				lpTimeStr: buf
				cchBuf: buf size + 1.
	size == 0
		ifTrue: 
			[size := lib
						getTimeFormat: self asParameter
						dwFlags: dwFlags
						lpTime: timeParm
						lpFormat: aStringOrNil
						lpTimeStr: nil
						cchBuf: 0.
			size == 0 ifTrue: [^lib systemError].
			buf := Utf16String newFixed: size - 1.	"Strings allocate extra space for null terminator"
			lib
				getTimeFormat: self asParameter
				dwFlags: dwFlags
				lpTime: timeParm
				lpFormat: aStringOrNil
				lpTimeStr: buf
				cchBuf: size].
	^buf resize: size - 1!

printUnboundedDate: aDate format: aStringOrNil flags: dwFlags
	"Private - Answer a locale specific formatted date String generated
	from the arguments. This is usually only employed if aDate is
	outside the range supported by Windows."

	| strm |
	#todo "Implement correctly to respect the format string".
	strm := String writeStream: 64.
	(dwFlags allMask: DATE_LONGDATE) 
		ifTrue: [
			strm
				display: aDate dayOfMonth; space;
				display: aDate monthName; space;
				display: aDate year]
		ifFalse: [
			self isMonthBeforeDay 
				ifTrue: [
					strm
						display: aDate monthIndex; nextPutAll: self dateSeparator;
						display: aDate dayOfMonth; nextPutAll: self dateSeparator]
				ifFalse: [
					strm
						display: aDate dayOfMonth; nextPutAll: self dateSeparator;
						display: aDate monthIndex; nextPutAll: self dateSeparator].
				strm display: aDate year].
	^strm contents!

shortDateFormats
	"Private - Answer a collection of the short date formats for the user locale."

	^self dateFormats: false!

timeFormat
	"Answer the default time format for the receiver locale."

	^self getInfo: LOCALE_STIMEFORMAT!

timeFormats
	"Answer a collection of the time formats for the specified locale."

	| enum formats |
	formats := OrderedCollection new: 4.
	enum := ExternalCallback block: 
					[:format | 
					formats add: format.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	(self nlsLib 
		enumTimeFormats: enum asParameter
		locale: self asParameter
		dwFlags: 0) ifFalse: [self nlsLib systemError].
	enum free.
	^formats!

timeSeparator
	"Answer the character used in the receiver locale to separate time components.
	Implementation Note: We cache this because it is used for printing, etc."

	timeSeparator isNil ifTrue: [timeSeparator := self getInfo: LOCALE_STIME].
	^timeSeparator!

timeZoneInformation
	| timeZoneInfo rc |
	timeZoneInfo := TIME_ZONE_INFORMATION new.
	rc := KernelLibrary default getTimeZoneInformation: timeZoneInfo.
	rc = -1 ifTrue: [^KernelLibrary default systemError].
	timeZoneInfo zoneId: rc.
	^timeZoneInfo! !
!Locale categoriesFor: #amDesignator!enquiries!public! !
!Locale categoriesFor: #asParameter!converting!public! !
!Locale categoriesFor: #currency!enquiries!public! !
!Locale categoriesFor: #dateFormat!enquiries!public! !
!Locale categoriesFor: #dateFormats:!enquiries!private! !
!Locale categoriesFor: #dateOrder!enquiries!public! !
!Locale categoriesFor: #dateSeparator!enquiries!public! !
!Locale categoriesFor: #dayNames!constants!public! !
!Locale categoriesFor: #decimalSeparator!enquiries!public! !
!Locale categoriesFor: #displayOn:!displaying!public! !
!Locale categoriesFor: #getInfo:!enquiries!private! !
!Locale categoriesFor: #getIntegerInfo:!enquiries!private! !
!Locale categoriesFor: #isMonthBeforeDay!enquiries!public! !
!Locale categoriesFor: #lcid:!accessing!private! !
!Locale categoriesFor: #listSeparator!enquiries!public! !
!Locale categoriesFor: #longDateFormat!enquiries!public! !
!Locale categoriesFor: #longDateFormats!enquiries!private! !
!Locale categoriesFor: #monthNames!constants!public! !
!Locale categoriesFor: #name!enquiries!public! !
!Locale categoriesFor: #nameOfDay:abbrev:!enquiries!private! !
!Locale categoriesFor: #nameOfMonth:abbrev:!enquiries!private! !
!Locale categoriesFor: #nlsLib!constants!private! !
!Locale categoriesFor: #pmDesignator!enquiries!public! !
!Locale categoriesFor: #printDate:format:flags:!printing!private! !
!Locale categoriesFor: #printDuration:on:!printing!public! !
!Locale categoriesFor: #printOn:!development!printing!public! !
!Locale categoriesFor: #printSysDate:format:flags:!printing!private! !
!Locale categoriesFor: #printTime:format:flags:!printing!private! !
!Locale categoriesFor: #printUnboundedDate:format:flags:!printing!private! !
!Locale categoriesFor: #shortDateFormats!enquiries!private! !
!Locale categoriesFor: #timeFormat!enquiries!public! !
!Locale categoriesFor: #timeFormats!enquiries!public! !
!Locale categoriesFor: #timeSeparator!enquiries!public! !
!Locale categoriesFor: #timeZoneInformation!enquiries!public! !

!Locale class methodsFor!

default
	"Answer the instance of the receiver which represents the default user locale."

	^self userDefault!

installedSystemLocales
	"Private - Answer the installed Win32 system locales.
		Locale installedSystemLocales
	"

	^self systemLocales: 1!

lcid: anLCID
	"Answer an instance of the receiver to represent the Locale with the specified id."

	^self new lcid: anLCID!

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

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	UserDefault := nil!

onStartup
	"Private - The system has just started. Adjust any locale specific
	information (e.g. Dates and Times). Can be sent at other times
	if the Locale has been changed."

	UserDefault := SystemDefault := nil!

supportedSystemLocales
	"Private - Answer the supported Win32 system locales.
		Locale supportedSystemLocales
	"

	^self systemLocales: 2!

systemDefault
	"Answer the instance of the receiver which represents the default user locale."

	SystemDefault isNil ifTrue: [SystemDefault := self lcid: KernelLibrary default getSystemDefaultLCID].
	^SystemDefault!

systemLocales: anInteger 
	"Private - Answer a collection of system locales, depending on the flags argument, anInteger."

	| enum locales |
	locales := OrderedCollection new: 30.
	enum := ExternalCallback block: 
					[:locale | 
					locales addLast: locale.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	KernelLibrary default enumSystemLocales: enum asParameter dwFlags: anInteger.
	enum free.
	^locales collect: [:s | self lcid: (Integer readFrom: s asUppercase readStream radix: 16)]!

userDefault
	"Answer the instance of the receiver which represents the default user locale."

	UserDefault isNil ifTrue: [UserDefault := self lcid: KernelLibrary default getUserDefaultLCID].
	^UserDefault! !
!Locale class categoriesFor: #default!accessing!public! !
!Locale class categoriesFor: #installedSystemLocales!enquiries!private! !
!Locale class categoriesFor: #lcid:!instance creation!public! !
!Locale class categoriesFor: #makeLangId:subLang:!enquiries!private! !
!Locale class categoriesFor: #makeLcId:sortId:!enquiries!private! !
!Locale class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Locale class categoriesFor: #onStartup!event handling!private! !
!Locale class categoriesFor: #supportedSystemLocales!enquiries!private! !
!Locale class categoriesFor: #systemDefault!accessing!public! !
!Locale class categoriesFor: #systemLocales:!enquiries!private! !
!Locale class categoriesFor: #userDefault!accessing!public! !

