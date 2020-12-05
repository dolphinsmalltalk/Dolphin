"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #PackageManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
PackageManagerTest guid: (Core.GUID fromString: '{f161630b-6480-4f0c-b958-a57ec75b9cbd}')!
PackageManagerTest comment: ''!
!PackageManagerTest categoriesForClass!Unclassified! !
!PackageManagerTest methodsFor!

testAllClassesPackaged
	"This is not really a PackageManager test, but more a test that the system has been deployed
	or patched correctly. This is to avoid embarassments like Base64Codec being unpackaged in
	5.1 PL4."

	self assert: Package manager unpackagedClasses asArray equals: #()!

testLooseMethodCacheUpToDate
	| allNames loose |
	allNames := LookupTable new.
	Package manager packages do: 
			[:eachPackage |
			eachPackage methodNames do: 
					[:each |
					self deny: (allNames includesKey: each).
					allNames at: each put: eachPackage]].
	loose := Package manager looseMethods.
	self assert: loose size equals: allNames size.
	loose
		keysAndValuesDo: [:eachKey :eachValue | self assert: (allNames lookup: eachKey) identicalTo: eachValue]! !
!PackageManagerTest categoriesFor: #testAllClassesPackaged!public!unit tests! !
!PackageManagerTest categoriesFor: #testLooseMethodCacheUpToDate!public!unit tests! !

