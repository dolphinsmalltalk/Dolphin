"Filed out from Dolphin Smalltalk X6.1"!

CompilerNotification subclass: #CompilerWarningNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerWarningNotification guid: (GUID fromString: '{87B4C573-026E-11D3-9FD7-00A0CC3E4A32}')!
CompilerWarningNotification comment: 'CompilerWarningNotification is a resumable exception used to represent semantic warnings detected by the Dolphin <Compiler>, <SmalltalkParser>, and (mainly) <StSemanticChecker>'!
!CompilerWarningNotification categoriesForClass!System-Exception Handling! !
!CompilerWarningNotification class methodsFor!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Warning! !
!CompilerWarningNotification class categoriesFor: #severityClass!constants!public! !

