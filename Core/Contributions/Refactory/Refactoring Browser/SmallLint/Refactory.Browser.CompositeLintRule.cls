"Filed out from Dolphin Smalltalk"!

Refactory.Browser.LintRule
	subclass: #'Refactory.Browser.CompositeLintRule'
	instanceVariableNames: 'rules'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.CompositeLintRule guid: (Core.GUID fromString: '{ac469ac9-0c11-4be1-90b2-f1a9192e9d98}')!
Refactory.Browser.CompositeLintRule comment: 'CompositeLintRule groups LintRules into a single rule (composite pattern).

Instance Variables:
	rules	<Collection of: LintRule>	the rules that make up the composite

'!
!Refactory.Browser.CompositeLintRule categoriesForClass!Refactory-Lint! !
!Refactory.Browser.CompositeLintRule methodsFor!

checkClass: aSmalllintContext 
	rules do: 
			[:each | 
			each checkClass: aSmalllintContext.
			Processor yield]!

checkMethod: aSmalllintContext 
	rules do: 
			[:each | 
			each checkMethod: aSmalllintContext.
			Processor yield]!

failedRules
	^rules inject: OrderedCollection new into: [:oc :each | oc addAll: each failedRules; yourself]!

hasConflicts
	^rules anySatisfy: [:each | each hasConflicts]!

isComposite
	^true!

isEmpty
	^rules allSatisfy: [:each | each isEmpty]!

problemCount
	^rules inject: 0 into: [:count :each | count + each problemCount]!

resetResult
	rules do: [:each | each resetResult]!

rules
	^rules!

rules: aCollection
	rules := aCollection!

viewResults
	rules do: [:each | each viewResults]! !
!Refactory.Browser.CompositeLintRule categoriesForMethods!
checkClass:!accessing!public! !
checkMethod:!accessing!public! !
failedRules!accessing!public! !
hasConflicts!public!testing! !
isComposite!public!testing! !
isEmpty!public!testing! !
problemCount!accessing!public! !
resetResult!initialize/release!public! !
rules!accessing!public! !
rules:!initialize/release!public! !
viewResults!helpers!private! !
!

!Refactory.Browser.CompositeLintRule class methodsFor!

allRules
	^self ruleFor: self protocol: 'all checks'!

lintChecks
	^self
		rules: (BasicLintRule lintProtocols collect: [:each | self ruleFor: BasicLintRule protocol: each])
		name: 'Lint checks'!

ruleFor: aClass protocol: aProtocol
	| allRules |
	#rbFix.	"Dolphin category names are strings, not symbols, and make use of #capitalized"
	allRules := aClass withAllSubclasses inject: OrderedCollection new
				into: 
					[:sum :each |
					sum
						addAll: ((BrowserEnvironment new selectorsFor: aProtocol in: each class)
									collect: [:selector | each perform: selector]);
						yourself	"asSymbol"].
	^self rules: (allRules asSortedCollection: [:a :b | a name <= b name]) name: aProtocol capitalized!

rules: aCollection 
	^self new rules: aCollection!

rules: aCollection name: aString 
	^(self new) rules: aCollection;
		name: aString;
		yourself!

transformations
	^self ruleFor: TransformationRule protocol: 'transformations'! !
!Refactory.Browser.CompositeLintRule class categoriesForMethods!
allRules!instance creation!public! !
lintChecks!all checks!public! !
ruleFor:protocol:!instance creation!public! !
rules:!instance creation!public! !
rules:name:!instance creation!public! !
transformations!all checks!public! !
!

