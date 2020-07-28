"Filed out from Dolphin Smalltalk 7"!

LintRule subclass: #TransformationRule
	instanceVariableNames: 'rewriteRule changes class'
	classVariableNames: 'RecursiveSelfRule'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TransformationRule guid: (GUID fromString: '{9864c788-a659-4ced-8264-c32a2b4327ec}')!
TransformationRule comment: 'TransformationRule is a LintRule that transforms code using rewrite rules.

Instance Variables:
	builder	<RefactoryBuilder>	the changes we''ve made
	class	<Behavior>	the class we''re looking at currently (only needed so we don''t have to pass the class around)
	rewriteRule	<ParseTreeRewriter>	the rule we''re replacing the code with

Class Variables:
	RecursiveSelfRule	<ParseTreeSearcher>	a rule that checks our rewrites so we don''t make directly recursive methods (e.g., "foo ^self foo")

'!
!TransformationRule categoriesForClass!Refactory-Lint! !
!TransformationRule methodsFor!

changes
	^changes!

checkMethod: aSmalllintContext 
	(rewriteRule canMatchMethod: aSmalllintContext compiledMethod) ifFalse: [^self].
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) 
		ifTrue: 
			[(self class recursiveSelfRule executeTree: rewriteRule tree initialAnswer: false) 
				ifFalse: 
					[changes 
						compile: rewriteRule tree fullPrintString
						in: class
						classified: aSmalllintContext protocols]]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self name!

hasConflicts
	^true!

isEmpty
	^changes changes isEmpty!

problemCount
	^changes problemCount!

resetResult
	changes := CompositeRefactoryChange named: self name!

rewriteUsing: searchReplacer 
	rewriteRule := searchReplacer.
	self resetResult!

superSends
	| rule |
	rule := ParseTreeRewriter new.
	rule 
		replace: 'super `@message: ``@args'
		with: 'self `@message: ``@args'
		when: 
			[:aNode | 
			class withAllSubclasses allSatisfy: [:each | (each includesSelector: aNode selector) not]].
	self rewriteUsing: rule!

viewResults
	"I reset the result so that we don't fill up memory with methods to compile in the builder."

	changes inspect.
	self resetResult! !
!TransformationRule categoriesFor: #changes!accessing!public! !
!TransformationRule categoriesFor: #checkMethod:!accessing!public! !
!TransformationRule categoriesFor: #displayOn:!printing!public! !
!TransformationRule categoriesFor: #hasConflicts!public!testing! !
!TransformationRule categoriesFor: #isEmpty!public!testing! !
!TransformationRule categoriesFor: #problemCount!accessing!public! !
!TransformationRule categoriesFor: #resetResult!accessing!public! !
!TransformationRule categoriesFor: #rewriteUsing:!initialize/release!public! !
!TransformationRule categoriesFor: #superSends!public!rules! !
!TransformationRule categoriesFor: #viewResults!private! !

!TransformationRule class methodsFor!

assignmentInIfTrue
	^self rewrite: #(
			#('``@Boolean ifTrue: [`variable := ``@true] ifFalse: [`variable := ``@false]'
			"->"
			'`variable := ``@Boolean ifTrue: [``@true] ifFalse: [``@false]')
			#('``@Boolean ifFalse: [`variable := ``@true] ifTrue: [`variable := ``@false]'
			"->"
			'`variable := ``@Boolean ifFalse: [``@true] ifTrue: [``@false]'))
		methods: false
		name: 'Move variable assignment outside of single statement ifTrue:ifFalse: blocks'!

atIfAbsent
	^self rewrite: #(
			#('``@dictionary at: ``@key 
					ifAbsent: [| `@temps | 
							``@.Statements1.
							``@dictionary at: ``@key put: ``@object.
							``@.Statements2.
							``@object]'
			"->"
			'``@dictionary at: ``@key
					ifAbsentPut: [| `@temps |
							``@.Statements1.
							``@.Statements2.
							``@object]')
			#('``@dictionary at: ``@key
					ifAbsent: [| `@temps |
							``@.Statements.
							``@dictionary at: ``@key put: ``@object]'
			"->"
			'``@dictionary at: ``@key
					ifAbsentPut: [| `@temps |
							``@.Statements.
							``@object]'))
		methods: false
		name: 'at:ifAbsent: -> at:ifAbsentPut:'!

betweenAnd
	^self rewrite: #(
			#('``@a >= ``@b and: [``@a <= ``@c]' "->" '``@a between: ``@b and: ``@c')
			#('``@a >= ``@b & (``@a <= ``@c)' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a and: [``@a <= ``@c]' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a & (``@a <= ``@c)' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c and: [``@a >= ``@b]' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c & (``@a >= ``@b)' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a and: [``@a >= ``@b]' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a & (``@a >= ``@b)' "->" '``@a between: ``@b and: ``@c')
			#('``@a >= ``@b and: [``@c >= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@a >= ``@b & (``@c >= ``@a)' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a and: [``@c >= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a & (``@c >= ``@a)' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c and: [``@b <= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c & (``@b <= ``@a)' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a and: [``@b <= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a & (``@b <= ``@a)' "->" '``@a between: ``@b and: ``@c'))
		methods: false
		name: '"a >= b and: [a <= c]" -> "a between: b and: c"'!

braceArrays
	^self rewrite: #(
			#('Array with: ``@arg'
			"->"
			'{``@arg}')
			#('Array with: ``@arg1 with: ``@arg2'
			"->"
			'{``@arg1. ``@arg2}')
			#('Array with: ``@arg1 with: ``@arg2 with: ``@arg3'
			"->"
			'{``@arg1. ``@arg2. ``@arg3}')
			#('Array with: ``@arg1 with: ``@arg2 with: ``@arg3 with: ``@arg4'
			"->"
			'{``@arg1. ``@arg2. ``@arg3. ``@arg4}')
			#('Array with: ``@arg1 with: ``@arg2 with: ``@arg3 with: ``@arg4 with: ``@arg5'
			"->"
			'{``@arg1. ``@arg2. ``@arg3. ``@arg4. ``@arg5}'))
		methods: false
		name: 'Replace Array class>>with:+ with brace arrays'!

cascadedNextPutAlls
	^self
		rewrite: #(
			#('``@rcvr nextPutAll: ``@object1 , ``@object2'
					"->"
				'``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2')
			#('``@rcvr show: ``@object1 , ``@object2'
					"->"
				'``@rcvr show: ``@object1; show: ``@object2'))
		methods: false
		name: 'Use cascaded nextPutAll:''s instead of #, in #nextPutAll:'!

detectIfNone
	^self rewrite: #(
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) isNil'
				"->"	'(``@collection anySatisfy: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) = nil'
				"->"	'(``@collection anySatisfy: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) == nil'
				"->"	'(``@collection anySatisfy: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) notNil'
				"->"	'``@collection anySatisfy: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~= nil'
				"->"	'``@collection anySatisfy: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~~ nil'
				"->"	'``@collection anySatisfy: [:`each | | `@temps | ``@.Statements]'))
		methods: false
		name: 'detect:ifNone: -> anySatisfy:'!

equalNil
	^self
		rewrite: #(
			#('``@object = nil'	"->"	'``@object isNil') 
			#('``@object == nil'	"->"	'``@object isNil') 
			#('``@object ~= nil'	"->"	'``@object notNil') 
			#('``@object ~~ nil'	"->"	'``@object notNil'))
		methods: false
		name: '= nil -> isNil AND ~= nil -> notNil'!

guardClause
	^self
		rewrite: #(
			#('`@methodName: `@args 
					| `@temps | 
					`@.Statements. 
					`@condition ifTrue: [| `@trueTemps | `.Statement1. `.Statement2. `@.Statements1]'
			"->"
			'`@methodName: `@args
					| `@temps `@trueTemps |
					`@.Statements.
					`@condition ifFalse: [^self].
					`.Statement1.
					`.Statement2.
					`@.Statements1') 
			#('`@methodName: `@args 
					| `@temps | 
					`@.Statements. 
					`@condition ifFalse: [| `@falseTemps | `.Statement1. `.Statement2. `@.Statements1]'
			"->"
			'`@methodName: `@args
					| `@temps `@falseTemps |
					`@.Statements.
					`@condition ifTrue: [^self].
					`.Statement1.
					`.Statement2.
					`@.Statements1'))
		methods: true
		name: 'Eliminate guarding clauses'!

initializeRecursiveSelfRule
	RecursiveSelfRule := ParseTreeSearcher new.
	RecursiveSelfRule 
		matchesAnyMethodOf: 
			#('`@methodName: `@args | `@temps | self `@methodName: `@args1' 
			'`@methodName: `@args | `@temps | ^self `@methodName: `@args1')
		do: [:aNode :answer | true].
	^RecursiveSelfRule!

minMax
	^self rewrite: #(
			#('``@a < ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a min: ``@b')
			#('``@a <= ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a min: ``@b')
			#('``@a > ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a max: ``@b')
			#('``@a >= ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a max: ``@b')
			#('``@a < ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a max: ``@b')
			#('``@a <= ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a max: ``@b')
			#('``@a > ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a min: ``@b')
			#('``@a >= ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a min: ``@b')
			#('`a < ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('`a <= ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('`a < ``@b ifFalse: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('`a <= ``@b ifFalse: [`a := ``@b]'			"->"	'`a := `a min: ``@b')
			#('`a > ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('`a >= ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('`a > ``@b ifFalse: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('`a >= ``@b ifFalse: [`a := ``@b]'			"->"	'`a := `a max: ``@b')
			#('``@b < `a ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('``@b <= `a ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('``@b < `a ifFalse: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('``@b <= `a ifFalse: [`a := ``@b]'			"->"	'`a := `a max: ``@b')
			#('``@b > `a ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('``@b >= `a ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('``@b > `a ifFalse: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('``@b >= `a ifFalse: [`a := ``@b]'			"->"	'`a := `a min: ``@b'))
		methods: false
		name: 'Rewrite ifTrue:ifFalse: using min:/max:'!

notElimination
	^self
		rewrite: #(
			#('``@object not not'	"->"	'``@object') 
			#('``@object not ifTrue: ``@block' 	"->"	'``@object ifFalse: ``@block') 
			#('``@object not ifFalse: ``@block'	"->"	'``@object ifTrue: ``@block') 
			#('``@object notNil ifFalse: ``@block'	"->"	'``@object isNil ifTrue: ``@block') 
			#('``@object isNil ifFalse: ``@block'	"->"	'``@object notNil ifTrue: ``@block') 
			#('``@object notNull ifFalse: ``@block'	"->"	'``@object isNull ifTrue: ``@block') 
			#('``@collection select: [:`each | | `@temps | ``@.Statements. ``@object not]'
				"->"	'``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object]')
			#('``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object not]'
				"->"	'``@collection select: [:`each | | `@temps | ``@.Statements. ``@object]')
			#('[| `@temps | ``@.Statements. ``@object not] whileTrue: ``@block'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileFalse: ``@block')
			#('[| `@temps | ``@.Statements. ``@object not] whileFalse: ``@block'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileTrue: ``@block')
			#('[| `@temps | ``@.Statements. ``@object not] whileTrue'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileFalse')
			#('[| `@temps | ``@.Statements. ``@object not] whileFalse'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileTrue')
			#('(``@a <= ``@b) not' "->" '``@a > ``@b')
			#('(``@a < ``@b) not' "->" '``@a >= ``@b')
			#('(``@a = ``@b) not' "->" '``@a ~= ``@b')
			#('(``@a == ``@b) not' "->" '``@a ~~ ``@b')
			#('(``@a ~= ``@b) not' "->" '``@a = ``@b')
			#('(``@a ~~ ``@b) not' "->" '``@a == ``@b')
			#('(``@a >= ``@b) not' "->" '``@a < ``@b')
			#('(``@a > ``@b) not' "->" '``@a <= ``@b'))			
		methods: false
		name: 'Eliminate unnecessary not''s'!

notEmpty
	^self 
		rewrite: #(
			#('``@a isEmpty ifFalse: ``@b' "->" '``@a notEmpty ifTrue: ``@b') 
			#('``@a isEmpty not' "->" '``@a notEmpty')
			#('``@a notEmpty ifFalse: ``@b' "->" '``@a isEmpty ifTrue: ``@b') 
			)
		methods: false
		name: 'isEmpty not -> notEmpty'!

recursiveSelfRule
	^RecursiveSelfRule isNil 
		ifTrue: [self initializeRecursiveSelfRule]
		ifFalse: [RecursiveSelfRule]!

rewrite: stringArrays methods: aBoolean name: aName 
	| rewriteRule |
	rewriteRule := ParseTreeRewriter new.
	stringArrays do: 
			[:each | 
			aBoolean 
				ifTrue: [rewriteRule replaceMethod: each first with: each last]
				ifFalse: [rewriteRule replace: each first with: each last]].
	^(self new)
		name: aName;
		rewriteUsing: rewriteRule;
		yourself!

showWhileBlocks
	^self
		rewrite: #(
			#('``@cursor showWhile: [| `@temps | ``@.Statements. `var := ``@object]'
				"->"	'`var := ``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]') 
			#('``@cursor showWhile: [| `@temps | ``@.Statements. ^``@object]'
				"->"	'^``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]'))
		methods: false
		name: 'Move assignment out of showWhile: blocks'!

streamLiterals
	^self rewrite: #(
			#('`#l `{:node | 
				node parent isMessage and: 
						[node parent selector = #writeStream or: 
								[node parent selector = #on: and: 
										[node parent receiver = (RBVariableNode named: ''WriteStream'') 
											or: [node parent receiver = (RBVariableNode named: ''ReadWriteStream'')]]]]}'
			"->"
			'`{`#l value isEmpty 
					ifTrue: 
						[RBMessageNode 
							receiver: (RBVariableNode named: (`#l value = '''' 
											ifTrue: [''String'']
											ifFalse: [`#l value class name asString]))
							selector: #new]
					ifFalse: [RBMessageNode receiver: `#l copy selector: #copy]}'))
		methods: false
		name: 'Convert write streams on literals to be write streams on non-literals'!

superSends
	^(self new)
		name: 'Rewrite super messages to self messages when both refer to same method';
		superSends;
		yourself!

testCaseAsserts
	"Replace TestCase>>assert: with more specific assertions that provide better diagnostics on failure."

	^self
		rewrite: #(
			#('self assert: ``@expr = ``@expected' "->" 'self assert: ``@expr equals: ``@expected')
			#('self assert: ``@expr ~= ``@expected' "->" 'self deny:``@expr equals: ``@expected')
			#('self deny: ``@expr = ``@expected' "->" 'self deny: ``@expr equals: ``@expected')
			#('self deny: ``@expr ~= ``@expected' "->" 'self assert: ``@expr equals: ``@expected')
			#('self assert: ``@expr == ``@expected' "->" 'self assert: ``@expr identicalTo:``@expected')
			#('self deny: ``@expr == ``@expected' "->" 'self deny: ``@expr identicalTo:``@expected')
			#('self assert: ``@expr ~~ ``@expected' "->" 'self deny: ``@expr identicalTo:``@expected')
			#('self deny:``@expr ~~ ``@expected' "->" 'self assert: ``@expr identicalTo:``@expected')
			#('self assert: (``@expr isKindOf: ``@expected)' "->" 'self assert: ``@expr isKindOf: ``@expected')
			#('self assert: ``@expr isNil' "->" 'self assertIsNil: ``@expr')
			#('self assert: ``@expr notNil' "->" 'self denyIsNil: ``@expr')
		)
		methods: false
		name: 'Use more intention-revealing TestCase assert methods'!

unwindBlocks
	#rbFix.	"Remove #valueNowOrOnUnwindDo: and #valueOnUnwindDo: rewrite rules"
	^self
		rewrite: #(
			#('[| `@temps | ``@.Statements. `var := ``@object] ensure: ``@block'
				"->"	'`var := [| `@temps | ``@.Statements. ``@object] ensure: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] ensure: ``@block'
				"->"	'^[| `@temps | ``@.Statements. ``@object] ensure: ``@block') 
			#('[| `@temps | ``@.Statements. `var := ``@object] ifCurtailed: ``@block'
				"->"	'`var := [| `@temps | ``@.Statements. ``@object] ifCurtailed: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] ifCurtailed: ``@block'
				"->"	'^[| `@temps | ``@.Statements. ``@object] ifCurtailed: ``@block'))
		methods: false
		name: 'Move assignment out of ensure: blocks'! !
!TransformationRule class categoriesFor: #assignmentInIfTrue!public!transformations! !
!TransformationRule class categoriesFor: #atIfAbsent!public!transformations! !
!TransformationRule class categoriesFor: #betweenAnd!public!transformations! !
!TransformationRule class categoriesFor: #braceArrays!public!transformations! !
!TransformationRule class categoriesFor: #cascadedNextPutAlls!public!transformations! !
!TransformationRule class categoriesFor: #detectIfNone!public!transformations! !
!TransformationRule class categoriesFor: #equalNil!public!transformations! !
!TransformationRule class categoriesFor: #guardClause!public!transformations! !
!TransformationRule class categoriesFor: #initializeRecursiveSelfRule!accessing!public! !
!TransformationRule class categoriesFor: #minMax!public!transformations! !
!TransformationRule class categoriesFor: #notElimination!public!transformations! !
!TransformationRule class categoriesFor: #notEmpty!public!transformations! !
!TransformationRule class categoriesFor: #recursiveSelfRule!accessing!public! !
!TransformationRule class categoriesFor: #rewrite:methods:name:!instance creation!public! !
!TransformationRule class categoriesFor: #showWhileBlocks!public!transformations! !
!TransformationRule class categoriesFor: #streamLiterals!public!transformations! !
!TransformationRule class categoriesFor: #superSends!public!transformations! !
!TransformationRule class categoriesFor: #testCaseAsserts!public!transformations! !
!TransformationRule class categoriesFor: #unwindBlocks!public!transformations! !

