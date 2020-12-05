"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBAbstractCondition subclass: #'Refactory.Browser.RBCondition'
	instanceVariableNames: 'block type errorBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBCondition guid: (Core.GUID fromString: '{af1642b9-45bf-427d-a24f-812c3271820d}')!
Refactory.Browser.RBCondition comment: 'Condition represents a condition that must be true for a refactoring to be performed.

Instance Variables:
	block	<Block>	this is the block that gets evaluated to check the condition
	errorBlock	<Block | nil>	if not nil, this is a block that if the condition fails, will produce some means of browsing the failure (such as opening a browser on the failures)
	type	<Array>		This array holds a symbol identifying the type of condition this is along
						with its parameters. Right now this is pretty useless, other than for printing,
						but in the future, we hope to be able to use this to assert postconditions of
						refactorings.'!
!Refactory.Browser.RBCondition categoriesForClass!Refactory-Conditions! !
!Refactory.Browser.RBCondition methodsFor!

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
!Refactory.Browser.RBCondition categoriesFor: #check!checking!public! !
!Refactory.Browser.RBCondition categoriesFor: #errorBlock:!initialize/release!public! !
!Refactory.Browser.RBCondition categoriesFor: #errorBlockFor:!accessing!public! !
!Refactory.Browser.RBCondition categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RBCondition categoriesFor: #type:block:errorString:!initialize/release!public! !
!Refactory.Browser.RBCondition categoriesFor: #withBlock:!initialize/release!public! !

!Refactory.Browser.RBCondition class methodsFor!

canUnderstand: aSelector in: aClass
	^self new
		type: {#understandsSelector. aClass. aSelector}
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
		type: {#definesClassVar. aClass. aString}
		block: [aClass definesClassVariable: aString]
		errorString: aClass printString , ' <1?:does not >define<1?s:> class variable ' , aString printString!

definesInstanceVariable: aString in: aClass
	^self new
		type: {#definesInstVar. aClass. aString}
		block: [aClass definesInstanceVariable: aString]
		errorString: aClass printString , ' <1?or a superclass :does not >define<1?s:> an instance variable '
				, aString printString!

definesSelector: aSelector in: aClass
	^self new
		type: {#definesSelector. aClass. aSelector}
		block: [aClass directlyDefinesMethod: aSelector]
		errorString: aClass printString , ' <1?:does not >define<1?s:> ' , aSelector printString!

definesTemporaryVariable: aString in: aClass
	| condition |
	condition := self new.
	condition
		type: {#definesTempVar. aClass. aString}
		block: 
			[| method |
			method := self
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :selector | false].
			method notNil
				ifTrue: [condition errorMacro: ('<1p> defines variable <2p>' expandMacrosWith: method with: aString)].
			method notNil]
		errorString: aClass printString , ' <1?:does not >define<1?s:> temporary variable '
				, aString printString.
	^condition!

definesTempVar: aString in: aClass ignoreClass: subclass
	| condition |
	condition := self new.
	condition
		type: {#definesTempVarIgnoring. aClass. aString. subclass}
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
		type: {#directlyDefinesClassVar. aClass. aString}
		block: [aClass directlyDefinesClassVariable: aString]
		errorString: aClass printString , ' <1?:does not >directly define<1?s:> class variable '
				, aString printString!

directlyDefinesInstanceVariable: aString in: aClass
	^self new
		type: {#directlyDefinesInstanceVariable. aClass. aString}
		block: [aClass directlyDefinesInstanceVariable: aString]
		errorString: aClass printString , ' <1?:does not >directly define<1?s:> instance variable '
				, aString printString!

empty
	"Returns an empty condition"

	^self new
		type: {#empty}
		block: [true]
		errorString: 'Empty'!

hasNamespace: aSymbol
	^self new
		type: {#hasNamespace. aSymbol}
		block: [aSymbol asQualifiedReference namespaceBinding notNil]
		errorString: aSymbol , ' is <1?:not >in an existing namespace'!

hasSubclasses: aClass
	^self new
		type: {#hasSubclasses. aClass}
		block: [aClass subclasses notEmpty]
		errorString: aClass printString , ' has <1?:no >subclasses'!

hasSuperclass: aClass
	^self new
		type: {#hasSuperclass. aClass}
		block: [aClass superclass isNil not]
		errorString: aClass printString , ' has <1?a:no> superclass'!

hierarchyOf: aClass canUnderstand: aSelector
	^self new
		type: {#hierarchyUnderstandsSelector. aClass. aSelector}
		block: [aClass hierarchyDefinesMethod: aSelector]
		errorString: aClass printString , ' <1?or a subclass:and all subclasses do not> understand<1?s:> '
				, aSelector printString!

hierarchyOf: aClass definesVariable: aString
	^self new
		type: {#hierarchyDefinesInstVar. aClass. aString}
		block: [aClass hierarchyDefinesVariable: aString]
		errorString: aClass printString , ' or one of its subclasses <1?:does not >define<1?s:> variable '
				, aString printString!

hierarchyOf: aClass referencesInstanceVariable: aString
	^self new
		type: {#hierarchyReferencesInstVar. aClass. aString}
		block: 
			[aClass withAllSubclasses
				anySatisfy: [:each | (each whichSelectorsReferToInstanceVariable: aString) notEmpty]]
		errorString: aClass printString , ' or subclass <1?:does not >reference<1?s:> instance variable '
				, aString!

isAbstractClass: aClass
	^self new
		type: {#IsAbstractClass. aClass}
		block: [aClass isAbstract]
		errorString: aClass printString , ' is <1?:not >an abstract class'!

isClass: anObject
	^self new
		type: {#IsClass. anObject}
		block: [anObject isBehavior]
		errorString: anObject printString , ' is <1?:not >a behavior'!

isEmptyClass: anObject
	^self new
		type: {#IsEmptyClass. anObject}
		block: 
			[anObject classVariableNames isEmpty
				and: [anObject instanceVariableNames isEmpty and: [anObject selectors isEmpty]]]
		errorString: anObject printString , ' is <1?:not > empty'!

isGlobal: aString in: aRBNamespace 
	^self new 
		type: {#isGlobal. aString}
		block: [aRBNamespace includesGlobal: aString asSymbol]
		errorString: aString , ' is <1?:not >a class or global variable'!

isImmediateSubclass: subclass of: superClass
	^self new
		type: {#immediateSubclass. superClass. subclass}
		block: [subclass superclass = superClass]
		errorString: subclass printString , ' is <1?:not >an immediate subclass of ' , superClass printString!

isMetaclass: anObject
	^self new
		type: {#IsMetaclass. anObject}
		block: [anObject isMeta]
		errorString: anObject printString , ' is <1?:not >a metaclass'!

isNamespace: aSymbol
	^self new
		type: {#isNamespace. aSymbol}
		block: [aSymbol asQualifiedReference namespaceBinding isNil]
		errorString: aSymbol , ' is <1?:not >a namespace'!

isString: aString
	"added by DMM  Dolphin's categories are *strings* NOT symbols.
	need this for RefactoringBrowserShell>>convertToSibling"

	^self new
		type: {#isString. aString}
		block: [aString isString]
		errorString: aString printString , ' is <1?:not >a string'!

isSymbol: aString
	^self new
		type: {#isSymbol. aString}
		block: [aString isSymbol]
		errorString: aString , ' is <1?:not >a symbol'!

isValidClassName: aString
	^self new
		type: {#validClassName. aString}
		block: [self validClassName: aString]
		errorString: aString printString , ' is <1?:not >a valid class name'!

isValidClassVarName: aString for: aClass
	^self new
		type: {#validClassVarName. aString. aClass}
		block: [self checkClassVarName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid class variable name'!

isValidInstanceVariableName: aString for: aClass
	^self new
		type: {#validInstVarName. aString. aClass}
		block: [self checkInstanceVariableName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid instance variable name'!

isValidMethodName: aString for: aClass
	^self new
		type: {#validMethodName. aString. aClass}
		block: [self checkMethodName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid method name'!

isValidTemporaryVariableName: aString for: aClass
	#rbFix.	"Added"
	^self new
		type: {#validTempVarName. aString. aClass}
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
		type: {#referencesInstVar. aClass. aString}
		block: [(aClass whichSelectorsReferToInstanceVariable: aString) notEmpty]
		errorString: aClass printString , ' <1?:does not >reference<1?s:> instance variable '
				, aString printString!

reservedNames
	^#('self' 'true' 'false' 'nil' 'thisContext' 'super')!

subclassesOf: aClass referToSelector: aSelector
	^self new
		type: {#subclassReferences. aClass. aSelector}
		block: 
			[aClass subclasses anySatisfy: 
					[:each |
					each selectors anySatisfy: 
							[:sel |
							| tree |
							tree := each parseTreeFor: sel.
							tree notNil and: [tree superMessages includes: aSelector]]]]
		errorString: '<1?:no:a> subclass of ' , aClass printString , ' refers to ' , aSelector printString!

validClassName: aString 
	"Class names and class variable names have the same restrictions"

	^self checkClassVarName: aString in: self!

withBlock: aBlock
	^self new withBlock: aBlock!

withBlock: aBlock errorString: aString 
	^self new type: #unknown
		block: aBlock
		errorString: aString! !
!Refactory.Browser.RBCondition class categoriesFor: #canUnderstand:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #checkClassVarName:in:!public!utilities! !
!Refactory.Browser.RBCondition class categoriesFor: #checkInstanceVariableName:in:!public!utilities! !
!Refactory.Browser.RBCondition class categoriesFor: #checkMethodName:in:!public!utilities! !
!Refactory.Browser.RBCondition class categoriesFor: #definesClassVariable:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #definesInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #definesSelector:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #definesTemporaryVariable:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #definesTempVar:in:ignoreClass:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #directlyDefinesClassVariable:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #directlyDefinesInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #empty!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #hasNamespace:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #hasSubclasses:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #hasSuperclass:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #hierarchyOf:canUnderstand:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #hierarchyOf:definesVariable:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #hierarchyOf:referencesInstanceVariable:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isAbstractClass:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isClass:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isEmptyClass:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isGlobal:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isImmediateSubclass:of:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isMetaclass:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isNamespace:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isString:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isSymbol:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isValidClassName:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isValidClassVarName:for:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isValidInstanceVariableName:for:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isValidMethodName:for:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #isValidTemporaryVariableName:for:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #methodDefiningTemporary:in:ignore:!public!utilities! !
!Refactory.Browser.RBCondition class categoriesFor: #referencesInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #reservedNames!public!utilities! !
!Refactory.Browser.RBCondition class categoriesFor: #subclassesOf:referToSelector:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #validClassName:!public!utilities! !
!Refactory.Browser.RBCondition class categoriesFor: #withBlock:!instance creation!public! !
!Refactory.Browser.RBCondition class categoriesFor: #withBlock:errorString:!instance creation!public! !

