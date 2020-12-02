"Filed out from Dolphin Smalltalk 7"!

CompilerNotification subclass: #CompilerWarningNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompilerWarningNotification guid: (GUID fromString: '{87b4c573-026e-11d3-9fd7-00a0cc3e4a32}')!
CompilerWarningNotification comment: 'CompilerWarningNotification is a resumable exception used to represent semantic warnings detected by the Dolphin <Compiler>, <SmalltalkParser>, and (mainly) <StSemanticChecker>'!
!CompilerWarningNotification categoriesForClass!System-Compiler! !
!CompilerWarningNotification class methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^1!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Warning! !
!CompilerWarningNotification class categoriesFor: #severity!constants!operations!public! !
!CompilerWarningNotification class categoriesFor: #severityClass!constants!public! !

