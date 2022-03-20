"Filed out from Dolphin Smalltalk"!

TestCaseProtocol subclass: #TestCaseHelper
	instanceVariableNames: 'testCase'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'testSelectors'!
TestCaseHelper guid: (GUID fromString: '{8205f35b-2543-4bf4-8069-8402d8c23365}')!
TestCaseHelper isAbstract: true!
TestCaseHelper comment: ''!
!TestCaseHelper categoriesForClass!Unclassified! !
!TestCaseHelper methodsFor!

attachTo: mainTestCase 
	testCase := mainTestCase.!

canonicalObject
	^testCase canonicalObject!

printOn: aStream

	aStream
		nextPutAll: self class printString;
		nextPutAll: '>>'!

protocol
	^testCase protocol! !
!TestCaseHelper categoriesForMethods!
attachTo:!public! !
canonicalObject!public! !
printOn:!public! !
protocol!public! !
!

!TestCaseHelper class methodsFor!

initialize
	testSelectors := nil!

isAbstract
	"Assume that concrete testcase classes do not have subclasses."
	^true!

suite
	^TestSuite new.!

testMethods
	testSelectors isNil ifTrue: [testSelectors := self selectors select: [:each | 'test*' match: each]].
	^testSelectors! !
!TestCaseHelper class categoriesForMethods!
initialize!public! !
isAbstract!public! !
suite!public! !
testMethods!public! !
!

