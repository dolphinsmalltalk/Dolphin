"Filed out from Dolphin Smalltalk 7"!

CompilerNotification subclass: #CompilerErrorNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerErrorNotification guid: (GUID fromString: '{87B4C572-026E-11D3-9FD7-00A0CC3E4A32}')!
CompilerErrorNotification comment: 'CompilerErrorNotification is a resumable exception used to represent lexical, syntax, and semantic errors detected by the <SmalltalkParser> and Dolphin <Compiler>.'!
!CompilerErrorNotification categoriesForClass!System-Exception Handling! !
!CompilerErrorNotification methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^2! !
!CompilerErrorNotification categoriesFor: #severity!displaying!public! !

!CompilerErrorNotification class methodsFor!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Error! !
!CompilerErrorNotification class categoriesFor: #severityClass!constants!public! !

