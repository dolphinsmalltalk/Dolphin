"Filed out from Dolphin Smalltalk 7"!

LintRuleTest subclass: #CompositeLintRuleTest
	instanceVariableNames: 'rules'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!CompositeLintRuleTest categoriesFor: #checkClass:!accessing!public! !
!CompositeLintRuleTest categoriesFor: #checkMethod:!accessing!public! !
!CompositeLintRuleTest categoriesFor: #failedRules!accessing!public! !
!CompositeLintRuleTest categoriesFor: #hasConflicts!public!testing! !
!CompositeLintRuleTest categoriesFor: #isComposite!public!testing! !
!CompositeLintRuleTest categoriesFor: #isEmpty!public!testing! !
!CompositeLintRuleTest categoriesFor: #problemCount!accessing!public! !
!CompositeLintRuleTest categoriesFor: #resetResult!initialize/release!public! !
!CompositeLintRuleTest categoriesFor: #rules!accessing!public! !
!CompositeLintRuleTest categoriesFor: #rules:!initialize/release!public! !
!CompositeLintRuleTest categoriesFor: #viewResults!private! !

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
!CompositeLintRuleTest class categoriesFor: #allRules!instance creation!public! !
!CompositeLintRuleTest class categoriesFor: #lintChecks!all checks!public! !
!CompositeLintRuleTest class categoriesFor: #ruleFor:protocol:!instance creation!public! !
!CompositeLintRuleTest class categoriesFor: #rules:!instance creation!public! !
!CompositeLintRuleTest class categoriesFor: #rules:name:!instance creation!public! !
!CompositeLintRuleTest class categoriesFor: #transformations!all checks!public! !

