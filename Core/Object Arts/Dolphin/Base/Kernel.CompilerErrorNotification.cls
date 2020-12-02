"Filed out from Dolphin Smalltalk 7"!

CompilerNotification subclass: #CompilerErrorNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompilerErrorNotification guid: (GUID fromString: '{87b4c572-026e-11d3-9fd7-00a0cc3e4a32}')!
CompilerErrorNotification comment: 'CompilerErrorNotification is a resumable exception used to represent lexical, syntax, and semantic errors detected by the <SmalltalkParser> and Dolphin <Compiler>.'!
!CompilerErrorNotification categoriesForClass!System-Compiler! !
!CompilerErrorNotification class methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^2!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Error! !
!CompilerErrorNotification class categoriesFor: #severity!constants!public! !
!CompilerErrorNotification class categoriesFor: #severityClass!constants!public! !

