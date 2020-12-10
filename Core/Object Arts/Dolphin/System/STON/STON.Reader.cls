"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'STON.Reader'
	instanceVariableNames: 'readStream objects classes stringStream acceptUnknownClasses newLine convertNewLines classInstVarMaps currentCharacter objectProperties renamedClasses'
	classVariableNames: 'EscapeChars'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'HexDigitValues' -> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 16r0 16r1 16r2 16r3 16r4 16r5 16r6 16r7 16r8 16r9 nil nil nil nil nil nil nil 16rA 16rB 16rC 16rD 16rE 16rF nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 16rA 16rB 16rC 16rD 16rE 16rF)
	}!
STON.Reader guid: (Core.GUID fromString: '{d393ea51-a9cb-4a9f-bdc2-477e3bb22712}')!
STON.Reader comment: 'STON.Reader materializes objects using the Smalltalk Object Notation format.

This parser is backwards compatible with standard JSON.

Customization options are:

- acceptUnknownClasses <Boolean> default is false
	if true, unknown class names are allowed, the standard #mapClass (Dictionary) is instanciated and the class name is added under #classNameKey (#className)
	if false, unknown class names result in a NotFound error
- convertNewLines <Boolean> default is false
	if true, any unescaped EOL sequence CR, LF or CRLF inside strings or symbols is read and converted as the chosen EOL sequence
	if false, CR, LF and CRLF are read unmodified
- newLine <String> default is String cr
	sequence to use as EOL

h2. Dolphin Specifics

We dispense with the naïve approach of patching up forward references encountered during the deserialization process by walking the objects as this quickly heads off into bits of the Object graph that were referenced from the STON serialisation, but not included in it. The `stonContainsSubObjects` mechanism is too simplistic and error prone to prevent this in all but very constrained object graphs with a known set of classes. It''s also rather slow. Neither of these things are suitable characteristics for a general purpose object serialization mechanism. To top it all, it isn''t actually necessary as the graph can only contain backwards references, never forwards references, as a function of the way it is built by visiting objects recursively. The numbered cross references in a STON stream are most often referencing a previously seen object that is known and recorded in the objects list and so which can be resolved immediately on encountering the reference. The corner case is where the object is not known because it is still being parsed and the reference is internal (only `parseObject` can encounter these cases). The design of the `fromSton:` API means that the materialised object instance is created without the reader''s immediate knowledge, so any internal refs will not be resolvable until after the `fromSton:` for the object being parsed has returned. In that case we can patch them up with `become:` if we can be very certain that the object is new and unshared. There is potential danger in using a swapping `become:` for classes that use the normal STON object representation, but which create some sort of external reference while the object itself is being instantiated (e.g. a registry for sharing), and which may internal references. For these we I have added a specific mechanism for the class side `fromSton:` to call back to the reader and replace the reference created by parseObject (see `STON.Reader>>#registerNewObject:`). This is not necessary for any of the standard `fromSton:` implementations, or any of the custom implementations to date.'!
!STON.Reader categoriesForClass!STON-Core-Reader! !
!STON.Reader methodsFor!

acceptUnknownClasses: aBoolean
	acceptUnknownClasses := aBoolean!

atEnd
	^currentCharacter isNil!

close
	readStream ifNotNil: [
		readStream close.
		readStream := nil ]!

consumeWhitespace
	"Strip whitespaces from the input stream."

	[(currentCharacter ?? $\0) isSeparator] whileTrue: [currentCharacter := readStream nextAvailable]!

convertNewLines: aBoolean
	"Private - When true, any newline CR, LF or CRLF read unescaped inside strings or symbols 
	will be converted to the newline convention chosen, see #newLine:
	The default is false, not doing any conversions."

	convertNewLines := aBoolean!

error: aString
	^ReaderError signal: aString
		streamPosition: (readStream isPositionable ifTrue: [readStream position])!

expectChar: character
	"Expect character and consume input and optional whitespace at the end, throw an error otherwise."

	currentCharacter == character
		ifTrue: 
			[currentCharacter := readStream nextAvailable.
			self consumeWhitespace]
		ifFalse: [self error: character asString , ' expected']!

initialize
	objects := IdentityDictionary new.
	classes := IdentityDictionary new.
	acceptUnknownClasses := convertNewLines := false.
	newLine := String lineDelimiter.
	objects := OrderedCollection new: 32.

	"Initialization specified to this class."
	stringStream := String writeStream: 32.
	classInstVarMaps := IdentityDictionary new!

instVarMapFor: aClass
	^classInstVarMaps at: aClass
		ifAbsentPut: 
			[| map |
			map := LookupTable new.
			aClass allInstVarNames keysAndValuesDo: [:eachKey :eachValue | map at: eachValue put: eachKey].
			map]!

isClassChar: aCharacter
	^aCharacter == $.
		or: ['_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890' identityIncludes: aCharacter]!

isClassStartChar: aCharacter
	"Would be nice to use the Scanner classification table here, but that creates an undesirable dependency."

	^'_ABCDEFGHIJKLMNOPQRSTUVWXYZ' identityIncludes: aCharacter!

isList
	^currentCharacter == $[!

isSimpleSymbolChar: char
	^char isLetter or: ['0123456789-_./' includes: char]!

lookupClass: aSymbol
	^(Smalltalk fullBindingFor: aSymbol)
		ifNotNil: [:binding | binding value]
		ifNil: [classes at: aSymbol ifAbsentPut: [(self renamedClasses lookup: aSymbol) ?? aSymbol]]!

match: string do: block
	self shouldNotImplement!

matchChar: character
	"Tries to match character, consume input and 
	answer true if successful and consumes whitespace at the end."

	^currentCharacter == character and: 
			[currentCharacter := readStream nextAvailable.
			self consumeWhitespace.
			true]!

newLine: string
	"Private - Set the newline convention to be used when converting newlines, see #convertNewLines"
	
	newLine := string !

newReference
	| index reference |
	index := objects size + 1.
	reference := Reference index: index.
	objects addLast: reference.
	^reference!

next
	self consumeWhitespace.
	^self parseValue!

objectProperties
	^objectProperties ifNil: [objectProperties := IdentityDictionary new]!

on: aReadStream
	readStream := aReadStream.
	currentCharacter := readStream nextAvailable!

optimizeForLargeStructures
!

parseCharacterConvertingNewLinesOn: writeStream
	| char |
	char := currentCharacter.
	currentCharacter := readStream nextAvailable.
	char == $\
		ifTrue: [writeStream nextPut: self parseEscapedCharacter]
		ifFalse: 
			[char == $\n
				ifTrue: [writeStream nextPutAll: newLine]
				ifFalse: 
					[char == $\r
						ifTrue: 
							[self peekFor: $\n.
							writeStream nextPutAll: newLine]
						ifFalse: [writeStream nextPut: char]]]!

parseCharacterHex
	| value |
	value := self parseCharacterHex4Value.
	^Character codePoint: ((value < 16rD800 or: [value > 16rDBFF])
				ifTrue: [value]
				ifFalse: 
					["Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"

					"See https://tools.ietf.org/html/rfc7159#section-7"
					16r10000 + ((value - 16rD800) * 16r400 + (self parseTrailingSurrogateHexEscape - 16rDC00))])!

parseCharacterHex4Value
	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [ 
		value := (value << 4) + self parseCharacterHexDigit ].
	^ value!

parseCharacterHexDigit
	| digit |
	currentCharacter
		ifNotNil: 
			[digit := HexDigitValues lookup: currentCharacter code + 1.
			currentCharacter := readStream nextAvailable.
			digit isNil ifFalse: [^digit]].
	self error: 'hex-digit expected'!

parseClass
	stringStream reset.
	
	[stringStream nextPut: currentCharacter.
	self isClassChar: (currentCharacter := readStream nextAvailable)]
			whileTrue.
	self consumeWhitespace.
	^self lookupClass: stringStream contents asSymbol!

parseConstant
	"Private - Parse and consume either true|false|nil|null."

	stringStream reset.
	[currentCharacter notNil and: [currentCharacter isLowerCase]] whileTrue: 
			[stringStream nextPut: currentCharacter.
			currentCharacter := readStream nextAvailable].
	self consumeWhitespace.
	^##(LookupTable withAll: {'true' -> true. 'false' -> false. 'nil' -> nil. 'null' -> nil})
		at: stringStream contents
		ifAbsent: [self error: 'invalid input']!

parseConstantDo: block
	"Private - Parse and consume either true|false|nil|null and execute block 
	or else do nothing (but do not back up).
	Hand written implementation to avoid the use of #position:"
	
	(readStream peek = $t)
		ifTrue: [
			^ self match: 'true' do: [ block value: true ] ].
	(readStream peek = $f)
		ifTrue: [
			^ self match: 'false' do: [ block value: false ] ].
	(readStream peek = $n)
		ifTrue: [
			readStream next.
			(readStream peek = $i)
				ifTrue: [
					self match: 'il' do: [ block value: nil ] ].
			(readStream peek = $u)
				ifTrue: [
					self match: 'ull' do: [ block value: nil ] ] ]		
!

parseEscapedCharacter
	| char |
	char := currentCharacter.
	currentCharacter := readStream nextAvailable.
	char == $u ifTrue: [^self parseCharacterHex].
	(EscapeChars lookup: char) ifNotNil: [:ch | ^ch].
	self error: 'invalid escape character \' , (String with: char)!

parseList
	| array stream |
	self expectChar: $[.
	array := STON listClass new.
	self storeReference: array.
	(self matchChar: $]) ifTrue: [^array].
	stream := array writeStream.
	[currentCharacter isNil] whileFalse: 
			[stream nextPut: self parseValue.
			(self matchChar: $])
				ifTrue: 
					[array resize: stream position.
					^array].
			self expectChar: $,].
	self error: 'end of list expected'.
	^self!

parseListDo: block
	| index |
	self expectChar: $[.
	(self matchChar: $]) ifTrue: [^self].	"short cut for empty lists"
	index := 1.
	[currentCharacter isNil] whileFalse: 
			[block cull: self parseValue cull: index.
			(self matchChar: $]) ifTrue: [^self].
			index := index + 1.
			self expectChar: $,].
	self error: 'end of list expected'!

parseListSingleton
	"Overriden to reduce overhead."

	| value |
	self expectChar: $[.
	value := self parseValue.
	self expectChar: $].
	^value!

parseMap
	| map |
	map := STON mapClass new.
	self storeReference: map.
	self parseMapDo: [:key :value | map at: key put: value].
	^map!

parseMapDo: block
	self expectChar: ${.
	(self matchChar: $}) ifTrue: [^self].	"short cut for empty maps"
	[currentCharacter isNil] whileFalse: 
			[| name value |
			name := self parseSimpleValue.
			self expectChar: $:.
			value := self parseValue.
			block value: name value: value.
			"The above is a more efficient way to say 'self parseValue' and using the returned association"
			(self matchChar: $}) ifTrue: [^self].
			self expectChar: $,].
	self error: 'end of map expected'!

parseNamedInstVarsFor: anObject
	| instVars |
	instVars := self instVarMapFor: anObject class.
	self parseMapDo: 
			[:name :value |
			(instVars lookup: name asString)
				ifNil: 
					["Store extra state for later"
					(self objectProperties at: anObject ifAbsentPut: [IdentityDictionary new]) at: name put: value]
				ifNotNil: [:i | anObject instVarAt: i put: value]]!

parseNumber
	| negated number |
	negated := self peekFor: $-.
	number := self parseNumberInteger.
	(self peekFor: $/)
		ifTrue: 
			[number := Fraction numerator: number denominator: self parseNumberInteger.
			(self peekFor: $s)
				ifTrue: [number := ScaledDecimal newFromNumber: number scale: self parseNumberInteger]]
		ifFalse: 
			[(self peekFor: $.) ifTrue: [number := number + self parseNumberFraction].
			(currentCharacter == $e or: [currentCharacter == $E])
				ifTrue: 
					[currentCharacter := readStream nextAvailable.
					number := number * self parseNumberExponent]].
	negated ifTrue: [number := number negated].
	self consumeWhitespace.
	^number!

parseNumberExponent
	^10 raisedTo: ((self peekFor: $-)
				ifTrue: [self parseNumberInteger * -1]
				ifFalse: 
					[self peekFor: $+.
					self parseNumberInteger])!

parseNumberFraction
	"Private - Parse the fraction part of a floating point number."

	| number power digit |
	number := 0.
	power := 1.
	[(digit := (currentCharacter ?? $\0) digitValue) >= 0 and: [digit < 10]] whileTrue: 
			[number := 10 * number + digit.
			power := power * 10.
			currentCharacter := readStream nextAvailable].
	^number / power asFloat!

parseNumberInteger
	| number digit |
	number := 0.
	[(digit := (currentCharacter ?? $\0) digitValue) >= 0 and: [digit < 10]] whileTrue: 
			[number := 10 * number + digit.
			currentCharacter := readStream nextAvailable].
	^number!

parseObject
	| targetClass reference object |
	reference := self newReference.
	targetClass := self parseClass.
	targetClass isSymbol
		ifFalse: 
			[object := targetClass fromSton: self.
			"If the object has internal references then it must be a new object, and so should be safe to #become:. If it is a class that has overridden toSton: and fromSton: to materialize as some pre-existing instance, then it cannot contain internal references, and so the pre-created reference will have a zero ref-count. The check for #stonContainsSubObjects is, strictly speaking, unnecessary. If it were safe, we could use just that, but it is too easy to forget to implement it. It would be safer if the Object implementation returned false."
			(reference refCount > 0 and: [object stonContainSubObjects])
				ifTrue: 
					[reference become: object.
					^reference]
				ifFalse: [self setReference: reference to: object]]
		ifTrue: 
			[acceptUnknownClasses
				ifTrue: 
					[object := STON mapClass new.
					self storeReference: object.
					self parseMapDo: [:key :value | object at: key put: value].
					object at: STON classNameKey put: targetClass]
				ifFalse: [self error: 'Cannot resolve class named ' , targetClass]].
	^object!

parseReference
	| index object |
	self expectChar: $@.
	index := self parseNumberInteger.
	self consumeWhitespace.
	"References can only ever be backwards, so we'll have seen this object before (or it will be in the process of being constructed)"
	object := objects at: index.
	object isStonReference ifTrue: [object addReference].
	^object!

parseSimpleValue
	currentCharacter isNil
		ifFalse: 
			[(self isClassStartChar: currentCharacter) ifTrue: [^self parseObject].
			currentCharacter == ${ ifTrue: [^self parseMap].
			currentCharacter == $[ ifTrue: [^self parseList].
			(currentCharacter == $' or: [currentCharacter == $"]) ifTrue: [^self parseString].
			currentCharacter == $# ifTrue: [^self parseSymbol].
			currentCharacter == $@ ifTrue: [^self parseReference].
			(currentCharacter == $- or: [currentCharacter isDigit]) ifTrue: [^self parseNumber].
			^self parseConstant].
	self error: 'invalid input'!

parseString
	^ self parseStringInternal!

parseStringInternal
	| delimiter |
	delimiter := currentCharacter.
	currentCharacter := readStream nextAvailable.
	stringStream reset.
	convertNewLines
		ifTrue: 
			[[(currentCharacter ?? delimiter) == delimiter]
				whileFalse: [self parseCharacterConvertingNewLinesOn: stringStream]]
		ifFalse: 
			[[(currentCharacter ?? delimiter) == delimiter] whileFalse: 
					[| char |
					char := currentCharacter.
					currentCharacter := readStream nextAvailable.
					stringStream nextPut: (char == $\ ifTrue: [self parseEscapedCharacter] ifFalse: [char])]].
	self expectChar: delimiter.
	^stringStream contents!

parseSymbol
	| string |
	currentCharacter := readStream nextAvailable.
	currentCharacter == $' ifTrue: [^self parseStringInternal asSymbol].
	stringStream reset.
	[self isSimpleSymbolChar: currentCharacter ?? $\0] whileTrue: 
			[stringStream nextPut: currentCharacter.
			currentCharacter := readStream nextAvailable.
			self].
	string := stringStream contents.
	string isEmpty
		ifFalse: 
			[self consumeWhitespace.
			^string asSymbol].
	self error: 'unexpected input'!

parseTrailingSurrogateHexEscape
	^((self peekFor: $\) and: [self peekFor: $u])
		ifTrue: [self parseCharacterHex4Value]
		ifFalse: [self error: 'trailing surrogate hex escape expected']!

parseValue
	| value |
	value := self parseSimpleValue.
	^(self matchChar: $:)
		ifTrue: [STON associationClass key: value value: self parseValue]
		ifFalse: [value]!

peekFor: aCharacter
	^currentCharacter == aCharacter and: 
			[currentCharacter := readStream nextAvailable.
			true]!

registerNewObject: anObject
	"Classes that create external references, e.g. a table of shared instances, when instantiating objects should call this method to replace the temporary STONReference in the parsed objects list.
	This removes the need to patch up any internal references later."

	| index existing |
	index := objects size.
	existing := objects at: index.
	existing == anObject ifTrue: [^self].
	(existing isStonReference and: [existing index == index])
		ifFalse: [^self error: 'Newly created object should be registered before parsing sub-objects'].
	objects at: index put: anObject!

renamedClasses
	^renamedClasses
		ifNil: 
			[| renamed |
			renamed := IdentityDictionary new.
			Smalltalk allClasses do: 
					[:each |
					((each class includesSelector: #stonName) and: [each stonName ~~ each fullName])
						ifTrue: [renamed at: each stonName put: each]].
			renamedClasses := renamed]!

reset
	objects removeAll!

setReference: reference to: object
	objects at: reference index put: object!

storeReference: object
	objects addLast: object.
	^objects size! !
!STON.Reader categoriesFor: #acceptUnknownClasses:!initialize/release!private! !
!STON.Reader categoriesFor: #atEnd!private!testing! !
!STON.Reader categoriesFor: #close!initialize/release!private! !
!STON.Reader categoriesFor: #consumeWhitespace!helpers!private! !
!STON.Reader categoriesFor: #convertNewLines:!initialize/release!private! !
!STON.Reader categoriesFor: #error:!error handling!private! !
!STON.Reader categoriesFor: #expectChar:!helpers!private! !
!STON.Reader categoriesFor: #initialize!initialize/release!private! !
!STON.Reader categoriesFor: #instVarMapFor:!private! !
!STON.Reader categoriesFor: #isClassChar:!helpers!private! !
!STON.Reader categoriesFor: #isClassStartChar:!helpers!private! !
!STON.Reader categoriesFor: #isList!public!testing! !
!STON.Reader categoriesFor: #isSimpleSymbolChar:!helpers!private! !
!STON.Reader categoriesFor: #lookupClass:!helpers!private! !
!STON.Reader categoriesFor: #match:do:!helpers!private! !
!STON.Reader categoriesFor: #matchChar:!helpers!private! !
!STON.Reader categoriesFor: #newLine:!initialize/release!private! !
!STON.Reader categoriesFor: #newReference!helpers!private! !
!STON.Reader categoriesFor: #next!public! !
!STON.Reader categoriesFor: #objectProperties!private! !
!STON.Reader categoriesFor: #on:!initialize/release!private! !
!STON.Reader categoriesFor: #optimizeForLargeStructures!initialize/release!private! !
!STON.Reader categoriesFor: #parseCharacterConvertingNewLinesOn:!parsing!private! !
!STON.Reader categoriesFor: #parseCharacterHex!helpers!private! !
!STON.Reader categoriesFor: #parseCharacterHex4Value!helpers!private! !
!STON.Reader categoriesFor: #parseCharacterHexDigit!parsing!private! !
!STON.Reader categoriesFor: #parseClass!parsing!private! !
!STON.Reader categoriesFor: #parseConstant!parsing!private! !
!STON.Reader categoriesFor: #parseConstantDo:!parsing-internal!private! !
!STON.Reader categoriesFor: #parseEscapedCharacter!parsing!private! !
!STON.Reader categoriesFor: #parseList!parsing!private! !
!STON.Reader categoriesFor: #parseListDo:!parsing!private! !
!STON.Reader categoriesFor: #parseListSingleton!parsing!private! !
!STON.Reader categoriesFor: #parseMap!parsing!private! !
!STON.Reader categoriesFor: #parseMapDo:!parsing!private! !
!STON.Reader categoriesFor: #parseNamedInstVarsFor:!parsing!private! !
!STON.Reader categoriesFor: #parseNumber!parsing!private! !
!STON.Reader categoriesFor: #parseNumberExponent!parsing!private! !
!STON.Reader categoriesFor: #parseNumberFraction!parsing!private! !
!STON.Reader categoriesFor: #parseNumberInteger!parsing!private! !
!STON.Reader categoriesFor: #parseObject!parsing!private! !
!STON.Reader categoriesFor: #parseReference!public! !
!STON.Reader categoriesFor: #parseSimpleValue!parsing!private! !
!STON.Reader categoriesFor: #parseString!parsing-internal!private! !
!STON.Reader categoriesFor: #parseStringInternal!parsing!private! !
!STON.Reader categoriesFor: #parseSymbol!parsing!private! !
!STON.Reader categoriesFor: #parseTrailingSurrogateHexEscape!parsing!private! !
!STON.Reader categoriesFor: #parseValue!parsing!private! !
!STON.Reader categoriesFor: #peekFor:!operations!private! !
!STON.Reader categoriesFor: #registerNewObject:!parsing!private! !
!STON.Reader categoriesFor: #renamedClasses!helpers!private! !
!STON.Reader categoriesFor: #reset!initialize/release!private! !
!STON.Reader categoriesFor: #setReference:to:!helpers!private! !
!STON.Reader categoriesFor: #storeReference:!helpers!private! !

!STON.Reader class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^STON icon!

initialize
	| escapeChars |
	escapeChars := IdentityDictionary new.
	Character.EscapeChars
		keysAndValuesDo: [:i :c | c ifNotNil: [escapeChars at: c put: (Character value: i - 1)]].
	"STON doesn't support the \a escape, so remove that."
	escapeChars removeKey: $a.
	#($' $" $/ $\) do: [:ch | escapeChars at: ch put: ch].
	self addClassConstant: 'EscapeChars'
		value: (escapeChars
				shrink;
				isImmutable: true;
				yourself).
	self initializeHexDigitValues!

initializeHexDigitValues
	| digitValues |
	digitValues := Array new: $f codePoint + 1.
	$0 codePoint to: $9 codePoint do: [:each | digitValues at: each + 1 put: each - ##($0 codePoint)].
	$A codePoint to: $F codePoint
		do: [:each | digitValues at: each + 1 put: each - ##($A codePoint - 10)].
	$a codePoint to: $f codePoint
		do: [:each | digitValues at: each + 1 put: each - ##($a codePoint - 10)].
	self addClassConstant: 'HexDigitValues' value: digitValues!

new
	^self basicNew initialize!

on: readStream
	^ self new
		on: readStream;
		yourself! !
!STON.Reader class categoriesFor: #icon!constants!public! !
!STON.Reader class categoriesFor: #initialize!private! !
!STON.Reader class categoriesFor: #initializeHexDigitValues!initializing!private! !
!STON.Reader class categoriesFor: #new!instance creation!private! !
!STON.Reader class categoriesFor: #on:!instance creation!public! !

