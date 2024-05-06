"Filed out from Dolphin Smalltalk"!

STONReader subclass: #DolphinSTONReader
	instanceVariableNames: 'classInstVarMaps currentCharacter objectProperties renamedClasses'
	classVariableNames: 'EscapeChars HexDigitValues'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinSTONReader guid: (GUID fromString: '{a8dab6bc-8e16-483a-adee-741c2aa9f0f7}')!

DolphinSTONReader addClassConstant: 'HexDigitValues' value: #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 0 1 2 3 4 5 6 7 8 9 nil nil nil nil nil nil nil 10 11 12 13 14 15 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 10 11 12 13 14 15)!

DolphinSTONReader comment: ''!

!DolphinSTONReader categoriesForClass!Unclassified! !

!DolphinSTONReader methodsFor!

atEnd
	^currentCharacter isNil!

consumeWhitespace
	"Strip whitespaces from the input stream."

	[(currentCharacter ?? $\0) isSeparator] whileTrue: [currentCharacter := readStream nextAvailable]!

error: aString
	^DolphinSTONReaderError signal: aString
		streamPosition: (readStream isPositionable ifTrue: [readStream position])!

expectChar: character
	"Expect character and consume input and optional whitespace at the end, throw an error otherwise."

	currentCharacter == character
		ifTrue: 
			[currentCharacter := readStream nextAvailable.
			self consumeWhitespace]
		ifFalse: [self error: character asString , ' expected']!

initialize
	super initialize.
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
	| charClass |
	charClass := SmalltalkScanner classify: aCharacter.
	^charClass == #alphabetic or: [charClass == #digit]!

isClassStartChar: aCharacter
	^(SmalltalkScanner classify: aCharacter) == #alphabetic and: [aCharacter code < ##($a code)]!

isList
	^currentCharacter == $[!

lookupClass: aSymbol
	^(Smalltalk bindingFor: aSymbol)
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

newReference
	| index reference |
	index := objects size + 1.
	reference := DolphinSTONReference index: index.
	objects addLast: reference.
	^ reference!

next
	self consumeWhitespace.
	^self parseValue!

objectProperties
	^objectProperties ifNil: [objectProperties := IdentityDictionary new]!

on: aReadStream
	readStream := aReadStream.
	currentCharacter := readStream nextAvailable!

parseCharacter
	^self shouldNotImplement!

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

parseMapOrListRepresentation
	"Private - Parse either a map or list to be used as a representation, not considering it as a referenceable object"

	currentCharacter == ${
		ifTrue: 
			[| map |
			map := STON mapClass new.
			self parseMapDo: [:key :value | map at: key put: value].
			^map].
	currentCharacter == $[
		ifTrue: 
			[| stream |
			stream := STON listClass writeStream: 16.
			self parseListDo: [:each | stream nextPut: each].
			^stream grabContents].
	self error: 'invalid input'!

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
					[Transcript nextPutAll: 'STON reader swapping reference '; print: reference; nextPutAll: ' for object '; print: object; cr.
					reference become: object.
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

peekFor: aCharacter
	^currentCharacter == aCharacter and: 
			[currentCharacter := readStream nextAvailable.
			true]!

processSubObjectsOf: object
	"We dispense with the naïve approach of walking the objects to patch up the references as this quickly heads off into bits of the Object graph that were referenced from the STON serialisation, but not included in it. The #stonContainsSubObjects mechanism is too simplistic and error prone to prevent this in all but very constrained object graphs with a known set of classes. It's also rather slow. Neither of these things are suitable characteristics for a general purpose object serialization mechanism. To top it all, it isn't actually necessary as the graph can only contain backwards references, never forwards references, as a function of the way it is built by visiting objects recursively. The numbered cross references in a STON stream are most often referencing a previously seen object that is known and recorded in the objects list and so which can be resolved immediately on encountering the reference. The corner case is where the object is not known because it is still being parsed and the reference is internal (only #parseObject can encounter these cases). The design of the fromSton: API means that the materialised object instance is created without the reader's immediate knowledge, so any internal refs will not be resolvable until after the #fromSton: for the object being parsed has returned. In that case we can patch them up with #become: if we can be very certain that the object is new and unshared. There is potential danger in using a swapping #become: for classes that use the normal STON object representation, but which create some sort of external reference while the object itself is being instantiated (e.g. a registry for sharing), and which may internal references. For these we I have added a specific mechanism for the class side #fromSton: to call back to the reader and replace the reference created by parseObject (see DolphinSTONReader>>registerNewObject:). This is not necessary for any of the standard #fromSton: implementations, or any of the custom implementations to date."

	self shouldNotImplement!

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
					((each class includesSelector: #stonName) and: [each stonName ~~ each name])
						ifTrue: [renamed at: each stonName put: each]].
			renamedClasses := renamed]!

resolveReference: reference
	"See #processSubObjctsOf:"

	^self shouldNotImplement!

resolveReferenceIndex: index
	"See #processSubObjctsOf:"

	^self shouldNotImplement!

storeReference: object
	objects addLast: object.
	^objects size!

stringStreamContents: block
	self shouldNotImplement! !

!DolphinSTONReader categoriesForMethods!
atEnd!private!testing! !
consumeWhitespace!helpers!private! !
error:!error handling!private! !
expectChar:!helpers!private! !
initialize!initialize/release!private! !
instVarMapFor:!private! !
isClassChar:!helpers!private! !
isClassStartChar:!helpers!private! !
isList!public!testing! !
lookupClass:!helpers!private! !
match:do:!helpers!private! !
matchChar:!helpers!private! !
newReference!helpers!private! !
next!public! !
objectProperties!private! !
on:!initialize/release!private! !
parseCharacter!parsing!private! !
parseCharacterConvertingNewLinesOn:!parsing!private! !
parseCharacterHexDigit!parsing!private! !
parseClass!parsing!private! !
parseConstant!parsing!private! !
parseEscapedCharacter!parsing!private! !
parseList!parsing!private! !
parseListDo:!parsing!private! !
parseListSingleton!parsing!private! !
parseMapDo:!parsing!private! !
parseMapOrListRepresentation!parsing!private! !
parseNamedInstVarsFor:!parsing!private! !
parseNumber!parsing!private! !
parseNumberExponent!parsing!private! !
parseNumberFraction!parsing!private! !
parseNumberInteger!parsing!private! !
parseObject!parsing!private! !
parseReference!public! !
parseSimpleValue!parsing!private! !
parseStringInternal!parsing!private! !
parseSymbol!parsing!private! !
parseTrailingSurrogateHexEscape!parsing!private! !
peekFor:!operations!private! !
processSubObjectsOf:!private! !
registerNewObject:!parsing!private! !
renamedClasses!helpers!private! !
resolveReference:!private! !
resolveReferenceIndex:!private! !
storeReference:!helpers!private! !
stringStreamContents:!helpers!private! !
!

!DolphinSTONReader class methodsFor!

initialize
	"
		self initialize
	"

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
	self addClassConstant: 'HexDigitValues' value: digitValues! !

!DolphinSTONReader class categoriesForMethods!
initialize!initializing!public! !
initializeHexDigitValues!initializing!private! !
!

