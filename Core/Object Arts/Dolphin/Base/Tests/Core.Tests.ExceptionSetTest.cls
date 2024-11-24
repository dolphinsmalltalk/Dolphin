"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.ExceptionSetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.ExceptionSetTest guid: (Core.GUID fromString: '{5f2adc73-f36c-4e96-88e4-1ffa950f50b0}')!

Core.Tests.ExceptionSetTest comment: ''!

!Core.Tests.ExceptionSetTest methodsFor!

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

!Core.Tests.ExceptionSetTest categoriesForMethods!
testMatching!public! !
!

