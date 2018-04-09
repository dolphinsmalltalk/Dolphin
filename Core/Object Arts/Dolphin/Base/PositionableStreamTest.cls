"Filed out from Dolphin Smalltalk 7"!

StreamTest subclass: #PositionableStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PositionableStreamTest guid: (GUID fromString: '{3abcc3a3-be2b-417d-bdb7-cf6a64cc2c6b}')!
PositionableStreamTest isAbstract: true!
PositionableStreamTest comment: ''!
!PositionableStreamTest categoriesForClass!Unclassified! !
!PositionableStreamTest methodsFor!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

streamWith: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass with: aString copy!

strings
	^{''.
		Utf16String empty.
		'a'.
		'abc'.
		AnsiString with: (Character value: 163).
		AnsiString with: (Character ansiValue: 128).
		Utf8String with: (Character value: 163).
		Character byteCharacterSet.
		'a' , Character dolphin asUtf8String.
		'a' , Character dolphin asUtf16String}!

subjectCollection: aSequenceableCollection
	^aSequenceableCollection!

testBasicNext
	self strings do: 
			[:each |
			| subject collection |
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
	| stream |
	stream := self streamWith: ''.
	self assert: stream contents isEmpty.
	self closeTempStream: stream.
	stream := self streamWith: 'hello'.
	self assert: stream contents = 'hello'.
	self closeTempStream: stream!

testNew
	self should: [self streamClass new] raise: Error!

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
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:each |
			| stream |
			stream := self streamOn: each.
			self assert: stream nextLine equals: ''.
			self assert: stream atEnd.
			self closeTempStream: stream].
	"Finishes with line delimiter"
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:eachDelim |
			#('a' 'ab' 'abc') do: 
					[:each |
					| stream |
					stream := self streamOn: each , eachDelim.
					self assert: stream nextLine = each.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	"Finishes with pair of line delimiters"
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
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
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
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

testNextWord
	"Single words"

	#('a' 'ab' 'abc') do: 
			[:each | 
			| stream |
			stream := self streamOn: each.
			self assert: stream nextWord = each.
			self assert: stream atEnd.
			self assert: stream nextWord isNil.
			self closeTempStream: stream].
	"Empty of just separators (i.e. no words)"
	#('' ' ' '	' '  ') , (Array 
				with: (String with: Character lf)
				with: (String with: Character cr)
				with: String lineDelimiter) 
		do: 
			[:each | 
			| stream |
			stream := self streamOn: each.
			self assert: stream nextWord isNil.
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
				self assert: stream nextWord = words first.
				self assert: stream nextWord = words second.
				self assert: stream nextWord isNil.
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
	self assert: stream reverseContents = (String with: $\x20AC with: $1).
	self closeTempStream: stream.
	stream := self streamWith: '¡Hola!!'.
	self assert: stream reverseContents = '!!aloH¡'.
	self closeTempStream: stream!

testSkipToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	"1 char sequence found at start"
	stream reset.
	self assert: (stream skipToAll: 'a').
	self assert: stream position = 1.	"Remember stream position is zero based"

	"1 char sequence found at end"
	stream reset.
	self assert: (stream skipToAll: 'e').
	self assert: stream atEnd.

	"1 char sequence found in middle"
	stream reset.
	self assert: (stream skipToAll: 'c').
	self assert: stream position = (chars indexOf: $c).

	"2 char sequence found at start"
	stream reset.
	self assert: (stream skipToAll: 'ab').
	self assert: stream position = 3.

	"2 char sequence found at end"
	stream reset.
	self assert: (stream skipToAll: 'de').
	self assert: stream atEnd.

	"2 char sequence found in middle"
	stream reset.
	self assert: (stream skipToAll: 'ca').
	self assert: stream position = ((chars indexOf: $c) + 1).

	"3 char sequence found at start"
	stream reset.
	self assert: (stream skipToAll: 'aba').
	self assert: stream position = 4.

	"3 char sequence found at end"
	stream reset.
	self assert: (stream skipToAll: 'cde').
	self assert: stream atEnd.

	"3 char sequence found in middle"
	stream reset.
	self assert: (stream skipToAll: 'cab').
	self assert: stream position = ((chars indexOf: $c) + 2).

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

testUpToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	"1 char sequence found at start"
	stream reset.
	self assert: (stream upToAll: 'a') = ''.
	self assert: stream position = 1.	"Remember stream position is zero based"

	"1 char sequence found at end"
	stream reset.
	self assert: (stream upToAll: 'e') = 'aababcabcdabcd'.
	self assert: stream atEnd.

	"1 char sequence found in middle"
	stream reset.
	self assert: (stream upToAll: 'c') = 'aabab'.
	self assert: stream position = (chars indexOf: $c).

	"2 char sequence found at start"
	stream reset.
	self assert: (stream upToAll: 'ab') = 'a'.
	self assert: stream position = 3.

	"2 char sequence found at end"
	stream reset.
	self assert: (stream upToAll: 'de') = 'aababcabcdabc'.
	self assert: stream atEnd.

	"2 char sequence found in middle"
	stream reset.
	self assert: (stream upToAll: 'ca') = 'aabab'.
	self assert: stream position = ((chars indexOf: $c) + 1).

	"3 char sequence found at start"
	stream reset.
	self assert: (stream upToAll: 'aba') = 'a'.
	self assert: stream position = 4.

	"3 char sequence found at end"
	stream reset.
	self assert: (stream upToAll: 'cde') = 'aababcabcdab'.
	self assert: stream atEnd.

	"3 char sequence found in middle"
	stream reset.
	self assert: (stream upToAll: 'cab') = 'aabab'.
	self assert: stream position = ((chars indexOf: $c) + 2).

	"1 char, not found"
	stream reset.
	self assert: (stream upToAll: 'f') = chars.
	self assert: stream atEnd.

	"2 chars, both not found"
	stream reset.
	self assert: (stream upToAll: 'gh') = chars.
	self assert: stream atEnd.

	"2 chars, second not found, first at start"
	stream reset.
	self assert: (stream upToAll: 'ah') = chars.
	self assert: stream atEnd.

	"2 chars, second not found, first middle"
	stream reset.
	self assert: (stream upToAll: 'ch') = chars.
	self assert: stream atEnd.

	"2 chars, second not found, first end"
	stream reset.
	self assert: (stream upToAll: 'eh') = chars.
	self assert: stream atEnd.

	"3 chars, first not found"
	stream reset.
	self assert: (stream upToAll: 'fab') = chars.
	self assert: stream atEnd.

	"3 chars, second not found at all"
	stream reset.
	self assert: (stream upToAll: 'cfb') = chars.
	self assert: stream atEnd.

	"3 chars, last not found at all"
	stream reset.
	self assert: (stream upToAll: 'abf') = chars.
	self assert: stream atEnd.
	self closeTempStream: stream!

testUpToEnd
	| chars stream |
	chars := 'abc'.
	stream := self streamOn: chars.
	stream reset.
	self assert: stream upToEnd = 'abc'.
	stream
		reset;
		next.
	self assert: stream upToEnd = 'bc'.
	stream
		reset;
		next: 2.
	self assert: stream upToEnd = 'c'.
	stream
		reset;
		next: 3.
	self assert: stream upToEnd = ''.
	self assert: stream upToEnd = ''.
	self closeTempStream: stream! !
!PositionableStreamTest categoriesFor: #streamOn:!helpers!private! !
!PositionableStreamTest categoriesFor: #streamWith:!helpers!private! !
!PositionableStreamTest categoriesFor: #strings!constants!private! !
!PositionableStreamTest categoriesFor: #subjectCollection:!public! !
!PositionableStreamTest categoriesFor: #testBasicNext!public!unit tests! !
!PositionableStreamTest categoriesFor: #testContents!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNew!public!testing! !
!PositionableStreamTest categoriesFor: #testNextLine!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextLineCrOnly!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextWord!public!unit tests! !
!PositionableStreamTest categoriesFor: #testPeekFor!public!unit tests! !
!PositionableStreamTest categoriesFor: #testReverseContents!public!unit tests! !
!PositionableStreamTest categoriesFor: #testSkipToAllColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToEnd!public!unit tests! !

