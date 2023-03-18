"Filed out from Dolphin Smalltalk"!

Kernel.CompilerNotification
	subclass: #'Kernel.CompilerErrorNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompilerErrorNotification guid: (Core.GUID fromString: '{87b4c572-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.CompilerErrorNotification comment: 'CompilerErrorNotification is a resumable exception used to represent lexical, syntax, and semantic errors detected by the <SmalltalkParser> and Dolphin <Compiler>.'!
!Kernel.CompilerErrorNotification categoriesForClass!System-Compiler! !
!Kernel.CompilerErrorNotification class methodsFor!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^2!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Error! !
!Kernel.CompilerErrorNotification class categoriesForMethods!
severity!constants!public! !
severityClass!constants!public! !
!

