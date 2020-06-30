"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #ExceptionSetANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExceptionSetANSITest guid: (GUID fromString: '{ba94a6b4-592f-4d50-a97b-425f5356665e}')!
ExceptionSetANSITest comment: ''!
!ExceptionSetANSITest categoriesForClass!Unclassified! !
!ExceptionSetANSITest methodsFor!

canonicalObject
	^ExceptionSet new!

protocol
	^#'exceptionSet'!

testXconcatenateOp
	" <exceptionSet>#, "
	#'Exception'.
#'todo'."??? Fix"
	self value: [ Warning, Error ]
		should: [:r | "(r class = (self protocolTestsMgr classAt: 'exceptionSet'))"
			true		and: [(r handles: (Warning new))
							& (r handles: (Error new))] ]
		conformTo: #'exceptionSet' selector: #','.!

testXhandlesX
	" <exceptionSelector>#handles: "
	#'Exception'.! !
!ExceptionSetANSITest categoriesFor: #canonicalObject!public! !
!ExceptionSetANSITest categoriesFor: #protocol!public! !
!ExceptionSetANSITest categoriesFor: #testXconcatenateOp!public! !
!ExceptionSetANSITest categoriesFor: #testXhandlesX!public! !

