"Filed out from Dolphin Smalltalk"!

LintRuleTest subclass: #CompositeLintRuleTest
	instanceVariableNames: 'rules'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompositeLintRuleTest guid: (GUID fromString: '{e17dd387-d4f7-4713-878e-41a7c57e54dd}')!
CompositeLintRuleTest comment: ''!
!CompositeLintRuleTest categoriesForClass!Refactory-Test data! !
!CompositeLintRuleTest methodsFor!

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
	^(rules detect: [:each | each hasConflicts] ifNone: [nil]) notNil!

isComposite
	^true!

isEmpty
	^(rules detect: [:each | each isEmpty not] ifNone: [nil]) isNil!

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
!CompositeLintRuleTest categoriesForMethods!
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
viewResults!private! !
!

!CompositeLintRuleTest class methodsFor!

allRules
	^self ruleFor: self protocol: 'all checks'!

lintChecks
	^self rules: (BasicLintRuleTest protocols
				collect: [:each | self ruleFor: BasicLintRuleTest protocol: each])
		name: 'Lint checks'!

ruleFor: aClass protocol: aProtocol 
	^self
		rules: (((BrowserEnvironment new selectorsFor: aProtocol asSymbol in: aClass class)
				collect: [:selector | aClass perform: selector])
					asSortedCollection: [:a :b | a name < b name])
		name: ((aProtocol asString copy) at: 1 put: aProtocol first asUppercase;
				yourself)!

rules: aCollection 
	^self new rules: aCollection!

rules: aCollection name: aString 
	^(self new) rules: aCollection;
		name: aString;
		yourself!

transformations
	^self ruleFor: TransformationRuleTest protocol: 'transformations'! !
!CompositeLintRuleTest class categoriesForMethods!
allRules!instance creation!public! !
lintChecks!all checks!public! !
ruleFor:protocol:!instance creation!public! !
rules:!instance creation!public! !
rules:name:!instance creation!public! !
transformations!all checks!public! !
!

