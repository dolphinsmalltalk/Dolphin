"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.StringPointerArrayTest
	subclass: #'OS.COM.Tests.BSTRArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.BSTRArrayTest guid: (Core.GUID fromString: '{e90f2fcf-c993-418f-bb52-ee22925cf849}')!

OS.COM.Tests.BSTRArrayTest comment: ''!

!OS.COM.Tests.BSTRArrayTest methodsFor!

isValidHeapString: anAddress
	^anAddress isNull or: [
		"BSTRs are allocated from the task heap, but SysAllocString stores the uint length in the first 4 bytes and returns a pointer to the memory beyond that"
		super isValidHeapString: anAddress - 4]!

testSelfEvaluating
	| subject expr |
	subject := self newTestSubjectOfSize: 5.
	self assert: subject isSelfEvaluating.
	expr := subject printString.
	self assert: (Compiler evaluate: expr) equals: subject.
	"The final element contains a null, so is not self evaluating."
	subject := self newTestSubjectOfSize: 6.
	self deny: (subject at: 6) isSelfEvaluating.
	self deny: subject isSelfEvaluating.
	self assert: subject printString equals: 'a COM.BSTRArray('''' ''a'' ''£'' ''a£🍺ö'' ''Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ'' ''a🐬␀b'')'! !

!OS.COM.Tests.BSTRArrayTest categoriesForMethods!
isValidHeapString:!helpers!private! !
testSelfEvaluating!public! !
!

!OS.COM.Tests.BSTRArrayTest class methodsFor!

arrayClass
	^BSTRArray!

elementFromIndex: anInteger
	^##({
		''.
		'a'.
		'£'.
		'a£🍺ö'.
		'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ'.
		'a🐬' , (String with: $\x0 with: $b)
	}) at: anInteger! !

!OS.COM.Tests.BSTRArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

