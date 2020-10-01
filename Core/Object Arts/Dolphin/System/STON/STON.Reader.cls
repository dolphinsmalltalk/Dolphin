"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'STON.Reader'
	instanceVariableNames: 'readStream objects classes unresolvedReferences stringStream acceptUnknownClasses newLine convertNewLines'
	classVariableNames: 'NotFound'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Reader guid: (Core.GUID fromString: '{d393ea51-a9cb-4a9f-bdc2-477e3bb22712}')!
STON.Reader comment: 'STONReader materializes objects using the Smalltalk Object Notation format.

This parser is backwards compatible with standard JSON.

Customization options are:

- acceptUnknownClasses <Boolean> default is false
	if true, unknown class names are allowed, the standard #mapClass (Dictionary) is instanciated and the class name is added under #classNameKey (#className)
	if false, unknown class names result in a NotFound error
- convertNewLines <Boolean> default is false
	if true, any unescaped EOL sequence CR, LF or CRLF inside strings or symbols is read and converted as the chosen EOL sequence
	if false, CR, LF and CRLF are read unmodified
- newLine <String> default is String cr
	sequence to use as EOL'!
!STON.Reader categoriesForClass!STON-Core-Reader! !
!STON.Reader methodsFor!

acceptUnknownClasses: boolean
	acceptUnknownClasses := boolean!

allowComplexMapKeys: boolean
	"Private - This is a no-op, this used to be an option, but it is now always enabled"!

atEnd
	^ readStream atEnd!

close
	readStream ifNotNil: [
		readStream close.
		readStream := nil ]!

consumeWhitespace
	"Strip whitespaces from the input stream."

	[ readStream atEnd not and: [ readStream peek isSeparator ] ]
		whileTrue: [ readStream next ]!

convertNewLines: boolean
	"Private - When true, any newline CR, LF or CRLF read unescaped inside strings or symbols 
	will be converted to the newline convention chosen, see #newLine:
	The default is false, not doing any convertions."
	
	convertNewLines := boolean!

error: aString
	| streamPosition |
	"Remain compatible with streams that don't understand #position"
	streamPosition := [readStream position] on: MessageNotUnderstood do: [nil].
	^ReaderError signal: aString streamPosition: streamPosition!

expectChar: character
	"Expect character and consume input and optional whitespace at the end,
	 throw an error otherwise."

	(self matchChar: character)
		ifFalse: [ self error: character asString, ' expected' ]!

initialize
	super initialize.
	objects := IdentityDictionary new.
	classes := IdentityDictionary new.
	acceptUnknownClasses := convertNewLines := false.
	newLine := String cr.
	unresolvedReferences := 0!

isClassChar: char
	^ 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_' includes: char!

isClassStartChar: char
	^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' includes: char!

isSimpleSymbolChar: char
	^char isLetter or: ['0123456789-_./' includes: char]!

lookupClass: name
	Smalltalk globals at: name ifPresent: [:class | ^class].
	^classes at: name
		ifAbsentPut: 
			[Object allSubclasses detect: [:class | class isMeta not and: [class stonName = name]]
				ifNone: [NotFound signalFor: name]]!

match: string do: block
	"Try to read and consume string and execute block if successful.
	Else do nothing (but do not back up)"

	(string allSatisfy: [ :each | readStream peekFor: each ])
		ifTrue: [ 
			self consumeWhitespace.
			block value ]!

matchChar: character
	"Tries to match character, consume input and 
	answer true if successful and consumes whitespace at the end."

	^ (readStream peekFor: character)
		ifTrue: [ 
			self consumeWhitespace.
			true ]
		ifFalse: [ false ]!

newLine: string
	"Private - Set the newline convention to be used when converting newlines, see #convertNewLines"
	
	newLine := string !

newReference
	| index reference |
	index := objects size + 1.
	reference := STON.Reference index: index.
	objects at: index put: reference.
	^reference!

next
	| object |
	self consumeWhitespace.
	object := self parseValue.
	unresolvedReferences > 0
		ifTrue: [ self processSubObjectsOf: object ].
	unresolvedReferences = 0
		ifFalse: [ self error: 'Inconsistent reference resolution' ].
	^ object!

on: aReadStream
	readStream := aReadStream!

optimizeForLargeStructures
	self class environment
		at: #FLLargeIdentityDictionary
		ifPresent: [ :identityDictionaryClass | objects := identityDictionaryClass new ]!

parseCharacter
	| char |
	^ (char := readStream next) = $\
		ifTrue: [ self parseEscapedCharacter ]
		ifFalse: [ char ]!

parseCharacterConvertingNewLinesOn: writeStream
	| char |
	(char := readStream next) = $\
		ifTrue: [writeStream nextPut: self parseEscapedCharacter]
		ifFalse: 
			[char = Character lf
				ifTrue: [writeStream nextPutAll: newLine]
				ifFalse: 
					[char = Character cr
						ifTrue: 
							[readStream peekFor: Character lf.
							writeStream nextPutAll: newLine]
						ifFalse: [writeStream nextPut: char]]]!

parseCharacterHex
	| value codePoint |
	value := self parseCharacterHex4Value.
	(value < 16rD800 or: [value > 16rDBFF])
		ifTrue: [codePoint := value]
		ifFalse: 
			[| leadSurrogate trailSurrogate |
			"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"

			"See https://tools.ietf.org/html/rfc7159#section-7"
			leadSurrogate := value.
			trailSurrogate := self parseTrailingSurrogateHexEscape.
			codePoint := (leadSurrogate - 16rD800) * 16r400 + (trailSurrogate - 16rDC00).
			codePoint := 16r10000 + codePoint].
	^Character codePoint: codePoint!

parseCharacterHex4Value
	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [ 
		value := (value << 4) + self parseCharacterHexDigit ].
	^ value!

parseCharacterHexDigit
	| digit |
	readStream atEnd ifFalse: [ 
		digit := readStream next asInteger.
		(digit between: "$0" 48 and: "$9" 57)
			ifTrue: [ ^ digit - 48 ].
		(digit between: "$A" 65 and: "$F" 70)
			ifTrue: [ ^ digit - 55 ].
		(digit between: "$a" 97 and: "$f" 102)
			ifTrue: [ ^ digit - 87 ] ].
	self error: 'hex-digit expected'!

parseClass
	| className |
	className := self stringStreamContents: [ :stream |
		[ readStream atEnd not and: [ self isClassChar: readStream peek ] ] whileTrue: [ 
			stream nextPut: readStream next ] ].
	self consumeWhitespace.
	^ self lookupClass: className asSymbol
	!

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
	char := readStream next.
	(#($' $" $/ $\) includes: char) ifTrue: [^char].
	char = $b ifTrue: [^Character backspace].
	char = $f ifTrue: [^Character newPage].
	char = $n ifTrue: [^Character lf].
	char = $r ifTrue: [^Character cr].
	char = $t ifTrue: [^Character tab].
	char = $u ifTrue: [^self parseCharacterHex].
	self error: 'invalid escape character \' , (String with: char).
	^char!

parseList
	| reference array |
	reference := self newReference.
	array := STON listClass streamContents: [:stream | self parseListDo: [:each | stream nextPut: each]].
	self setReference: reference to: array.
	^array!

parseListDo: block
	| index |
	self expectChar: $[.
	(self matchChar: $]) ifTrue: [ ^ self ]. "short cut for empty lists"
	index := 1.
	[ readStream atEnd ] whileFalse: [
		block cull: self parseValue cull: index.
		(self matchChar: $]) ifTrue: [ ^ self ].
		index := index + 1.
		self expectChar: $, ].
	self error: 'end of list expected'!

parseListSingleton
	| value |
	value := nil.
	self parseListDo: [ :each :index |
		index = 1 ifTrue: [ value := each ] ].
	^ value!

parseMap
	| map |
	map := STON mapClass new.
	self storeReference: map.
	self parseMapDo: [:key :value | map at: key put: value].
	^map!

parseMapDo: block
	self expectChar: ${.
	(self matchChar: $}) ifTrue: [ ^ self ]. "short cut for empty maps"
	[ readStream atEnd ] whileFalse: [ | name value |
		name := self parseSimpleValue.
		self expectChar: $:.
		value := self parseValue.
		block value: name value: value.
		"The above is a more efficient way to say 'self parseValue' and using the returned association"
		(self matchChar: $}) ifTrue: [ ^ self ].
		self expectChar: $, ].
	self error: 'end of map expected'!

parseMapOrListRepresentation
	"Private - Parse either a map or list to be used as a representation, not considering it as a referenceable object"

	readStream atEnd
		ifFalse: 
			[readStream peek = ${
				ifTrue: 
					[| map |
					map := STON mapClass new.
					self parseMapDo: [:key :value | map at: key put: value].
					^map].
			readStream peek = $[
				ifTrue: [^STON listClass streamContents: [:stream | self parseListDo: [:each | stream nextPut: each]]]].
	self error: 'invalid input'!

parseNamedInstVarsFor: anObject
	self parseMapDo: [ :instVarName :value |
		anObject instVarNamed: instVarName put: value ]!

parseNumber
	| negated number |
	negated := readStream peekFor: $-.
	number := self parseNumberInteger.
	(readStream peekFor: $/)
		ifTrue: 
			[number := Fraction numerator: number denominator: self parseNumberInteger.
			(readStream peekFor: $s)
				ifTrue: [number := ScaledDecimal newFromNumber: number scale: self parseNumberInteger]]
		ifFalse: 
			[(readStream peekFor: $.) ifTrue: [number := number + self parseNumberFraction].
			((readStream peekFor: $e) or: [readStream peekFor: $E])
				ifTrue: [number := number * self parseNumberExponent]].
	negated ifTrue: [number := number negated].
	self consumeWhitespace.
	^number!

parseNumberExponent
	| number negated |
	number := 0.
	(negated := readStream peekFor: $-)
		ifFalse: [ readStream peekFor: $+ ].
	[ readStream atEnd not and: [ readStream peek isDigit ] ]
		whileTrue: [ number := 10 * number + readStream next digitValue ].
	negated
		ifTrue: [ number := number negated ].
	^ 10 raisedTo: number!

parseNumberFraction
	| number power |
	number := 0.
	power := 1.0.
	[ readStream atEnd not and: [ readStream peek isDigit ] ] whileTrue: [
		number := 10 * number + readStream next digitValue.
		power := power * 10.0 ].
	^ number / power!

parseNumberInteger
	| number |
	number := 0.
	[ readStream atEnd not and: [ readStream peek isDigit ] ] whileTrue: [ 
		number := 10 * number + readStream next digitValue ].
	^ number!

parseObject
	| targetClass reference object |
	
	[reference := self newReference.
	targetClass := self parseClass.
	object := targetClass fromSton: self.
	self setReference: reference to: object]
			on: NotFound
			do: 
				[:notFound |
				acceptUnknownClasses
					ifTrue: 
						[object := STON mapClass new.
						self storeReference: object.
						self parseMapDo: [:key :value | object at: key put: value].
						object at: STON classNameKey put: notFound object]
					ifFalse: [self error: 'Cannot resolve class named ' , notFound object printString]].
	^object!

parseReference
	| index |
	self expectChar: $@.
	index := self parseNumberInteger.
	self consumeWhitespace.
	unresolvedReferences := unresolvedReferences + 1.
	^STON.Reference index: index!

parseSimpleValue
	| char |
	readStream atEnd ifFalse: [ 
		(self isClassStartChar: (char := readStream peek)) 
			ifTrue: [ ^ self parseObject ].
		char = ${
			ifTrue: [ ^ self parseMap ].
		char = $[
			ifTrue: [ ^ self parseList ].
		(char = $' or: [ char = $" ])
			ifTrue: [ ^ self parseString ].
		char = $#
			ifTrue: [ ^ self parseSymbol ].
		char = $@
			ifTrue: [ ^ self parseReference ].
		(char = $- or: [ char isDigit ])
			ifTrue: [ ^ self parseNumber ].
		self parseConstantDo: [ :value | ^ value ] ].
	self error: 'invalid input'!

parseString
	^ self parseStringInternal!

parseStringInternal
	| result delimiter |
	delimiter := readStream next.
	(delimiter = $' or: [ delimiter = $" ])
		ifFalse: [ self error: ''' or " expected' ].
	result := self
		stringStreamContents: [ :stream | 
			convertNewLines
				ifTrue: [ 
					[ readStream atEnd or: [ readStream peek = delimiter ] ] 
						whileFalse: [ self parseCharacterConvertingNewLinesOn: stream ] ]
				ifFalse: [ 
					[ readStream atEnd or: [ readStream peek = delimiter ] ] 
						whileFalse: [ stream nextPut: self parseCharacter ] ] ].
	self expectChar: delimiter.
	^ result!

parseSymbol
	| string |
	self expectChar: $#.
	readStream peek = $'
		ifTrue: [ ^ self parseStringInternal asSymbol ].
	string := self stringStreamContents: [ :stream |
		[ readStream atEnd not and: [ self isSimpleSymbolChar: readStream peek ] ] whileTrue: [
			stream nextPut: readStream next ] ].
	string isEmpty
		ifFalse: [ 
			self consumeWhitespace.
			^ string asSymbol ].
	self error: 'unexpected input'!

parseTrailingSurrogateHexEscape
	(readStream next = $\ and: [ readStream next = $u ])
		ifTrue: [ ^ self parseCharacterHex4Value ]
		ifFalse: [ self error: 'trailing surrogate hex escape expected' ]!

parseValue
	| value |
	value := self parseSimpleValue.
	^(self matchChar: $:)
		ifTrue: [STON associationClass key: value value: self parseValue]
		ifFalse: [value]!

processSubObjectsOf: object
	| unresolvedReferencesCount |
	unresolvedReferencesCount := unresolvedReferences.
	object stonProcessSubObjects: [ :each | 
		each isStonReference
			ifTrue: [ self resolveReference: each ]
			ifFalse: [ 
				each stonContainSubObjects
					ifTrue: [ self processSubObjectsOf: each ]
					ifFalse: [ each ] ] ].
	unresolvedReferencesCount > unresolvedReferences
		ifTrue: [ object stonPostReferenceResolution ].
	^ object!

reset
	unresolvedReferences := 0.
	objects removeAll!

resolveReference: reference
	unresolvedReferences := unresolvedReferences - 1.
	^ self resolveReferenceIndex: reference index!

resolveReferenceIndex: index
	^ objects at: index!

setReference: reference to: object
	objects at: reference index put: object!

storeReference: object
	| index |
	index := objects size + 1.
	objects at: index put: object.
	^ index!

stringStreamContents: block
	stringStream ifNil: [stringStream := (String new: 32) writeStream].
	stringStream reset.
	block value: stringStream.
	^stringStream contents! !
!STON.Reader categoriesFor: #acceptUnknownClasses:!initialize/release!private! !
!STON.Reader categoriesFor: #allowComplexMapKeys:!initialize/release!private! !
!STON.Reader categoriesFor: #atEnd!private!testing! !
!STON.Reader categoriesFor: #close!initialize/release!private! !
!STON.Reader categoriesFor: #consumeWhitespace!helpers!private! !
!STON.Reader categoriesFor: #convertNewLines:!initialize/release!private! !
!STON.Reader categoriesFor: #error:!error handling!private! !
!STON.Reader categoriesFor: #expectChar:!helpers!private! !
!STON.Reader categoriesFor: #initialize!initialize/release!private! !
!STON.Reader categoriesFor: #isClassChar:!helpers!private! !
!STON.Reader categoriesFor: #isClassStartChar:!helpers!private! !
!STON.Reader categoriesFor: #isSimpleSymbolChar:!helpers!private! !
!STON.Reader categoriesFor: #lookupClass:!helpers!private! !
!STON.Reader categoriesFor: #match:do:!helpers!private! !
!STON.Reader categoriesFor: #matchChar:!helpers!private! !
!STON.Reader categoriesFor: #newLine:!initialize/release!private! !
!STON.Reader categoriesFor: #newReference!helpers!private! !
!STON.Reader categoriesFor: #next!helpers!public! !
!STON.Reader categoriesFor: #on:!initialize/release!private! !
!STON.Reader categoriesFor: #optimizeForLargeStructures!initialize/release!private! !
!STON.Reader categoriesFor: #parseCharacter!parsing-internal!private! !
!STON.Reader categoriesFor: #parseCharacterConvertingNewLinesOn:!parsing-internal!private! !
!STON.Reader categoriesFor: #parseCharacterHex!helpers!private! !
!STON.Reader categoriesFor: #parseCharacterHex4Value!helpers!private! !
!STON.Reader categoriesFor: #parseCharacterHexDigit!parsing-internal!private! !
!STON.Reader categoriesFor: #parseClass!parsing-internal!private! !
!STON.Reader categoriesFor: #parseConstantDo:!parsing-internal!private! !
!STON.Reader categoriesFor: #parseEscapedCharacter!parsing-internal!private! !
!STON.Reader categoriesFor: #parseList!parsing!private! !
!STON.Reader categoriesFor: #parseListDo:!parsing!private! !
!STON.Reader categoriesFor: #parseListSingleton!parsing!private! !
!STON.Reader categoriesFor: #parseMap!parsing!private! !
!STON.Reader categoriesFor: #parseMapDo:!parsing!private! !
!STON.Reader categoriesFor: #parseMapOrListRepresentation!parsing!private! !
!STON.Reader categoriesFor: #parseNamedInstVarsFor:!parsing!private! !
!STON.Reader categoriesFor: #parseNumber!parsing-internal!private! !
!STON.Reader categoriesFor: #parseNumberExponent!parsing-internal!private! !
!STON.Reader categoriesFor: #parseNumberFraction!parsing-internal!private! !
!STON.Reader categoriesFor: #parseNumberInteger!parsing-internal!private! !
!STON.Reader categoriesFor: #parseObject!parsing!private! !
!STON.Reader categoriesFor: #parseReference!parsing-internal!private! !
!STON.Reader categoriesFor: #parseSimpleValue!parsing!private! !
!STON.Reader categoriesFor: #parseString!parsing-internal!private! !
!STON.Reader categoriesFor: #parseStringInternal!parsing-internal!private! !
!STON.Reader categoriesFor: #parseSymbol!parsing-internal!private! !
!STON.Reader categoriesFor: #parseTrailingSurrogateHexEscape!helpers!private! !
!STON.Reader categoriesFor: #parseValue!parsing!private! !
!STON.Reader categoriesFor: #processSubObjectsOf:!helpers!private! !
!STON.Reader categoriesFor: #reset!initialize/release!private! !
!STON.Reader categoriesFor: #resolveReference:!helpers!private! !
!STON.Reader categoriesFor: #resolveReferenceIndex:!helpers!private! !
!STON.Reader categoriesFor: #setReference:to:!helpers!private! !
!STON.Reader categoriesFor: #storeReference:!helpers!private! !
!STON.Reader categoriesFor: #stringStreamContents:!helpers!private! !

!STON.Reader class methodsFor!

on: readStream
	^ self new
		on: readStream;
		yourself! !
!STON.Reader class categoriesFor: #on:!instance creation!public! !

