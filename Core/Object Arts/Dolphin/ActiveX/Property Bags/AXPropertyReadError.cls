"Filed out from Dolphin Smalltalk 7"!

Error subclass: #AXPropertyReadError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXPropertyReadError guid: (GUID fromString: '{395bcbe7-6d49-461d-8e8e-617d944548f7}')!
AXPropertyReadError comment: ''!
!AXPropertyReadError categoriesForClass!Unclassified! !
!AXPropertyReadError methodsFor!

errorLog
	"Answer the <AXErrorLog> associated with the receiver."

	^self tag!

errorLog: anAXErrorLog
	"Set the <AXErrorLog> associated with the receiver."

	tag := anAXErrorLog!

guid
	"Answer the guid of the object which was being loaded when the error occurred."

	^self errorLog guid!

initialize
	"Private - Initialize the receiver's instance variables."

	messageText := 'Error loading from property bag'.! !
!AXPropertyReadError categoriesFor: #errorLog!accessing!public! !
!AXPropertyReadError categoriesFor: #errorLog:!accessing!public! !
!AXPropertyReadError categoriesFor: #guid!accessing!public! !
!AXPropertyReadError categoriesFor: #initialize!initializing!private! !

