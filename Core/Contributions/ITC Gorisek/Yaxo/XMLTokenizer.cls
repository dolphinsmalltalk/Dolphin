"Filed out from Dolphin Smalltalk 7"!

Object subclass: #XMLTokenizer
	instanceVariableNames: 'stream nestedStreams entities externalEntities parameterEntities parsingMarkup peekChar validating buffer contentBuffer'
	classVariableNames: 'CharEscapes NameChars NameDelimiters'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
XMLTokenizer guid: (GUID fromString: '{3504f679-282f-4ded-a387-6493f6c85f67}')!
XMLTokenizer comment: 'XMLTokenizer

bolot@cc.gatech.edu

breaks the stream of characters into a stream of XMLnodes (aka token stream)
token stream is used by XMLparser to generate XMLdocument tree

==========
Dolphin port notes (Steve Waring)
-Methods that have been changed or added are marked with #swYAXO
-Added instance variables: buffer, contentBuffer for buffering.
-Added class variable: NameChars for wellformedness check.'!
!XMLTokenizer categoriesForClass!XML-Parser! !
!XMLTokenizer methodsFor!

atEnd
	nestedStreams notNil ifFalse: [^peekChar isNil and: [self stream atEnd]].
	^self stream atEnd 
		ifTrue: 
			[self popNestingLevel.
			self atEnd]
		ifFalse: [false]!

checkAndExpandReference: parsingContext
	| referenceString nextChar |
	nextChar := self peek.
	self validating
		ifFalse: [^nil].
	nextChar == $&
		ifTrue: [
			self next.
			self peek == $#
				ifTrue: [^self pushStream: (ReadStream on: self nextCharReference asString)].
			referenceString := self nextLiteral.
			self next == $;
				ifFalse: [self errorExpected: ';'].
			self handleEntity: referenceString in: parsingContext ]
		ifFalse: [
			((nextChar == $%
				and: [self parsingMarkup])
				and: [parsingContext == #entityValue])
				ifTrue: [
					self skipSeparators.
					referenceString := self nextLiteral.
					self handleEntity: referenceString in: parsingContext]].

	self atEnd ifTrue: [self errorExpected: 'Character expected.'].
	^nextChar!

checkNestedStream
	nestedStreams notNil
		ifTrue: [(peekChar isNil and: [self stream atEnd])
			ifTrue: [
				self popNestingLevel.
				self checkNestedStream]]
!

conditionalInclude: conditionalKeyword
	conditionalKeyword = 'INCLUDE'
		ifTrue: [^true].
	conditionalKeyword = 'IGNORE'
		ifTrue: [^false].
	^self conditionalInclude: (self parameterEntity: conditionalKeyword) value!

endDocTypeDecl
	"Skip ]>"
	self next; next.
	^nil!

endParsingMarkup
	parsingMarkup := false!

entities
	entities isNil ifTrue: [entities := self initEntities].
	^entities!

entity: refName
	#swYAXO.	"sw: changed to malformedError"
	^self validating 
		ifTrue: 
			[self entities at: refName
				ifAbsentPut: [self malformedError: 'XML undefined entity ' , refName printString]]
		ifFalse: [DTDEntityDeclaration name: refName value: '']!

entity: refName put: aReference
	"Only the first declaration of an entity is valid so if there is already one don't register the new value."

	self entities at: refName ifAbsentPut: [aReference]!

errorExpected: expectedString
	#swYAXO.	"sw: changed from #parseError"
	self malformedError: 'XML expected ' , expectedString printString , ': ' 
				, (stream nextAvailable: 20)	"sw changed from #next:"!

externalEntities
	externalEntities isNil ifTrue: [externalEntities := Dictionary new].
	^externalEntities!

externalEntity: refName
	^self entities
		at: refName
		ifAbsentPut: ['']!

handleCData: aString
	self log: 'CData: ' , aString!

handleComment: aString
	self log: 'Comment: ' , aString!

handleEndDocument
	self log: 'End Doc '!

handleEndTag: aString
	self log: 'End tag: ' , aString!

handleEntity: referenceString in: parsingContext 

	| entity entityValue |
	entity := self entity: referenceString.
	entityValue := entity valueForContext: parsingContext.
	(self class isCharEscape: entityValue)
		ifTrue: [entityValue := entity reference].
	self pushStream: (ReadStream on: entityValue asString)!

handlePCData: aString
	self log: 'PCData: ' , aString!

handlePI: piTarget data: piData
	self log: 'PI: ' , piTarget , ' data ' , piData!

handleStartDocument
	self log: 'Start Doc'!

handleStartTag: tagName attributes: attributes
	self log: 'Start tag: ' , tagName.
	attributes keysAndValuesDo: [:key :value |
		self log: key , '->' , value]!

handleXMLDecl: attributes
	attributes keysAndValuesDo: [:key :value |
		self log: key , '->' , value]!

hasNestedStreams
	^nestedStreams notNil!

initEntities
	| ents |
	#swYAXO.	"sw: changed to use LookupTable"
	#swYAXO.	"Thanks to Jerome Chan for this fix to this methos"
	ents := LookupTable new.
	ents
		at: 'amp' put: (DTDEntityDeclaration name: 'amp' value: $&);
		at: 'quot' put: (DTDEntityDeclaration name: 'quot' value: $");
		at: 'apos' put: (DTDEntityDeclaration name: 'apos' value: $');
		at: 'gt' put: (DTDEntityDeclaration name: 'gt' value: $>);
		at: 'lt' put: (DTDEntityDeclaration name: 'lt' value: $<).
	^ents!

initialize
	#swYAXO.	"sw: changed to initialize buffer and contentBuffer"
	"sw: changed to validating := true. IMO, this mode is better named isCheckingWellFormedness. It does *not* validate"
	super initialize.
	parsingMarkup := false.
	validating := true.
	buffer := WriteStream on: (String new: 32).
	contentBuffer := WriteStream on: (String new: 32)!

log: aString
	"Transcript show: aString; cr"!

malformedError: errorString
	SAXMalformedException signal: errorString!

nestedStreams
	nestedStreams isNil ifTrue: [nestedStreams := OrderedCollection new].
	^nestedStreams!

next
	"Return the next character from the current input stream. If the current stream is at end pop to next nesting level if there is one.
	Due to the potential nesting of original document, included documents and replacment texts the streams are held in a stack representing the nested streams. The current stream is the top one."
	| nextChar |
	#swYAXO.
	nestedStreams notNil ifTrue: [self checkNestedStream].
	"sw: changed from ifNil:ifNotNil"
	peekChar isNil
		ifTrue: [nextChar := self stream nextOrNil "sw: was #next"]
		ifFalse: [ 
			nextChar := peekChar.
			peekChar := nil].
	^nextChar!

nextAttributeInto: attributes

	| attrName attrValue |
	#swYAXO. "sw: added check for duplicate attribute"
	attrName := self nextName.
	(attributes includesKey: attrName) ifTrue: [self malformedError: 'Duplicate attribute name'].
	self skipSeparators.
	self next == $=
		ifFalse: [self errorExpected: '='].
	self skipSeparators.
	attrValue := self nextAttributeValue.
	attributes at: attrName put: attrValue!

nextAttributeListDeclaration
	#swYAXO. "sw: addition for checking well-formedness"

	self skipSeparators.
	self nextName isEmpty ifTrue: [self malformedError: 'ATTLIST: a name is required'].
	self skipSeparators.
	self skipUpTo: $>

	!

nextAttributeValue
	| delimiterChar nextChar nextPeek referenceString entity entityValue |
	#swYAXO.	"Modified to use buffers"
	delimiterChar := self next.
	(delimiterChar == $" or: [delimiterChar == $']) 
		ifFalse: [self errorExpected: 'Attribute value delimiter expected.'].
	buffer reset.
	
	[nextPeek := nextChar := self peek.
	nextChar isNil ifTrue: [self errorExpected: 'Character expected.'].
	nextChar == $< ifTrue: [self malformedError: 'Attribute value included <.'].
	nextChar == $& 
		ifTrue: 
			[self next.
			self peek == $# 
				ifTrue: 
					[nextPeek := nil.
					nextChar := self nextCharReference]
				ifFalse: 
					[referenceString := self nextLiteral.
					self next == $; ifFalse: [self errorExpected: ';'].
					entity := self entity: referenceString.
					entityValue := entity valueForContext: #content.
					(self class isCharEscape: entityValue) 
						ifTrue: 
							[nextPeek := nil.
							nextChar := entityValue]
						ifFalse: 
							[entityValue := entityValue asString.
							entityValue isEmpty 
								ifTrue: [nextPeek := nextChar := nil]
								ifFalse: 
									[self pushStream: (ReadStream on: entityValue asString).
									nextPeek := nextChar := self next]]]]
		ifFalse: [self next].
	nextPeek == delimiterChar] 
			whileFalse: [nextChar notNil ifTrue: [buffer nextPut: nextChar]].
	^buffer contents!

nextCDataContent
	| cdata |
	"Skip $[ "
	#swYAXO. "Add check for well-formedness"
	self next.
	cdata := self nextUpToAll: ']]>'.
	('*<!![CDATA[*' match: cdata) ifTrue: [self malformedError: 'Nested CDATA sections'].
	self handleCData: cdata
!

nextCDataOrConditional

	| nextChar conditionalKeyword |
	"Skip ["
	#swYAXO.
	self next.
	"self skipSeparators" "sw: not wellformed"

	nextChar := self peek.
	nextChar == $%
		ifTrue: [
			self checkAndExpandReference: (self parsingMarkup ifTrue: [#dtd] ifFalse: [#content]).
			conditionalKeyword := self nextLiteral.
			self skipSeparators.
			^self next == $[
				ifTrue: [
						self skipSeparators.
						self nextIncludeSection: (self conditionalInclude: conditionalKeyword)]
				ifFalse: [self errorExpected: '[' ]].

	nextChar == $C
		ifTrue: [
			^self nextLiteral = 'CDATA'
				ifTrue: [self peek == $[
							ifTrue: [self nextCDataContent]
							ifFalse: [self errorExpected: '[' ]]
				ifFalse: [self errorExpected: 'CData']].
	self errorExpected: 'CData or declaration'
!

nextCharReference
	| base numberString charValue |
	#swYAXO.	"changed for Dolphin's Number parsing"
	self next == $# ifFalse: [self errorExpected: 'character reference'].
	base := self peek == $x 
				ifTrue: 
					[self next.
					'16r']
				ifFalse: ['10r'].
	numberString := self nextUpTo: $;.
	charValue := [Number fromString: base , numberString asUppercase] on: Error
				do: [:ex | self errorExpected: 'Number.'].
	^charValue > 255 ifTrue: [^$-] ifFalse: [charValue asCharacter]!

nextComment
	"Skip first -"

	| string |
	#swYAXO.	"sw: check for comment wellformedness"
	self next.
	self next == $- ifFalse: [self errorExpected: 'second comment $-'].
	string := self nextUpToAll: '--'.
	self next == $> ifFalse: [self errorExpected: '-- to be followed by >'].
	self handleComment: string!

nextDocType
	| declType |
	declType := self nextLiteral.
	declType = 'DOCTYPE'
		ifTrue: [
			self startParsingMarkup.
			^self nextDocTypeDecl].
	self errorExpected: 'markup declaration, not ' , declType printString!

nextDocTypeDecl
	| nextChar |
	self skipSeparators.
	self nextLiteral.
	self skipSeparators.
	self peek == $[
		ifFalse: [[nextChar := self peek.
				nextChar == $> or: [nextChar == $[ ]] whileFalse: [self next]].
	self peek == $[
		ifTrue: [
			self next.
			[self skipSeparators.
			self peek == $]] whileFalse: [
				self checkAndExpandReference: #dtd.
				self nextNode].
			self next == $] 
				ifFalse: [self errorExpected: ']' ]].
	self skipSeparators.
	self next == $>
		ifFalse: [self errorExpected: '>' ].

	self endParsingMarkup!

nextElementDeclaration
	#swYAXO.	"sw: addition for checking well-formedness"
	self skipSeparators.
	self nextName isEmpty ifTrue: [self malformedError: 'ELEMENT: a name is required'].
	self skipSeparators.
	self skipUpTo: $>!

nextEndTag
	| string |
	"Skip /"
	#swYAXO. "sw: changed to use buffer"
	contentBuffer position = 0 ifFalse: [
		self handlePCData: contentBuffer contents].
	self next.
	self skipSeparators.
	string := (self nextUpTo: $>) trimBlanks. "sw: was #withBlanksTrimmed."
	self handleEndTag: string!

nextEntity
	"return the next XMLnode, or nil if there are no more"

	"branch, depending on what the first character is"

	"nestedStreams notNil ifTrue: [self halt]."

	#swYAXO.	"sw: changed to use buffer"
	contentBuffer reset.
	self pushSeparators.
	self atEnd 
		ifTrue: 
			[self handleEndDocument.
			^nil].
	self checkAndExpandReference: (self parsingMarkup ifTrue: [#dtd] ifFalse: [#content]).
	^self peek = $< ifTrue: [self nextNode] ifFalse: [self nextPCData]!

nextEntityDeclaration
	| entityName entityDef referenceClass reference |
	#swYAXO.
	self skipRequiredSeparators.	"sw: check for wellformedness"
	referenceClass := self peek == $% 
				ifTrue: 
					[self next.
					self skipRequiredSeparators.	"sw: check for wellformedness"
					DTDParameterEntityDeclaration]
				ifFalse: [DTDEntityDeclaration].
	"sw: changed from #nextLiteral"
	entityName := self nextName.
	self skipSeparators.
	entityDef := (self peek == $" or: [self peek == $']) 
				ifTrue: [self nextEntityValue]
				ifFalse: [self nextExternalId].
	self skipUpTo: $>.
	reference := referenceClass name: entityName value: entityDef.
	reference registerIn: self.
	^reference!

nextEntityValue
	| delimiterChar entityValueStream nextChar nextPeek referenceString entity entityValue |
	#swYAXO.	"sw: changed from ifNil: etc"
	delimiterChar := self next.
	(delimiterChar == $" or: [delimiterChar == $']) 
		ifFalse: [self errorExpected: 'Entity value delimiter expected.'].
	entityValueStream := WriteStream on: String new.
	
	[nextPeek := nextChar := self peek.
	nextChar isNil ifTrue: [self errorExpected: 'Character expected.'].
	nextChar == $& 
		ifTrue: 
			[self next.
			self peek == $# 
				ifTrue: 
					[nextPeek := nil.
					nextChar := self nextCharReference]
				ifFalse: 
					[referenceString := self nextLiteral.
					self next == $; ifFalse: [self errorExpected: ';'].
					entity := self entity: referenceString.
					entityValue := entity valueForContext: #entityValue.
					self pushStream: (ReadStream on: entityValue asString).
					nextPeek := nextChar := self next]]
		ifFalse: 
			[nextChar == $% 
				ifTrue: 
					[self skipSeparators.
					referenceString := self nextLiteral.
					nextChar := self handleEntity: referenceString in: #entityValue.
					nextPeek := nextChar := self next]
				ifFalse: [self next]].
	nextPeek == delimiterChar] 
			whileFalse: [nextChar notNil ifTrue: [entityValueStream nextPut: nextChar]].
	^entityValueStream contents!

nextExternalId
	| extDefType systemId dir |
	#swYAXO.	"sw: removed parsing of external DTD (not required for a non-validating processor"
	extDefType := self nextLiteral.
	extDefType = 'PUBLIC' 
		ifTrue: 
			[self skipRequiredSeparators.
			self nextPubidLiteral.
			self skipSeparators.
			self peek == $> ifFalse: [systemId := self nextSystemLiteral]].
	extDefType = 'SYSTEM' 
		ifTrue: 
			[self skipRequiredSeparators.
			systemId := self nextSystemLiteral].
	^nil
	"systemId
		ifNil: [^nil].
	dir := self topStream directory.
	^(dir fileExists: systemId)
		ifTrue: [(dir readOnlyFileNamed: systemId) contentsOfEntireFile]
		ifFalse: ['']"!

nextIncludeSection: parseSection
	| section |
	"Read the file up to the next include section delimiter and parse it if parseSection is true"

	
	section := self nextUpToAll: ']]>'.
	parseSection
		ifTrue: [
			self pushStream: (ReadStream on: section)]!

nextLiteral
	| resultStream nextChar validChars resultString |
	#swYAXO.
	validChars := ##(':-_.' asSet).
	resultStream := (String new: 10) writeStream.
	((nextChar := self peek) isLetter
		or: [nextChar == $_])
		ifFalse: [self errorExpected: 'Name literal.'].
	[nextChar := self peek.
	(nextChar isLetter or: [nextChar isDigit or: [validChars includes: nextChar]]) not
		ifTrue: [
			resultString := resultStream contents.
			resultString isEmpty
				ifTrue: [self errorExpected: 'Name literal']
				ifFalse: [^resultString]]
		ifFalse: [
			nextChar == $&
				ifTrue: [
					nextChar := self next.
					resultStream nextPut: (self peek == $#
						ifTrue: [self nextCharReference]
						ifFalse: [^resultStream contents])]
				ifFalse: [
					resultStream nextPut: self next]]] repeat!

nextMarkupDeclaration
	| declType |
	#swYAXO.	"sw: added extra cases to check for wellformedness"
	declType := self nextLiteral.
	self validating ifFalse: [^self skipMarkupDeclaration].
	declType = 'ENTITY' ifTrue: [^self nextEntityDeclaration].
	declType = 'NOTATION' ifTrue: [^self nextNotationDeclaration].
	declType = 'ATTLIST' ifTrue: [^self nextAttributeListDeclaration].
	declType = 'ELEMENT' ifTrue: [^self nextElementDeclaration].
	self malformedError: 'Unknown markup declaration'!

nextName
	| nextChar |
	#swYAXO.	"sw: changed to use buffers"
	buffer reset.
	nextChar := self peek.
	nextChar isNil ifTrue: [self malformedError: 'Character expected.'].
	"sw: changed to check first char of name for wellformedness"
	(nextChar isDigit or: [nextChar == $. or: [nextChar == $-]]) 
		ifTrue: [self malformedError: 'Illegal first character for a name'].
	
	[nextChar := self peek.
	nextChar isNil ifTrue: [self errorExpected: 'Character expected.'].
	NameDelimiters at: nextChar codePoint	"sw: changed from asciiValue"] 
			whileFalse: 
				["sw: changed to check name for wellformedness"

				(NameChars at: nextChar codePoint) ifFalse: [self malformedError: 'Illegal name'].
				buffer nextPut: self next].
	^buffer contents!

nextNode
	| nextChar |
	"Skip < "
	self next.
	nextChar := self peek.
	nextChar == $!! ifTrue: [
		"Skip !!"
		self next.
		nextChar := self peek.
		nextChar == $- ifTrue: [^self nextComment].
		nextChar == $[ ifTrue: [^self nextCDataOrConditional].
		^self parsingMarkup
			ifTrue: [self nextMarkupDeclaration]
			ifFalse: [self nextDocType]].
	nextChar == $? ifTrue: [^self nextPI].
	^self nextTag!

nextNotationDeclaration
	| idType |
	"Transcript
		show: 'nextNotationDeclaration';
		cr;
		flush."
	self skipSeparators.
	self nextName.
	self skipSeparators.
	idType := self nextLiteral.
	idType  = 'PUBLIC'
		ifTrue: [
			self skipSeparators.
			self nextPubidLiteral.
			self skipSeparators.
			self peek == $>
				ifFalse: [self nextSystemLiteral]].

	idType  = 'SYSTEM'
		ifTrue: [
			self skipSeparators.
			self nextSystemLiteral].
	self skipSeparators.
	self next == $>
		ifFalse: [self errorExpected: '>' ].

!

nextPCData
	| nextChar referenceString entity entityValue nextPeek |
	#swYAXO.	"sw: changed to use buffers"
	self validating
		ifFalse: [
			[self peek == $<]
				whileFalse: [contentBuffer nextPut: self next].
			^self handlePCData: contentBuffer contents].

	[
	nextPeek := nextChar := self peek.
	nextChar isNil ifTrue: [self errorExpected: 'Character expected.'].
	nextChar == $&
		ifTrue: [
			self next.
			self peek == $#
				ifTrue: [
					nextPeek := nil.
					nextChar := self nextCharReference]
				ifFalse: [
					referenceString := self nextLiteral.
					self next == $;
						ifFalse: [self errorExpected: ';'].
					entity := self entity: referenceString.
					entityValue := entity valueForContext: #content.
					(self class isCharEscape: entityValue)
						ifTrue: [
							nextPeek := nil.
							nextChar := entityValue]
						ifFalse: [
							entityValue := entityValue asString.
							entityValue isEmpty
								ifTrue: [nextPeek := nextChar := nil]
								ifFalse: [
									self pushStream: (ReadStream on: entityValue asString).
									nextPeek := nextChar := self peek]]]]
		ifFalse: [nextPeek == $< ifFalse: [self next]].
	nextPeek == $<]
		whileFalse: [
			nextChar notNil ifTrue: [contentBuffer nextPut: nextChar]].
	self handlePCData: contentBuffer contents!

nextPI
	| piTarget piData |
	"Skip ?"
	self next.
	piTarget := self nextLiteral.
	piTarget asUppercase = 'XML'
		ifTrue: [^self nextXMLDecl].
	self skipSeparators.
	piData := self nextUpToAll: '?>'.
	self handlePI: piTarget data: piData!

nextPubidLiteral
	^self nextAttributeValue!

nextSystemLiteral
	^self nextAttributeValue!

nextTag
	| tagName attributes nextChar |
	#swYAXO.
	self peek = $/ ifTrue: [^self nextEndTag].
	tagName := self nextName.
	self skipSeparators.
	"sw: changed from Dictionary"
	attributes := LookupTable new.
	[(nextChar := self peek) == $> or: [nextChar == $/]] whileFalse: 
			[self checkAndExpandReference: #content.
			self nextAttributeInto: attributes.
			self skipSeparators].
	self handleStartTag: tagName attributes: attributes.
	self next == $/ 
		ifTrue: 
			[self handleEndTag: tagName.
			"sw: added wellformedness check"
			self next == $> ifFalse: [self malformedError: 'Invalid Empty Element Tag']]!

nextUpTo: delimiter
	| resultStream nextChar |
	self unpeek.
	resultStream := WriteStream on: (String new: 10).
	[self atEnd or: [(nextChar := self next) == delimiter]]
		whileFalse: [resultStream nextPut: nextChar].
	nextChar == delimiter
		ifFalse: [self malformedError: 'XML no delimiting ' , delimiter printString , ' found'].
	^resultStream contents
!

nextUpToAll: delimitingString
	| string |
	self unpeek.
	string := self stream upToAll: delimitingString.
	self stream skip: delimitingString size negated.
	(self stream next: delimitingString size) = delimitingString
		ifFalse: [self malformedError: 'XML no delimiting ' , delimitingString printString , ' found'].
	^string
!

nextXMLDecl
	| attributes nextChar |
	#swYAXO.
	self skipSeparators.
	"sw: changed from Dictionary"
	attributes := LookupTable new.
	[(nextChar := self peek) == $?] whileFalse: 
			[self nextAttributeInto: attributes.
			self skipSeparators].
	self next.
	self next == $> ifFalse: [self errorExpected: '> expected.'].
	self handleXMLDecl: attributes!

parameterEntities
	parameterEntities isNil ifTrue: [parameterEntities := Dictionary new].
	^parameterEntities!

parameterEntity: refName
	^self parameterEntities
		at: refName
		ifAbsent: [self malformedError: 'XML undefined parameter entity ' , refName printString]!

parameterEntity: refName put: aReference
	"Only the first declaration of an entity is valid so if there is already one don't register the new value."
	self parameterEntities at: refName ifAbsentPut: [aReference]!

parseStream: aStream
	self stream: aStream!

parsingMarkup
	^parsingMarkup!

peek
	"Return the next character from the current input stream. If the current stream poop to next nesting level if there is one.
	Due to the potential nesting of original document, included documents and replacment texts the streams are held in a stack representing the nested streams. The current stream is the top one."

	#swYAXO.
	nestedStreams notNil ifTrue: [self checkNestedStream].
	peekChar isNil ifTrue: [peekChar := self stream nextOrNil	"sw was #next"].
	^peekChar!

popNestingLevel
	nestedStreams notNil
		ifTrue: [
			self stream close.
			self stream: self nestedStreams removeLast.
			self nestedStreams size > 0
				ifFalse: [nestedStreams := nil]]!

pushBack: aString
	| pushBackString |
	#swYAXO.
	pushBackString := peekChar
		ifNil: [aString]
		ifNotNil: [:t |  "sw squeak block is monadic" peekChar asString , aString].
	peekChar := nil.
	self pushStream: (ReadStream on: pushBackString)!

pushSeparators
	| nextChar |
	#swYAXO.	"sw: added for wellformedness checks"
	[(nextChar := self peek) notNil and: [nextChar isSeparator]] 
		whileTrue: [contentBuffer nextPut: self next].
	(nestedStreams notNil and: [self atEnd]) 
		ifTrue: 
			[self checkNestedStream.
			self pushSeparators]!

pushStream: newStream
	"Continue parsing from the new nested stream."
	self unpeek.
	self nestedStreams addLast: self stream.
	self stream: newStream!

skipMarkupDeclaration
	self skipUpTo: $>!

skipRequiredSeparators
	| nextChar skipped |
	#swYAXO.	"sw: added for wellformedness checks"
	skipped := false.
	[(nextChar := self peek) notNil and: [nextChar isSeparator]] whileTrue: 
			[self next.
			skipped := true].
	skipped ifFalse: [self malformedError: 'Required S not found'].!

skipSeparators
	| nextChar |
	[(nextChar := self peek) notNil
		and: [nextChar isSeparator]]
		whileTrue: [self next].
	(nestedStreams notNil and: [self atEnd])
		ifTrue: [
			self checkNestedStream.
			self skipSeparators]!

skipUpTo: delimiter
	| nextChar |
	self unpeek.
	[self atEnd or: [(nextChar := self next) == delimiter]]
		whileFalse: [].
	nextChar == delimiter
		ifFalse: [self malformedError: 'XML no delimiting ' , delimiter printString , ' found']
!

startParsingMarkup
	parsingMarkup := true!

stream
	^stream!

stream: newStream
	"Continue parsing from the new nested stream."
	stream := newStream!

topStream
	^nestedStreams notNil
		ifTrue: [self nestedStreams first]
		ifFalse: [self stream]!

unpeek
	peekChar
		notNil ifTrue: [ 
			peekChar := nil.
			self stream skip: -1]!

validating
	^validating!

validating: aBoolean
	validating := aBoolean! !
!XMLTokenizer categoriesFor: #atEnd!public!streaming! !
!XMLTokenizer categoriesFor: #checkAndExpandReference:!public!tokenizing! !
!XMLTokenizer categoriesFor: #checkNestedStream!public!streaming! !
!XMLTokenizer categoriesFor: #conditionalInclude:!public!tokenizing! !
!XMLTokenizer categoriesFor: #endDocTypeDecl!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #endParsingMarkup!modes!private! !
!XMLTokenizer categoriesFor: #entities!entities!public! !
!XMLTokenizer categoriesFor: #entity:!entities!public! !
!XMLTokenizer categoriesFor: #entity:put:!entities!public! !
!XMLTokenizer categoriesFor: #errorExpected:!errors!public! !
!XMLTokenizer categoriesFor: #externalEntities!entities!public! !
!XMLTokenizer categoriesFor: #externalEntity:!entities!public! !
!XMLTokenizer categoriesFor: #handleCData:!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleComment:!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleEndDocument!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleEndTag:!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleEntity:in:!entities!public! !
!XMLTokenizer categoriesFor: #handlePCData:!handling tokens!public! !
!XMLTokenizer categoriesFor: #handlePI:data:!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleStartDocument!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleStartTag:attributes:!handling tokens!public! !
!XMLTokenizer categoriesFor: #handleXMLDecl:!handling tokens!public! !
!XMLTokenizer categoriesFor: #hasNestedStreams!public!streaming! !
!XMLTokenizer categoriesFor: #initEntities!entities!public! !
!XMLTokenizer categoriesFor: #initialize!initialize!public! !
!XMLTokenizer categoriesFor: #log:!accessing!private! !
!XMLTokenizer categoriesFor: #malformedError:!errors!public! !
!XMLTokenizer categoriesFor: #nestedStreams!accessing!private! !
!XMLTokenizer categoriesFor: #next!public!streaming! !
!XMLTokenizer categoriesFor: #nextAttributeInto:!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextAttributeListDeclaration!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextAttributeValue!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextCDataContent!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextCDataOrConditional!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextCharReference!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextComment!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextDocType!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextDocTypeDecl!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextElementDeclaration!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextEndTag!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextEntity!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextEntityDeclaration!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextEntityValue!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextExternalId!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextIncludeSection:!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextLiteral!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextMarkupDeclaration!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextName!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextNode!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextNotationDeclaration!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #nextPCData!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextPI!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextPubidLiteral!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextSystemLiteral!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextTag!public!tokenizing! !
!XMLTokenizer categoriesFor: #nextUpTo:!public!streaming! !
!XMLTokenizer categoriesFor: #nextUpToAll:!public!streaming! !
!XMLTokenizer categoriesFor: #nextXMLDecl!public!tokenizing! !
!XMLTokenizer categoriesFor: #parameterEntities!entities!public! !
!XMLTokenizer categoriesFor: #parameterEntity:!entities!public! !
!XMLTokenizer categoriesFor: #parameterEntity:put:!entities!public! !
!XMLTokenizer categoriesFor: #parseStream:!accessing!public! !
!XMLTokenizer categoriesFor: #parsingMarkup!private!testing! !
!XMLTokenizer categoriesFor: #peek!public!streaming! !
!XMLTokenizer categoriesFor: #popNestingLevel!public!streaming! !
!XMLTokenizer categoriesFor: #pushBack:!public!streaming! !
!XMLTokenizer categoriesFor: #pushSeparators!public!streaming! !
!XMLTokenizer categoriesFor: #pushStream:!public!streaming! !
!XMLTokenizer categoriesFor: #skipMarkupDeclaration!public!tokenizing dtd! !
!XMLTokenizer categoriesFor: #skipRequiredSeparators!public!streaming! !
!XMLTokenizer categoriesFor: #skipSeparators!public!streaming! !
!XMLTokenizer categoriesFor: #skipUpTo:!public!streaming! !
!XMLTokenizer categoriesFor: #startParsingMarkup!modes!private! !
!XMLTokenizer categoriesFor: #stream!accessing!private! !
!XMLTokenizer categoriesFor: #stream:!accessing!private! !
!XMLTokenizer categoriesFor: #topStream!public!streaming! !
!XMLTokenizer categoriesFor: #unpeek!public!streaming! !
!XMLTokenizer categoriesFor: #validating!public!testing! !
!XMLTokenizer categoriesFor: #validating:!accessing!public! !

!XMLTokenizer class methodsFor!

addressBookXML
	^'<addressbook>
  <person employee-number="A0000" family-name="Gates" first-name="Bob">
    <contact-info><!!--Confidential--></contact-info>
    <address city="Los Angeles" number="1239" state="CA" street="Pine Rd."/>
    <job-info employee-type="Full-Time" is-manager="no" job-description="Manager"/>
    <manager employee-number="A0000"/>
  </person>
  <person employee-number="A7000" family-name="Brown"
    first-name="Robert" middle-initial="L.">
    <contact-info>
      <email address="robb@iro.ibm.com"/>
      <home-phone number="03-3987873"/>
    </contact-info>
    <address city="New York" number="344" state="NY" street="118 St."/>
    <job-info employee-type="Full-Time" is-manager="yes" job-description="Group Leader"/>
    <manager employee-number="A0000"/>
  </person>
  <person employee-number="A7890" family-name="DePaiva"
    first-name="Kassie" middle-initial="W.">
    <contact-info><!!-- Kassie''s agent phone: 03-987654 --></contact-info>
    <address city="Los Angeles" number="1234" state="CA" street="Pine Rd."/>
    <job-info employee-type="Full-Time" is-manager="no" job-description="Actor"/>
    <manager employee-number="A0000"/>
    <misc-info>One of the most talented actresses on Daytime. Kassie
      plays the devious and beautiful Blair Cramer on ABC&apos;s
      &quot;One Life To Live.&quot;</misc-info>
  </person>
  <person employee-number="A7987" family-name="Smith" first-name="Joe">
    <contact-info>
      <email address="joes@iro.ibm.com"/>
      <mobile-phone number="888-7657765"/>
      <home-phone number="03-8767898"/>
      <home-phone number="03-8767871"/>
    </contact-info>
    <address city="New York" number="12789" state="NY" street="W. 15th Ave."/>
    <job-info employee-type="Part-Time" is-manager="no" job-description="Hacker"/>
    <manager employee-number="A7000"/>
  </person>
</addressbook>
'!

addressBookXMLWithDTD
	^'<?xml version="1.0" encoding="UTF-8"?>
<!!DOCTYPE addressbook SYSTEM "addressbook.dtd">
<?xml:stylesheet type="text/xsl" href="demo.xsl"?>
<addressbook>
  <person employee-number="A0000" family-name="Gates" first-name="Bob">
    <contact-info><!!--Confidential--></contact-info>
    <address city="Los Angeles" number="1239" state="CA" street="Pine Rd."/>
    <job-info employee-type="Full-Time" is-manager="no" job-description="Manager"/>
    <manager employee-number="A0000"/>
  </person>
  <person employee-number="A7000" family-name="Brown"
    first-name="Robert" middle-initial="L.">
    <contact-info>
      <email address="robb@iro.ibm.com"/>
      <home-phone number="03-3987873"/>
    </contact-info>
    <address city="New York" number="344" state="NY" street="118 St."/>
    <job-info employee-type="Full-Time" is-manager="yes" job-description="Group Leader"/>
    <manager employee-number="A0000"/>
  </person>
  <person employee-number="A7890" family-name="DePaiva"
    first-name="Kassie" middle-initial="W.">
    <contact-info><!!-- Kassie''s agent phone: 03-987654 --></contact-info>
    <address city="Los Angeles" number="1234" state="CA" street="Pine Rd."/>
    <job-info employee-type="Full-Time" is-manager="no" job-description="Actor"/>
    <manager employee-number="A0000"/>
    <misc-info>One of the most talented actresses on Daytime. Kassie
      plays the devious and beautiful Blair Cramer on ABC&apos;s
      &quot;One Life To Live.&quot;</misc-info>
  </person>
  <person employee-number="A7987" family-name="Smith" first-name="Joe">
    <contact-info>
      <email address="joes@iro.ibm.com"/>
      <mobile-phone number="888-7657765"/>
      <home-phone number="03-8767898"/>
      <home-phone number="03-8767871"/>
    </contact-info>
    <address city="New York" number="12789" state="NY" street="W. 15th Ave."/>
    <job-info employee-type="Part-Time" is-manager="no" job-description="Hacker"/>
    <manager employee-number="A7000"/>
  </person>
</addressbook>
'!

exampleAddressBook
	"
	XMLTokenizer exampleAddressBook
	"

	| tokenizer |
	#swYAXO.
	tokenizer := XMLTokenizer on: self addressBookXML readStream.
	[tokenizer next notNil] whileTrue: [].
	^tokenizer!

exampleAddressBookWithDTD
	"
	XMLTokenizer exampleAddressBookWithDTD
	"

	| tokenizer |
	tokenizer := XMLTokenizer on: self addressBookXMLWithDTD readStream.
	[tokenizer next notNil] whileTrue: [].
	^tokenizer!

initialize
	"
	XMLTokenizer initialize
	"

	| nameDelimiters |
	#swYAXO.	"added intialization of NameChars"
	CharEscapes := #($& $" $' $> $<) asSet.
	nameDelimiters := #(9 10 12 13 32 61 62 47).
	NameDelimiters := Array new: 256.
	NameDelimiters atAllPut: false.
	nameDelimiters do: [:each | NameDelimiters at: each put: true].

	"sw: can only mark common ASCII/UTF8 characters"
	NameChars := Array new: 256.
	NameChars atAllPut: true.
	1 to: 47 do: [:i | NameChars at: i put: false].
	91 to: 96 do: [:i | NameChars at: i put: false].
	123 to: 127 do: [:i | NameChars at: i put: false].
	'.-_:' do: [:each | NameChars at: each codePoint put: true]!

isCharEscape: aChar
	^CharEscapes includes: aChar!

new
	^super new initialize!

on: aStream
	^self new parseStream: aStream! !
!XMLTokenizer class categoriesFor: #addressBookXML!examples!public! !
!XMLTokenizer class categoriesFor: #addressBookXMLWithDTD!examples!public! !
!XMLTokenizer class categoriesFor: #exampleAddressBook!examples!public! !
!XMLTokenizer class categoriesFor: #exampleAddressBookWithDTD!examples!public! !
!XMLTokenizer class categoriesFor: #initialize!class initialization!public! !
!XMLTokenizer class categoriesFor: #isCharEscape:!accessing!public! !
!XMLTokenizer class categoriesFor: #new!instance creation!public! !
!XMLTokenizer class categoriesFor: #on:!instance creation!public! !

