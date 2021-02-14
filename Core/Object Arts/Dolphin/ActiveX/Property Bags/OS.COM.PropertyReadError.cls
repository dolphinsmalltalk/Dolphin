"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'OS.COM.PropertyReadError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.PropertyReadError guid: (Core.GUID fromString: '{395bcbe7-6d49-461d-8e8e-617d944548f7}')!
OS.COM.PropertyReadError comment: ''!
!OS.COM.PropertyReadError categoriesForClass!Unclassified! !
!OS.COM.PropertyReadError methodsFor!

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
!OS.COM.PropertyReadError categoriesFor: #errorLog!accessing!public! !
!OS.COM.PropertyReadError categoriesFor: #errorLog:!accessing!public! !
!OS.COM.PropertyReadError categoriesFor: #guid!accessing!public! !
!OS.COM.PropertyReadError categoriesFor: #initialize!initializing!private! !

