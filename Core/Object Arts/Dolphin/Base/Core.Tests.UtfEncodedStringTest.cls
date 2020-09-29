"Filed out from Dolphin Smalltalk 7"!

Core.Tests.StringTest subclass: #'Core.Tests.UtfEncodedStringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.UtfEncodedStringTest guid: (Core.GUID fromString: '{f3d4f4a7-05b6-445f-8380-d0b838804877}')!
Core.Tests.UtfEncodedStringTest isNonInstantiable: true!
Core.Tests.UtfEncodedStringTest comment: ''!
!Core.Tests.UtfEncodedStringTest categoriesForClass!Unclassified! !
!Core.Tests.UtfEncodedStringTest methodsFor!

afterTestCases
	^super afterTestCases
		, #(#('🐬Ā' $\x1F42C $\x100) #('🐬🍺' $\x1F42C $\x1F37A) #('Ā文' $\x100 $\x6587))!

beforeTestCases
	^super beforeTestCases
		, #(#('Ā🐬' $\x1F42C $\x100) #('🐬🍺' $\x1F37A $\x1F42C) #('文Ā' $\x100 $\x6587))!

caseConversionCases
	^super caseConversionCases
		, #(#('кракозябры' 'КРАКОЗЯБРЫ') #('文字化け') #('маймуница' 'МАЙМУНИЦА') #('ａｂｃ' 'ＡＢＣ'))!

decodeIncompleteContinuations
	^Error notYetImplemented!

decodeInvalidContinuations
	^Error notYetImplemented!

decodeTestCases
	^Error notYetImplemented!

indexOfTestCases
	^super indexOfTestCases, #('' $文 'a£ö🐬👨🏻‍🍳' $文 '' $🐬 'a£文🍺👨🏻‍🍳' $🐬'a£a文a🍺a👨🏻‍🍳a' $a 'a£文🍺👨🏻‍🍳' $b 'a文£文ö文🐬文👨🏻‍🍳文' $文 'a🐬£🐬文🐬🍺🐬👨🏻‍🍳🐬' $🐬)!

lengthTestCases
	^super lengthTestCases
		, #(#('a 🍺' 3) #('文字化け' 4) #('Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ' 122) #('Camión' 6) #('ᚠ' 1) #('Приве́т नमस्ते שָׁלוֹם' 22) #('🐬🍺ö' 4) #('👨🏻‍🍳' 4))!

makeStringFromCodeUnits: data
	| subject |
	subject := self collectionClass empty copyEmpty: data size.
	1 to: data size do: [:i | subject basicAt: i put: (data at: i)].
	subject := self assimilateString: subject.
	^subject!

reverseTestCases
	"Private - #reverse doesn't work correctly for multi-byte encodings of UTF-8 and UTF-16."

	^super reverseTestCases
		, #(#('🍺 a' 'a 🍺') #('文字化け' 'け化字文') #('Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ' 'ẵṹɋîⱡą āᶇꞡáᵯ ȇꝛôꞎꝍđ ȶé ếꝛőḇẩḹ ŧṷ ťńṵᵭȋḑīḉñỉ ɍṓᶈᶆĕṫ ďꝋḿŝŭḭẽ ⱺᶁ ᶑếș ,ʈįłḝ ġɳįčṩĭƥḯɖấ ɾûțᶒťċḙṩɲṓĉ ,ẗệṁӓ ťǐʂ ᵳǭḽỡḍ ṁᶙšṕȋ ᶆëᶉơḼ'))!

testAllButFirst
	| subject |
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: subject allButFirst equals: 'a£文🍺'.
	self assert: (subject allButFirst: 2) equals: '£文🍺'.
	self assert: (subject allButFirst: 3) equals: '文🍺'.
	self assert: (subject allButFirst: 4) equals: '🍺'.
	self assert: (subject allButFirst: 5) equals: ''.
	self should: [subject allButFirst: 6] raise: Error.
	self should: [self collectionClass empty allButFirst] raise: Error!

testAllButLast
	| subject |
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: subject allButLast equals: '🐬a£文'.
	self assert: (subject allButLast: 2) equals: '🐬a£'.
	self assert: (subject allButLast: 3) equals: '🐬a'.
	self assert: (subject allButLast: 4) equals: '🐬'.
	self assert: (subject allButLast: 5) equals: ''.
	self should: [subject allButLast: 6] raise: Error.
	self should: [self collectionClass empty allButLast] raise: Error!

testAllSatisfy
	| subject |
	super testAllSatisfy.
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: (subject allSatisfy: [:each | each isSurrogate not])!

testAnsiStringRoundTrip
	| ansiAll utf ansi |
	ansiAll := Character byteCharacterSet.
	utf := self assimilateString: ansiAll.
	ansi := utf asAnsiString.
	self assert: ansi class identicalTo: AnsiString.
	self assert: ansi size equals: 256.
	self assert: ansi equals: ansiAll!

testAnyone
	| subject |
	super testAnyone.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: subject anyOne equals: Character dolphin!

testAnySatisfy
	| subject |
	super testAnySatisfy.
	subject := self assimilateString: 'a£文🐬1🍺'.
	self deny: (subject anySatisfy: [:each | each isSurrogate])!

testBeginsWithExtended
	| subject comperand |
	subject := self newCollection: {Character dolphin. $a. $£. $b. $c}.
	self assert: (subject beginsWith: Character dolphin).
	self deny: (subject beginsWith: (String with: (Character value: 16rF0))).
	self deny: (subject beginsWith: (Character value: 16rF0)).
	self deny: (subject beginsWith: (String with: (Character value: 16r3D))).
	self deny: (subject beginsWith: (Character value: 16r3D)).
	comperand := Character dolphin asUtf8String , 'a£'.
	self assert: (subject beginsWith: comperand).
	comperand := Character dolphin asUtf16String , 'a£'.
	self assert: (subject beginsWith: comperand)!

testBeginsWithIgnoreCase
	| subject comperand |
	subject := self newCollection: {Character dolphin. $a. $\0. $£. $b. $c}.
	self assert: (subject beginsWith: subject ignoreCase: true).
	self assert: (subject beginsWith: subject ignoreCase: false).
	comperand := self newCollection: {Character dolphin. $A. $\0. $£}.
	self assert: (subject beginsWith: comperand ignoreCase: true).
	self deny: (subject beginsWith: comperand ignoreCase: false).
	comperand := comperand asUtf16String.
	self assert: (subject beginsWith: comperand ignoreCase: true).
	self deny: (subject beginsWith: comperand ignoreCase: false)!

testCollect
	| subject actual |
	subject := self assimilateString: 'a£文🐬1🍺'.
	actual := subject collect: 
					[:each |
					self deny: each isSurrogate.
					Character value: each codePoint + 1].
	self assert: actual equals: 'b¤斈🐭2🍻'.
	self assert: (self collectionClass empty collect: [:each | self assert: false]) equals: ''!

testCopyReplaceAllWith
	| subject actual |
	super testCopyReplaceAllWith.
	subject := self assimilateString: 'a£文£1£文🍺'.
	actual := subject copyReplaceAll: '£文' asUtf8String with: 'नमस्ते' asUtf8String.
	self assert: actual equals: 'aनमस्ते£1नमस्ते🍺'.
	actual := subject copyReplaceAll: '£文' asUtf16String with: 'नमस्ते' asUtf16String.
	self assert: actual equals: 'aनमस्ते£1नमस्ते🍺'.
	actual := subject copyReplaceAll: '£文' asArray with: 'नमस्ते' asArray.
	self assert: actual equals: 'aनमस्ते£1नमस्ते🍺'!

testCopyReplacingWithObject
	| subject actual |
	subject := self assimilateString: 'a£文£1🍺'.
	actual := subject copyReplacing: $£ withObject: Character dolphin.
	self assert: actual equals: 'a🐬文🐬1🍺'.
	actual := subject copyReplacing: $\x1F37A withObject: $\x6587.
	self assert: actual equals: 'a£文£1文'!

testCopyWithout
	| string |
	super testCopyWithout.
	"Try a non-ANSI case as well:"
	string := self assimilateString: 'a🐬£🐬文🐬1🐬🐬🍺🐬'.
	self assert: (string copyWithout: Character dolphin) equals: 'a£文1🍺'!

testCopyWithoutIndex
	| subject index |
	super testCopyWithoutIndex.
	subject := self assimilateString: 'a£🍺文1'.
	index := subject indexOf: $\x1F37A.
	self assert: (subject copyWithoutIndex: index) equals: 'a£文1'.
	self should: [subject copyWithoutIndex: index + 1] raise: Error!

testDecodeAt
	self decodeTestCases do: 
			[:each |
			| subject actual |
			subject := self assimilateString: each.
			actual := subject decodeAt: 1.
			self assert: actual equals: each.
			"Starting in the middle of a character should always be an error"
			2 to: subject size do: [:i | self should: [subject decodeAt: i] raise: Error]].
	self decodeInvalidContinuations do: 
			[:each |
			| subject actual |
			subject := self makeStringFromCodeUnits: each first.
			actual := subject decodeAt: 1.
			self assert: actual equals: Character replacement].
	self decodeIncompleteContinuations do: 
			[:each |
			| subject actual |
			subject := self makeStringFromCodeUnits: each.
			actual := subject decodeAt: 1.
			self assert: actual equals: Character replacement]!

testDecodeNextFrom
	| subject |
	subject := self collectionClass empty.
	self decodeTestCases do: 
			[:each |
			| stream actual |
			stream := (self assimilateString: each) readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: each].
	self decodeInvalidContinuations do: 
			[:each |
			| stream actual |
			stream := each first readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: Character replacement.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: each last.
			self assert: stream atEnd].
	self decodeIncompleteContinuations do: 
			[:each |
			| stream actual |
			stream := each readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: Character replacement.
			self assert: stream atEnd]!

testEncodeOnPut
	{Character dolphin.
		Character codePoint: 16r10FFFD.
		$a.
		$\0.
		Character ansiValue: 128.
		Character codePoint: 128.
		Character codePoint: 163.
		Character codePoint: 255.
		Character codePoint: 256.
		Character codePoint: 16rFFFD.
		Character codePoint: 16r10000} do: 
				[:each |
				"Test different initial buffer sizes to check stream growth/non-growth scenarios"
				#(0 1 2 3 4 8) do: 
						[:i |
						| actual utf stream actual2 |
						stream := self collectionClass writeStream: i.
						stream collection
							encodeOn: stream put: each;
							encodeOn: stream put: each.
						utf := stream contents.
						stream := utf readStream.
						actual := stream next.
						actual2 := stream next.
						self assert: actual2 equals: actual.
						self assert: stream atEnd.
						self assert: actual equals: each]]!

testFindFirst
	| subject index |
	super testFindFirst.
	subject := self assimilateString: 'a£🍺文1'.
	subject do: 
			[:ch |
			index := subject findFirst: [:each | each = ch].
			self assert: index equals: (subject indexOf: ch)].
	index := subject findFirst: [:each | each = Character dolphin].
	self assert: index equals: 0.
	index := self collectionClass empty findFirst: [:each | each = $a].
	self assert: index equals: 0!

testFindLast
	| subject index |
	subject := self assimilateString: 'a£🍺文1a£🍺文1'.
	subject do: 
			[:ch |
			index := subject findLast: [:each | each = ch].
			self assert: index equals: (subject lastIndexOf: ch)].
	index := subject findLast: [:each | each = Character dolphin].
	self assert: index equals: 0.
	index := self collectionClass empty findLast: [:each | each = $a].
	self assert: index equals: 0!

testFindStringStartingAt
	| subject actual start expected |
	super testFindStringStartingAt.
	subject := self assimilateString: 'a£文🐬£1£文🍺'.
	start := subject indexOf: $\x6587.
	expected := subject lastIndexOf: $£.
	actual := subject findString: '£文' asUtf8String startingAt: start.
	self assert: actual equals: expected.
	actual := subject findString: '£文' asUtf16String startingAt: start.
	self assert: actual equals: expected.
	"Start in the middle of a character"
	actual := subject findString: '£文' startingAt: (subject indexOf: Character dolphin) + 1.
	self assert: actual equals: expected.
	"Not found"
	actual := subject findString: '🐬文' startingAt: 1.
	self assert: actual equals: 0.
	actual := subject findString: '' startingAt: 1.
	self assert: actual equals: 0!

testFirst
	| subject |
	super testFirst.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: subject first equals: $\x1F42C.
	self should: [self collectionClass empty first] raise: Error!

testFirstColon
	| subject |
	super testFirstColon.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject first: 1) equals: '🐬'.
	self assert: (subject first: 2) equals: '🐬a'.
	self assert: (subject first: 3) equals: '🐬a£'.
	self assert: (subject first: 4) equals: '🐬a£文'.
	self assert: (subject first: 5) equals: '🐬a£文🍺'.
	self should: [subject first: 6] raise: Error.
	self should: [self collectionClass empty first: 1] raise: Error!

testFromToKeysAndValuesDo
	| subject expected actual |
	super testFromToKeysAndValuesDo.
	subject := self assimilateString: 'a£文🐬1🍺'.
	expected := ('a£文🐬1🍺' asArray copyFrom: 2 to: 5)
				collect: [:each | {subject indexOf: each. each}].
	actual := OrderedCollection new.
	subject
		from: 2
		to: (subject indexOf: $1)
		keysAndValuesDo: 
			[:eachKey :eachValue |
			self deny: eachValue isSurrogate.
			actual add: {eachKey. eachValue}].
	actual := actual asArray.
	self assert: actual equals: expected!

testGothicSubStrings
	"This is really a test of Character>>split: now with characters outside the basic plane that will require 4 or 2 code units for UTF-8 and UTF-16 respectively."

	| subject actual |
	subject := self
				newCollection: '𐌼𐌰𐌲 𐌲𐌻𐌴𐍃 𐌹̈𐍄𐌰𐌽, 𐌽𐌹 𐌼𐌹𐍃 𐍅𐌿 𐌽𐌳𐌰𐌽 𐌱𐍂𐌹𐌲𐌲𐌹𐌸'.
	"In UTF-8 the gothic characters are mostly 4 code units. In UTF-16 they will be mostly 2 code units."
	actual := subject subStrings: $\x10330.
	self assert: actual
		equals: #('𐌼' '𐌲 𐌲𐌻𐌴𐍃 𐌹̈𐍄' '𐌽, 𐌽𐌹 𐌼𐌹𐍃 𐍅𐌿 𐌽𐌳' '𐌽 𐌱𐍂𐌹𐌲𐌲𐌹𐌸').
	actual := subject subStrings: $\x20.
	self assert: actual
		equals: #('𐌼𐌰𐌲' '𐌲𐌻𐌴𐍃' '𐌹̈𐍄𐌰𐌽,' '𐌽𐌹' '𐌼𐌹𐍃' '𐍅𐌿' '𐌽𐌳𐌰𐌽' '𐌱𐍂𐌹𐌲𐌲𐌹𐌸').
	"We can split on any codepoint, including one that is part of a composite glyph, in this case $̈, even though this isn't necessarily valid"
	actual := subject subStrings: $\x308.
	self assert: actual
		equals: #('𐌼𐌰𐌲 𐌲𐌻𐌴𐍃 𐌹' '𐍄𐌰𐌽, 𐌽𐌹 𐌼𐌹𐍃 𐍅𐌿 𐌽𐌳𐌰𐌽 𐌱𐍂𐌹𐌲𐌲𐌹𐌸')!

testIdentityIncludes
	| subject pound dolphin foreign |
	super testIdentityIncludes.
	pound := Character value: 163.
	dolphin := self collectionClass with: Character dolphin.
	subject := (self newCollection: 'a') , dolphin , 'b' , pound asString , 'c'.
	{$a. Character dolphin. $\x1F42C. $b. pound. $c}
		do: [:each | self assert: (subject identityIncludes: each)].
	"Should include all the surrogates too"
	dolphin do: [:each | self assert: (subject identityIncludes: each)].
	foreign := self collectionClass encoding == #utf8
				ifTrue: [dolphin asUtf16String]
				ifFalse: [dolphin asUtf8String].
	"Should not include the surrogates from the other encoding"
	1 to: foreign size do: [:i | self deny: (subject identityIncludes: (foreign at: i))]!

testIncludes
	| subject pound dolphin foreign |
	super testIncludes.
	pound := Character value: 163.
	dolphin := self collectionClass with: Character dolphin.
	subject := (self newCollection: 'a') , dolphin , 'b' , pound asString , 'c'.
	{$a. Character dolphin. $\x1F42C. $b. pound. $c} do: [:each | self assert: (subject includes: each)].
	dolphin do: [:each | self assert: (subject includes: each)].
	foreign := self collectionClass encoding == #utf8
				ifTrue: [dolphin asUtf16String]
				ifFalse: [dolphin asUtf8String].
	1 to: foreign size do: [:i | self deny: (subject includes: (foreign at: i))]!

testInjectInto
	| subject actual |
	subject := self assimilateString: 'a£文🐬1🍺'.
	actual := subject inject: 0
				into: 
					[:sum :each |
					self deny: each isSurrogate.
					sum + each codePoint].
	self assert: actual
		equals: $a codePoint + $£ codePoint + $\x6587 codePoint + $\x1F42C codePoint + $1 codePoint
				+ $\x1F37A codePoint.
	"Test empty"
	self assert: (self collectionClass empty inject: 5 into: [:sum :each | sum + each]) equals: 5!

testKeysAndValuesDo
	| subject expected actual |
	subject := self assimilateString: 'a£文🐬1🍺'.
	expected := subject asArray collect: [:each | {subject indexOf: each. each}].
	actual := OrderedCollection new.
	subject keysAndValuesDo: 
			[:eachKey :eachValue |
			self deny: eachValue isSurrogate.
			actual add: {eachKey. eachValue}].
	actual := actual asArray.
	self assert: actual equals: expected!

testLast
	| subject |
	super testLast.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: subject last equals: $\x1F37A.
	self should: [self collectionClass empty last] raise: Error!

testLastColon
	| subject |
	super testLastColon.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject last: 1) equals: '🍺'.
	self assert: (subject last: 2) equals: '文🍺'.
	self assert: (subject last: 3) equals: '£文🍺'.
	self assert: (subject last: 4) equals: 'a£文🍺'.
	self assert: (subject last: 5) equals: '🐬a£文🍺'.
	self should: [subject last: 6] raise: Error.
	self should: [self collectionClass empty last: 1] raise: Error!

testLeftString
	| subject |
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject leftString: 1) equals: '🐬'.
	self assert: (subject leftString: 2) equals: '🐬a'.
	self assert: (subject leftString: 3) equals: '🐬a£'.
	self assert: (subject leftString: 4) equals: '🐬a£文'.
	self assert: (subject leftString: 5) equals: '🐬a£文🍺'.
	self assert: (subject leftString: 6) equals: '🐬a£文🍺'.
	self assert: (self collectionClass empty leftString: 1) equals: ''!

testMidString
	| subject |
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject midString: 3 from: (subject indexOf: $a)) equals: 'a£文'.
	self assert: (subject midString: 3 from: (subject indexOf: $£)) equals: '£文🍺'.
	self should: [subject midString: 3 from: (subject indexOf: $\x6587)] raise: Error!

testOccurrencesOf
	| subject |
	subject := self assimilateString: '🐬a£文🐬Ā🍺'.
	self assert: (subject occurrencesOf: Character dolphin) equals: 2.
	self assert: (subject occurrencesOf: $£) equals: 1.
	self assert: (subject occurrencesOf: $ð) equals: 0.
	subject := self collectionClass empty.
	self assert: (subject occurrencesOf: Character dolphin) equals: 0!

testPairsDo
	| subject pairs |
	subject := self assimilateString: '🐬a£文Ā🍺👨🏻‍🍳'.
	pairs := OrderedCollection new.
	subject pairsDo: [:a :b | pairs add: {a. b}].
	self assert: pairs asArray
		equals: #(#($\x1F42C $a) #($£ $\x6587) #($\x100 $\x1F37A) #($\x1F468 $\x1F3FB) #($\x200D $\x1F373)).
	"Test empty"
	self collectionClass empty pairsDo: [:a :b | self assert: false].
	"It is an error to attempt pairs enumation over a collection of odd length"
	self should: [(self assimilateString: '🐬') pairsDo: [:a :b | ]] raise: Error!

testReject
	| subject actual |
	subject := self assimilateString: 'a文£🐬1🍺🍻'.
	actual := subject reject: 
					[:each |
					self deny: each isSurrogate.
					each codePoint > 32768].
	self assert: actual equals: 'a文£1'.
	self assert: (self collectionClass empty reject: [:each | self assert: false]) equals: ''!

testReverseComposites
	self skip.	"Currently #reverse does not handle these cases - issue #765"
	self assert: 'a 👨🏻‍🍳' reverse equals: '👨🏻‍🍳 a'.
	self assert: 'aeiöu' reverse equals: 'uöiea'.
	self assert: ' กำ' reverse equals: 'กำ '!

testRuneSubStrings
	"This is really a test of Character>>split: with characters requiring 3 code units in UTF-8, although still only one in UTF-16"

	| subject actual |
	subject := self
				newCollection: 'ᚠᛇᚻ᛫ᛒᛦᚦ᛫ᚠᚱᚩᚠᚢᚱ᛫ᚠᛁᚱᚪ᛫ᚷᛖᚻᚹᛦᛚᚳᚢᛗ
ᛋᚳᛖᚪᛚ᛫ᚦᛖᚪᚻ᛫ᛗᚪᚾᚾᚪ᛫ᚷᛖᚻᚹᛦᛚᚳ᛫ᛗᛁᚳᛚᚢᚾ᛫ᚻᛦᛏ᛫ᛞᚫᛚᚪᚾ
ᚷᛁᚠ᛫ᚻᛖ᛫ᚹᛁᛚᛖ᛫ᚠᚩᚱ᛫ᛞᚱᛁᚻᛏᚾᛖ᛫ᛞᚩᛗᛖᛋ᛫ᚻᛚᛇᛏᚪᚾ᛬'.
	"In UTF-8 the runes are all 3 code units long, in UTF-16 they are in the basic plane, so 1 code unit"
	actual := subject subStrings: $\x16EB.
	self assert: actual
		equals: #('ᚠᛇᚻ' 'ᛒᛦᚦ' 'ᚠᚱᚩᚠᚢᚱ' 'ᚠᛁᚱᚪ' 'ᚷᛖᚻᚹᛦᛚᚳᚢᛗ
ᛋᚳᛖᚪᛚ' 'ᚦᛖᚪᚻ' 'ᛗᚪᚾᚾᚪ' 'ᚷᛖᚻᚹᛦᛚᚳ' 'ᛗᛁᚳᛚᚢᚾ' 'ᚻᛦᛏ' 'ᛞᚫᛚᚪᚾ
ᚷᛁᚠ' 'ᚻᛖ' 'ᚹᛁᛚᛖ' 'ᚠᚩᚱ' 'ᛞᚱᛁᚻᛏᚾᛖ' 'ᛞᚩᛗᛖᛋ' 'ᚻᛚᛇᛏᚪᚾ᛬')!

testSecondThirdEtc
	| subject |
	subject := self assimilateString: '🐬a£文🍺Ā'.
	self assert: subject second equals: $a.
	self assert: subject third equals: $£.
	self assert: subject fourth equals: $\x6587.
	self assert: subject fifth equals: $\x1F37A.
	self assert: subject sixth equals: $\x100.
	self should: [self collectionClass empty second] raise: Error.
	self should: [self collectionClass empty third] raise: Error.
	self should: [self collectionClass empty third] raise: Error.
	self should: [self collectionClass empty fourth] raise: Error.
	self should: [self collectionClass empty fifth] raise: Error.
	self should: [self collectionClass empty sixth] raise: Error!

testSelect
	| subject actual |
	subject := self assimilateString: 'a文£🐬1🍺🍻'.
	actual := subject select: 
					[:each |
					self deny: each isSurrogate.
					each codePoint > 256].
	self assert: actual equals: '文🐬🍺🍻'.
	self assert: (self collectionClass empty select: [:each | self assert: false]) equals: ''!

testSplitByCharacterArrayExtended
	| subject actual separators |
	subject := self assimilateString: '一1二2三3四'.
	separators := #($\x4E00 $\x4E8C $\x4E09 $\x56DB).
	actual := separators split: subject.
	"Note that leading/trailing separator results in an empty element in the result collection"
	self assert: actual equals: #('' '1' '2' '3' '').
	"Split by empty list of separators should return original string as the single result"
	self assert: (#() split: subject) equals: {subject}.
	"Splitting an empty string should return an empty result"
	subject := self assimilateString: ''.
	actual := separators split: subject.
	self assert: actual equals: #()!

testSplitByString
	| subject actual separators empty |
	subject := self assimilateString: '£文a£文🐬£1£文🍺£文'.
	separators := self assimilateString: '£文'.
	actual := separators split: subject.
	self assert: actual equals: #('' 'a' '🐬£1' '🍺' '').
	empty := self assimilateString: ''.
	self assert: (empty split: subject) equals: {subject}.
	actual := separators split: empty.
	self assert: actual equals: #()!

testWithDo
	| subject reversed pairs testCase expected |
	testCase := 'a£1文🍺'.
	subject := self assimilateString: testCase.
	reversed := testCase reverse.
	expected := #(#($a $\x1F37A) #($£ $\x6587) #($1 $1) #($\x6587 $£) #($\x1F37A $a)).
	pairs := OrderedCollection new.
	subject with: reversed asUtf8String do: [:a :b | pairs add: {a. b}].
	self assert: pairs asArray equals: expected.
	pairs := OrderedCollection new.
	subject with: reversed asUtf16String do: [:a :b | pairs add: {a. b}].
	self assert: pairs asArray equals: expected.
	pairs := OrderedCollection new.
	subject with: reversed asArray do: [:a :b | pairs add: {a. b}].
	self assert: pairs asArray equals: expected.
	self should: [subject with: (1 to: 6) do: [:a :b | ]] raise: Error.
	self should: [subject with: (1 to: 4) do: [:a :b | ]] raise: Error!

withAllTestCases
	^super withAllTestCases , {{'a 🐬 è' asUtf16String}.
				{'a 🐬 è' asUtf8String}.
				#('Приве́т नमस्ते שָׁלוֹם').
				#('áèȋöû')}! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #afterTestCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #beforeTestCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #caseConversionCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #decodeIncompleteContinuations!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #decodeInvalidContinuations!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #decodeTestCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #indexOfTestCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #lengthTestCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #makeStringFromCodeUnits:!helpers!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #reverseTestCases!constants!private! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testAllButFirst!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testAllButLast!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testAllSatisfy!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testAnsiStringRoundTrip!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testAnyone!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testAnySatisfy!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testBeginsWithExtended!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testBeginsWithIgnoreCase!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testCollect!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testCopyReplaceAllWith!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testCopyReplacingWithObject!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testCopyWithout!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testCopyWithoutIndex!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testDecodeAt!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testDecodeNextFrom!constants!public! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testEncodeOnPut!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testFindFirst!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testFindLast!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testFirst!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testFirstColon!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testFromToKeysAndValuesDo!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testGothicSubStrings!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testIdentityIncludes!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testIncludes!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testInjectInto!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testKeysAndValuesDo!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testLast!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testLastColon!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testLeftString!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testMidString!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testOccurrencesOf!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testPairsDo!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testReject!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testReverseComposites!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testRuneSubStrings!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testSecondThirdEtc!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testSelect!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testSplitByCharacterArrayExtended!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testSplitByString!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #testWithDo!public!unit tests! !
!Core.Tests.UtfEncodedStringTest categoriesFor: #withAllTestCases!constants!private! !

