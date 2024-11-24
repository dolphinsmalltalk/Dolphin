"Filed out from Dolphin Smalltalk"!

DolphinTest
	subclass: #'ExceptionSetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionSetTest guid: (GUID fromString: '{5f2adc73-f36c-4e96-88e4-1ffa950f50b0}')!

ExceptionSetTest comment: ''!

!ExceptionSetTest methodsFor!

testMatching
	"Also implicitly tested by use in the OA SUnit extension, #should:raise:matching:"

	| selector |
	selector := NotFoundError , BoundsError matching: [:ex | ex messageText = 'Foo'].
	self should: [NotFoundError signal: 'Foo'] raise: selector.
	self should: [BoundsError signal: 'Foo'] raise: selector.
	self shouldnt: [NotFoundError signal: 'Bar'] raise: selector.
	self shouldnt: [Error signal: 'Foo'] raise: selector.
	self shouldnt: [Notification signal: 'Foo'] raise: selector.
	self should: 
			[Notification signal: 'Foo'.
			NotFoundError signal: 'Foo']
		raise: selector.
	self shouldnt: 
			[self error: 'Bar'.
			NotFoundError signal: 'Foo']
		raise: selector! !

!ExceptionSetTest categoriesForMethods!
testMatching!public! !
!

