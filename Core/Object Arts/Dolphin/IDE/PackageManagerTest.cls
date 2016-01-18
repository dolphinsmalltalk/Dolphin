"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PackageManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageManagerTest guid: (GUID fromString: '{F161630B-6480-4F0C-B958-A57EC75B9CBD}')!
PackageManagerTest comment: ''!
!PackageManagerTest categoriesForClass!Unclassified! !
!PackageManagerTest methodsFor!

testAllClassesPackaged
	"This is not really a PackageManager test, but more a test that the system has been deployed
	or patched correctly. This is to avoid embarassments like Base64Codec being unpackaged in
	5.1 PL4."

	self assert: Package manager unpackagedClasses isEmpty!

testLooseMethodCacheUpToDate
	| allNames |
	allNames := Set new.
	Package manager looseMethods keysAndValuesDo: 
			[:eachName :eachPackage | 
			| method names |
			method := eachPackage methodFromName: eachName ifAbsent: [].
			self assert: method notNil.
			self assert: method name = eachName.
			names := eachPackage methodNames.
			allNames addAll: names.
			self assert: (names includes: eachName)].
	self assert: Package manager looseMethods size = allNames size! !
!PackageManagerTest categoriesFor: #testAllClassesPackaged!public!unit tests! !
!PackageManagerTest categoriesFor: #testLooseMethodCacheUpToDate!public!unit tests! !

