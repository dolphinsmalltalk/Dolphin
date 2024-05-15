"Filed out from Dolphin Smalltalk"!

AbstractWindowsLocale subclass: #WindowsLocale
	instanceVariableNames: 'lcid tag'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WindowsLocale guid: (GUID fromString: '{72672414-3e98-4af9-a1af-684456e4529d}')!

WindowsLocale comment: ''!

!WindowsLocale categoriesForClass!System-Localization! !

!WindowsLocale methodsFor!

= anObject
	"Answer whether the receiver and argument are equivalent (i.e. represent the same Locale)."

	^self == anObject or: [anObject species == self species and: [anObject basicLcid = lcid]]!

basicLcid
	"Private - Answer the <integer> id (LCID) of the receiver, including any flags encoded in the high order bits outside the 24-bit range of LCIDs."

	^lcid!

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

!WindowsLocale categoriesForMethods!
=!comparing!public! !
basicLcid!accessing!private! !
isTurkic!public!testing! !
lcid:!initializing!private! !
printOn:!development!printing!public! !
tag!constants!public! !
!

!WindowsLocale class methodsFor!

reset
	UserDefault := SystemDefault := nil!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using an
	STBSingletonProxy."

	^anSTBClassConversion
		ifNotNil: 
			[| ref lcid locale |
			ref := anSTBInFiler register: nil.
			"Version 0 had 3 inst vars: 'numberFormat', 'lcid', and 'info'. The first and last are cached info and can be discarded."
			self assert: [anSTBClassConversion instSize == 3].
			anSTBInFiler basicNext.
			lcid := anSTBInFiler basicNext.
			anSTBInFiler basicNext.
			locale := self lcid: lcid.
			anSTBInFiler fixup: ref to: locale.
			locale]
		ifNil: 
			[super
				stbReadFrom: anSTBInFiler
				format: anSTBClassConversion
				size: anInteger]!

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
	^locales collect: [:s | self lcid: (Integer readFrom: s asUppercase readStream radix: 16)]! !

!WindowsLocale class categoriesForMethods!
reset!initializing!private! !
stbReadFrom:format:size:!binary filing!public! !
systemLocales:!enquiries!private! !
!

