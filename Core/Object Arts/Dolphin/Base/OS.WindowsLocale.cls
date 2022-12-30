"Filed out from Dolphin Smalltalk"!

OS.AbstractWindowsLocale subclass: #'OS.WindowsLocale'
	instanceVariableNames: 'lcid'
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
		nextPut: $)! !
!OS.WindowsLocale categoriesForMethods!
=!comparing!public! !
basicLcid!accessing!private! !
lcid:!initializing!private! !
printOn:!development!printing!public! !
!

!OS.WindowsLocale class methodsFor!

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
		ifNil: [self error: 'Unexpected WindowsLocale instance in STB stream']! !
!OS.WindowsLocale class categoriesForMethods!
stbReadFrom:format:size:!binary filing!public! !
!

