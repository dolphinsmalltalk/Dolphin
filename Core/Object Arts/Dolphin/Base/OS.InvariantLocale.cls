"Filed out from Dolphin Smalltalk"!

OS.AbstractWindowsLocale
	subclass: #'OS.InvariantLocale'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.InvariantLocale guid: (Core.GUID fromString: '{de192d86-3877-4a04-9a30-86e0bbd3922a}')!
OS.InvariantLocale comment: ''!
!OS.InvariantLocale categoriesForClass!System-Localization! !
!OS.InvariantLocale methodsFor!

basicLcid
	"Private - Answer the <integer> id (LCID) of the receiver, including any flags encoded in the high order bits outside the 24-bit range of LCIDs."

	^##(LOCALE_INVARIANT bitOr: NoUserOverrideMask)!

displayScaledDecimal: aScaledDecimal on: aPuttableStream
	"Append to the <puttableStream> 2nd argument, a String whose characters are a representation of the <ScaledDecimal> first argument that a user in this <Locale> might expect to see."

	aScaledDecimal basicDisplayOn: aPuttableStream!

isInstalled
	"Answer whether the receiver is a recognised (valid) Locale that is installed on the host OS."

	^true!

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
		writeClassPrefix: Locale;
		register: self.
	anSTBOutFiler nextPut: #invariant!

tag
	"Answer the RFC4646 language aka tag for this locale."

	^LOCALE_NAME_INVARIANT! !
!OS.InvariantLocale categoriesForMethods!
basicLcid!constants!private! !
displayScaledDecimal:on:!displaying!public! !
isInstalled!public!testing! !
name!accessing!public! !
primary!printing!public! !
printOn:!printing!public! !
stbSaveOn:!binary filing!public! !
tag!constants!public! !
!

!OS.InvariantLocale class methodsFor!

current
	^Invariant!

reset
	Invariant := nil!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	^self error: 'Unexpected InvariantLocale instance in STB stream'! !
!OS.InvariantLocale class categoriesForMethods!
current!instance creation!public! !
reset!initializing!public! !
stbReadFrom:format:size:!binary filing!public! !
!

