"Filed out from Dolphin Smalltalk"!

OS.AbstractWindowsLocale subclass: #'OS.InvariantLocale'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.InvariantLocale guid: (Core.GUID fromString: '{de192d86-3877-4a04-9a30-86e0bbd3922a}')!
OS.InvariantLocale comment: ''!
!OS.InvariantLocale categoriesForClass!Unclassified! !
!OS.InvariantLocale methodsFor!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^true!

lcid
	"Answer the <integer> Windows Locale Id of the receiver."

	^LOCALE_INVARIANT!

name
	"Answer the <String> unique name of the Locale."

	^#invariant!

primary
	"Answer the primary language locale for this Locale. For example fr-Fr is the primary locale for all the various French locales such as fr-CA."

	^self!

printOn: aStream
	"Append a debug representation of the receiver to aStream."

	aStream
		print: Locale;
		space;
		display: #invariant!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler."

	anSTBOutFiler
		writeClass: Locale withPrefix: STBPrefix forData;
		register: self.
	anSTBOutFiler nextPut: #invariant! !
!OS.InvariantLocale categoriesForMethods!
isInstalled!public!testing! !
lcid!accessing!public! !
name!accessing!public! !
primary!printing!public! !
printOn:!printing!public! !
stbSaveOn:!binary filing!public! !
!

!OS.InvariantLocale class methodsFor!

current
	^Invariant!

reset
	Invariant := nil!

stbReadFrom: anSTBInFiler format: anSTBClassConversion
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	^self error: 'Unexpected InvariantLocale instance in STB stream'! !
!OS.InvariantLocale class categoriesForMethods!
current!instance creation!public! !
reset!initializing!public! !
stbReadFrom:format:!binary filing!public! !
!

