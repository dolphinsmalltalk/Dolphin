"Filed out from Dolphin Smalltalk"!

Object
	subclass: #CommandLine
	instanceVariableNames: 'arguments argv optArg optIndex optOpt optionPrefixChars options parsingArgStream parsingErrors parsingRules'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

matchLongOption: aString
	^parsingRules detect: [:each | each name = aString]
		ifNone: 
			[| rules |
			rules := parsingRules select: [:each | each isLongOption and: [each name beginsWith: aString]].
			rules size == 1
				ifTrue: [rules first]
				ifFalse: 
					[parsingErrors
						nextPutAll: (rules isEmpty ifTrue: ['Unrecognized'] ifFalse: ['Ambiguous']);
						nextPutAll: ' option ';
						print: aString;
						cr.
					nil]]!

matchOption: aCharacter
	^parsingRules detect: [:each | each name = aCharacter]
		ifNone: 
			["Unrecognized option"
			options add: nil -> aCharacter.
			parsingErrors
				nextPutAll: 'Unrecognized option: ';
				nextPut: aCharacter;
				cr.
			nil]!

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
	| argument key rule i |
	i := aString indexOf: $=.
	i == 0
		ifTrue: 
			["option does not have argument with it"
			key := aString]
		ifFalse: 
			["option=value format"
			key := aString copyFrom: 1 to: i - 1.
			argument := aString copyFrom: i + 1 to: aString size].
	rule := self matchLongOption: key.
	rule ifNil: [^self].
	rule isArgumentAllowed
		ifFalse: 
			[argument
				ifNil: [options add: rule -> nil]
				ifNotNil: 
					[parsingErrors
						nextPutAll: 'Option ';
						print: rule name;
						nextPutAll: ' has unexpected argument of ';
						print: argument;
						cr].
			^self].
	argument
		ifNil: 
			[argument := parsingArgStream atEnd
						ifTrue: [nil]
						ifFalse: 
							[| peek |
							peek := parsingArgStream peek.
							(optionPrefixChars includes: peek first) ifTrue: [nil] ifFalse: [parsingArgStream next]]].
	(rule isArgumentRequired and: [argument isNil])
		ifTrue: 
			[options add: nil -> key.
			parsingErrors
				nextPutAll: 'Missing required argument for option ';
				print: key;
				cr]
		ifFalse: [options add: rule -> argument]!

parseNextArg
	| parsingArg parsingOptionStream len prefix |
	parsingArg := parsingArgStream next.
	len := parsingArg size.
	(1 < len and: [prefix := parsingArg first. (optionPrefixChars includes: prefix)])
		ifFalse: 
			["no prefix means treat as an argument rather than as an option"
			arguments add: parsingArg.
			^self].
	(len == 2 and: [parsingArg second = prefix])
		ifTrue: 
			["-- by itself is a signal to treat everything following as arguments, not options"
			arguments addAll: parsingArgStream upToEnd.
			^self].
	(2 < len and: [parsingArg second = prefix])
		ifTrue: 
			["-- is lead-in to long argument"
			self parseLongOption: (parsingArg copyFrom: 3 to: len).
			^self].
	parsingOptionStream := (ReadStream on: parsingArg)
				next;
				yourself.	"Prefix character ($/ or $-)"
	[parsingOptionStream atEnd] whileFalse: 
			["one argv can have multiple options (-ab is equivalent to -a -b)"
			self parseNextOption: parsingOptionStream]!

parseNextOption: aReadStream
	| char optionArg rule |
	char := aReadStream next.
	rule := self matchOption: char.
	rule ifNil: [^self].
	rule isArgumentAllowed
		ifFalse: 
			["simple option without an argument"
			options add: rule -> nil.
			^self].
	"option has an optional or required argument"
	optionArg := aReadStream upToEnd.	"option argument can follow immediately (-xabc)"
	optionArg isEmpty ifTrue: [optionArg := nil].
	(optionArg isNil and: [parsingArgStream atEnd not])
		ifTrue: 
			["look for option argument in next argv"
			optionArg := parsingArgStream peek.
			(optionPrefixChars includes: optionArg first)
				ifTrue: 
					["next argument begins with prefix character, so another option"
					optionArg := nil	"option does not have an argument"]
				ifFalse: [parsingArgStream next	"argument associated with option"]].
	(rule isArgumentRequired and: [optionArg isNil])
		ifTrue: 
			["error if required argument is not present"
			parsingErrors
				nextPutAll: 'Missing required argument for option ';
				nextPut: char;
				cr.
			optionArg := char.
			rule := nil].
	options add: rule -> optionArg	"save option and argument"!

processOptions
	options ifNil: [self parse].
	options do: [:each | each key ifNotNil: [:rule | rule value: each value]]! !
!CommandLine categoriesForMethods!
addOption:!public! !
addOption:whenPresentDo:!public! !
addOptionAllowingArgument:!public! !
addOptionAllowingArgument:whenPresentDo:!public! !
addOptionRequiringArgument:!public! !
addOptionRequiringArgument:whenPresentDo:!public! !
addRulesFrom:!private! !
arguments!accessing!public! !
checkForErrors!private! !
getOpt:!getopt protocol!public! !
initialize:!initializing!private! !
matchLongOption:!private! !
matchOption:!private! !
optArg!getopt protocol!public! !
options!accessing!public! !
options:!public! !
optOpt!getopt protocol!public! !
parse!private! !
parseLongOption:!private! !
parseNextArg!private! !
parseNextOption:!private! !
processOptions!public! !
!

!CommandLine class methodsFor!

argv: anArray
	^self basicNew
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
!CommandLine class categoriesForMethods!
argv:!public! !
new!public! !
options:!public! !
!

