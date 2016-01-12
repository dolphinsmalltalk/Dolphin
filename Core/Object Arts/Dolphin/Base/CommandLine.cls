"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLine
	instanceVariableNames: 'arguments argv optArg optInd optionPrefixChars options'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLine guid: (GUID fromString: '{4E9D5C42-1049-4F31-862C-CB56225AA08A}')!
CommandLine comment: ''!
!CommandLine categoriesForClass!Kernel-Objects! !
!CommandLine methodsFor!

getOpt: aString

	| option |
	self options: aString.
	options size < optInd ifTrue: [^nil].
	(option := options at: optInd) ifNil: [
		optInd := optInd + 1.
		options size < optInd ifTrue: [^nil].
		option := options at: optInd.
	].
	optInd := optInd + 1.
	optArg := option value.
	^option key!

initialize: anArray

	argv := anArray.
	self assert: [2 <= argv size].
	optInd := 1.
	optionPrefixChars := '-/'.!

optArg

	^optArg!

optInd

	^optInd + 2!

options: aString

	| argStream optionsStream rules |
	optionsStream := ReadStream on: aString.
	arguments := OrderedCollection new.
	options := OrderedCollection new.
	rules := OrderedCollection new.
	[optionsStream atEnd] whileFalse: [
		| argRequired char |
		argRequired := nil.	"argument not allowed"
		char := optionsStream next. 
		 optionsStream peek == $: ifTrue: [
			argRequired := (optionsStream next; peek) == $:.
		].
		rules add: char -> argRequired.
	].
	argStream := (ReadStream on: argv) next; next; yourself.
	[argStream atEnd] whileFalse: [
		| arg |
		arg := argStream next.
		(1 < arg size and: [optionPrefixChars includes: arg first]) ifTrue: [
			| optionStream |
			optionStream := (ReadStream on: arg) next; yourself.
			[optionStream atEnd] whileFalse: [
				| argRequired char rule |
				char := optionStream next.
				(arg size == 2 and: [(arg at: 1) == (arg at: 2)]) ifTrue: [
					options add: nil.
					arguments addAll: argStream upToEnd.
				] ifFalse: [
					rule := rules detect: [:each | each key == char] ifNone: [self error: 'unexpected option: ' , char printString].
					argRequired := rule value.
					argRequired ifNil: [
						options add: char -> nil.
					] ifNotNil: [
						| optionArg |
						(optionArg := optionStream upToEnd) isEmpty ifTrue: [
							argStream atEnd ifTrue: [
								self halt.
							] ifFalse: [
								optionArg := argStream peek.
								(optionPrefixChars includes: optionArg first) ifTrue: [
									optionArg := ''.
								] ifFalse: [
									argStream next.
									options add: nil.
								].
							].
						].
						(argRequired and: [optionArg isEmpty]) ifTrue: [self error: 'Argument required for option: ' , char printString].
						options add: char -> optionArg.
					].
				].
			].
		] ifFalse: [
			arguments add: arg.
		].
	].
! !
!CommandLine categoriesFor: #getOpt:!public! !
!CommandLine categoriesFor: #initialize:!public! !
!CommandLine categoriesFor: #optArg!public! !
!CommandLine categoriesFor: #optInd!public! !
!CommandLine categoriesFor: #options:!public! !

!CommandLine class methodsFor!

argv: anArray

	^super new
		initialize: anArray;
		yourself! !
!CommandLine class categoriesFor: #argv:!public! !

