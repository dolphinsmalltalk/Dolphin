"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.CommonDialogStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommonDialogConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.CommonDialogStructure guid: (Core.GUID fromString: '{2ddae63c-f325-47b3-abc3-4b9f8bd84ee9}')!
OS.CommonDialogStructure isNonInstantiable: true!
OS.CommonDialogStructure comment: ''!
!OS.CommonDialogStructure categoriesForClass!External-Data-Structured-Win32! !
!OS.CommonDialogStructure methodsFor!

flags
	^self subclassResponsibility!

flags: anInteger 
	^self subclassResponsibility!

hook: anExternalCallback 
	"Set the receiver's lpfnHook field to the value of anObject."

	self lpfnHook: anExternalCallback asParameter yourAddress.
	self maskIn: self hookFlag!

hookFlag
	^0!

lpfnHook: anExternalAddress 
	^self subclassResponsibility!

maskIn: anInteger 
	self flags: (self flags maskSet: anInteger)! !
!OS.CommonDialogStructure categoriesForMethods!
flags!accessing!public! !
flags:!accessing!public! !
hook:!accessing!public! !
hookFlag!constants!public! !
lpfnHook:!public! !
maskIn:!accessing!public! !
!

