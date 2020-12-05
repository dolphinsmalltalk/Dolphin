"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.Tests.RefactoryTestDataApp'
	instanceVariableNames: 'temporaryVariable'
	classVariableNames: ''
	imports: #(#{OS.CRTConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RefactoryTestDataApp guid: (Core.GUID fromString: '{dd22adf0-7b3f-4465-aa71-377108619c45}')!
Refactory.Browser.Tests.RefactoryTestDataApp comment: 'Test class for Smalllint. Contains lots of smelly code'!
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.RefactoryTestDataApp methodsFor!

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
	^OrderedCollection new
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
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #==!comparing!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #anySatisfy!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #asOrderedCollectionNotNeeded!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #assignmentInBlock!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #assignmentInIfTrue!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #atIfAbsent!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #badMessage!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #booleanPrecedence!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #called:on:!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #called:on1:!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #caller!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #caller1!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #caller2!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #callFoo!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #callMethod!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #collectionMessagesToExternalObject!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #collectionProtocol!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #collectSelectNotUsed!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #consistencyCheck!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #detectAnySatisfy!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #endTrueFalse!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #equalNotUsed!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #equalsTrue!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #exampleCall!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #extraBlock!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #fileBlocks!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #foo:!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #fullBlocks!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #guardingClause!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #ifTrueBlocks!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #ifTrueReturns!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineComponent!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineFailed!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineFoo:!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineJunk!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineLast!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineMax!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineMethod!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineParameterMethod:!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #inlineTemporary!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #isLiteral!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #justSendsSuper!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #literalArrayCharacters!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #literalArrayStringsAndSymbols!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #longMethods!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #minMax!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #missingYourself!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #modifiesCollection!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #moveDefinition!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #multipleCalls!inline!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #noMoveDefinition!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #precedence!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #referencesConditionFor:!accessing!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #refersToClass!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #release!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #rename:two:!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #renameThisMethod:!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #returnInEnsure!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #returnsBooleanAndOther!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #returnsIfTrue!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #searchingLiteral!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #selectorNotReferenced!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #sendInlineParameterMethod!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #sendsDifferentSuper!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #sizeCheck!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #stringConcatenation!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #symbolReference!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #tempsReadBeforeWritten!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #tempVarOverridesInstVar!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #testFoo:!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #testMethod!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #testMethod1!public!test! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #threeElementPoint!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #toDo!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #toDoCollect!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #toDoWithIncrement!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #usesAdd!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #variableAssignedLiteral!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #whileTrue!lint!public! !
!Refactory.Browser.Tests.RefactoryTestDataApp categoriesFor: #yourselfNotUsed!lint!public! !

!Refactory.Browser.Tests.RefactoryTestDataApp class methodsFor!

comment
	#rbFix.	"Added to test #overridesSpecialMessage"
	^'Test class for Smalllint. Contains lots of smelly code'! !
!Refactory.Browser.Tests.RefactoryTestDataApp class categoriesFor: #comment!accessing!public! !

