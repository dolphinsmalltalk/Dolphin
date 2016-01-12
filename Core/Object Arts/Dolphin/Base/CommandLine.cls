"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLine
	instanceVariableNames: 'argv index optionPrefixChars'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLine guid: (GUID fromString: '{4E9D5C42-1049-4F31-862C-CB56225AA08A}')!
CommandLine comment: ''!
!CommandLine categoriesForClass!Kernel-Objects! !
!CommandLine methodsFor!

getOpt: aString

	self options: aString.
	^nil!

initialize: anArray

	argv := anArray.
	self assert: [2 <= argv size].
	index := 3.
	optionPrefixChars := '-/'.!

options: aString

	| argStream options optionsStream |
	optionsStream := ReadStream on: aString.
	options := OrderedCollection new.
	[optionsStream atEnd] whileFalse: [
		| argRequired char |
		argRequired := nil.	"argument not allowed"
		char := optionsStream next. 
		 optionsStream peek == $: ifTrue: [
			argRequired := (optionsStream next; peek) == $:.
		].
		options add: char -> argRequired.
	].
	argStream := (ReadStream on: argv) next; next; yourself.
	[argStream atEnd] whileFalse: [
		| arg |
		arg := argStream next.
		(optionPrefixChars includes: arg first) ifTrue: [
			| argRequired char |
			char := arg at: 2.
			argRequired := (options detect: [:each | each key == char] ifNone: [self error: 'unexpected option']) value.
			argRequired halt.
		] ifFalse: [
			arg halt.
		].
	].
	self halt.
! !
!CommandLine categoriesFor: #getOpt:!public! !
!CommandLine categoriesFor: #initialize:!public! !
!CommandLine categoriesFor: #options:!public! !

!CommandLine class methodsFor!

argv: anArray

	^super new
		initialize: anArray;
		yourself! !
!CommandLine class categoriesFor: #argv:!public! !

