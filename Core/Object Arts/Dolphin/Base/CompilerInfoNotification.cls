"Filed out from Dolphin Smalltalk 7"!

CompilerNotification subclass: #CompilerInfoNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerInfoNotification guid: (GUID fromString: '{135aa40a-a210-4d71-8553-a1d64829c446}')!
CompilerInfoNotification comment: 'CompilerInfoNotification is a resumable exception used to represent low-severity semantic warnings detected by the <StSemanticChecker>'!
!CompilerInfoNotification categoriesForClass!System-Exception Handling! !
!CompilerInfoNotification methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^0!

severityName
	^#Note! !
!CompilerInfoNotification categoriesFor: #severity!constants!public! !
!CompilerInfoNotification categoriesFor: #severityName!displaying!public! !

