"Filed out from Dolphin Smalltalk X6"!

Error subclass: #AXPropertyReadError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXPropertyReadError guid: (GUID fromString: '{395BCBE7-6D49-461D-8E8E-617D944548F7}')!
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

