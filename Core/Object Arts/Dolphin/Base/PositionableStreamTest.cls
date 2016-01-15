"Filed out from Dolphin Smalltalk 7"!

StreamTest subclass: #PositionableStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PositionableStreamTest guid: (GUID fromString: '{3ABCC3A3-BE2B-417D-BDB7-CF6A64CC2C6B}')!
PositionableStreamTest comment: ''!
!PositionableStreamTest categoriesForClass!Unclassified! !
!PositionableStreamTest methodsFor!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

streamWith: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass with: aString copy!

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
	#('' 'a' 'ab' 'abc') do: 
			[:each | 
			| stream line |
			stream := self streamOn: each.
			line := stream nextLine.
			self assert: line = each.
			self assert: stream atEnd.
			self closeTempStream: stream].

	"Empty but for a single line delimiter"
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:each | 
			| stream |
			stream := self streamOn: each.
			self assert: stream nextLine = ''.
			self assert: stream atEnd.
			self closeTempStream: stream].
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:eachDelim | 
			#('a' 'ab' 'abc') do: 
					[:each | 
					| stream |
					stream := self streamOn: eachDelim , each.
					self assert: stream nextLine = ''.
					self assert: stream atEnd not.
					self assert: stream nextLine = each.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:eachDelim | 
			#('a' 'ab' 'abc') do: 
					[:each | 
					| stream |
					stream := self streamOn: each , eachDelim , each.
					self assert: stream nextLine = each.
					self assert: stream atEnd not.
					self assert: stream nextLine = each.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:eachDelim | 
			#('a' 'ab' 'abc') do: 
					[:each | 
					| stream line |
					stream := self streamOn: each , eachDelim , eachDelim , each.
					stream reset.
					line := stream nextLine.
					self assert: line = each.
					self assert: stream atEnd not.
					line := stream nextLine.
					self assert: line = ''.
					self assert: stream atEnd not.
					line := stream nextLine.
					self assert: line = each.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:eachDelim | 
			#('a' 'ab' 'abc') do: 
					[:each | 
					| stream |
					stream := self streamOn: each , eachDelim , eachDelim , each , eachDelim.
					self assert: stream nextLine = each.
					self assert: stream atEnd not.
					self assert: stream nextLine = ''.
					self assert: stream atEnd not.
					self assert: stream nextLine = each.
					self assert: stream atEnd.
					self closeTempStream: stream]].
	(Array with: (String with: Character lf) with: String lineDelimiter) do: 
			[:eachDelim | 
			#('' 'a' 'ab' 'abc') do: 
					[:each | 
					| stream |
					stream := self streamOn: each , eachDelim.
					self assert: stream nextLine = each.
					self assert: stream atEnd.
					self closeTempStream: stream]].

	"Single CR - not treated as a line delimiter unless last in file"
	#('' 'a' 'ab' 'abc') do: 
			[:each | 
			| line chars stream |
			chars := each , (String with: Character cr).
			stream := self streamOn: chars.
			stream reset.
			line := stream nextLine.
			self assert: line = each.
			self assert: stream atEnd.
			self closeTempStream: stream].

	"Single CR - not treated as a line delimiter unless last in file"
	#('a' 'ab' 'abc') do: 
			[:each | 
			| line2 chars stream |
			chars := each , (String with: Character cr) , each.
			stream := self streamOn: chars.
			stream reset.
			line2 := stream nextLine.
			self assert: line2 = chars.
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
!PositionableStreamTest categoriesFor: #testContents!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNew!public!testing! !
!PositionableStreamTest categoriesFor: #testNextLine!public!unit tests! !
!PositionableStreamTest categoriesFor: #testNextWord!public!unit tests! !
!PositionableStreamTest categoriesFor: #testSkipToAllColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!PositionableStreamTest categoriesFor: #testUpToEnd!public!unit tests! !

!PositionableStreamTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!PositionableStreamTest class categoriesFor: #isAbstract!public!Testing! !

