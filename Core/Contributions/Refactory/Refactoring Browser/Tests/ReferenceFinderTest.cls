"Filed out from Dolphin Smalltalk"!

RefactoringBrowserTest subclass: #ReferenceFinderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ReferenceFinderTest guid: (GUID fromString: '{9403e023-ffa2-4920-af9d-9b80e6055ac8}')!

ReferenceFinderTest comment: ''!

!ReferenceFinderTest categoriesForClass!Refactory-Testing! !

!ReferenceFinderTest methodsFor!

testAllPaths
	| paths |
	paths := ReferenceFinder findAllPathsTo: RefactoringManager instance.
	self deny: paths isEmpty.
	paths do: 
			[:each |
			self assert: each last identicalTo: RefactoringManager instance.
			self assert: each first identicalTo: Smalltalk]!

testAllPathsToInstance
	| paths |
	paths := ReferenceFinder findAllPathsToInstanceOf: RefactoringManager.
	self deny: paths isEmpty.
	paths do: 
			[:each |
			self assert: each last class identicalTo: RefactoringManager.
			self assert: each first identicalTo: Smalltalk]!

testFound
	| path |
	path := ReferenceFinder findPathTo: RefactoringManager instance.
	self assert: path last identicalTo: RefactoringManager instance.
	self assert: (path at: path size - 1) isVariableBinding.
	#rbFix.	"Dolphin's class pool variable names are strings, not Symbols"
	self assert: (path at: path size - 1) key equals: 'Instance'.
	self assert: path first identicalTo: Smalltalk!

testNotFound
	| path |
	path := ReferenceFinder findPathTo: Object new.
	self assertIsNil: path!

testPathToInstance
	| path |
	path := ReferenceFinder findPathToInstanceOf: RefactoringManager.
	self assert: path last class identicalTo: RefactoringManager.
	self assert: path first identicalTo: Smalltalk! !

!ReferenceFinderTest categoriesForMethods!
testAllPaths!public!tests! !
testAllPathsToInstance!public!tests! !
testFound!public!tests! !
testNotFound!public!tests! !
testPathToInstance!public!tests! !
!

