"Filed out from Dolphin Smalltalk"!

Core.Tests.StringTest
	subclass: #'Core.Tests.UtfEncodedStringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.UtfEncodedStringTest guid: (Core.GUID fromString: '{f3d4f4a7-05b6-445f-8380-d0b838804877}')!
Core.Tests.UtfEncodedStringTest isNonInstantiable: true!
Core.Tests.UtfEncodedStringTest comment: ''!
!Core.Tests.UtfEncodedStringTest methodsFor!

afterTestCases
	^super afterTestCases
		, #(#('🐬Ā' $\x1F42C $\x100) #('🐬🍺' $\x1F42C $\x1F37A) #('Ā文' $\x100 $\x6587))!

beforeTestCases
	^super beforeTestCases
		, #(#('Ā🐬' $\x1F42C $\x100) #('🐬🍺' $\x1F37A $\x1F42C) #('文Ā' $\x100 $\x6587))!

caseConversionCases
	"Turkic i's are tested separately as these are non-standard cases."

	^self ordinalCaseConversionCases , #(#('straße' 'STRASSE'))!

caseInsensitiveEqualCases
	^super caseInsensitiveEqualCases , #(#('🐬' '🐬'))!

caseInsensitiveLessThanCases
	^super caseInsensitiveLessThanCases
		, #(#('' '🐬') #('🐬' '🐬a') #('a🐬' 'b🐬') #('a' '🐬') #('A' '🐬'))!

decodeIncompleteContinuations
	^self subclassResponsibility!

decodeInvalidCharacters
	^#()!

decodeInvalidContinuations
	^self subclassResponsibility!

decodeNonCharacters
	"Just one replacement char expected for these"
	^#($\x3FFFF $\xFFFF $\x10FFFF)!

decodeTestCases
	^self subclassResponsibility!

equalityTestCases
	^super equalityTestCases
		, #(#('Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ' 'ḼƠᶉËᶆ ȊṔŠᶙṀ ḌỠḼǬᵳ ʂǏŤ ӒṀỆẗ, ĈṒƝṨḘĊŤᶒȚÛɾ ẤƉḮƤĬṨČĮɳĠ ḜŁĮƮ, ȘẾᶑ ᶁⱺ ẼḬŬŜḾꝊĎ ṪĔᶆᶈṒɌ ỈÑḈĪḐȊᵭṴŃŤ ṶŦ ḸẨḆŐꝚẾ Éȶ ĐꝌꞎÔꝚȆ ᵯÁꞡᶇĀ ĄⱠÎɊṸẴ') #('a🐬' 'A🐬'))!

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

matchingPairs
	^super matchingPairs , #(#('#' '🐬') #('#€#a' '🐬€🍺a'))!

ordinalCaseConversionCases
	^super ordinalCaseConversionCases
		, #(#('кракозябры' 'КРАКОЗЯБРЫ') #('文字化け') #('маймуница' 'МАЙМУНИЦА') #('ａｂｃ' 'ＡＢＣ'))!

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
	self assert: ansi equals: ansiAll.

	"A few common non-ASCII examples"
	#($€ $£) do: 
			[:each |
			| utf ansi |
			utf := self collectionClass with: each.
			ansi := utf asAnsiString.
			self assert: ansi single equals: each.
			self assert: (self assimilateString: ansi) equals: utf].

	"A few common non-tround-tripping examples - e.g. turkish dotless-i's do not normally roundtrip, unless using a turkic code page."
	#('ınteresting' 'interesting' '∞' '8' '・' '·') pairsDo: 
			[:each :expected |
			| utf ansi |
			utf := self assimilateString: each.
			ansi := utf asAnsiString.
			self assert: ansi equals: expected asAnsiString.
			"Doesn't round-trip"
			self deny: (self assimilateString: ansi) equals: utf.
			self assert: (self assimilateString: ansi) equals: ansi].

	"Chars outside the BMP should translate to a single replacement char, not two"
	self assert: (self collectionClass with: Character dolphin) asAnsiString equals: '?'!

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

testAsAnsiStringDotlessI
	| subject actual |
	"Note that turkic i's are not normally preserved on conversion to an ANSI string, unless using a turkic code page."
	Locale userDefault isTurkic
		ifTrue: 
			[subject := self assimilateString: 'İiıI'.
			actual := subject asAnsiString.
			self assert: actual equals: 'İiıI']
		ifFalse: 
			[subject := self assimilateString: 'İiıI'.
			actual := subject asAnsiString.
			self assert: actual equals: 'IiiI']!

testAsLowercase
	| de tr |
	de := Locale named: 'de-DE'.
	self assert: ('' asLowercase: de) equals: ''.
	self assert: ('STRAẞE' asLowercase: de) equals: 'straße'.
	"Turkish dotted and non-dotted i"
	tr := Locale named: 'tr-TR'.
	self assert: ('INTERESTİNG' asLowercase: tr) equals: 'ınteresting'.
	"Invariant"
	{ Locale invariant. Locale smalltalk } do: 
			[:invariant |
			self assert: ('' asLowercase: invariant) equals: ''.
			"Upper-case german eszett is converted by invariant Locale as it still requests linguistic case translations, and the letter is only used in German so is not ambiguous."
			self assert: ('STRAẞE' asLowercase: invariant) equals: 'straße'.
			"Turkish dotted and non-dotted i; invariant lowercase-i is always dotted"
			self deny: invariant isTurkic.
			"Note that with ICU we get a U+0307 (Combining dot above) after the lowercase, presumably to preserve that it was a conversion from U+0130"
			self assert: ('INTERESTİNG' asLowercase: invariant) equals: 'interesti̇ng']!

testAsUppercase
	| de tr |
	de := Locale standard: 'de-DE'.
	self assert: ('' asUppercase: de) equals: ''.
	"There are two lower-case forms of the greek letter Sigma."
	self assert: ('Ὀδυσσεύς' asUppercase: de) equals: 'ὈΔΥΣΣΕΎΣ'.
	self deny: ('Straße' asUppercase: de) equals: 'STRAẞE'.
	"Single code-point ligature converted to 3 uppercase code points"
	self assert: (self collectionClass with: $ﬄ) asUppercase equals: 'FFL'.
	"Turkish dotted and dotless i should be converted correctly preserved the dot or absence of dot"
	tr := Locale standard: 'tr-TR'.
	self assert: ('ınteresting' asUppercase: tr) equals: 'INTERESTİNG'.
	{ Locale invariant. Locale smalltalk } do: 
			[:subject |
			self assert: ('' asUppercase: subject) equals: ''.
			"With ICU the eszett is now uppercased correctly"
			self assert: ('Straße' asUppercase: subject) equals: 'STRASSE'.
			self assert: ('ınteresting' asUppercase: subject) equals: 'INTERESTING'.
			"There are two lower-case forms of the greek letter Sigma."
			self assert: ('Ὀδυσσεύς' asUppercase: subject) equals: 'ὈΔΥΣΣΕΎΣ']!

testBeginsWithExtended
	| subject comparand |
	subject := self newCollection: { Character dolphin. $a. $£. $b. $c }.
	self assert: (subject beginsWith: Character dolphin).
	self deny: (subject beginsWith: (String with: $\xF0)).
	self deny: (subject beginsWith: $\xF0).
	self deny: (subject beginsWith: (String with: $\x3D)).
	self deny: (subject beginsWith: $\x3D).
	comparand := Character dolphin asUtf8String , 'a£'.
	self assert: (subject beginsWith: comparand).
	comparand := Character dolphin asUtf16String , 'a£'.
	self assert: (subject beginsWith: comparand)!

testBeginsWithIgnoreCaseExtended
	| subject comparand |
	subject := self newCollection: { Character dolphin. $a. $\0. $£. $b. $c }.
	comparand := Utf16String withAll: { Character dolphin. $A. $\0. $£ }.
	self assert: (subject beginsWith: comparand ignoreCase: true).
	self deny: (subject beginsWith: comparand ignoreCase: false).
	"Note that this is an ordinal comparison, so linguistic case folding is not used."
	self deny: ('straße' beginsWith: 'STRASS' ignoreCase: false)!

testCollect
	| subject actual |
	subject := self assimilateString: 'a£文🐬1🍺'.
	actual := subject collect: 
					[:each |
					self deny: each isSurrogate.
					Character value: each codePoint + 1].
	self assert: actual equals: 'b¤斈🐭2🍻'.
	self assert: (self collectionClass empty collect: [:each | self assert: false]) equals: ''!

testCompareEszett
	| lower upper |
	lower := 'straße'.
	upper := 'STRASSE'.
	self assert: lower <= upper.
	self assert: upper <= lower.
	self assert: lower >= upper.
	self assert: upper >= lower.
	self assert: lower <=> upper equals: 0.
	self assert: upper <=> lower equals: 0!

testConcatenation
	| actual triples |
	triples := #(#('' '' '') #('' '€' '€') #('€' '' '€') #('' '€£' '€£') #('€£' '' '€£') #('a' '£' 'a£') #('a' '€' 'a€') #('' '🐬' '🐬') #('£' 'a' '£a') #('€' 'a' '€a') #('£' '€~🐬' '£€~🐬') #('a£~€' 'b£€�𐀀🐬' 'a£~€b£€�𐀀🐬')).
	triples do: 
			[:each |
			| prefix |
			prefix := self assimilateString: each first.
			actual := prefix , each second asUtf8String.
			self assert: actual isKindOf: self copyClass.
			self assert: actual equals: each third.
			actual := prefix , each second asUtf16String.
			self assert: actual isKindOf: self copyClass.
			self assert: actual equals: each third]!

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

testCopyWith
	| subject copy |
	super testCopyWith.
	subject := self collectionClass empty.
	copy := subject copyWith: $🐬.
	self assert: copy class identicalTo: copy copyingClass.
	self assert: copy equals: '🐬'.
	subject := self assimilateString: 'a'.
	copy := subject copyWith: $🐬.
	self assert: copy class identicalTo: copy copyingClass.
	self assert: copy equals: 'a🐬'.
	subject := self assimilateString: 'a£文1🍺'.
	self assert: subject length equals: 5.
	copy := subject copyWith: $🐬.
	self assert: copy class identicalTo: copy copyingClass.
	self assert: copy equals: 'a£文1🍺🐬'.
	self assert: copy length equals: 6!

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

testCountElements
	self decodeTestCases pairsDo: 
			[:codes :char |
			| subject |
			subject := self makeStringFromCodeUnits: codes.
			self assert: subject countElements equals: 1].
	self decodeInvalidContinuations do: 
			[:each |
			| subject |
			subject := self makeStringFromCodeUnits: each first.
			self assert: subject countElements equals: each second + 1].
	self decodeIncompleteContinuations do: 
			[:each |
			| subject |
			subject := self makeStringFromCodeUnits: each.
			self assert: subject countElements equals: each size].
	self decodeNonCharacters do: 
			[:each |
			| subject |
			subject := self collectionClass with: each.
			self assert: subject countElements equals: 1].
	self decodeInvalidCharacters pairsDo: 
			[:codes :replacements |
			| subject |
			subject := self makeStringFromCodeUnits: codes.
			self assert: subject countElements equals: replacements]!

testDecodeAt
	self decodeTestCases pairsDo: 
			[:codes :char |
			| subject actual |
			subject := self makeStringFromCodeUnits: codes.
			actual := subject decodeAt: 1.
			self assert: actual equals: char.
			"Starting in the middle of a character should always return the replacement character"
			2 to: subject size
				do: 
					[:i |
					self assert: (subject decodeAt: i) equals: Character replacement.
					self assert: (subject encodedSizeAt: i) equals: 1]].
	self decodeInvalidContinuations do: 
			[:each |
			| subject actual |
			subject := self makeStringFromCodeUnits: each first.
			actual := subject decodeAt: 1.
			self assert: actual equals: Character replacement.
			self assert: (subject encodedSizeAt: 1)
				equals: (subject readStream
						next;
						position)].
	self decodeIncompleteContinuations do: 
			[:each |
			| subject actual |
			subject := self makeStringFromCodeUnits: each.
			actual := subject decodeAt: 1.
			self assert: actual equals: Character replacement.
			self assert: (subject encodedSizeAt: 1)
				equals: (subject readStream
						next;
						position)].
	self decodeNonCharacters do: 
			[:each |
			| subject actual |
			subject := self collectionClass with: each.
			actual := subject decodeAt: 1.
			self assert: actual equals: Character replacement.
			self assert: (subject encodedSizeAt: 1) equals: (subject encodedSizeOf: each)].
	self decodeInvalidCharacters pairsDo: 
			[:codes :replacements |
			| subject actual |
			subject := self makeStringFromCodeUnits: codes.
			actual := subject decodeAt: 1.
			self assert: actual equals: Character replacement.
			self assert: (subject encodedSizeAt: 1) equals: 1]!

testDecodeNextFrom
	"Test that the UTF decoding in the String #decodeNextFrom: methods, and in the VM's primitiveNext, correctly handles decoding of valid and invalid encoding sequences.
	"

	| subject |
	subject := self collectionClass empty.
	self decodeTestCases pairsDo: 
			[:codes :char |
			| stream actual string |
			stream := codes readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: char.
			self assert: stream atEnd.
			"Test primitiveNext"
			string := self makeStringFromCodeUnits: codes.
			stream := string readStream.
			actual := stream next.
			self assert: actual equals: char.
			self assert: stream atEnd.
			stream reset.
			self assert: stream upToEnd equals: string].
	self decodeInvalidContinuations do: 
			[:each |
			| stream actual string |
			stream := each first readStream.
			each second timesRepeat: 
					[actual := subject decodeNextFrom: stream.
					self assert: actual equals: Character replacement].
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: each last.
			self assert: stream atEnd.
			"Test primitiveNext"
			string := self makeStringFromCodeUnits: each first.
			stream := string readStream.
			each second timesRepeat: [self assert: stream next equals: Character replacement].
			self assert: stream next equals: each last.
			self assert: stream atEnd].
	self decodeIncompleteContinuations do: 
			[:codes |
			| stream string |
			stream := codes readStream.
			codes size timesRepeat: 
					[| actual |
					actual := subject decodeNextFrom: stream.
					self assert: actual equals: Character replacement].
			self assert: stream atEnd.
			"Test primitiveNext"
			string := self makeStringFromCodeUnits: codes.
			stream := string readStream.
			codes size timesRepeat: [self assert: stream next equals: Character replacement]].
	self decodeNonCharacters do: 
			[:each |
			| stream actual |
			stream := (self collectionClass with: each) readStream.
			actual := subject decodeNextFrom: stream.
			self assert: actual equals: Character replacement.
			self assert: stream atEnd.
			"Test primitiveNext"
			stream reset.
			self assert: stream next equals: Character replacement.
			self assert: stream atEnd].
	self decodeInvalidCharacters pairsDo: 
			[:codes :replacements |
			| stream actual string |
			stream := codes readStream.
			replacements timesRepeat: 
					[actual := subject decodeNextFrom: stream.
					self assert: actual equals: Character replacement].
			self assert: stream atEnd.
			"Test primitiveNext"
			string := self makeStringFromCodeUnits: codes.
			stream := string readStream.
			replacements timesRepeat: [self assert: stream next equals: Character replacement].
			self assert: stream atEnd]!

testDetectIfNoneExtended
	| absent chars subject |
	absent := Object new.
	chars := Array writeStream.
	self decodeTestCases pairsDo: [:bytes :char | chars nextPut: char].
	chars := chars contents.
	subject := self newCollection: chars.
	chars keysAndValuesDo: 
			[:key :ch |
			| enumerated |
			enumerated := OrderedCollection new.
			self assert: (subject detect: 
							[:each |
							enumerated add: each.
							each = ch]
						ifNone: [absent])
				equals: ch.
			self assert: enumerated asArray equals: (chars copyFrom: 1 to: key).
			self assert: (subject detect: [:each | each = $🍻] ifNone: [absent]) identicalTo: absent]!

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

testEndsWithExtended
	| chars string |
	string := self assimilateString: 'abc🐬e'.
	chars := string asArray.
	self assert: chars size equals: 5.
	1 to: 6
		do: 
			[:each |
			| tail |
			tail := chars copyFrom: each to: chars size.
			self assert: (string endsWith: tail).
			self assert: (string endsWith: (Utf8String withAll: tail)).
			self assert: (string endsWith: (Utf16String withAll: tail)).
			self deny: (string endsWith: $d).
			self deny: (string endsWith: $🐬)].
	self assert: (string endsWith: 'e' asAnsiString).
	self deny: (string endsWith: 'd' asAnsiString).
	self deny: (string endsWith: '🐬e' asAnsiString).
	self deny: (string endsWith: 'c🐬' asUtf16String).
	self deny: (string endsWith: 'c🐬' asUtf8String).
	self deny: (string endsWith: '🐬' asUtf16String).
	self deny: (string endsWith: '🐬' asUtf8String).
	self deny: (string endsWith: #(101)).
	self deny: (string endsWith: #[101]).
	self assert: (string endsWith: $e).
	self deny: (string endsWith: $d).
	self deny: (string endsWith: $¬).
	self deny: (string endsWith: $Ā).
	self deny: (string endsWith: $ࠀ).
	self deny: (string endsWith: $🐬).
	string := string copyFrom: 1 to: string size - 1.
	self assert: (string endsWith: $🐬).
	self deny: (string endsWith: $🐭).
	self deny: (string endsWith: $? asAnsiString)!

testFindFirst
	| subject index |
	super testFindFirst.
	subject := self assimilateString: 'a£🍺文1'.
	subject
		do: [:ch | self assert: (subject findFirst: [:each | each = ch]) equals: (subject indexOf: ch)].
	index := subject findFirst: [:each | each = Character dolphin].
	self assert: index equals: 0.
	index := self collectionClass empty findFirst: [:each | each = $a].
	self assert: index equals: 0!

testFindLast
	| subject index |
	subject := self assimilateString: 'a£🍺文1a£🍺文1'.
	subject
		do: [:ch | self assert: (subject findLast: [:each | each = ch]) equals: (subject lastIndexOf: ch)].
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

testFoldCaseICU
	"Transcription of ICU case folding test."

	| mixed foldedDefault foldedExcludeSpecialI subject tr de |
	mixed := Utf16String
				withAll: (#(16r61 16r42 16r130 16r49 16r131 16r3D0 16rDF 16rFB03 16rD93F 16rDFFF)
						collect: [:each | Character utf16Value: each]).	"'aBİIıϐßﬃ�'"
	foldedDefault := Utf16String
				withAll: (#(16r61 16r62 16r69 16r307 16r69 16r131 16r3B2 16r73 16r73 16r66 16r66 16r69 16rD93F 16rDFFF)
						collect: [:each | Character utf16Value: each]). "'abi̇iıβssffi�'"
	foldedExcludeSpecialI := Utf16String
				withAll: (#(16r61 16r62 16r69 16r131 16r131 16r3B2 16r73 16r73 16r66 16r66 16r69 16rD93F 16rDFFF)
						collect: [:each | Character utf16Value: each]).	"'abiııβssffi�'"
	tr := Locale named: 'tr-TR'.
	de := Locale named: 'de-DE'.
	subject := self assimilateString: mixed.
	self assert: subject caseFolded equals: foldedDefault.
	self assert: (subject caseFolded: de) equals: foldedDefault.
	self assert: (subject caseFolded: tr) equals: foldedExcludeSpecialI!

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

testLessOrEqual
	super testLessOrEqual.
	#('' '🐬' '🐬' '🐬' '🐬' '🐬a' 'a🐬' '🐬' 'a🐬' 'b🐬' 'a' '🐬' 'A' '🐬')
		pairsDo: 
			[:a :b |
			| subject |
			subject := self assimilateString: a.
			self assert: subject <= b asUtf8String.
			self assert: subject <= b asUtf16String].
	#('🐬' '' '🐬' '£🐬')
		pairsDo: 
			[:a :b |
			| subject |
			subject := self assimilateString: a.
			self deny: subject <= b asAnsiString.
			self deny: subject <= b asUtf8String.
			self deny: subject <= b asUtf16String].!

testLetterICaseConversions
	"Letter i is a a bit of a special case. Note that we don't test asLowercase/asUppercase/caseFolded, as the outcome of these depends on the default locale so is unstable. The conversions without a parameter are equivalent to, e.g. `string asLocale: Locale userDefault`"

	| tr de az en capitalDotted smallDotted capitalDotless smallDotless |
	tr := Locale named: 'tr-TR'.
	de := Locale named: 'de-DE'.
	az := Locale named: 'az-Latn-AZ'.
	en := Locale named: 'en-GB'.
	"All the i forms"
	"[U+0049 LATIN CAPITAL LETTER I](https://codepoints.net/U+0049)"
	capitalDotless := self collectionClass with: $I.
	"[U+0130 Latin Capital Letter I with Dot Above](https://codepoints.net/U+0130)"
	capitalDotted := self collectionClass with: $İ.
	"[U+0069 Latin Small Letter I](https://codepoints.net/U+0069)"
	smallDotted := self collectionClass with: $i.
	" [U+0131 Latin Small Letter Dotless I](https://codepoints.net/U+0131)"
	smallDotless := self collectionClass with: $ı.
	"Conversion of letter to own case should be a nop"
	self assert: (smallDotted asLowercase: tr) equals: smallDotted.
	self assert: (smallDotted asLowercase: de) equals: smallDotted.
	self assert: (smallDotted asLowercase: en) equals: smallDotted.
	self assert: smallDotted asLowercase equals: smallDotted.
	self assert: (smallDotless asLowercase: tr) equals: smallDotless.
	self assert: (smallDotless asLowercase: de) equals: smallDotless.
	self assert: (smallDotless asLowercase: en) equals: smallDotless.
	self assert: smallDotless asLowercase equals: smallDotless.
	self assert: (capitalDotted asUppercase: tr) equals: capitalDotted.
	self assert: (capitalDotted asUppercase: de) equals: capitalDotted.
	self assert: (capitalDotted asUppercase: en) equals: capitalDotted.
	self assert: capitalDotted asUppercase equals: capitalDotted.
	self assert: (capitalDotless asUppercase: tr) equals: capitalDotless.
	self assert: (capitalDotless asUppercase: de) equals: capitalDotless.
	self assert: (capitalDotless asUppercase: en) equals: capitalDotless.
	self assert: capitalDotless asUppercase equals: capitalDotless.

	"In turkic locales, linguistic lowercase of U+0130 is U+0069"
	self assert: (capitalDotted asLowercase: tr) equals: smallDotted.
	"In de-DE we get the U+0069 U+0307 sequence"
	self assert: (capitalDotted asLowercase: de) equals: smallDotted , (self collectionClass with: $̇).
	self assert: (capitalDotted asLowercase: en) equals: smallDotted , (self collectionClass with: $̇).

	"In turkic locales expect U+0049 to lowercase to U+0131"
	self assert: (capitalDotless asLowercase: tr) equals: smallDotless.
	"But not elsewhere"
	self assert: (capitalDotless asLowercase: de) equals: smallDotted.

	"Linguistic Uppercase of U+0131 is always to U+0049"
	self assert: (smallDotless asUppercase: tr) equals: capitalDotless.
	self assert: (smallDotless asUppercase: de) equals: capitalDotless.

	"In turkic locales expect U+0069 to uppercase to U+0130"
	self assert: (smallDotted asUppercase: tr) equals: capitalDotted.
	"But not elsewhere"
	self assert: (smallDotted asUppercase: de) equals: capitalDotless.

	"In summary"
	self assert: ('İiıI' asLowercase: az) equals: 'iiıı'.
	self assert: ('İiıI' asUppercase: az) equals: 'İİII'.
	self assert: ('İiıI' asLowercase: de) equals: 'i̇iıi'.
	self assert: ('İiıI' asUppercase: de) equals: 'İIII'.
	self assert: ('İiıI' asLowercase: en) equals: 'i̇iıi'.
	self assert: ('İiıI' asUppercase: en) equals: 'İIII'!

testMatchExtended
	#(#('#' '🐬') #('*#' '🐬') #('*#a' '🐬A') #('*#€#🍺*B*' '🐬€a🍺b') #('*€文a#b*c' '🐬🍺€文a🍺€文a🍺bc'))
		do: [:each | self verifyPattern: each first matches: each second]!

testMidString
	| subject |
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject midString: 3 from: (subject indexOf: $a)) equals: 'a£文'.
	self assert: (subject midString: 3 from: (subject indexOf: $£)) equals: '£文🍺'.
	self should: [subject midString: 3 from: (subject indexOf: $\x6587)] raise: Error!

testNewWithAll
	| subject |
	0 to: 3
		do: 
			[:i |
			subject := self collectionClass new: i withAll: $\x1F42C.
			self assert: subject asArray size equals: i.
			subject allSatisfy: [:each | each = $\x1F42C]]!

testOccurrencesOf
	| subject |
	subject := self assimilateString: '🐬a£文🐬Ā🍺Ā'.
	self assert: (subject occurrencesOf: $🐬) equals: 2.
	self assert: (subject occurrencesOf: $£) equals: 1.
	self assert: (subject occurrencesOf: $文) equals: 1.
	self assert: (subject occurrencesOf: $ð) equals: 0.
	self assert: (subject occurrencesOf: $Ā) equals: 2.
	subject := self collectionClass empty.
	self assert: (subject occurrencesOf: $🐬) equals: 0!

testOccurrencesOfFromTo
	| subject |
	subject := self assimilateString: '🐬a£文a🐬Ā🍺'.
	self assert: (subject
				occurrencesOf: $🐬
				from: 1
				to: subject size - 1)
		equals: 2.
	2 to: 6
		do: 
			[:i |
			self assert: (subject
						occurrencesOf: $🐬
						from: i
						to: subject size - 1)
				equals: 1].
	self assert: (subject
				occurrencesOf: $a
				from: 2
				to: subject size - 1)
		equals: 2.
	self assert: (subject
				occurrencesOf: $🍺
				from: 2
				to: subject size)
		equals: 1.
	self assert: (subject
				occurrencesOf: $🍺
				from: 2
				to: subject size - 1)
		equals: 0.
	subject := self collectionClass empty.
	self assert: (subject
				occurrencesOf: $🐬
				from: 1
				to: subject size)
		equals: 0!

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
	pairs removeAll.
	subject with: reversed asUtf16String do: [:a :b | pairs add: {a. b}].
	self assert: pairs asArray equals: expected.
	pairs removeAll.
	subject with: reversed asArray do: [:a :b | pairs add: {a. b}].
	self assert: pairs asArray equals: expected.
	self should: [subject with: (1 to: 6) do: [:a :b | ]] raise: Error.
	self should: [subject with: (1 to: 4) do: [:a :b | ]] raise: Error!

verifyPattern: patternString matches: matchString
	self assert: ((self assimilateString: patternString) match: matchString asUtf8String).
	self assert: ((self assimilateString: patternString) match: matchString asUtf16String)!

withAllTestCases
	^super withAllTestCases , {{'a 🐬 è' asUtf16String}.
				{'a 🐬 è' asUtf8String}.
				#('Приве́т नमस्ते שָׁלוֹם').
				#('áèȋöû')}! !
!Core.Tests.UtfEncodedStringTest categoriesForMethods!
afterTestCases!constants!private! !
beforeTestCases!constants!private! !
caseConversionCases!constants!private! !
caseInsensitiveEqualCases!constants!private! !
caseInsensitiveLessThanCases!constants!private! !
decodeIncompleteContinuations!constants!private! !
decodeInvalidCharacters!constants!private! !
decodeInvalidContinuations!constants!private! !
decodeNonCharacters!constants!private! !
decodeTestCases!constants!private! !
equalityTestCases!constants!private! !
indexOfTestCases!constants!private! !
lengthTestCases!constants!private! !
makeStringFromCodeUnits:!helpers!private! !
matchingPairs!constants!private! !
ordinalCaseConversionCases!constants!private! !
reverseTestCases!constants!private! !
testAllButFirst!public!unit tests! !
testAllButLast!public!unit tests! !
testAllSatisfy!public!unit tests! !
testAnsiStringRoundTrip!public!unit tests! !
testAnyone!public!unit tests! !
testAnySatisfy!public!unit tests! !
testAsAnsiStringDotlessI!public!unit tests! !
testAsLowercase!public!unit tests! !
testAsUppercase!public!unit tests! !
testBeginsWithExtended!public!unit tests! !
testBeginsWithIgnoreCaseExtended!public!unit tests! !
testCollect!public!unit tests! !
testCompareEszett!public! !
testConcatenation!public!unit tests! !
testCopyReplaceAllWith!public!unit tests! !
testCopyReplacingWithObject!public!unit tests! !
testCopyWith!public! !
testCopyWithout!public!unit tests! !
testCopyWithoutIndex!public!unit tests! !
testCountElements!public!unit tests! !
testDecodeAt!public!unit tests! !
testDecodeNextFrom!public!unit tests! !
testDetectIfNoneExtended!public!unit tests! !
testEncodeOnPut!public!unit tests! !
testEndsWithExtended!public!unit tests! !
testFindFirst!public!unit tests! !
testFindLast!public!unit tests! !
testFindStringStartingAt!public!unit tests! !
testFirst!public!unit tests! !
testFirstColon!public!unit tests! !
testFoldCaseICU!public! !
testFromToKeysAndValuesDo!public!unit tests! !
testGothicSubStrings!public!unit tests! !
testIdentityIncludes!public!unit tests! !
testIncludes!public!unit tests! !
testInjectInto!public!unit tests! !
testKeysAndValuesDo!public!unit tests! !
testLast!public!unit tests! !
testLastColon!public!unit tests! !
testLeftString!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLetterICaseConversions!public!unit tests! !
testMatchExtended!public! !
testMidString!public!unit tests! !
testNewWithAll!public! !
testOccurrencesOf!public!unit tests! !
testOccurrencesOfFromTo!public!unit tests! !
testPairsDo!public!unit tests! !
testReject!public!unit tests! !
testReverseComposites!public!unit tests! !
testRuneSubStrings!public!unit tests! !
testSecondThirdEtc!public!unit tests! !
testSelect!public!unit tests! !
testSplitByCharacterArrayExtended!public!unit tests! !
testSplitByString!public!unit tests! !
testWithDo!public!unit tests! !
verifyPattern:matches:!public! !
withAllTestCases!constants!private! !
!

