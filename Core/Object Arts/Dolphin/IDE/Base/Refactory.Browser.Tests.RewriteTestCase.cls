"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #RewriteTestCase
	instanceVariableNames: 'env'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
RewriteTestCase guid: (Core.GUID fromString: '{6a77c1e6-2f15-4abc-9442-261f617e5ba1}')!
RewriteTestCase comment: ''!
!RewriteTestCase categoriesForClass!Unclassified! !
!RewriteTestCase methodsFor!

setUp
	env := Refactory.Browser.BrowserEnvironment new.
	env := env forClasses: {Animal. Animal class}.
	env := env referencesTo: #notify:caption:!

testEnvironment
	self
		assert: (env includesSelector: #ask in: Animal);
		assert: (env includesSelector: #playGame in: Animal class);
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
	rule := Refactory.Browser.TransformationRule
				rewrite: {{find. replace}}
				methods: false
				name: 'Transform'.
	Refactory.Browser.SmalllintChecker runRule: rule onEnvironment: env.
	self deny: rule changes changes isEmpty! !
!RewriteTestCase categoriesFor: #setUp!public!unit tests! !
!RewriteTestCase categoriesFor: #testEnvironment!public!unit tests! !
!RewriteTestCase categoriesFor: #testFindReplace!public!unit tests! !
!RewriteTestCase categoriesFor: #testTransformationRule!public!unit tests! !

