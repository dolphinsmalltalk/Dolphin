"Filed out from Dolphin Smalltalk 7"!

Core.ArrayedCollection variableByteSubclass: #'Core.String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'empty'
	classConstants: {
		'EncodingAnsi' -> 16r0.
		'Encodings' -> #(#ansi #utf8 #utf16le #utf32).
		'EncodingUtf16' -> 16r2.
		'EncodingUtf32' -> 16r3.
		'EncodingUtf8' -> 16r1.
		'LineDelimiter' -> '
'
	}!
Core.String guid: (Core.GUID fromString: '{87b4c514-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.String isNullTerminated: true!
Core.String isNonInstantiable: true!
Core.String comment: '`String` is the abstract class of `ArrayedCollection`s representing strings of `Character`s (although note that the Character''s represent code units when accessed by index, and may not constitute a full Unicode code point). 

String has subclasses for strings in the most common encodings, e.g. Ansi (`AnsiString`), UTF-8 (`Utf8String`), and UTF-16LE (`Utf16String`). 

The default and preferred string type is `Utf8String`, representing UTF-8 encoded strings, however many Windows APIs will expect to be passed (and will return) UTF-16LE encoded strings. `Utf16String` is the concrete subclass to  represent UTF-16LE encoded strings. Conversion between the string encodings is easy and fast using `asAnsiString`, `asUtf8String` and `asUtf8String`, although when converting the Unicode encodings to `AnsiString`s some characters cannot be represented and so will be "lost" (i.e. substitued with the replacement character). When working with `WriteStream`s backed by strings it is not necessary to explicitly translate to the target encoding as the class library and VM primitives will transparently convert from whatever string encoding is written.

N.B. Dolphin Strings are, unlike Smalltalk-80 strings, null-terminated. Space for the null terminator is implicity included when a `String` is allocated, but is not reported when the size of the `String` is requested.

`String` complies with the following ANSI Smalltalk protocols:
 Object`
 magnitude
 collection
 sequencedReadableCollection
 sequencedCollection
 readableString
 String'!
!Core.String categoriesForClass!Collections-Text! !
!Core.String methodsFor!

, aSequencedReadableCollection
	"Answer a new <String> like the receiver (i.e. of the receiver's species but not necessarily
	the exact same class) containing the Characters of the receiver in their original order with
	Characters constructed from the elements of the <sequencedReadableCollection> argument
	appended in their original order, i.e. concatenate the argument to the receiver."

	<primitive: 218>
	^self class == aSequencedReadableCollection class
		ifTrue: 
			["For concatenation of the same string encoding we can use efficient array block copy operations"
			super , aSequencedReadableCollection]
		ifFalse: 
			["For mixed encoding, we stream into a Utf8String"
			(Utf8String writeStream: self size + aSequencedReadableCollection size)
				nextPutAll: self;
				nextPutAll: aSequencedReadableCollection;
				contents]!

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

	"Implementation Note: Double dispatched from String>>sameAs:. Works for any mix of encodings because <=> does."

	^self == aString or: [aString <=> self == 0]!

< aString
	"Answer whether the receiver is lexically less than the <readableString> argument, ignoring case, according to the implementation defined collation sequence (see <=>)."

	^self <=> aString < 0!

<< anObject
	"Expand the receiver with replacable arguments represented by anObject.
	anObject may be an individual object mapping to a single parameter (in which case this message is equivalent to #expandMacrosWith:),
	or a collection mapping to a collection of parameters (in which case this message is equivalent to #expandMacrosWithArguments:).

	See #expandMacrosWithArguments: for further details."

	^anObject expandMacrosIn: self!

<= aString
	"Answer whether the receiver is lexically less than or equal to the <readableString>, argument, ignoring case, according to the implementation defined collation sequence (see <=>)."

	"Note that this is the equivalent to 
		'self < comparand or: [self sameAs: comparand]'
	and NOT
		'self < comparand or: [self = comparand]
	since String>>= is case sensitive."

	^self <=> aString <= 0!

<===> aString
	"Answer the receiver's <integer> ORDINAL (i.e. binary) collation order with respect to the <readableString> argument.
	The answer is < 0 if the receiver is ordinally before the argument, 0 if ordinally equivalent, or > 0 if ordinally after the argument. 
	This comparison is fast and locale insensitive, however the ordering it provides isn't of use for non-technical purposes since it is based on the code unit values, and takes no account of character classifications."

	<primitive: 220>
	^self primitiveFailed: _failureCode!

<==> comparand
	"Answer the receiver's <integer> collation order with respect to the <readableString> argument, comparand. 
	Similar to the spaceship operator, <=>, but the comparison is comparison is CASE SENSITIVE."

	"Implementation Note: CompareString performs a word-based comparison which keeps, for example, hyphenated words together with equivalent non-hyphenated words. This is useful, but slower than a basic string collation.
	Also the comparison respects the currently configured default locale of the host operating system, and the performance may disappoint in some cases."

	<primitive: 51>
	| string1 string2 |
	string1 := self asUtf16String.
	string2 := comparand asUtf16String.
	^(OS.KernelLibrary default
		compareString: OS.NlsConstants.LOCALE_USER_DEFAULT
		dwCmpFlags: 0
		lpString1: string1
		cchCount1: string1 size
		lpString2: string2
		cchCount2: string2 size) - 2!

<=> aString
	"Answer the receiver's <integer> collation order with respect to the <readableString> argument. Colloquially known as the spaceship operator.
	The answer is < 0 if the receiver is lexically before the argument, 0 if lexically equivalent, or	> 0 if lexically after the argument. 
	The comparision is CASE INSENSITIVE and respects the currently configured default locale of the host operating system.
	Note that this can be a relatively complex comparison and may be substantially slower than a simple ordinal comparison."

	<primitive: 56>
	| string1 string2 |
	aString isString ifFalse: [^self error: 'Invalid comparand'].
	"The primitive works with any supported string encoding (ANSI, UTF-8 and UTF-16) and invokes the OS StringCompare function, in essence as follows:"
	string1 := self asUtf16String.
	string2 := aString asUtf16String.
	^(OS.KernelLibrary default
		compareString: OS.NlsConstants.LOCALE_USER_DEFAULT
		dwCmpFlags: OS.NlsConstants.NORM_IGNORECASE
		lpString1: string1
		cchCount1: string1 size
		lpString2: string2
		cchCount2: string2 size) - 2!

= anObject
	"Answer whether the receiver and the <Object> argument are both <String>s containing identical code points.
	Note that <Symbol>s are now considered equal to <String>s with the same characters.

	Primitive failure results:
		InvalidParameter1  	- anObject is not a null-terminated object.
		AssertionFailure		- anObject and/or receiver encoding not recognised."

	<primitive: 219>
	^self == anObject or: [anObject isString and: [self <===> anObject == 0]]!

> aString
	"Answer whether the receiver is lexically greater than the <readableString> argument, ignoring case, according to the implementation defined collation sequence (see <=>)."

	^self <=> aString > 0!

>= aString
	"Answer whether the receiver is lexically greater than or equal to the <readableString> argument, ignoring case, according to the implementation defined collation sequence (see <=>)."

	^self <=> aString >= 0!

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

asMethodCategory
	^MethodCategory name: self!

asNumber
	"Answer a Number constructed by interpreting the receiver's characters as the
	printString of a Number."

	^Number fromString: self!

asPhrase
	"Answer a <sequencedReadableCollection> of the 'words' in the receiver, as capitalized strings.
	The word boundaries are identified by colons (i.e. keywords) and capital letters."

	| stream last |
	stream := self copyingClass writeStream: self size + 10.
	self do: 
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

asQualifiedReference
	^BindingReference pathString: self!

asResourceId
	"On Windows wide string APIs will be expecting string resource names to be in UTF-16."

	^self asUtf16String!

associations
	"Answer a <sequencedReadableCollection> containing the receiver's associations, representing the keys (indices) and values (Characters) in the receiver."

	"Strings don't actually contains Associations so the result is built afresh each time and modifying its contents will not affect the original collection. However this is no different to the implementation for LookupTable/IdentityDictionary."

	| stream |
	stream := Array writeStream: self size.
	self keysAndValuesDo: [:eachKey :eachValue | stream nextPut: eachKey -> eachValue].
	^stream grabContents!

asString
	"Answer a <readableString> containing the same characters as the receiver,
	i.e. the receiver."

	^self!

asSymbol
	"Answer the <symbol> corresponding to the receiver."

	^Symbol intern: self asUtf8String!

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
	"Answer the <Character> with the code unit at the <integer> index, in the receiver."

	"Primitive Failure Reasons:
		InvalidParameter1	- aSmallInteger is not a SmallInteger
		OutOfBounds		- aSmallInteger out of bounds (not in the range 1..receiver's indexable size)"

	<primitive: 63>
	^self _primitiveError: _failureCode at: index!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	<primitive: 63>
	^(index > 0 and: [index <= self size]) ifTrue: [self at: index] ifFalse: [exceptionBlock value]!

at: anInteger put: aCharacter
	"Replace the character at index, anInteger, in the receiver with aCharacter."

	"Primitive Failure Reasons:
		InvalidParameter1	- index is not a SmallInteger
		OutOfBounds		- index out of bounds (not in the range 1..receiver's indexable size)
		InvalidParameter2	- aCharacter is not a Character."

	<primitive: 64>
	^self
		_primitiveError: _failureCode
		at: anInteger
		put: aCharacter!

beginsWith: comperand
	"Answer whether the receiver starts with the exact characters
	of the argument, comperand."

	<primitive: 224>
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
			[(OS.KernelLibrary default
				compareString: OS.NlsConstants.LOCALE_USER_DEFAULT
				dwCmpFlags: (aBoolean ifTrue: [OS.NlsConstants.NORM_IGNORECASE] ifFalse: [0])
				lpString1: string1
				cchCount1: cch
				lpString2: string2
				cchCount2: cch) == OS.NlsConstants.CSTR_EQUAL]!

between: min and: max
	"Answer whether the receiver is inclusively between the <magnitude> arguments, 
	min and max."

	^self >= min and: [self <= max]!

byteAt: anInteger
	"Answer the byte at offset anInteger in the receiver"

	<primitive: 60>
	^self basicAt: anInteger!

byteAt: aSmallInteger put: value
	"Replace the byte at the specified index in the receiver with the specified integer byte value."

	"Primitive Failure Reasons:
		InvalidParameter1	- aSmallInteger is not a SmallInteger
		OutOfBounds		- aSmallInteger out of bounds (not in the range 1..receiver's indexable size) 
		InvalidParameter2	- the argument, value, is not a SmallInteger.
		IntegerOutOfRange	- the argument is a SmallInteger, but not in the range [0..255]"

	<primitive: 61>
	^self
		_primitiveError: _failureCode
		at: aSmallInteger
		put: value!

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
	write := self copyingClass writeStream: size.
	read := self readStream.
	write nextPut: read next asUppercase.
	write nextPutAll: read upToEnd.
	^write contents!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	^self class codePage!

codePointsDo: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the full code point <Character> elements of the receiver. Answers the receiver. The elements are evaluated in sequence."

	self subclassResponsibility!

contains: aString
	"Answer whether the receiver contains the specified sub-string."

	^(self findString: aString startingAt: 1) ~~ 0!

copyReplaceAll: oldSequencedReadableCollection with: newSequencedReadableCollection
	^super copyReplaceAll: (self class coerceString: oldSequencedReadableCollection asString)
		with: (self class coerceString: newSequencedReadableCollection asString)!

copyToBuffer: anAddress ofSize: anInteger
	^self subclassResponsibility!

decodeAt: anInteger
	"Private - Answer the encoded object beginning at the specified position in the receiver."

	^self subclassResponsibility!

decodeNextAvailable: anInteger from: aReadStream
	"Private - Answer the next anInteger future sequence values of the <ReadStream>, aReadStream, or as
	many as are available before the end of stream."

	| newStream count next |
	newStream := self copyingClass writeStream: (count := anInteger).
	[count == 0 or: [(next := aReadStream nextAvailable) isNil]] whileFalse: 
			[newStream nextPut: next.
			count := count - 1].
	^newStream contents!

decodeNextFrom: aReadStream
	"Private - Answer the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	^self subclassResponsibility!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self!

displayString
	"Answer a String representation of the receiver in a form suitable for
	presentation to an end user.
	Implementation Note: This is implemented purely for performance reasons to
	avoid the Stream overhead when displaying strings because it is such a
	common operation."

	^self!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occuppied by the <Character> whose first code unit is at the specified index in the receiver. Throw an error if the code unit at anInteger is not either an ASCII code point or a UTF-8 lead surrogate"

	^self subclassResponsibility!

encodeOn: aWriteStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the character
	encoding of the receiver, e.g. for Utf8String, this would be the relevant sequence of 1 to 4
	UTF-8 encoded bytes necessary to represent the Unicode code point of the character."

	^self subclassResponsibility!

expandMacros
	"Expand the receiver with replacable arguments.
	See #expandMacrosWithArguments: for further details."

	^self expandMacrosWithArguments: #()!

expandMacrosIn: aString

	"Private - Expand aString with the replaceable argument represented by the receiver.

	Overridden here to avoid treating the receiver as a collection of multiple arguments"

	^aString expandMacrosWith: self!

expandMacrosWith: anObject
	"Expand the receiver with replacable arguments.
	See #expandMacrosWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject}!

expandMacrosWith: anObject with: anotherObject
	"Expand the receiver with replacable arguments.
	See #expandMacrosWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject. anotherObject}!

expandMacrosWith: anObject with: anotherObject with: thirdObject 
	"Expand the receiver with replacable arguments.
	See #expandMacrosWithArguments: for further details."

	^self expandMacrosWithArguments: {anObject. anotherObject. thirdObject}!

expandMacrosWith: anObject with: anotherObject with: thirdObject with: fourthObject 
	"Expand the receiver with replacable arguments.
	See #expandMacrosWithArguments: for further details."

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

	^self expandMacrosWithArguments: anArray locale: Locale userDefault!

expandMacrosWithArguments: anArray locale: aLocale
	"Expand the receiver with replaceable arguments.
	e.g.
		'Hello <D><N><1P> <D>' expandMacrosWithArguments: #('World' 1).
		'Hello <2?Good:Bad> <1S>' expandMacrosWithArguments: #('World' false)

	<nD> expands the nth parameter using it's #displayString for the <Locale>
	<nP> expands the nth parameter using it's #printString
	<nS> expands the nth parameter treating it as a <String>
	<N> expands as a newline combination
	<T> expands as a TAB
	<n?xxxx:yyyy> if the nth parameter is true expands to 'xxxx' else 'expands to yyyy'

	If n is omitted the default of 1 is used.	
	"

	| stream |
	stream := String writeStream: self size.
	stream locale: aLocale.
	self expandMacrosWithArguments: anArray on: stream.
	^stream contents!

expandMacrosWithArguments: anArray on: aPuttableStream
	"Expand the receiver with replaceable arguments from the <Array> argument onto the <puttableStream> argument.
	e.g.
		'Hello <D><N><1P> <D>' expandMacrosWithArguments: #('World' 1).
		'Hello <2?Good:Bad> <1S>' expandMacrosWithArguments: #('World' false)

	<nD> expands the nth parameter using it's #displayOn:
	<nP> expands the nth parameter using it's #printOn:
	<nS> expands the nth parameter treating it as a <String>
	<N> expands as a newline combination
	<T> expands as a TAB
	<n?xxxx:yyyy> if the nth parameter is true expands to 'xxxx' else 'expands to yyyy'

	If n is omitted the default of 1 is used.	
	"

	| readStream index char |
	readStream := ReadStream on: self.
	index := 1.
	[(char := readStream nextAvailable) isNil] whileFalse: 
			[char == $<
				ifTrue: 
					[| nextChar |
					nextChar := readStream next asUppercase.
					nextChar == $N ifTrue: [aPuttableStream cr].
					nextChar == $T ifTrue: [aPuttableStream tab].
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
							aPuttableStream nextPutAll: ((anArray at: index) ifTrue: [trueString] ifFalse: [falseString]).
							index := index + 1].
					nextChar == $P
						ifTrue: 
							[(anArray at: index) printOn: aPuttableStream.
							index := index + 1].
					nextChar == $D
						ifTrue: 
							[(anArray at: index) displayOn: aPuttableStream.
							index := index + 1].
					nextChar == $S
						ifTrue: 
							[aPuttableStream nextPutAll: (anArray at: index).
							index := index + 1].
					readStream skipTo: $>]
				ifFalse: [aPuttableStream nextPut: (char == $% ifTrue: [readStream next] ifFalse: [char])]]!

findString: aString 
	"Answer the index of the <String> argument within the receiver. If the receiver does not
	contain aString, answer 0."

	^self findString: aString startingAt: 1!

findString: aString startingAt: anInteger
	"Answer the index of the <String> argument within the receiver, starting at the <integer> argument. If the receiver does not contain aString, answer 0.

	Primitive Failure Reasons:
		InvalidParameter2	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 1..receiver's indexable size) 
		InvalidParameter1	- aString is not of the same class as the receiver.

	Implementation Note: The string search primitive is implemented using the Boyer-Moore algorithm unless the receiver is less than 512 bytes long, in which case it isn't worth initializing the skip array in most cases, so a simple brute force search (much like that of the superclass) is used."

	<primitive: 149>
	^self basicIndexOfSubCollection: (self class coerceString: aString) startingAt: anInteger!

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

	^OS.KernelLibrary default
		formatMessage: 0
		source: self
		flags: OS.Win32Constants.FORMAT_MESSAGE_FROM_STRING
		withArguments: aCollection!

hash
	"Answer the <integer> hash value for the receiver. Note that this must be the same for equal objects, and therefore it should be the same for the same sequence of characters, regardless of encoding.
	Currently the hash is a 32-bit FNV1a with the standard constants, folded to 30 bits to produce a positive <SmallInteger> hash value, but this is a choice subject to change."

	<primitive: 106>
	| utf8 hash |
	utf8 := self asUtf8String.
	hash := 2166136261.
	"FNV1a"
	1 to: utf8 size do: [:i | hash := (hash bitXor: (utf8 basicAt: i)) * 16777619 bitAnd: 16rFFFFFFFF].
	"Fold to 30 bits so is always positive SmallInteger"
	^(hash bitShift: VMConstants.SmallIntegerMax highBit negated)
		bitXor: (hash bitAnd: VMConstants.SmallIntegerMax)!

indexOfAnyOf: aCollectionOfCharacters startingAt: anInteger 
	"Answer the one-based integer index of the first encountered element of the receiver which
	is equal to one of the characters in the argument, aCollectionOfCharacters, starting from
	the one-based <integer> index, start, in the receiver. If no occurrences are found, then
	answer 0."

	^aCollectionOfCharacters _indexOfAnyInString: self startingAt: anInteger!

indexOfSubCollection: aSequencedReadableCollection startingAt: startInteger
	"Answer the <integer> index of the next occurrence within the receiver of the <sequencedReadableCollection> sub-sequence, starting at the specified <integer> index. If there are no such occurrences (or the search sequence is empty), answer 0."

	<primitive: 149>
	aSequencedReadableCollection isString
		ifTrue: 
			[| encoded |
			encoded := self class coerceString: aSequencedReadableCollection.
			encoded ~~ aSequencedReadableCollection
				ifTrue: [^self indexOfSubCollection: encoded startingAt: startInteger]].
	^self basicIndexOfSubCollection: aSequencedReadableCollection startingAt: startInteger!

isLiteral
	"Answer whether the receiver can be represented as a literal (i.e. it has a printed
	representation which can be directly understood by the compiler)."

	^(self identityIncludes: $\0) not!

isString
	"Answer whether the receiver is a <String>."

	^true!

leftString: anInteger
	"Answer a new string comprising up to the leftmost anInteger <Characters> of the receiver. 
	If the receiver has less than anInteger characters, then copy only those characters in the receiver."

	^self first: (anInteger min: self length)!

length
	"Answer the number of Unicode code-points in the receiver. Note that:
	- Strings in Dolphin are indexed by code-unit; to get the number of code units in a string send it the `size` message. The size of different types of string for the same set of Unicode code points will vary depending on the string's encoding.
	- The code-point count is not necessarily the same as the number of user-perceived characters in a string (aka grapheme clusters), as some grapheme clusters are composed from multiple code-points."

	"To be overridden by subclasses which do not have fixed-width encodings"
	^self size!

lines
	"Answer a SequenceableCollection containing the lines of the receiver (sequences of Characters
	separated by line delimiters. Blank lines are included.
	N.B. It is assumed that a line delimiter consists of two characters."

	^String lineDelimiter split: self!

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
	"Answer a new string comprising the anIntegerLength <Characters> starting at anIntegerStart in the receiver."

	^self copyFrom: anIntegerStart to: anIntegerStart + anIntegerLength - 1!

min: operand
	"Answer the lesser of the receiver and the <magnitude>, operand."

	^self < operand
		ifTrue:  [self]
		ifFalse: [operand]!

nextIdentityIndexOf: anObject from: startInteger to: stopInteger
	"Answer the index of the next occurrence of anObject in the receiver's indexable variables between startInteger and stopInteger inclusive. If there are no such occurrences, or the search interval is empty, answer 0."

	"The primitive will find Characters in any encoding of String. 

	Primitive failure reasons:
		InvalidParameter2	- startInteger is not a SmallInteger
		InvalidParameter3	- stopInteger is not a SmallInteger
		OutOfBounds		- one or other index if out of bounds (not in the range [1..receiver's size]
		AssertionFailure		- malformed receiver (unrecognised encoding)"

	<primitive: 52>
	^anObject class == Character
		ifTrue: 
			[self
				nextIndexOfCharacter: anObject
				from: startInteger
				to: stopInteger]
		ifFalse: 
			["Strings can only contain Characters"
			^0]!

nextIndexOf: anObject from: startInteger to: stopInteger
	"Answer the index of the next occurrence of anObject in the receiver's indexable variables between startInteger and stopInteger inclusive. If there are no such occurrences, or the search interval is empty, answer 0."

	"The primitive will find Characters in any encoding of String. 

	Primitive failure reasons:
		InvalidParameter2	- startInteger is not a SmallInteger
		InvalidParameter3	- stopInteger is not a SmallInteger
		OutOfBounds		- one or other index if out of bounds (not in the range [1..receiver's size]
		AssertionFailure		- malformed receiver (unrecognised encoding)"

	<primitive: 52>
	^anObject class == Character
		ifTrue: 
			[self
				nextIndexOfCharacter: anObject
				from: startInteger
				to: stopInteger]
		ifFalse: 
			["Strings can only contain Characters"
			^0]!

nextIndexOfCharacter: aCharacter from: startInteger to: stopInteger
	^self subclassResponsibility!

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

prevIndexOf: anObject from: hiInteger to: loInteger
	"Answer the <integer> index of the first occurrence of anElement in the receiver that is before index, hiInteger, but after index, loInteger. The range is inclusive. If there are no such occurrences, answer 0."

	| last next |
	last := 0.
	next := self
				nextIndexOf: anObject
				from: loInteger
				to: hiInteger.
	[next == 0 or: [next > hiInteger]] whileFalse: 
			[last := next.
			next := self
						nextIndexOf: anObject
						from: last + 1
						to: hiInteger].
	^last!

printOn: aStream
	"Append the receiver as a quoted string to aStream. The stream is expected to be over a
	String suitable for holding any Unicode code point (e.g. Utf8String or Utf16String).
	Internal quotes are doubled to produce a literal String. Null characters are printed as
	the Unicode Null symbol to avoid them being treated as null terminators by C api's."

	aStream nextPut: $'.
	self codePointsDo: 
			[:ch |
			ch == $\0
				ifTrue: [aStream nextPut: $\x2400]
				ifFalse: [(aStream nextPut: ch) == $' ifTrue: [aStream nextPut: $']]].
	aStream nextPut: $'!

refersToLiteral: anObject
	"Private - Answer whether the receiver is a reference to the literal argument.
	This assumes that the receiver is in the role of a literal."

	^self = anObject and: [anObject isSymbol not]!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:

	Primitive Failure Reasons:
		InvalidParameter1	- aByteObject is not a byte object
		InvalidParameter2	- start is not a SmallInteger.
		InvalidParameter3	- stop is not a SmallInteger.
		InvalidParameter4	- fromStart is not a SmallInteger.
		OutOfBounds		- 'from' or 'to' interval is out-of-bounds
	"

	<primitive: 142>
	| fromOffset |
	fromOffset := fromStart - start.
	stop to: start
		by: -1
		do: [:i | aByteObject basicAt: i put: (self byteAt: i + fromOffset)].
	^aByteObject!

replaceFrom: startInteger to: stopInteger with: aReadableString startingAt: startAtInteger
	"Replace the characters of the receiver at the <integer> index positions startInteger
	through stopInteger inclusive with consecutive characters of the <readableString>
	aReadableString beginning at <integer> index position startAtInteger. Answer the receiver."

	| sourceEncoding |
	sourceEncoding := aReadableString encoding.
	(sourceEncoding == #binary or: [sourceEncoding == self encoding])
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

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types.
	All of the various String encodings are really just implementations of the same basic type, and all are logically sequences of Characters."

	^String!

split: aReadableString
	"Answer an Array containing the substrings in aReadableString separated by the sequence of characters of the receiver."

	| start end answer subSize size |
	subSize := self size.
	size := aReadableString size.
	size == 0 ifTrue: [^#()].
	subSize == 1 ifTrue: [^(self at: 1) split: aReadableString].
	end := aReadableString findString: self startingAt: 1.
	end == 0 ifTrue: [^{aReadableString}].
	start := 1.
	answer := Array writeStream: 10.
	
	[answer nextPut: (aReadableString copyFrom: start to: end - 1).
	start := end + subSize.
	end := aReadableString findString: self startingAt: start.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	answer nextPut: (aReadableString copyFrom: start to: size).
	^answer contents!

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
	^OS.CRTLibrary default strcspn: self yourAddress + anInteger - 1 strCharSet: aString!

strlen
	"Answer the length of the receiver (in code units) up to the first null terminator. This may be less than its size if it contains embedded nulls. It can never be greater than the receiver's size."

	^OS.CRTLibrary default strlen: self!

subStrings
	"Answer an Array containing the substrings of the receiver which are separated by one or 
	more Characters which answer true to #isSeparator."

	| stream answer wordStream |
	answer := OrderedCollection new.
	stream := self readStream.
	wordStream := self copyingClass writeStream: 10.
	[stream atEnd] whileFalse: 
			[| word next |
			wordStream reset.
			[stream atEnd or: [(next := stream next) isSeparator]] whileFalse: [wordStream nextPut: next].
			word := wordStream contents.
			word notEmpty ifTrue: [answer add: word]].
	^answer asArray!

subStrings: separatorOrSeparators
	"Answer an array containing the substrings of the receiver separated by occurrences of the <Character> or <readableString> argument, separator.
	Repeated separators produce empty strings in the array (cf. #subStrings). The separators are removed."

	#todo. "N.B. This does not comply with the current ANSI definition, which expects that the argument is a <sequencedReadableCollection> of separators, any one of which may separate each token. In the next major release (7.2) this behaviour will be changed to be ANSI compliant. Also the historic asymmetric behaviour of ignoring a terminating separator will be corrected so that the operation behaves in the same was as Character>>split:"
	^separatorOrSeparators split: self!

subStringsAnsi: separators
	"Answer an array containing the substrings of the receiver separated by occurrences
	of any of the <Character>s in the <collection> argument, separators.
	Repeated separators produce empty strings in the array (cf. #subStrings).
	The separators are removed."

	| start answer size end |
	#deprecated.	"Will be removed in 7.2"
	size := self size.
	size == 0 ifTrue: [^{}].
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
	kernel := OS.KernelLibrary default.
	src := self asUtf16String.
	len := kernel
				lcMapString: OS.NlsConstants.LOCALE_USER_DEFAULT
				dwMapFlags: OS.NlsConstants.LCMAP_TITLECASE
				lpScrStr: src
				cchSrc: src size
				lpDestStr: nil
				cchDest: 0.
	len == 0 ifTrue: [kernel systemError].
	dest := Utf16String newFixed: len.
	kernel
		lcMapString: OS.NlsConstants.LOCALE_USER_DEFAULT
		dwMapFlags: OS.NlsConstants.LCMAP_TITLECASE
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

truncateTo: anInteger
	"Answer a <readableString> of at most anInteger characters from the receiver."

	^self size <= anInteger ifTrue: [self] ifFalse: [self copyFrom: 1 to: anInteger]!

unescapePercents
	Notification deprecated.
	^self urlDecoded!

urlDecoded
	"Asuming that receiver is a URI encoded representation from UTF-8 as specified in RFC3986,
	answer a <Utf8String> representing the unescaped (original) UTF-8 encoded text. If it is
	detected that the content is not URI-encoded (e.g. it contains %-prefixed character
	sequences where the next two characters are not hex digits, or it contains non-ASCII
	characters) then the original text is answered as UTF-8. The detection of non URI-encoded
	input is not 100% reliable, so it is an application responsibility to avoid double-decoding
	strings or decoding those that were never encoded in the first place."

	| ansi |
	ansi := self asAnsiString.
	^ansi = self ifTrue: [ansi urlDecoded] ifFalse: [self]!

urlEncoded
	"Percent encode the receiver as described in RFC 3986 (https://tools.ietf.org/html/rfc3986) Section 2.
	Not every part in a URI should be encoded as it is explained in section 2.4 so you should be cautious."

	^self asUtf8String urlEncoded!

withNormalizedLineDelimiters
	"Answer a copy of the receiver with any line terminator convention converted to the windows (CR/LF) convention."

	| target eol stm |
	target := self copyingClass writeStream: self size.
	stm := self readStream.
	eol := self copyingClass lineDelimiter.
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
!Core.String categoriesFor: #,!copying!public! !
!Core.String categoriesFor: #_indexOfAnyInString:startingAt:!double dispatch!private!searching! !
!Core.String categoriesFor: #_sameAsString:!comparing!private! !
!Core.String categoriesFor: #<!comparing!public! !
!Core.String categoriesFor: #<<!printing!public! !
!Core.String categoriesFor: #<=!comparing!public! !
!Core.String categoriesFor: #<===>!public! !
!Core.String categoriesFor: #<==>!comparing!public! !
!Core.String categoriesFor: #<=>!comparing!public! !
!Core.String categoriesFor: #=!comparing!public! !
!Core.String categoriesFor: #>!comparing!public! !
!Core.String categoriesFor: #>=!comparing!public! !
!Core.String categoriesFor: #appendToStream:!double dispatch!private! !
!Core.String categoriesFor: #asAnsiString!converting!public! !
!Core.String categoriesFor: #asByteArray!converting!public! !
!Core.String categoriesFor: #asLowercase!converting!public! !
!Core.String categoriesFor: #asMethodCategory!converting!public! !
!Core.String categoriesFor: #asNumber!converting!public! !
!Core.String categoriesFor: #asPhrase!converting!public! !
!Core.String categoriesFor: #asQualifiedReference!public! !
!Core.String categoriesFor: #asResourceId!converting!public! !
!Core.String categoriesFor: #associations!accessing!public! !
!Core.String categoriesFor: #asString!converting!public! !
!Core.String categoriesFor: #asSymbol!converting!public! !
!Core.String categoriesFor: #asUIntPtr!converting!public! !
!Core.String categoriesFor: #asUppercase!converting!public! !
!Core.String categoriesFor: #asUtf16String!converting!public! !
!Core.String categoriesFor: #asUtf8String!converting!public! !
!Core.String categoriesFor: #at:!accessing!public! !
!Core.String categoriesFor: #at:ifAbsent:!accessing!public! !
!Core.String categoriesFor: #at:put:!accessing!public! !
!Core.String categoriesFor: #beginsWith:!comparing!public! !
!Core.String categoriesFor: #beginsWith:ignoreCase:!comparing!public! !
!Core.String categoriesFor: #between:and:!comparing!public! !
!Core.String categoriesFor: #byteAt:!accessing!public! !
!Core.String categoriesFor: #byteAt:put:!accessing!public! !
!Core.String categoriesFor: #byteSize!accessing!private! !
!Core.String categoriesFor: #capitalized!converting!public! !
!Core.String categoriesFor: #codePage!constants!public! !
!Core.String categoriesFor: #codePointsDo:!public! !
!Core.String categoriesFor: #contains:!public!searching! !
!Core.String categoriesFor: #copyReplaceAll:with:!public! !
!Core.String categoriesFor: #copyToBuffer:ofSize:!constants!copying!private! !
!Core.String categoriesFor: #decodeAt:!encode/decode!private! !
!Core.String categoriesFor: #decodeNextAvailable:from:!encode/decode!private! !
!Core.String categoriesFor: #decodeNextFrom:!encode/decode!private! !
!Core.String categoriesFor: #displayOn:!printing!public! !
!Core.String categoriesFor: #displayString!printing!public! !
!Core.String categoriesFor: #encodedSizeAt:!encode/decode!private! !
!Core.String categoriesFor: #encodeOn:put:!encode/decode!private! !
!Core.String categoriesFor: #expandMacros!printing!public! !
!Core.String categoriesFor: #expandMacrosIn:!double dispatch!private! !
!Core.String categoriesFor: #expandMacrosWith:!printing!public! !
!Core.String categoriesFor: #expandMacrosWith:with:!printing!public! !
!Core.String categoriesFor: #expandMacrosWith:with:with:!printing!public! !
!Core.String categoriesFor: #expandMacrosWith:with:with:with:!printing!public! !
!Core.String categoriesFor: #expandMacrosWithArguments:!printing!public! !
!Core.String categoriesFor: #expandMacrosWithArguments:locale:!printing!public! !
!Core.String categoriesFor: #expandMacrosWithArguments:on:!printing!public! !
!Core.String categoriesFor: #findString:!public!searching! !
!Core.String categoriesFor: #findString:startingAt:!public!searching! !
!Core.String categoriesFor: #findString:startingAt:ignoreCase:!public!searching! !
!Core.String categoriesFor: #formatWith:!printing!public! !
!Core.String categoriesFor: #formatWith:with:!printing!public! !
!Core.String categoriesFor: #formatWith:with:with:!printing!public! !
!Core.String categoriesFor: #formatWith:with:with:with:!printing!public! !
!Core.String categoriesFor: #formatWithArguments:!printing!public! !
!Core.String categoriesFor: #hash!comparing!public! !
!Core.String categoriesFor: #indexOfAnyOf:startingAt:!public!searching! !
!Core.String categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!Core.String categoriesFor: #isLiteral!public!testing! !
!Core.String categoriesFor: #isString!public!testing! !
!Core.String categoriesFor: #leftString:!copying!public! !
!Core.String categoriesFor: #length!accessing!public! !
!Core.String categoriesFor: #lines!copying!public! !
!Core.String categoriesFor: #lookup:!accessing!public! !
!Core.String categoriesFor: #match:!public!searching! !
!Core.String categoriesFor: #match:ignoreCase:!public!searching! !
!Core.String categoriesFor: #matchPatternFrom:in:from:!private!searching! !
!Core.String categoriesFor: #max:!comparing!public! !
!Core.String categoriesFor: #midString:from:!copying!public! !
!Core.String categoriesFor: #min:!comparing!public! !
!Core.String categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!Core.String categoriesFor: #nextIndexOf:from:to:!public!searching! !
!Core.String categoriesFor: #nextIndexOfCharacter:from:to:!private!searching! !
!Core.String categoriesFor: #occurrencesOf:!public!searching! !
!Core.String categoriesFor: #occurrencesOf:from:to:!public!searching! !
!Core.String categoriesFor: #prevIndexOf:from:to:!public!searching! !
!Core.String categoriesFor: #printOn:!printing!public! !
!Core.String categoriesFor: #refersToLiteral:!private!testing! !
!Core.String categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!private! !
!Core.String categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!Core.String categoriesFor: #rightString:!copying!public! !
!Core.String categoriesFor: #sameAs:!comparing!public! !
!Core.String categoriesFor: #skipOver:ignoreCase:!private!searching! !
!Core.String categoriesFor: #species!accessing!public! !
!Core.String categoriesFor: #split:!public!tokenizing! !
!Core.String categoriesFor: #sprintfWith:!printing!public! !
!Core.String categoriesFor: #sprintfWith:with:!printing!public! !
!Core.String categoriesFor: #storeOn:!printing!public! !
!Core.String categoriesFor: #strcspn:start:!private!searching! !
!Core.String categoriesFor: #strlen!accessing!private! !
!Core.String categoriesFor: #subStrings!public!tokenizing! !
!Core.String categoriesFor: #subStrings:!public!tokenizing! !
!Core.String categoriesFor: #subStringsAnsi:!copying!public! !
!Core.String categoriesFor: #titleCased!converting!public! !
!Core.String categoriesFor: #trimBlanks!copying!public! !
!Core.String categoriesFor: #trimNulls!copying!public! !
!Core.String categoriesFor: #truncateTo:!converting!public! !
!Core.String categoriesFor: #unescapePercents!operations!public! !
!Core.String categoriesFor: #urlDecoded!operations!public! !
!Core.String categoriesFor: #urlEncoded!operations!public! !
!Core.String categoriesFor: #withNormalizedLineDelimiters!converting!public! !

Core.String methodProtocol: #readableString attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #asLowercase #asString #asSymbol #asUppercase #at: #at:ifAbsent: #before: #between:and: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #do: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #keysAndValuesDo: #last #max: #min: #reverse #reverseDo: #sameAs: #subStrings: #with:do:)!
Core.String methodProtocol: #String attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asLowercase #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #asString #asSymbol #asUppercase #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #between:and: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #max: #min: #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #sameAs: #select: #size #subStrings: #with:do:)!

!Core.String class methodsFor!

ansiClass
	"Answer the class of String to use for ANSI-encoded strings."

	^AnsiString!

basicEncoding
	^self extraInstanceSpec!

characterForCodeUnit: anInteger
	^self subclassResponsibility!

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

coerceString: aString
	"Answer a sub-instance of the receiver equivalent to (i.e. containing the same characters as) the <String> argument, aString."

	^aString asUtf8String!

cr
	^LineDelimiter!

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

	^Encodings at: self basicEncoding + 1!

encodingName: anInteger
	^Encodings at: anInteger + 1!

encodings
	^Encodings!

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

	^OS.KernelLibrary default
		formatMessage: anIntegerId
		source: 0
		flags: OS.Win32Constants.FORMAT_MESSAGE_FROM_SYSTEM
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

	^self coerceString: (Utf16String fromAtomId: anInteger)!

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
	kernel := OS.KernelLibrary default.
	p := kernel globalLock: anExternalHandle.
	^[self fromAddress: p] ensure: [kernel globalUnlock: anExternalHandle]!

fromId: anInteger
	"Answer a new String loaded from resources."

	^self fromId: anInteger in: SessionManager current defaultResourceLibrary!

fromId: resourceId in: anExternalLibraryOrHandle
	"Answer a new String loaded from the resources of the module with handle, anExternalLibraryOrHandle."

	| len pch |
	pch := External.Address new.
	(len := OS.UserLibrary default
				loadString: anExternalLibraryOrHandle asParameter
				uID: resourceId asResourceId
				lpBuffer: pch basicYourAddress
				nBufferMax: 0) isZero
		ifTrue: [OS.UserLibrary default systemError].
	^Utf16String fromAddress: pch length: len!

fromString: aString
	"Answer an instance of the receiver containing the same characters as the argument, aString."

	^self coerceString: aString!

fromUtf16String: anAddressOrUtf16String
	"Answer a byte-encoded String representation of the UTF16 string at the specified
	address."

	| answer size lib |
	lib := OS.KernelLibrary default.
	(size := lib
				wideCharToMultiByte: OS.NlsConstants.CP_UTF8
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
		wideCharToMultiByte: OS.NlsConstants.CP_UTF8
		dwFlags: 0
		lpWideCharStr: anAddressOrUtf16String
		cchWideChar: -1
		lpMultiByteStr: answer
		cchMultiByte: answer basicSize
		lpDefaultChar: nil
		lpUsedDefaultChar: nil.
	^answer!

initialize
	empty := ''!

installedCodePages
	"Answer the names of all code pages installed on the host system."

	^self systemCodePages: OS.NlsConstants.CP_INSTALLED!

lf
	^AnsiString with: $\n!

lineDelimiter
	"Answer an immutable instance of the receiver containing the host system 
	end-of-line character sequence (a Cr/Lf pair).
	This is a method of String rather than Character because the answer will 
	always be a String."

	^LineDelimiter!

new: aSmallInteger
	"Answer an instance of the default string class of sufficient size to hold the specified number of code units."

	<primitive: 71>
	_failureCode == _PrimitiveFailureCode.NonInstantiable
		ifTrue: 
			["Attempt to instantiate abstract class String, so answer an instance of the default concrete class, Utf8String"
			^Utf8String new: aSmallInteger].
	^self primitiveFailed: _failureCode!

newFixed: aSmallInteger
	"Answer a sub-instance of the receiver of size aSmallInteger bytes (this method is 
	only valid for byte objects). The object is allocated from the fixed memory heap
	and will not move in memory (objects allocated with primitive 71 are free to 
	move to assist garbage collection, whereas those allocated with primitive 76 
	are in a traditional fixed heap)."

	<primitive: 76>
	_failureCode == _PrimitiveFailureCode.NonInstantiable
		ifTrue: 
			["Attempt to instantiate abstract class String, so answer an instance of the default concrete class, Utf8String"
			^Utf8String newFixed: aSmallInteger].
	^self primitiveFailed: _failureCode!

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

smalltalkWriteStream
	"Answer a <WriteStream> on the a new empty sub-instance of the receiver, configured to display objects using <SmalltalkLocale> settings."

	^self smalltalkWriteStream: 32!

smalltalkWriteStream: anInteger
	"Answer a <WriteStream> on the a new sub-instance of the receiver with initialize size, anInteger, configured to display objects using <SmalltalkLocale> settings."

	^(WriteStream on: (Utf8String new: anInteger))
		locale: Locale smalltalk;
		yourself!

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

	^self systemCodePages: OS.NlsConstants.CP_SUPPORTED!

systemCodePages: anInteger
	"Private - Answer a collection of system locales, depending on the flags argument,
	anInteger. Note that this will take a while to run first time through as it causes the OS to
	load all the code page information."

	| enum ids kernel |
	ids := OrderedCollection new: 30.
	enum := External.Callback block: 
					[:codePage |
					ids addLast: codePage.
					true]
				descriptor: (External.FunctionDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	kernel := OS.KernelLibrary default.
	kernel enumSystemCodePages: enum asParameter dwFlags: anInteger.
	enum free.
	^ids collect: [:each | OS.CPINFOEXW codePage: (Integer fromString: each)]!

tab
	"Answer an instance of the receiver containing a tab character."

	^##(self with: Character tab)!

utf16Class
	"Answer the class of String to use for UTF16-encoded strings."

	^Utf16String!

utf8Class
	"Answer the class of String to use for UTF8-encoded strings."

	^Utf16String!

with: character
	"Answer a new instance of the receiver containing the single <Character> element, element1."

	^(self writeStream: 2)
		nextPut: character;
		contents!

with: firstCharacter with: secondCharacter
	"Answer an instance of the receiver containing the <Character> arguments as its elements"

	^(self writeStream: 4)
		nextPut: firstCharacter;
		nextPut: secondCharacter;
		contents!

with: firstCharacter with: secondCharacter with: thirdCharacter
	"Answer an instance of the receiver containing the <Character> arguments as its elements"

	^(self writeStream: 6)
		nextPut: firstCharacter;
		nextPut: secondCharacter;
		nextPut: thirdCharacter;
		contents!

with: firstCharacter with: secondCharacter with: thirdCharacter with: fourthCharacter
	"Answer an instance of the receiver containing the <Character> arguments as its elements"

	^(self writeStream: 8)
		nextPut: firstCharacter;
		nextPut: secondCharacter;
		nextPut: thirdCharacter;
		nextPut: fourthCharacter;
		contents!

with: firstCharacter with: secondCharacter with: thirdCharacter with: fourthCharacter with: fifthCharacter
	"Answer an instance of the receiver containing the <Character> arguments as its elements.
	N.B. This is not an ANSI standard method (up to 4 elements are supported by <Array factory>
	#with:&c messages, for more one must use #withAll:)."

	^(self writeStream: 10)
		nextPut: firstCharacter;
		nextPut: secondCharacter;
		nextPut: thirdCharacter;
		nextPut: fourthCharacter;
		nextPut: fifthCharacter;
		contents!

withAll: aCollectionOfCharacters
	"Answer a new instance of the receiver containing all of the <Character> elements of the <collection>, aCollectionOfCharacters."

	| stream |
	stream := self writeStream: aCollectionOfCharacters size.
	aCollectionOfCharacters do: [:each | stream nextPut: each].
	^stream grabContents! !
!Core.String class categoriesFor: #ansiClass!constants!public! !
!Core.String class categoriesFor: #basicEncoding!accessing!public! !
!Core.String class categoriesFor: #characterForCodeUnit:!enquiries!public! !
!Core.String class categoriesFor: #codePage!constants!public! !
!Core.String class categoriesFor: #coerceString:!instance creation!public! !
!Core.String class categoriesFor: #cr!constants!public! !
!Core.String class categoriesFor: #elementSize!constants!public! !
!Core.String class categoriesFor: #empty!instance creation!public! !
!Core.String class categoriesFor: #encoding!constants!public! !
!Core.String class categoriesFor: #encodingName:!enquiries!private! !
!Core.String class categoriesFor: #encodings!constants!public! !
!Core.String class categoriesFor: #errorInvalidCodePoint:!exceptions!private! !
!Core.String class categoriesFor: #formatMessage:in:withArguments:!instance creation!public! !
!Core.String class categoriesFor: #formatMessage:withArguments:!instance creation!public! !
!Core.String class categoriesFor: #formatSystemMessage:withArguments:!instance creation!public! !
!Core.String class categoriesFor: #fromAddress:!instance creation!public! !
!Core.String class categoriesFor: #fromAddress:length:!instance creation!public! !
!Core.String class categoriesFor: #fromAtomId:!instance creation!public! !
!Core.String class categoriesFor: #fromByteArray:!instance creation!public! !
!Core.String class categoriesFor: #fromByteArray:length:!instance creation!public! !
!Core.String class categoriesFor: #fromByteArray:length:startingAt:!instance creation!public! !
!Core.String class categoriesFor: #fromByteArray:startingAt:!instance creation!public! !
!Core.String class categoriesFor: #fromGlobalHandle:!instance creation!public! !
!Core.String class categoriesFor: #fromId:!instance creation!public! !
!Core.String class categoriesFor: #fromId:in:!instance creation!public! !
!Core.String class categoriesFor: #fromString:!instance creation!public! !
!Core.String class categoriesFor: #fromUtf16String:!instance creation!public! !
!Core.String class categoriesFor: #initialize!class initialization!development!public! !
!Core.String class categoriesFor: #installedCodePages!enquiries!public! !
!Core.String class categoriesFor: #lf!constants!public! !
!Core.String class categoriesFor: #lineDelimiter!instance creation!public! !
!Core.String class categoriesFor: #new:!instance creation!public! !
!Core.String class categoriesFor: #newFixed:!instance creation!public! !
!Core.String class categoriesFor: #readFrom:!instance creation!public! !
!Core.String class categoriesFor: #smalltalkWriteStream!instance creation!public!streaming! !
!Core.String class categoriesFor: #smalltalkWriteStream:!instance creation!public!streaming! !
!Core.String class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Core.String class categoriesFor: #stbVersion!binary filing!constants!public! !
!Core.String class categoriesFor: #supportedCodePages!enquiries!public! !
!Core.String class categoriesFor: #systemCodePages:!enquiries!private! !
!Core.String class categoriesFor: #tab!instance creation!public! !
!Core.String class categoriesFor: #utf16Class!constants!public! !
!Core.String class categoriesFor: #utf8Class!constants!public! !
!Core.String class categoriesFor: #with:!instance creation!public! !
!Core.String class categoriesFor: #with:with:!instance creation!public! !
!Core.String class categoriesFor: #with:with:with:!instance creation!public! !
!Core.String class categoriesFor: #with:with:with:with:!instance creation!public! !
!Core.String class categoriesFor: #with:with:with:with:with:!instance creation!public! !
!Core.String class categoriesFor: #withAll:!instance creation!public! !

Core.String class methodProtocol: #'String factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

