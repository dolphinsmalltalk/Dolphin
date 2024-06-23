"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.ExceptionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.ExceptionTest guid: (Core.GUID fromString: '{fffc7252-5c16-49bb-a941-086859b823dc}')!

Core.Tests.ExceptionTest comment: ''!

!Core.Tests.ExceptionTest methodsFor!

testMatching
	"Also implicitly tested by use in the OA SUnit extension, #should:raise:matching:"

	| selector |
	selector := Error matching: [:ex | ex messageText = 'Foo'].
	self should: [self error: 'Foo'] raise: selector.
	self shouldnt: [self error: 'Bar'] raise: selector.
	self shouldnt: [Notification signal: 'Foo'] raise: selector.
	self should: 
			[Notification signal: 'Foo'.
			self error: 'Foo']
		raise: selector.
	self shouldnt: 
			[self error: 'Bar'.
			self error: 'Foo']
		raise: selector! !

!Core.Tests.ExceptionTest categoriesForMethods!
testMatching!public! !
!

