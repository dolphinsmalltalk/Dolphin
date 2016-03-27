"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentTest subclass: #PackageEnvironmentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageEnvironmentTest guid: (GUID fromString: '{4375158A-0238-45AD-86E5-967559575DED}')!
PackageEnvironmentTest comment: 'SUnitBrowser openOnTestCase: self'!
!PackageEnvironmentTest categoriesForClass!Refactory-Testing! !
!PackageEnvironmentTest methodsFor!

classNamesFor: aPackageEnvironment
	"Superclass implementation will fail because PackageEnvironment may contain partial classes
	and therefore some classes will be in both the environment and its negation."

	| classNames |
	classNames := (aPackageEnvironment classNames asSet)
				addAll: aPackageEnvironment not classNames;
				yourself.
	self assert: classNames = BrowserEnvironment new classNames.
	"	looseClasses := Set new.
	aPackageEnvironment packageNames do: [:eachPak | (Package manager packageNamed: eachPak) methods 
		do: [:each | looseClasses add: each methodClass instanceClass name]].
	self assert: ((aPackageEnvironment & aPackageEnvironment not) classes symmetricDifference: looseClasses. 
				difference: looseClasses)."
	self assert: (aPackageEnvironment | aPackageEnvironment not) classNames asSortedCollection
				= BrowserEnvironment new classNames asSortedCollection!

testPackageEnvironment
	| env selectors |
	env := BrowserEnvironment new 
				forPackages: (Array with: (Package manager packageNamed: 'ActiveX Automation Development')).
	self universalTestFor: env.
	self assert: (env includesClass: AXDispatchImpAbstract).
	selectors := OrderedCollection new.
	env selectorsForClass: AXDispatchImpAbstract do: [:each | selectors add: each].
	self assert: selectors size = 0.
	self assert: (env includesClass: AXDispatchImpAbstract class).
	env selectorsForClass: AXDispatchImpAbstract class do: [:each | selectors add: each].
	self assert: selectors size = 1.
	(Array with:  AXDispatchImpAbstract with: AXDispatchImpAbstract class) do: [:each |
		self assert: (env includesClass: each).
		self deny: (env definesClass: each)].
	(Array with:  AXTypeLibraryPrompter with: AXTypeLibraryPrompter  class) do: [:each |
		self assert: (env includesClass: each).
		self assert: (env definesClass: each)].
	self assert: (env includesSelector: #icon in: AXDispatchImpAbstract class).
	self deny: (env includesSelector: #icon in: AXDispatchImpAbstract)! !
!PackageEnvironmentTest categoriesFor: #classNamesFor:!BrowserEnvironment tests!public! !
!PackageEnvironmentTest categoriesFor: #testPackageEnvironment!public!unit tests! !

