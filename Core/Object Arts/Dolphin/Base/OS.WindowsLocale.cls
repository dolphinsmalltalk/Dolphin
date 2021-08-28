"Filed out from Dolphin Smalltalk"!

OS.AbstractWindowsLocale subclass: #'OS.WindowsLocale'
	instanceVariableNames: 'lcid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WindowsLocale guid: (Core.GUID fromString: '{72672414-3e98-4af9-a1af-684456e4529d}')!
OS.WindowsLocale comment: ''!
!OS.WindowsLocale categoriesForClass!Unclassified! !
!OS.WindowsLocale methodsFor!

lcid
	"Answer the <integer> Windows Locale Id."

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
		display: #named:;
		space;
		print: self name;
		nextPut: $)! !
!OS.WindowsLocale categoriesForMethods!
lcid!accessing!public! !
lcid:!initializing!private! !
printOn:!development!printing!public! !
!

!OS.WindowsLocale class methodsFor!

stbReadFrom: anSTBInFiler format: anSTBClassConversion
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
stbReadFrom:format:!binary filing!public! !
!

