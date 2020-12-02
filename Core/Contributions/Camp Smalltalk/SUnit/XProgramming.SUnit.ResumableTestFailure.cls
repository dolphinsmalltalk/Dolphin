"Filed out from Dolphin Smalltalk 7"!

TestFailure subclass: #ResumableTestFailure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ResumableTestFailure guid: (GUID fromString: '{453f7575-1ad8-4700-b5ed-2e6a6990f8cd}')!
ResumableTestFailure comment: 'A ResumableTestFailure triggers a TestFailure, but lets execution of the TestCase continue. This is useful when iterating through collections, and #assert: ing on each element. In combination with methods like TestCase>>#assert:description:, this lets you run through a whole collection and note which tests pass.

Here''s an example:

	aCollection do: [ :each |
		self assert: each isFoo description: each printString resumable: true]

For each element where #isFoo returns <false>, the element will be printed to the Transcript. '!
!ResumableTestFailure categoriesForClass!SUnitPreload! !
!ResumableTestFailure methodsFor!

isResumable
	"Of course a ResumableTestFailure is resumable ;-)"

	^true
!

sunitExitWith: aValue
	self resume: aValue
! !
!ResumableTestFailure categoriesFor: #isResumable!public! !
!ResumableTestFailure categoriesFor: #sunitExitWith:!public! !

