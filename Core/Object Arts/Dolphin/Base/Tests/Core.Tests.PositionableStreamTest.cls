"Filed out from Dolphin Smalltalk"!

Core.Tests.StreamTest
	subclass: #'Core.Tests.PositionableStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.PositionableStreamTest guid: (Core.GUID fromString: '{3abcc3a3-be2b-417d-bdb7-cf6a64cc2c6b}')!

Core.Tests.PositionableStreamTest isNonInstantiable: true!

Core.Tests.PositionableStreamTest comment: ''!

!Core.Tests.PositionableStreamTest methodsFor!

arrayedCollections
	^self strings, self byteArrays, self arrays!

arrays
	^#(#(#()) #(#(#x)) #(#(#x #y)))!

assert: aPositionableStream absolutePositionEquals: anInteger
	self assert: aPositionableStream absolutePosition equals: anInteger!

assert: aPositionableStream bufferPositionEquals: anInteger
	self assert: aPositionableStream bufferPosition equals: anInteger!

assertBufferDirty: subject
	self assert: subject isBufferDirty!

assertStream: subject hasPosition: anInteger
	(subject class conformsToProtocol: #positionableStream)
		ifTrue: [self assert: subject position equals: anInteger]!

bufferClasses
	^##(IdentityDictionary withAll: {
				#utf8 -> Utf8String.
				#utf16 -> Utf16String.
				#ansi -> AnsiString.
				#text -> Utf8String.
				#pointers -> Array
			})!

bufferSizeOfStream: subject
	^subject collection size!

byteArrays
	^#(#(#[] #()) #(#[1] #(1)) #(#[1 255] #(1 255)))!

collections
	^self strings , self byteArrays , self arrays, self intervals , self orderedCollections, self runArrays!

expectedAnsiProtocolNames
	^#(#collectionStream #Object #sequencedStream)!

intervals
	^{{1 to: 0. #()}. {2 to: 2. #(2)}. {1 to: 5. #(1 2 3 4 5)}. {3 to: 1 by: -1. #(3 2 1)}}!

newStream: aSymbol
	^self streamClass on: (PositionableStream.ByteBufferClasses at: aSymbol) new!

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

streamClassSupportsUtf8Surrogates
	^true!

streamedContents: aStream
	^aStream contents!

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
	| strings |
	strings := {
				#('' #()).
				{ Utf8String empty. #() }.
				#('a' #($a)).
				#('abc' #($a $b $c)).
				{ '£€1' asAnsiString. #($£ $\x20AC $1) }.
				{ 'a£€1' asUtf8String. #($a $£ $\x20AC $1) }.
				{ Character byteCharacterSet. Character byteCharacterSet asArray }.
				{ 'a' , Character dolphin asUtf8String , '文'. #($a $\x1F42C $\x6587) }
			}.
	^self streamClassSupportsUtf16
		ifTrue: 
			[strings , {
						{ Utf16String empty. #() }.
						{ 'a' , Character dolphin asUtf16String , '文'. #($a $\x1F42C $\x6587) }
					}]
		ifFalse: [strings]!

subjectCollection: aSequenceableCollection
	^aSequenceableCollection!

tempReadStream
	^self tempReadStream: #text!

tempReadStream: aSymbol
	"Only applicable for tests of readable streams"

	self streamOn: (self newStream: aSymbol)!

tempWriteStream
	"Private - Answer a writeable FileStream on a temporary file."

	^self tempWriteStream: #text!

tempWriteStream: aSymbol
	"Only applicable for write steam test subclasses"

	^self newStream: aSymbol!

test1065
	<mustConform: #writeFileStream>
	| filename |
	#(0 1 512 4095 4096 8191 8192 8193 16383 16384 16385) do: 
			[:size |
			| data written subject |
			data := WriteStream on: (ByteArray new: size).
			size timesRepeat: [data nextPut: (OS.Ucrt rand bitAnd: 255)].
			data := data grabContents.
			subject := self tempWriteStream: #binary.
			subject
				next: data size
				putAll: data
				startingAt: 1.
			filename := subject name.
			subject close.
			written := File readAllBytes: filename.
			self assert: data equals: written]!

testAppend
	<mustConform: #writeFileStream>
	| actual padding filename subject |
	subject := self tempWriteStream.
	padding := String new: (self bufferSizeOfStream: subject) - $\xFEFF utf8Length - 1 withAll: $\x20.
	subject
		nextPutAll: padding;
		nextPut: Character dolphin.
	filename := subject name.
	subject close.
	subject := self streamClass
				write: filename
				mode: #append
				check: false
				type: #utf8.
	[subject nextPutAll: ' says hello'] ensure: [subject close].
	actual := File readAllText: filename.
	self assert: (actual beginsWith: padding).
	self assert: (actual copyFrom: padding size + 1)
		equals: Character dolphin asUtf8String , ' says hello'!

testBasicNext
	<mustConform: #gettableStream>
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
			self should: [subject basicNext] raise: subject class endOfStreamSignal]!

testContents
	<mustConform: #sequencedStream>
	self collections do: 
			[:pair |
			| each stream |
			each := pair first.
			stream := self streamWith: each.
			self assert: stream contents equals: each]!

testEncodedSizeOf
	| subject |
	subject := self streamOn: AnsiString new.
	self assert: (subject encodedSizeOf: $a) equals: 1.
	self assert: (subject encodedSizeOf: $£) equals: 1.
	"Multi-byte characters will be substituted with the replacement character in ANSI streams"
	self assert: (subject encodedSizeOf: Character dolphin) equals: 1.
	subject := self streamOn: Utf8String new.
	self assert: (subject encodedSizeOf: $a) equals: 1.
	self assert: (subject encodedSizeOf: $£) equals: 2.
	self assert: (subject encodedSizeOf: Character dolphin) equals: 4.
	self streamClassSupportsUtf16
		ifTrue: 
			[subject := self streamOn: Utf16String new.
			self assert: (subject encodedSizeOf: $a) equals: 1.
			self assert: (subject encodedSizeOf: $£) equals: 1.
			self assert: (subject encodedSizeOf: Character dolphin) equals: 2]!

testEncoding
	<mustConform: #gettableStream>

	| subject |
	subject := self streamOn: AnsiString empty.
	self assert: subject encoding equals: #ansi.
	subject := self streamOn: Utf8String empty.
	self assert: subject encoding equals: #utf8.
	self streamClassSupportsUtf16
		ifTrue: 
			[subject := self streamOn: Utf16String empty.
			self assert: subject encoding equals: #utf16le].
	subject := self streamOn: #[1].
	self assert: subject encoding equals: #binary.
	self streamClassSupportsPointers
		ifTrue: 
			[subject := self streamOn: #('abc').
			self assert: subject encoding equals: #pointers]!

testMarkusKuhnUtf8
	"Tests the decoding of UTF-8 while streaming over test data that contains most possible error and boundary cases"
	<mustConform: #gettableStream>

	| subject testFilePath bytes utf16 utf8 |
	testFilePath := FileLocator imageRelative
				localFileSpecFor: 'Core\Object Arts\Dolphin\Tests\UTF8-test.txt'.
	subject := self streamOnFile: testFilePath type: #utf8.
	"Should be able to read every character, even if invalid"
	[subject atEnd] whileFalse: [subject next].
	bytes := File readAllBytes: testFilePath.
	utf8 := Utf8String fromByteArray: bytes.
	utf16 := Utf16String fromBytes: bytes codePage: OS.NlsConstants.CP_UTF8.
	self assert: subject contents equals: utf8.
	subject reset.
	self assert: subject upToEnd equals: utf16!

testNew
	self should: [self streamClass new] raise: Error!

testNewContents
	<mustConform: #puttableStream>
	| stream contents |
	stream := self streamWith: String new.
	self assert: (self streamedContents: stream) isEmpty.
	stream nextPut: $h.
	self assert: (self streamedContents: stream) equals: 'h'.
	stream := self streamWith: 'hel'.
	stream nextPutAll: 'lo'.
	contents := self streamedContents: stream.
	self assert: contents equals: 'hello'!

testNext
	<mustConform: #gettableStream>
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
			self should: [subject next] raise: subject class endOfStreamSignal]!

testNextAvailable
	<mustConform: #gettableStream>
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
			self assert: (subject nextAvailable) isNil]!

testNextAvailableColon
	<mustConform: #gettableStream>
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
			self assert: (subject nextAvailable: elems size + 1) equals: each]!

testNextColon
	<mustConform: #gettableStream>
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
			self should: [subject next: 1] raise: Stream endOfStreamSignal]!

testNextColonPutColon
	<mustConform: #puttableStream>
	| stream |
	stream := self tempWriteStream: #text.
	stream next: 0 put: $a.
	self assert: (self streamedContents: stream) equals: ''.
	stream next: 1 put: $a.
	self assert: (self streamedContents: stream) equals: 'a'.
	stream next: 2 put: $b.
	self assert: (self streamedContents: stream) equals: 'abb'!

testNextIllegalUtf8CodePositions
	"Test cases from Kuhn"
	<mustConform: #gettableStream>

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
	<mustConform: #gettableStream>
	| stream result endOfStream |
	"Previously-failing tests"
	stream := self streamOn: #[1 2 3].
	result := Array new: 2.
	endOfStream := stream class endOfStreamSignal.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(1 2).
	stream := self streamOn: #[1 2 3].
	result := Array new: 3.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(1 2 3).
	stream := self streamOn: #[1 2 3 4 5 6 7 8 9].
	result := Array new: 4.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(1 2 3 4).
	stream := self streamOn: #[1 2 3 4 5 6 7 8 9].
	result := Array new: 5.
	stream next: 2.
	self shouldnt: [stream nextInto: result] raise: endOfStream.
	self assert: result equals: #(3 4 5 6 7).

	"Expected failure"
	stream := self streamOn: #[1 2 3].
	result := Array new: 5.
	self should: [stream nextInto: result] raise: endOfStream!

testNextLine
	<mustConform: #gettableStream>

	"No line delimiters"
	#('' 'a' 'ab' 'abc') do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextLine equals: each.
			self assert: stream atEnd].

	"Empty but for a single line delimiter"
	{String with: Character lf. String lineDelimiter} do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextLine equals: ''.
			self assert: stream atEnd].
	"Finishes with line delimiter"
	{String with: Character lf. String lineDelimiter} do: 
			[:eachDelim |
			#('a' 'ab' 'abc') do: 
					[:each |
					| stream |
					stream := self streamOn: each , eachDelim.
					self assert: stream nextLine equals: each.
					self assert: stream atEnd]].
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
					self assert: stream atEnd]].
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
					self assert: stream atEnd]].


	"Single CR at end of file"
	#('' 'a' 'ab' 'abc') do: 
			[:each |
			| line chars stream |
			chars := each , (String with: Character cr).
			stream := self streamOn: chars.
			stream reset.
			line := stream nextLine.
			self assert: line equals: each.
			self assert: stream atEnd]!

testNextLineCrOnly
	"Test PositionableStream>>nextLine for text streams with <CR> between lines"
	<mustConform: #gettableStream>

	#('a' 'ab' 'abc') do: 
			[:each |
			| chars stream |
			chars := each , (String with: Character cr) , each.
			stream := self streamOn: chars.
			stream reset.
			self assert: stream nextLine equals: each.
			self deny: stream atEnd.
			self assert: stream nextLine equals: each.
			self assert: stream atEnd]!

testNextLongUtf8Encodings
	"UTF-8 can encode values up to 16rFFFFFFF. In practice these are not required since the maximum Unicode code point is U+10FFFF, which requires only 4 bytes to encode, but in theory they could be encountered, and should be treated as invalid characters (i.e. substituted with the replacement character"
	<mustConform: #gettableStream>

	| subject |
	subject := self
				streamOnBytes: #[16rF8 16r88 16r80 16r80 16r80] , Character dolphin asString asByteArray
						, #[16rFB 16rBF 16rBF 16rBF 16rBF] , $£ asUtf8String asByteArray
						, #[16rFC 16r84 16r80 16r80 16r80] , $\x20AC asUtf8String asByteArray
						, #[16rFD 16rBF 16rBF 16rBF 16rBF 16rBF] , $\x4F60 asUtf8String asByteArray
				type: #utf8.
	5 timesRepeat: [self assert: subject next equals: Character replacement].
	self assert: subject next equals: Character dolphin.
	5 timesRepeat: [self assert: subject next equals: Character replacement].
	self assert: subject next equals: $£.
	5 timesRepeat: [self assert: subject next equals: Character replacement].
	self assert: subject next equals: $\x20AC.
	6 timesRepeat: [self assert: subject next equals: Character replacement].
	self assert: subject next equals: $\x4F60!

testNextOtherNonCharactersUtf16
	"Other 'noncharacters' from Kuhn"
	<mustConform: #gettableStream>

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

testNextOtherNonCharactersUtf8
	"Other 'noncharacters' from Kuhn"
	<mustConform: #gettableStream>

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
	<mustConform: #gettableStream>

	| subject |
	"4.1 Overlong ASCII character encodings"
	subject := self
				streamOnBytes: #[16rC0 16rAF 95 16rE0 16r80 16rAF 95 16rF0 16r80 16r80 16rAF 95 16rF8 16r80 16r80 16r80 16rAF 95 16rFC 16r80 16r80 16r80 16r80 16rAF 95]
				type: #utf8.
	2 to: 6
		do: 
			[:i |
			i timesRepeat: [self assert: subject next equals: Character replacement].
			self assert: subject next equals: $_].
	self assert: subject atEnd.

	"4.2 Maximum overlong sequences"
	subject := self
				streamOnBytes: #[16rC1 16rBF 10 16rE0 16r9F 16rBF 10 16rF0 16r8F 16rBF 16rBF 10 16rF8 16r87 16rBF 16rBF 16rBF 10 16rFC 16r83 16rBF 16rBF 16rBF 16rBF 10]
				type: #utf8.
	2 to: 6
		do: 
			[:i |
			i timesRepeat: [self assert: subject next equals: Character replacement].
			self assert: subject next equals: Character lf].

	"4.3 Overlong representations of NUL"
	subject := self
				streamOnBytes: #[16rC0 16r80 10 16rE0 16r80 16r80 10 16rF0 16r80 16r80 16r80 10 16rF8 16r80 16r80 16r80 16r80 10 16rFC 16r80 16r80 16r80 16r80 16r80 10]
				type: #utf8.
	2 to: 6
		do: 
			[:i |
			i timesRepeat: [self assert: subject next equals: Character replacement].
			self assert: subject next equals: Character lf]!

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
					actual := self streamedContents: subject.
					self assert: subject atEnd.
					expected := each , each.
					self assert: actual equals: expected]
				ifFalse: [elems size > 0 ifTrue: [self writeOperationNotImplemented: [subject nextPut: elems first]]]]!

testNextPutAll
	<mustConform: #writeFileStream>
	| string written actual offset bufferSize subject filename |
	subject := self tempWriteStream.
	written := ''.
	offset := $\xFEFF utf8Length.
	self assertStream: subject hasPosition: 0.
	self assert: subject bufferPositionEquals: offset.
	self assert: subject absolutePositionEquals: offset.
	"Write nothing"
	subject nextPutAll: ''.
	self assertStream: subject hasPosition: 0.
	self assert: subject bufferPositionEquals: offset.
	self assert: subject absolutePositionEquals: offset.
	"Write one byte"
	subject nextPutAll: 'X'.
	written := 'X'.
	self assertStream: subject hasPosition: 1.
	self assert: subject bufferPositionEquals: offset + 1.
	self assert: subject absolutePositionEquals: offset + 1.
	"Fill the first page up to the penultimate byte"
	bufferSize := self bufferSizeOfStream: subject.
	string := String new: bufferSize - offset - 2 withAll: $X.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize - 1.
	self assert: subject absolutePositionEquals: bufferSize - 1.
	self assertStream: subject hasPosition: bufferSize - 1 - offset.
	self assertBufferDirty: subject.
	"Fill the last byte - page full, but not written yet"
	string := 'Z'.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize.
	self assert: subject absolutePositionEquals: bufferSize.
	self assertStream: subject hasPosition: bufferSize - offset.
	self assertBufferDirty: subject.
	"Write another byte to overflow into next page"
	string := 'A'.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: 1.
	self assert: subject absolutePositionEquals: bufferSize + 1.
	self assertStream: subject hasPosition: bufferSize + 1 - offset.
	self assertBufferDirty: subject.
	"Fill the 2nd page up to the last byte"
	string := String new: bufferSize - 2 withAll: $X.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize - 1.
	self assert: subject absolutePositionEquals: bufferSize * 2 - 1.
	self assertStream: subject hasPosition: bufferSize * 2 - 1 - offset.
	self assertBufferDirty: subject.
	"Write a two byte char causing overflow to next page"
	string := '£'.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: 1.
	self assert: subject absolutePositionEquals: bufferSize * 2 + 1.
	self assertStream: subject hasPosition: bufferSize * 2 + 1 - offset.
	self assertBufferDirty: subject.
	"Fill the 3nd page up to the 2nd to last byte"
	string := String new: bufferSize - 3 withAll: $X.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize - 2.
	self assert: subject absolutePositionEquals: bufferSize * 3 - 2.
	self assertStream: subject hasPosition: bufferSize * 3 - 2 - offset.
	self assertBufferDirty: subject.
	"Write a three byte char causing 1-byte overflow to next page"
	string := '€'.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: 1.
	self assert: subject absolutePositionEquals: bufferSize * 3 + 1.
	self assertStream: subject hasPosition: bufferSize * 3 + 1 - offset.
	self assertBufferDirty: subject.
	"Fill the 4th page up to the 2nd to last byte"
	string := String new: bufferSize - 3 withAll: $X.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize - 2.
	self assert: subject absolutePositionEquals: bufferSize * 4 - 2.
	self assertStream: subject hasPosition: bufferSize * 4 - 2 - offset.
	self assertBufferDirty: subject.
	"Write a four byte char causing 2-byte overflow to next page"
	string := '𐀀'.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: 2.
	self assert: subject absolutePositionEquals: bufferSize * 4 + 2.
	self assertStream: subject hasPosition: bufferSize * 4 + 2 - offset.
	self assertBufferDirty: subject.
	"Fill the 5th page up to allow enough space for a 4-byte char"
	string := String new: bufferSize - 6 withAll: $X.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize - 4.
	self assert: subject absolutePositionEquals: bufferSize * 5 - 4.
	self assertStream: subject hasPosition: bufferSize * 5 - 4 - offset.
	self assertBufferDirty: subject.
	"Write a four byte char to just fill the page"
	string := '🐬'.
	subject nextPutAll: string.
	written := written , string.
	self assert: subject bufferPositionEquals: bufferSize.
	self assert: subject absolutePositionEquals: bufferSize * 5.
	self assertStream: subject hasPosition: bufferSize * 5 - offset.
	self assertBufferDirty: subject.

	"Final sanity check that we actually wrote what we expected"
	filename := subject name.
	subject close.
	actual := File readAllText: filename.
	self assert: actual equals: written!

testNextPutAllArray
	<mustConform: #collectionStream>
	<mustConform: #puttableStream>
	<mustNotConform: #FileStream>
	| subject array |
	subject := self streamOn: Array new.
	array := #(10 20 30 40 50).
	subject nextPutAll: array.
	self assert: (self streamedContents: subject) equals: array!

testNextPutAllStartingAtAnsiToUtf8
	<mustConform: #puttableStream>
	| subject data preamble |
	subject := self tempWriteStream: #utf8.
	preamble := AnsiString new: ((self bufferSizeOfStream: subject) - 7 max: 0) withAll: $#.
	subject nextPutAll: preamble.
	data := 'ab£cd€e' asAnsiString.
	self assert: data size equals: 7.
	subject
		next: 2
		putAll: data
		startingAt: 2.
	self assertStream: subject hasPosition: preamble size + 3.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 3).
	"Write more data, but still not overflowing the buffer"
	subject
		next: 1
		putAll: data
		startingAt: 4.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 4).
	self assertStream: subject hasPosition: preamble size + 4.
	"Cause overflow"
	subject
		next: 2
		putAll: data
		startingAt: 5.
	self assertStream: subject hasPosition: preamble size + 8.
	self assert: (self streamedContents: subject) equals: preamble , 'b£cd€'!

testNextPutAllStartingAtBytes
	<mustConform: #puttableStream>
	| subject data preamble |
	subject := self tempWriteStream: #binary.
	preamble := ByteArray new: ((self bufferSizeOfStream: subject) - 4 max: 0) withAll: 35.
	subject nextPutAll: preamble.
	data := #[1 2 3 4 5 6].
	subject
		next: 3
		putAll: data
		startingAt: 2.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 4).
	"Write more data, but still not overflowing the buffer"
	subject
		next: 1
		putAll: data
		startingAt: 5.
	self assert: (self streamedContents: subject) equals: preamble , #[2 3 4 5].
	self assertStream: subject hasPosition: preamble size + 4.
	"Write one byte causing buffer overflow"
	subject
		next: 1
		putAll: data
		startingAt: 6.
	self assert: (self streamedContents: subject) equals: preamble , #[2 3 4 5 6]!

testNextPutAllStartingAtUtf16ToBytes
	<mustConform: #puttableStream>
	| subject data preamble |
	subject := self tempWriteStream: #binary.
	preamble := Utf16String new: ((self bufferSizeOfStream: subject) - 6 max: 0) withAll: $#.
	subject nextPutAll: preamble.
	data := 'ab🐬£c' asUtf16String.
	self assert: data size equals: 6.
	"Since we are writing bytes, we just copy across the UTF-16 encoding, so we can stop in the middle of a character"
	subject
		next: 2
		putAll: data
		startingAt: 2.
	self assert: (self streamedContents: subject)
		equals: preamble asByteArray , (data asByteArray copyFrom: 3 to: 6).
	"Write more data, but still not overflowing the buffer - adds the trail surrogate to complete the dolphin code point"
	subject
		next: 1
		putAll: data
		startingAt: 4.
	self assert: (self streamedContents: subject)
		equals: preamble asByteArray , (data asByteArray copyFrom: 3 to: 8).
	self assertStream: subject hasPosition: preamble size * 2 + 6.
	"Cause overflow"
	subject
		next: 2
		putAll: data
		startingAt: 5.
	self assert: (self streamedContents: subject) asUtf16String equals: preamble , 'b🐬£c'!

testNextPutAllStartingAtUtf16ToUtf8
	"When writing UTF-16 to UTF-8 we can only write complete characters, so must start on the first or only code unit of a code point, and end on the last or only code unit of a code point."

	<mustConform: #puttableStream>
	| subject data preamble |
	subject := self tempWriteStream: #utf8.
	preamble := Utf16String new: ((self bufferSizeOfStream: subject) - 7 max: 0) withAll: $#.
	subject nextPutAll: preamble.
	data := 'ab🐬£c' asUtf16String.
	self assert: data size equals: 6.
	subject
		next: 3
		putAll: data
		startingAt: 2.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 4).
	"Write more data, but still not overflowing the buffer"
	subject
		next: 1
		putAll: data
		startingAt: 5.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 5).
	self assertStream: subject hasPosition: 7 + preamble size.
	"Cause overflow"
	subject
		next: 1
		putAll: data
		startingAt: 1.
	self assert: (self streamedContents: subject) equals: preamble , 'b🐬£a'!

testNextPutAllStartingAtUtf16ToUtf8InvalidCount
	"There is no UTF-8 encoding for UTF-16 surrogates, so we can't end on the lead surrogate of a code point outside the BMP that requires two UTF-16 code points (e.g. emoji)"

	<mustConform: #puttableStream>
	| subject |
	subject := self tempWriteStream: #utf8.
	self
		should: 
			[subject
				next: 2
				putAll: 'a🐬b' asUtf16String
				startingAt: 1]
		raise: InvalidArgumentError
		matching: [:ex | ex tag = 'countInteger']!

testNextPutAllStartingAtUtf16ToUtf8InvalidStart
	"There is no UTF-8 encoding for UTF-16 surrogates, so we can't start on the trailing surrogate of a code point outside the BMP that requires two UTF-16 code points (e.g. emoji)"

	<mustConform: #puttableStream>
	| subject |
	subject := self tempWriteStream: #utf8.
	self
		should: 
			[subject
				next: 2
				putAll: 'a🐬b' asUtf16String
				startingAt: 3]
		raise: InvalidArgumentError
		matching: [:ex | ex tag = 'fromInteger']!

testNextPutAllStartingAtUtf8ToBytes
	<mustConform: #puttableStream>
	| subject data preamble |
	subject := self tempWriteStream: #binary.
	preamble := Utf8String new: ((self bufferSizeOfStream: subject) - 4 max: 0) withAll: $#.
	subject nextPutAll: preamble.
	data := 'ab🐬c' asUtf8String.
	self assert: data size equals: 7.
	subject
		next: 3
		putAll: data
		startingAt: 2.
	self assert: (self streamedContents: subject)
		equals: preamble asByteArray , (data asByteArray copyFrom: 2 to: 4).
	"Write more data, but still not overflowing the buffer"
	subject
		next: 1
		putAll: data
		startingAt: 5.
	self assert: (self streamedContents: subject)
		equals: preamble asByteArray , (data asByteArray copyFrom: 2 to: 5).
	self assertStream: subject hasPosition: preamble size + 4.
	"Cause overflow"
	subject
		next: 2
		putAll: data
		startingAt: 6.
	self assert: (self streamedContents: subject) asUtf8String equals: preamble , 'b🐬c'!

testNextPutAllStartingAtUtf8ToUtf16
	<mustConform: #puttableStream>
	<skipUnless: #streamClassSupportsUtf16>
	| subject data preamble |
	subject := self tempWriteStream: #utf16le.
	preamble := Utf8String new: ((self bufferSizeOfStream: subject) - 4 max: 0) withAll: $#.
	subject nextPutAll: preamble.
	data := 'ab🐬c' asUtf8String.
	self assert: data size equals: 7.
	subject
		next: 5
		putAll: data
		startingAt: 2.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 6).
	self assertStream: subject hasPosition: preamble size + 3.
	"Write more data, but still not overflowing the buffer"
	subject
		next: 1
		putAll: data
		startingAt: 7.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 7).
	self assertStream: subject hasPosition: preamble size + 4.
	"Cause overflow"
	subject
		next: 2
		putAll: data
		startingAt: 1.
	self assertStream: subject hasPosition: preamble size + 6.
	self assert: (self streamedContents: subject) equals: preamble , 'b🐬cab'!

testNextPutAllStartingAtUtf8ToUtf8
	<mustConform: #puttableStream>
	<skipUnless: #streamClassSupportsUtf8Surrogates>
	| subject data preamble expectedContent |
	subject := self tempWriteStream: #utf8.
	preamble := Utf8String new: ((self bufferSizeOfStream: subject) - 4 max: 0) withAll: $#.
	subject nextPutAll: preamble.
	data := 'ab🐬c' asUtf8String.
	self assert: data size equals: 7.
	subject
		next: 3
		putAll: data
		startingAt: 2.
	self assert: (self streamedContents: subject) equals: preamble , (data copyFrom: 2 to: 4).

	"Write more data, but still not overflowing the buffer"
	subject
		next: 1
		putAll: data
		startingAt: 5.
	expectedContent := preamble , (data copyFrom: 2 to: 5).
	self assert: (self streamedContents: subject) equals: expectedContent.
	self assertStream: subject hasPosition: expectedContent size.
	"Cause overflow"
	subject
		next: 2
		putAll: data
		startingAt: 6.
	self assertStream: subject hasPosition: preamble size + 6.
	self assert: (self streamedContents: subject) equals: preamble , 'b🐬c'.
	"Out of bounds of source collection error cases"
	self should: 
			[subject
				next: 3
				putAll: 'def'
				startingAt: 0]
		raise: BoundsError.
	self should: 
			[subject
				next: 3
				putAll: 'def'
				startingAt: 2]
		raise: BoundsError!

testNextUtf8Underflow
	<mustConform: #writeFileStream>
	<mustConform: #readFileStream>
	<mustNotConform: #StdioFileStream>
	| offset string subject |
	subject := self tempWriteStream: #utf8.
	offset := $\xFEFF utf8Length.
	"Fill the first page up to the penultimate byte"
	string := String new: (self bufferSizeOfStream: subject) - offset - 1 withAll: $X.
	subject nextPutAll: string.
	subject nextPut: Character dolphin.
	subject close.
	subject := self tempReadStream: #utf8.
	self assert: (subject next: string size) equals: string.
	"The emoji straddles the page boundary"
	self assert: subject next equals: Character dolphin.
	self assert: subject atEnd!

testNextWord
	<mustConform: #gettableStream>
	"Single words"
	#('a' 'ab' 'abc') do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextWord equals: each.
			self assert: stream atEnd.
			self assertIsNil: stream nextWord].
	"Empty of just separators (i.e. no words)"
	#('' ' ' '	' '  ') , {String with: Character lf. String with: Character cr. String lineDelimiter}
		do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assertIsNil: stream nextWord.
			self assert: stream atEnd].

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
				self assert: stream atEnd]!

testOwnsFile
	<mustConform: #writeFileStream> 
	<mustNotConform: #StdioFileStream>
	| subject file |
	subject := self tempWriteStream.
	self assert: subject ownsFile.
	file := subject file.
	self assert: file handle isKindOf: External.Handle.
	subject close.
	self assertIsNil: file handle.
	file open.
	self assert: file handle isKindOf: External.Handle.
	subject := self streamClass on: file.
	self deny: subject ownsFile.
	subject close.
	self assert: file handle isKindOf: External.Handle.
	file close!

testPeek
	<mustConform: #gettableStream>

	| stream |
	"Empty stream (initlially at end)"
	stream := self streamOn: ''.
	self assertIsNil: stream peek.
	self assert: stream atEnd.
	"Non-empty stream"
	stream := self streamOn: 'ab'.
	"Not at end but mismatch"
	self assert: stream peek equals: $a.
	self assert: stream peek equals: $a.
	self assert: stream position equals: 0.
	stream := self streamOn: '🐬'.
	self assert: stream peek equals: $🐬.
	self assert: stream peek equals: $🐬.
!

testPeekFor
	<mustConform: #gettableStream>

	| stream |
	"Empty stream (initlially at end)"
	stream := self streamOn: ''.
	self deny: (stream peekFor: $a).
	self assert: stream atEnd.
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
	self assert: stream atEnd!

testPositionAfterWrite
	<mustConform: #writeFileStream>
	| actual subject filename |
	subject := self tempWriteStream: #ansi.
	filename := subject name.
	subject position: 100.
	subject nextPut: $a.
	"Reposition to a later point, but don't write anything."
	subject position: 200.
	"Only the content up to the last actual write position should be flushed to the file."
	subject close.
	actual := File readAllText: filename.
	self assert: actual size equals: 101.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: 101) equals: $a.
	self assert: (actual occurrencesOf: $\0) equals: 100!

testRandomWriteOnePage
	<mustConform: #writeFileStream>
	| pos actual bufferSize subject |
	"Use an ansi stream so no BOM"
	subject := self tempWriteStream: #ansi.
	bufferSize := self bufferSizeOfStream: subject.
	pos := bufferSize - 2.
	subject position: pos.
	self assertStream: subject hasPosition: pos.
	self assert: subject size equals: 0.
	self assert: subject atEnd.
	subject nextPut: $a.
	"Reposition behind the point we extended the file to and write something earlier in the page."
	subject position: pos - 100.
	subject nextPutAll: 'b'.
	"We expect the content to be flushed up to the first char we wrote (which is the last positionally)"
	subject flush.
	actual := self streamedContents: subject.
	self assert: actual size equals: bufferSize - 1.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: pos + 1) equals: $a.
	self assert: (actual at: pos - 100 + 1) equals: $b.
	self assert: (actual occurrencesOf: $\0) equals: bufferSize - 1 - 2!

testResetAfterWrite
	<mustConform: #writeFileStream>
	| stream |
	stream := self streamWith: String new.
	stream nextPut: $a.
	stream reset.
	self isReadableStreamClass
		ifTrue: 
			[self assert: stream next equals: $a.
			self assert: stream atEnd]
		ifFalse: [self assert: (self streamedContents: stream) equals: 'a']!

testReverseContents
	<mustConform: #sequencedStream>
	| stream euro |
	stream := self streamWith: ''.
	self assert: stream reverseContents isEmpty.
	euro := String with: $1 with: $\x20AC.
	stream := self streamWith: euro.
	self assert: stream reverseContents equals: (String with: $\x20AC with: $1).
	stream := self streamWith: '¡Hola!!'.
	self assert: stream reverseContents equals: '!!aloH¡'.
	stream := self streamWith: #[].
	self assert: stream reverseContents isEmpty.
	stream := self streamWith: #[1 2 3].
	self assert: stream reverseContents equals: #[3 2 1]!

testRewindAfterWrite
	<mustConform: #writeFileStream>
	| actual subject |
	subject := self tempWriteStream.
	subject nextPutAll: 'Hello'.
	subject position: 1.
	subject close.
	actual := self tempReadStream upToEnd.
	self assert: actual equals: 'Hello'!

testSetToEnd
	<mustConform: #sequencedStream>
	| string stream |
	string := 'hello'.
	stream := self streamWith: string.
	self assert: stream atEnd.
	stream setToEnd.
	self assert: stream position equals: string size.
	self assert: (self streamedContents: stream) equals: string!

testSingleByteOverflow
	"Test that overflowing the FileStream buffer by a single byte and letting the FileStream be finalized
	doesn't lose the last byte."

	<mustConform: #writeFileStream>
	| weak subject gcs bufferSize |
	subject := self newStream: #text.
	"Write bufSize-1 characters - buffer should be dirty but not yet flushed"
	bufferSize := self bufferSizeOfStream: subject.
	subject next: bufferSize - 1 put: $1.
	self assertBufferDirty: subject.

	"Write the last byte - buffer should be dirty and full but not yet flushed"
	subject nextPut: $2.
	self assertBufferDirty: subject.

	"Write another byte - overflowing buffer by one, but should still be dirty"
	subject nextPut: $3.
	self assertBufferDirty: subject.
	weak := WeakArray with: subject.
	subject := nil.
	gcs := 0.
	[(weak at: 1) isKindOf: DeadObject] whileFalse: 
			[self assert: gcs < 10.
			MemoryManager current collectGarbage.
			gcs := gcs + 1].

	"Forcibly finalize"
	MemoryManager current administerLastRites.
	subject := self tempReadStream: #text.
	self assert: subject size equals: bufferSize + 1.
	subject next: bufferSize - 2.
	self assert: subject next equals: $1.
	self assert: subject next equals: $2.
	self assert: subject next equals: $3.
	subject close!

testSkipSeparators
	<mustConform: #gettableStream>

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
	self deny: stream skipSeparators!

testSkipToAllColon
	<mustConform: #gettableStream>

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
	self assert: stream atEnd!

testTruncate
	<mustConform: #writeFileStream>
	| actual subject filename |
	subject := self tempWriteStream.
	subject nextPutAll: 'hello'.
	filename := subject name.
	subject close.
	subject := self streamClass
				write: filename
				mode: #truncate
				check: false
				text: true.
	[subject nextPutAll: ' world'] ensure: [subject close].
	actual := self tempReadStream upToEnd.
	self assert: actual equals: ' world'!

testUpTo
	<mustConform: #gettableStream>
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
					self assert: actual asArray equals: expected]]!

testUpToAllColon
	<mustConform: #gettableStream>
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
	self assert: stream atEnd!

testUpToEnd
	<mustConform: #gettableStream>
	<mustConform: #sequencedStream>
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
					self assert: actual asArray equals: expected]]!

testUpToUtf
	<mustConform: #gettableStream>

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
			self assert: stream atEnd]!

testWriteEmptyString
	<mustConform: #puttableStream>
	self verifyWriteString: ''!

testWriteOneCharacter	
	<mustConform: #puttableStream>
	self verifyWriteCharacter: $a!

testWriteOneExtendedChar
	<mustConform: #puttableStream>
	self verifyWriteCharacter: Character dolphin!

testWritePastEnd
	"#457: Tests that the page buffer is zero'd out out when writing beyond the end of the file
	so that previous buffer content is not mirrored into the last page."

	<mustConform: #writeFileStream>
	| actual expected r bufferSize subject |
	subject := self tempWriteStream: #ansi.
	bufferSize := self bufferSizeOfStream: subject.
	expected := WriteStream with: (AnsiString new: bufferSize * 2).
	expected reset.
	r := Random new.
	bufferSize
		timesRepeat: [subject nextPut: (expected nextPut: (Character ansiValue: (r next * 97 + 32) asInteger))].
	subject position: bufferSize - 2.
	expected position: subject position.
	subject nextPutAll: (expected nextPutAll: 'abc').
	"Go back and read the first page."
	subject reset.
	"Reposition into the 2nd page beyond the current end."
	subject position: bufferSize * 2 - 5.
	expected position: subject position.
	"Write some more stuff"
	subject nextPutAll: (expected nextPutAll: 'world').
	subject flush.
	actual := self streamedContents: subject.
	expected := expected contents.
	self assert: actual equals: expected!

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
	^count!

verifyWriteCharacter: aCharacter
	| utf8 subject |
	utf8 := aCharacter asString.
	subject := self tempWriteStream: #text.
	subject nextPut: aCharacter.
	self assert: (self streamedContents: subject) equals: utf8!

verifyWriteString: aString
	| subject |
	subject := self tempWriteStream: aString encoding.
	self assertStream: subject hasPosition: 0.
	subject nextPutAll: aString.
	self assertStream: subject hasPosition: aString size.
	self assert: (self streamedContents: subject) equals: aString!

writeableCollections
	^self strings , self byteArrays , self arrays , self orderedCollections!

writeOperationNotImplemented: aBlock 
	"It is an error to attempt to write to a ReadStream"

	self 
		should: aBlock
		raise: Error
		matching: [:ex | ex description = 'The stream is not writeable']! !

!Core.Tests.PositionableStreamTest categoriesForMethods!
arrayedCollections!constants!private! !
arrays!constants!private! !
assert:absolutePositionEquals:!helpers!private! !
assert:bufferPositionEquals:!helpers!private! !
assertBufferDirty:!helpers!private! !
assertStream:hasPosition:!helpers!private! !
bufferClasses!helpers!private! !
bufferSizeOfStream:!helpers!private!unit tests! !
byteArrays!constants!private! !
collections!constants!private! !
expectedAnsiProtocolNames!constants!private! !
intervals!constants!private! !
newStream:!helpers!private! !
orderedCollections!constants!private! !
readOperationNotImplemented:!helpers!private! !
runArrays!constants!private! !
streamClassSupportsPointers!helpers!private! !
streamClassSupportsUtf16!helpers!private! !
streamClassSupportsUtf8Surrogates!helpers!private! !
streamedContents:!helpers!private! !
streamOnBytes:type:!helpers!private! !
streamOnFile:type:!helpers!private! !
streamWith:!helpers!private! !
strings!constants!private! !
subjectCollection:!helpers!public! !
tempReadStream!helpers!private! !
tempReadStream:!helpers!private! !
tempWriteStream!helpers!private! !
tempWriteStream:!helpers!private! !
test1065!public!unit tests! !
testAppend!public!unit tests! !
testBasicNext!public!unit tests! !
testContents!public!unit tests! !
testEncodedSizeOf!public!unit tests! !
testEncoding!public!strict utf8!unit tests! !
testMarkusKuhnUtf8!public!strict utf8!unit tests! !
testNew!public!unit tests! !
testNewContents!public!unit tests! !
testNext!public!unit tests! !
testNextAvailable!public!unit tests! !
testNextAvailableColon!public!unit tests! !
testNextColon!public!unit tests! !
testNextColonPutColon!public!unit tests! !
testNextIllegalUtf8CodePositions!public!unit tests! !
testNextInto!public!unit tests! !
testNextLine!public!unit tests! !
testNextLineCrOnly!public!unit tests! !
testNextLongUtf8Encodings!public!strict utf8!unit tests! !
testNextOtherNonCharactersUtf16!public!unit tests! !
testNextOtherNonCharactersUtf8!public!unit tests! !
testNextOverlongUtf8!public!strict utf8!unit tests! !
testNextPut!public!unit tests! !
testNextPutAll!public!unit tests! !
testNextPutAllArray!public!unit tests! !
testNextPutAllStartingAtAnsiToUtf8!public!unit tests! !
testNextPutAllStartingAtBytes!public!unit tests! !
testNextPutAllStartingAtUtf16ToBytes!public!unit tests! !
testNextPutAllStartingAtUtf16ToUtf8!public!unit tests! !
testNextPutAllStartingAtUtf16ToUtf8InvalidCount!public!unit tests! !
testNextPutAllStartingAtUtf16ToUtf8InvalidStart!public!unit tests! !
testNextPutAllStartingAtUtf8ToBytes!public!unit tests! !
testNextPutAllStartingAtUtf8ToUtf16!public!unit tests! !
testNextPutAllStartingAtUtf8ToUtf8!public!unit tests! !
testNextUtf8Underflow!public!unit tests! !
testNextWord!public!unit tests! !
testOwnsFile!public!unit tests! !
testPeek!public!unit tests! !
testPeekFor!public!unit tests! !
testPositionAfterWrite!public!unit tests! !
testRandomWriteOnePage!public!unit tests! !
testResetAfterWrite!public!unit tests! !
testReverseContents!public!unit tests! !
testRewindAfterWrite!public!unit tests! !
testSetToEnd!public!unit tests! !
testSingleByteOverflow!public!unit tests! !
testSkipSeparators!public!unit tests! !
testSkipToAllColon!public!unit tests! !
testTruncate!public!unit tests! !
testUpTo!public!unit tests! !
testUpToAllColon!public!unit tests! !
testUpToEnd!public!unit tests! !
testUpToUtf!public!unit tests! !
testWriteEmptyString!public!unit tests! !
testWriteOneCharacter!public!unit tests! !
testWriteOneExtendedChar!public!unit tests! !
testWritePastEnd!public!unit tests! !
verifyNonChars:!constants!helpers!private! !
verifyWriteCharacter:!helpers!private! !
verifyWriteString:!helpers!private! !
writeableCollections!constants!private! !
writeOperationNotImplemented:!helpers!private! !
!

