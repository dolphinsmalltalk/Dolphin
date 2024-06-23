"Filed out from Dolphin Smalltalk"!

Kernel.CompilerNotification
	subclass: #'Kernel.CompilerWarningNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.CompilerWarningNotification guid: (Core.GUID fromString: '{87b4c573-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.CompilerWarningNotification comment: 'CompilerWarningNotification is a resumable exception used to represent semantic warnings detected by the Dolphin <Compiler>, <SmalltalkParser>, and (mainly) <StSemanticChecker>'!

!Kernel.CompilerWarningNotification categoriesForClass!System-Compiler! !

!Kernel.CompilerWarningNotification class methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^1!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Warning! !

!Kernel.CompilerWarningNotification class categoriesForMethods!
severity!constants!operations!public! !
severityClass!constants!public! !
!

