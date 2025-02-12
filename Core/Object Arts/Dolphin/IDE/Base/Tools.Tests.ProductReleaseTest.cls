﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.ProductReleaseTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.ProductReleaseTest guid: (Core.GUID fromString: '{685d25f7-ba9b-419b-af63-61526013895c}')!

Tools.Tests.ProductReleaseTest comment: ''!

!Tools.Tests.ProductReleaseTest methodsFor!

checkNoClass: aSymbol
	self specialAssert: (Smalltalk lookup: aSymbol) isNil!

isReleased
	^(Smalltalk lookup: #DolphinOAEdition) isNil!

specialAssert: aBoolean 
	"Private - In an released development environment assert that aBoolean is true. In an OA development
	environment assert that aBoolean is false"

	self assert: (self isReleased ifTrue: [aBoolean] ifFalse: [aBoolean not])!

testClassState
	Smalltalk allClasses do: 
			[:each |
			| builder |
			builder := ClassBuilder forModifying: each.
			[builder validateForModify] on: Warning do: [:warning | warning resume].
			each imports do: [:import | self assert: import isKindOf: NamespaceImport].
			each classPool associationsDo: [:binding | self assert: binding environment identicalTo: each]]!

testClassVariableEnvironments
	"Verify that environment of class variable bindings is the correct class."

	Smalltalk allClasses
		do: [:each | each classPool associationsDo: [:var | self assert: var environment identicalTo: each]]!

testCompilationFailures
	| failed |
	failed := '*-compilation failures' asMethodCategory methods.
	self assert: failed asArray equals: #()
	"
	(Refactory.Browser.BrowserEnvironment new forMethods: failed) browse
	"!

testPackagePaths
	"Verify that the paths of the packages in the image match those defined in the DolphinProduct hierarchy"

	DolphinProduct current contents do: 
			[:each |
			self assert: (File removeExtension: each first)
				equals: (File
						removeExtension: (Package manager packageNamed: (File splitStemFrom: each first)) packagePathname)]!

testSmalltalkKeysAreSymbols
	self assert: (Smalltalk keys reject: [:each | each isSymbol]) asArray equals: #()!

testSubclassResponsibilityNotDefined
	<namespace: Refactory.Browser>
	| checker rule failures |
	rule := BlockLintRule subclassResponsibilityNotDefined.
	checker := SmalllintChecker newWithCachingContext
				rule: rule;
				environment: BrowserEnvironment new;
				yourself.
	checker run.
	failures := rule failedMethods reject: 
					[:each |
					each selector == #testWarnUnimplementedAbstractMethod or: [each methodClass subclasses isEmpty]].
	self assert: failures asSortedArray equals: #()
	"
	(BrowserEnvironment new forMethods: failures) openEditor.
	Or to see all failures, including those grandfathered-in
	rule viewResults.
	"!

testUnlistedPrerequisites
	"Verify that all packages in the image are listed in the DolphinProduct description. This will fail if user code is loaded."

	self assert: DolphinProduct current unlistedPrerequisites asArray equals: #()!

testUnpackagedClasses
	"Verify that there are no unpackaged classes in the image"

	self assert: Package manager unpackagedClasses equals: IdentitySet new!

testUnpackagedVariables
	"Verify that there are no unpackaged static/namespace variables in the image"

	self assert: Package manager unpackagedVariables equals: Set new! !

!Tools.Tests.ProductReleaseTest categoriesForMethods!
checkNoClass:!public!unit tests! !
isReleased!private!unit tests! !
specialAssert:!private!unit tests! !
testClassState!public!unit tests! !
testClassVariableEnvironments!public!unit tests! !
testCompilationFailures!public!unit tests! !
testPackagePaths!public!unit tests! !
testSmalltalkKeysAreSymbols!public!unit tests! !
testSubclassResponsibilityNotDefined!public!unit tests! !
testUnlistedPrerequisites!public!unit tests! !
testUnpackagedClasses!public!unit tests! !
testUnpackagedVariables!public!unit tests! !
!

