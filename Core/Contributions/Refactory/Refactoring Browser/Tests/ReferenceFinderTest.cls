"Filed out from Dolphin Smalltalk 2000 release 5.00"!

RefactoringBrowserTest subclass: #ReferenceFinderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReferenceFinderTest guid: (GUID fromString: '{9403E023-FFA2-4920-AF9D-9B80E6055AC8}')!
ReferenceFinderTest comment: ''!
!ReferenceFinderTest categoriesForClass!Refactory-Testing! !
!ReferenceFinderTest methodsFor!

testAllPaths
	| paths |
	paths := ReferenceFinder findAllPathsTo: RefactoringManager instance.
	self deny: paths isEmpty.
	paths do: 
			[:each | 
			self assert: each last == RefactoringManager instance.
			self assert: each first == Smalltalk]!

testAllPathsToInstance
	| paths |
	paths := ReferenceFinder findAllPathsToInstanceOf: RefactoringManager.
	self deny: paths isEmpty.
	paths do: 
			[:each | 
			self assert: each last class == RefactoringManager.
			self assert: each first == Smalltalk]!

testFound
	| path |
	path := ReferenceFinder findPathTo: RefactoringManager instance.
	self assert: path last == RefactoringManager instance.
	self assert: (path at: path size - 1) isVariableBinding.
	#rbFix. "Dolphin's class pool variable names are strings, not Symbols"
	self assert: (path at: path size - 1) key = 'Instance'.
	self assert: path first == Smalltalk!

testNotFound
	| path |
	path := ReferenceFinder findPathTo: Object new.
	self assert: path isNil!

testPathToInstance
	| path |
	path := ReferenceFinder findPathToInstanceOf: RefactoringManager.
	self assert: path last class == RefactoringManager.
	self assert: path first == Smalltalk! !
!ReferenceFinderTest categoriesFor: #testAllPaths!public!tests! !
!ReferenceFinderTest categoriesFor: #testAllPathsToInstance!public!tests! !
!ReferenceFinderTest categoriesFor: #testFound!*-RB fixes!public!tests! !
!ReferenceFinderTest categoriesFor: #testNotFound!public!tests! !
!ReferenceFinderTest categoriesFor: #testPathToInstance!public!tests! !

