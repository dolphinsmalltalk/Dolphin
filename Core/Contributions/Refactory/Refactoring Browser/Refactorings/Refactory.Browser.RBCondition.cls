"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractCondition
	subclass: #'Refactory.Browser.RBCondition'
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

type: aSymbol block: aBlock errorString: aStringOrValuable 
	type := aSymbol.
	block := aBlock.
	self errorMacro: aStringOrValuable!

withBlock: aBlock 
	block := aBlock.
	type := #(#generic)! !
!Refactory.Browser.RBCondition categoriesForMethods!
check!checking!public! !
errorBlock:!initialize/release!public! !
errorBlockFor:!accessing!public! !
printOn:!printing!public! !
type:block:errorString:!initialize/release!public! !
withBlock:!initialize/release!public! !
!

!Refactory.Browser.RBCondition class methodsFor!

canUnderstand: aSelector in: aClass
	^self new
		type: {#understandsSelector. aClass. aSelector}
		block: [aClass definesMethod: aSelector]
		errorString: aClass unqualifiedName , ' <1?:does not >understand<1?s:> ' , aSelector printString!

checkClassVarName: aName
	| string |
	aName isString ifFalse: [^false].
	string := aName asString.
	(self reservedNames includes: string) ifTrue: [^false].
	string isEmpty ifTrue: [^false].
	(string first isUppercase or: [string first == $_]) ifFalse: [^false].
	^Scanner isVariable: string!

checkInstanceVariableName: aName
	| string |
	aName isString ifFalse: [^false].
	string := aName asString.
	string isEmpty ifTrue: [^false].
	(self reservedNames includes: string) ifTrue: [^false].
	string first isUppercase ifTrue: [^false].
	^Scanner isVariable: string!

checkMethodName: aName
	^aName isString and: [Scanner isSelector: aName]!

definesClassVariable: aString in: aClass
	^self new
		type: {#definesClassVar. aClass. aString}
		block: [aClass definesClassVariable: aString]
		errorString: [aClass name , ' <1?:does not >define<1?s:> class variable/constant '
				, aString printString]!

definesInstanceVariable: aString in: aClass
	^self new
		type: { #definesInstVar. aClass. aString }
		block: [aClass definesInstanceVariable: aString]
		errorString: 
			[aClass unqualifiedName , ' <1?or a superclass :does not >define<1?s:> an instance variable '
				, aString printString]!

definesSelector: aSelector in: aClass
	^self new
		type: {#definesSelector. aClass. aSelector}
		block: [aClass directlyDefinesMethod: aSelector]
		errorString: [aClass unqualifiedName , ' <1?:does not >define<1?s:> ' , aSelector printString]!

definesStaticVariable: aString in: aClass
	^self new
		type: {#definesStaticVar. aClass. aString}
		block: [aClass definesStaticVariable: aString]
		errorString: [aClass instanceClass name , ' <1?:does not >define<1?s:> static variable '
				, aString printString]!

definesTemporaryVariable: aString in: aClass
	| condition |
	condition := self new.
	condition
		type: { #definesTempVar. aClass. aString }
		block: 
			[| method |
			method := self
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :selector | false].
			method notNil
				ifTrue: [condition errorMacro: ('<1p> defines variable <2p>' expandMacrosWith: method with: aString)].
			method notNil]
		errorString: 
			[aClass unqualifiedName , ' <1?:does not >define<1?s:> temporary variable ' , aString printString].
	^condition!

definesTempVar: aString in: aClass ignoreClass: subclass
	| condition |
	condition := self new.
	condition
		type: { #definesTempVarIgnoring. aClass. aString. subclass }
		block: 
			[| method |
			method := self
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :aSelector | class includesClass: subclass].
			method notNil
				ifTrue: [condition errorMacro: ('<1p> defines variable <2p>' expandMacrosWith: method with: aString)].
			method notNil]
		errorString: 
			[aClass unqualifiedName , ' <1?:does not >define<1?s:> temporary variable ' , aString printString].
	^condition!

directlyDefinesClassVariable: aString in: aClass
	^self new
		type: { #directlyDefinesClassVar. aClass. aString }
		block: [aClass directlyDefinesClassVariable: aString]
		errorString: 
			[aClass unqualifiedName , ' <1?:does not >directly define<1?s:> class variable '
				, aString printString]!

directlyDefinesInstanceVariable: aString in: aClass
	^self new
		type: { #directlyDefinesInstanceVariable. aClass. aString }
		block: [aClass directlyDefinesInstanceVariable: aString]
		errorString: 
			[aClass unqualifiedName , ' <1?:does not >directly define<1?s:> instance variable '
				, aString printString]!

empty
	"Returns an empty condition"

	^RBEmptyCondition.Current!

hasNamespace: aSymbol
	^self new
		type: {#hasNamespace. aSymbol}
		block: [aSymbol asQualifiedReference namespaceBinding notNil]
		errorString: aSymbol , ' is <1?:not >in an existing namespace'!

hasSubclasses: aClass excluding: aCollection
	^self new
		type: {#hasSubclasses. aClass}
		block: [aClass subclasses anySatisfy: [:each | (aCollection includes: each name) not]]
		errorString: aClass unqualifiedName , ' has <1?:no >subclasses'!

hasSuperclass: aClass
	^self new
		type: {#hasSuperclass. aClass}
		block: [aClass superclass isNil not]
		errorString: aClass unqualifiedName , ' has <1?a:no> superclass'!

hierarchyOf: aClass canUnderstand: aSelector
	^self new
		type: {#hierarchyUnderstandsSelector. aClass. aSelector}
		block: [aClass hierarchyDefinesMethod: aSelector]
		errorString: [aClass unqualifiedName , ' <1?or a subclass:and all subclasses do not> understand<1?s:> '
				, aSelector printString]!

hierarchyOf: aClass definesVariable: aString
	^self new
		type: {#hierarchyDefinesInstVar. aClass. aString}
		block: [aClass hierarchyDefinesVariable: aString]
		errorString: [aClass unqualifiedName
				, ' or one of its subclasses <1?:does not >define<1?s:> variable ' , aString printString]!

hierarchyOf: aClass referencesInstanceVariable: aString
	^self new
		type: { #hierarchyReferencesInstVar. aClass. aString }
		block: 
			[aClass withAllSubclasses
				anySatisfy: [:each | (each whichSelectorsReferToInstanceVariable: aString) notEmpty]]
		errorString: 
			[aClass unqualifiedName , ' or subclass <1?:does not >reference<1?s:> instance variable ' , aString]!

isAbstractClass: aClass
	^self new
		type: {#IsAbstractClass. aClass}
		block: [aClass isAbstract]
		errorString: aClass unqualifiedName , ' is <1?:not >an abstract class'!

isBoundParseTree: aRBProgramNode
	^self new
		type: {#isBoundParseTree. aRBProgramNode}
		block: [aRBProgramNode scope notNil]
		errorString: 'Parse tree is <1?:not >bound'!

isClass: anObject
	^self new
		type: {#IsClass. anObject}
		block: [anObject isBehavior]
		errorString: [anObject printString , ' is <1?:not >a behavior']!

isClassBinding: aBindingReference
	^self new
		type: {#isDefined. aBindingReference}
		block: 
			[| binding |
			binding := aBindingReference bindingOrNil.
			binding notNil and: [binding isClassBinding]]
		errorString: [aBindingReference printString , ' <1?refers:does not refer> to a defined class binding']!

isDefinedBinding: aBindingReference
	^self new
		type: {#isDefined. aBindingReference}
		block: [aBindingReference isDefined]
		errorString: [aBindingReference printString , ' is <1?already:not> defined']!

isEmptyClass: anObject
	^self new
		type: {#IsEmptyClass. anObject}
		block: 
			[anObject classPool isEmpty
				and: [anObject instanceVariableNames isEmpty and: [anObject selectors isEmpty]]]
		errorString: 
			[| stream hasMethods hasClassVars hasInstVars |
			stream := String writeStream.
			stream
				print: anObject;
				nextPutAll: ' is <1?:not >empty (has <1?no variables or methods):'.
			hasMethods := anObject selectors notEmpty.
			hasClassVars := anObject classPool notEmpty.
			hasClassVars ifTrue: [stream nextPutAll: 'class/shared variables'].
			hasInstVars := anObject instanceVariableNames notEmpty.
			hasInstVars
				ifTrue: 
					[hasClassVars
						ifTrue: 
							[stream nextPutAll: ', '.
							hasMethods ifFalse: [stream nextPutAll: 'and ']].
					stream nextPutAll: 'instance variables'].
			hasMethods
				ifTrue: 
					[(hasClassVars or: [hasInstVars]) ifTrue: [stream nextPutAll: ', and '].
					stream nextPutAll: 'methods'].
			stream
				nextPut: $);
				contents]!

isImmediateSubclass: subclass of: superClass
	^self new
		type: {#immediateSubclass. superClass. subclass}
		block: [subclass superclass = superClass]
		errorString: [subclass printString , ' is <1?:not >an immediate subclass of ' , superClass printString]!

isMetaclass: anObject
	^self new
		type: {#IsMetaclass. anObject}
		block: [anObject isMeta]
		errorString: anObject unqualifiedName , ' is <1?:not >a metaclass'!

isNamespace: aSymbol
	^self new
		type: {#isNamespace. aSymbol}
		block: [aSymbol asQualifiedReference namespaceBinding isNil]
		errorString: aSymbol , ' is <1?:not >a namespace'!

isStatic: aString in: aRBModel
	^self new
		type: {#isGlobal. aString}
		block: [aRBModel definesStaticVariable: aString]
		errorString: aString , ' is <1?:not >an existing class or static variable'!

isString: aString
	"added by DMM  Dolphin's categories are *strings* NOT symbols.
	need this for RefactoringBrowserShell>>convertToSibling"

	^self new
		type: {#isString. aString}
		block: [aString isString]
		errorString: [aString printString , ' is <1?:not >a string']!

isSubclassable: aClass
	^self new
		type: { #isSubclassable. aClass }
		block: [aClass isNil or: [(ClassBuilder.Unsubclassable includes: aClass fullyQualifiedReference) not]]
		errorString: aClass unqualifiedName , ' is <1?:not >subclassable.'!

isSymbol: aString
	^self new
		type: {#isSymbol. aString}
		block: [aString isSymbol]
		errorString: aString , ' is <1?:not >a symbol'!

isValidClassName: aString
	^self new
		type: { #validClassName. aString }
		block: [self validClassName: aString]
		errorString: [ClassBuilder.ErrorInvalidClassName << aString]!

isValidClassVarName: aString
	^self new
		type: { #validClassVarName. aString }
		block: [self checkClassVarName: aString]
		errorString: [aString printString , ' is <1?:not >a valid class variable name']!

isValidInstanceVariableName: aString
	^self new
		type: { #validInstVarName. aString }
		block: [self checkInstanceVariableName: aString]
		errorString: [ClassBuilder.ErrorInvalidInstVarName << aString]!

isValidMethodName: aString
	^self new
		type: {#validMethodName. aString}
		block: [self checkMethodName: aString]
		errorString: [aString printString , ' is <1?:not >a valid method name']!

isValidTemporaryVariableName: aString
	#rbFix.	"Added"
	^self new
		type: { #validTempVarName. aString }
		block: [self checkInstanceVariableName: aString]
		errorString: [aString printString , ' is <1?:not >a valid temporary variable name']!

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
		type: { #referencesInstVar. aClass. aString }
		block: [(aClass whichSelectorsReferToInstanceVariable: aString) notEmpty]
		errorString: 
			[aClass unqualifiedName , ' <1?:does not >reference<1?s:> instance variable ' , aString printString]!

reservedNames
	^#('self' 'true' 'false' 'nil' 'thisContext' 'super')!

subclassesOf: aClass referToSelector: aSelector
	^self new
		type: { #subclassReferences. aClass. aSelector }
		block: 
			[aClass subclasses anySatisfy: 
					[:each |
					each selectors anySatisfy: 
							[:sel |
							| tree |
							tree := each parseTreeFor: sel.
							tree notNil and: [tree superMessages includes: aSelector]]]]
		errorString: 
			['<1?:no:a> subclass of ' , aClass unqualifiedName , ' refers to ' , aSelector printString]!

validClassName: aString
	"Class names and class variable names have the same restrictions"

	^self checkClassVarName: aString!

withBlock: aBlock
	^self new withBlock: aBlock!

withBlock: aBlock errorString: aStringOrValuable 
	^self new type: #unknown
		block: aBlock
		errorString: aStringOrValuable! !
!Refactory.Browser.RBCondition class categoriesForMethods!
canUnderstand:in:!instance creation!public! !
checkClassVarName:!private!utilities! !
checkInstanceVariableName:!public!utilities! !
checkMethodName:!public!utilities! !
definesClassVariable:in:!instance creation!public! !
definesInstanceVariable:in:!instance creation!public! !
definesSelector:in:!instance creation!public! !
definesStaticVariable:in:!instance creation!public! !
definesTemporaryVariable:in:!instance creation!public! !
definesTempVar:in:ignoreClass:!instance creation!public! !
directlyDefinesClassVariable:in:!instance creation!public! !
directlyDefinesInstanceVariable:in:!instance creation!public! !
empty!instance creation!public! !
hasNamespace:!instance creation!public! !
hasSubclasses:excluding:!instance creation!public! !
hasSuperclass:!instance creation!public! !
hierarchyOf:canUnderstand:!instance creation!public! !
hierarchyOf:definesVariable:!instance creation!public! !
hierarchyOf:referencesInstanceVariable:!instance creation!public! !
isAbstractClass:!instance creation!public! !
isBoundParseTree:!instance creation!public! !
isClass:!instance creation!public! !
isClassBinding:!instance creation!public! !
isDefinedBinding:!instance creation!public! !
isEmptyClass:!instance creation!public! !
isImmediateSubclass:of:!instance creation!public! !
isMetaclass:!instance creation!public! !
isNamespace:!instance creation!public! !
isStatic:in:!instance creation!public! !
isString:!instance creation!public! !
isSubclassable:!instance creation!public! !
isSymbol:!instance creation!public! !
isValidClassName:!instance creation!public! !
isValidClassVarName:!instance creation!public! !
isValidInstanceVariableName:!instance creation!public! !
isValidMethodName:!instance creation!public! !
isValidTemporaryVariableName:!instance creation!public! !
methodDefiningTemporary:in:ignore:!private!utilities! !
referencesInstanceVariable:in:!instance creation!public! !
reservedNames!public!utilities! !
subclassesOf:referToSelector:!instance creation!public! !
validClassName:!public!utilities! !
withBlock:!instance creation!public! !
withBlock:errorString:!instance creation!public! !
!

