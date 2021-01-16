"Filed out from Dolphin Smalltalk 7"!

Core.Tests.StreamTest subclass: #'Core.Tests.PositionableStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.PositionableStreamTest guid: (Core.GUID fromString: '{3abcc3a3-be2b-417d-bdb7-cf6a64cc2c6b}')!
Core.Tests.PositionableStreamTest isNonInstantiable: true!
Core.Tests.PositionableStreamTest comment: ''!
!Core.Tests.PositionableStreamTest categoriesForClass!Unclassified! !
!Core.Tests.PositionableStreamTest methodsFor!

arrayedCollections
	^self strings, self byteArrays, self arrays!

arrays
	^#(#(#()) #(#(#x)) #(#(#x #y)))!

byteArrays
	^#(#(#[] #()) #(#[1] #(1)) #(#[1 255] #(1 255)))!

collections
	^self strings , self byteArrays , self arrays, self intervals , self orderedCollections, self runArrays!

intervals
	^{{1 to: 0. #()}. {2 to: 2. #(2)}. {1 to: 5. #(1 2 3 4 5)}. {3 to: 1 by: -1. #(3 2 1)}}!

newStream
	^self streamOn: String new!

orderedCollections
	^{{OrderedCollection new. #()}.
		{OrderedCollection with: #x. #(x)}.
		{OrderedCollection with: #x with: #y. #(#x #y)}.
		{(1 to: 10) asOrderedCollection
				removeFirst;
				yourself.
			#(2 3 4 5 6 7 8 9 10)}}!

readOperationNotImplemented: aBlock 
	"It is an error to attempt to read from a WriteStream"

	self 
		should: aBlock
		raise: Error
		matching: [:ex | ex description = 'The stream is not readable']!

runArrays
	^{{RunArray new. #()}.
		{RunArray with: #x. #(#x)}.
		{RunArray with: #x with: #y. #(#x #y)}.
		{(1 to: 5) asRunArray. #(1 2 3 4 5)}}!

streamClassSupportsPointers
	^true!

streamClassSupportsUtf16
	^true!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

streamOnBytes: aByteArray type: aSymbol
	^aSymbol == #utf8
		ifTrue: [self streamOn: (Utf8String fromByteArray: aByteArray)]
		ifFalse: 
			[aSymbol == #utf16le
				ifTrue: [self streamOn: (Utf16String fromByteArray: aByteArray)]
				ifFalse: [self streamOn: aByteArray]]!

streamOnFile: pathString type: aSymbol
	^self streamOnBytes: (File readAllBytes: pathString) type: aSymbol!

streamWith: aSequenceableCollection
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <SequenceableCollection> argument."

	^self streamClass with: aSequenceableCollection copy!

strings
	^{#('' #()).
		{Utf8String empty. #()}.
		{Utf16String empty. #()}.
		#('a' #($a)).
		#('abc' #($a $b $c)).
		{'£€1' asAnsiString. #($£ $\x20AC $1)}.
		{'a£€1' asUtf8String. #($a $£ $\x20AC $1)}.
		{Character byteCharacterSet. Character byteCharacterSet asArray}.
		{'a' , Character dolphin asUtf8String , '文'. #($a $\x1F42C $\x6587)}.
		{'a' , Character dolphin asUtf16String , '文'. #($a $\x1F42C $\x6587)}}!

subjectCollection: aSequenceableCollection
	^aSequenceableCollection!

testBasicNext
	self arrayedCollections do: 
			[:pair |
			| each subject collection |
			each := pair first.
			subject := self streamOn: each.
			collection := self subjectCollection: each.
			1 to: collection size
				do: 
					[:i |
					| expected actual |
					expected := collection basicAt: i.
					actual := subject basicNext.
					self assert: actual equals: expected].
			self assert: subject atEnd.
			self should: [subject basicNext] raise: subject class endOfStreamSignal.
			self closeTempStream: subject]!

testContents
	self collections do: 
			[:pair |
			| each stream |
			each := pair first.
			stream := self streamWith: each.
			self assert: stream contents equals: each.
			self closeTempStream: stream]!

testEncodedSizeOf
	| subject |
	subject := self streamOn: AnsiString new.
	self assert: (subject encodedSizeOf: $a) equals: 1.
	self assert: (subject encodedSizeOf: $£) equals: 1.
	"Multi-byte characters will be substituted with the replacement character in ANSI streams"
	self assert: (subject encodedSizeOf: Character dolphin) equals: 1.
	self closeTempStream: subject.
	subject := self streamOn: Utf8String new.
	self assert: (subject encodedSizeOf: $a) equals: 1.
	self assert: (subject encodedSizeOf: $£) equals: 2.
	self assert: (subject encodedSizeOf: Character dolphin) equals: 4.
	self closeTempStream: subject.
	self streamClassSupportsUtf16
		ifTrue: 
			[subject := self streamOn: Utf16String new.
			self assert: (subject encodedSizeOf: $a) equals: 1.
			self assert: (subject encodedSizeOf: $£) equals: 1.
			self assert: (subject encodedSizeOf: Character dolphin) equals: 2.
			self closeTempStream: subject]!

testEncoding
	| subject |
	subject := self streamOn: AnsiString empty.
	self assert: subject encoding equals: #ansi.
	self closeTempStream: subject.
	subject := self streamOn: Utf8String empty.
	self assert: subject encoding equals: #utf8.
	self closeTempStream: subject.
	self streamClassSupportsUtf16
		ifTrue: 
			[subject := self streamOn: Utf16String empty.
			self assert: subject encoding equals: #utf16le.
			self closeTempStream: subject].
	subject := self streamOn: #[1].
	self assert: subject encoding equals: #binary.
	self closeTempStream: subject.
	self streamClassSupportsPointers
		ifTrue: 
			[subject := self streamOn: #('abc').
			self assert: subject encoding equals: #pointers.
			self closeTempStream: subject]!

testMarkusKuhnUtf8
	"A kick-the-tyres test that various read operations will not fail on UTF-8 with many
	encoding edge cases and errors. The nature of the data is such that there is not much we can
	assert, although it contains many informally expressed test cases that can be mined to create
	better unit tests."

	| stream testFilePath bytes text |
	testFilePath := FileLocator imageRelative
				localFileSpecFor: 'Core\Object Arts\Dolphin\Tests\UTF8-test.txt'.
	stream := self streamOnFile: testFilePath type: #utf8.
	"Should be able to read every character, even if invalid"
	[stream atEnd] whileFalse: [stream next].
	bytes := File readAllBytes: testFilePath.
	text := Utf16String fromBytes: bytes codePage: OS.NlsConstants.CP_UTF8.
	self assert: stream contents equals: text.
	stream reset.
	self assert: stream upToEnd equals: text.
	self closeTempStream: stream!

testNew
	self should: [self streamClass new] raise: Error!

testNext
	self arrayedCollections do: 
			[:pair |
			| each subject collection |
			each := pair first.
			subject := self streamOn: each.
			collection := pair last.
			1 to: collection size
				do: 
					[:i |
					| expected actual |
					expected := collection at: i.
					actual := subject next.
					self assert: actual equals: expected].
			self assert: subject atEnd.
			self should: [subject next] raise: subject class endOfStreamSignal.
			self closeTempStream: subject]!

testNextAvailable
	self collections do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			subject := self streamOn: each.
			elems := each asArray.
			0 to: elems size
				do: 
					[:i |
					subject reset.
					actual := subject nextAvailable: i.
					expected := elems copyFrom: 1 to: i.
					self assert: actual asArray equals: expected].
			self assert: subject atEnd.
			self assert: (subject nextAvailable) isNil.
			self closeTempStream: subject]!

testNextAvailableColon
	self collections do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			subject := self streamOn: each.
			elems := each asArray.
			0 to: elems size
				do: 
					[:i |
					subject reset.
					actual := subject nextAvailable: i.
					expected := elems copyFrom: 1 to: i.
					self assert: actual asArray equals: expected].
			self assert: subject atEnd.
			self assert: (subject nextAvailable: 1) isEmpty.
			subject reset.
			self assert: (subject nextAvailable: elems size + 1) equals: each.
			self closeTempStream: subject]!

testNextColon
	self collections do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			subject := self streamOn: each.
			elems := each asArray.
			self should: [subject next: elems size + 1] raise: Stream endOfStreamSignal.
			0 to: elems size
				do: 
					[:i |
					subject reset.
					actual := subject next: i.
					expected := elems copyFrom: 1 to: i.
					self assert: actual asArray equals: expected].
			self assert: subject atEnd.
			self should: [subject next: 1] raise: Stream endOfStreamSignal.
			self closeTempStream: subject]!

testNextIllegalUtf8CodePositions
	"Test cases from Kuhn"

	"5 Illegal code positions

	5.1 Single UTF-16 surrogates 

	5.1.1  U+D800 = ed a0 80
	5.1.2  U+DB7F = ed ad bf
	5.1.3  U+DB80 = ed ae 80
	5.1.4  U+DBFF = ed af bf
	5.1.5  U+DC00 = ed b0 80
	5.1.6  U+DF80 = ed be 80
	5.1.7  U+DFFF = ed bf bf"

	self assert: (self verifyNonChars: #('eda080' 'edadbf' 'edae80' 'edafbf' 'edb080' 'edbe80' 'edbfbf')) equals: 7 + 1.

	"5.2 Paired UTF-16 surrogates

	5.2.1  U+D800 U+DC00 = ed a0 80 ed b0 80
	5.2.2  U+D800 U+DFFF = ed a0 80 ed bf bf
	5.2.3  U+DB7F U+DC00 = ed ad bf ed b0 80
	5.2.4  U+DB7F U+DFFF = ed ad bf ed bf bf
	5.2.5  U+DB80 U+DC00 = ed ae 80 ed b0 80
	5.2.6  U+DB80 U+DFFF = ed ae 80 ed bf bf
	5.2.7  U+DBFF U+DC00 = ed af bf ed b0 80
	5.2.8  U+DBFF U+DFFF = ed af bf ed bf bf"
	self assert: (self verifyNonChars:#( 'eda080' 'edb080'  'eda080' 'edbfbf' 'edadbf' 'edb080' 'edadbf' 'edbfbf' 'edae80' 'edb080' 'edae80' 'edbfbf' 'edafbf' 'edb080' 'edafbf' 'edbfbf')) equals: 16 + 1.!

testNextInto
	| stream result endOfStream |
	"Previously-failing tests"
	stream := self streamOn: #[1 2 3].
	result := Array new: 2.
	endOfStream := stream class endOfStreamSignal.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(1 2).
	self closeTempStream: stream.
	stream := self streamOn: #[1 2 3].
	result := Array new: 3.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(1 2 3).
	self closeTempStream: stream.
	stream := self streamOn: #[1 2 3 4 5 6 7 8 9].
	result := Array new: 4.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(1 2 3 4).
	self closeTempStream: stream.
	stream := self streamOn: #[1 2 3 4 5 6 7 8 9].
	result := Array new: 5.
	stream next: 2.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(3 4 5 6 7).
	self closeTempStream: stream.

	"Expected failure"
	stream := self streamOn: #[1 2 3].
	result := Array new: 5.
	self should: [stream nextInto: result] raise: endOfStream.
	self closeTempStream: stream!

testNextLine
	"No line delimiters"

	#('' 'a' 'ab' 'abc') do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextLine equals: each.
			self assert: stream atEnd.
			self closeTempStream: stream].

	"Empty but for a single line delimiter"
	{String with: Character lf. String lineDelimiter} do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextLine equals: ''.
			self assert: stream atEnd.
			self closeTempStream: stream].
	"Finishes with line delimiter"
	{String with: Character lf. String lineDelimiter} do: 
			[:eachDelim |
			#('a' 'ab' 'abc') do: 
					[:each |
					| stream |
					stream := self streamOn: each , eachDelim.
					self assert: stream nextLine equals: each.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	"Finishes with pair of line delimiters"
	{String with: Character lf. String lineDelimiter} do: 
			[:eachDelim |
			#('' 'a' 'ab' 'abc') do: 
					[:each |
					| stream |
					stream := self streamOn: each , eachDelim , eachDelim.
					self assert: stream nextLine equals: each.
					self assert: stream atEnd not.
					"Empty line"
					self assert: stream nextLine equals: ''.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	"Starts with line delimiter, delimiter between lines, two delimiters between lines"
	{String with: Character lf. String lineDelimiter} do: 
			[:eachDelim |
			#('a' 'ab' 'abc') do: 
					[:each |
					| stream |
					stream := self streamOn: eachDelim , each , eachDelim , each , eachDelim , eachDelim , each.
					self assert: stream nextLine equals: ''.
					self deny: stream atEnd.
					self assert: stream nextLine equals: each.
					self deny: stream atEnd.
					self assert: stream nextLine equals: each.
					self deny: stream atEnd.
					self assert: stream nextLine equals: ''.
					self deny: stream atEnd.
					self assert: stream nextLine equals: each.
					self assert: stream atEnd.
					self closeTempStream: stream]].


	"Single CR at end of file"
	#('' 'a' 'ab' 'abc') do: 
			[:each |
			| line chars stream |
			chars := each , (String with: Character cr).
			stream := self streamOn: chars.
			stream reset.
			line := stream nextLine.
			self assert: line equals: each.
			self assert: stream atEnd.
			self closeTempStream: stream]!

testNextLineCrOnly
	"Test PositionableStream>>nextLine for text streams with <CR> between lines"

	#('a' 'ab' 'abc') do: 
			[:each |
			| chars stream |
			chars := each , (String with: Character cr) , each.
			stream := self streamOn: chars.
			stream reset.
			self assert: stream nextLine equals: each.
			self deny: stream atEnd.
			self assert: stream nextLine equals: each.
			self assert: stream atEnd.
			self closeTempStream: stream]!

testNextLongUtf8Encodings
	"UTF-8 can encode values up to 16rFFFFFFF. In practice these are not required since the maximum Unicode code point is U+10FFFF, which requires only 4 bytes to encode, but in theory they could be encountered, and should be treated as invalid characters (i.e. substituted with the replacement character"

	| subject |
	subject := self
				streamOnBytes: #[16rF8 16r88 16r80 16r80 16r80] , Character dolphin asString asByteArray
						, #[16rFB 16rBF 16rBF 16rBF 16rBF] , $£ asUtf8String asByteArray
						, #[16rFC 16r84 16r80 16r80 16r80] , $\x20AC asUtf8String asByteArray
						, #[16rFD 16rBF 16rBF 16rBF 16rBF 16rBF] , $\x4F60 asUtf8String asByteArray
				type: #utf8.
	self assert: subject next equals: Character replacement.
	self assert: subject next equals: Character dolphin.
	self assert: subject next equals: Character replacement.
	self assert: subject next equals: $£.
	self assert: subject next equals: Character replacement.
	self assert: subject next equals: $\x20AC.
	self assert: subject next equals: Character replacement.
	self assert: subject next equals: $\x4F60.
	self closeTempStream: subject!

testNextOtherNonCharactersUtf8
	"Other 'noncharacters' from Kuhn"

	| count |
	"5.3.1  U+FFFE = ef bf be
	5.3.2  U+FFFF = ef bf bf"

	"stdio streams will just consume the U+FFFF, so we might get either 2 or 3 chars read here."
	count := self streamClass == OS.StdioFileStream ifTrue: [2] ifFalse: [3].
	self assert: (self verifyNonChars: #('efbefe' 'efbfbf')) equals: count.

	"5.3.3  U+FDD0 .. U+FDEF"
	self assert: (self
				verifyNonChars: #('efb790' 'efb791' 'efb792' 'efb793' 'efb794' 'efb795' 'efb796' 'efb797' 'efb798' 'efb799' 'efb79a' 'efb79b' 'efb79c' 'efb79d' 'efb79e' 'efb79f' 'efb7a0' 'efb7a1' 'efb7a2' 'efb7a3' 'efb7a4' 'efb7a5' 'efb7a6' 'efb7a7' 'efb7a8' 'efb7a9' 'efb7aa' 'efb7ab' 'efb7ac' 'efb7ad' 'efb7ae' 'efb7af'))
		equals: 32 + 1.
	"5.3.4  U+nFFFE U+nFFFF (for n = 1..10)"
	self assert: (self
				verifyNonChars: #('f09fbfbe' 'f09fbfbf' 'f0afbfbe' 'f0afbfbf' 'f0bfbfbe' 'f0bfbfbf' 'f18fbfbe' 'f18fbfbf' 'f19fbfbe' 'f19fbfbf' 'f1afbfbe' 'f1afbfbf' 'f1bfbfbe' 'f1bfbfbf' 'f28fbfbe' 'f28fbfbf' 'f29fbfbe' 'f29fbfbf' 'f2afbfbe' 'f2afbfbf' 'f2bfbfbe' 'f2bfbfbf' 'f38fbfbe' 'f38fbfbf' 'f39fbfbe' 'f39fbfbf' 'f3afbfbe' 'f3afbfbf' 'f3bfbfbe' 'f3bfbfbf' 'f48fbfbe' 'f48fbfbf'))
		equals: 2 * 16 + 1!

testNextOverlongUtf8
	| subject |
	"4.1 Overlong ASCII character encodings"
	subject := self
				streamOnBytes: #[16rC0 16rAF 95 16rE0 16r80 16rAF 95 16rF0 16r80 16r80 16rAF 95 16rF8 16r80 16r80 16r80 16rAF 95 16rFC 16r80 16r80 16r80 16r80 16rAF 95]
				type: #utf8.
	5 timesRepeat: 
			[self assert: subject next equals: Character replacement.
			self assert: subject next equals: $_].
	self assert: subject atEnd.
	self closeTempStream: subject.

	"4.2 Maximum overlong sequences"
	subject := self
				streamOnBytes: #[16rC1 16rBF 10 16rE0 16r9F 16rBF 10 16rF0 16r8F 16rBF 16rBF 10 16rF8 16r87 16rBF 16rBF 16rBF 10 16rFC 16r83 16rBF 16rBF 16rBF 16rBF 10]
				type: #utf8.
	5 timesRepeat: 
			[self assert: subject next equals: Character replacement.
			self assert: subject next equals: Character lf].
	self closeTempStream: subject.
	"4.3 Overlong representations of NUL"
	subject := self
				streamOnBytes: #[16rC0 16r80 10 16rE0 16r80 16r80 10 16rF0 16r80 16r80 16r80 10 16rF8 16r80 16r80 16r80 16r80 10 16rFC 16r80 16r80 16r80 16r80 16r80 10]
				type: #utf8.
	5 timesRepeat: 
			[self assert: subject next equals: Character replacement.
			self assert: subject next equals: Character lf].
	self closeTempStream: subject!

testNextPut
	self writeableCollections do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			elems := pair last.
			subject := self streamWith: each.
			subject isWriteable
				ifTrue: 
					[elems do: [:e | subject nextPut: e].
					actual := subject contents.
					self assert: subject atEnd.
					self closeTempStream: subject.
					expected := each , each.
					self assert: actual equals: expected]
				ifFalse: [elems size > 0 ifTrue: [self writeOperationNotImplemented: [subject nextPut: elems first]]]]!

testNextWord
	"Single words"

	#('a' 'ab' 'abc') do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextWord equals: each.
			self assert: stream atEnd.
			self assertIsNil: stream nextWord.
			self closeTempStream: stream].
	"Empty of just separators (i.e. no words)"
	#('' ' ' '	' '  ') , {String with: Character lf. String with: Character cr. String lineDelimiter}
		do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assertIsNil: stream nextWord.
			self assert: stream atEnd.
			self closeTempStream: stream].

	"Two words of one or more characters separated by one or more delimiters"
	#('a a' 'a  a' ' a a' 'a a ' ' a a ' '  a  a  ')
		, #('a ab' 'a  ab' ' a ab' 'a ab ' ' a ab ' '  a  ab  ')
			, #('ab a' 'ab  a' ' ab a' 'ab a ' ' ab a ' '  ab  a  ')
			, #('ab ab' 'ab  ab' ' ab ab' 'ab ab ' ' ab ab ' '  ab  ab  ')
			, #('abc abc' 'abc  abc' ' abc abc' 'abc abc ' ' abc abc ' '  abc  abc  ') do: 
				[:each |
				| stream words |
				words := each subStrings.
				stream := self streamOn: each.
				self assert: stream nextWord equals: words first.
				self assert: stream nextWord equals: words second.
				self assertIsNil: stream nextWord.
				self assert: stream atEnd.
				self closeTempStream: stream]!

testPeekFor
	"Test PositionableStream>>peekFor:"

	"Empty stream (initlially at end)"

	| stream |
	stream := self streamOn: ''.
	self deny: (stream peekFor: $a).
	self assert: stream atEnd.
	self closeTempStream: stream.
	"Non-empty stream"
	stream := self streamOn: 'ab'.
	"Not at end but mismatch"
	self deny: (stream peekFor: $b).
	self assert: stream position equals: 0.
	"Successful match"
	self assert: (stream peekFor: $a).
	self assert: stream position equals: 1.
	"Another mismatch"
	self deny: (stream peekFor: $c).
	self assert: stream position equals: 1.
	"Another Successful match"
	self deny: stream atEnd.
	self assert: (stream peekFor: $b).
	self assert: stream atEnd.
	"Now at end"
	self deny: (stream peekFor: $a).
	self assert: stream atEnd.
	self closeTempStream: stream!

testReverseContents
	| stream euro |
	stream := self streamWith: ''.
	self assert: stream reverseContents isEmpty.
	self closeTempStream: stream.
	euro := String with: $1 with: $\x20AC.
	stream := self streamWith: euro.
	self assert: stream reverseContents equals: (String with: $\x20AC with: $1).
	self closeTempStream: stream.
	stream := self streamWith: '¡Hola!!'.
	self assert: stream reverseContents equals: '!!aloH¡'.
	self closeTempStream: stream.
	stream := self streamWith: #[].
	self assert: stream reverseContents isEmpty.
	self closeTempStream: stream.
	stream := self streamWith: #[1 2 3].
	self assert: stream reverseContents equals: #[3 2 1].
	self closeTempStream: stream!

testSkipSeparators
	| chars stream |
	chars := '1 2 	3
4 €£🐬' copyWith: $\f.
	stream := self streamOn: chars.
	stream reset.
	self assert: stream skipSeparators.
	self assert: stream peek equals: $1.
	self assert: stream skipSeparators.
	self assert: stream next equals: $1.
	self assert: stream skipSeparators.
	self assert: stream next equals: $2.
	self assert: stream skipSeparators.
	self assert: stream next equals: $3.
	self assert: stream skipSeparators.
	self assert: stream next equals: $4.
	self assert: stream skipSeparators.
	self assert: stream next equals: $\x20AC.
	self assert: stream skipSeparators.
	self assert: stream next equals: $£.
	self assert: stream skipSeparators.
	self assert: stream next equals: Character dolphin.
	self deny: stream atEnd.
	self deny: stream skipSeparators.
	self assert: stream atEnd.
	self deny: stream skipSeparators.
	self closeTempStream: stream!

testSkipToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	"1 char sequence found at start"
	stream reset.
	self assert: (stream skipToAll: 'a').
	self assert: stream position equals: 1.	"Remember stream position is zero based"

	"1 char sequence found at end"
	stream reset.
	self assert: (stream skipToAll: 'e').
	self assert: stream atEnd.

	"1 char sequence found in middle"
	stream reset.
	self assert: (stream skipToAll: 'c').
	self assert: stream position equals: (chars indexOf: $c).

	"2 char sequence found at start"
	stream reset.
	self assert: (stream skipToAll: 'ab').
	self assert: stream position equals: 3.

	"2 char sequence found at end"
	stream reset.
	self assert: (stream skipToAll: 'de').
	self assert: stream atEnd.

	"2 char sequence found in middle"
	stream reset.
	self assert: (stream skipToAll: 'ca').
	self assert: stream position equals: (chars indexOf: $c) + 1.

	"3 char sequence found at start"
	stream reset.
	self assert: (stream skipToAll: 'aba').
	self assert: stream position equals: 4.

	"3 char sequence found at end"
	stream reset.
	self assert: (stream skipToAll: 'cde').
	self assert: stream atEnd.

	"3 char sequence found in middle"
	stream reset.
	self assert: (stream skipToAll: 'cab').
	self assert: stream position equals: (chars indexOf: $c) + 2.

	"1 char, not found"
	stream reset.
	self assert: (stream skipToAll: 'f') not.
	self assert: stream atEnd.

	"2 chars, both not found"
	stream reset.
	self assert: (stream skipToAll: 'gh') not.
	self assert: stream atEnd.

	"2 chars, second not found, first at start"
	stream reset.
	self assert: (stream skipToAll: 'ah') not.
	self assert: stream atEnd.

	"2 chars, second not found, first middle"
	stream reset.
	self assert: (stream skipToAll: 'ch') not.
	self assert: stream atEnd.

	"2 chars, second not found, first end"
	stream reset.
	self assert: (stream skipToAll: 'eh') not.
	self assert: stream atEnd.

	"3 chars, first not found"
	stream reset.
	self assert: (stream skipToAll: 'fab') not.
	self assert: stream atEnd.

	"3 chars, second not found at all"
	stream reset.
	self assert: (stream skipToAll: 'cfb') not.
	self assert: stream atEnd.

	"3 chars, last not found at all"
	stream reset.
	self assert: (stream skipToAll: 'abf') not.
	self assert: stream atEnd.
	self closeTempStream: stream!

testUpTo
	self collections do: 
			[:pair |
			| each subject elems |
			each := pair first.
			elems := pair last.
			subject := self streamWith: each.
			subject reset.
			self assert: (subject upTo: Object new) equals: each.
			self assert: subject atEnd.
			elems do: 
					[:target |
					| actual expected |
					subject reset.
					expected := elems copyFrom: 1 to: (elems indexOf: target) - 1.
					actual := subject upTo: target.
					self assert: actual asArray equals: expected].
			self closeTempStream: subject]!

testUpToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	"1 char sequence found at start"
	stream reset.
	self assert: (stream upToAll: 'a') equals: ''.
	self assert: stream position equals: 1.	"Remember stream position is zero based"

	"1 char sequence found at end"
	stream reset.
	self assert: (stream upToAll: 'e') equals: 'aababcabcdabcd'.
	self assert: stream atEnd.

	"1 char sequence found in middle"
	stream reset.
	self assert: (stream upToAll: 'c') equals: 'aabab'.
	self assert: stream position equals: (chars indexOf: $c).

	"2 char sequence found at start"
	stream reset.
	self assert: (stream upToAll: 'ab') equals: 'a'.
	self assert: stream position equals: 3.

	"2 char sequence found at end"
	stream reset.
	self assert: (stream upToAll: 'de') equals: 'aababcabcdabc'.
	self assert: stream atEnd.

	"2 char sequence found in middle"
	stream reset.
	self assert: (stream upToAll: 'ca') equals: 'aabab'.
	self assert: stream position equals: (chars indexOf: $c) + 1.

	"3 char sequence found at start"
	stream reset.
	self assert: (stream upToAll: 'aba') equals: 'a'.
	self assert: stream position equals: 4.

	"3 char sequence found at end"
	stream reset.
	self assert: (stream upToAll: 'cde') equals: 'aababcabcdab'.
	self assert: stream atEnd.

	"3 char sequence found in middle"
	stream reset.
	self assert: (stream upToAll: 'cab') equals: 'aabab'.
	self assert: stream position equals: (chars indexOf: $c) + 2.

	"1 char, not found"
	stream reset.
	self assert: (stream upToAll: 'f') equals: chars.
	self assert: stream atEnd.

	"2 chars, both not found"
	stream reset.
	self assert: (stream upToAll: 'gh') equals: chars.
	self assert: stream atEnd.

	"2 chars, second not found, first at start"
	stream reset.
	self assert: (stream upToAll: 'ah') equals: chars.
	self assert: stream atEnd.

	"2 chars, second not found, first middle"
	stream reset.
	self assert: (stream upToAll: 'ch') equals: chars.
	self assert: stream atEnd.

	"2 chars, second not found, first end"
	stream reset.
	self assert: (stream upToAll: 'eh') equals: chars.
	self assert: stream atEnd.

	"3 chars, first not found"
	stream reset.
	self assert: (stream upToAll: 'fab') equals: chars.
	self assert: stream atEnd.

	"3 chars, second not found at all"
	stream reset.
	self assert: (stream upToAll: 'cfb') equals: chars.
	self assert: stream atEnd.

	"3 chars, last not found at all"
	stream reset.
	self assert: (stream upToAll: 'abf') equals: chars.
	self assert: stream atEnd.
	self closeTempStream: stream!

testUpToEnd
	self collections do: 
			[:pair |
			| each subject elems |
			each := pair first.
			elems := pair last.
			subject := self streamWith: each.
			subject reset.
			self assert: subject upToEnd equals: each.
			self assert: subject atEnd.
			2 to: elems size
				do: 
					[:i |
					| actual expected |
					subject reset.
					i timesRepeat: [subject next].
					i < elems size ifTrue: [self deny: subject atEnd].
					expected := elems copyFrom: i + 1.
					actual := subject upToEnd.
					self assert: actual asArray equals: expected].
			self closeTempStream: subject]!

testUpToUtf
	| pound capitalAwithCircumflex |
	pound := Character value: 16rA3.
	"A-with-circumflex is also the lead byte for pound in UTF-8"
	capitalAwithCircumflex := Character value: 16rC2.
	{AnsiString. Utf8String} do: 
			[:stringClass |
			| chars stream actual |
			chars := (stringClass with: capitalAwithCircumflex) , (stringClass fromString: 'bcde')
						, (stringClass with: pound) , (stringClass fromString: 'ghij').
			self assert: chars class equals: stringClass.
			stream := self streamOn: chars.
			actual := stream upToEnd.
			self assert: actual equals: chars.
			"Search for a potentially multi-byte char at the start"
			stream reset.
			self assert: (stream upTo: capitalAwithCircumflex) equals: ''.
			"Search for a single-byte char"
			self assert: (stream upTo: $c) equals: 'b'.
			"Search for another multi-byte char after the start"
			self assert: (stream upTo: pound) equals: 'de'.
			"Search for a non-existant char"
			self assert: (stream upTo: $z) equals: 'ghij'.
			self assert: stream atEnd.
			self assert: (stream upTo: $z) equals: ''.
			stream reset.
			"Search for what would be lead byte of pound"
			stream next.
			self assert: (stream upTo: capitalAwithCircumflex) equals: chars asAnsiString allButFirst.
			"Search terminating on last character"
			stream reset.
			self assert: (stream upTo: $j) equals: chars allButLast.
			self assert: stream atEnd.
			"Search for non-existant character"
			stream reset.
			self assert: (stream upTo: $z) equals: chars.
			self assert: stream atEnd.
			self closeTempStream: stream]	"Utf8String. Utf16String"!

verifyNonChars: anArray
	| sep stream count bytes |
	sep := (ByteArray with: $a codePoint) asHexString.
	bytes := ByteArray
				fromHexString: (String streamContents: 
							[:s |
							s nextPutAll: sep.
							anArray do: 
									[:each |
									s
										nextPutAll: each;
										nextPutAll: sep]]).
	stream := self streamOnBytes: bytes type: #utf8.
	self deny: stream atEnd.
	count := 0.
	[stream atEnd] whileFalse: 
			[| ch |
			ch := stream next.
			ch == $a ifTrue: [count := count + 1] ifFalse: [self assert: ch equals: Character replacement]].
	self closeTempStream: stream.
	^count!

writeableCollections
	^self strings , self byteArrays , self arrays , self orderedCollections!

writeOperationNotImplemented: aBlock 
	"It is an error to attempt to write to a ReadStream"

	self 
		should: aBlock
		raise: Error
		matching: [:ex | ex description = 'The stream is not writeable']! !
!Core.Tests.PositionableStreamTest categoriesFor: #arrayedCollections!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #arrays!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #byteArrays!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #collections!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #intervals!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #newStream!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #orderedCollections!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #readOperationNotImplemented:!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #runArrays!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #streamClassSupportsPointers!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #streamClassSupportsUtf16!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #streamOn:!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #streamOnBytes:type:!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #streamOnFile:type:!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #streamWith:!helpers!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #strings!constants!private! !
!Core.Tests.PositionableStreamTest categoriesFor: #subjectCollection:!public! !
!Core.Tests.PositionableStreamTest categoriesFor: #testBasicNext!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testContents!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testEncodedSizeOf!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testEncoding!gettableStream only!public!strict utf8!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testMarkusKuhnUtf8!gettableStream only!public! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNew!public!testing! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNext!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextAvailable!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextAvailableColon!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextColon!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextIllegalUtf8CodePositions!gettableStream only!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextInto!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextLine!gettableStream only!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextLineCrOnly!gettableStream only!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextLongUtf8Encodings!gettableStream only!public!strict utf8!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextOtherNonCharactersUtf8!gettableStream only!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextOverlongUtf8!gettableStream only!public!strict utf8!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextPut!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testNextWord!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testPeekFor!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testReverseContents!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testSkipSeparators!gettableStream only!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testSkipToAllColon!gettableStream only!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testUpTo!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testUpToEnd!public!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #testUpToUtf!gettableStream only!public! !
!Core.Tests.PositionableStreamTest categoriesFor: #verifyNonChars:!public! !
!Core.Tests.PositionableStreamTest categoriesFor: #writeableCollections!private!unit tests! !
!Core.Tests.PositionableStreamTest categoriesFor: #writeOperationNotImplemented:!private!unit tests! !

