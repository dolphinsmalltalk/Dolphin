"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.TestData.RefactoryTestDataApp'
	instanceVariableNames: 'temporaryVariable'
	classVariableNames: 'ClassVar1 ClassVar2'
	imports: #(#{OS.CRTConstants})
	classInstanceVariableNames: ''
	classConstants: { 'AppConst1' -> 'ClassConst1 of RefactoryTestDataApp' }!

Refactory.Browser.TestData.RefactoryTestDataApp guid: (Core.GUID fromString: '{dd22adf0-7b3f-4465-aa71-377108619c45}')!

Refactory.Browser.TestData.RefactoryTestDataApp comment: 'Test class for Smalllint. Contains lots of smelly code'!

!Refactory.Browser.TestData.RefactoryTestDataApp categoriesForClass!Refactory-Test data! !

!Refactory.Browser.TestData.RefactoryTestDataApp methodsFor!

== comparand 
	<primitive: 110>
	#rbFix.	"Added to test #overridesSpecialMessage"
	^self primitiveFailed!

annotationReference
	<renameThisMethod: #foo>
	^self!

annotationReferenceTwo
	<rename: #foo two: #bar>!

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

braceArray
	^{1. 2. 3. 4. 5}!

called: anObject on: aBlock
	"Method-level comment from #called:on:🐬"

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
	"🐬 Method-level comment from #foo:"

	^(1 to: 10) inject: aValue into: [:sum :each | sum + each] 	"🐭 Statement-level comment from #foo:"
!

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

inlineTemporary
	| temp |
	self isNil ifTrue: [temp := 4].
	^temp!

inlineWithNamespace
	^{ self refersToClassUnqualified. self refersToClassFullyQualifiedBindingInArray }!

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

refersToClassBindingNotFound
	^#{_.Tests.DolphinTest} bindingOrNil!

refersToClassBindingNotFoundInArray
	^#(#{_.Tests.DolphinTest} #{_.Tests.ClassToRename} #{ClassToRename} #{Foo.ClassToRename})
		collect: [:each | each valueOrNil]!

refersToClassConstantFullyQualified
	^Refactory.Browser.Tests.ClassToRename.ClassConst1!

refersToClassConstantPartiallyQualified
	^Tests.ClassToRename.ClassConst1!

refersToClassConstantPartiallyQualifiedWithNamespace
	<namespace: Refactory.Browser.Tests>
	^ClassToRename.ClassConst1!

refersToClassConstantUnqualified
	<namespace: Refactory.Browser.Tests.ClassToRename>
	^ClassConst1!

refersToClassFullyQualified
	^Refactory.Browser.Tests.ClassToRename!

refersToClassFullyQualifiedBinding
	^#{Refactory.Browser.Tests.ClassToRename}!

refersToClassFullyQualifiedBindingInArray
	^#(#{Refactory.Browser.Tests.ClassToRename})!

refersToClassFullyQualifiedName
	"Symbols are no longer renamed, even if fully-qualified. BindingReferences should always be used to refer indirectly to classes by name."

	^#'Refactory.Browser.Tests.ClassToRename'!

refersToClassFullyQualifiedNameInArray
	^#(#'Refactory.Browser.Tests.ClassToRename')!

refersToClassPartiallyQualified1
	^Tests.ClassToRename!

refersToClassPartiallyQualified2
	^Browser.Tests.ClassToRename!

refersToClassPartiallyQualifiedBinding1
	^#{_.Tests.ClassToRename}!

refersToClassPartiallyQualifiedBinding2
	^#{_.Browser.Tests.ClassToRename}!

refersToClassPartiallyQualifiedBindingInArray
	^#(#{_.Browser.Tests.ClassToRename class})!

refersToClassPartiallyQualifiedName
	"We don't expect this to be recognised as a refercne to ClassToRename"

	^#'Tests.ClassToRename'!

refersToClassUnqualified
	"🐬 Method-level comment from #refersToClassUnqualified"

	<namespace: Refactory.Browser.Tests>
	^ClassToRename	"🐭 Statement-level comment from #refersToClassUnqualified"!

refersToClassUnqualifiedBinding
	<namespace: Refactory.Browser.Tests>
	^#{ClassToRename private}!

refersToClassUnqualifiedBindingInArray
	<namespace: Refactory.Browser.Tests>
	^#(#{ClassToRename class})!

refersToClassUnqualifiedInArray
	<namespace: Refactory.Browser.Tests>
	^{ClassToRename}!

refersToClassUnqualifiedName
	"Symbols are no longer renamed and are not considered to be class references"

	<namespace: Refactory.Browser.Tests>
	^#ClassToRename!

refersToClassUnqualifiedNameInArray
	<namespace: Refactory.Browser.Tests>
	^#(#ClassToRename)!

refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
	<namespace: Browser.Tests>
	^ClassToRename!

refersToClassVariableFullyQualified
	^Refactory.Browser.Tests.ClassToRename.ClassVar1!

refersToClassVariablePartiallyQualified
	^Tests.ClassToRename.ClassVar1!

refersToClassVariablePartiallyQualifiedBinding
	^#{_.Tests.ClassToRename.ClassVar1} binding!

refersToDolphinTestBindingFullyQualified
	^#{Core.Tests.DolphinTest}!

refersToDolphinTestPartiallyQualifiedBindingMethodNamespace
	<namespace: Core>
	^#{_.Tests.DolphinTest}!

refersToDolphinTestUnqualifiedNameMethodNamespace
	<namespace: Core.Tests>
	^#DolphinTest!

refersToImportedPoolConstantBindingUnqualified
	^#{EINVAL}!

refersToImportedPoolConstantFullyQualified
	^OS.CRTConstants.EINVAL!

refersToImportedPoolConstantUnqualified
	^EINVAL!

refersToOtherClassPartiallyQualifiedBinding
	"Not a valid relative reference to the superclass (does not bind - try sending it #value)"

	^#{_.Tools.ClassToRename}!

refersToOtherClassPartiallyQualifiedName
	"Definitely not a reference. Will not be renamed"

	^#'Tools.ClassToRename'!

refersToOwnClassVariable
	^ClassVar1!

refersToOwnClassVariableUnqualifiedBinding
	^#{ClassVar1} value!

refersToPoolConstantBindingFullyQualified
	^#{OS.Win32Constants.COLOR_DESKTOP}!

refersToPoolConstantFullyQualified
	^OS.Win32Constants.COLOR_DESKTOP!

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

sendsDifferentSuper
	super printString!

sizeCheck
	self isEmpty
		ifFalse: [self do: 
					[:each | 
					Transcript
						show: each;
						cr]]!

smalltalkAssociationAt
	^Smalltalk associationAt: #PoolConstantsDictionary!

smalltalkAssociationAtIfAbsent
	^Smalltalk associationAt: #PoolConstantsDictionary ifAbsent: [self error: 'absent']!

smalltalkAssociationAtIfPresent
	^Smalltalk associationAt: #PoolConstantsDictionary ifPresent: [:pc | pc value name , ' is present']!

smalltalkAtAlias
	^Smalltalk at: #ExternalHandle!

smalltalkAtIfAbsent
	^Smalltalk at: #PoolConstantsDictionary ifAbsent: [self error: 'absent']!

smalltalkAtIfPresent
	^Smalltalk at: #PoolConstantsDictionary ifPresent: [:pc | pc name , ' is present']!

smalltalkAtPut
	^Smalltalk at: #PoolConstantsDictionary put: nil!

smalltalkIncludesKey
	^Smalltalk includesKey: #PoolConstantsDictionary!

smalltalkLookup
	^Smalltalk lookup: #PoolConstantsDictionary!

smalltalkRemoveKey
	^Smalltalk removeKey: #PoolConstantsDictionary!

smalltalkRemoveKeyIfAbsent
	^Smalltalk removeKey: #PoolConstantsDictionary ifAbsent: [self error: 'absent']!

stringConcatenation
	| string |
	string := '' yourself.
	(1 to: 10) do: [:i | string := string , i printString].
	^string!

symbolReference
	^#(#renameThisMethod: #(4 #renameThisMethod:))!

temporaryVariable
	"🐬 method-level comment from temporaryVariable accessor"

	"🐬 another method-level comment from temporaryVariable accessor"

	^temporaryVariable	"🐭 statement-level comment from temporaryVariable accessor"!

temporaryVariable2
	^self temporaryVariable + self temporaryVariable!

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

!Refactory.Browser.TestData.RefactoryTestDataApp categoriesForMethods!
==!comparing!public! !
annotationReference!public!test! !
annotationReferenceTwo!public!test! !
anySatisfy!lint!public! !
asOrderedCollectionNotNeeded!lint!public! !
assignmentInBlock!lint!public! !
assignmentInIfTrue!lint!public! !
atIfAbsent!lint!public! !
badMessage!lint!public! !
booleanPrecedence!lint!public! !
braceArray!lint!public! !
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
inlineTemporary!inline!public! !
inlineWithNamespace!inline!public! !
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
refersToClassBindingNotFound!lint!public! !
refersToClassBindingNotFoundInArray!lint!public! !
refersToClassConstantFullyQualified!lint!public! !
refersToClassConstantPartiallyQualified!lint!public! !
refersToClassConstantPartiallyQualifiedWithNamespace!lint!public! !
refersToClassConstantUnqualified!lint!public! !
refersToClassFullyQualified!lint!public! !
refersToClassFullyQualifiedBinding!lint!public! !
refersToClassFullyQualifiedBindingInArray!lint!public! !
refersToClassFullyQualifiedName!lint!public! !
refersToClassFullyQualifiedNameInArray!lint!public! !
refersToClassPartiallyQualified1!lint!public! !
refersToClassPartiallyQualified2!lint!public! !
refersToClassPartiallyQualifiedBinding1!lint!public! !
refersToClassPartiallyQualifiedBinding2!performing!public! !
refersToClassPartiallyQualifiedBindingInArray!lint!public! !
refersToClassPartiallyQualifiedName!lint!public! !
refersToClassUnqualified!lint!public! !
refersToClassUnqualifiedBinding!lint!public! !
refersToClassUnqualifiedBindingInArray!lint!public! !
refersToClassUnqualifiedInArray!lint!public! !
refersToClassUnqualifiedName!lint!public! !
refersToClassUnqualifiedNameInArray!lint!public! !
refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation!lint!public! !
refersToClassVariableFullyQualified!lint!public! !
refersToClassVariablePartiallyQualified!lint!public! !
refersToClassVariablePartiallyQualifiedBinding!lint!public! !
refersToDolphinTestBindingFullyQualified!lint!public! !
refersToDolphinTestPartiallyQualifiedBindingMethodNamespace!lint!public! !
refersToDolphinTestUnqualifiedNameMethodNamespace!lint!public! !
refersToImportedPoolConstantBindingUnqualified!lint!public! !
refersToImportedPoolConstantFullyQualified!lint!public! !
refersToImportedPoolConstantUnqualified!lint!public! !
refersToOtherClassPartiallyQualifiedBinding!performing!public! !
refersToOtherClassPartiallyQualifiedName!performing!public! !
refersToOwnClassVariable!lint!public! !
refersToOwnClassVariableUnqualifiedBinding!lint!public! !
refersToPoolConstantBindingFullyQualified!lint!public! !
refersToPoolConstantFullyQualified!lint!public! !
release!lint!public! !
rename:two:!public!test! !
renameThisMethod:!public!test! !
returnInEnsure!lint!public! !
returnsBooleanAndOther!lint!public! !
returnsIfTrue!lint!public! !
searchingLiteral!lint!public! !
selectorNotReferenced!public!test! !
sendsDifferentSuper!lint!public! !
sizeCheck!lint!public! !
smalltalkAssociationAt!performing!public! !
smalltalkAssociationAtIfAbsent!performing!public! !
smalltalkAssociationAtIfPresent!performing!public! !
smalltalkAtAlias!performing!public! !
smalltalkAtIfAbsent!performing!public! !
smalltalkAtIfPresent!performing!public! !
smalltalkAtPut!performing!public! !
smalltalkIncludesKey!performing!public! !
smalltalkLookup!performing!public! !
smalltalkRemoveKey!performing!public! !
smalltalkRemoveKeyIfAbsent!performing!public! !
stringConcatenation!lint!public! !
symbolReference!public!test! !
temporaryVariable!accessing!private! !
temporaryVariable2!accessing!private! !
tempsReadBeforeWritten!lint!public! !
tempVarOverridesInstVar!lint!public! !
testFoo:!public!test! !
testMethod!public!test! !
threeElementPoint!lint!public! !
toDo!lint!public! !
toDoCollect!lint!public! !
toDoWithIncrement!lint!public! !
usesAdd!lint!public! !
variableAssignedLiteral!lint!public! !
whileTrue!lint!public! !
yourselfNotUsed!lint!public! !
!

!Refactory.Browser.TestData.RefactoryTestDataApp class methodsFor!

classSideClassVarRefs
	ClassVar2 := {
				ClassVar1.
				AppConst1.
				#{ClassVar1}.
				#{Refactory.Browser.TestData.RefactoryTestDataApp.ClassVar1}.
				#{ClassVar2}.
				#{AppConst1}
			}!

classSideGlobalRef
	^Smalltalk!

comment
	#rbFix.	"Added to test #overridesSpecialMessage"
	^'Test class for Smalllint. Contains lots of smelly code'!

initialize
	ClassVar1 := 'ClassVar1 of RefactoryTestDataApp'.
	ClassVar2 := 'ClassVar2 of RefactoryTestDataApp'.!

refersToClassPartiallyQualified1
	^Tests.ClassToRename! !

!Refactory.Browser.TestData.RefactoryTestDataApp class categoriesForMethods!
classSideClassVarRefs!class initialization!public! !
classSideGlobalRef!class initialization!public! !
comment!accessing!public! !
initialize!class initialization!public! !
refersToClassPartiallyQualified1!lint!public! !
!

