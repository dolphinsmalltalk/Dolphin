"Filed out from Dolphin Smalltalk 7"!

TestCaseProtocol subclass: #TestCaseHelper
	instanceVariableNames: 'testCase'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'testSelectors'
	classConstants: {}!
TestCaseHelper guid: (GUID fromString: '{8205f35b-2543-4bf4-8069-8402d8c23365}')!
TestCaseHelper isAbstract: true!
TestCaseHelper comment: ''!
!TestCaseHelper categoriesForClass!Unclassified! !
!TestCaseHelper methodsFor!

attachTo: mainTestCase 
	testCase := mainTestCase.!

printOn: aStream

	aStream
		nextPutAll: self class printString;
		nextPutAll: '>>'!

protocol
	^testCase protocol! !
!TestCaseHelper categoriesFor: #attachTo:!public! !
!TestCaseHelper categoriesFor: #printOn:!public! !
!TestCaseHelper categoriesFor: #protocol!public! !

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
!TestCaseHelper class categoriesFor: #initialize!public! !
!TestCaseHelper class categoriesFor: #isAbstract!public! !
!TestCaseHelper class categoriesFor: #suite!public! !
!TestCaseHelper class categoriesFor: #testMethods!public! !

