"Filed out from Dolphin Smalltalk 7"!

StsEdition subclass: #StsMethodEdition
	instanceVariableNames: 'classSymbol selector isPrivate categoriesString source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsMethodEdition guid: (GUID fromString: '{BA7BAEAB-0FCA-11D4-B091-000000000000}')!
StsMethodEdition comment: ''!
!StsMethodEdition categoriesForClass!Unclassified! !
!StsMethodEdition methodsFor!

= anObject 
	anObject == self ifTrue: [^true].
	anObject class == self class ifFalse: [^false].
	^timestamp = anObject timestamp and: 
			[selector = anObject selector and: 
					[developer = anObject developer and: 
							[classSymbol = anObject classSymbol and: 
									[source = anObject source and: 
											[((self categoriesString subStrings: $!!) asSortedCollection: [:a :b | a byteCompare: b]) 
												= ((anObject categoriesString subStrings: $!!) asSortedCollection: [:a :b | a byteCompare: b]) 
													and: [self isPrivate = anObject isPrivate]]]]]]!

basicExportAsSmalltalkXChangeSetOn: aStream packageName: packageName 
	self putSmalltalkXDeveloperAndTimestampOn: aStream.
	aStream
		nextPut: $!!;
		nextPutAll: self className;
		nextPutAll: ' methodsFor:''' , self defaultCategory , '''!!

';
		nextPutAll: self sourceForFileout;
		nextPutAll: '
!! !!

'!

basicExportAsSqueakFileOutOn: aStream packageName: packageName 
	| stamp date time |
	aStream
		nextPut: $!!;
		nextPutAll: self className;
		nextPutAll: ' methodsFor: ';
		nextPutAll: (packageName isNil 
					ifTrue: [self defaultCategory]
					ifFalse: ['*' , (self convertToSqueakPackageName: packageName) asLowercase]) printString;
		nextPutAll: ' stamp: '.
	stamp := self developer , ' '.
	date := self timestamp date.
	time := self timestamp time.
	stamp := stamp , date monthIndex printString , '/' , date dayOfMonth printString , '/' 
				, date year printString , ' ' 
				, time hours printString , ':' 
				, (time minutes < 10 ifTrue: ['0' , time minutes printString] ifFalse: [time minutes printString]).
	aStream
		nextPutAll: stamp printString;
		nextPutAll: '!!
';
		nextPutAll: self sourceForFileout;
		nextPutAll: '!! !!
'!

basicExportAsVastDoItScriptOn: aStream packageName: packageName 
	| catString |
	catString := ''.
	(self categories 
		reject: [:each | each isPrivacy or: [MethodCategory pseudoCategories includes: each]]) 
			do: [:each | catString := catString , ' ' , each name printString].
	aStream nextPutAll: self vastClassReferenceExpression.
	self isPrivate 
		ifFalse: [aStream nextPutAll: '
	compile: ']
		ifTrue: [aStream nextPutAll: '
	compileAsPrivate: '].
	aStream
		nextPutAll: self source printString;
		nextPutAll: '
	notifying: Transcript
	ifNewAddTo: (controllers at: ';
		nextPutAll: packageName printString;
		nextPutAll: ')
	categorizeIn: #(';
		nextPutAll: catString;
		nextPutAll: ').
'!

basicExportAsVWChangeSetOn: xmlWriter parcelName: parcelName 
	"Export method as VW change set XML.
	If parcelName is not nil it will be also added to parcel."

	xmlWriter tag: 'methods'
		do: 
			[xmlWriter
				tag: 'class-id' value: (self classNameForVisualWorks: self className);
				tag: 'category' value: self defaultCategory;
				tag: 'body' value: self source].
	parcelName isNil 
		ifFalse: 
			[xmlWriter tag: 'component_selector_change'
				do: 
					[xmlWriter
						tag: 'name' value: parcelName;
						tag: 'type' value: 'parcel';
						tag: 'definitionName' value: (self fullClassNameForVisualWorks: self className);
						tag: 'meta' value: ((self className includes: $ ) ifTrue: ['true'] ifFalse: ['false']);
						tag: 'selector' value: self selector asString;
						tag: 'definitionChange' value: 'added']]!

basicExportAsXmlOn: writer 
	writer tag: 'method'
		do: 
			[writer
				tag: 'selector' value: self selector;
				tag: 'developer' value: self developer;
				tag: 'timestamp' value: self timestampValue;
				tag: 'isPrivate' value: self isPrivate printString;
				tag: 'categories' value: self categoriesString;
				tag: 'class' value: self classSymbol;
				tag: 'source' value: self source]!

basicExportLooseMethodAsXmlOn: writer 
	writer tag: 'looseMethod'
		do: 
			[writer
				tag: 'selector' value: self selector;
				tag: 'developer' value: self developer;
				tag: 'timestamp' value: self timestampValue;
				tag: 'isPrivate' value: self isPrivate printString;
				tag: 'categories' value: self categoriesString;
				tag: 'class' value: self classSymbol;
				tag: 'source' value: self source]!

browseEdition
	self sourceControl browseMethodEditions: self selector class: self classSymbol!

categories
	| coll stream |
	coll := OrderedCollection new.
	coll add: (self isPrivate ifTrue: [MethodCategory private] ifFalse: [MethodCategory public]).
	stream := ReadStream on: self categoriesString.
	[stream atEnd] whileFalse: [coll add: (MethodCategory name: (stream upTo: $!!))].
	^coll!

categoriesFromString: aString 
	"Answer a collection of categories parsed from aString.  Exclude pseudo-categories."

	| col stm pseudoCategories |
	col := OrderedCollection new.
	stm := aString readStream.
	pseudoCategories := MethodCategory pseudoCategories collect: [:e | e name].
	
	[col add: (stm upTo: $!!).
	stm atEnd] whileFalse.
	^(col reject: [:e | pseudoCategories includes: e]) asSortedCollection!

categoriesString
	^(categoriesString isNil or: [categoriesString isEmpty]) 
		ifTrue: ['*-unclassified!!']
		ifFalse: [categoriesString]!

categoriesString: aString 
	categoriesString := aString!

className
	^classSymbol asString!

classNameInstanceSide
	| className |
	^((className := self className) endsWith: ' class') 
		ifFalse: [className]
		ifTrue: [className copyFrom: 1 to: className size - 6]!

classSymbol
	^classSymbol!

compareIgnoringWhitespaceSource: str with: str2 
	| rs1 rs2 insideComment insideString ch1 ch2 whiteSpaceChars pch1 pch2 |
	whiteSpaceChars := #(10 13 9 32) collect: [:each | each asCharacter].
	str = str2 ifTrue: [^true].
	insideString := false.
	insideComment := false.
	rs1 := ReadStream on: str.
	rs2 := ReadStream on: str2.
	
	[pch1 := ch1.
	pch2 := ch2.
	ch1 := rs1 atEnd ifFalse: [rs1 next].
	ch2 := rs2 atEnd ifFalse: [rs2 next].
	ch1 isNil 
		ifTrue: 
			[(insideComment or: [insideString]) 
				ifFalse: 
					[[(whiteSpaceChars includes: ch2) or: [ch2 = $.]] whileTrue: [ch2 := rs2 atEnd ifFalse: [rs2 next]]].
			^ch2 isNil]
		ifFalse: 
			[ch2 isNil 
				ifTrue: 
					[(insideComment or: [insideString]) 
						ifFalse: 
							[[(whiteSpaceChars includes: ch1) or: [ch1 = $.]] whileTrue: [ch1 := rs1 atEnd ifFalse: [rs1 next]]].
					^ch1 isNil]].
	insideComment 
		ifTrue: 
			[ch1 = ch2 ifFalse: [^false].
			ch1 = $" ifTrue: [insideComment := false]]
		ifFalse: 
			[insideString 
				ifTrue: 
					[ch1 = ch2 ifFalse: [^false].
					ch1 = $' ifTrue: [insideString := false]]
				ifFalse: 
					[(whiteSpaceChars includes: ch1) 
						ifTrue: 
							[ch1 := $ .
							[whiteSpaceChars includes: rs1 peek] whileTrue: [rs1 next]].
					(whiteSpaceChars includes: ch2) 
						ifTrue: 
							[ch2 := $ .
							[whiteSpaceChars includes: rs2 peek] whileTrue: [rs2 next]].
					ch1 = ch2 
						ifFalse: 
							["za primer, ko je oklepaj preblizu"
							(pch1 = $[ or: [pch1 = $(]) 
								ifTrue: 
									[ch1 = $  
										ifTrue: 
											[ch2 := $ .
											rs2 position: rs2 position - 1]
										ifFalse: 
											[ch2 = $  
												ifTrue: 
													[ch1 := $ .
													rs1 position: rs1 position - 1]]]
								ifFalse: 
									["za primer, ko je zaklepaj brez presledka pred njim"
									(ch1 = $  and: [ch2 = $[ or: [ch2 = $(]]) 
										ifTrue: [rs1 peek = ch2 ifTrue: [ch1 := rs1 next]]
										ifFalse: [(ch2 = $  and: [ch1 = $[ or: [ch1 = $(]]) ifTrue: [rs2 peek = ch1 ifTrue: [ch2 := rs2 next]]]]].
					ch1 = ch2 ifFalse: [^false].
					ch1 = $' ifTrue: [insideString := true] ifFalse: [ch1 = $" ifTrue: [insideComment := true]]]].
	true] 
			whileTrue: []!

correspondsTo: aCompiledMethod 
	^self 
		correspondsTo: aCompiledMethod getSource
		privacy: aCompiledMethod isPrivate
		categories: (self class categoriesStringFor: aCompiledMethod)!

correspondsTo: methodSource privacy: aBoolean categories: aString 
	^self source = methodSource and: 
			[self isPrivate = aBoolean 
				and: [(self categoriesFromString: self categoriesString) = (self categoriesFromString: aString)]]!

defaultCategory
	| tokens |
	tokens := #().
	(categoriesString isNil or: [categoriesString isEmpty]) 
		ifFalse: [tokens := categoriesString subStrings: $!!].
	tokens 
		do: [:each | (each notEmpty and: [('*UNCLASSIFIED*' match: each asUppercase) not]) ifTrue: [^each]].
	^self isPrivate ifTrue: ['private'] ifFalse: ['public']!

displayOn: aStream 
	self isLoaded ifTrue: [aStream nextPut: $*].
	aStream nextPut: $(.
	timestamp printOn: aStream.
	aStream nextPutAll: ')'.
	developer isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' by ';
				nextPutAll: developer]!

icon
	^isPrivate == true
		ifTrue: [Smalltalk developmentSystem privateMethodIcon]
		ifFalse: [Smalltalk developmentSystem publicMethodIcon]!

isExpression
	^false!

isLoaded
	| compiledMethod |
	^self methodClass notNil and: 
			[(compiledMethod := self methodClass compiledMethodAt: selector ifAbsent: []) notNil 
				and: [self correspondsTo: compiledMethod]]!

isPrivate
	^isPrivate == true!

isPrivate: aBoolean 
	isPrivate := aBoolean!

isPublic
	^self isPrivate == false!

isSimilarIgnoringCategoriesTo: anObject 
	anObject == self ifTrue: [^true].
	anObject class == self class ifFalse: [^false].
	^selector = anObject selector 
		and: [classSymbol = anObject classSymbol and: [source = anObject source]]!

isSimilarIgnoringWhitespaceAndCategoryChangesTo: anObject 
	anObject == self ifTrue: [^true].
	anObject class == self class ifFalse: [^false].
	^selector = anObject selector and: 
			[classSymbol = anObject classSymbol 
				and: [self compareIgnoringWhitespaceSource: source with: anObject source]]!

isSimilarIgnoringWhitespaceChangesTo: anObject 
	anObject == self ifTrue: [^true].
	anObject class == self class ifFalse: [^false].
	^selector = anObject selector and: 
			[classSymbol = anObject classSymbol and: 
					[(self compareIgnoringWhitespaceSource: source with: anObject source) and: 
							["Categories comparing may be confusing becouse of special categories use: -changed, -unclasified."
							((self categoriesString subStrings: $!!) asSortedCollection: [:a :b | a byteCompare: b]) 
								= ((anObject categoriesString subStrings: $!!) asSortedCollection: [:a :b | a byteCompare: b]) 
									and: [self isPrivate = anObject isPrivate]]]]!

load
	self methodClass isNil 
		ifTrue: [self logError: 'Can not load ' , selector printString , '.  Method class does not exist']
		ifFalse: [self methodClass compile: self source categories: self categories]!

methodClass
	^(classSymbol includes: $ ) 
		ifFalse: [Smalltalk at: classSymbol ifAbsent: []]
		ifTrue: [(Smalltalk at: (classSymbol copyFrom: 1 to: classSymbol size - 6) ifAbsent: [^nil]) class]!

methodClass: aClassOrSymbol 
	classSymbol := aClassOrSymbol class == Symbol 
				ifTrue: [aClassOrSymbol]
				ifFalse: [aClassOrSymbol name asSymbol]!

methodClassOrProxy
	| className classObject |
	className := (classSymbol includes: $ ) 
				ifFalse: [classSymbol]
				ifTrue: [classSymbol copyFrom: 1 to: classSymbol size - 6].
	classObject := Smalltalk at: className ifAbsent: [StsClassProxy new name: className].
	^(classSymbol includes: $ ) ifTrue: [classObject metaClass] ifFalse: [classObject]!

name
	^classSymbol asString , '>>' , selector asString!

selector
	^selector!

selector: aSymbol 
	selector := aSymbol!

source
	"Sending #odbResolve insures that object is already fetched from the database
		(will never answer an instance of ODBReference)."

	^source odbResolve!

source: aString 
	source := aString!

sourceForFileout
	| rs ws ch |
	rs := ReadStream on: self source.
	ws := WriteStream on: (String new: rs size + 10).
	[rs atEnd] whileFalse: 
			[ch := rs next.
			ws nextPut: ch.
			ch = $!! ifTrue: [ws nextPut: ch]].
	^ws contents!

vastClassReferenceExpression
	| className |
	^((className := self className) endsWith: ' class') 
		ifFalse: ['(Smalltalk at: #' , className , ')']
		ifTrue: ['(Smalltalk at: #' , (className copyFrom: 1 to: className size - 6) , ') class']! !
!StsMethodEdition categoriesFor: #=!public! !
!StsMethodEdition categoriesFor: #basicExportAsSmalltalkXChangeSetOn:packageName:!public! !
!StsMethodEdition categoriesFor: #basicExportAsSqueakFileOutOn:packageName:!public! !
!StsMethodEdition categoriesFor: #basicExportAsVastDoItScriptOn:packageName:!public! !
!StsMethodEdition categoriesFor: #basicExportAsVWChangeSetOn:parcelName:!public! !
!StsMethodEdition categoriesFor: #basicExportAsXmlOn:!public! !
!StsMethodEdition categoriesFor: #basicExportLooseMethodAsXmlOn:!public! !
!StsMethodEdition categoriesFor: #browseEdition!public! !
!StsMethodEdition categoriesFor: #categories!public! !
!StsMethodEdition categoriesFor: #categoriesFromString:!public! !
!StsMethodEdition categoriesFor: #categoriesString!public! !
!StsMethodEdition categoriesFor: #categoriesString:!public! !
!StsMethodEdition categoriesFor: #className!public! !
!StsMethodEdition categoriesFor: #classNameInstanceSide!private! !
!StsMethodEdition categoriesFor: #classSymbol!public! !
!StsMethodEdition categoriesFor: #compareIgnoringWhitespaceSource:with:!public! !
!StsMethodEdition categoriesFor: #correspondsTo:!public! !
!StsMethodEdition categoriesFor: #correspondsTo:privacy:categories:!public! !
!StsMethodEdition categoriesFor: #defaultCategory!public! !
!StsMethodEdition categoriesFor: #displayOn:!public! !
!StsMethodEdition categoriesFor: #icon!public! !
!StsMethodEdition categoriesFor: #isExpression!public! !
!StsMethodEdition categoriesFor: #isLoaded!public! !
!StsMethodEdition categoriesFor: #isPrivate!public! !
!StsMethodEdition categoriesFor: #isPrivate:!public! !
!StsMethodEdition categoriesFor: #isPublic!public! !
!StsMethodEdition categoriesFor: #isSimilarIgnoringCategoriesTo:!public! !
!StsMethodEdition categoriesFor: #isSimilarIgnoringWhitespaceAndCategoryChangesTo:!public! !
!StsMethodEdition categoriesFor: #isSimilarIgnoringWhitespaceChangesTo:!public! !
!StsMethodEdition categoriesFor: #load!public! !
!StsMethodEdition categoriesFor: #methodClass!public! !
!StsMethodEdition categoriesFor: #methodClass:!public! !
!StsMethodEdition categoriesFor: #methodClassOrProxy!public! !
!StsMethodEdition categoriesFor: #name!public! !
!StsMethodEdition categoriesFor: #selector!public! !
!StsMethodEdition categoriesFor: #selector:!public! !
!StsMethodEdition categoriesFor: #source!public! !
!StsMethodEdition categoriesFor: #source:!public! !
!StsMethodEdition categoriesFor: #sourceForFileout!public! !
!StsMethodEdition categoriesFor: #vastClassReferenceExpression!private! !

!StsMethodEdition class methodsFor!

categoriesStringFor: aCompiledMethod 
	(aCompiledMethod respondsTo: #categoriesString) 
		ifTrue: [^aCompiledMethod categoriesString]
		ifFalse: 
			[| str |
			str := ''.
			aCompiledMethod methodClass methodsCatalogue keys 
				do: [:each | (each includesMethod: aCompiledMethod) ifTrue: [str := str , each name , '!!']].
			MethodCategory pseudoCategories do: 
					[:each | 
					(each isPrivacy not and: [each includesMethod: aCompiledMethod]) 
						ifTrue: [str := str , each name , '!!']].
			^str]!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!StsMethodEdition class categoriesFor: #categoriesStringFor:!public! !
!StsMethodEdition class categoriesFor: #icon!constants!public! !

