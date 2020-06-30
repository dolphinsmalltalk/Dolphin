"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RefactoryTestDataApp
	instanceVariableNames: 'temporaryVariable'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoryTestDataApp guid: (GUID fromString: '{dd22adf0-7b3f-4465-aa71-377108619c45}')!
RefactoryTestDataApp comment: 'Test class for Smalllint. Contains lots of smelly code'!
!RefactoryTestDataApp categoriesForClass!Refactory-Test data! !
!RefactoryTestDataApp methodsFor!

== comparand 
	<primitive: 110>
	#rbFix.	"Added to test #overridesSpecialMessage"
	^self primitiveFailed!

anySatisfy
	^((1 to: 10) detect: [:each | each > 2] ifNone: [nil]) isNil!

asOrderedCollectionNotNeeded
	self foo addAll: (1 to: 10) asOrderedCollection!

assignmentInBlock
	[^self printString] ensure: [self close]!

assignmentInIfTrue
	| variable |
	self isVariable 
		ifTrue: [variable := self]
		ifFalse: [variable := self printString].
	^variable!

atIfAbsent
	^Smalltalk at: #Test
		ifAbsent: 
			[| collection |
			collection := #().
			Smalltalk at: #Test put: collection]!

badMessage
	self become: String new!

booleanPrecedence
	^true & 4 = 45!

called: anObject on: aBlock 
	Transcript
		show: anObject printString;
		cr.
	aBlock value!

called: anObject on1: aBlock 
	| each |
	each := anObject printString.
	Transcript
		show: each;
		cr.
	aBlock value: each!

caller
	| anObject |
	anObject := 5.
	self 
		called: anObject + 1
		on: [^anObject]!

caller1
	| anObject |
	anObject := 5.
	self called: anObject + 1
		on1: 
			[:each | 
			each printString.
			^anObject]!

caller2
	^(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]!

callFoo
	^self testFoo: 5!

callMethod
	^self renameThisMethod: 5!

collectionMessagesToExternalObject
	self someObject collection remove: 10!

collectionProtocol
	| newCollection |
	newCollection := OrderedCollection new.
	(1 to: 10) asOrderedCollection do: 
			[:each | 
			| new |
			new := each * 2.
			newCollection add: new].
	^newCollection!

collectSelectNotUsed
	(1 to: 10) select: [:each | each = 4]!

consistencyCheck
	^(1 to: 10) at: 1!

detectAnySatisfy
	^(1 to: 10) do: [:each | each > 2 ifTrue: [^each]]!

endTrueFalse
	self isVariable 
		ifTrue: 
			[self printString.
			self isVariable printString]
		ifFalse: 
			[self printString.
			^4]!

equalNotUsed
	| string |
	string = '' yourself.
	(1 to: 10) do: [:i | string := i printString].
	^string!

equalsTrue
	^true == self!

exampleCall
	^self rename: 1 two: 2!

extraBlock
	^[:arg | arg + 43] value: 45!

fileBlocks
	| file |
	^
	[file := FileStream read: 'asdf'.
	file contents] ensure: [file close]!

foo: aValue
	^(1 to: 10) inject: aValue into: [:sum :each | sum + each]!

fullBlocks
	^[^thisContext]!

guardingClause
	self isSymbol 
		ifFalse: 
			[self printString.
			self isSymbol printString]!

ifTrueBlocks
	self isArray ifFalse: self block ifTrue: [(self printString + 4) * 3]!

ifTrueReturns
	self isSymbol ifFalse: [^true].
	^false!

inlineComponent
	| a |
	a := 5.
	^a class
		superclass;
		hasImmediateInstances;
		yourself!

inlineFailed
	| x y q |
	x := 5.
	y := 10.
	q := x + 1 fooMax: y.
	^q!

inlineFoo: aBlock 
	| bar baz asdf |
	bar := aBlock value: self.
	baz := bar + bar.
	asdf := baz + bar.
	^asdf!

inlineJunk
	| asdf |
	asdf := self inlineFoo: 
					[:each | 
					| temp |
					temp := each.
					temp , temp].
	^asdf foo: 
			[:bar | 
			| baz |
			baz := bar.
			baz * baz]!

inlineLast
	5 = 3 ifTrue: [^self caller] ifFalse: [^self caller2]!

inlineMax
	| x y q |
	x := 5.
	y := 10.
	q := x + 1 max: y.
	^q!

inlineMethod
	| temp |
	temp := self
				foo;
				inlineMethod;
				bar.
	^temp!

inlineParameterMethod: aSymbol
	^aSymbol isSymbol!

inlineTemporary
	| temp |
	self isNil ifTrue: [temp := 4].
	^temp!

isLiteral
	^false!

justSendsSuper
	super justSendsSuper!

literalArrayCharacters
	^#($a $b $c) includes: $a!

literalArrayStringsAndSymbols
	^#('abc' #def) includes: 'abc'!

longMethods
	self printString.
	self printString.
	self isVariable ifTrue: [self printString].
	self isVariable ifTrue: [self printString].
	self isVariable ifTrue: [self printString].
	self isVariable ifTrue: [self printString]!

minMax
	"Bug in 3<5 ifTrue: [3]  ifFalse: [5]"

^3<5 ifTrue: [3]  ifFalse: [5]
"	| var |
	var := 4.
	var < 5 ifTrue: [var := 5].
	^var"!

missingYourself
	^(OrderedCollection new)
		add: 1;
		add: 2;
		removeFirst!

modifiesCollection
	| collection |
	collection := (1 to: 10) asOrderedCollection.
	collection do: [:each | each > 5 ifTrue: [collection remove: each]].
	^collection!

moveDefinition
	| temp |
	^(self collect: 
			[:each | 
			temp := each printString.
			temp , temp]) 
		select: 
			[:each | 
			temp := each size.
			temp odd]!

multipleCalls
	self caller2.
	self caller2!

noMoveDefinition
	| temp |
	^(self collect: 
			[:each | 
			temp := each printString.
			temp , temp]) 
		select: [:each | temp := each size + temp]!

precedence
	^self isArray ifFalse: [self block + 5 * 34] ifTrue: [self printString = 10]!

referencesConditionFor: aClass 
	| environment association |
	^(RBCondition withBlock: 
			[association := Smalltalk associationAt: aClass name
						ifAbsent: [self refactoringError: 'Could not find class'].
			environment := (self environment referencesTo: association) 
						| (self environment referencesTo: aClass name).
			environment isEmpty])
		errorMacro: aClass , ' is referenced.<n>Browse references?';
		errorBlock: [environment openEditor];
		yourself!

refersToClass
	^RefactoryTestDataApp!

release
	self printString!

rename: this two: argumentMethod
	^self printString , this , argumentMethod!

renameThisMethod: anArg
	^self!

returnInEnsure
	[self error: 'asdf'] ensure: [^4]!

returnsBooleanAndOther
	self isVariable ifTrue: [^false].
	self printString!

returnsIfTrue
	^self isNil ifTrue: [4]!

searchingLiteral
	^self printString = #abc 
		or: [#() = self printString | (#[] == self printString)]!

selectorNotReferenced
	^self selectorNotReferenced + 4!

sendInlineParameterMethod
	^self inlineParameterMethod: #(#asdf)!

sendsDifferentSuper
	super printString!

sizeCheck
	self isEmpty
		ifFalse: [self do: 
					[:each | 
					Transcript
						show: each;
						cr]]!

stringConcatenation
	| string |
	string := '' yourself.
	(1 to: 10) do: [:i | string := string , i printString].
	^string!

symbolReference
	^#(#renameThisMethod: #(4 #renameThisMethod:))!

tempsReadBeforeWritten
	| temp |
	self isVariable ifTrue: [temp := 4].
	^temp!

tempVarOverridesInstVar
	| temporaryVariable |
	temporaryVariable := 4.
	^temporaryVariable!

testFoo: anObject
	^self class + anObject!

testMethod
	^self class!

testMethod1
	^self testMethod1 
		, ([:each | each testMethod1] value: #(#(#testMethod1) 2 #testMethod1))!

threeElementPoint
	^5 @ 5 + 6 @ 6!

toDo
	1 to: self size do: [:i | (self at: i) printString]!

toDoCollect
	| array |
	array := Array new: 10.
	1 to: 10 do: [:i | array at: i put: i * i].
	^array!

toDoWithIncrement
	| counter |
	counter := 0.
	1 to: 10
		by: 2
		do: [:i | counter := counter + 2].
	^counter!

usesAdd
	^(1 to: 10) asOrderedCollection addAll: (11 to: 20)!

variableAssignedLiteral
	temporaryVariable := #()!

whileTrue
	| i |
	i := 1.
	[i < self size] whileTrue: 
			[(self at: i) printString.
			i := i + 1]!

yourselfNotUsed
	self
		printString;
		printString;
		yourself! !
!RefactoryTestDataApp categoriesFor: #==!comparing!public! !
!RefactoryTestDataApp categoriesFor: #anySatisfy!lint!public! !
!RefactoryTestDataApp categoriesFor: #asOrderedCollectionNotNeeded!lint!public! !
!RefactoryTestDataApp categoriesFor: #assignmentInBlock!lint!public! !
!RefactoryTestDataApp categoriesFor: #assignmentInIfTrue!lint!public! !
!RefactoryTestDataApp categoriesFor: #atIfAbsent!lint!public! !
!RefactoryTestDataApp categoriesFor: #badMessage!lint!public! !
!RefactoryTestDataApp categoriesFor: #booleanPrecedence!lint!public! !
!RefactoryTestDataApp categoriesFor: #called:on:!inline!public! !
!RefactoryTestDataApp categoriesFor: #called:on1:!inline!public! !
!RefactoryTestDataApp categoriesFor: #caller!inline!public! !
!RefactoryTestDataApp categoriesFor: #caller1!inline!public! !
!RefactoryTestDataApp categoriesFor: #caller2!inline!public! !
!RefactoryTestDataApp categoriesFor: #callFoo!public!test! !
!RefactoryTestDataApp categoriesFor: #callMethod!public!test! !
!RefactoryTestDataApp categoriesFor: #collectionMessagesToExternalObject!lint!public! !
!RefactoryTestDataApp categoriesFor: #collectionProtocol!lint!public! !
!RefactoryTestDataApp categoriesFor: #collectSelectNotUsed!lint!public! !
!RefactoryTestDataApp categoriesFor: #consistencyCheck!lint!public! !
!RefactoryTestDataApp categoriesFor: #detectAnySatisfy!lint!public! !
!RefactoryTestDataApp categoriesFor: #endTrueFalse!lint!public! !
!RefactoryTestDataApp categoriesFor: #equalNotUsed!lint!public! !
!RefactoryTestDataApp categoriesFor: #equalsTrue!lint!public! !
!RefactoryTestDataApp categoriesFor: #exampleCall!public!test! !
!RefactoryTestDataApp categoriesFor: #extraBlock!lint!public! !
!RefactoryTestDataApp categoriesFor: #fileBlocks!lint!public! !
!RefactoryTestDataApp categoriesFor: #foo:!inline!public! !
!RefactoryTestDataApp categoriesFor: #fullBlocks!lint!public! !
!RefactoryTestDataApp categoriesFor: #guardingClause!lint!public! !
!RefactoryTestDataApp categoriesFor: #ifTrueBlocks!lint!public! !
!RefactoryTestDataApp categoriesFor: #ifTrueReturns!lint!public! !
!RefactoryTestDataApp categoriesFor: #inlineComponent!inline!public! !
!RefactoryTestDataApp categoriesFor: #inlineFailed!inline!public! !
!RefactoryTestDataApp categoriesFor: #inlineFoo:!public!test! !
!RefactoryTestDataApp categoriesFor: #inlineJunk!public!test! !
!RefactoryTestDataApp categoriesFor: #inlineLast!inline!public! !
!RefactoryTestDataApp categoriesFor: #inlineMax!inline!public! !
!RefactoryTestDataApp categoriesFor: #inlineMethod!public!test! !
!RefactoryTestDataApp categoriesFor: #inlineParameterMethod:!public!test! !
!RefactoryTestDataApp categoriesFor: #inlineTemporary!inline!public! !
!RefactoryTestDataApp categoriesFor: #isLiteral!lint!public! !
!RefactoryTestDataApp categoriesFor: #justSendsSuper!lint!public! !
!RefactoryTestDataApp categoriesFor: #literalArrayCharacters!lint!public! !
!RefactoryTestDataApp categoriesFor: #literalArrayStringsAndSymbols!lint!public! !
!RefactoryTestDataApp categoriesFor: #longMethods!lint!public! !
!RefactoryTestDataApp categoriesFor: #minMax!lint!public! !
!RefactoryTestDataApp categoriesFor: #missingYourself!lint!public! !
!RefactoryTestDataApp categoriesFor: #modifiesCollection!lint!public! !
!RefactoryTestDataApp categoriesFor: #moveDefinition!public!test! !
!RefactoryTestDataApp categoriesFor: #multipleCalls!inline!public! !
!RefactoryTestDataApp categoriesFor: #noMoveDefinition!public!test! !
!RefactoryTestDataApp categoriesFor: #precedence!lint!public! !
!RefactoryTestDataApp categoriesFor: #referencesConditionFor:!accessing!public! !
!RefactoryTestDataApp categoriesFor: #refersToClass!lint!public! !
!RefactoryTestDataApp categoriesFor: #release!lint!public! !
!RefactoryTestDataApp categoriesFor: #rename:two:!public!test! !
!RefactoryTestDataApp categoriesFor: #renameThisMethod:!public!test! !
!RefactoryTestDataApp categoriesFor: #returnInEnsure!lint!public! !
!RefactoryTestDataApp categoriesFor: #returnsBooleanAndOther!lint!public! !
!RefactoryTestDataApp categoriesFor: #returnsIfTrue!lint!public! !
!RefactoryTestDataApp categoriesFor: #searchingLiteral!lint!public! !
!RefactoryTestDataApp categoriesFor: #selectorNotReferenced!public!test! !
!RefactoryTestDataApp categoriesFor: #sendInlineParameterMethod!public!test! !
!RefactoryTestDataApp categoriesFor: #sendsDifferentSuper!lint!public! !
!RefactoryTestDataApp categoriesFor: #sizeCheck!lint!public! !
!RefactoryTestDataApp categoriesFor: #stringConcatenation!lint!public! !
!RefactoryTestDataApp categoriesFor: #symbolReference!public!test! !
!RefactoryTestDataApp categoriesFor: #tempsReadBeforeWritten!lint!public! !
!RefactoryTestDataApp categoriesFor: #tempVarOverridesInstVar!lint!public! !
!RefactoryTestDataApp categoriesFor: #testFoo:!public!test! !
!RefactoryTestDataApp categoriesFor: #testMethod!public!test! !
!RefactoryTestDataApp categoriesFor: #testMethod1!public!test! !
!RefactoryTestDataApp categoriesFor: #threeElementPoint!lint!public! !
!RefactoryTestDataApp categoriesFor: #toDo!lint!public! !
!RefactoryTestDataApp categoriesFor: #toDoCollect!lint!public! !
!RefactoryTestDataApp categoriesFor: #toDoWithIncrement!lint!public! !
!RefactoryTestDataApp categoriesFor: #usesAdd!lint!public! !
!RefactoryTestDataApp categoriesFor: #variableAssignedLiteral!lint!public! !
!RefactoryTestDataApp categoriesFor: #whileTrue!lint!public! !
!RefactoryTestDataApp categoriesFor: #yourselfNotUsed!lint!public! !

!RefactoryTestDataApp class methodsFor!

comment
	#rbFix.	"Added to test #overridesSpecialMessage"
	^'Test class for Smalllint. Contains lots of smelly code'! !
!RefactoryTestDataApp class categoriesFor: #comment!accessing!public! !

