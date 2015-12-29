"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #HtmlParserReadStream
	instanceVariableNames: 'stream replacements'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlParserReadStream guid: (GUID fromString: '{0D236B62-8A9F-453E-9D99-DAD70EB7AE5B}')!
HtmlParserReadStream comment: ''!
!HtmlParserReadStream categoriesForClass!Unclassified! !
!HtmlParserReadStream methodsFor!

basicNextString
	| string wasWhitespace ch |
	wasWhitespace := false.
	string := ''.
	[stream atEnd] whileFalse: 
			[ch := stream peek.
			ch = $< ifTrue: [^string].
			stream next.
			(self isWhitespace: ch) 
				ifTrue: 
					[wasWhitespace 
						ifFalse: 
							[string := string , ' '.
							wasWhitespace := true]]
				ifFalse: 
					[wasWhitespace := false.
					string := string , ch asString]].
	^string!

isWhitespace: ch 
	ch isNil ifTrue: [^false].
	^#(8 9 10 13 32) includes: ch asInteger!

nextAttributeAndValue
	| fieldName fieldValue |
	
	[self skipWhitespace.
	stream atEnd] whileFalse: 
				[(fieldName := self nextFieldName) isNil ifTrue: [^nil].
				self skipWhitespace.
				stream peek = $= 
					ifFalse: [fieldValue := nil]
					ifTrue: 
						[stream next.
						self skipWhitespace.
						fieldValue := self nextFieldValue].
				^Association key: fieldName asUppercase value: fieldValue].
	^nil!

nextFieldName
	| fieldNameStream ch |
	fieldNameStream := WriteStream on: String new.
	[(ch := stream peek) notNil and: [ch isLetter or: [ch isDigit]]] 
		whileTrue: [fieldNameStream nextPut: stream next].
	^fieldNameStream size = 0 ifFalse: [fieldNameStream contents]!

nextFieldValue
	| writeStream ch delimiter wasBackslash |
	stream atEnd ifTrue: [^nil].
	writeStream := WriteStream on: String new.
	ch := stream next.
	(ch = $" or: [ch = $']) 
		ifTrue: [delimiter := ch]
		ifFalse: 
			[
			[writeStream nextPut: ch.
			self isWhitespace: stream peek] whileFalse: 
						[stream atEnd ifTrue: [^writeStream contents].
						ch := stream next].
			^writeStream contents].
	wasBackslash := false.
	[stream atEnd] whileFalse: 
			[ch := stream next.
			ch = delimiter 
				ifTrue: 
					[wasBackslash 
						ifFalse: [stream peek = delimiter ifTrue: [stream next] ifFalse: [^writeStream contents]]]
				ifFalse: [wasBackslash := ch = $\].
			writeStream nextPut: ch].
	^writeStream contents!

nextString
	| string rs ws ch str |
	(string := self basicNextString) isNil ifTrue: [^nil].
	(string includes: $&) ifFalse: [^string].
	rs := ReadStream on: string.
	ws := WriteStream on: String new.
	[rs atEnd] whileFalse: 
			[(ch := rs next) = $& 
				ifTrue: 
					[str := rs upTo: $;.
					(ch := self replacements at: str ifAbsent: []) isNil 
						ifTrue: 
							[ws nextPutAll: str.
							stream atEnd 
								ifTrue: 
									[stream position: stream size - 1.
									stream next = $; ifTrue: [ws nextPut: $;]]]
						ifFalse: [ws nextPut: ch]]
				ifFalse: [ws nextPut: ch]].
	^ws contents!

nextTag
	| tagName endTag ch tagContents |
	stream next.
	stream atEnd ifTrue: [^nil].
	(endTag := (ch := stream peek) = $/) ifTrue: [stream next].
	tagName := ''.
	
	[stream atEnd ifTrue: [^nil].
	ch := stream peek.
	ch isLetter or: [ch isDigit]] 
			whileTrue: 
				[tagName := tagName , ch asString.
				stream next].
	tagContents := WriteStream on: (String new: 128).
	[stream atEnd or: 
			[ch := stream peek.
			ch = $>]] whileFalse: 
			[tagContents nextPut: ch.
			stream next].
	stream atEnd ifFalse: [stream next].
	"parse tagContents for attribute values"
	^Array 
		with: tagName asUppercase
		with: tagContents contents
		with: endTag!

nextToken
	| ch |
	[stream atEnd] whileFalse: 
			[ch := stream peek.
			ch = $< 
				ifTrue: [^self nextTag]
				ifFalse: [(self isWhitespace: ch) ifFalse: [^self nextString]].
			stream next].
	^nil!

on: aReadStream 
	stream := aReadStream!

replacements
	replacements isNil 
		ifTrue: 
			[replacements :=HttpTranslationService getUnicodeTo8bitCodePageMapsForCurrentCodePage.
			replacements
				at: 'nbsp' put: $ ;
				at: 'amp' put: $&;
				at: 'quot' put: $";
				at: 'laquo' put: $";
				at: 'raquo' put: $";
				at: 'lt' put: $<;
				at: 'gt' put: $>;
				yourself].
	^replacements!

reset
	stream reset!

skipWhitespace
	[self isWhitespace: stream peek] whileTrue: [stream next]! !
!HtmlParserReadStream categoriesFor: #basicNextString!public! !
!HtmlParserReadStream categoriesFor: #isWhitespace:!public! !
!HtmlParserReadStream categoriesFor: #nextAttributeAndValue!public! !
!HtmlParserReadStream categoriesFor: #nextFieldName!public! !
!HtmlParserReadStream categoriesFor: #nextFieldValue!public! !
!HtmlParserReadStream categoriesFor: #nextString!public! !
!HtmlParserReadStream categoriesFor: #nextTag!public! !
!HtmlParserReadStream categoriesFor: #nextToken!public! !
!HtmlParserReadStream categoriesFor: #on:!public! !
!HtmlParserReadStream categoriesFor: #replacements!public! !
!HtmlParserReadStream categoriesFor: #reset!public! !
!HtmlParserReadStream categoriesFor: #skipWhitespace!public! !

