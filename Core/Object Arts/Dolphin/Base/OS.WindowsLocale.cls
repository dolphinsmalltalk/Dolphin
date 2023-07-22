"Filed out from Dolphin Smalltalk"!

OS.AbstractWindowsLocale
	subclass: #'OS.WindowsLocale'
	instanceVariableNames: 'lcid tag'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WindowsLocale guid: (Core.GUID fromString: '{72672414-3e98-4af9-a1af-684456e4529d}')!
OS.WindowsLocale comment: ''!
!OS.WindowsLocale categoriesForClass!System-Localization! !
!OS.WindowsLocale methodsFor!

= anObject
	"Answer whether the receiver and argument are equivalent (i.e. represent the same Locale)."

	^self == anObject or: [anObject species == self species and: [anObject basicLcid = lcid]]!

basicLcid
	"Private - Answer the <integer> id (LCID) of the receiver, including any flags encoded in the high order bits outside the 24-bit range of LCIDs."

	^lcid!

icuCaseFoldingOptions
	^self isTurkic
		ifTrue: [U_FOLD_CASE_EXCLUDE_SPECIAL_I]
		ifFalse: [U_FOLD_CASE_DEFAULT]!

isTurkic
	"Answer whether the receiver is a turkic locale (tr or az language)."

	^(self tag beginsWith: 'tr') or: [tag beginsWith: 'az']!

lcid: anLCID
	lcid := anLCID.
	self initialize!

printOn: aStream
	"Append a debug representation of the receiver to aStream."

	self lcid == LOCALE_CUSTOM_DEFAULT
		ifTrue: 
			[aStream
				print: Locale;
				space;
				display: #userDefault.
			^self].
	self lcid == LOCALE_CUSTOM_UNSPECIFIED
		ifTrue: 
			[aStream basicPrint: self.
			^self].
	aStream
		nextPut: $(;
		print: Locale;
		space;
		display: (self noUserOverrides ifTrue: [#standard:] ifFalse: [#named:]);
		space;
		print: self name;
		nextPut: $)!

tag
	"Answer the RFC4646 language name, aka 'tag', for this locale."

	^tag ifNil: [tag := self getLocaleInfoString: LOCALE_SNAME]! !
!OS.WindowsLocale categoriesForMethods!
=!comparing!public! !
basicLcid!accessing!private! !
icuCaseFoldingOptions!constants!private! !
isTurkic!public!testing! !
lcid:!initializing!private! !
printOn:!development!printing!public! !
tag!constants!public! !
!

