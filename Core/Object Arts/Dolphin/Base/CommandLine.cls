"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLine
	instanceVariableNames: 'arguments argv optArg optIndex optOpt optionPrefixChars options parsingArg parsingArgStream parsingErrors parsingOptionStream parsingRules'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CommandLine guid: (GUID fromString: '{4e9d5c42-1049-4f31-862c-cb56225aa08a}')!
CommandLine comment: 'Instances of CommandLine can be used to parse command line options and arguments. 

The basic implementation is guided by and modeled on getopt() in Unix (http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html), but also has a simpler API. 

The description of the short (single-character) options is similar to getopt(), basically a string of characters that are allowed options with a $: following those that require an arguments.

From a CMD shell in the Dolphin directory, launch the development image with the following:

C:\Dolphin>Dolphin7 DPRO.img7 -a -b -c foo bar

Then, in a workspace evalute the following:

| commandLine options arguments |
commandLine := CommandLine options: ''abc:''.
options := commandLine options.	"a Dictionary($c -> ''foo'' $a -> nil $b -> nil)"
arguments := commandLine arguments. "#(''bar'')"


Also, long options are supported with the ''--'' prefix. Instead of using the #options: message, each long option needs to be added with one of the following:
	#addOptionAllowingArgumentNamed: 		"adds an option with an optional argument"
	#addOptionNamed: 					"adds an option with no argument"
	#addOptionRequiringArgumentNamed: 	"adds an option with a required argument"

Calls to #arguments or #options will now signal a CommandLineError (actually a Notification) if there is a unrecognized or ambiguous option or if a required argument is missing.

From a CMD shell in the Dolphin directory, launch the development image with the following:

C:\Dolphin>Dolphin7 DPRO.img7 --noArg --reg=arg1 --eq=arg2 --optA --optB arg3 arg4

Then, in a workspace evalute the following:

| commandLine options arguments |
commandLine := CommandLine new
	addOptionNamed: ''noArg'';
	addOptionRequiringArgumentNamed: ''reg'';		"Note that equals sign is allowed"
	addOptionRequiringArgumentNamed: ''equal'';	"Note that abbreviated option is allowed"
	addOptionAllowingArgumentNamed: ''optA'';
	addOptionAllowingArgumentNamed: ''optB'';
	yourself.
options := commandLine options.	"a Dictionary(''noArg'' -> nil ''reg'' -> ''arg1'' ''equal'' -> ''arg2'' ''optA'' -> nil ''optB'' -> ''arg3'')"
arguments := commandLine arguments. "#(''arg4'')"
'!
!CommandLine categoriesForClass!Kernel-Objects! !
!CommandLine methodsFor!

addOption: aString 
	parsingRules add: (CommandLineOption named: aString)!

addOption: aString whenPresentDo: aBlock 
	parsingRules add: (CommandLineOption named: aString block: aBlock)!

addOptionAllowingArgument: aString 
	parsingRules add: (CommandLineOption allowingArgument: aString)!

addOptionAllowingArgument: aString whenPresentDo: aBlock 
	parsingRules add: (CommandLineOption allowingArgument: aString block: aBlock)!

addOptionRequiringArgument: aString 
	parsingRules add: (CommandLineOption requiringArgument: aString)!

addOptionRequiringArgument: aString whenPresentDo: aBlock 
	parsingRules add: (CommandLineOption requiringArgument: aString block: aBlock)!

addRulesFrom: aString

	| optionsStream |
	optionsStream := ReadStream on: aString.
	[optionsStream atEnd] whileFalse: [
		parsingRules add: (CommandLineOption fromStream: optionsStream).
	].!

arguments

	arguments ifNil: [self parse].
	self checkForErrors.
	^arguments!

checkForErrors

	| string |
	(string := parsingErrors contents) isEmpty ifTrue: [^self].
	CommandLineError signal: string.
!

getOpt: aString
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html"

	| option |
	self options: aString.
	options ifNil: [self parse].
	options size < optIndex ifTrue: [^nil].
	(option := options at: optIndex) ifNil: [
		optIndex := optIndex + 1.
		options size < optIndex ifTrue: [^nil].
		option := options at: optIndex.
	].
	optIndex := optIndex + 1.
	option key ifNil: [
		optArg := nil.
		optOpt := option value.
		^$?
	].
	optArg := option value.
	optOpt := nil.
	^option key name!

initialize: anArray

	argv := anArray.
	optIndex := 1.
	optionPrefixChars := '-/'.
	parsingRules := OrderedCollection new.!

optArg

	^optArg!

options
	"Answers a dictionary where key is the option and value is
		nil if no argument allowed
		empty if optional argument missing
		otherwise value of optional or required argument"

	| dict |
	options ifNil: [self parse].
	self checkForErrors.
	dict := Dictionary new.
	options do: [:each | 
		each key ifNotNil: [
			dict at: each key name put: each value.
		].
	].
	^dict!

options: aString
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html"

	self addRulesFrom: aString.
!

optOpt

	^optOpt!

parse

	arguments := OrderedCollection new.
	options := OrderedCollection new.
	parsingErrors := WriteStream on: String new.
	parsingArgStream := (ReadStream on: argv) 
		next; 	"exe"
		yourself.
	[parsingArgStream atEnd] whileFalse: [	"iterate over the argv array"
		self parseNextArg.
	].
	arguments := arguments asArray.
!

parseLongOption: aString

	| argument key rule |
	(aString includes: $=) ifFalse: [	"option does not have argument with it"
		key := aString.
	] ifTrue: [		"option=value format"
		| pieces |
		pieces := $= split: aString.
		key := pieces at: 1.
		argument := pieces at: 2.
	].
	rule := parsingRules 
		detect: [:each | each name = key]
		ifNone: [
			| rules |
			rules := parsingRules select: [:each | each isLongOption and: [each name beginsWith: key]].
			rules size == 1 ifTrue: [
				rules first.
			] ifFalse: [
				rules isEmpty ifTrue: [
					parsingErrors nextPutAll: 'Unrecognized option ' , key printString; cr.
				] ifFalse: [
					parsingErrors nextPutAll: 'Ambiguous option ' , key printString; cr.
				].
				^self
			].
		].
	rule isArgumentAllowed ifFalse: [
		argument ifNil: [
			options add: rule -> nil.
		] ifNotNil: [
			parsingErrors nextPutAll: 'Option ' , rule name printString , ' has unexpected argument of ' , argument printString; cr.
		].
		^self
	].
	argument ifNil: [
		argument := parsingArgStream atEnd 
			ifTrue: [nil] 
			ifFalse: [
				| peek |
				peek := parsingArgStream peek.
				(optionPrefixChars includes: peek first) 
					ifTrue: [nil]
					ifFalse: [parsingArgStream next].
			].
		
	].
	(rule isArgumentRequired and: [argument isNil]) ifTrue: [
		options add: nil -> key.
		parsingErrors nextPutAll: 'Missing required argument for option ' , key printString; cr.
	] ifFalse: [
		options add: rule -> argument.
	].
!

parseNextArg

	parsingArg := parsingArgStream next.
	(parsingArg size == 2 and: [(parsingArg at: 1) == (parsingArg at: 2)]) ifTrue: [	"-- by itself is a signal to treat everything following as arguments, not options"
		arguments addAll: parsingArgStream upToEnd.
		^self
	].
	(1 < parsingArg size and: [optionPrefixChars includes: parsingArg first]) ifFalse: [	"no prefix means treat as an argument rather than as an option"
		arguments add: parsingArg.
		^self
	].
	(2 < parsingArg size and: [(parsingArg at: 1) == (parsingArg at: 2)]) ifTrue: [	"-- is lead-in to long argument"
		self parseLongOption: (parsingArg copyFrom: 3 to: parsingArg size).
		^self
	].
	parsingOptionStream := (ReadStream on: parsingArg) 
		next; 	"Prefix character ($/ or $-)"
		yourself.
	[parsingOptionStream atEnd] whileFalse: [	"one argv can have multiple options (-ab is equivalent to -a -b)"
		self parseNextOption.
	].
!

parseNextOption

	| char optionArg rule |
	char := parsingOptionStream next.
	rule := parsingRules 
		detect: [:each | each name == char] 
		ifNone: [	"Unrecognized option"
			options add: nil -> char.
			parsingErrors nextPutAll: 'Unrecognized option: ' , char printString; cr.
			^self
		].
	rule isArgumentAllowed ifFalse: [	"simple option without an argument"
		options add: rule -> nil.
		^self
	].
	"option has an optional or required argument"
	optionArg := parsingOptionStream upToEnd.	"option argument can follow immediately (-xabc)"
	optionArg isEmpty ifTrue: [optionArg := nil].
	(optionArg isNil and: [parsingArgStream atEnd not]) ifTrue: [	"look for option argument in next argv"
		optionArg := parsingArgStream peek.
		(optionPrefixChars includes: optionArg first) ifTrue: [	"next argument begins with prefix character, so another option"
			optionArg := nil.		"option does not have an argument"
		] ifFalse: [
			parsingArgStream next.	"argument associated with option"
		].
	].
	(rule isArgumentRequired and: [optionArg isNil]) ifTrue: [	"error if required argument is not present"
		parsingErrors nextPutAll: 'Missing required argument for option ' , char printString; cr.
		optionArg := char. 
		rule := nil.
	].
	options add: rule -> optionArg.	"save option and argument"!

processOptions
	options ifNil: [self parse].
	options do: [:each | each key ifNotNil: [:rule | rule value: each value]]! !
!CommandLine categoriesFor: #addOption:!public! !
!CommandLine categoriesFor: #addOption:whenPresentDo:!public! !
!CommandLine categoriesFor: #addOptionAllowingArgument:!public! !
!CommandLine categoriesFor: #addOptionAllowingArgument:whenPresentDo:!public! !
!CommandLine categoriesFor: #addOptionRequiringArgument:!public! !
!CommandLine categoriesFor: #addOptionRequiringArgument:whenPresentDo:!public! !
!CommandLine categoriesFor: #addRulesFrom:!private! !
!CommandLine categoriesFor: #arguments!accessing!public! !
!CommandLine categoriesFor: #checkForErrors!private! !
!CommandLine categoriesFor: #getOpt:!getopt protocol!public! !
!CommandLine categoriesFor: #initialize:!initializing!private! !
!CommandLine categoriesFor: #optArg!getopt protocol!public! !
!CommandLine categoriesFor: #options!accessing!public! !
!CommandLine categoriesFor: #options:!public! !
!CommandLine categoriesFor: #optOpt!getopt protocol!public! !
!CommandLine categoriesFor: #parse!private! !
!CommandLine categoriesFor: #parseLongOption:!private! !
!CommandLine categoriesFor: #parseNextArg!private! !
!CommandLine categoriesFor: #parseNextOption!private! !
!CommandLine categoriesFor: #processOptions!public! !

!CommandLine class methodsFor!

argv: anArray
	"Constructor called directly only in testing"

	^super new
		initialize: anArray;
		yourself!

new
	"Generally the #options: constructor should be used"

	^self options: ''		"By default no options, only arguments"!

options: aString
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html"

	^(self argv: SessionManager current argv)
		options: aString;
		yourself! !
!CommandLine class categoriesFor: #argv:!public! !
!CommandLine class categoriesFor: #new!public! !
!CommandLine class categoriesFor: #options:!public! !

