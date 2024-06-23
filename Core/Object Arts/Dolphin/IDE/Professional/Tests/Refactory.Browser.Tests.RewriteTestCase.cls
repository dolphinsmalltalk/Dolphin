"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Refactory.Browser.Tests.RewriteTestCase'
	instanceVariableNames: 'env'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.RewriteTestCase guid: (Core.GUID fromString: '{6a77c1e6-2f15-4abc-9442-261f617e5ba1}')!

Refactory.Browser.Tests.RewriteTestCase comment: ''!

!Refactory.Browser.Tests.RewriteTestCase categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.RewriteTestCase methodsFor!

setUp
	super setUp.
	env := BrowserEnvironment new.
	env := env forClasses: {UI.Examples.Animal. UI.Examples.Animal class}.
	env := env referencesTo: #notify:caption:!

testEnvironment
	self
		assert: (env includesSelector: #ask in: UI.Examples.Animal);
		assert: (env includesSelector: #playGame in: UI.Examples.Animal class);
		deny: env isEmpty!

testFindReplace
	| find replace rule |
	find := '``@receiver notify: ``@arg caption: ``@arg1 '.
	replace := 'self notify: ``@arg caption: ``@arg1'.
	rule := ParseTreeLintRule
				createParseTreeRule: {find. replace}
				method: false
				name: 'Find'.
	SmalllintChecker runRule: rule onEnvironment: env.
	self deny: rule isEmpty!

testTransformationRule
	| find replace rule |
	find := '``@receiver notify: ``@arg caption: ``@arg1 '.
	replace := 'self notify: ``@arg caption: ``@arg1'.
	rule := TransformationRule
				rewrite: {{find. replace}}
				methods: false
				name: 'Transform'.
	SmalllintChecker runRule: rule onEnvironment: env.
	self deny: rule changes changes isEmpty! !

!Refactory.Browser.Tests.RewriteTestCase categoriesForMethods!
setUp!public!unit tests! !
testEnvironment!public!unit tests! !
testFindReplace!public!unit tests! !
testTransformationRule!public!unit tests! !
!

