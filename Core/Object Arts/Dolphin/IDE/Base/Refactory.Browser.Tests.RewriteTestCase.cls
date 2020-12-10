"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'Refactory.Browser.Tests.RewriteTestCase'
	instanceVariableNames: 'env'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RewriteTestCase guid: (Core.GUID fromString: '{6a77c1e6-2f15-4abc-9442-261f617e5ba1}')!
Refactory.Browser.Tests.RewriteTestCase comment: ''!
!Refactory.Browser.Tests.RewriteTestCase categoriesForClass!Unclassified! !
!Refactory.Browser.Tests.RewriteTestCase methodsFor!

setUp
	env := BrowserEnvironment new.
	env := env forClasses: {Smalltalk.Animal. Smalltalk.Animal class}.
	env := env referencesTo: #notify:caption:!

testEnvironment
	self
		assert: (env includesSelector: #ask in: Smalltalk.Animal);
		assert: (env includesSelector: #playGame in: Smalltalk.Animal class);
		deny: env isEmpty!

testFindReplace
	| find replace rule |
	find := '``@receiver notify: ``@arg caption: ``@arg1 '.
	replace := 'self notify: ``@arg caption: ``@arg1'.
	rule := Refactory.Browser.ParseTreeLintRule
				createParseTreeRule: {find. replace}
				method: false
				name: 'Find'.
	Refactory.Browser.SmalllintChecker runRule: rule onEnvironment: env.
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
!Refactory.Browser.Tests.RewriteTestCase categoriesFor: #setUp!public!unit tests! !
!Refactory.Browser.Tests.RewriteTestCase categoriesFor: #testEnvironment!public!unit tests! !
!Refactory.Browser.Tests.RewriteTestCase categoriesFor: #testFindReplace!public!unit tests! !
!Refactory.Browser.Tests.RewriteTestCase categoriesFor: #testTransformationRule!public!unit tests! !

