"Filed out from Dolphin Smalltalk"!

TestCase subclass: #RewriteTestCase
	instanceVariableNames: 'env'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RewriteTestCase guid: (GUID fromString: '{6a77c1e6-2f15-4abc-9442-261f617e5ba1}')!
RewriteTestCase comment: ''!
!RewriteTestCase categoriesForClass!Unclassified! !
!RewriteTestCase methodsFor!

setUp
	env := BrowserEnvironment new.
	env := env forClasses: (Array with: Animal with: Animal class).
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
	rule := ParseTreeLintRule 
				createParseTreeRule: (Array with: find with: replace)
				method: false
				name: 'Find'.
	SmalllintChecker runRule: rule onEnvironment: env.
	self deny: rule isEmpty!

testTransformationRule
	| find replace rule |
	find := '``@receiver notify: ``@arg caption: ``@arg1 '.
	replace := 'self notify: ``@arg caption: ``@arg1'.
	rule := TransformationRule 
				rewrite: (Array with: (Array with: find with: replace))
				methods: false
				name: 'Transform'.
	SmalllintChecker runRule: rule onEnvironment: env.
	self deny: rule changes changes isEmpty! !
!RewriteTestCase categoriesForMethods!
setUp!public!unit tests! !
testEnvironment!public!unit tests! !
testFindReplace!public!unit tests! !
testTransformationRule!public!unit tests! !
!

