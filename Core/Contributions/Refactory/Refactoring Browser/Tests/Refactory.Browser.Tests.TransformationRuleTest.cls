"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.FooLintRuleTest subclass: #'Refactory.Browser.Tests.TransformationRuleTest'
	instanceVariableNames: 'rewriteRule builder class'
	classVariableNames: 'RecursiveSelfRule'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.TransformationRuleTest guid: (Core.GUID fromString: '{f92d7547-3000-44f7-94ae-0c8b01fc5f2d}')!
Refactory.Browser.Tests.TransformationRuleTest comment: ''!
!Refactory.Browser.Tests.TransformationRuleTest categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.TransformationRuleTest methodsFor!

checkMethod: aSmalllintContext 
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
				ifFalse: 
					[builder compile: rewriteRule tree printString
						in: class
						classified: aSmalllintContext protocols]]!

hasConflicts
	^true!

isEmpty
	^builder changes isEmpty!

problemCount
	^builder problemCount!

resetResult
	builder := CompositeRefactoryChange new!

rewriteUsing: searchReplacer 
	rewriteRule := searchReplacer.
	self resetResult!

superSends
	| rule |
	rule := ParseTreeRewriter new.
	rule addSearch: 'super `@message: ``@args'
				-> (
					[:aNode | 
					(class withAllSubclasses
						detect: [:each | each includesSelector: aNode selector]
						ifNone: [nil]) isNil]
							-> 'self `@message: ``@args').
	self rewriteUsing: rule!

viewResults
	"I reset the result so that we don't fill up memory with methods to compile in the builder."

	builder inspect.
	self resetResult! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #checkMethod:!accessing!public! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #hasConflicts!public!testing! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #problemCount!accessing!public! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #resetResult!accessing!public! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #rewriteUsing:!initialize/release!public! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #superSends!public!rules! !
!Refactory.Browser.Tests.TransformationRuleTest categoriesFor: #viewResults!private! !

!Refactory.Browser.Tests.TransformationRuleTest class methodsFor!

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

detectIfNone
	^self rewrite: #(
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) isNil'
				"->"	'(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) = nil'
				"->"	'(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) == nil'
				"->"	'(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) notNil'
				"->"	'``@collection contains: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~= nil'
				"->"	'``@collection contains: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~~ nil'
				"->"	'``@collection contains: [:`each | | `@temps | ``@.Statements]'))
		methods: false
		name: 'detect:ifNone: -> contains:'!

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

initializeAfterLoad1
	RecursiveSelfRule := ParseTreeSearcher new.
	RecursiveSelfRule
		addMethodSearches: #('`@methodName: `@args | `@temps | self `@methodName: `@args' '`@methodName: `@args | `@temps | ^self `@methodName: `@args')
				-> [:aNode :answer | true]!

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

nuke
	RecursiveSelfRule := nil!

rewrite: stringArrays methods: aBoolean name: aName
	| rewriteRule |
	rewriteRule := ParseTreeRewriter new.
	stringArrays do: 
			[:each |
			aBoolean
				ifTrue: [rewriteRule addMethodSearch: each first -> each last]
				ifFalse: [rewriteRule addSearch: each first -> each last]].
	^self new
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

superSends
	^(self new)
		name: 'Rewrite super messages to self messages when both refer to same method';
		superSends;
		yourself!

unwindBlocks
	^self
		rewrite: #(
			#('[| `@temps | ``@.Statements. `var := ``@object] valueNowOrOnUnwindDo: ``@block'
				"->"	'`var := [| `@temps | ``@.Statements. ``@object] valueNowOrOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] valueNowOrOnUnwindDo: ``@block'
				"->"	'^[| `@temps | ``@.Statements. ``@object] valueNowOrOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. `var := ``@object] valueOnUnwindDo: ``@block'
				"->"	'`var := [| `@temps | ``@.Statements. ``@object] valueOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] valueOnUnwindDo: ``@block'
				"->"	'^[| `@temps | ``@.Statements. ``@object] valueOnUnwindDo: ``@block'))
		methods: false
		name: 'Move assignment out of valueNowOrUnwindDo: blocks'! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #assignmentInIfTrue!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #atIfAbsent!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #betweenAnd!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #detectIfNone!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #equalNil!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #guardClause!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #initializeAfterLoad1!class initialization!public! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #minMax!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #notElimination!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #nuke!class initialization!public! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #rewrite:methods:name:!instance creation!public! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #showWhileBlocks!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #superSends!public!transformations! !
!Refactory.Browser.Tests.TransformationRuleTest class categoriesFor: #unwindBlocks!public!transformations! !

