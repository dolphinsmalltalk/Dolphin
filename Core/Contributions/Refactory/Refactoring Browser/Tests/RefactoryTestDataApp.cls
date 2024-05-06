"Filed out from Dolphin Smalltalk"!

Object subclass: #RefactoryTestDataApp
	instanceVariableNames: 'temporaryVariable'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!

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

!RefactoryTestDataApp categoriesForMethods!
==!comparing!public! !
anySatisfy!lint!public! !
asOrderedCollectionNotNeeded!lint!public! !
assignmentInBlock!lint!public! !
assignmentInIfTrue!lint!public! !
atIfAbsent!lint!public! !
badMessage!lint!public! !
booleanPrecedence!lint!public! !
called:on:!inline!public! !
called:on1:!inline!public! !
caller!inline!public! !
caller1!inline!public! !
caller2!inline!public! !
callFoo!public!test! !
callMethod!public!test! !
collectionMessagesToExternalObject!lint!public! !
collectionProtocol!lint!public! !
collectSelectNotUsed!lint!public! !
consistencyCheck!lint!public! !
detectAnySatisfy!lint!public! !
endTrueFalse!lint!public! !
equalNotUsed!lint!public! !
equalsTrue!lint!public! !
exampleCall!public!test! !
extraBlock!lint!public! !
fileBlocks!lint!public! !
foo:!inline!public! !
fullBlocks!lint!public! !
guardingClause!lint!public! !
ifTrueBlocks!lint!public! !
ifTrueReturns!lint!public! !
inlineComponent!inline!public! !
inlineFailed!inline!public! !
inlineFoo:!public!test! !
inlineJunk!public!test! !
inlineLast!inline!public! !
inlineMax!inline!public! !
inlineMethod!public!test! !
inlineParameterMethod:!public!test! !
inlineTemporary!inline!public! !
isLiteral!lint!public! !
justSendsSuper!lint!public! !
literalArrayCharacters!lint!public! !
literalArrayStringsAndSymbols!lint!public! !
longMethods!lint!public! !
minMax!lint!public! !
missingYourself!lint!public! !
modifiesCollection!lint!public! !
moveDefinition!public!test! !
multipleCalls!inline!public! !
noMoveDefinition!public!test! !
precedence!lint!public! !
referencesConditionFor:!accessing!public! !
refersToClass!lint!public! !
release!lint!public! !
rename:two:!public!test! !
renameThisMethod:!public!test! !
returnInEnsure!lint!public! !
returnsBooleanAndOther!lint!public! !
returnsIfTrue!lint!public! !
searchingLiteral!lint!public! !
selectorNotReferenced!public!test! !
sendInlineParameterMethod!public!test! !
sendsDifferentSuper!lint!public! !
sizeCheck!lint!public! !
stringConcatenation!lint!public! !
symbolReference!public!test! !
tempsReadBeforeWritten!lint!public! !
tempVarOverridesInstVar!lint!public! !
testFoo:!public!test! !
testMethod!public!test! !
testMethod1!public!test! !
threeElementPoint!lint!public! !
toDo!lint!public! !
toDoCollect!lint!public! !
toDoWithIncrement!lint!public! !
usesAdd!lint!public! !
variableAssignedLiteral!lint!public! !
whileTrue!lint!public! !
yourselfNotUsed!lint!public! !
!

!RefactoryTestDataApp class methodsFor!

comment
	#rbFix.	"Added to test #overridesSpecialMessage"
	^'Test class for Smalllint. Contains lots of smelly code'! !

!RefactoryTestDataApp class categoriesForMethods!
comment!accessing!public! !
!

