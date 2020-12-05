"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.LintRuleTest subclass: #'Refactory.Browser.Tests.CompositeLintRuleTest'
	instanceVariableNames: 'rules'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.CompositeLintRuleTest guid: (Core.GUID fromString: '{e17dd387-d4f7-4713-878e-41a7c57e54dd}')!
Refactory.Browser.Tests.CompositeLintRuleTest comment: ''!
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.CompositeLintRuleTest methodsFor!

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
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #checkClass:!accessing!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #checkMethod:!accessing!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #failedRules!accessing!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #hasConflicts!public!testing! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #isComposite!public!testing! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #problemCount!accessing!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #resetResult!initialize/release!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #rules!accessing!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #rules:!initialize/release!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest categoriesFor: #viewResults!private! !

!Refactory.Browser.Tests.CompositeLintRuleTest class methodsFor!

allRules
	^self ruleFor: self protocol: 'all checks'!

lintChecks
	^self
		rules: (BasicLintRuleTest protocols collect: [:each | self ruleFor: BasicLintRuleTest protocol: each])
		name: 'Lint checks'!

ruleFor: aClass protocol: aProtocol
	^self
		rules: (((BrowserEnvironment new selectorsFor: aProtocol asSymbol in: aClass class)
				collect: [:selector | aClass perform: selector]) asSortedCollection: [:a :b | a name < b name])
		name: (aProtocol asString copy
				at: 1 put: aProtocol first asUppercase;
				yourself)!

rules: aCollection 
	^self new rules: aCollection!

rules: aCollection name: aString 
	^(self new) rules: aCollection;
		name: aString;
		yourself!

transformations
	^self ruleFor: TransformationRuleTest protocol: 'transformations'! !
!Refactory.Browser.Tests.CompositeLintRuleTest class categoriesFor: #allRules!instance creation!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest class categoriesFor: #lintChecks!all checks!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest class categoriesFor: #ruleFor:protocol:!instance creation!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest class categoriesFor: #rules:!instance creation!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest class categoriesFor: #rules:name:!instance creation!public! !
!Refactory.Browser.Tests.CompositeLintRuleTest class categoriesFor: #transformations!all checks!public! !

