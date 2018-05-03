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
		matching: [:ex | ex description beginsWith: self streamClass name , ' should not implement']!

runArrays
	^{{RunArray new. #()}.
		{RunArray with: #x. #(#x)}.
		{RunArray with: #x with: #y. #(#x #y)}.
		{(1 to: 5) asRunArray. #(1 2 3 4 5)}}!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

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

testNew
	self should: [self streamClass new] raise: Error!

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

writeableCollections
	^self strings , self byteArrays , self arrays , self orderedCollections!

writeOperationNotImplemented: aBlock 
	"It is an error to attempt to write to a ReadStream"

	self 
		should: aBlock
		raise: Error
		matching: [:ex | ex description beginsWith: self streamClass name , ' does not understand']! !
!PositionableStreamTest categoriesFor: #arrayedCollections!private!unit tests! !
!PositionableStreamTest categoriesFor: #arrays!private!unit tests! !
!PositionableStreamTest categoriesFor: #byteArrays!private!unit tests! !
!PositionableStreamTest categoriesFor: #collections!private!unit tests! !
!PositionableStreamTest categoriesFor: #intervals!private!unit tests! !
!PositionableStreamTest categoriesFor: #orderedCollections!private!unit tests! !
!PositionableStreamTest categoriesFor: #readOperationNotImplemented:!private!unit tests! !
!PositionableStreamTest categoriesFor: #runArrays!private!unit tests! !
!PositionableStreamTest categoriesFor: #streamOn:!helpers!private! !
!PositionableStreamTest categoriesFor: #streamWith:!helpers!private! !
!PositionableStreamTest categoriesFor: #strings!constants!private! !
!PositionableStreamTest categoriesFor: #subjectCollection:!public! !
!PositionableStreamTest categoriesFor: #testBasicNext!public!unit tests! !
!PositionableStreamTest categoriesFor: #testContents!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNew!public!testing! !
!PositionableStreamTest categoriesFor: #testNextAvailableColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextLine!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextLineCrOnly!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextPut!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextWord!public!unit tests! !
!PositionableStreamTest categoriesFor: #testPeekFor!public!unit tests! !
!PositionableStreamTest categoriesFor: #testReverseContents!public!unit tests! !
!PositionableStreamTest categoriesFor: #testSkipToAllColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpTo!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToEnd!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToUtf!public! !
!PositionableStreamTest categoriesFor: #writeableCollections!private!unit tests! !
!PositionableStreamTest categoriesFor: #writeOperationNotImplemented:!private!unit tests! !

