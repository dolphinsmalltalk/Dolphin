"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #CommonDialogStructure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!

CommonDialogStructure guid: (GUID fromString: '{2ddae63c-f325-47b3-abc3-4b9f8bd84ee9}')!

CommonDialogStructure isAbstract: true!

CommonDialogStructure comment: ''!

!CommonDialogStructure categoriesForClass!External-Data-Structured-Win32! !

!CommonDialogStructure methodsFor!

flags
	^self subclassResponsibility!

flags: anInteger 
	^self subclassResponsibility!

hook: anExternalCallback 
	"Set the receiver's lpfnHook field to the value of anObject."

	self lpfnHook: anExternalCallback asParameter yourAddress.
	self maskIn: self hookFlag!

hookFlag
	^self subclassResponsibility!

lpfnHook: anExternalAddress 
	^self subclassResponsibility!

maskIn: anInteger 
	self flags: (self flags maskSet: anInteger)! !

!CommonDialogStructure categoriesForMethods!
flags!accessing!public! !
flags:!accessing!public! !
hook:!accessing!public! !
hookFlag!constants!public! !
lpfnHook:!public! !
maskIn:!accessing!public! !
!

