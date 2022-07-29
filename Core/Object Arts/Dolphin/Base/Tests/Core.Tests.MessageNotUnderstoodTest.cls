"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Core.Tests.MessageNotUnderstoodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.MessageNotUnderstoodTest guid: (Core.GUID fromString: '{17ddb7ae-928d-40aa-a407-fc9f24a94791}')!
Core.Tests.MessageNotUnderstoodTest comment: ''!
!Core.Tests.MessageNotUnderstoodTest methodsFor!

testDescription
	| subject |
	subject := [self blah] on: MessageNotUnderstood do: [:ex | ex].
	self assert: subject description equals: 'Tests.MessageNotUnderstoodTest does not understand #blah'! !
!Core.Tests.MessageNotUnderstoodTest categoriesForMethods!
testDescription!public! !
!

