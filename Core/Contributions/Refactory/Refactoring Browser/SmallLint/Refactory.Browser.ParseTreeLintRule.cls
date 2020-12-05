"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BasicLintRule subclass: #'Refactory.Browser.ParseTreeLintRule'
	instanceVariableNames: 'matcher'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ParseTreeLintRule guid: (Core.GUID fromString: '{db449dfa-5729-42a3-87e6-340f66c98e20}')!
Refactory.Browser.ParseTreeLintRule comment: ''!
!Refactory.Browser.ParseTreeLintRule categoriesForClass!Refactory-Lint! !
!Refactory.Browser.ParseTreeLintRule methodsFor!

checkMethod: aSmalllintContext 
	(matcher canMatchMethod: aSmalllintContext compiledMethod) 
		ifFalse: [^self].
	(matcher executeTree: aSmalllintContext parseTree initialAnswer: nil) 
		notNil 
			ifTrue: 
				[result addClass: aSmalllintContext selectedClass
					selector: aSmalllintContext selector]!

defaultResultClass
	^ParseTreeEnvironment!

matcher: aParseTreeMatcher
	matcher := aParseTreeMatcher!

resetResult
	result := ParseTreeEnvironment new.
	result
		label: self name;
		matcher: matcher! !
!Refactory.Browser.ParseTreeLintRule categoriesFor: #checkMethod:!accessing!public! !
!Refactory.Browser.ParseTreeLintRule categoriesFor: #defaultResultClass!private! !
!Refactory.Browser.ParseTreeLintRule categoriesFor: #matcher:!initialize/release!public! !
!Refactory.Browser.ParseTreeLintRule categoriesFor: #resetResult!initialize/release!public! !

!Refactory.Browser.ParseTreeLintRule class methodsFor!

anySatisfy
	#rbFix.	"Renamed from #contains to equivalent ANSI selector, #anySatisfy"
	^self 
		createParseTreeRule: #('(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) isNil' '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) notNil' '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) = nil' '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) == nil' '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) ~= nil' '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) ~~ nil' '`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [| `@temps1 | `@.Statements2. ^`@anything]')
		name: 'Uses detect:ifNone: instead of anySatisfy:'!

asOrderedCollectionNotNeeded
	^self 
		createParseTreeRule: #('`@node addAll: `{:node | node isMessage and: [#(asOrderedCollection asArray) includes: node selector]}')
		name: '#asOrderedCollection/#asArray not needed'!

assignmentInBlock
	#rbFix.	"Remove valueNowOrOnUnwindDo: and #valueOnUnwindDo: as not defined in Dolphin."
	^self createParseTreeRule: #(
			'`@cursor showWhile: [| `@temps | `@.Statements1. `var := `@object]' 
			'`@cursor showWhile: [| `@temps | `@.Statements1. ^`@object]' 
			'[| `@temps | `@.Statements. `var := `@object] ensure: `@block' 
			'[| `@temps | `@.Statements. ^`@object] ensure: `@block' 
			'[| `@temps | `@.Statements. `var := `@object] ifCurtailed: `@block' 
			'[| `@temps | `@.Statements. ^`@object] ifCurtailed: `@block' ) 
		name: 'Unnecessary assignment or return in block'!

assignmentInIfTrue
	^self createParseTreeRule: 
			#('`@boolean 
					ifTrue: [| `@temps1 | `@.Statements1. `var := `@object1] 
					ifFalse: [| `@temps2 | `@.Statements2. `var := `@object2]' 
			'`@boolean 
					ifFalse: [| `@temps1 | `@.Statements1. `var := `@object1] 
					ifTrue: [| `@temps2 | `@.Statements2. `var := `@object2]') 
		name: 'Assignment to same variable at end of ifTrue:ifFalse: blocks'!

atIfAbsent
	^self createParseTreeRule: 
				#('`@object 
						at: `@atArg 
						ifAbsent: [| `@temps | `@.Statements. `@object at: `@atArg put: `@putArg]' 
				'`@object 
						at: `@atArg 
						ifAbsent: [| `@temps | 
								`@.Statements. 
								`@object at: `@atArg put: `@putArg. 
								`@.xStatements1. 
								`@putArg]') 
		name: 'Uses at:ifAbsent: instead of at:ifAbsentPut:'!

booleanPrecedence
	^self createParseTreeRule: 
			#('`@object1 | `@object2 = `@object3'
			'`@object1 | `@object2 == `@object3'
			'`@object1 & `@object2 = `@object3'
			'`@object1 & `@object2 == `@object3'
			'`@object1 | `@object2 ~= `@object3'
			'`@object1 | `@object2 ~~ `@object3'
			'`@object1 & `@object2 ~= `@object3'
			'`@object1 & `@object2 ~~ `@object3')
		name: 'Uses A | B = C instead of A | (B = C)'!

collectionProtocol
	^self createParseTreeRule: 
			#('`@collection do: [:`each | | `@temps | `@.Statements1. `@object add: `@arg. `@.Statements2]' 
			'`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifTrue: [| `@blockTemps | 
							`@.BlockStatements1. 
							`@object add: `each. 
							`@.BlockStatements2]. 
					`@.Statements2]' 
			'`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifFalse: [| `@blockTemps | 
							`@.BlockStatements1. 
							`@object add: `each. 
							`@.BlockStatements2]. 
					`@.Statements2]') 
		name: 'Uses do: instead of collect: or select:''s'!

collectSelectNotUsed
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [(#(#select: #collect: #reject:) includes: node selector) and: [node isUsed not and: [node arguments first isBlock]]]}')
		name: 'Doesn''t use the result of a collect:/select:'!

consistencyCheck
	^self createParseTreeRule: 
				#('`@object size == 0' 
				'`@object size = 0' 
				'`@object size > 0' 
				'`@object size >= 1' 
				'`@object == nil' 
				'`@object = nil'
				'`@collection at: 1'
				'`@collection at: `@collection size') 
		name: 'Uses "size = 0", "= nil",  or "at: 1" instead of "isEmpty",  "isNil", or "first"'!

createMatcherFor: codeStrings method: aBoolean
	| matcher |
	matcher := ParseTreeSearcher new.
	aBoolean
		ifTrue: [matcher matchesAnyMethodOf: codeStrings do: [:aNode :answer | aNode]]
		ifFalse: [matcher matchesAnyOf: codeStrings do: [:aNode :answer | aNode]].
	^matcher!

createParseTreeRule: codeStrings method: aBoolean name: aName 
	^(self new)
		name: aName;
		matcher: (self createMatcherFor: codeStrings method: aBoolean);
		yourself!

createParseTreeRule: codeStrings name: aName 
	^self 
		createParseTreeRule: codeStrings
		method: false
		name: aName!

detectAnySatisfy
	#rbFix. "ANSI selector for #contains: is #anySatisfy:, so renamed"
	^self 
		createParseTreeRule: #('`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^`each]. 
					`@.Statements2]' '`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^`each]. 
					`@.Statements2]' '`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^true]. 
					`@.Statements2]' '`@Collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^true]. 
					`@.Statements2]' '`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^false]. 
					`@.Statements2]' '`@collection do: [:`each | | `@temps | 
					`@.Statements1. 
					`@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^false]. 
					`@.Statements2]')
		name: 'Uses do: instead of anySatisfy: or detect:''s'!

endTrueFalse
	| detector matcher |
	detector := self new.
	detector name: 'Same statements at end of ifTrue:ifFalse: blocks'.
	matcher := ParseTreeSearcher new
				matchesAnyOf: #('`@object 
								ifTrue: [| `@temps1 | `@.Statements1. `.Statement] 
								ifFalse: [| `@temps2 | `@.Statements2. `.Statement]' '`@object 
								ifTrue: [| `@temps1 | `.Statement. `@.Statements1] 
								ifFalse: [| `@temps2 | `.Statement. `@.Statements2]' '`@object 
								ifFalse: [| `@temps1 | `@.Statements1. `.Statement] 
								ifTrue: [| `@temps2 | `@.Statements2. `.Statement]' '`@object 
								ifFalse: [| `@temps1 | `.Statement. `@.Statements1] 
								ifTrue: [| `@temps2 | `.Statement. `@.Statement2]')
					do: 
						[:aNode :answer |
						answer isNil
							ifTrue: 
								[| node |
								node := aNode arguments first body statements last.
								(node isVariable and: [node = aNode arguments last body statements last])
									ifTrue: [nil]
									ifFalse: [aNode]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector!

equalNotUsed
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [node isUsed not and: [#(#= #== #~= #~~ #< #> #<= #>=) includes: node selector]]}')
		name: 'Doesn''t use the result of a =, ~=, etc.'!

equalsTrue
	| detector matcher |
	detector := self new.
	detector name: 'Unnecessary "= true"'.
	matcher := ParseTreeSearcher new
				matchesAnyOf: #('true' 'false')
					do: 
						[:aNode :answer |
						answer isNil
							ifTrue: 
								[(aNode parent isMessage and: [#(#= #== #~= #~~) includes: aNode parent selector])
									ifTrue: [aNode]
									ifFalse: [nil]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector!

extraBlock
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [node receiver isBlock and: [node parent isCascade not and: [#(#value #value: #value:value: #value:value:value: #valueWithArguments) includes: node selector]]]}')
		name: 'Block immediately evaluated'!

fileBlocks
	^self createParseTreeRule: 
				#('[| `@temps | 
					`var := `@object.  
					`@.statements] 
							valueNowOrOnUnwindDo: 
								[`var `@messages: `@args]' 
				'[| `@temps | 
					`var := `@object.  
					`@.statements] 
							valueOnUnwindDo: 
								[`var `@messages: `@args]'
				'[| `@temps | 
					`var := `@object.  
					`@.statements] 
							ensure: 
								[`var `@messages: `@args]' 
				'[| `@temps | 
					`var := `@object.  
					`@.statements] 
							ifCurtailed: 
								[`var `@messages: `@args]') 
		name: 'Assignment inside unwind blocks should be outside.'!

guardingClause
	| detector matcher |
	detector := self new.
	detector name: 'Guarding clauses'.
	matcher := ParseTreeSearcher new.
	matcher
		matchesAnyMethodOf: #('`@MethodName: `@args 
					| `@temps | 
					`@.Statements. 
					`@condition ifTrue: [| `@BlockTemps | `.Statement1. `.Statement2. `@.BStatements]' '`@MethodName: `@args 
					| `@temps | 
					`@.Statements. 
					`@condition ifFalse: [| `@BlockTemps | `.Statement1. `.Statement2. `@.BStatements]')
		do: [:aNode :answer | answer isNil ifTrue: [aNode body statements last] ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

ifTrueBlocks
	^self 
		createParseTreeRule: #(
				'`@condition ifTrue: `{:node | node isBlock not} ifFalse: `@block' 
				'`@condition ifTrue: `@block ifFalse: `{:node | node isBlock not}' 
				'`@condition ifFalse: `{:node | node isBlock not} ifTrue: `@block' 
				'`@condition ifFalse: `@block ifTrue: `{:node | node isBlock not}' 
				'`@condition ifTrue: `{:node | node isBlock not}' 
				'`@condition ifFalse: `{:node | node isBlock not}')
		name: 'Non-blocks in ifTrue:/ifFalse: messages'!

ifTrueReturns
	| detector matcher |
	detector := self new.
	detector name: 'ifTrue:/ifFalse: returns instead of and:/or:''s'.
	matcher := ParseTreeSearcher new.
	matcher
		matchesAnyOf: #('| `@temps | ``@.Statements. ``@object ifTrue: [^``@value1]. ^``@value2' '| `@temps | ``@.Statements. ``@object ifFalse: [^``@value1]. ^``@value2')
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: 
					[| node |
					node := (aNode statements at: aNode statements size - 1) arguments first body statements last value.	"``@value1"
					((node isLiteralNode and: [#(true false) includes: node value]) or: 
							[node := aNode statements last value.
							node isLiteralNode and: [#(true false) includes: node value]])
						ifTrue: [aNode]
						ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

indexOf
^self 
	createParseTreeRule: 
		#('(`@collection indexOf: `@object) = 0' 
		'(`@collection indexOf: `@object) == 0' 
		'(`@collection indexOf: `@object) ~= 0' 
		'(`@collection indexOf: `@object) ~~ 0')
	name: 'Uses indexOf: instead of includes:'!

isArrayOfCharacters: anArray
	anArray isEmpty ifTrue: [^false].
	1 to: anArray size do: [:each | (anArray at: each) class == Character ifFalse: [^false]].
	^true!

isSearchingLiteralExpression: aMessageNode 
	| equalNode expressionNode |
	equalNode := aMessageNode selector = #| 
				ifTrue: [aMessageNode arguments first]
				ifFalse: [aMessageNode receiver].
	expressionNode := equalNode receiver isLiteralNode 
				ifTrue: [equalNode arguments first]
				ifFalse: [equalNode receiver].
	^self isSearchingLiteralExpression: aMessageNode for: expressionNode!

isSearchingLiteralExpression: aSearchingNode for: anObjectNode 
	| argument arguments |
	aSearchingNode isMessage ifFalse: [^false].
	arguments := aSearchingNode arguments.
	arguments size = 1 ifFalse: [^false].
	argument := arguments first.
	(#(#= #==) includes: aSearchingNode selector) 
		ifTrue: 
			[^(aSearchingNode receiver = anObjectNode 
				and: [aSearchingNode arguments first isLiteralNode]) or: 
						[aSearchingNode arguments first = anObjectNode 
							and: [aSearchingNode receiver isLiteralNode]]].
	aSearchingNode selector = #| 
		ifTrue: 
			[^(self isSearchingLiteralExpression: aSearchingNode receiver for: anObjectNode) 
				and: [self isSearchingLiteralExpression: argument for: anObjectNode]].
	aSearchingNode selector = #or: ifFalse: [^false].
	argument isBlock ifFalse: [^false].
	argument body statements size = 1 ifFalse: [^false].
	^(self isSearchingLiteralExpression: aSearchingNode receiver for: anObjectNode) 
		and: [self isSearchingLiteralExpression: argument body statements first for: anObjectNode]!

literalArrayCharacters
	| detector matcher |
	detector := self new.
	detector name: 'Literal array contains only characters'.
	matcher := ParseTreeSearcher new.
	matcher matches: '`#literal'
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: 
					[(aNode value class == Array and: [self isArrayOfCharacters: aNode value])
						ifTrue: [aNode]
						ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

minMax
	| detector matcher |
	detector := self new.
	detector name: 'Uses ifTrue:/ifFalse: instead of min: or max:'.
	matcher := ParseTreeSearcher new.
	matcher
		matchesAnyOf: #('(`x `message: `@y) `ifTrue: [`x := `@y]' '(`@x `message: `@y) `ifTrue: [`@x] `ifFalse: [`@y]' '(`@x `message: `@y) `ifTrue: [`v := `@x] `ifFalse: [`v := `@y]')
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: 
					[((#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) includes: aNode selector)
						and: [#(#< #<= #> #>=) includes: aNode receiver selector]) ifTrue: [aNode] ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

missingYourself
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [node parent isCascade and: [node isDirectlyUsed and: [node selector ~~ #yourself]]]}')
		name: 'Possible missing "; yourself"'!

modifiesCollection
	| detector matcher |
	detector := self new.
	detector name: 'Modifies collection while iterating over it'.
	matcher := ParseTreeSearcher new
				matchesAnyOf: #('`@object do: [:`each | | `@temps | ``@.Statements]' '`@object collect: [:`each | | `@temps | ``@.Statements]' '`@object select: [:`each | | `@temps | ``@.Statements]' '`@object reject: [:`each | | `@temps | ``@.Statements]' '`@object inject: `@value into: [:`sum :`each | | `@temps | ``@.Statements]')
					do: 
						[:aNode :answer |
						answer isNil
							ifTrue: [(self modifiesTree: aNode receiver in: aNode arguments last) ifTrue: [aNode] ifFalse: [nil]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector!

modifiesTree: aCollectionTree in: aParseTree
	| notifier args |
	notifier := ParseTreeSearcher new.
	args := {RBPatternVariableNode named: '`@object'}.
	notifier
		matchesAnyTreeOf: (#(#add: #addAll: #remove: #removeAll:) collect: 
					[:each |
					RBMessageNode
						receiver: aCollectionTree
						selector: each
						arguments: args])
		do: [:aNode :answer | true].
	^notifier executeTree: aParseTree initialAnswer: false!

precedence
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [node hasParentheses not and: [#(#+ #-) includes: node selector]]} * `@C')
		name: 'Inspect instances of "A + B * C" might be "A + (B * C)"'!

returnInEnsure
	| detector matcher returnMatcher |
	detector := self new.
	detector name: 'Contains a return in an ensure: block'.
	returnMatcher := ParseTreeSearcher new.
	returnMatcher matches: '^`@object' do: [:aNode :answer | true].
	matcher := ParseTreeSearcher new.
	matcher
		matchesAnyOf: #('``@rcv ensure: [| `@temps | ``@.Stmts]' '``@rcv valueNowOrOnUnwindDo: [| `@temps | ``@.Stmts]' '``@rcv ifCurtailed: [| `@temps | ``@.Stmts]' '``@rcv valueOnUnwindDo: [| `@temps | ``@.Stmts]')
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: 
					[(returnMatcher executeTree: aNode arguments first initialAnswer: false)
						ifTrue: [aNode]
						ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

returnsIfTrue
	^self createParseTreeRule: 
				#('^`@condition ifTrue: [| `@temps | `@.statements]' 
				'^`@condition ifFalse: [| `@temps | `@.statements]') 
		name: 'Returns value of ifTrue:/ifFalse: without ifFalse:/ifTrue: block'!

searchingLiteral
	| detector matcher |
	detector := self new.
	detector name: 'Uses or''s instead of a searching literal'.
	matcher := ParseTreeSearcher new.
	matcher
		matchesAnyOf: #('``@object = `#literal or: [``@expression]' '``@object == `#literal or: [``@expression]' '`#literal = ``@object or: [``@expression]' '`#literal == ``@object or: [``@expression]' '``@expression | (``@object = `#literal)' '``@expression | (``@object == `#literal)' '``@expression | (`#literal = ``@object)' '``@expression | (`#literal == ``@object)')
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: [(self isSearchingLiteralExpression: aNode) ifTrue: [aNode] ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

sizeCheck
	^self createParseTreeRule: (#(#do: #collect: #reject: #select:) collect: 
					[:each | 
					'`@object size > 0 ifTrue: [`@object ' , each
						, ' [:`each | | `@temps | `@.Statements1]. `@.Statements2]'])
				, (#(#do: #collect: #reject: #select:) collect: 
							[:each | 
							'`@object isEmpty ifFalse: [`@object ' , each
								, ' [:`each | | `@temps | `@.Statements1]. `@.Statements2]'])
		name: 'Unnecessary size check'!

stringConcatenation
	| detector matcher concatenationMatcher |
	detector := self new.
	detector name: 'String concatenation instead of streams'.
	matcher := ParseTreeSearcher new.
	concatenationMatcher := ParseTreeSearcher new.
	concatenationMatcher matches: '`@receiver , `@argument' do: [:aNode :answer | true].
	matcher
		matchesAnyOf: #('``@collection do: [:`each | | `@temps | ``@.Statements]' '``@collection do: [:`each | | `@temps | ``@.Statements] separatedBy: [| `@temps1 | ``@.Statements1]' '``@number to: ``@endNumber do: [:`i | | `@temps | ``@.Statements]' '``@collection detect: [:`each | | `@temps | ``@.Statements]' '``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [| `@temps1 | ``@.Statements1]' '``@collection select: [:`each | | `@temps | ``@.Statements]' '``@collection inject: ``@value into: [:`each | | `@temps | ``@.Statements]')
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: 
					[(aNode arguments
						anySatisfy: [:each | each isBlock and: [concatenationMatcher executeTree: each initialAnswer: false]])
							ifTrue: [aNode]
							ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

threeElementPoint
	| detector matcher |
	detector := self new.
	detector name: 'Possible three element point (e.g., x @ y + q @ r)'.
	matcher := ParseTreeSearcher new
				matches: '``@x @ ``@y'
					do: 
						[:aNode :answer |
						answer isNil
							ifTrue: 
								[| current |
								current := aNode parent.
								
								[current isNil
									or: [current isMessage and: [current selector == #@ or: [current selector isInfix not]]]]
										whileFalse: [current := current parent].
								(current isNil or: [current isMessage and: [current selector isInfix not]])
									ifTrue: [nil]
									ifFalse: [aNode]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector!

toDo
	| detector matcher |
	detector := self new.
	detector name: 'Uses to:do: instead of do:, with:do: or timesRepeat:'.
	matcher := ParseTreeSearcher new.
	matcher matches: '1 to: ``@object size do: [:`each | | `@temps | `@.Statements]'
		do: 
			[:aNode :answer |
			answer isNil
				ifTrue: 
					[| varName variableMatcher |
					varName := aNode arguments last arguments first.	"`each"
					variableMatcher := ParseTreeSearcher new.
					variableMatcher matchesTree: varName
						do: [:node :ans | ans and: [node parent isMessage and: [node parent selector == #at:]]].
					(variableMatcher executeTree: aNode arguments last body initialAnswer: true)
						ifTrue: [aNode]
						ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector!

toDoCollect
	^self 
		createParseTreeRule: #(
			'| `@temps1 |
			`@.Stmts1.
			`collection := Array new: `@size.
			`@.Stmts2.
			1 to: `@size do: 
					[:`i | 
					| `@Btemps2 | 
					`@.BStmts1. 
					`collection at: `i put: `@obj.
					`@.BStmt2].
			`@.Stmts3'
					"-------------"
			 '| `@temps1 |
			`@.Stmts1.
			`collection := Array new: `@size.
			`@.Stmts2.
			1 to: `collection size do: 
					[:`i | 
					| `@Btemps2 | 
					`@.BStmts1. 
					`collection at: `i put: `@obj.
					`@.BStmt2].
			`@.Stmts3')
		name: 'to:do: doesn''t use collect:'!

toDoWithIncrement
	^self 
		createParseTreeRule: #(
				'`@i to: `@j do: [:`e | | `@temps | `@.Stmts. `x := `x + 1. `@.Stmts2]' 
				'`@i to: `@j by: `@k do: [:`e | | `@temps | `@.Stmts. `x := `x + `@k. `@.Stmts2]')
		name: 'to:do: loop also increments a counter'!

unnecessaryAssignment
	^self 
		createParseTreeRule: #('^`{:aNode | aNode isAssignment and: [(aNode whoDefines: aNode variable name) notNil]}')
		name: 'Unnecessary assignment to a temporary variable'!

unoptimizedAndOr
	^self 
		createParseTreeRule: #('(`@a and: `@b) and: `@c' '(`@a or: `@b) or: `@c')
		name: 'Uses "(a and: [b]) and: [c]" instead of "a and: [b and: [c]]"'!

unoptimizedToDo
	^self createParseTreeRule: #('(`@a to: `@b) do: `@c')
		name: 'Uses (to:)do: instead of to:do:'!

usesAdd
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [(node selector == #add: or: [node selector == #addAll:]) and: [node isDirectlyUsed]]}')
		name: 'Uses the result of an add: message'!

whileTrue
	^self createParseTreeRule: 
			#('| `@temps | 
				`@.Statements1. 
				[`index <= `@stop] 
					whileTrue: 
						[| `@blockTemps | 
						`@.BlockStmts1. 
						`index := `index + 1].
				`@.Statements2' 
			'| `@temps | 
				`@.Statements1. 
				[`index < `@stop] 
					whileTrue: 
						[| `@blockTemps | 
						`@.BlockStmts1. 
						`index := `index + 1].
				`@.Statements2'
			'| `@temps | 
				`@.Statements1. 
				[`index >= `@stop] 
					whileTrue: 
						[| `@blockTemps | 
						`@.BlockStmts1. 
						`index := `index - 1].
				`@.Statements2' 
			'| `@temps | 
				`@.Statements1. 
				[`index > `@stop] 
					whileTrue: 
						[| `@blockTemps | 
						`@.BlockStmts1. 
						`index := `index - 1].
				`@.Statements2') 
		name: 'Uses whileTrue: instead of to:do:'!

yourselfNotUsed
	^self createParseTreeRule: #('`{:node | node parent isUsed not} yourself')
		name: 'Doesn''t use the result of a yourself message'! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #anySatisfy!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #asOrderedCollectionNotNeeded!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #assignmentInBlock!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #assignmentInIfTrue!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #atIfAbsent!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #booleanPrecedence!bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #collectionProtocol!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #collectSelectNotUsed!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #consistencyCheck!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #createMatcherFor:method:!helpers!private! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #createParseTreeRule:method:name:!instance creation!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #createParseTreeRule:name:!instance creation!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #detectAnySatisfy!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #endTrueFalse!public!unnecessary code! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #equalNotUsed!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #equalsTrue!public!unnecessary code! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #extraBlock!public!unnecessary code! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #fileBlocks!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #guardingClause!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #ifTrueBlocks!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #ifTrueReturns!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #indexOf!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #isArrayOfCharacters:!private!testing! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #isSearchingLiteralExpression:!private!testing! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #isSearchingLiteralExpression:for:!private!testing! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #literalArrayCharacters!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #minMax!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #missingYourself!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #modifiesCollection!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #modifiesTree:in:!helpers!private! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #precedence!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #returnInEnsure!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #returnsIfTrue!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #searchingLiteral!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #sizeCheck!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #stringConcatenation!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #threeElementPoint!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #toDo!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #toDoCollect!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #toDoWithIncrement!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #unnecessaryAssignment!public!unnecessary code! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #unoptimizedAndOr!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #unoptimizedToDo!miscellaneous!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #usesAdd!possible bugs!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #whileTrue!intention revealing!public! !
!Refactory.Browser.ParseTreeLintRule class categoriesFor: #yourselfNotUsed!miscellaneous!public! !

