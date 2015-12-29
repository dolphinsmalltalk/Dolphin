"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #JavaScriptMinifier
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JavaScriptMinifier guid: (GUID fromString: '{BBA4C944-C2B8-4EB6-BEBB-F4E4495EAA8B}')!
JavaScriptMinifier comment: ''!
!JavaScriptMinifier categoriesForClass!Unclassified! !
!JavaScriptMinifier class methodsFor!

action: anInteger readStream: rs writeStream: ws data: data 
	anInteger <= 1 ifTrue: [ws nextPut: (data at: #a)].
	anInteger <= 2 
		ifTrue: 
			[data at: #a put: (data at: #b).
			((data at: #a) = $' or: [(data at: #a) = $"]) 
				ifTrue: 
					[self 
						parseString: data
						readStream: rs
						writeStream: ws]].
	anInteger <= 3 
		ifTrue: 
			[data at: #b put: (self nextSkipComments: rs).
			((data at: #b) = $/ and: ['(,=:[!!&|' includes: (data at: #a)]) 
				ifTrue: 
					[ws
						nextPut: (data at: #a);
						nextPut: (data at: #b).
					self 
						parseRegEx: data
						readStream: rs
						writeStream: ws.
					data at: #b put: (self nextSkipComments: rs)]]!

isAlphanum: aCharacter 
	^aCharacter isAlphaNumeric 
		or: [aCharacter = $_ or: [aCharacter = $$ or: [aCharacter = $\ or: [aCharacter asInteger > 126]]]]!

minify: aStringOrStream 
	| rs ws data a b |
	rs := aStringOrStream isString ifTrue: [ReadStream on: aStringOrStream] ifFalse: [aStringOrStream].
	ws := WriteStream on: String new.
	data := LookupTable new.
	data at: #a put: 10 asCharacter.
	self 
		action: 3
		readStream: rs
		writeStream: ws
		data: data.
	[(data at: #a) isNil] whileFalse: 
			[a := data at: #a.
			b := data at: #b.
			a = $  
				ifTrue: 
					[(self isAlphanum: b) 
						ifTrue: 
							[self 
								action: 1
								readStream: rs
								writeStream: ws
								data: data]
						ifFalse: 
							[self 
								action: 2
								readStream: rs
								writeStream: ws
								data: data]]
				ifFalse: 
					[a = 10 asCharacter 
						ifTrue: 
							[(b = ${ or: [b = $[ or: [b = $( or: [b = $+ or: [b = $-]]]]) 
								ifTrue: 
									[self 
										action: 1
										readStream: rs
										writeStream: ws
										data: data]
								ifFalse: 
									[b = $  
										ifTrue: 
											[self 
												action: 3
												readStream: rs
												writeStream: ws
												data: data]
										ifFalse: 
											[(self isAlphanum: b) 
												ifTrue: 
													[self 
														action: 1
														readStream: rs
														writeStream: ws
														data: data]
												ifFalse: 
													[self 
														action: 2
														readStream: rs
														writeStream: ws
														data: data]]]]
						ifFalse: 
							[b = $  
								ifTrue: 
									[(self isAlphanum: a) 
										ifTrue: 
											[self 
												action: 1
												readStream: rs
												writeStream: ws
												data: data]
										ifFalse: 
											[self 
												action: 3
												readStream: rs
												writeStream: ws
												data: data]]
								ifFalse: 
									[b = 10 asCharacter 
										ifTrue: 
											[(a = $} or: [a = $] or: [a = $) or: [a = $+ or: [a = $- or: [a = $" or: [a = $']]]]]]) 
												ifTrue: 
													[self 
														action: 1
														readStream: rs
														writeStream: ws
														data: data]
												ifFalse: 
													[(self isAlphanum: a) 
														ifTrue: 
															[self 
																action: 1
																readStream: rs
																writeStream: ws
																data: data]
														ifFalse: 
															[self 
																action: 3
																readStream: rs
																writeStream: ws
																data: data]]]
										ifFalse: 
											[self 
												action: 1
												readStream: rs
												writeStream: ws
												data: data]]]]].
	^ws contents!

next: aStream 
	| c |
	aStream atEnd ifTrue: [^nil].
	c := aStream next.
	(c asInteger > 32 or: [c asInteger = 10]) ifTrue: [^c].
	c asInteger = 13 ifTrue: [^10 asCharacter].
	^$ !

nextSkipComments: aStream 
	| c n |
	c := self next: aStream.
	c = $/ 
		ifTrue: 
			[(n := aStream peek) = $/ 
				ifTrue: [[(c := self next: aStream) = 10 asCharacter] whileFalse]
				ifFalse: 
					[n = $* 
						ifTrue: 
							[self next: aStream.
							[true] whileTrue: 
									[((c := self next: aStream) = $* and: [aStream peek = $/]) 
										ifTrue: 
											[self next: aStream.
											^$ ]]]]].
	^c!

parseRegEx: data readStream: rs writeStream: ws 
	[rs atEnd] whileFalse: 
			[data at: #a put: (self next: rs).
			(data at: #a) = $/ ifTrue: [^self].
			(data at: #a) = $\ 
				ifTrue: 
					[ws nextPut: (data at: #a).
					data at: #a put: (self next: rs)]
				ifFalse: 
					[(data at: #a) = 10 asCharacter ifTrue: [self error: 'Unterminated Regular Expression literal']].
			ws nextPut: (data at: #a)]!

parseString: data readStream: rs writeStream: ws 
	[rs atEnd] whileFalse: 
			[ws nextPut: (data at: #a).
			data at: #a put: (self next: rs).
			(data at: #a) = (data at: #b) ifTrue: [^self].
			(data at: #a) = $\ 
				ifTrue: 
					[ws nextPut: (data at: #a).
					data at: #a put: (self next: rs)]
				ifFalse: [(data at: #a) = 10 asCharacter ifTrue: [self error: 'Unterminated string literal']]]! !
!JavaScriptMinifier class categoriesFor: #action:readStream:writeStream:data:!private! !
!JavaScriptMinifier class categoriesFor: #isAlphanum:!private! !
!JavaScriptMinifier class categoriesFor: #minify:!public! !
!JavaScriptMinifier class categoriesFor: #next:!private! !
!JavaScriptMinifier class categoriesFor: #nextSkipComments:!private! !
!JavaScriptMinifier class categoriesFor: #parseRegEx:readStream:writeStream:!private! !
!JavaScriptMinifier class categoriesFor: #parseString:readStream:writeStream:!private! !

