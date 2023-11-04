"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.CommonDialogStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommonDialogConstants})
	classInstanceVariableNames: ''
	classConstants: { '_CommonDialogStructure_Size' -> 16r8. '_OffsetOf_hwndOwner' -> 16r4 }!
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

hwndOwner: aHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndOwner put: aHandle!

lpfnHook: anExternalAddress 
	^self subclassResponsibility!

maskIn: anInteger 
	self flags: (self flags maskSet: anInteger)!

ownerView: aView
	"Set the parent window for the dialog to aView."

	self hwndOwner: aView asParameter ?? 0! !
!OS.CommonDialogStructure categoriesForMethods!
flags!accessing!public! !
flags:!accessing!public! !
hook:!accessing!public! !
hookFlag!constants!public! !
hwndOwner:!**compiled accessors**!public! !
lpfnHook:!public! !
maskIn:!accessing!public! !
ownerView:!accessing!public! !
!

!OS.CommonDialogStructure class methodsFor!

byteSize
	^_CommonDialogStructure_Size!

defineFields
	"
	self compileDefinition
	"

	super defineFields.
	self defineField: #hwndOwner type: HANDLEField writeOnly! !
!OS.CommonDialogStructure class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

