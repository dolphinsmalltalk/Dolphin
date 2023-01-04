"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ExceptionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionTest guid: (GUID fromString: '{fffc7252-5c16-49bb-a941-086859b823dc}')!

ExceptionTest comment: ''!

!ExceptionTest methodsFor!

testMatching
	"Also implicitly tested by use in the OA SUnit extension, #should:raise:matching:"

	| selector |
	selector := Error matching: [:ex | ex messageText = 'Foo'].
	self should: [self error: 'Foo'] raise: selector.
	self shouldnt: [self error: 'Bar'] raise: selector.
	self shouldnt: [Notification signal: 'Foo'] raise: selector.
	self should: [Notification signal: 'Foo'. self error: 'Foo'] raise: selector.
	self shouldnt: [self error: 'Bar'. self error: 'Foo'] raise: selector.
! !

!ExceptionTest categoriesForMethods!
testMatching!public! !
!

