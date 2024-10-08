﻿"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor
	subclass: #'Refactory.Browser.RBReadBeforeWrittenTester'
	instanceVariableNames: 'read checkNewTemps scopeStack'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RBReadBeforeWrittenTester guid: (Core.GUID fromString: '{a344e3a6-5cf4-4eb9-ae6a-990cae954e18}')!

Refactory.Browser.RBReadBeforeWrittenTester comment: ''!

!Refactory.Browser.RBReadBeforeWrittenTester categoriesForClass!Refactory-ParseTree Matching! !

!Refactory.Browser.RBReadBeforeWrittenTester methodsFor!

checkNewTemps: aBoolean 
	checkNewTemps := aBoolean!

copyDictionary: aDictionary
	"We could send aDictionary the copy message, but that doesn't copy the associations."

	| newDictionary |
	newDictionary := Dictionary new: aDictionary size.
	aDictionary 
		keysAndValuesDo: [:key :value | newDictionary at: key put: value].
	^newDictionary!

createScope
	#rbFix.	"Since we're using a LookupTable rather than a dictionary (faster and more memory efficient), a normal #copy will work"
	scopeStack add: scopeStack last copy	"self copyDictionary: "!

currentScope
	^scopeStack last!

executeTree: aParseTree 
	^self visitNode: aParseTree!

initialize
	super initialize.
	scopeStack := OrderedCollection with: LookupTable new.
	read := Set new.
	checkNewTemps := true!

initializeVars: varNames 
	varNames do: [:each | self currentScope at: each put: nil]!

processBlock: aNode 
	| newScope |
	self createScope.
	self executeTree: aNode body.
	newScope := self removeScope.
	newScope keysAndValuesDo: 
			[:key :value | 
			(value == true and: [(self currentScope at: key) isNil]) 
				ifTrue: [self currentScope at: key put: value]]!

processIfTrueIfFalse: aNode 
	| trueScope falseScope |
	self createScope.
	self executeTree: aNode arguments first body.
	trueScope := self removeScope.
	self createScope.
	self executeTree: aNode arguments last body.
	falseScope := self removeScope.
	self currentScope keysAndValuesDo: 
			[:key :value | 
			value isNil 
				ifTrue: 
					[(trueScope at: key) == (falseScope at: key) 
						ifTrue: [self currentScope at: key put: (trueScope at: key)]
						ifFalse: 
							[((trueScope at: key) == true or: [(falseScope at: key) == true]) 
								ifTrue: [self currentScope at: key put: true]]]]!

processStatementNode: aNode 
	| temps |
	(checkNewTemps not or: [aNode temporaries isEmpty]) 
		ifTrue: 
			[aNode statements do: [:each | self executeTree: each].
			^self].
	self createScope.
	temps := aNode temporaries collect: [:each | each name].
	self initializeVars: temps.
	aNode statements do: [:each | self executeTree: each].
	self removeScope keysAndValuesDo: 
			[:key :value | 
			(temps includes: key) 
				ifTrue: [value == true ifTrue: [read add: key]]
				ifFalse: 
					[(self currentScope at: key) isNil 
						ifTrue: [self currentScope at: key put: value]]]!

read
	self currentScope
		keysAndValuesDo: [:key :value | value == true ifTrue: [read add: key]].
	^read!

removeScope
	^scopeStack removeLast!

variableRead: aNode 
	(self currentScope includesKey: aNode name) 
		ifTrue: 
			[(self currentScope at: aNode name) isNil 
				ifTrue: [self currentScope at: aNode name put: true]]!

variableWritten: aNode 
	(self currentScope includesKey: aNode variable name) 
		ifTrue: 
			[(self currentScope at: aNode variable name) isNil 
				ifTrue: [self currentScope at: aNode variable name put: false]]!

visitAssignmentNode: anAssignmentNode
	self visitNode: anAssignmentNode value.
	self variableWritten: anAssignmentNode!

visitMessageNode: aMessageNode
	((#(#whileTrue: #whileFalse: #whileTrue #whileFalse) includes: aMessageNode selector)
		and: [aMessageNode receiver isBlock])
			ifTrue: [self executeTree: aMessageNode receiver body]
			ifFalse: 
				[(aMessageNode isCascaded not or: [aMessageNode isFirstCascaded])
					ifTrue: [self visitNode: aMessageNode receiver]].
	((#(#ifTrue:ifFalse: #ifFalse:ifTrue:) includes: aMessageNode selector)
		and: [aMessageNode arguments allSatisfy: [:each | each isBlock]])
			ifTrue: [^self processIfTrueIfFalse: aMessageNode].
	aMessageNode arguments do: [:each | self visitNode: each]!

visitSequenceNode: aSequenceNode
	self processStatementNode: aSequenceNode!

visitVariableNode: aVariableNode
	self variableRead: aVariableNode! !

!Refactory.Browser.RBReadBeforeWrittenTester categoriesForMethods!
checkNewTemps:!initializing!public! !
copyDictionary:!helpers!private! !
createScope!helpers!private! !
currentScope!accessing!private! !
executeTree:!accessing!public! !
initialize!initializing!public! !
initializeVars:!initializing!public! !
processBlock:!operations!private! !
processIfTrueIfFalse:!operations!private! !
processStatementNode:!operations!private! !
read!accessing!public! !
removeScope!private!removing! !
variableRead:!helpers!private! !
variableWritten:!helpers!private! !
visitAssignmentNode:!public!visitor/double dispatching! !
visitMessageNode:!public!visitor/double dispatching! !
visitSequenceNode:!public!visitor/double dispatching! !
visitVariableNode:!public!visitor/double dispatching! !
!

!Refactory.Browser.RBReadBeforeWrittenTester class methodsFor!

isVariable: aString readBeforeWrittenIn: aBRProgramNode 
	^(self isVariable: aString writtenBeforeReadIn: aBRProgramNode) not!

isVariable: aString writtenBeforeReadIn: aBRProgramNode
	^(self readBeforeWritten: {aString} in: aBRProgramNode) isEmpty!

readBeforeWritten: varNames in: aParseTree 
	^(self new)
		checkNewTemps: false;
		initializeVars: varNames;
		executeTree: aParseTree;
		read!

variablesReadBeforeWrittenIn: aParseTree 
	^(self new)
		executeTree: aParseTree;
		read! !

!Refactory.Browser.RBReadBeforeWrittenTester class categoriesForMethods!
isVariable:readBeforeWrittenIn:!accessing!public! !
isVariable:writtenBeforeReadIn:!accessing!public! !
readBeforeWritten:in:!accessing!public! !
variablesReadBeforeWrittenIn:!accessing!public! !
!

