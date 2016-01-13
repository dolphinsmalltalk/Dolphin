"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLine
	instanceVariableNames: 'arguments argv optArg optInd optOpt optionPrefixChars options'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLine guid: (GUID fromString: '{4E9D5C42-1049-4F31-862C-CB56225AA08A}')!
CommandLine comment: 'Instances of CommandLine can be used to parse command line options and arguments. 

The implementation is guided by and modeled on getopt() in Unix (http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html), but also has a simpler API. 

The description of the options is similar to getopt(), basically a string of characters that are allowed options with a $: following those that require an arguments.

From a CMD shell in the Dolphin directory, launch the development image with the following:

C:\Dolphin>Dolphin7 DPRO.img7 -a -b -c foo bar

Then, in a workspace evalute the following:

| commandLine options arguments |
commandLine := CommandLine options: ''abc:''.
options := commandLine options.	"a Dictionary($c -> ''foo'' $a -> nil $b -> nil)"
arguments := commandLine arguments. "#(''bar'')"'!
!CommandLine categoriesForClass!Kernel-Objects! !
!CommandLine methodsFor!

arguments

	^arguments!

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
	option key == $? ifTrue: [
		optArg := nil.
		optOpt := option value.
	] ifFalse: [
		optArg := option value.
		optOpt := nil.
	].
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

options

	| dict |
	dict := Dictionary new.
	options do: [:each | 
		(each notNil and: [each key notNil and: [each key ~~ $?]]) ifTrue: [
			dict at: each key put: each value.
		].
	].
	^dict!

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
			argRequired := (optionsStream next; peek) ~~ $:.
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
					rule := rules detect: [:each | each key == char] ifNone: [nil -> nil].
					rule key ifNil: [
						options add: $? -> char.
					] ifNotNil: [
						argRequired := rule value.
						argRequired ifNil: [
							options add: char -> nil.
						] ifNotNil: [
							| optionArg |
							(optionArg := optionStream upToEnd) isEmpty ifTrue: [
								argStream atEnd ifFalse: [
									optionArg := argStream peek.
									(optionPrefixChars includes: optionArg first) ifTrue: [
										optionArg := ''.
									] ifFalse: [
										argStream next.
										options add: nil.
									].
								].
							].
							(argRequired and: [optionArg isEmpty]) ifTrue: [
								optionArg := char. 
								char := $?.
							].
							options add: char -> optionArg.
						].
					].
				].
			].
		] ifFalse: [
			arguments add: arg.
		].
	].
	arguments := arguments asArray.!

optOpt

	^optOpt! !
!CommandLine categoriesFor: #arguments!public! !
!CommandLine categoriesFor: #getOpt:!public! !
!CommandLine categoriesFor: #initialize:!public! !
!CommandLine categoriesFor: #optArg!public! !
!CommandLine categoriesFor: #optInd!public! !
!CommandLine categoriesFor: #options!public! !
!CommandLine categoriesFor: #options:!public! !
!CommandLine categoriesFor: #optOpt!public! !

!CommandLine class methodsFor!

argv: anArray
	"Constructor used primarily for testing"

	^super new
		initialize: anArray;
		yourself!

new

	^self argv: SessionManager current argv!

options: aString

	^self new
		options: aString;
		yourself! !
!CommandLine class categoriesFor: #argv:!public! !
!CommandLine class categoriesFor: #new!public! !
!CommandLine class categoriesFor: #options:!public! !

