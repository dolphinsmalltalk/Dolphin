"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.BrowserEnvironmentTest subclass: #'Refactory.Browser.Tests.PackageEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PackageEnvironmentTest guid: (Core.GUID fromString: '{4375158a-0238-45ad-86e5-967559575ded}')!
Refactory.Browser.Tests.PackageEnvironmentTest comment: 'SUnitBrowser openOnTestCase: self'!
!Refactory.Browser.Tests.PackageEnvironmentTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PackageEnvironmentTest methodsFor!

classNamesFor: aPackageEnvironment
	"Superclass implementation will fail because PackageEnvironment may contain partial classes
	and therefore some classes will be in both the environment and its negation."

	| classNames allClassNames |
	classNames := aPackageEnvironment classNames asSet
				addAll: aPackageEnvironment not classNames;
				yourself.
	allClassNames := Refactory.Browser.BrowserEnvironment new classNames.
	self assert: classNames equals: allClassNames.
	"	looseClasses := Set new.
	aPackageEnvironment packageNames do: [:eachPak | (Package manager packageNamed: eachPak) methods 
		do: [:each | looseClasses add: each methodClass instanceClass name]].
	self assert: ((aPackageEnvironment & aPackageEnvironment not) classes symmetricDifference: looseClasses. 
				difference: looseClasses)."
	self assert: (aPackageEnvironment | aPackageEnvironment not) classNames equals: allClassNames!

testPackageEnvironment
	| env selectors |
	env := universalEnvironment
				forPackages: {Package manager packageNamed: 'Dolphin Common Dialogs'}.
	self universalTestFor: env.
	self assert: (env includesClass: Graphics.Font).
	self deny: (env definesClass: Graphics.Font).
	selectors := OrderedCollection new.
	env selectorsForClass: Graphics.Font do: [:each | selectors add: each].
	self assert: selectors size equals: 0.
	self assert: (env includesClass: Graphics.Font class).
	self deny: (env definesClass: Graphics.Font class).
	env selectorsForClass: Graphics.Font class do: [:each | selectors add: each].
	self assert: selectors size equals: 1.
	{UI.FontDialog. UI.FontDialog class} do: 
			[:each |
			self assert: (env includesClass: each).
			self assert: (env definesClass: each)].
	self assert: (env includesSelector: #choose in: Graphics.Font class).
	self deny: (env includesSelector: #icon in: Graphics.Font class)! !
!Refactory.Browser.Tests.PackageEnvironmentTest categoriesFor: #classNamesFor:!BrowserEnvironment tests!public! !
!Refactory.Browser.Tests.PackageEnvironmentTest categoriesFor: #testPackageEnvironment!public!unit tests! !

