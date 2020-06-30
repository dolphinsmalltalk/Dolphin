"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #MessageNotUnderstoodSelectorANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MessageNotUnderstoodSelectorANSITest guid: (GUID fromString: '{3c0ef06b-106a-4c5f-8d34-21a3dbad2f69}')!
MessageNotUnderstoodSelectorANSITest comment: ''!
!MessageNotUnderstoodSelectorANSITest categoriesForClass!Unclassified! !
!MessageNotUnderstoodSelectorANSITest methodsFor!

canonicalObject
	^MessageNotUnderstood!

protocol
	^#MessageNotUnderstoodSelector!

testXconcatenateOp
	" <exceptionSelector>#, "
	#'Exception'.!

testXhandlesX
	" <MessageNotUnderstoodSelector>#handles: "
	#'Exception'.
	self value: [	[ MessageNotUnderstood signal
				] on: MessageNotUnderstood do: [ :mnu |
					mnu return: (MessageNotUnderstood handles: mnu) ] ]
		should: [:r | r]
		conformTo: #'MessageNotUnderstoodSelector' selector: #'handles:'.

	" ??? should!! "
	self value: [	[ MessageNotUnderstood signal
				] on: MessageNotUnderstood do: [ :mnu |
					mnu return: (Error handles: mnu) ] ]
		should: [:r | r]
		conformTo: #'MessageNotUnderstoodSelector' selector: #'handles:'.! !
!MessageNotUnderstoodSelectorANSITest categoriesFor: #canonicalObject!public! !
!MessageNotUnderstoodSelectorANSITest categoriesFor: #protocol!public! !
!MessageNotUnderstoodSelectorANSITest categoriesFor: #testXconcatenateOp!public! !
!MessageNotUnderstoodSelectorANSITest categoriesFor: #testXhandlesX!public! !

