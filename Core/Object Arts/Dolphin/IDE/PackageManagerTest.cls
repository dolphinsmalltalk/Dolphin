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
	| allLooseMethods count |
	allLooseMethods := LookupTable new.
	Package manager packages do: 
			[:eachPackage |
			eachPackage methodNames do: 
					[:each |
					| method |
					method := each value.
					self deny: (allLooseMethods includesKey: method).
					allLooseMethods at: method put: eachPackage]].
	count := 0.
	Package manager looseMethods keysAndValuesDo: 
			[:eachClass :eachMap |
			count := count + eachMap size.
			eachMap keysAndValuesDo: 
					[:eachSelector :eachPackage |
					self assert: (allLooseMethods at: eachClass >> eachSelector) identicalTo: eachPackage]].
	self assert: count equals: allLooseMethods size! !
!PackageManagerTest categoriesFor: #testAllClassesPackaged!public!unit tests! !
!PackageManagerTest categoriesFor: #testLooseMethodCacheUpToDate!public!unit tests! !

