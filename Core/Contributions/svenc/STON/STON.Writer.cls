"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'STON.Writer'
	instanceVariableNames: 'writeStream prettyPrint stonCharacters newLine asciiOnly jsonMode keepNewLines referencePolicy level objects'
	classVariableNames: 'STONCharacters STONSimpleSymbolCharacters'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Writer guid: (Core.GUID fromString: '{ad80eebc-c783-428d-8dbf-ebde1ffe8ddf}')!
STON.Writer comment: 'STONWriter serializes objects using the Smalltalk Object Notation format. 

Customization options are:

- prettyPrint <Boolean> default is false
	if true, produce pretty printed output
- newLine <String> default is String cr
	what sequence to use for EOL
- asciiOnly <Boolean> default is false
   if true, use \u escapes for all non-ASCII characters
   most common control characters are still escaped
- jsonMode <Boolean> default is false
	if true, the follow changes occur
	- strings are delimited with double quotes
	- nil is encoded as null
	- symbols are treated as strings
	- only STON listClass and STON mapClass instances are allowed as composite objects
	it is wise to also use either #error or #ignore as referencePolicy to avoid references
- referencePolicy <#normal|#ignore|#error> default is #normal
	if #normal, track and count object references and use references to implement sharing and break cycles
	if #error, track object references and signal STONWriterError when a shared reference is encountered
	if #ignore, don''t track object references which might loop forever on cycles
 - keepNewLines <Boolean> default is false
	if true, any newline sequence CR, LF or CRLF inside strings or symbols will not be escaped 
	but will be written as the newline EOF convention
	
Note that in default STON mode I only use the following named character escapes: \b \t \n \f \'' and \\ while in JSON mode \'' is replaced by \"
'!
!STON.Writer categoriesForClass!STON-Core-Writer! !
!STON.Writer methodsFor!

asciiOnly: boolean
	asciiOnly := boolean!

close
	writeStream ifNotNil: [
		writeStream close.
		writeStream := nil ]!

encodeCharacter: char
	| code encoding |
	"STONCharacters contains for the lower 127 characters (codes 0 to 126) either nil (unknown), 
	#pass (output as is, clean ASCII characters) or a full escape string"
	((code := char codePoint) < 127 and: [ (encoding := self stonCharacters at: code + 1) notNil ])
		ifTrue: [ 
			(encoding = #pass or: [ jsonMode and: [ char = $' ] ])
				ifTrue: [ writeStream nextPut: char ]
				ifFalse: [ writeStream nextPutAll: encoding ] ]
		ifFalse: [
			"always escape Latin1 C1 controls, or when asciiOnly is true" 
			(code > 16r9F and: [ asciiOnly not ])
				ifTrue: [ writeStream nextPut: char ]
				ifFalse: [ self escapeUnicode: code ] ]
!

encodeKey: key value: value
	(jsonMode and: [ key isString not ])
		ifTrue: [ self error: 'JSON key names in objects must be strings' ].
	self nextPut: key.
	self prettyPrintSpace.
	writeStream nextPut: $:.
	self prettyPrintSpace.
	self nextPut: value!

encodeList: elements
	writeStream nextPut: $[.
	elements isEmpty
		ifTrue: [
			self prettyPrintSpace ]
		ifFalse: [
			self indentedDo: [
				self newlineIndent.
				elements 
					do: [ :each | self nextPut: each ]
					separatedBy: [ self listElementSeparator ] ].
			self newlineIndent ].
	writeStream nextPut: $]
!

encodeMap: pairs
	writeStream nextPut: ${.
	pairs isEmpty
		ifTrue: [self prettyPrintSpace]
		ifFalse: 
			[self indentedDo: 
					[| first |
					first := true.
					self newlineIndent.
					pairs keysAndValuesDo: 
							[:key :value |
							first ifTrue: [first := false] ifFalse: [self mapElementSeparator].
							self encodeKey: key value: value]].
			self newlineIndent].
	writeStream nextPut: $}!

encodeString: string
	writeStream nextPut: (jsonMode ifTrue: [ $" ] ifFalse: [ $' ]).
	keepNewLines
		ifTrue: [ 
			self encodeStringKeepingNewLines: string ]
		ifFalse: [ 
			string do: [ :each | self encodeCharacter: each ] ].
	writeStream nextPut: (jsonMode ifTrue: [ $" ] ifFalse: [ $' ])!

encodeStringKeepingNewLines: string
	| input char |
	input := string readStream.
	[input atEnd] whileFalse: 
			[char := input next.
			char = Character lf
				ifTrue: [writeStream nextPutAll: newLine]
				ifFalse: 
					[char = Character cr
						ifTrue: 
							[input peekFor: Character lf.
							writeStream nextPutAll: newLine]
						ifFalse: [self encodeCharacter: char]]]!

error: aString
	^STON.WriterError signal: aString!

escape: char with: anObject
	"Instruct me to escape char with object, either a replacement string or #pass"
	
	"self escape: $/ with: '\/'."
	
	self assert: (anObject isString | (anObject == #pass)).
	self assert: char isOctetCharacter.
	self writeableStonCharacters at: char codePoint + 1 put: anObject!

escapeUnicode: codePoint
	codePoint <= 16rFFFF
		ifTrue: [ self escapeUnicode4: codePoint ]
		ifFalse: [ 
			codePoint <= 16r10FFFF
				ifTrue: [ | leadSurrogate trailSurrogate shifted |
					"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"
					"See https://tools.ietf.org/html/rfc7159#section-7"
					shifted := codePoint - 16r10000.
					leadSurrogate := 16rD800 + (shifted // 16r400).
					trailSurrogate := 16rDC00 + (shifted \\ 16r400).
					self escapeUnicode4: leadSurrogate.
					self escapeUnicode4: trailSurrogate ]
				ifFalse: [ self error: 'Character Unicode code point outside encoder range' ] ]!

escapeUnicode4: codePoint
	writeStream nextPutAll: '\u'.
	codePoint printOn: writeStream base: 16 nDigits: 4!

indentedDo: block
	level := level + 1.
	block value.
	level := level - 1!

initialize
	super initialize.
	stonCharacters := STONCharacters.
	prettyPrint := false.
	newLine := String cr.
	level := 0.
	referencePolicy := #normal.
	jsonMode := keepNewLines := asciiOnly := false.
	objects := IdentityDictionary new!

isSimpleSymbol: symbol
	(symbol isEmpty or: [ symbol isWideString ]) 
		ifTrue: [ ^ false ].
	^ (symbol class 
		findFirstInString: symbol 
		inSet: STONSimpleSymbolCharacters 
		startingAt: 1) = 0

!

jsonMode

	^ jsonMode !

jsonMode: boolean
	(jsonMode := boolean)
		ifTrue: [ 
			self
				escape: $' with: #pass;
				escape: $" with: '\"' ]
		ifFalse: [ 
			self
				escape: $" with: #pass;
				escape: $' with: '\''' ]!

keepNewLines: boolean
	"If true, any newline CR, LF or CRLF inside strings or symbols will not be escaped
	but will instead be converted to the newline convention chosen, see #newLine:
	The default is false, where CR, LF or CRLF will be enscaped unchanged."
	
	keepNewLines := boolean!

listElementSeparator
	writeStream nextPut: $,.
	self newlineIndent
!

mapElementSeparator
	writeStream nextPut: $,.
	self newlineIndent
!

newLine: string
	"The sequence to use when ending a line, either CR, LF or CRLF"
	
	newLine := string!

newlineIndent
	prettyPrint ifTrue: [ 
		writeStream nextPutAll: newLine.
		level timesRepeat: [ writeStream tab ] ]!

nextPut: anObject
	anObject stonOn: self!

on: aWriteStream
	writeStream := aWriteStream
!

optimizeForLargeStructures
	self class environment
		at: #FLLargeIdentityDictionary
		ifPresent: [ :identityDictionaryClass | objects := identityDictionaryClass new ].!

prettyPrint: boolean
	prettyPrint := boolean!

prettyPrintSpace
	prettyPrint ifTrue: [ writeStream space ]
!

referencePolicy: policy
	self assert: [#(#normal #ignore #error) includes: policy ].
	referencePolicy := policy
!

reset
	objects removeAll!

shortListElementSeparator
	writeStream nextPut: $,.
	self prettyPrintSpace
!

stonCharacters
	^ stonCharacters ifNil: [ stonCharacters := STONCharacters ]!

with: object do: block
	| index |
	referencePolicy = #ignore 
		ifTrue: [ ^ block value ].
	(index := objects at: object ifAbsent: [ nil ]) notNil
		ifTrue: [
			referencePolicy = #error
				ifTrue: [ ^ self error: 'shared reference detected' ].
			self writeReference: index ]
		ifFalse: [
			index := objects size + 1.
			objects at: object put: index.
			block value ]!

writeableStonCharacters
	^ self stonCharacters == STONCharacters
		ifTrue: [ stonCharacters := stonCharacters copy ]
		ifFalse: [ stonCharacters ]!

writeAssociation: association
	jsonMode
		ifTrue: [ self error: 'wrong object class for JSON mode' ].
	self 
		encodeKey: association key 
		value: association value!

writeBoolean: boolean
	writeStream print: boolean!

writeFloat: float
	writeStream print: float!

writeFraction: fraction
	jsonMode
		ifTrue: [ self writeFloat: fraction asFloat ]
		ifFalse: [ writeStream
				print: fraction numerator;
				nextPut: $/;
				print: fraction denominator ]!

writeInteger: integer
	writeStream print: integer!

writeList: collection
	self with: collection do: [ 
		self encodeList: collection ]!

writeMap: hashedCollection
	self with: hashedCollection do: [ 
		self encodeMap: hashedCollection ]!

writeNull
	jsonMode
		ifTrue: [ writeStream nextPutAll: 'null' ]
		ifFalse: [ writeStream print: nil ]!

writeObject: anObject
	| instanceVariableNames |
	(instanceVariableNames := anObject class stonAllInstVarNames) isEmpty
		ifTrue: [ 
			self writeObject: anObject do: [ self encodeMap: #() ] ]
		ifFalse: [ 
			self writeObject: anObject streamMap: [ :dictionary | 
				instanceVariableNames do: [ :each | 
					(anObject instVarNamed: each)
						ifNotNil: [ :value | 
							dictionary at: each asSymbol put: value ]
						ifNil: [ 
							anObject stonShouldWriteNilInstVars 
								ifTrue: [ dictionary at: each asSymbol put: nil ] ] ] ] ]!

writeObject: anObject do: block
	(jsonMode and: [anObject class ~= STON listClass and: [anObject class ~= STON mapClass]])
		ifTrue: [self error: 'wrong object class for JSON mode'].
	self with: anObject
		do: 
			[writeStream nextPutAll: anObject class stonName.
			self prettyPrintSpace.
			block value]!

writeObject: object listSingleton: element
	self writeObject: object do: [
		writeStream nextPut: $[.
		self 
			prettyPrintSpace;
			nextPut: element;
			prettyPrintSpace.
		writeStream nextPut: $] ]!

writeObject: anObject named: stonName do: block
	(jsonMode and: [anObject class ~= STON listClass and: [anObject class ~= STON mapClass]])
		ifTrue: [self error: 'wrong object class for JSON mode'].
	self with: anObject
		do: 
			[writeStream nextPutAll: stonName.
			self prettyPrintSpace.
			block value]!

writeObject: object named: stonName listSingleton: element
	self writeObject: object named: stonName do: [
		writeStream nextPut: $[.
		self 
			prettyPrintSpace;
			nextPut: element;
			prettyPrintSpace.
		writeStream nextPut: $] ]!

writeObject: object streamList: block
	self writeObject: object
		do: 
			[| listWriter |
			listWriter := STON.ListWriter on: self.
			writeStream nextPut: $[.
			self indentedDo: 
					[self newlineIndent.
					block value: listWriter].
			self newlineIndent.
			writeStream nextPut: $]]!

writeObject: object streamMap: block
	self writeObject: object
		do: 
			[| mapWriter |
			mapWriter := STON.MapWriter on: self.
			writeStream nextPut: ${.
			self indentedDo: 
					[self newlineIndent.
					block value: mapWriter].
			self newlineIndent.
			writeStream nextPut: $}]!

writeObject: object streamShortList: block
	self writeObject: object
		do: 
			[| listWriter |
			listWriter := STON.ShortListWriter on: self.
			writeStream nextPut: $[.
			self indentedDo: 
					[self prettyPrintSpace.
					block value: listWriter].
			self prettyPrintSpace.
			writeStream nextPut: $]]!

writeReference: index
	writeStream
		nextPut: $@;
		print: index!

writeScaledDecimal: scaledDecimal
	jsonMode
		ifTrue: [ self writeFloat: scaledDecimal asFloat ]
		ifFalse: [ writeStream
				print: scaledDecimal numerator;
				nextPut: $/;
				print: scaledDecimal denominator;
				nextPut: $s;
				print: scaledDecimal scale ]!

writeString: string
	self encodeString: string!

writeSymbol: symbol
	jsonMode
		ifTrue: [
			self writeString: symbol ]
		ifFalse: [
			writeStream nextPut: $#.
			(self isSimpleSymbol: symbol)
				ifTrue: [
					writeStream nextPutAll: symbol ]
				ifFalse: [
					self encodeString: symbol ] ]! !
!STON.Writer categoriesFor: #asciiOnly:!initialize/release!public! !
!STON.Writer categoriesFor: #close!initialize/release!public! !
!STON.Writer categoriesFor: #encodeCharacter:!private! !
!STON.Writer categoriesFor: #encodeKey:value:!private! !
!STON.Writer categoriesFor: #encodeList:!public!writing! !
!STON.Writer categoriesFor: #encodeMap:!public!writing! !
!STON.Writer categoriesFor: #encodeString:!private! !
!STON.Writer categoriesFor: #encodeStringKeepingNewLines:!private! !
!STON.Writer categoriesFor: #error:!error handling!public! !
!STON.Writer categoriesFor: #escape:with:!initialize/release!public! !
!STON.Writer categoriesFor: #escapeUnicode:!initialize/release!public! !
!STON.Writer categoriesFor: #escapeUnicode4:!private! !
!STON.Writer categoriesFor: #indentedDo:!private! !
!STON.Writer categoriesFor: #initialize!initialize/release!public! !
!STON.Writer categoriesFor: #isSimpleSymbol:!private! !
!STON.Writer categoriesFor: #jsonMode!initialize/release!public! !
!STON.Writer categoriesFor: #jsonMode:!initialize/release!public! !
!STON.Writer categoriesFor: #keepNewLines:!initialize/release!public! !
!STON.Writer categoriesFor: #listElementSeparator!private! !
!STON.Writer categoriesFor: #mapElementSeparator!private! !
!STON.Writer categoriesFor: #newLine:!initialize/release!public! !
!STON.Writer categoriesFor: #newlineIndent!private! !
!STON.Writer categoriesFor: #nextPut:!public! !
!STON.Writer categoriesFor: #on:!initialize/release!public! !
!STON.Writer categoriesFor: #optimizeForLargeStructures!initialize/release!public! !
!STON.Writer categoriesFor: #prettyPrint:!initialize/release!public! !
!STON.Writer categoriesFor: #prettyPrintSpace!private! !
!STON.Writer categoriesFor: #referencePolicy:!initialize/release!public! !
!STON.Writer categoriesFor: #reset!initialize/release!public! !
!STON.Writer categoriesFor: #shortListElementSeparator!private! !
!STON.Writer categoriesFor: #stonCharacters!private! !
!STON.Writer categoriesFor: #with:do:!private! !
!STON.Writer categoriesFor: #writeableStonCharacters!public!writing! !
!STON.Writer categoriesFor: #writeAssociation:!public!writing! !
!STON.Writer categoriesFor: #writeBoolean:!public!writing! !
!STON.Writer categoriesFor: #writeFloat:!public!writing! !
!STON.Writer categoriesFor: #writeFraction:!public!writing! !
!STON.Writer categoriesFor: #writeInteger:!public!writing! !
!STON.Writer categoriesFor: #writeList:!public!writing! !
!STON.Writer categoriesFor: #writeMap:!public!writing! !
!STON.Writer categoriesFor: #writeNull!public!writing! !
!STON.Writer categoriesFor: #writeObject:!public!writing! !
!STON.Writer categoriesFor: #writeObject:do:!public!writing! !
!STON.Writer categoriesFor: #writeObject:listSingleton:!public!writing! !
!STON.Writer categoriesFor: #writeObject:named:do:!public!writing! !
!STON.Writer categoriesFor: #writeObject:named:listSingleton:!public!writing! !
!STON.Writer categoriesFor: #writeObject:streamList:!public!writing! !
!STON.Writer categoriesFor: #writeObject:streamMap:!public!writing! !
!STON.Writer categoriesFor: #writeObject:streamShortList:!public!writing! !
!STON.Writer categoriesFor: #writeReference:!public!writing! !
!STON.Writer categoriesFor: #writeScaledDecimal:!public!writing! !
!STON.Writer categoriesFor: #writeString:!public!writing! !
!STON.Writer categoriesFor: #writeSymbol:!public!writing! !

!STON.Writer class methodsFor!

initialize
	"Modification timestamp 20170131"
	
	self initializeSTONCharacters.
	self initializeSTONSimpleSymbolCharacters!

initializeSTONCharacters
	| escapes |
	STONCharacters := Array new: 127.
	32 to: 126 do: [:each | STONCharacters at: each + 1 put: #pass].
	"This is the minimal STON set of named escapes"
	escapes := #(8 '\b' 9 '\t' 10 '\n' 12 '\f' 13 '\r' 39 '\''' 92 '\\').
	escapes pairsDo: [:code :escape | STONCharacters at: code + 1 put: escape]!

initializeSTONSimpleSymbolCharacters
	"STONSimpleSymbolCharacters asArray collectWithIndex: [ :each :index |
		each isZero ifTrue: [ (index - 1) asCharacter ] ]."

	STONSimpleSymbolCharacters := ByteArray new: 256 withAll: 1.
	1 to: 256
		do: 
			[:each |
			| char |
			char := (each - 1) asCharacter.
			(self isSimpleSymbolChar: char) ifTrue: [STONSimpleSymbolCharacters at: each put: 0]]!

isSimpleSymbolChar: char
	^ 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_./' includes: char!

on: writeStream
	^ self new
		on: writeStream;
		yourself! !
!STON.Writer class categoriesFor: #initialize!class initialization!public! !
!STON.Writer class categoriesFor: #initializeSTONCharacters!class initialization!public! !
!STON.Writer class categoriesFor: #initializeSTONSimpleSymbolCharacters!class initialization!public! !
!STON.Writer class categoriesFor: #isSimpleSymbolChar:!private! !
!STON.Writer class categoriesFor: #on:!instance creation!public! !

