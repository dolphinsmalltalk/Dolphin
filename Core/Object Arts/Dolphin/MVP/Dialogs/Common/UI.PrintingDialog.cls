"Filed out from Dolphin Smalltalk"!

UI.CommonDialog
	subclass: #'UI.PrintingDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.PrintingDialog guid: (Core.GUID fromString: '{2db5c831-2da8-46f1-9146-23ef129fea95}')!

UI.PrintingDialog isNonInstantiable: true!

UI.PrintingDialog comment: ''!

!UI.PrintingDialog methodsFor!

devMode
	^self winStruct devMode!

devMode: aDEVMODEW
	self winStruct devMode: aDEVMODEW!

devNames
	^self winStruct devNames!

devNames: aDEVNAMESW
	self winStruct devNames: aDEVNAMESW!

flags
	^self winStruct flags!

returnDefaults
	self winStruct returnDefaults! !

!UI.PrintingDialog categoriesForMethods!
devMode!public! !
devMode:!accessing!public! !
devNames!public! !
devNames:!accessing!public! !
flags!accessing!public! !
returnDefaults!modes!public! !
!

