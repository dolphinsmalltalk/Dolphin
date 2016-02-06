"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaIfaceParser
	instanceVariableNames: 'events commentQueue lexerConstantPrefix classification isTestRun commands category parsingDeprecated'
	classVariableNames: 'Commands IgnoredMessages RenamedMessages TypeMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaIfaceParser guid: (GUID fromString: '{BABB8E5D-5EE9-43B2-A88B-0959484C008E}')!
ScintillaIfaceParser comment: 'This class reads the Scintilla.iface definition and autogenerates wrapper methods and the constants pool.

The parsing is pretty grungy, but adequate for purpose.

self new isTestRun: false; parseFile

(ScintillaIfaceParser classPool at: ''RenamedMessages'') difference: ScintillaView selectors
'!
!ScintillaIfaceParser categoriesForClass!Development! !
!ScintillaIfaceParser methodsFor!

autoGenCategoryName
	"Private - Answer the name of the special method category for auto-generated
	methods."

	^'**auto generated**'!

autoGenEventCategories
	"Private - Answer the special method categories for auto-generated
	property accessors in the receivers wrapper class."

	^Array with: (MethodCategory name: self autoGenCategoryName)
		with: (MethodCategory name: 'event handling-scintilla')!

autoGenMethodCategories
	"Private - Answer the special method categories for auto-generated
	property accessors in the receivers wrapper class."

	^Array with: (MethodCategory name: self autoGenCategoryName)
		with: (MethodCategory name: 'scintilla interface')!

buildParamName: wParamName type: wParamType 
	^(String with: wParamName first asLowercase) , (wParamName copyFrom: 2) 
		, wParamType first!

compile: aString selector: selector in: targetClass categories: autogenCats 
	| source  |
	source := (SmalltalkParser parseMethod: aString) formattedCode.
	isTestRun 
		ifTrue: 
			[(ChunkSourceFiler on: Transcript)
				emitHeaderForMethodsOf: targetClass;
				nextChunkPut: source;
				endChunk;
				emitCategories: autogenCats
					for: selector
					in: targetClass.
			Transcript cr]
		ifFalse: 
			[targetClass compile: source
				categories: (autogenCats union: (classification at: selector ifAbsent: [#()]))]!

compileMethod: selector source: aString 
	self 
		compileMethod: selector
		source: aString
		categories: self autoGenMethodCategories!

compileMethod: selector source: aString categories: aCollection 
	self 
		compile: aString
		selector: selector
		in: self scintillaViewClass
		categories: aCollection!

constantsPool
	^Smalltalk at: #ScintillaConstants ifAbsentPut: [PoolConstantsDictionary new]!

defineAdditionalConstants
	(self constantsPool)
		at: 'STYLE_NORMAL' put: 0!

emitComment: aLookupTable on: aPuttableStream private: aBoolean 
	| target text comment |
	comment := aLookupTable at: #comment.
	comment isEmpty ifTrue: [^self].
	target := String writeStream.
	target nextPut: $".
	aBoolean ifTrue: [target nextPutAll: 'Private - '].
	self emitCommentString: comment on: target.
	false 
		ifTrue: 
			[target crtab.
			self emitCommentString: (aLookupTable at: #originalLine) on: target].
	target nextPut: $".
	text := target contents.
	aPuttableStream
		nextPutAll: (Smalltalk developmentSystem 
					wrapText: text
					indent: Smalltalk developmentSystem workspaceClass defaultTabWidth + 1
					tabWidth: Smalltalk developmentSystem workspaceClass defaultTabWidth);
		cr;
		crtab!

emitCommentString: aString on: stream 
	aString do: [:each | each == $" ifTrue: [stream nextPut: $'] ifFalse: [stream nextPut: each]]!

emitMethodPreamble: aLookupTable on: stream private: private 
	self 
		emitComment: aLookupTable
		on: stream
		private: private.
	parsingDeprecated 
		ifTrue: 
			[stream
				print: #deprecated;
				nextPut: $.;
				crtab]!

generateCommandMap
	| stream |
	stream := String writeStream.
	stream
		display: #initializeCommands;
		crtab;
		nextPutAll: 'Commands := (IdentityDictionary new)';
		crtab.
	commands at: 'SCI_NULL' put: #yourself.
	(Commands copyWith: 'SCI_NULL') do: 
			[:each | 
			stream
				nextPutAll: 'at: ';
				display: each;
				nextPutAll: ' put: ';
				print: (commands at: each);
				nextPut: $;;
				crtab].
	stream
		display: #shrink;
		nextPut: $;;
		crtab;
		display: #isImmutable:;
		space;
		display: true;
		nextPut: $;;
		crtab;
		nextPutAll: 'yourself'.
	self 
		compile: (SmalltalkParser parseMethod: stream contents) formattedCode
		selector: #initializeCommandMap
		in: ScintillaKeyBinding class
		categories: self autoGenMethodCategories, (Array with: MethodCategory private with: (MethodCategory name: 'development'))!

generateEventHandler: aLookupTable 
	| stream selector args |
	(aLookupTable at: #deprecated) 
		ifTrue: 
			[Transcript
				display: 'Default handler for ';
				print: (aLookupTable at: #constName);
				display: ' as deprecated';
				cr.
			^self].
	selector := aLookupTable at: #selector.
	(self scintillaViewClass includesSelector: selector) 
		ifTrue: 
			[Transcript
				display: 'Default handler for ';
				print: selector;
				display: ' not generated due to selector clash';
				cr.
			^self].
	stream := String writeStream.
	stream
		nextPutAll: selector;
		nextPutAll: ' pSCNotification';
		crtab;
		nextPutAll: '"Private - Default handler for an ';
		display: (aLookupTable at: #constName);
		display: ' event.';
		crtab.
	args := aLookupTable at: #args.
	args isEmpty 
		ifTrue: [stream nextPutAll: 'No fields of the notification structure are set.']
		ifFalse: 
			[stream nextPutAll: 'The following fields of the notification structure are set:'.
			args do: 
					[:each | 
					stream
						crtab: 2;
						nextPutAll: each key]].
	stream
		nextPut: $";
		cr;
		crtab;
		nextPutAll: '^nil'.
	self 
		compileMethod: selector
		source: stream contents
		categories: self autoGenEventCategories!

generateNotificationMap
	| stream scnFirst |
	stream := String writeStream.
	stream
		display: #initializeNotificationMap;
		crtab;
		nextPutAll: 'ScnMap := (Array new: ';
		print: (events last at: #eventId) + 1 - self scnFirst;
		nextPut: $);
		crtab: 2.
	scnFirst := self scnFirst.
	events do: 
			[:each | 
			| constName |
			constName := each at: #constName.
			stream
				nextPutAll: 'at: (';
				nextPutAll: constName;
				nextPutAll: ' - ';
				print: scnFirst - 1;
				nextPutAll: ') put: ';
				print: ((each at: #deprecated) ifFalse: [each at: #selector]);
				nextPut: $;;
				crtab: 2].
	stream
		display: #isImmutable:;
		space;
		display: true;
		nextPut: $;;
		crtab: 2;
		nextPutAll: 'yourself'.
	self 
		compile: (SmalltalkParser parseMethod: stream contents) formattedCode
		selector: #initializeNotificationMap
		in: self scintillaViewClass class
		categories: (self autoGenMethodCategories copyWith: (MethodCategory name: 'must not strip'))!

generateNullLParamFunction: aLookupTable message: aString 
	| stream lParamType lParamName name returnType selector private |
	stream := String writeStream: 128.
	lParamType := TypeMap at: (aLookupTable at: #lParamType).
	lParamName := self buildParamName: (aLookupTable at: #lParamName) type: lParamType.
	name := aLookupTable at: #name.
	private := false.
	selector := RenamedMessages at: aString
				ifAbsent: 
					[private := true.
					('sci' , name capitalized , ':') asSymbol].
	stream
		nextPutAll: selector;
		space;
		nextPutAll: lParamName;
		crtab.
	self 
		emitMethodPreamble: aLookupTable
		on: stream
		private: private.
	returnType := TypeMap at: (aLookupTable at: #returnType).
	self printRetConversion: returnType on: stream.
	stream
		nextPutAll: 'self sendMessage: ';
		nextPutAll: aString;
		nextPutAll: ' wParam: ';
		print: 0.
	stream
		nextPutAll: ((lParamType at: 2) ifTrue: [' lpParam: '] ifFalse: [' lParam: ']);
		nextPutAll: lParamName.
	stream display: (lParamType at: 3).
	self printRetConversionTrailer: returnType on: stream.
	self compileMethod: selector source: stream contents!

generateNullNullFunction: aLookupTable message: aString 
	| stream name retType selector private |
	stream := String writeStream: 128.
	name := aLookupTable at: #name.
	private := false.
	selector := RenamedMessages at: aString
				ifAbsent: 
					[private := true.
					('sci' , name capitalized) asSymbol].
	((aLookupTable at: #messageType) = 'fun' and: [(aLookupTable at: #returnType) = 'void']) 
		ifTrue: [commands at: aString put: selector].
	stream
		nextPutAll: selector;
		crtab.
	self 
		emitMethodPreamble: aLookupTable
		on: stream
		private: private.
	retType := TypeMap at: (aLookupTable at: #returnType).
	self printRetConversion: retType on: stream.
	stream
		nextPutAll: 'self sendMessage: ';
		nextPutAll: aString;
		nextPutAll: ' wParam: 0 lParam: 0'.
	self printRetConversionTrailer: retType on: stream.
	self compileMethod: selector source: stream contents!

generateWParamLParamFunction: aLookupTable message: aString 
	| stream lParamName wParamType wParamName name lParamType retType selector keyword2 keyword1 private |
	stream := String writeStream: 128.
	wParamName := aLookupTable at: #wParamName.
	wParamType := TypeMap at: (aLookupTable at: #wParamType).
	wParamName := self buildParamName: wParamName type: wParamType.
	name := aLookupTable at: #name.
	lParamType := TypeMap at: (aLookupTable at: #lParamType).
	lParamName := self buildParamName: (aLookupTable at: #lParamName) type: lParamType.
	selector := RenamedMessages at: aString ifAbsent: [].
	selector isNil 
		ifTrue: 
			[keyword2 := (aLookupTable at: #lParamName) copyWith: $:.
			keyword1 := 'sci' , (name capitalized copyWith: $:).
			selector := (keyword1 , keyword2) asSymbol.
			private := true]
		ifFalse: 
			[| keywords |
			keywords := selector subStrings: $:.
			keyword1 := keywords first copyWith: $:.
			keyword2 := keywords second copyWith: $:.
			private := false].
	stream
		nextPutAll: keyword1;
		space;
		nextPutAll: wParamName;
		space;
		nextPutAll: keyword2;
		space;
		nextPutAll: lParamName;
		crtab.
	self 
		emitMethodPreamble: aLookupTable
		on: stream
		private: private.
	retType := TypeMap at: (aLookupTable at: #returnType).
	self printRetConversion: retType on: stream.
	stream
		nextPutAll: 'self sendMessage: ';
		nextPutAll: aString;
		nextPutAll: ' wParam: ';
		nextPutAll: wParamName.
	(wParamType at: 2) 
		ifTrue: 
			[stream
				space;
				display: #yourAddress].
	stream display: (wParamType at: 3).
	stream
		nextPutAll: ' lParam: ';
		nextPutAll: lParamName.
	(lParamType at: 2) 
		ifTrue: 
			[stream
				space;
				display: #yourAddress].
	stream display: (lParamType at: 3).
	self printRetConversionTrailer: retType on: stream.
	self compileMethod: selector source: stream contents!

generateWParamNullFunction: aLookupTable message: aString 
	| stream wParamType wParamName name retType selector private |
	stream := String writeStream: 128.
	wParamName := aLookupTable at: #wParamName.
	wParamType := TypeMap at: (aLookupTable at: #wParamType).
	wParamName := self buildParamName: wParamName type: wParamType.
	name := aLookupTable at: #name.
	private := false.
	selector := RenamedMessages at: aString
				ifAbsent: 
					[private := true.
					('sci' , name capitalized , ':') asSymbol].
	stream
		nextPutAll: selector;
		space;
		nextPutAll: wParamName;
		crtab.
	self 
		emitMethodPreamble: aLookupTable
		on: stream
		private: private.
	retType := TypeMap at: (aLookupTable at: #returnType).
	self printRetConversion: retType on: stream.
	stream
		nextPutAll: 'self sendMessage: ';
		nextPutAll: aString;
		nextPutAll: ' wParam: ';
		nextPutAll: wParamName.
	(wParamType at: 2) 
		ifTrue: 
			[stream
				space;
				display: #yourAddress].
	stream display: (wParamType at: 3).
	stream nextPutAll: ' lParam: 0'.
	self printRetConversionTrailer: retType on: stream.
	self compileMethod: selector source: stream contents!

getAndResetCommentQueue
	| answer |
	answer := commentQueue contents.
	commentQueue := WriteStream on: (String new: 160).
	^answer!

initialize
	events := OrderedCollection new: 256.
	commentQueue := WriteStream on: (String new: 160).
	lexerConstantPrefix := ' '.
	isTestRun isNil ifTrue: [isTestRun := false].
	commands := LookupTable new.
	"Special case"
	commands at: 'SCI_SETZOOM' put: #resetZoom.
	parsingDeprecated := false!

isTestRun: anObject
	isTestRun := anObject!

parseCategory: aLine
	category  := aLine readStream 
		skipWhile: [:each | each isSeparator not];
		skipSeparators;
		upToEnd.
	parsingDeprecated := category asLowercase = 'deprecated'!

parseDeprecated: aString 
	Transcript
		display: 'Ignoring deprecated definition: ';
		display: aString;
		cr!

parseEmptyLine: aString 
	!

parseEnum: aString 
	Transcript display: 'Enumeration definition ignored: '; nextPutAll: aString; cr!

parseEvent: aLine 
	[self primParseEvent: aLine] on: HRESULTError
		do: [:err | self reportError: err parsing: aLine]!

parseEventArgs: argArray 
	| readStr writeStr token |
	readStr := ReadStream on: argArray.
	writeStr := WriteStream on: Array new.
	token := readStr next.	"("
	(token includes: $() ifFalse: [^writeStr contents].
	token := readStr next.
	[readStr atEnd or: [token includes: $)]] whileFalse: 
			[token = 'void' 
				ifFalse: 
					[| type ident argh |
					type := token.
					token := readStr next.	"skip white space"
					ident := readStr next.
					argh := ident -> type.
					writeStr nextPut: argh.
					token := readStr next].
			readStr atEnd ifFalse: [token := readStr next]].
	^writeStr contents!

parseFile
	| filename |
	filename := (FileOpenDialog on: 'scintilla.iface')
			fileTypes: #(#('Scintilla Interface Files (*.iface)' '*.iface') #('All Files (*.*)' '*.*'));
			defaultExtension: 'iface';
			showModal.
	self parseFile: filename
"
self new parseFile
"!

parseFile: aFileName 
	| cFile |
	self initialize.
	self removeAutoGeneratedMethods.
	self constantsPool removeAllKeys: self constantsPool keys.
	self defineAdditionalConstants.
	cFile := FileStream read: aFileName.
	[cFile atEnd] whileFalse: [self parseLine: cFile nextLine].
	cFile close.
	self generateNotificationMap.
	self generateCommandMap.
	self scintillaViewClass initializeNotificationMap.
	ScintillaKeyBinding initializeCommands!

parseFileComment: aLine
!

parseInterfaceComment: aString 
	commentQueue isEmpty ifFalse: [commentQueue space].
	commentQueue nextPutAll: (aString copyFrom: 2) trimBlanks!

parseLex: aString 
	lexerConstantPrefix := aString subStrings last!

parseLine: aString 
	aString = '' ifTrue: [^self parseEmptyLine: aString].
	(aString beginsWith: 'cat') ifTrue: [^self parseCategory: aString].
	(aString beginsWith: 'fun') ifTrue: [^self parseMessage: aString].
	(aString beginsWith: 'get') ifTrue: [^self parseMessage: aString].
	(aString beginsWith: 'set') ifTrue: [^self parseMessage: aString].
	(aString beginsWith: 'val') ifTrue: [^self parseValue: aString].
	(aString beginsWith: 'evt') ifTrue: [^self parseEvent: aString].
	(aString beginsWith: '##') ifTrue: [^self parseFileComment: aString].
	(aString beginsWith: '#!!') ifTrue: [^self parseShBang: aString].
	(aString beginsWith: '#') ifTrue: [^self parseInterfaceComment: aString].
	(aString beginsWith: 'enu') ifTrue: [^self parseEnum: aString].
	(aString beginsWith: 'lex') ifTrue: [^self parseLex: aString].

	"Catch all"
	Transcript
		show: 'Unknown line: ';
		show: aString;
		cr!

parseMessage: aLine 
	^[self primParseMessage: aLine] on: Error do: [:err | self reportError: err parsing: aLine]!

parseShBang: aLine
!

parseValue: aString 
	| subStrings value numberStream radix constName |
	self getAndResetCommentQueue.
	subStrings := self splitDefinition: aString.
	constName := subStrings at: 3.
	"We don't want to bloat the constants pool with a load of lexer defines that we don't need in Dolphin"
	(constName beginsWith: lexerConstantPrefix) 
		ifTrue: 
			[self constantsPool removeKey: constName ifAbsent: [].
			^self].
	value := subStrings at: 5.
	numberStream := value readStream.
	radix := (value beginsWith: '0x') 
				ifTrue: 
					[numberStream skip: 2.
					16]
				ifFalse: [10].
	value := Integer readFrom: numberStream radix: radix.
	numberStream atEnd ifFalse: [^self].
	self constantsPool at: constName put: value!

primParseEvent: aString 
	| subStrings args strings eventId name constName selector |
	subStrings := self splitDefinition: aString.
	strings := LookupTable new.
	name := subStrings at: 5.
	eventId := (subStrings at: 7) asNumber.
	constName := 'SCN_' , name asUppercase.
	self constantsPool at: constName put: eventId.
	selector := ('scn' , name capitalized , ':') asSymbol.
	args := self parseEventArgs: (subStrings copyFrom: 8).
	strings
		at: #constName put: constName;
		at: #selector put: selector;
		at: #returnType put: (subStrings at: 3);
		at: #name put: name;
		at: #eventId put: eventId;
		at: #originalLine put: aString;
		at: #comment put: self getAndResetCommentQueue;
		at: #args put: args;
		at: #deprecated put: parsingDeprecated;
		yourself.
	self generateEventHandler: strings.
	events add: strings!

primParseMessage: aString 
	| subStrings trouble strings name messageId messageName |
	subStrings := self splitDefinition: aString.
	strings := LookupTable new.
	name := subStrings at: 5.
	messageId := (subStrings at: 7) asNumber.
	strings
		at: #messageType put: (subStrings at: 1);
		at: #returnType put: (subStrings at: 3);
		at: #name put: name;
		at: #messageId put: messageId;
		at: #originalLine put: aString;
		at: #comment put: self getAndResetCommentQueue.
	messageName := 'SCI_' , name asUppercase.
	self constantsPool at: messageName put: messageId.
	(IgnoredMessages includes: messageName) 
		ifTrue: 
			[Notification signal: 'Ignoring message ' , messageName.
			^self].
	trouble := subStrings at: 8.
	(trouble beginsWith: '(,)') ifTrue: [^self generateNullNullFunction: strings message: messageName].
	(trouble beginsWith: '(,') 
		ifTrue: 
			[strings
				at: #lParamType put: (subStrings at: 9);
				at: #lParamName put: (subStrings at: 11).
			^self generateNullLParamFunction: strings message: messageName].
	^(trouble beginsWith: '(') 
		ifTrue: 
			[| trouble2 |
			strings
				at: #wParamType put: (subStrings at: 9);
				at: #wParamName put: (subStrings at: 11).
			trouble2 := subStrings at: 12.
			(trouble2 beginsWith: ',)') 
				ifTrue: [^self generateWParamNullFunction: strings message: messageName].
			strings
				at: #lParamType put: (subStrings at: 13);
				at: #lParamName put: (subStrings at: 15).
			^self generateWParamLParamFunction: strings message: messageName]!

printRetConversion: anArray on: aWriteStream 
	| retConversion |
	anArray first notNil ifTrue: [aWriteStream nextPut: $^].
	retConversion := anArray at: 4.
	retConversion notNil 
		ifTrue: 
			[retConversion last == $: 
				ifTrue: 
					[aWriteStream
						nextPutAll: anArray first;
						space;
						nextPutAll: retConversion;
						nextPutAll: ' (']
				ifFalse: [aWriteStream nextPut: $(]]!

printRetConversionTrailer: anArray on: aWriteStream 
	| retConversion |
	retConversion := anArray at: 4.
	retConversion notNil 
		ifTrue: 
			[aWriteStream nextPut: $).
			retConversion last == $: 
				ifFalse: 
					[aWriteStream
						space;
						nextPutAll: retConversion]]!

removeAutoGeneratedMethods
	| aClassDescription autogen methods selectors |
	aClassDescription := self scintillaViewClass.
	autogen := aClassDescription methodCategoryClass name: self autoGenCategoryName.
	methods := autogen methodsInBehavior: aClassDescription.
	classification := LookupTable new.
	methods do: 
			[:each | 
			classification at: each selector
				put: (each categories reject: [:cat | cat isPrivacy or: [cat == autogen]])].
	selectors := methods collect: [:method | method selector].
	isTestRun 
		ifTrue: 
			[Transcript
				print: aClassDescription;
				space;
				display: #removeSelectors:;
				space;
				nextPutAll: '#('.
			selectors do: [:each | Transcript print: each] separatedBy: [Transcript space].
			Transcript cr]
		ifFalse: [aClassDescription removeSelectors: selectors]!

replaceHexStart: aString
	aString size < 2
		ifTrue: [ ^aString ].

	(aString copyFrom:1 to: 2) = '0x'
		ifFalse: [ ^aString ].

	^ '16r', (aString copyFrom: 3)

!

reportError: err parsing: aLine 
	^Transcript
		nextPutAll: 'Error parsing: ';
		print: aLine;
		crtab;
		display: err description;
		cr!

scintillaViewClass
	^ScintillaView!

scnFirst
	^2000!

smalltalkTypeFor: aString 
	^TypeMap at: aString!

splitDefinition: aString 
	| aStream answer lastChar wordStream nextChar separators |
	separators := Set withAll: ' =(),'.
	answer := OrderedCollection new.
	aStream := aString readStream.
	wordStream := aString species writeStream: 10.
	nextChar := $(.
	lastChar := Character null.
	[aStream atEnd] whileFalse: 
			[| next |
			wordStream reset.
			(separators includes: nextChar) ifFalse: [wordStream nextPut: nextChar].
			[aStream atEnd or: [separators includes: (nextChar := aStream next)]] 
				whileFalse: [wordStream nextPut: nextChar].
			next := wordStream contents.
			next notEmpty ifTrue: [answer add: next].
			lastChar := $(.
			wordStream reset.
			(separators includes: nextChar) ifTrue: [wordStream nextPut: nextChar].
			[aStream atEnd or: [(separators includes: (lastChar := nextChar := aStream next)) not]] 
				whileFalse: [wordStream nextPut: nextChar].
			next := wordStream contents.
			next notEmpty ifTrue: [answer add: next]].
	(separators includes: lastChar) ifFalse: [answer add: lastChar asString].
	^answer asArray! !
!ScintillaIfaceParser categoriesFor: #autoGenCategoryName!constants!private! !
!ScintillaIfaceParser categoriesFor: #autoGenEventCategories!constants!private! !
!ScintillaIfaceParser categoriesFor: #autoGenMethodCategories!constants!private! !
!ScintillaIfaceParser categoriesFor: #buildParamName:type:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #compile:selector:in:categories:!public! !
!ScintillaIfaceParser categoriesFor: #compileMethod:source:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #compileMethod:source:categories:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #constantsPool!helpers!private! !
!ScintillaIfaceParser categoriesFor: #defineAdditionalConstants!helpers!public! !
!ScintillaIfaceParser categoriesFor: #emitComment:on:private:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #emitCommentString:on:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #emitMethodPreamble:on:private:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #generateCommandMap!generating!private! !
!ScintillaIfaceParser categoriesFor: #generateEventHandler:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #generateNotificationMap!generating!private! !
!ScintillaIfaceParser categoriesFor: #generateNullLParamFunction:message:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #generateNullNullFunction:message:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #generateWParamLParamFunction:message:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #generateWParamNullFunction:message:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #getAndResetCommentQueue!helpers!private! !
!ScintillaIfaceParser categoriesFor: #initialize!helpers!public! !
!ScintillaIfaceParser categoriesFor: #isTestRun:!public! !
!ScintillaIfaceParser categoriesFor: #parseCategory:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseDeprecated:!public! !
!ScintillaIfaceParser categoriesFor: #parseEmptyLine:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseEnum:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseEvent:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseEventArgs:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseFile!helpers!public! !
!ScintillaIfaceParser categoriesFor: #parseFile:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseFileComment:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseInterfaceComment:!helpers!public! !
!ScintillaIfaceParser categoriesFor: #parseLex:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseLine:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseMessage:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseShBang:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #parseValue:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #primParseEvent:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #primParseMessage:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #printRetConversion:on:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #printRetConversionTrailer:on:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #removeAutoGeneratedMethods!helpers!private! !
!ScintillaIfaceParser categoriesFor: #replaceHexStart:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #reportError:parsing:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #scintillaViewClass!helpers!private! !
!ScintillaIfaceParser categoriesFor: #scnFirst!generating!private! !
!ScintillaIfaceParser categoriesFor: #smalltalkTypeFor:!helpers!private! !
!ScintillaIfaceParser categoriesFor: #splitDefinition:!copying!public! !

!ScintillaIfaceParser class methodsFor!

icon
	^ScintillaView icon!

initialize
	"
	self initialize
	"

	self initializeTypeMap.
	self initializeIgnoredMessages.
	self initializeCommands.
	self initializeRenamedMessages
	"at: 'SCI_SETMODIFY' put: #isTextModified:;"!

initializeCommands
	"
	self initializeCommands
	"

	Commands := #('SCI_BACKTAB' 'SCI_CANCEL' 'SCI_CHARLEFT' 'SCI_CHARLEFTEXTEND' 'SCI_CHARLEFTRECTEXTEND' 'SCI_CHARRIGHT' 'SCI_CHARRIGHTEXTEND' 'SCI_CHARRIGHTRECTEXTEND' 'SCI_CLEAR' 'SCI_CLEARALL' 'SCI_COPY' 'SCI_CUT' 'SCI_DELETEBACK' 'SCI_DELETEBACKNOTLINE' 'SCI_DELLINELEFT' 'SCI_DELLINERIGHT' 'SCI_DELWORDLEFT' 'SCI_DELWORDRIGHT' 'SCI_DOCUMENTEND' 'SCI_DOCUMENTENDEXTEND' 'SCI_DOCUMENTSTART' 'SCI_DOCUMENTSTARTEXTEND' 'SCI_EDITTOGGLEOVERTYPE' 'SCI_FORMFEED' 'SCI_HOME' 'SCI_HOMEDISPLAY' 'SCI_HOMEDISPLAYEXTEND' 'SCI_HOMEEXTEND' 'SCI_HOMERECTEXTEND' 'SCI_HOMEWRAP' 'SCI_HOMEWRAPEXTEND' 'SCI_LINECOPY' 'SCI_LINECUT' 'SCI_LINEDELETE' 'SCI_LINEDOWN' 'SCI_LINEDOWNEXTEND' 'SCI_LINEDOWNRECTEXTEND' 'SCI_LINEDUPLICATE' 'SCI_LINEEND' 'SCI_LINEENDDISPLAY' 'SCI_LINEENDDISPLAYEXTEND' 'SCI_LINEENDEXTEND' 'SCI_LINEENDRECTEXTEND' 'SCI_LINEENDWRAP' 'SCI_LINEENDWRAPEXTEND' 'SCI_LINESCROLLDOWN' 'SCI_LINESCROLLUP' 'SCI_LINESJOIN' 'SCI_LINETRANSPOSE' 'SCI_LINEUP' 'SCI_LINEUPEXTEND' 'SCI_LINEUPRECTEXTEND' 'SCI_LOWERCASE' 'SCI_MOVECARETINSIDEVIEW' 'SCI_NEWLINE' 'SCI_PAGEDOWN' 'SCI_PAGEDOWNEXTEND' 'SCI_PAGEDOWNRECTEXTEND' 'SCI_PAGEUP' 'SCI_PAGEUPEXTEND' 'SCI_PAGEUPRECTEXTEND' 'SCI_PARADOWN' 'SCI_PARADOWNEXTEND' 'SCI_PARAUP' 'SCI_PARAUPEXTEND' 'SCI_PASTE' 'SCI_REDO' 'SCI_SEARCHANCHOR' 'SCI_SELECTALL' 'SCI_SETSAVEPOINT' 'SCI_STARTRECORD' 'SCI_STOPRECORD' 'SCI_STUTTEREDPAGEDOWN' 'SCI_STUTTEREDPAGEDOWNEXTEND' 'SCI_STUTTEREDPAGEUP' 'SCI_STUTTEREDPAGEUPEXTEND' 'SCI_TAB' 'SCI_TARGETFROMSELECTION' 'SCI_TOGGLECARETSTICKY' 'SCI_UNDO' 'SCI_UPPERCASE' 'SCI_VCHOME' 'SCI_VCHOMEEXTEND' 'SCI_VCHOMERECTEXTEND' 'SCI_VCHOMEWRAP' 'SCI_VCHOMEWRAPEXTEND' 'SCI_WORDLEFT' 'SCI_WORDLEFTEND' 'SCI_WORDLEFTENDEXTEND' 'SCI_WORDLEFTEXTEND' 'SCI_WORDPARTLEFT' 'SCI_WORDPARTLEFTEXTEND' 'SCI_WORDPARTRIGHT' 'SCI_WORDPARTRIGHTEXTEND' 'SCI_WORDRIGHT' 'SCI_WORDRIGHTEND' 'SCI_WORDRIGHTENDEXTEND' 'SCI_WORDRIGHTEXTEND' 'SCI_ZOOMIN' 'SCI_ZOOMOUT' 'SCI_SETZOOM')!

initializeIgnoredMessages
	"Private - Ignored messages won't have a wrapper function generated - this is normally because they
	are trivial messages invoked directly by the high-level wrapper method, or because they are
	for getting/setting the value of an attribute.
		self initializeIgnoredMessages
	"

	IgnoredMessages := #('SCI_GETDIRECTFUNCTION' 'SCI_NULL' 'SCI_GETDIRECTPOINTER' 'SCI_GETLENGTH' 'SCI_GETVIEWWS' 'SCI_SETVIEWWS' 'SCI_COPYTEXT' 'SCI_GETFOCUS' 'SCI_GETMARGINMASKN' 'SCI_SETMARGINMASKN' 'SCI_GETMARGINTYPEN' 'SCI_SETMARGINTYPEN' 'SCI_GETMARGINWIDTHN' 'SCI_SETMARGINWIDTHN' 'SCI_GETMARGINSENSITIVEN' 'SCI_SETMARGINSENSITIVEN' 'SCI_GETREADONLY' 'SCI_GRABFOCUS' 'SCI_INDICGETFORE' 'SCI_INDICSETFORE' 'SCI_INDICGETSTYLE' 'SCI_INDICSETSTYLE' 'SCI_INDICGETUNDER' 'SCI_INDICSETUNDER' 'SCI_INDICGETALPHA' 'SCI_INDICSETALPHA' 'SCI_MARKERSETBACK' 'SCI_MARKERSETFORE' 'SCI_MARKERADD' 'SCI_MARKERDEFINE' 'SCI_MARKERDELETE' 'SCI_SETFOCUS' 'SCI_STYLESETFORE' 'SCI_STYLESETBACK' 'SCI_STYLESETFONT' 'SCI_STYLESETBOLD' 'SCI_STYLESETITALIC' 'SCI_STYLESETUNDERLINE' 'SCI_STYLESETCASE' 'SCI_STYLESETCHARACTERSET' 'SCI_STYLESETSIZE' 'SCI_STYLESETEOLFILLED' 'SCI_STYLESETCHANGEABLE' 'SCI_STYLESETHOTSPOT' 'SCI_STYLESETVISIBLE' 'SCI_STYLERESETDEFAULT' 'SCI_SETSELECTIONEND' 'SCI_SETSELECTIONSTART' 'SCI_USEPOPUP' 'SCI_SETCURRENTPOS' 'SCI_LINELENGTH' 'SCI_SCROLLCARET' 'SCI_GETSTYLEAT' 'SCI_GETCHARAT' 'SCI_ANNOTATIONGETSTYLE' 'SCI_ANNOTATIONSETSTYLE') 
				asSet.

	"Our Scintilla wrapping predates when style definitions were queryable, so we don't need it"
	IgnoredMessages 
		addAll: #('SCI_STYLEGETFORE' 'SCI_STYLEGETBACK' 'SCI_STYLEGETBOLD' 'SCI_STYLEGETITALIC' 'SCI_STYLEGETSIZE' 'SCI_STYLEGETFONT' 'SCI_STYLEGETEOLFILLED' 'SCI_STYLEGETUNDERLINE' 'SCI_STYLEGETCASE' 'SCI_STYLEGETCHARACTERSET' 'SCI_STYLEGETVISIBLE' 'SCI_STYLEGETCHANGEABLE' 'SCI_STYLEGETHOTSPOT').

	"SCI_GETLENGTH is ignored because it duplicates SCI_GETTEXTLENGTH"
	IgnoredMessages add: 'SCI_GETLENGTH'.

	"Don't make use of document ref. stuff at present."
	"IgnoredMessages add: 'SCI_ADDREFDOCUMENT'."

	"Scintilla's cursor management is not required in Dolphin which has its own mechanisms."
	IgnoredMessages addAll: #('SCI_GETCURSOR' 'SCI_SETCURSOR').

	"We don't need SCI_GETMODEVENTMASK because we store the event mask in an instance variable (for some reason that I no longer know)"
	IgnoredMessages add: 'SCI_GETMODEVENTMASK'.

	"We don't need these as they are for the GTK+ platform only"
	IgnoredMessages 
		addAll: #('SCI_GETRECTANGULARSELECTIONMODIFIER' 'SCI_SETRECTANGULARSELECTIONMODIFIER')!

initializeRenamedMessages
	"
	self initializeRenamedMessages 
	"

	"Selection movement"

	"		at: 'SCI_LINEENDRECTEXTEND' put: #extendRectangleToEndOfLine;"

	RenamedMessages := LookupTable new.
	"Indicators"
	RenamedMessages
		at: 'SCI_GETINDICATORCURRENT' put: #currentIndicatorId;
		at: 'SCI_SETINDICATORCURRENT' put: #currentIndicatorId:;
		at: 'SCI_GETINDICATORVALUE' put: #currentIndicatorValue;
		at: 'SCI_SETINDICATORVALUE' put: #currentIndicatorValue:;
		yourself.

	"Zoom"
	RenamedMessages
		at: 'SCI_ZOOMIN' put: #zoomIn;
		at: 'SCI_ZOOMOUT' put: #zoomOut;
		at: 'SCI_GETZOOM' put: #zoomLevel;
		at: 'SCI_SETZOOM' put: #zoomLevel:;
		yourself.
	"Undo/redo"
	RenamedMessages
		at: 'SCI_BEGINUNDOACTION' put: #beginUndoGroup;
		at: 'SCI_ENDUNDOACTION' put: #endUndoGroup;
		at: 'SCI_EMPTYUNDOBUFFER' put: #emptyUndoBuffer;
		at: 'SCI_CANREDO' put: #canRedo;
		at: 'SCI_CANUNDO' put: #canUndo;
		at: 'SCI_REDO' put: #redo;
		at: 'SCI_GETUNDOCOLLECTION' put: #isUndoEnabled;
		at: 'SCI_SETUNDOCOLLECTION' put: #isUndoEnabled:;
		at: 'SCI_UNDO' put: #basicUndo;
		yourself.
	"Tabs & indents"
	RenamedMessages
		at: 'SCI_GETHIGHLIGHTGUIDE' put: #highlightGuide;
		at: 'SCI_SETHIGHLIGHTGUIDE' put: #highlightGuide:;
		at: 'SCI_GETINDENT' put: #indentation;
		at: 'SCI_SETINDENT' put: #indentation:;
		at: 'SCI_GETTABWIDTH' put: #tabWidth;
		at: 'SCI_SETTABWIDTH' put: #tabWidth:;
		at: 'SCI_GETUSETABS' put: #isUsingTabs;
		at: 'SCI_SETUSETABS' put: #isUsingTabs:;
		at: 'SCI_GETBACKSPACEUNINDENTS' put: #backspaceUnindents;
		at: 'SCI_SETBACKSPACEUNINDENTS' put: #backspaceUnindents:;
		at: 'SCI_GETTABINDENTS' put: #tabIndents;
		at: 'SCI_SETTABINDENTS' put: #tabIndents:;
		yourself.
	""
	RenamedMessages
		at: 'SCI_GETXOFFSET' put: #xOffset;
		at: 'SCI_SETXOFFSET' put: #xOffset:;
		at: 'SCI_BACKTAB' put: #unindent;
		at: 'SCI_LINEFROMPOSITION' put: #basicLineFromPosition:;
		at: 'SCI_POSITIONFROMLINE' put: #basicPositionAtLine:;
		at: 'SCI_GETVIEWEOL' put: #hasVisibleLineEndings;
		at: 'SCI_SETVIEWEOL' put: #hasVisibleLineEndings:;
		at: 'SCI_CLEAR' put: #basicClearSelection;
		at: 'SCI_GETHSCROLLBAR' put: #canHScroll;
		at: 'SCI_GETVSCROLLBAR' put: #canVScroll;
		at: 'SCI_SETENDATLASTLINE' put: #canScrollPastEnd:;
		yourself.
	"Caret"
	RenamedMessages
		at: 'SCI_GETCARETFORE' put: #caretForecolor;
		at: 'SCI_GETCARETPERIOD' put: #caretPeriod;
		at: 'SCI_SETCARETPERIOD' put: #caretPeriod:;
		at: 'SCI_GETCARETWIDTH' put: #caretWidth;
		at: 'SCI_GETCARETLINEBACK' put: #currentLineBackcolor;
		at: 'SCI_GETCARETLINEBACKALPHA' put: #currentLineAlpha;
		at: 'SCI_SETCARETLINEBACKALPHA' put: #currentLineAlpha:;
		at: 'SCI_GETCARETLINEVISIBLE' put: #isCurrentLineHighlighted;
		at: 'SCI_SETCARETLINEVISIBLE' put: #isCurrentLineHighlighted:;
		at: 'SCI_MOVECARETINSIDEVIEW' put: #moveCaretInsideView;
		at: 'SCI_CHOOSECARETX' put: #rememberCaretX;
		at: 'SCI_GETCARETSTICKY' put: #isCaretSticky;
		at: 'SCI_SETCARETSTICKY' put: #isCaretSticky:;
		yourself.
	"		at: 'SCI_SETCARETFORE' put: #caretForecolor:;"
	"at: 'SCI_SETCARETLINEBACK' put: #currentLineBackcolor:;"
	"Markers"
	RenamedMessages
		at: 'SCI_MARKERDELETEALL' put: #deleteMarkers:;
		yourself.
	"Scrolling"
	RenamedMessages
		at: 'SCI_SETVSCROLLBAR' put: #showVerticalScrollBar:;
		at: 'SCI_GETSCROLLWIDTH' put: #scrollWidth;
		at: 'SCI_SETSCROLLWIDTH' put: #scrollWidth:;
		at: 'SCI_GETSCROLLWIDTHTRACKING' put: #isScrollWidthTracking;
		at: 'SCI_SETSCROLLWIDTHTRACKING' put: #isScrollWidthTracking:;
		yourself.
	"Line wrapping"
	RenamedMessages
		at: 'SCI_LINESSPLIT' put: #splitTarget:;
		at: 'SCI_LINESJOIN' put: #joinTarget;
		yourself.

	"Whitespace"
	RenamedMessages yourself.

	"Selection"
	RenamedMessages
		at: 'SCI_SELECTIONISRECTANGLE' put: #isSelectionRectangular;
		at: 'SCI_SETSEL' put: #basicSelectionStart:end:;
		at: 'SCI_HIDESELECTION' put: #hideSelection:;
		at: 'SCI_GETSELALPHA' put: #selectionAlpha;
		at: 'SCI_SETSELALPHA' put: #selectionAlpha:;
		at: 'SCI_GETSELEOLFILLED' put: #isSelectionBackcolorExtendedToEndOfLine;
		at: 'SCI_SETSELEOLFILLED' put: #isSelectionBackcolorExtendedToEndOfLine:;
		yourself.

	"Miscellaneous"
	RenamedMessages
		at: 'SCI_GETMOUSEDWELLTIME' put: #hoverTime;
		at: 'SCI_SETMOUSEDWELLTIME' put: #hoverTime:;
		at: 'SCI_GETBUFFEREDDRAW' put: #isDrawingBuffered;
		at: 'SCI_SETBUFFEREDDRAW' put: #isDrawingBuffered:;
		at: 'SCI_GETOVERTYPE' put: #isOvertypeEnabled;
		at: 'SCI_SETOVERTYPE' put: #isOvertypeEnabled:;
		at: 'SCI_GETMODIFY' put: #isTextModified;
		at: 'SCI_GETLINECOUNT' put: #lineCount;
		at: 'SCI_GETPRINTCOLOURMODE' put: #printColourMode;
		at: 'SCI_SETPRINTCOLOURMODE' put: #printColourMode:;
		at: 'SCI_GETPRINTMAGNIFICATION' put: #printMagnification;
		at: 'SCI_SETPRINTMAGNIFICATION' put: #printMagnification:;
		at: 'SCI_CLEARALL' put: #clearAll;
		at: 'SCI_EDITTOGGLEOVERTYPE' put: #toggleOvertype;
		at: 'SCI_GETEDGECOLOUR' put: #edgeColor;
		at: 'SCI_SETEDGECOLOUR' put: #edgeColor:;
		at: 'SCI_GETTEXTLENGTH' put: #textLength;
		at: 'SCI_GETTWOPHASEDRAW' put: #isDrawingTwoPhase;
		at: 'SCI_SETTWOPHASEDRAW' put: #isDrawingTwoPhase:;
		at: 'SCI_SETREADONLY' put: #setReadOnly:;
		at: 'SCI_TAB' put: #indent;
		at: 'SCI_TARGETFROMSELECTION' put: #setTargetRangeFromSelection;
		at: 'SCI_GETSTATUS' put: #errorStatus;
		at: 'SCI_SETSTATUS' put: #errorStatus:;
		at: 'SCI_LINESONSCREEN' put: #linesOnScreen;
		at: 'SCI_GETUSEPALETTE' put: #isUsingPalette;
		at: 'SCI_SETUSEPALETTE' put: #isUsingPalette:;
		at: 'SCI_GETMOUSEDOWNCAPTURES' put: #willCaptureMouse;
		at: 'SCI_SETMOUSEDOWNCAPTURES' put: #willCaptureMouse:;
		at: 'SCI_ADDTEXT' put: #insertText:from:;
		at: 'SCI_GETWRAPSTARTINDENT' put: #hangingIndent;
		at: 'SCI_SETWRAPSTARTINDENT' put: #hangingIndent:;
		at: 'SCI_CLEARDOCUMENTSTYLE' put: #removeAllStyling;
		at: 'SCI_SETSTYLING' put: #styleNext:mask:;
		at: 'SCI_GETPOSITIONCACHE' put: #positionCacheSize;
		at: 'SCI_SETPOSITIONCACHE' put: #positionCacheSize:;
		yourself.
	"Hotspot"
	RenamedMessages
		at: 'SCI_GETHOTSPOTACTIVEBACK' put: #activeHotspotBackcolor;
		at: 'SCI_GETHOTSPOTACTIVEFORE' put: #activeHotspotForecolor;
		at: 'SCI_GETHOTSPOTACTIVEUNDERLINE' put: #isActiveHotspotUnderlined;
		at: 'SCI_SETHOTSPOTACTIVEUNDERLINE' put: #isActiveHotspotUnderlined:;
		at: 'SCI_GETHOTSPOTSINGLELINE' put: #areHotspotsSingleLine;
		at: 'SCI_SETHOTSPOTSINGLELINE' put: #areHotspotsSingleLine:;
		yourself.
	"Autocompletion"
	RenamedMessages
		at: 'SCI_AUTOCCANCEL' put: #cancelAutoCompletion;
		at: 'SCI_AUTOCACTIVE' put: #isAutoCompletionActive;
		at: 'SCI_AUTOCCOMPLETE' put: #acceptAutoCompletion;
		at: 'SCI_AUTOCGETIGNORECASE' put: #isAutoCompletionCaseInsensitive;
		at: 'SCI_AUTOCSETIGNORECASE' put: #isAutoCompletionCaseInsensitive:;
		at: 'SCI_AUTOCGETAUTOHIDE' put: #isAutoCompletionCancelledWhenNoMatch;
		at: 'SCI_AUTOCSETAUTOHIDE' put: #isAutoCompletionCancelledWhenNoMatch:;
		at: 'SCI_AUTOCSELECT' put: #findAutoCompletionEntry:;
		at: 'SCI_AUTOCGETCANCELATSTART' put: #isAutoCompletionCancelledAtStart;
		at: 'SCI_AUTOCSETCANCELATSTART' put: #isAutoCompletionCancelledAtStart:;
		at: 'SCI_AUTOCGETDROPRESTOFWORD' put: #isAutoCompletionTruncating;
		at: 'SCI_AUTOCSETDROPRESTOFWORD' put: #isAutoCompletionTruncating:;
		at: 'SCI_AUTOCGETCHOOSESINGLE' put: #isAutoCompletionSingleMatchChosen;
		at: 'SCI_AUTOCSETCHOOSESINGLE' put: #isAutoCompletionSingleMatchChosen:;
		at: 'SCI_CLEARREGISTEREDIMAGES' put: #destroyAutoCompletionListImages;
		at: 'SCI_AUTOCGETMAXWIDTH' put: #maxCompletionListWidth;
		at: 'SCI_AUTOCSETMAXWIDTH' put: #maxCompletionListWidth:;
		at: 'SCI_AUTOCGETMAXHEIGHT' put: #maxCompletionListHeight;
		at: 'SCI_AUTOCSETMAXHEIGHT' put: #maxCompletionListHeight:;
		yourself.
	"Calltips"
	RenamedMessages
		at: 'SCI_CALLTIPACTIVE' put: #isCallTipActive;
		at: 'SCI_CALLTIPCANCEL' put: #cancelCallTip;
		at: 'SCI_CANCEL' put: #cancelModes;
		yourself.
	"at: 'SCI_CALLTIPPOSSTART' put: #callTipPosition;"
	"at: 'SCI_CALLTIPGETBACK' put: #callTipBackcolor;"

	"at: 'SCI_SETMODIFY' put: #isTextModified:;"

	"Macros"
	RenamedMessages
		at: 'SCI_STARTRECORD' put: #startRecording;
		at: 'SCI_STOPRECORD' put: #stopRecording;
		yourself.
	RenamedMessages
		at: 'SCI_CHARLEFT' put: #moveLeft;
		at: 'SCI_CHARRIGHT' put: #moveRight;
		at: 'SCI_WORDLEFT' put: #moveToStartOfWord;
		at: 'SCI_WORDLEFTEND' put: #moveToEndOfPreviousWord;
		at: 'SCI_WORDRIGHT' put: #moveToEndOfWord;
		at: 'SCI_WORDRIGHTEND' put: #moveToEndOfNextWord;
		at: 'SCI_WORDPARTLEFT' put: #moveToStartOfWordPart;
		at: 'SCI_WORDPARTRIGHT' put: #moveToEndOfWordPart;
		at: 'SCI_LINEUP' put: #moveUp;
		at: 'SCI_LINEDOWN' put: #moveDown;
		at: 'SCI_PARAUP' put: #moveParaUp;
		at: 'SCI_PARADOWN' put: #moveParaDown;
		at: 'SCI_PAGEUP' put: #movePageUp;
		at: 'SCI_PAGEUP' put: #movePageUp;
		at: 'SCI_STUTTEREDPAGEUP' put: #moveStutteredPageUp;
		at: 'SCI_PAGEDOWN' put: #movePageDown;
		at: 'SCI_STUTTEREDPAGEDOWN' put: #moveStutteredPageDown;
		at: 'SCI_DOCUMENTEND' put: #moveToEndOfDocument;
		at: 'SCI_DOCUMENTSTART' put: #moveToStartOfDocument;
		at: 'SCI_HOME' put: #moveToStartOfLine;
		at: 'SCI_HOMEWRAP' put: #moveToStartOfWrappedLine;
		at: 'SCI_HOMEDISPLAY' put: #moveToStartOfDisplayLine;
		at: 'SCI_VCHOME' put: #moveToVcHome;
		at: 'SCI_VCHOMEWRAP' put: #moveToWrappedVcHome;
		at: 'SCI_LINEEND' put: #moveToEndOfLine;
		at: 'SCI_LINEENDDISPLAY' put: #moveToEndOfDisplayLine;
		at: 'SCI_LINEENDWRAP' put: #moveToEndOfWrappedLine;
		at: 'SCI_LINESCROLLDOWN' put: #scrollDown;
		at: 'SCI_LINESCROLLUP' put: #scrollUp;
		yourself.	"Cursor movement"

	"Selection movement"
	RenamedMessages
		at: 'SCI_CHARLEFTEXTEND' put: #extendLeft;
		at: 'SCI_CHARRIGHTEXTEND' put: #extendRight;
		at: 'SCI_CHARLEFTRECTEXTEND' put: #extendRectangleLeft;
		at: 'SCI_CHARRIGHTRECTEXTEND' put: #extendRectangleRight;
		at: 'SCI_WORDLEFTEXTEND' put: #extendToStartOfWord;
		at: 'SCI_WORDLEFTENDEXTEND' put: #extendToEndOfPreviousWord;
		at: 'SCI_WORDRIGHTEXTEND' put: #extendToEndOfWord;
		at: 'SCI_WORDRIGHTENDEXTEND' put: #extendToEndOfNextWord;
		at: 'SCI_WORDPARTLEFTEXTEND' put: #extendToStartOfWordPart;
		at: 'SCI_WORDPARTRIGHTEXTEND' put: #extendToEndOfWordPart;
		at: 'SCI_DOCUMENTENDEXTEND' put: #extendToEndOfDocument;
		at: 'SCI_DOCUMENTSTARTEXTEND' put: #extendToStartOfDocument;
		at: 'SCI_HOMEEXTEND' put: #extendToStartOfLine;
		at: 'SCI_HOMEWRAPEXTEND' put: #extendToStartOfWrappedLine;
		at: 'SCI_VCHOMEEXTEND' put: #extendToVcHome;
		at: 'SCI_VCHOMERECTEXTEND' put: #extendRectangleToVcHome;
		at: 'SCI_VCHOMEWRAPEXTEND' put: #extendToWrappedVcHome;
		at: 'SCI_HOMEDISPLAYEXTEND' put: #extendToStartOfDisplayLine;
		at: 'SCI_HOMERECTEXTEND' put: #extendRectangleToStartOfLine;
		at: 'SCI_LINEDOWNEXTEND' put: #extendDown;
		at: 'SCI_LINEUPEXTEND' put: #extendUp;
		at: 'SCI_LINEDOWNRECTEXTEND' put: #extendRectangleDown;
		at: 'SCI_LINEUPRECTEXTEND' put: #extendRectangleUp;
		at: 'SCI_LINEENDEXTEND' put: #extendToEndOfLine;
		at: 'SCI_LINEENDRECTEXTEND' put: #extendRectangleToEndOfLine;
		at: 'SCI_LINEENDDISPLAYEXTEND' put: #extendToEndOfDisplayLine;
		at: 'SCI_LINEENDWRAPEXTEND' put: #extendToEndOfWrappedLine;
		at: 'SCI_PAGEUPEXTEND' put: #extendPageUp;
		at: 'SCI_PAGEUPRECTEXTEND' put: #extendRectanglePageUp;
		at: 'SCI_STUTTEREDPAGEUPEXTEND' put: #extendStutteredPageUp;
		at: 'SCI_PAGEDOWNEXTEND' put: #extendPageDown;
		at: 'SCI_STUTTEREDPAGEDOWNEXTEND' put: #extendStutteredPageDown;
		at: 'SCI_PAGEDOWNRECTEXTEND' put: #extendRectanglePageDown;
		at: 'SCI_PARAUPEXTEND' put: #extendParaUp;
		at: 'SCI_PARADOWNEXTEND' put: #extendParaDown;
		at: 'SCI_SELECTALL' put: #basicSelectAll;
		yourself.

	"Unsupported rectangular selection commands"
	false 
		ifTrue: 
			[RenamedMessages
				at: 'SCI_PARADOWNRECTEXTEND' put: #extendRectangleParaDown;
				at: 'SCI_PARAUPRECTEXTEND' put: #extendRectangleParaUp;
				at: 'SCI_WORDLEFTRECTEXTEND' put: #extendRectangleToStartOfWord;
				at: 'SCI_WORDRIGHTRECTEXTEND' put: #extendRectangleToEndOfWord;
				yourself].

	"Deletion"
	RenamedMessages
		at: 'SCI_DELLINELEFT' put: #deleteToStartOfLine;
		at: 'SCI_DELLINERIGHT' put: #deleteToEndOfLine;
		at: 'SCI_DELWORDLEFT' put: #deleteToStartOfWord;
		at: 'SCI_DELWORDRIGHT' put: #deleteToNextWord;
		at: 'SCI_DELWORDRIGHTEND' put: #deleteToEndOfWord;
		at: 'SCI_DELETEBACK' put: #backspace;
		at: 'SCI_DELETEBACKNOTLINE' put: #backspaceNoLine;
		yourself.

	"Insertion"
	RenamedMessages
		at: 'SCI_FORMFEED' put: #formFeed;
		at: 'SCI_NEWLINE' put: #newLine;
		yourself.

	"Cut, Copy & Paste"
	RenamedMessages
		at: 'SCI_PASTE' put: #pasteClipboard;
		at: 'SCI_CUT' put: #cutSelection;
		at: 'SCI_COPY' put: #copySelection;
		at: 'SCI_COPYALLOWLINE' put: #copySelectionOrLine;
		at: 'SCI_LINECUT' put: #cutLine;
		at: 'SCI_LINEDELETE' put: #deleteLine;
		at: 'SCI_LINECOPY' put: #copyLine;
		at: 'SCI_LINEDUPLICATE' put: #duplicateLine;
		at: 'SCI_LINETRANSPOSE' put: #twiddleLines;
		yourself.

	"Other"
	RenamedMessages
		at: 'SCI_UPPERCASE' put: #convertToUppercase;
		at: 'SCI_LOWERCASE' put: #convertToLowercase;
		yourself.

	"1.67"
	RenamedMessages
		at: 'SCI_SELECTIONDUPLICATE' put: #duplicateSelection;
		yourself.

	"1.77"
	RenamedMessages
		at: 'SCI_SETKEYSUNICODE' put: #isKeyboardInputUnicode:;
		at: 'SCI_GETKEYSUNICODE' put: #isKeyboardInputUnicode;
		yourself.

	"2.01"
	RenamedMessages
		at: 'SCI_GETMULTIPLESELECTION' put: #isMultiSelect;
		at: 'SCI_SETMULTIPLESELECTION' put: #isMultiSelect:;
		at: 'SCI_CLEARSELECTIONS' put: #removeSelections;
		at: 'SCI_GETADDITIONALCARETSBLINK' put: #hasBlinkingSecondaryCarets;
		at: 'SCI_SETADDITIONALCARETSBLINK' put: #hasBlinkingSecondaryCarets:;
		at: 'SCI_GETADDITIONALSELALPHA' put: #secondarySelectionAlpha;
		at: 'SCI_SETADDITIONALSELALPHA' put: #secondarySelectionAlpha:;
		at: 'SCI_ROTATESELECTION' put: #rotateSelection;
		at: 'SCI_GETADDITIONALCARETFORE' put: #secondaryCaretForecolor;
		at: 'SCI_GETSELECTIONS' put: #selectionCount;
		at: 'SCI_ANNOTATIONCLEARALL' put: #basicRemoveAllAnnotations;
		at: 'SCI_ANNOTATIONGETSTYLEOFFSET' put: #annotationStylesOffset;
		at: 'SCI_ANNOTATIONSETSTYLEOFFSET' put: #annotationStylesOffset:;
		at: 'SCI_MARGINGETSTYLEOFFSET' put: #marginStylesOffset;
		at: 'SCI_MARGINSETSTYLEOFFSET' put: #marginStylesOffset:;
		at: 'SCI_GETEXTRAASCENT' put: #extraAscent;
		at: 'SCI_SETEXTRAASCENT' put: #extraAscent:;
		at: 'SCI_GETEXTRADESCENT' put: #extraDescent;
		at: 'SCI_SETEXTRADESCENT' put: #extraDescent:;
		at: 'SCI_SWAPMAINANCHORCARET' put: #swapPrimarySelectionAnchorAndCaret;
		yourself.
	RenamedMessages shrink!

initializeTypeMap
	TypeMap := LookupTable new.
	TypeMap
		at: 'void' put: #(nil false '' nil);
		at: 'string' put: #(#String true '' nil);
		at: 'int' put: #(#Integer false '' nil);
		at: 'cells' put: #(#ByteArray true '' nil);
		at: 'position' put: #(#Integer false '' nil);
		at: 'bool' put: #(#Boolean false ' asParameter' #asBoolean);
		at: 'textrange' put: #(#TEXTRANGE true '' #fromAddress:);
		at: 'stringresult' put: #(#String true '' #fromAddress:);
		at: 'colour' put: #(#RGB false ' asParameter' #fromInteger:);
		at: 'keymod' put: #(#Integer false '' nil);
		at: 'findtext' put: #(#FINDTEXT true '' #fromAddress:);
		at: 'formatrange' put: #(#FORMATRANGE true '' #fromAddress:)! !
!ScintillaIfaceParser class categoriesFor: #icon!constants!development!public! !
!ScintillaIfaceParser class categoriesFor: #initialize!initializing!public! !
!ScintillaIfaceParser class categoriesFor: #initializeCommands!initializing!private! !
!ScintillaIfaceParser class categoriesFor: #initializeIgnoredMessages!initializing!private! !
!ScintillaIfaceParser class categoriesFor: #initializeRenamedMessages!initializing!private! !
!ScintillaIfaceParser class categoriesFor: #initializeTypeMap!initializing!private! !

