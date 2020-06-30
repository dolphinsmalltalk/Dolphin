"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #DurationFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DurationFactoryANSITest guid: (GUID fromString: '{7398a166-b100-4def-b4bb-25a2cde30eec}')!
DurationFactoryANSITest comment: ''!
!DurationFactoryANSITest categoriesForClass!Unclassified! !
!DurationFactoryANSITest methodsFor!

canonicalObject
	^Duration!

protocol
	^#'Duration factory'!

testXdaysXhoursXminutesXsecondsX
	" <Duration factory>#days:hours:minutes:seconds: "
	#'Date and Time'.
#'todo'. "??? finish impl this. ???"
	self value: [(Duration days: 0 hours: 1 minutes: 2 seconds: 3)]
		should: [:r | r = (Duration days: 0 hours: 1 minutes: 2 seconds: 3)]
		conformTo: #'Duration factory'
		selector: #'days:hours:minutes:seconds:'.!

testXsecondsX
	" <Duration factory>#seconds: "
	#'Date and Time'.
#'todo'. "??? finish impl this. ???"
	"((1 * (24 * 60 * 60) + (1 * (60 * 60)) + (1 * 60) + 1)) -> 90061"
	self value: [(Duration seconds: 3)]
		should: [:r | r = (Duration days: 0 hours: 0 minutes: 0 seconds: 3)]
		conformTo: #'Duration factory' selector: #'seconds:'.!

testXzero
	" <Duration factory>#zero "
	#'Date and Time'.
	self value: [Duration zero] should: [:r | r asSeconds = 0]
		conformTo: #'Duration factory' selector: #'seconds:'.! !
!DurationFactoryANSITest categoriesFor: #canonicalObject!public! !
!DurationFactoryANSITest categoriesFor: #protocol!public! !
!DurationFactoryANSITest categoriesFor: #testXdaysXhoursXminutesXsecondsX!public! !
!DurationFactoryANSITest categoriesFor: #testXsecondsX!public! !
!DurationFactoryANSITest categoriesFor: #testXzero!public! !

