"Filed out from Dolphin Smalltalk"!

Kernel.CompilerNotification
	subclass: #'Kernel.CompilerInfoNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.CompilerInfoNotification guid: (Core.GUID fromString: '{135aa40a-a210-4d71-8553-a1d64829c446}')!

Kernel.CompilerInfoNotification comment: 'CompilerInfoNotification is a resumable exception used to represent low-severity semantic warnings detected by the <StSemanticChecker>'!

!Kernel.CompilerInfoNotification categoriesForClass!System-Compiler! !

!Kernel.CompilerInfoNotification methodsFor!

severityName
	^#Note! !

!Kernel.CompilerInfoNotification categoriesForMethods!
severityName!displaying!public! !
!

!Kernel.CompilerInfoNotification class methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^0! !

!Kernel.CompilerInfoNotification class categoriesForMethods!
severity!constants!public! !
!

