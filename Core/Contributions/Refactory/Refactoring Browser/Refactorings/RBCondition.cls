"Filed out from Dolphin Smalltalk"!

RBAbstractCondition subclass: #RBCondition
	instanceVariableNames: 'block type errorBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBCondition guid: (GUID fromString: '{af1642b9-45bf-427d-a24f-812c3271820d}')!

RBCondition comment: 'Condition represents a condition that must be true for a refactoring to be performed.

Instance Variables:
	block	<Block>	this is the block that gets evaluated to check the condition
	errorBlock	<Block | nil>	if not nil, this is a block that if the condition fails, will produce some means of browsing the failure (such as opening a browser on the failures)
	type	<Array>		This array holds a symbol identifying the type of condition this is along
						with its parameters. Right now this is pretty useless, other than for printing,
						but in the future, we hope to be able to use this to assert postconditions of
						refactorings.'!

!RBCondition categoriesForClass!Refactory-Conditions! !

!RBCondition methodsFor!

check
	^block value!

errorBlock: anObject
	errorBlock := anObject!

errorBlockFor: aBoolean
	^errorBlock!

printOn: aStream 
	type printOn: aStream!

type: aSymbol block: aBlock errorString: aString 
	type := aSymbol.
	block := aBlock.
	self errorMacro: aString!

withBlock: aBlock 
	block := aBlock.
	type := #(#generic)! !

!RBCondition categoriesForMethods!
check!checking!public! !
errorBlock:!initialize/release!public! !
errorBlockFor:!accessing!public! !
printOn:!printing!public! !
type:block:errorString:!initialize/release!public! !
withBlock:!initialize/release!public! !
!

!RBCondition class methodsFor!

canUnderstand: aSelector in: aClass
	^self new
		type: (Array with: #understandsSelector with: aClass with: aSelector)
		block: [aClass definesMethod: aSelector]
		errorString: aClass printString , ' <1?:does not >understand<1?s:> ' , aSelector printString!

checkClassVarName: aName in: aClass 
	| string |
	aName isString ifFalse: [^false].
	string := aName asString.
	(self reservedNames includes: string) ifTrue: [^false].
	string isEmpty ifTrue: [^false].
	(string first isUppercase or: [string first == $_]) ifFalse: [^false].
	^RBScanner isVariable: string!

checkInstanceVariableName: aName in: aClass 
	| string |
	aName isString ifFalse: [^false].
	string := aName asString.
	string isEmpty ifTrue: [^false].
	(self reservedNames includes: string) ifTrue: [^false].
	string first isUppercase ifTrue: [^false].
	^RBScanner isVariable: string!

checkMethodName: aName in: aClass 
	^aName isString and: [RBScanner isSelector: aName]!

definesClassVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #definesClassVar
				with: aClass
				with: aString)
		block: [aClass definesClassVariable: aString]
		errorString: aClass printString 
				, ' <1?:does not >define<1?s:> class variable ' , aString printString!

definesInstanceVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #definesInstVar
				with: aClass
				with: aString)
		block: [aClass definesInstanceVariable: aString]
		errorString: aClass printString , ' <1?or a superclass :does not >define<1?s:> an instance variable ' 
				, aString printString!

definesSelector: aSelector in: aClass 
	^self new
		type: (Array with: #definesSelector with: aClass with: aSelector)
		block: [aClass directlyDefinesMethod: aSelector]
		errorString: aClass printString , ' <1?:does not >define<1?s:> ' , aSelector printString!

definesTemporaryVariable: aString in: aClass 
	| condition |
	condition := self new.
	condition 
		type: (Array 
				with: #definesTempVar
				with: aClass
				with: aString)
		block: 
			[| method |
			method := self 
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :selector | false].
			method notNil 
				ifTrue: [condition errorMacro: ('<1p> defines variable <2p>' expandMacrosWith: method with: aString)].
			method notNil]
		errorString: aClass printString , ' <1?:does not >define<1?s:> temporary variable ' , aString printString.
	^condition!

definesTempVar: aString in: aClass ignoreClass: subclass 
	| condition |
	condition := self new.
	condition 
		type: (Array 
				with: #definesTempVarIgnoring
				with: aClass
				with: aString
				with: subclass)
		block: 
			[| method |
			method := self 
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :aSelector | class includesClass: subclass].
			method notNil 
				ifTrue: [condition errorMacro: ('<1p> defines variable <2p>' expandMacrosWith: method with: aString)].
			method notNil]
		errorString: aClass printString , ' <1?:does not >define<1?s:> temporary variable ' 
				, aString printString.
	^condition!

directlyDefinesClassVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #directlyDefinesClassVar
				with: aClass
				with: aString)
		block: [aClass directlyDefinesClassVariable: aString]
		errorString: aClass printString , ' <1?:does not >directly define<1?s:> class variable ' 
				, aString printString!

directlyDefinesInstanceVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #directlyDefinesInstanceVariable
				with: aClass
				with: aString)
		block: [aClass directlyDefinesInstanceVariable: aString]
		errorString: aClass printString , ' <1?:does not >directly define<1?s:> instance variable ' 
				, aString printString!

empty
	"Returns an empty condition"

	^self new 
		type: (Array with: #empty)
		block: [true]
		errorString: 'Empty'!

hasSubclasses: aClass 
	^self new 
		type: (Array with: #hasSubclasses with: aClass)
		block: [aClass subclasses notEmpty]
		errorString: aClass printString , ' has <1?:no >subclasses'!

hasSuperclass: aClass 
	^self new 
		type: (Array with: #hasSuperclass with: aClass)
		block: [aClass superclass isNil not]
		errorString: aClass printString , ' has <1?a:no> superclass'!

hierarchyOf: aClass canUnderstand: aSelector
	^self new
		type: (Array with: #hierarchyUnderstandsSelector with: aClass with: aSelector)
		block: [aClass hierarchyDefinesMethod: aSelector]
		errorString: aClass printString , ' <1?or a subclass:and all subclasses do not> understand<1?s:> ' , aSelector printString!

hierarchyOf: aClass definesVariable: aString 
	^self new 
		type: (Array 
				with: #hierarchyDefinesInstVar
				with: aClass
				with: aString)
		block: [aClass hierarchyDefinesVariable: aString]
		errorString: aClass printString 
				, ' or one of its subclasses <1?:does not >define<1?s:> variable ' 
					, aString printString!

hierarchyOf: aClass referencesInstanceVariable: aString 
	^self new 
		type: (Array 
				with: #hierarchyReferencesInstVar
				with: aClass
				with: aString)
		block: 
			[aClass withAllSubclasses 
				anySatisfy: [:each | (each whichSelectorsReferToInstanceVariable: aString) notEmpty]]
		errorString: aClass printString 
				, ' or subclass <1?:does not >reference<1?s:> instance variable ' , aString!

isAbstractClass: aClass 
	^self new 
		type: (Array with: #IsAbstractClass with: aClass)
		block: [aClass isAbstract]
		errorString: aClass printString , ' is <1?:not >an abstract class'!

isClass: anObject
	^self new
		type: (Array with: #IsClass with: anObject)
		block: [anObject isBehavior]
		errorString: anObject printString , ' is <1?:not >a behavior'!

isEmptyClass: anObject 
	^self new type: (Array with: #IsEmptyClass with: anObject)
		block: 
			[anObject classVariableNames isEmpty
				and: [anObject instanceVariableNames isEmpty and: [anObject selectors isEmpty]]]
		errorString: anObject printString , ' is <1?:not > empty'!

isGlobal: aString in: aRBNamespace 
	^self new 
		type: (Array with: #isGlobal with: aString)
		block: [aRBNamespace includesGlobal: aString asSymbol]
		errorString: aString , ' is <1?:not >a class or global variable'!

isImmediateSubclass: subclass of: superClass
	^self new
		type: (Array with: #immediateSubclass with: superClass with: subclass)
		block: [subclass superclass = superClass]
		errorString: subclass printString , ' is <1?:not >an immediate subclass of ' , superClass printString!

isMetaclass: anObject 
	^self new type: (Array with: #IsMetaclass with: anObject)
		block: [anObject isMeta]
		errorString: anObject printString , ' is <1?:not >a metaclass'!

isString: aString
	"added by DMM  Dolphin's categories are *strings* NOT symbols.
	need this for RefactoringBrowserShell>>convertToSibling"

	^self new
		type: (Array with: #isString with: aString)
		block: [aString isString]
		errorString: aString printString, ' is <1?:not >a string'!

isSymbol: aString
	^self new
		type: (Array with: #isSymbol with: aString)
		block: [aString isSymbol]
		errorString: aString , ' is <1?:not >a symbol'!

isValidClassName: aString 
	^self new 
		type: (Array with: #validClassName with: aString)
		block: [self validClassName: aString]
		errorString: aString printString , ' is <1?:not >a valid class name'!

isValidClassVarName: aString for: aClass 
	^self new 
		type: (Array 
				with: #validClassVarName
				with: aString
				with: aClass)
		block: [self checkClassVarName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid class variable name'!

isValidInstanceVariableName: aString for: aClass 
	^self new 
		type: (Array 
				with: #validInstVarName
				with: aString
				with: aClass)
		block: [self checkInstanceVariableName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid instance variable name'!

isValidMethodName: aString for: aClass
	^self new
		type: (Array with: #validMethodName with: aString with: aClass)
		block: [self checkMethodName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid method name'!

isValidTemporaryVariableName: aString for: aClass 
	#rbFix.	"Added"
	^self new 
		type: (Array 
				with: #validTempVarName
				with: aString
				with: aClass)
		block: [self checkInstanceVariableName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid temporary variable name'!

methodDefiningTemporary: aString in: aClass ignore: aBlock 
	| searcher method |
	searcher := ParseTreeSearcher new.
	method := nil.	"Shut-up the warning"
	searcher matches: aString do: [:aNode :answer | ^method].
	aClass withAllSubclasses do: 
			[:class | 
			class selectors do: 
					[:each | 
					(aBlock value: class value: each) 
						ifFalse: 
							[| parseTree |
							method := class methodFor: each.
							parseTree := class parseTreeFor: each.
							parseTree notNil ifTrue: [searcher executeTree: parseTree]]]].
	^nil!

referencesInstanceVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #referencesInstVar
				with: aClass
				with: aString)
		block: [(aClass whichSelectorsReferToInstanceVariable: aString) notEmpty]
		errorString: aClass printString , ' <1?:does not >reference<1?s:> instance variable ' 
				, aString printString!

reservedNames
	^#('self' 'true' 'false' 'nil' 'thisContext' 'super')!

subclassesOf: aClass referToSelector: aSelector 
	^self new 
		type: (Array 
				with: #subclassReferences
				with: aClass
				with: aSelector)
		block: 
			[aClass subclasses anySatisfy: 
					[:each | 
					each selectors anySatisfy: 
							[:sel | 
							| tree |
							tree := each parseTreeFor: sel.
							tree notNil and: [tree superMessages includes: aSelector]]]]
		errorString: '<1?:no:a> subclass of ' , aClass printString , ' refers to ' 
				, aSelector printString!

validClassName: aString 
	"Class names and class variable names have the same restrictions"

	^self checkClassVarName: aString in: self!

withBlock: aBlock
	^self new withBlock: aBlock!

withBlock: aBlock errorString: aString 
	^self new type: #unknown
		block: aBlock
		errorString: aString! !

!RBCondition class categoriesForMethods!
canUnderstand:in:!instance creation!public! !
checkClassVarName:in:!public!utilities! !
checkInstanceVariableName:in:!public!utilities! !
checkMethodName:in:!public!utilities! !
definesClassVariable:in:!instance creation!public! !
definesInstanceVariable:in:!instance creation!public! !
definesSelector:in:!instance creation!public! !
definesTemporaryVariable:in:!instance creation!public! !
definesTempVar:in:ignoreClass:!instance creation!public! !
directlyDefinesClassVariable:in:!instance creation!public! !
directlyDefinesInstanceVariable:in:!instance creation!public! !
empty!instance creation!public! !
hasSubclasses:!instance creation!public! !
hasSuperclass:!instance creation!public! !
hierarchyOf:canUnderstand:!instance creation!public! !
hierarchyOf:definesVariable:!instance creation!public! !
hierarchyOf:referencesInstanceVariable:!instance creation!public! !
isAbstractClass:!instance creation!public! !
isClass:!instance creation!public! !
isEmptyClass:!instance creation!public! !
isGlobal:in:!instance creation!public! !
isImmediateSubclass:of:!instance creation!public! !
isMetaclass:!instance creation!public! !
isString:!instance creation!public! !
isSymbol:!instance creation!public! !
isValidClassName:!instance creation!public! !
isValidClassVarName:for:!instance creation!public! !
isValidInstanceVariableName:for:!instance creation!public! !
isValidMethodName:for:!instance creation!public! !
isValidTemporaryVariableName:for:!instance creation!public! !
methodDefiningTemporary:in:ignore:!public!utilities! !
referencesInstanceVariable:in:!instance creation!public! !
reservedNames!public!utilities! !
subclassesOf:referToSelector:!instance creation!public! !
validClassName:!public!utilities! !
withBlock:!instance creation!public! !
withBlock:errorString:!instance creation!public! !
!

