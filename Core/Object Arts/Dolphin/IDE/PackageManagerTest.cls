"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #PackageManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageManagerTest guid: (GUID fromString: '{f161630b-6480-4f0c-b958-a57ec75b9cbd}')!
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
	allNames := Set new.
	Package manager packages
		do: [:eachPackage | eachPackage methodNames do: [:each | allNames add: each key , each value]].
	loose := Package manager looseMethods keys collect: [:each | each key , each value].
	self assert: loose equals: allNames! !
!PackageManagerTest categoriesForMethods!
testAllClassesPackaged!public!unit tests! !
testLooseMethodCacheUpToDate!public!unit tests! !
!

