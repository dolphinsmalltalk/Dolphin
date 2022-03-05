"Filed out from Dolphin Smalltalk"!

CompilerNotification subclass: #CompilerInfoNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerInfoNotification guid: (GUID fromString: '{135aa40a-a210-4d71-8553-a1d64829c446}')!
CompilerInfoNotification comment: 'CompilerInfoNotification is a resumable exception used to represent low-severity semantic warnings detected by the <StSemanticChecker>'!
!CompilerInfoNotification categoriesForClass!System-Compiler! !
!CompilerInfoNotification methodsFor!

severityName
	^#Note! !
!CompilerInfoNotification categoriesForMethods!
severityName!displaying!public! !
!

!CompilerInfoNotification class methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^0! !
!CompilerInfoNotification class categoriesForMethods!
severity!constants!public! !
!

