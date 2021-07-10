"Filed out from Dolphin Smalltalk"!

Core.Error subclass: #'Kernel.SourceFormatNotSupportedError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SourceFormatNotSupportedError guid: (Core.GUID fromString: '{aa18b57c-6ae3-457a-87c3-a9cad29607ed}')!
Kernel.SourceFormatNotSupportedError comment: ''!
!Kernel.SourceFormatNotSupportedError categoriesForClass!Kernel-Exception Handling! !
!Kernel.SourceFormatNotSupportedError methodsFor!

_descriptionFormat
	"Private - Answer the description format string for the receiver."

	^'%2 cannot be saved in legacy (pre-namespace) format. %1'!

messageText
	^messageText ifNil: ['The variable is not bindable by unqualified name from Smalltalk.']! !
!Kernel.SourceFormatNotSupportedError categoriesFor: #_descriptionFormat!displaying!private! !
!Kernel.SourceFormatNotSupportedError categoriesFor: #messageText!initializing!public! !

