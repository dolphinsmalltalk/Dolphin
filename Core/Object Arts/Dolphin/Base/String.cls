"Filed out from Dolphin Smalltalk 7"!

ArrayedCollection variableByteSubclass: #String
	instanceVariableNames: ''
	classVariableNames: 'EncodingAnsi EncodingUtf16 EncodingUtf32 EncodingUtf8 LineDelimiter'
	poolDictionaries: ''
	classInstanceVariableNames: 'empty'!
String guid: (GUID fromString: '{87b4c514-026e-11d3-9fd7-00a0cc3e4a32}')!
String isNullTerminated: true!
String isAbstract: true!
String addClassConstant: 'EncodingAnsi' value: 0!
String addClassConstant: 'EncodingUtf16' value: 2!
String addClassConstant: 'EncodingUtf32' value: 3!
String addClassConstant: 'EncodingUtf8' value: 1!
String addClassConstant: 'LineDelimiter' value: '
'!
String comment: 'String is the abstract class of <ArrayedCollection>s representing strings of <Character>s. It has subclasses for strings in the most common encodings, e.g. Latin1, UTF-8, and UTF-16. 

The default and preferred string type is Utf8String, representing UTF-8 encoded strings, however many Windows APIs will expect to be passed (and will return) UTF-16 encoded strings. Utf16String is the concreted subclass to  represent UTF-16 encoded strings.

N.B. Dolphin Strings are, unlike Smalltalk-80 strings, null terminated. Space for the null terminator is implicity included when a String is allocated, but is not reported when the size of the String is requested.

String complies with the following ANSI protocols:
	Object
	magnitude
	collection
	sequencedReadableCollection
	sequencedCollection
	readableString
	String'!
!String categoriesForClass!Collections-Text! !
!String methodsFor!

, aSequencedReadableCollection
	"Answer a new <String> like the receiver (i.e. of the receiver's species but not necessarily
	the exact same class) containing the Characters of the receiver in their original order with
	Characters constructed from the elements of the <sequencedReadableCollection> argument
	appended in their original order, i.e. concatenate the argument to the receiver."

	<primitive: 218>
	^self class == aSequencedReadableCollection class
		ifTrue: [
			"For concatenation of the same string encoding we can use efficient array block copy operations"
			super , aSequencedReadableCollection]
		ifFalse: 
			[
			"For mixed encoding, we stream into a Utf8String"
			(Utf8String writeStream: self size + aSequencedReadableCollection size)
				nextPutAll: self;
				nextPutAll: aSequencedReadableCollection;
				contents]!

_cmp: comparand
	"Private - Answer the receiver's <integer> ordinal collation order with respect to 
	the <readableString> argument, comparand. The answer is < 0 if
	the receiver is ordinally before the argument, 0 if ordinally equivalent, or
	> 0 if ordinally after the argument. This comparison is fast and locale insensitive."

	<primitive: 220>
	^self primitiveFailed!

_collate: comparand
	"Private - Answer the receiver's <integer> collation order with respect to 
	the <readableString> argument, comparand. The answer is < 0 if
	the receiver is lexically before the argument, 0 if lexically equivalent, or
	> 0 if lexically after the argument. The comparision is CASE INSENSITIVE.
	The comparison respects the currently configured default locale of the
	host operating system, and the performance may disappoint in some cases."

	| string1 string2 |
	<primitive: 56>
	comparand isString ifFalse: [^self error: 'Invalid comparand'].
	"The primitive works with any supported string encoding (ANSI, UTF-8 and UTF-16) and invokes
	the OS StringCompare function, in essence as follows:"
	string1 := self asUtf16String.
	string2 := comparand asUtf16String.
	^(KernelLibrary default
		compareString: Win32Constants.LOCALE_USER_DEFAULT
		dwCmpFlags: Win32Constants.NORM_IGNORECASE
		lpString1: string1
		cchCount1: string1 size
		lpString2: string2
		cchCount2: string2 size) - 2!

_indexOfAnyInString: aString startingAt: anInteger
	| span |
	#todo.	"Doesn't work for mixed encodings, only both ANSI or both UTF-8"
	span := aString strcspn: self start: anInteger.
	^span + anInteger > aString size
		ifTrue: [0]
		ifFalse: 
			["CRT function will stop if it hits a null embedded in the string, so we must fall back
			on slower superclass implementation in that case."
			^(aString basicAt: span + anInteger) == 0
				ifTrue: [super _indexOfAnyInString: aString startingAt: anInteger]
				ifFalse: [span + anInteger]]!

_sameAsString: aString 
	"Private - Answer whether the receiver collates the same as argument, aString."

	"Implementation Note: Double dispatched from String>>sameAs:. Works for any mix of encodings
	because _collate: does."

	^self == aString or: [(aString _collate: self) == 0]!

_separateSubStringsIn: aReadableString 
	"Private - Answer an Array containing the substrings in aReadableString separated
	by the receiver."

	| start size answer subSize |
	(subSize := self size) == 0 
		ifTrue: [^self error: 'separator must consist of at least one character'].
	subSize == 1 ifTrue: [^(self at: 1) _separateSubStringsIn: aReadableString].
	start := 1.
	size := aReadableString size.
	answer := OrderedCollection new: 10.
	
	[| stop |
	stop := aReadableString findString: self startingAt: start.
	stop == 0 
		ifTrue: 
			[answer addLast: (aReadableString copyFrom: start to: size).
			^answer asArray].
	answer addLast: (aReadableString copyFrom: start to: stop - 1).
	(start := stop + subSize) > size] 
			whileFalse.
	^answer asArray!

< comparand
	"Answer whether the receiver is lexically less than the <readableString>, comparand,
	ignoring case, according to the implementation defined collation sequence (see _collate:)."

	^(self _collate: comparand) < 0!

<= comparand
	"Answer whether the receiver is lexically less than or equal to the <readableString>, 
	comparand, ignoring case, according to the implementation defined collation sequence 
	(see _collate:). Note that this is the equivalent to 
		'self < comparand or: [self sameAs: comparand]'
	and NOT
		'self < comparand or: [self = comparand]
	since String>>= is case sensitive."

	^(self _collate: comparand) <= 0!

= comparand
	"Answer whether the receiver and the <Object> argument, comparand, 
	are both Strings containing identical code points.

	Primitive failure results:
		0 -	comparand is a SmallInteger.
		1 - 	comparand is not a null-terminated object.
		2 -	comparand and/or receiver encoding not recognised."

	<primitive: 219>
	^self == comparand or: 
			[comparand isString and: 
					[comparand isSymbol not and: 
							[| string1 string2 |
							"The primitive uses the OS CompareStringOrdinal function, or memcmp for a pair of byte strings of matched encoding."
							string1 := self asUtf16String.
							string2 := comparand asUtf16String.
							(KernelLibrary default
								compareStringOrdinal: string1
								cchCount1: string1 size
								lpString2: string2
								cchCount2: string2 size
								bIgnoreCase: false) == Win32Constants.CSTR_EQUAL]]]!

> comparand
	"Answer whether the receiver is lexically greater than the <readableString>, comparand,
	ignoring case, according to the implementation defined collation sequence 
	(see _collate:)."

	^(self _collate: comparand) > 0!

>= comparand
	"Answer whether the receiver is lexically greater than or equal to the 
	<readableString> comparand, ignoring case, according to the implementation 
	defined collation sequence (see _collate:)."

	^(self _collate: comparand) >= 0!

appendToStream: puttableStream
	"Private - Append the receiver's elements to the argument, puttableStream.
	We can be able to do a fast block copy. Answer the receiver.
	Implementation note: Double dispatched from puttableStream>>nextPutAll:."

	| chars ch |
	#todo.	"This works but is sub-optimal. Need to coerce the receiver to the encoding of the target stream so we can do a block write through next:putAll:startingAt:. The stream probably needs to forward the request to its contents class, not directly to the collection arg of #nextPutAll:, similarly to #nextPut: sending #encode:on:"
	chars := ReadStream on: self.
	[(ch := chars nextAvailable) isNil] whileFalse: [puttableStream nextPut: ch]!

asAnsiString
	"Answer an ANSI encoded string representation of the receiver."

	<primitive: 217>
	^self asUtf16String asByteString: AnsiString!

asByteArray
	"Answer a <ByteArray> containing the encoded representations of the characters of the
	receiver."

	| size |
	size := self byteSize - self class elementSize.
	^self
		replaceBytesOf: (ByteArray new: size)
		from: 1
		to: size
		startingAt: 1!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	^self subclassResponsibility!

asNumber
	"Answer a Number constructed by interpreting the receiver's characters as the
	printString of a Number."

	^Number fromString: self!

asPhrase
	"Answer a <sequencedReadableCollection> of the 'words' in the receiver, as capitalized strings.
	The word boundaries are identified by colons (i.e. keywords) and capital letters."

	| stream last |
	stream := self species writeStream: self size + 10.
	self readStream do: 
			[:each | 
			last isNil 
				ifTrue: [each == $: ifFalse: [last := stream nextPut: each asUppercase]]
				ifFalse: 
					[each == $: 
						ifFalse: 
							[last == $: 
								ifTrue: 
									[stream
										space;
										nextPut: each asUppercase]
								ifFalse: 
									[(each isUppercase and: [last isLowercase]) ifTrue: [stream space].
									(each isDigit and: [last isDigit not]) ifTrue: [stream space].
									stream nextPut: each]].
					last := each]].
	^stream contents!

asResourceId
	"On Windows wide string APIs will be expecting string resource names to be in UTF-16."

	^self asUtf16String!

asString
	"Answer a <readableString> containing the same characters as the receiver,
	i.e. the receiver."

	^self!

asSymbol
	"Answer the <symbol> corresponding to the receiver."

	^Symbol intern: self!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	"N.B. Be careful that the receiver is not GC'd until the result is no longer required, or it
	will be a dangling pointer."

	^self yourAddress!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	^self subclassResponsibility!

asUtf16String
	"Answer a UTF16-encoded equivalent of the receiver."

	<primitive: 215>
	^Utf16String withAll: self!

asUtf8String
	"Answer a UTF-8 encoded string representation of the receiver."

	<primitive: 216>
	^self asUtf16String asByteString: Utf8String!

at: index
	"Answer the <Character> at the <integer> index, in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size)."

	<primitive: 63>
	^self errorAt: index!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	<primitive: 63>
	^(index > 0 and: [index <= self size]) ifTrue: [self at: index] ifFalse: [exceptionBlock value]!

at: anInteger put: aCharacter
	"Replace the character at index, anInteger, in the receiver with aCharacter.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size).
		2 -	aCharacter is not a Character."

	<primitive: 64>
	^(aCharacter isKindOf: Character)
		ifTrue: [self errorAt: anInteger put: aCharacter]
		ifFalse: [self error: ('can''t hold <1p>''s' expandMacrosWith: aCharacter class)]!

beginsWith: comperand
	"Answer whether the receiver starts with the exact characters
	of the argument, comperand."

	^comperand _beginsString: self!

beginsWith: aString ignoreCase: aBoolean
	"Answer whether the receiver starts with the characters of the argument, aString. The
	comparison may be case sensitive or insensitive, depending on the <Boolean> argument. Note
	that unlike #beginsWith:, the comperand must be a <String>."

	| string1 string2 cch |
	string1 := self asUtf16String.
	string2 := aString asUtf16String.
	cch := string2 size.
	^cch <= string1 size and: 
			[(KernelLibrary default
				compareString: Win32Constants.LOCALE_USER_DEFAULT
				dwCmpFlags: (aBoolean ifTrue: [Win32Constants.NORM_IGNORECASE] ifFalse: [0])
				lpString1: string1
				cchCount1: cch
				lpString2: string2
				cchCount2: cch) == Win32Constants.CSTR_EQUAL]!

between: min and: max
	"Answer whether the receiver is inclusively between the <magnitude> arguments, 
	min and max."

	^self >= min and: [self <= max]!

byteAt: anInteger
	"Answer the byte at offset anInteger in the receiver"

	<primitive: 60>
	^self basicAt: anInteger!

byteAt: aSmallInteger put: value
	"Replace the byte at the specified index in the receiver with the specified integer byte value.

	Primitive Failure Reasons:
		0	- aSmallInteger is not a SmallInteger
		1	- aSmallInteger out of bounds (not in the range 1..receiver's mutable size) 
		2	- the argument, value, is not a SmallInteger in the range 0..255."

	<primitive: 61>
	^self errorAt: aSmallInteger put: value!

byteSize
	"Private - Answer the size in bytes of this object. N.B. this includes a null terminator,
	which may be of 1, 2, or 4 bytes length (see class #elementSize)."

	^self basicSize + 1!

capitalized
	"Answer a <readableString> which is a copy of the receiver but with 
	the first character converted to its uppercase equivalent."

	| size write read |
	size := self size.
	size == 0 ifTrue: [^self].
	write := self species writeStream: size.
	read := self readStream.
	write nextPut: read next asUppercase.
	write nextPutAll: read upToEnd.
	^write contents!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	^self class codePage!

contains: aString
	"Answer whether the receiver contains the specified sub-string."

	^(self findString: aString startingAt: 1) ~~ 0!

copyToBuffer: anAddress ofSize: anInteger
	^self subclassResponsibility!

decodeNextAvailable: anInteger from: aReadStream
	"Private - Answer the next anInteger future sequence values of the <ReadStream>, aReadStream, or as
	many as are available before the end of stream."

	| newStream count next |
	newStream := self class writeStream: (count := anInteger).
	[count == 0 or: [(next := aReadStream nextAvailable) isNil]] whileFalse: 
			[newStream nextPut: next.
			count := count - 1].
	^newStream contents!

decodeNextFrom: aReadStream
	"Private - Answer the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	^self subclassResponsibility!

displayOn: aStream
	"Append the receiver in end-user form to aStream. Since this message is intended
	for producing end-user text, the receiver is appended to the stream as-is."

	aStream nextPutAll: self!

displayString
	"Answer a String representation of the receiver in a form suitable for
	presentation to an end user.
	Implementation Note: This is implemented purely for performance reasons to
	avoid the Stream overhead when displaying strings because it is such a
	common operation."

	^self!

encodeOn: aWriteStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the character
	encoding of the receiver, e.g. for Utf8String, this would be the relevant sequence of 1 to 4
	UTF-8 encoded bytes necessary to represent the Unicode code point of the character."

	^self subclassResponsibility!

encoding
	^self class encoding!

equals: comperand
	"Answer whether the characters of the receiver are identical to those of 
	the argument, comperand. Should not be overridden by subclasses (a kind of basic=).
	Using this method strings and symbols compare equal if they contain the same
	character sequence - this was not true in releases prior to 3.0."

	<primitive: 55>
	#todo.	"Doesn't work correctly for comparing Symbols to UTF encoded strings. This could be
	       deprecated if we allowed strings and symbols to be equal for the same code point
	       sequence."
	(self == comperand or: [self = comperand]) ifTrue: [^true].
	comperand isString ifFalse: [^false].
	^(self _cmp: comperand) == 0!

expandMacros
	"Expand the receiver with replacable arguments.
	See #formatWithArguments: for further details."

	^self expandMacrosWithArguments: #()!

expandMacrosWith: anObject
	"Expand the receiver with replacable arguments.
	See #formatWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject}!

expandMacrosWith: anObject with: anotherObject
	"Expand the receiver with replacable arguments.
	See #formatWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject. anotherObject}!

expandMacrosWith: anObject with: anotherObject with: thirdObject 
	"Expand the receiver with replacable arguments.
	See #formatWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject. anotherObject. thirdObject}!

expandMacrosWith: anObject with: anotherObject with: thirdObject with: fourthObject 
	"Expand the receiver with replacable arguments.
	See #formatWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject. anotherObject. thirdObject. fourthObject}!

expandMacrosWithArguments: anArray 
	"Expand the receiver with replacable arguments.
	e.g.
		'Hello <D><N><1P> <D>' expandMacrosWithArguments: #('World' 1).
		'Hello <2?Good:Bad> <1S>' expandMacrosWithArguments: #('World' false)

	<nD> expands the nth parameter using it's #displayString
	<nP> expands the nth parameter using it's #printString
	<nS> expands the nth parameter treating it as a <String>
	<N> expands as a newline combination
	<T> expands as a TAB
	<n?xxxx:yyyy> if the nth parameter is true expands to 'xxxx' else 'expands to yyyy'

	If n is omitted the default of 1 is used.	
	"

	| newStream readStream index |
	newStream := String writeStream: self size.
	readStream := ReadStream on: self.
	index := 1.
	[readStream atEnd] whileFalse: 
			[| char |
			char := readStream next.
			char == $< 
				ifTrue: 
					[| nextChar |
					nextChar := readStream next asUppercase.
					nextChar == $N ifTrue: [newStream cr].
					nextChar == $T ifTrue: [newStream tab].
					nextChar isDigit 
						ifTrue: 
							[index := nextChar digitValue.
							[readStream atEnd or: [(nextChar := readStream next asUppercase) isDigit not]] 
								whileFalse: [index := index * 10 + nextChar digitValue]].
					nextChar == $? 
						ifTrue: 
							[| trueString falseString |
							trueString := readStream upTo: $:.
							falseString := readStream upTo: $>.
							readStream position: readStream position - 1.
							newStream nextPutAll: ((anArray at: index) ifTrue: [trueString] ifFalse: [falseString]).
							index := index + 1].
					nextChar == $P 
						ifTrue: 
							[(anArray at: index) printOn: newStream.
							index := index + 1].
					nextChar == $D 
						ifTrue: 
							[(anArray at: index) displayOn: newStream.
							index := index + 1].
					nextChar == $S 
						ifTrue: 
							[newStream nextPutAll: (anArray at: index).
							index := index + 1].
					readStream skipTo: $>]
				ifFalse: [newStream nextPut: (char == $% ifTrue: [readStream next] ifFalse: [char])]].
	^newStream contents!

findString: aString 
	"Answer the index of the <String> argument within the receiver. If the receiver does not
	contain aString, answer 0."

	^self findString: aString startingAt: 1!

findString: aString startingAt: anInteger 
	"Answer the index of the <String> argument within the receiver, starting at the <integer>
	argument. If the receiver does not contain aString, answer 0.

	Primitive Failure Reasons:/
		0	- anInteger is not a SmallInteger
		1	- anInteger is out of bounds (not in the range 1..receiver's indexable size) 
		2	- aString is not of the same class as the receiver.

	Implementation Note: The string search primitive is implemented using the 
	Boyer-Moore algorithm unless the receiver is less than 512 bytes long, in which
	case it isn't worth initializing the skip array in most cases, so a simple brute
	force search (much like that of the superclass) is used."

	<primitive: 149>
	^super indexOfSubCollection: aString startingAt: anInteger!

findString: aString startingAt: anInteger ignoreCase: aBoolean 
	"Answer the index of the <String> argument within the receiver, ignoring case differences, starting at the <integer>
	argument. If the receiver does not contain aString, answer 0."

	| meLower subLower |
	#todo.	"More efficient implementation needed."
	aBoolean ifFalse: [^self findString: aString startingAt: anInteger].
	meLower := self asLowercase.
	subLower := aString asLowercase.
	^meLower findString: subLower startingAt: anInteger!

formatWith: anObject
	"Answer a <readableString> which is a message formatted from the receiver (assumed to be a
	Win32 format string (see Win32 help)) with substituations from the remaining argument(s).
	See #formatWithArguments: for further details."

	^self formatWithArguments: {anObject}!

formatWith: anObject1 with: anObject2
	"Answer a <readableString> which is a message formatted from the receiver (assumed to be a
	Win32 format string (see Win32 help)) with substituations from the remaining argument(s).
	See #formatWithArguments: for further details."

	^self formatWithArguments: {anObject1. anObject2}!

formatWith: anObject1 with: anObject2 with: anObject3
	"Answer a <readableString> which is a message formatted from the receiver (assumed to be a
	Win32 format string (see Win32 help)) with substituations from the remaining argument(s).
	See #formatWithArguments: for further details."

	^self formatWithArguments: {anObject1. anObject2. anObject3}!

formatWith: anObject1 with: anObject2 with: anObject3 with: anObject4
	"Answer a <readableString> which is a message formatted from the receiver (assumed to be a
	Win32 format string (see Win32 help)) with substituations from the remaining argument(s).
	See #formatWithArguments: for further details."

	^self formatWithArguments: {anObject1. anObject2. anObject3. anObject4}!

formatWithArguments: aCollection 
	"Answer a <readableString> which is a message formatted from the receiver, assumed to be a
	Win32 format string (see
	http://msdn.microsoft.com/library/en-us/debug/base/formatmessage.asp for further
	information), with substitutions from the collection argument.

	For Example:
		'Hello %1!!03u!!' formatWith: 7
		'Hello %1!!s!!' formatWith: 'World'

	N.B. Floating point specifiers are NOT supported."

	"Note that although the #formatWith:&c family of methods have not been deprecated in Dolphin
	6, we recommend that, where possible, you use #expandMacrosXXX by preference."

	^KernelLibrary default 
		formatMessage: 0
		source: self
		flags: Win32Constants.FORMAT_MESSAGE_FROM_STRING
		withArguments: aCollection!

hash
	"Answer the <integer> hash value for the receiver. Note that this must be the same for equal
	objects, and therefore it should be the same for the same sequence of characters, regardless
	of encoding."

	^self asUtf8String hash!

hashCharacters
	"Private - Use the standard byte hashing algorithm to hash the characters of 
	the receiver. Used for doing lookup by value, e.g. in the Symbol table."

	<primitive: 106>
	^VMLibrary default hashBytes: self count: self size
!

indexOfAnyOf: aCollectionOfCharacters startingAt: anInteger 
	"Answer the one-based integer index of the first encountered element of the receiver which
	is equal to one of the characters in the argument, aCollectionOfCharacters, starting from
	the one-based <integer> index, start, in the receiver. If no occurrences are found, then
	answer 0."

	^aCollectionOfCharacters _indexOfAnyInString: self startingAt: anInteger!

indexOfSubCollection: targetSequence startingAt: start
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start. If there are no such occurrences
	(or the search sequence is empty), answer 0."

	<primitive: 149>
	^super indexOfSubCollection: targetSequence startingAt: start!

isLiteral
	"Answer whether the receiver can be represented as a literal (i.e. it has a printed
	representation which can be directly understood by the compiler)."

	^(self identityIncludes: $\0) not!

isString
	"Answer whether the receiver is a <String>."

	^true!

leftString: anInteger
	"Answer a new string comprising up to the leftmost anInteger characters of the receiver. 
	If the receiver has less than anInteger characters, then copy only those characters in the 
	receiver."

	^self first:( anInteger min: self size).
!

lines
	"Answer a SequenceableCollection containing the lines of the receiver (sequences of Characters
	separated by line delimiters. Blank lines are included.
	N.B. It is assumed that a line delimiter consists of two characters."

	^self subStrings: String lineDelimiter!

lookup: keyInteger
	"Answer the <Character> value named by the <Integer> argument, keyInteger, or nil if there is no such key in the receiver."

	<primitive: 63>
	^nil!

match: aString 
	"Answer whether the receiver (which may contain wildcard characters) matches the 
	<readableString> argument, ignoring case differences.
	Note that the pattern matching characters are *, matching any sequence of characters 
	and # matching any single character. The latter differs from the usual ? for historical
	reasons."

	^self match: aString ignoreCase: true!

match: aString ignoreCase: aBoolean
	"Answer whether the receiver (which may contain wildcard characters) matches the 
	<readableString> argument, aString, ignoring or respecting case differences depending
	on the <Boolean> argument, aBoolean.
	Note that the pattern matching characters are *, matching any sequence of characters 
	and # matching any single character. The latter differs from the usual ? for historical
	reasons."

	^aBoolean
		ifTrue: 
			[self asUppercase
				matchPatternFrom: 1
				in: aString asUppercase
				from: 1]
		ifFalse: 
			[self
				matchPatternFrom: 1
				in: aString
				from: 1]!

matchPatternFrom: patternStart in: aString from: sourceStart
	"Private - Answer whether the receiver matches aString (starting
	at patternStart in the receiver and sourceStart in source).
	The receiver may contain wildcards. Any differences in case between individual
	characters are ignored if the <boolean> argument is true."

	| p |
	patternStart > self size
		ifTrue: 
			["We've processed the whole pattern.
		If there is no more source, then we have a successful match,
		otherwise the match has failed."
			^sourceStart > aString size].

	"Get the next character from the pattern."
	(p := self at: patternStart) == $*
		ifTrue: 
			["Handle the $* in the pattern."
			sourceStart to: aString size + 1
				do: 
					[:s |
					(self
						matchPatternFrom: patternStart + 1
						in: aString
						from: s) ifTrue: [^true]].
			^false].
	sourceStart > aString size
		ifTrue: 
			["We've run out of source to be matched by the pattern."
			^false].
	(p == $# or: [p = (aString at: sourceStart)])
		ifTrue: 
			[^self
				matchPatternFrom: patternStart + 1
				in: aString
				from: sourceStart + 1].
	"A character has been matched exactly, or matched by a $#."
	^false!

max: operand
	"Answer the greater of the receiver and the <magnitude>, operand.
	 Implementation Note: #< is used since other relational operators are often implemented 
	in terms of it."

	^self < operand
		ifTrue:  [operand]
		ifFalse: [self]!

midString: anIntegerLength from: anIntegerStart
	"Answer a new string comprising the anIntegerLength characters starting
	at anIntegerStart in the receiver."

	^self copyFrom: anIntegerStart to: anIntegerStart + anIntegerLength - 1!

min: operand
	"Answer the lesser of the receiver and the <magnitude>, operand."

	^self < operand
		ifTrue:  [self]
		ifFalse: [operand]!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the inherited implementation to make use of the primitive."

	<primitive: 52>
	^anElement class == Character 
		ifTrue: [self basicIdentityIndexOf: anElement asInteger from: start to: stop]
		ifFalse: [0 "Can only contain characters"]!

occurrencesOf: anObject 
	"Answer how many of the receiver's elements are equal to anObject.
	Implementation Note: Override for improved performance (superclass
	uses a serial search, which is appropriate where #nextIndexOf:from:to:
	is implemented in the same way, but we have a fast primitive for that."

	^self 
		occurrencesOf: anObject
		from: 1
		to: self size!

occurrencesOf: anObject from: startInteger to: endInteger 
	| current occurrences |
	current := startInteger.
	occurrences := 0.
	[current > endInteger] whileFalse: 
			[| next |
			(next := self 
						nextIndexOf: anObject
						from: current
						to: endInteger) == 0 
				ifTrue: [^occurrences].
			occurrences := occurrences + 1.
			current := next + 1].
	^occurrences!

printOn: aStream
	"Append the receiver as a quoted string to aStream. The stream is expected to be over a
	String suitable for holding any Unicode code point (e.g. Utf8String or Utf16String).
	Internal quotes are doubled to produce a literal String. Null characters are printed as
	the Unicode Null symbol to avoid them being treated as null terminators by C api's."

	| chars |
	aStream nextPut: $'.
	chars := ReadStream on: self.
	[chars atEnd] whileFalse: 
			[| ch |
			(ch := chars next) == $\0
				ifTrue: [aStream nextPut: $\x2400]
				ifFalse: [(aStream nextPut: ch) == $' ifTrue: [aStream nextPut: $']]].
	aStream nextPut: $'!

refersToLiteral: anObject 
	"Private - Answer whether the receiver is a reference to the literal argument.
	This assumes that the receiver is in the role of a literal."

	^self = anObject!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:

	Primitive Failure Reasons:
		0 	- fromStart is not a SmallInteger.
		1	- stop is not a SmallInteger.
		2	- start is not a SmallInteger.
		3	- aByteObject is not a byte object
		4	- 'from' or 'to' interval is out-of-bounds
	"

	| fromOffset |
	<primitive: 142>
	fromOffset := fromStart - start.
	stop to: start by: -1 do: [:i | aByteObject basicAt: i put: (self byteAt: i + fromOffset)].
	^aByteObject!

replaceFrom: startInteger to: stopInteger with: aReadableString startingAt: startAtInteger
	"Replace the characters of the receiver at the <integer> index positions startInteger
	through stopInteger inclusive with consecutive characters of the <readableString>
	aReadableString beginning at <integer> index position startAtInteger. Answer the receiver."

	aReadableString class == self class
		ifTrue: 
			[aReadableString
				replaceBytesOf: self
				from: startInteger
				to: stopInteger
				startingAt: startAtInteger]
		ifFalse: 
			[| stream current |
			stream := aReadableString readStream.
			stream position: startAtInteger - 1.
			current := startInteger.
			[current > stopInteger] whileFalse: 
					[| ch |
					(ch := stream nextAvailable) isNil ifTrue: [BoundsError signalWith: stream position + 1].
					current := (self encodedAt: current put: ch) + 1]]!

reverse
	"Answer a copy of the receiver but with its elements in reverse order."

	^self subclassResponsibility!

rightString: anInteger
	"Answer a new string comprising the rightmost anInteger characters of the receiver."

	^self last: anInteger!

sameAs: comparand 
	"Answer whether the receiver collates the same as the <sequencedReadableCollection>
	 argument, operand, in the currently configured locale (case insensitively).
	Note that the ANSI standard definition of this function requires that the comparand
	complies with <readableString>, but we relax that to allow any <sequencedReadableCollection>
	although that collection must contain valid character code points, consequently the
	argument need not be the same class as the receiver."

	"Implementation note: Similar to superclass implementation of #=, but we allow different
	species, and we need to use collating of the currently configured locale. This is easiest
	if we first construct a String from the argument, since Win32 provides no simple
	function for comparing two characters, and that is easiest if we double dispatch."

	^comparand _sameAsString: self!

skipOver: aStream ignoreCase: ignoreCase
	"Private - Answer whether the receiver matches the contents of <sequencedStream> stream
	ignoring case differences if <boolean> ignoreCase is true. Answers true if a complete match is
	found, false otherwise. If a match is found then the stream is left pointing to the next character
	following the match. If not, the stream position is left unchanged."

	| originalPosition |
	ignoreCase ifFalse: [^self skipOver: aStream].
	originalPosition := aStream position.
	self do: 
			[:each | 
			(aStream atEnd or: [aStream next asUppercase ~= each asUppercase]) 
				ifTrue: 
					[aStream position: originalPosition.
					^false]].
	^true!

sprintfWith: arg1
	"Answer a String which is a message formatted from the receiver (assumed to be a C-printf
	format String) with substituations from the remaining argument(s).
	e.g.
	  'Hello %s' sprintfWith: 'World'.
	  'Hello %i %s' sprintfWith: 1 with: 'world'.

	Note: This is much faster than formatWith:."

	| n crt buf size format |
	crt := VMLibrary default.
	size := self size + 64.
	format := self asUtf8String.
	
	[buf := Utf8String new: size.
	n := crt
				_snprintf_s: buf
				bufferSize: size + 1
				count: size
				format: format
				with: arg1.
	n < 0]
			whileTrue: [size := size * 2].
	^buf copyFrom: 1 to: n!

sprintfWith: arg1 with: arg2
	"Answer a String which is a message formatted from the receiver (assumed to be a C-printf
	format String) with substituations from the arguments.
	e.g.

	  'Hello🐬  %s' sprintfWith: 'World'.
	  'Hello %i %s' sprintfWith: 1 with: 'world'.

	Note: This is much faster than formatWith:with:."

	| written lib buf size format |
	lib := VMLibrary default.
	size := self size + 128.
	format := self asUtf8String.
	
	[buf := Utf8String new: size.
	written := lib
				_snprintf_s: buf
				bufferSize: size + 1
				count: size
				format: format
				with: arg1
				with: arg2.
	written < 0]
			whileTrue: [size := size * 2].
	^buf copyFrom: 1 to: written!

storeOn: aStream 
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	self printOn: aStream!

strcspn: aString start: anInteger 
	^CRTLibrary default strcspn: self yourAddress + anInteger - 1 strCharSet: aString!

strlen
	"Answer the length of the receiver (in characters) up to the first null terminator. This may
	be less than its size if it contains embedded nulls. It can never be greater than the
	receiver's size."

	^self subclassResponsibility!

subStrings
	"Answer an Array containing the substrings of the receiver which are separated by one or 
	more Characters which answer true to #isSeparator."

	| stream answer wordStream |
	answer := OrderedCollection new.
	stream := self readStream.
	wordStream := self species writeStream: 10.
	[stream atEnd] whileFalse: 
			[| word next |
			wordStream reset.
			[stream atEnd or: [(next := stream next) isSeparator]] 
				whileFalse: [wordStream nextPut: next].
			word := wordStream contents.
			word notEmpty ifTrue: [answer add: word]].
	^answer asArray!

subStrings: separatorOrSeparators 
	"Answer an array containing the substrings of the receiver separated by occurrences
	of the <Character> or <readableString> argument, separator.
	Repeated separators produce empty strings in the array (cf. #subStrings).
	The separators are removed."

	#todo.	"This does not comply with the current ANSI definition, which expects that the
		argument is a <sequencedReadableCollection> of separators, any one of which may
		separate each token. For historical reasons the Dolphin implementation accepts also
		accepts a single character as the separator, and furthermore when passed a <String>
		it will use the entire string as a multi-character separator. A workaround is to
		convert the separator string to an array of <Character>."
	^separatorOrSeparators _separateSubStringsIn: self!

subStringsAnsi: separators
	"Answer an array containing the substrings of the receiver separated by occurrences
	of any of the <Character>s in the <collection> argument, separators.
	Repeated separators produce empty strings in the array (cf. #subStrings).
	The separators are removed."

	| start answer size end |
	size := self size.
	size == 0 ifTrue: [^Array new].
	end := self indexOfAnyOf: separators startingAt: 1.
	end == 0 ifTrue: [^{self}].
	answer := Array writeStream: 5.
	start := 1.
	
	[answer nextPut: (self copyFrom: start to: end - 1).
	start := end + 1.
	end := self indexOfAnyOf: separators startingAt: start.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	start <= size ifTrue: [answer nextPut: (self copyFrom: start to: size)].
	^answer contents!

titleCased
	"Answer a <readableString> which is a copy of the receiver but with the first letter of each major word capitalized."

	| kernel src dest len |
	kernel := KernelLibrary default.
	src := self asUtf16String.
	len := kernel
				lcMapString: Win32Constants.LOCALE_USER_DEFAULT
				dwMapFlags: Win32Constants.LCMAP_TITLECASE
				lpScrStr: src
				cchSrc: src size
				lpDestStr: nil
				cchDest: 0.
	len == 0 ifTrue: [kernel systemError].
	dest := Utf16String newFixed: len.
	kernel
		lcMapString: Win32Constants.LOCALE_USER_DEFAULT
		dwMapFlags: Win32Constants.LCMAP_TITLECASE
		lpScrStr: src
		cchSrc: src size
		lpDestStr: dest
		cchDest: len.
	^dest!

trimBlanks
	"Answer a copy of the receiver with leading and trailing white space removed."

	| size first last |
	size := self size.
	first := 1.
	[first < size and: [(self at: first) isSeparator]]
		whileTrue: [first := first + 1].
	last := size.
	[last >= first and: [(self at: last) isSeparator]]
		whileTrue: [last := last - 1].
	^self copyFrom: first to: last!

trimNulls
	"Answer a copy of the receiver with trailing nulls removed."

	| len |
	^(len := self strlen) = self size ifTrue: [self] ifFalse: [self copyFrom: 1 to: len]!

trueCompare: comparand
	"Private - Answer the receiver's <integer> collation order with respect to 
	the <readableString> argument, comparand. The answer is < 0 if
	the receiver is lexically before the argument, 0 if lexically equivalent, or
	> 0 if lexically after the argument. The comparision is CASE SENSITIVE.
	Implementation Note: lstrcmp() is used, which is a word based comparison
	which keeps, for example, hyphenated words together with equivalent
	non-hyphenated words. This is useful, but slower than a basic string collation.
	Also the comparison respects the currently configured default locale of the
	host operating system, and the performance may disappoint in some cases."

	| string1 string2 |
	<primitive: 51>
	string1 := self asUtf16String.
	string2 := comparand asUtf16String.
	^(KernelLibrary default
		compareString: Win32Constants.LOCALE_USER_DEFAULT
		dwCmpFlags: 0
		lpString1: string1
		cchCount1: string1 size
		lpString2: string2
		cchCount2: string2 size) - 2!

truncateTo: anInteger
	"Answer a <readableString> of at most anInteger characters from the receiver."

	^self size <= anInteger ifTrue: [self] ifFalse: [self copyFrom: 1 to: anInteger]!

unescapePercents
	"Answer a copy of the receiver with each %XY substring replaced by 
	the character with hex ASCII value XY and $+'s replaced by spaces."

	| answer pos oldPos |
	answer := self species writeStream: self size.
	oldPos := 1.
	
	[pos := self indexOfAnyOf: '+%' startingAt: oldPos.
	pos > 0] whileTrue: 
				[| char |
				answer 
					next: pos - oldPos
					putAll: self
					startingAt: oldPos.
				char := self at: pos.
				char == $+ 
					ifTrue: [answer nextPut: $\x20]
					ifFalse: 
						[(char == $% and: [pos + 2 <= self size]) 
							ifTrue: 
								[| digit1 digit2 |
								digit1 := (self at: pos + 1) asUppercase.
								digit2 := (self at: pos + 2) asUppercase.
								(digit1 isHexDigit and: [digit2 isHexDigit]) ifFalse: [^self].	"not really an escaped string"
								answer nextPut: (Character value: digit1 digitValue * 16 + digit2 digitValue).
								pos := pos + 2]
							ifFalse: [answer nextPut: char]].
				oldPos := pos + 1].
	answer 
		next: self size - oldPos + 1
		putAll: self
		startingAt: oldPos.
	^answer contents!

withNormalizedLineDelimiters
	"Answer a copy of the receiver with any line terminator convention converted to the windows (CR/LF) convention."

	| target eol stm |
	target := self species writeStream: self size.
	stm := self readStream.
	eol := self species lineDelimiter.
	stm do: 
			[:each |
			each == $\n
				ifTrue: [target nextPutAll: eol]
				ifFalse: 
					[each == $\r
						ifTrue: 
							[stm peekFor: $\n.
							target nextPutAll: eol]
						ifFalse: [target nextPut: each]]].
	^target contents! !
!String categoriesFor: #,!copying!public! !
!String categoriesFor: #_cmp:!comparing!private! !
!String categoriesFor: #_collate:!comparing!private! !
!String categoriesFor: #_indexOfAnyInString:startingAt:!double dispatch!private!searching! !
!String categoriesFor: #_sameAsString:!comparing!private! !
!String categoriesFor: #_separateSubStringsIn:!double dispatch!private! !
!String categoriesFor: #<!comparing!public! !
!String categoriesFor: #<=!comparing!public! !
!String categoriesFor: #=!comparing!public! !
!String categoriesFor: #>!comparing!public! !
!String categoriesFor: #>=!comparing!public! !
!String categoriesFor: #appendToStream:!double dispatch!private! !
!String categoriesFor: #asAnsiString!converting!public! !
!String categoriesFor: #asByteArray!converting!public! !
!String categoriesFor: #asLowercase!converting!public! !
!String categoriesFor: #asNumber!converting!public! !
!String categoriesFor: #asPhrase!converting!public! !
!String categoriesFor: #asResourceId!converting!public! !
!String categoriesFor: #asString!converting!public! !
!String categoriesFor: #asSymbol!converting!public! !
!String categoriesFor: #asUIntPtr!converting!public! !
!String categoriesFor: #asUppercase!converting!public! !
!String categoriesFor: #asUtf16String!converting!public! !
!String categoriesFor: #asUtf8String!converting!public! !
!String categoriesFor: #at:!accessing!public! !
!String categoriesFor: #at:ifAbsent:!accessing!public! !
!String categoriesFor: #at:put:!accessing!public! !
!String categoriesFor: #beginsWith:!comparing!public! !
!String categoriesFor: #beginsWith:ignoreCase:!comparing!public! !
!String categoriesFor: #between:and:!comparing!public! !
!String categoriesFor: #byteAt:!accessing!public! !
!String categoriesFor: #byteAt:put:!accessing!public! !
!String categoriesFor: #byteSize!accessing!private! !
!String categoriesFor: #capitalized!converting!public! !
!String categoriesFor: #codePage!constants!public! !
!String categoriesFor: #contains:!public! !
!String categoriesFor: #copyToBuffer:ofSize:!constants!copying!private! !
!String categoriesFor: #decodeNextAvailable:from:!encode/decode!private! !
!String categoriesFor: #decodeNextFrom:!encode/decode!private! !
!String categoriesFor: #displayOn:!printing!public! !
!String categoriesFor: #displayString!printing!public! !
!String categoriesFor: #encodeOn:put:!encode/decode!private! !
!String categoriesFor: #encoding!constants!public! !
!String categoriesFor: #equals:!comparing!public! !
!String categoriesFor: #expandMacros!printing!public! !
!String categoriesFor: #expandMacrosWith:!printing!public! !
!String categoriesFor: #expandMacrosWith:with:!printing!public! !
!String categoriesFor: #expandMacrosWith:with:with:!printing!public! !
!String categoriesFor: #expandMacrosWith:with:with:with:!printing!public! !
!String categoriesFor: #expandMacrosWithArguments:!printing!public! !
!String categoriesFor: #findString:!public!searching! !
!String categoriesFor: #findString:startingAt:!public!searching! !
!String categoriesFor: #findString:startingAt:ignoreCase:!public!searching! !
!String categoriesFor: #formatWith:!printing!public! !
!String categoriesFor: #formatWith:with:!printing!public! !
!String categoriesFor: #formatWith:with:with:!printing!public! !
!String categoriesFor: #formatWith:with:with:with:!printing!public! !
!String categoriesFor: #formatWithArguments:!printing!public! !
!String categoriesFor: #hash!comparing!public! !
!String categoriesFor: #hashCharacters!comparing!private! !
!String categoriesFor: #indexOfAnyOf:startingAt:!public!searching! !
!String categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!String categoriesFor: #isLiteral!public!testing! !
!String categoriesFor: #isString!public!testing! !
!String categoriesFor: #leftString:!copying!public! !
!String categoriesFor: #lines!copying!public! !
!String categoriesFor: #lookup:!accessing!public! !
!String categoriesFor: #match:!public!searching! !
!String categoriesFor: #match:ignoreCase:!public!searching! !
!String categoriesFor: #matchPatternFrom:in:from:!private!searching! !
!String categoriesFor: #max:!comparing!public! !
!String categoriesFor: #midString:from:!copying!public! !
!String categoriesFor: #min:!comparing!public! !
!String categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!String categoriesFor: #occurrencesOf:!public!searching! !
!String categoriesFor: #occurrencesOf:from:to:!public!searching! !
!String categoriesFor: #printOn:!printing!public! !
!String categoriesFor: #refersToLiteral:!private!testing! !
!String categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!private! !
!String categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!String categoriesFor: #reverse!copying!public! !
!String categoriesFor: #rightString:!copying!public! !
!String categoriesFor: #sameAs:!comparing!public! !
!String categoriesFor: #skipOver:ignoreCase:!private!searching! !
!String categoriesFor: #sprintfWith:!printing!public! !
!String categoriesFor: #sprintfWith:with:!printing!public! !
!String categoriesFor: #storeOn:!printing!public! !
!String categoriesFor: #strcspn:start:!private!searching! !
!String categoriesFor: #strlen!accessing!private! !
!String categoriesFor: #subStrings!copying!public! !
!String categoriesFor: #subStrings:!copying!public! !
!String categoriesFor: #subStringsAnsi:!copying!public! !
!String categoriesFor: #titleCased!converting!public! !
!String categoriesFor: #trimBlanks!copying!public! !
!String categoriesFor: #trimNulls!copying!public! !
!String categoriesFor: #trueCompare:!comparing!private! !
!String categoriesFor: #truncateTo:!converting!public! !
!String categoriesFor: #unescapePercents!operations!public! !
!String categoriesFor: #withNormalizedLineDelimiters!converting!public! !

String methodProtocol: #readableString attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #asLowercase #asString #asSymbol #asUppercase #at: #at:ifAbsent: #before: #between:and: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #do: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #keysAndValuesDo: #last #max: #min: #reverse #reverseDo: #sameAs: #subStrings: #with:do:)!
String methodProtocol: #String attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asLowercase #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #asString #asSymbol #asUppercase #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #between:and: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #max: #min: #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #sameAs: #select: #size #subStrings: #with:do:)!

!String class methodsFor!

ansiClass
	"Answer the class of String to use for ANSI-encoded strings."

	^AnsiString!

basicEncoding
	^self extraInstanceSpec!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	"Ideally this should be fixed to Windows-1252, as the current code page may vary by machine
	and so is not suitable for persisted strings, but historically we have used the current ANSI
	code page because the Win32 'A' apis do. In order to continue to interpret pre-existing
	strings as before on any particular users machine, this will be the machine's current code
	page. If, however, the machine's code page is a multi-byte code page, then it will be
	Windows-1252 instead, because Dolphin's ANSI string implementation does not work correctly
	with multi-byte strings anyway. Going forwards the use of Unicode strings (e.g. Utf8String)
	is recommended."

	^Character.AnsiCodePage!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^1!

empty
	"Answer an empty String instance. It is shared and should not be modified.
	N.B. The compiler generates reference to a shared empty string in any case
	so there should never be more than one empty literal string."

	^empty!

encoding
	"Answer a <Symbol> naming the encoding of instances of the receiver, which will be one of #ansi, #utf8, #utf16 or #utf32."

	^self encodingName: self basicEncoding!

encodingName: anInteger
	^String encodings at: anInteger + 1!

encodings
	^#(#ansi #utf8 #utf16le #utf32)!

errorInvalidCodePoint: codePoint
	^self error: 'Invalid code point ' , codePoint hex!

formatMessage: anIntegerId in: hModule withArguments: arguments
	"Answer a String which is a message formatted from the format String with the
	specified id in the specified module, with arguments substituted from
	argumentCollection."

	^(self fromId: anIntegerId in: hModule) formatWithArguments: arguments!

formatMessage: anIntegerId withArguments: argumentCollection
	"Answer a String which is a message formatted from the format String with the
	specified id in the specified module, with arguments substituted from
	argumentCollection."

	^self 
		formatMessage: anIntegerId
		in: SessionManager current defaultResourceLibrary
		withArguments: argumentCollection!

formatSystemMessage: anIntegerId withArguments: arguments
	"Answer a String which is a message formatted from the format String with the
	specified id in the specified module, with arguments substituted from
	argumentCollection."

	^KernelLibrary default
		formatMessage: anIntegerId
		source: 0
		flags: Win32Constants.FORMAT_MESSAGE_FROM_SYSTEM
		withArguments: arguments!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	^self subclassResponsibility!

fromAddress: anAddress length: anInteger
	"Answer a new String, of length anInteger, copied from the first anInteger
	bytes of aString."

	^anAddress isNull 
		ifFalse: [
			anAddress asExternalAddress
				replaceBytesOf: (self new: anInteger)
				from: 1 to: anInteger startingAt: 1 ]
!

fromAtomId: anInteger
	"Answer a new string which is a copy of the atom with id anInteger."

	^self fromString: (Utf16String fromAtomId: anInteger)!

fromByteArray: aByteArray
	^self
		fromByteArray: aByteArray
		length: aByteArray size // self elementSize
		startingAt: 1!

fromByteArray: aByteArray length: cchInteger
	"Answer a new instance of the receiver of length (in character code units), cchInteger,
	copied from the bytes of <ByteArray>, aByteArray, starting with that at the <integer> byte
	index , indexInteger. Note that the length is specified in characters (because it specifies
	the size of the new String), and the starting index in bytes (because it is an offset into a
	ByteArray)."

	^self
		fromByteArray: aByteArray
		length: cchInteger
		startingAt: 1!

fromByteArray: aByteArray length: cchInteger startingAt: indexInteger
	"Answer a new instance of the receiver of length (in character code units), cchInteger,
	copied from the bytes of <ByteArray>, aByteArray, starting with that at the <integer> byte
	index , indexInteger. Note that the length is specified in characters (because it specifies
	the size of the new String), and the starting index in bytes (because it is an offset into a
	ByteArray)."

	| answer |
	answer := self basicNew: cchInteger.
	aByteArray
		replaceBytesOf: answer
		from: 1
		to: cchInteger * self elementSize
		startingAt: indexInteger.
	^answer!

fromByteArray: aByteArray startingAt: indexInteger
	"Answer a new instance of the receiver copied from the bytes of <ByteArray>, aByteArray,
	starting with that at the <integer> byte index , indexInteger. The length of the new
	instance will depend on the size of the ByteArray, the starting index, and the string
	encoding element size."

	^self
		fromByteArray: aByteArray
		length: (aByteArray size - indexInteger + 1) // self elementSize
		startingAt: indexInteger!

fromGlobalHandle: anExternalHandle
	"Answer a new String instantiated from the contents of the global heap block with the specified handle."

	| kernel p |
	kernel := KernelLibrary default.
	p := kernel globalLock: anExternalHandle.
	^[self fromAddress: p] ensure: [kernel globalUnlock: anExternalHandle]!

fromId: anInteger
	"Answer a new String loaded from resources."

	^self fromId: anInteger in: SessionManager current defaultResourceLibrary!

fromId: resourceId in: anExternalLibraryOrHandle
	"Answer a new String loaded from the resources of the module with handle, anExternalLibraryOrHandle."

	| answer len |
	answer := Utf16String newFixed: 256.
	(len := UserLibrary default
				loadString: anExternalLibraryOrHandle asParameter
				uID: resourceId asResourceId
				lpBuffer: answer
				nBufferMax: answer size) isZero
		ifTrue: [UserLibrary default systemError].
	^answer leftString: len!

fromString: aString
	"Answer an instance of the receiver containing the same characters as the argument, aString."

	^aString asUtf8String!

fromUtf16String: anAddressOrUtf16String
	"Answer a byte-encoded String representation of the UTF16 string at the specified
	address."

	| answer size lib cp |
	lib := KernelLibrary default.
	cp := self codePage.
	(size := lib
				wideCharToMultiByte: cp
				dwFlags: 0
				lpWideCharStr: anAddressOrUtf16String
				cchWideChar: -1
				lpMultiByteStr: nil
				cchMultiByte: 0
				lpDefaultChar: nil
				lpUsedDefaultChar: nil) == 0
		ifTrue: [lib systemError].
	answer := self new: size - 1.
	lib
		wideCharToMultiByte: cp
		dwFlags: 0
		lpWideCharStr: anAddressOrUtf16String
		cchWideChar: -1
		lpMultiByteStr: answer
		cchMultiByte: answer basicSize
		lpDefaultChar: nil
		lpUsedDefaultChar: nil.
	^answer!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	empty := ''.
	self
		addClassConstant: 'EncodingAnsi' value: 0;
		addClassConstant: 'EncodingUtf8' value: 1;
		addClassConstant: 'EncodingUtf16' value: 2;
		addClassConstant: 'EncodingUtf32' value: 3.
!

installedCodePages
	"Answer the names of all code pages installed on the host system."

	^self systemCodePages: Win32Constants.CP_INSTALLED!

lineDelimiter
	"Answer an immutable instance of the receiver containing the host system 
	end-of-line character sequence (a Cr/Lf pair).
	This is a method of String rather than Character because the answer will 
	always be a String."

	^LineDelimiter!

new: aSmallInteger
	"Answer an instance of the default string class of sufficient size to hold the specified number of code units."

	<primitive: 71>
	self isNonInstantiable ifTrue: [^Utf8String new: aSmallInteger].
	^self primitiveFailed!

newFixed: aSmallInteger
	"Answer a sub-instance of the receiver of size aSmallInteger bytes (this method is 
	only valid for byte objects). The object is allocated from the fixed memory heap
	and will not move in memory (objects allocated with primitive 71 are free to 
	move to assist garbage collection, whereas those allocated with primitive 76 
	are in a traditional fixed heap)."

	<primitive: 76>
	self isNonInstantiable ifTrue: [^Utf8String newFixed: aSmallInteger].
	^self primitiveFailed!

readFrom: aStream 
	"Answer a <String> read from the <gettableStream>, aStream
	Note that the string is expected to be in Smalltalk literal form, i.e.
	single quoted and with embedded quotes doubled."

	| answer |
	answer := self writeStream: 16.
	aStream skipTo: $'.	"Skip any leading chars up to just after the first quote"
	[aStream atEnd] whileFalse: 
			[| ch |
			ch := aStream next.
			ch == $' 
				ifTrue: 
					[aStream atEnd ifTrue: [^answer contents].
					ch := aStream next.
					ch == $' 
						ifFalse: 
							["Single quote terminates string (else gobble the doubled quote)"

							aStream pop.
							^answer contents]].
			answer nextPut: ch].
	^answer contents!

stbConvertFrom: aSTBClassConversion
	"As of version 1, String is abstract and non-instantiable. We want to create AnsiString instances instead.
	This will only be used for reading very old (version 0) STB data, as after version 0 there is special case
	handling for Strings and they are automatically mapped to AnsiStrings."

	^[:data | AnsiString fromByteArray: data]!

stbVersion
	^1!

supportedCodePages
	"Answer the names of all code pages installed on the host system.
		self supportedCodePages
	"

	^self systemCodePages: Win32Constants.CP_SUPPORTED!

systemCodePages: anInteger
	"Private - Answer a collection of system locales, depending on the flags argument,
	anInteger. Note that this will take a while to run first time through as it causes the OS to
	load all the code page information."

	| enum ids kernel |
	ids := OrderedCollection new: 30.
	enum := ExternalCallback block: 
					[:codePage |
					ids addLast: codePage.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	kernel := KernelLibrary default.
	kernel enumSystemCodePages: enum asParameter dwFlags: anInteger.
	enum free.
	^ids collect: [:each | CPINFOEXW codePage: (Integer fromString: each)]!

tab
	"Answer an instance of the receiver containing a tab character."

	^##(self with: Character tab)!

utf16Class
	"Answer the class of String to use for UTF16-encoded strings."

	^Utf16String!

utf8Class
	"Answer the class of String to use for UTF8-encoded strings."

	^Utf16String!

with: element1
	"Answer a new instance of the receiver containing the single <Character> element, element1."

	^(self writeStream: 4)
		nextPut: element1;
		contents!

with: element1 with: element2
	"Answer an instance of the receiver containing the <Character> arguments as its elements"

	^(self writeStream: 2)
		nextPut: element1;
		nextPut: element2;
		contents!

with: element1 with: element2 with: element3
	"Answer an instance of the receiver containing the <Character> arguments as its elements"

	^(self writeStream: 3)
		nextPut: element1;
		nextPut: element2;
		nextPut: element3;
		contents!

with: element1 with: element2 with: element3 with: element4
	"Answer an instance of the receiver containing the <Character> arguments as its elements"

	^(self writeStream: 4)
		nextPut: element1;
		nextPut: element2;
		nextPut: element3;
		nextPut: element4;
		contents!

with: element1 with: element2 with: element3 with: element4 with: element5
	"Answer an instance of the receiver containing the <Character> arguments as its elements.
	N.B. This is not an ANSI standard method (up to 4 elements are supported by <Array factory>
	#with:&c messages, for more one must use #withAll:)."

	^(self writeStream: 5)
		nextPut: element1;
		nextPut: element2;
		nextPut: element3;
		nextPut: element4;
		nextPut: element5;
		contents!

withAll: newElements
	"Answer a new instance of the receiver containing all of the <Character> elements of the
	<collection> newElements."

	| stream |
	stream := self writeStream: 10.
	newElements do: [:each | stream nextPut: each].
	^stream contents! !
!String class categoriesFor: #ansiClass!constants!public! !
!String class categoriesFor: #basicEncoding!accessing!public! !
!String class categoriesFor: #codePage!constants!public! !
!String class categoriesFor: #elementSize!constants!public! !
!String class categoriesFor: #empty!instance creation!public! !
!String class categoriesFor: #encoding!constants!public! !
!String class categoriesFor: #encodingName:!enquiries!private! !
!String class categoriesFor: #encodings!constants!public! !
!String class categoriesFor: #errorInvalidCodePoint:!exceptions!private! !
!String class categoriesFor: #formatMessage:in:withArguments:!instance creation!public! !
!String class categoriesFor: #formatMessage:withArguments:!instance creation!public! !
!String class categoriesFor: #formatSystemMessage:withArguments:!instance creation!public! !
!String class categoriesFor: #fromAddress:!instance creation!public! !
!String class categoriesFor: #fromAddress:length:!instance creation!public! !
!String class categoriesFor: #fromAtomId:!instance creation!public! !
!String class categoriesFor: #fromByteArray:!public! !
!String class categoriesFor: #fromByteArray:length:!public! !
!String class categoriesFor: #fromByteArray:length:startingAt:!public! !
!String class categoriesFor: #fromByteArray:startingAt:!public! !
!String class categoriesFor: #fromGlobalHandle:!instance creation!public! !
!String class categoriesFor: #fromId:!instance creation!public! !
!String class categoriesFor: #fromId:in:!instance creation!public! !
!String class categoriesFor: #fromString:!instance creation!public! !
!String class categoriesFor: #fromUtf16String:!instance creation!public! !
!String class categoriesFor: #icon!constants!public! !
!String class categoriesFor: #initialize!class initialization!development!public! !
!String class categoriesFor: #installedCodePages!enquiries!public! !
!String class categoriesFor: #lineDelimiter!instance creation!public! !
!String class categoriesFor: #new:!instance creation!public! !
!String class categoriesFor: #newFixed:!instance creation!public! !
!String class categoriesFor: #readFrom:!instance creation!public! !
!String class categoriesFor: #stbConvertFrom:!binary filing!public! !
!String class categoriesFor: #stbVersion!binary filing!constants!public! !
!String class categoriesFor: #supportedCodePages!enquiries!public! !
!String class categoriesFor: #systemCodePages:!enquiries!private! !
!String class categoriesFor: #tab!instance creation!public! !
!String class categoriesFor: #utf16Class!constants!public! !
!String class categoriesFor: #utf8Class!constants!public! !
!String class categoriesFor: #with:!instance creation!public! !
!String class categoriesFor: #with:with:!instance creation!public! !
!String class categoriesFor: #with:with:with:!instance creation!public! !
!String class categoriesFor: #with:with:with:with:!instance creation!public! !
!String class categoriesFor: #with:with:with:with:with:!instance creation!public! !
!String class categoriesFor: #withAll:!instance creation!public! !

String class methodProtocol: #'String factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

