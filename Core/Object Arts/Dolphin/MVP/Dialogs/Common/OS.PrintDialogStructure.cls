"Filed out from Dolphin Smalltalk"!

OS.ComDlgStructure
	subclass: #'OS.PrintDialogStructure'
	instanceVariableNames: 'cachedHDevMode devMode cachedHDevNames devNames'
	classVariableNames: ''
	imports: #(#{OS.PrintDialogConstants})
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_hDevMode' -> 16r8. '_OffsetOf_hDevNames' -> 16rC }!
OS.PrintDialogStructure guid: (Core.GUID fromString: '{06b8f99c-539a-4568-8d6e-f72cb3c037b1}')!
OS.PrintDialogStructure isNonInstantiable: true!
OS.PrintDialogStructure comment: ''!
!OS.PrintDialogStructure methodsFor!

deviceName
	^self devNames deviceName!

devMode
	| hDevMode |
	hDevMode := self hDevMode.
	hDevMode = cachedHDevMode
		ifFalse: [devMode := DEVMODEW withBytes: (ByteArray fromGlobalHandle: (cachedHDevMode := hDevMode))].
	^devMode!

devMode: aDEVMODEW
	self hDevMode: (cachedHDevMode := aDEVMODEW copyToGlobalHeap).
	devMode := aDEVMODEW!

devNames
	| hDevNames |
	hDevNames := self hDevNames.
	hDevNames = cachedHDevNames
		ifFalse: [devNames := DEVNAMESW withBytes: (ByteArray fromGlobalHandle: (cachedHDevNames := hDevNames))].
	^devNames!

devNames: aDEVNAMESW
	self hDevNames: (cachedHDevNames  := aDEVNAMESW copyToGlobalHeap).
	devNames := aDEVNAMESW!

driverName
	^self devNames driverName!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

hDevMode
	"Answer the <Handle> value of the receiver's 'hDevMode' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hDevMode) asExternalHandle!

hDevMode: aHandle
	"Set the receiver's 'hDevMode' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDevMode put: aHandle!

hDevNames
	"Answer the <Handle> value of the receiver's 'hDevNames' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hDevNames) asExternalHandle!

hDevNames: aHandle
	"Set the receiver's 'hDevNames' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDevNames put: aHandle!

initialize
	super initialize.
	self beFinalizable!

isDefault
	"Answer whether the selected printer is the default."

	^self devNames isDefault!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources."

	^(self isNull or: [self isPointer]) not!

orientation
	^self devMode dmOrientation!

outputName
	^self devNames outputName!

paperSize
	^self devMode dmPaperSize!

returnDefaultFlag
	^self subclassResponsibility!

returnDefaults
	self maskIn: self returnDefaultFlag! !
!OS.PrintDialogStructure categoriesForMethods!
deviceName!accessing!public! !
devMode!operations!public! !
devMode:!operations!public! !
devNames!operations!public! !
devNames:!operations!public! !
driverName!accessing!public! !
dwSize:!**compiled accessors**!public! !
hDevMode!**compiled accessors**!public! !
hDevMode:!**compiled accessors**!public! !
hDevNames!**compiled accessors**!public! !
hDevNames:!**compiled accessors**!public! !
initialize!initializing!public! !
isDefault!public!testing! !
needsFree!public!realizing/unrealizing! !
orientation!accessing!public! !
outputName!accessing!public! !
paperSize!accessing!public! !
returnDefaultFlag!accessing!constants!private! !
returnDefaults!modes!public! !
!

!OS.PrintDialogStructure class methodsFor!

clear: bytesOrAddress
	"Free external resources referenced by the structure of the receiver's element type at the specified address."

	##({ _OffsetOf_hDevMode. _OffsetOf_hDevNames }) do: 
			[:offset |
			| globalHandle |
			globalHandle := bytesOrAddress uintPtrAtOffset: offset.
			globalHandle == 0 ifFalse: [Kernel32 globalFree: globalHandle]]!

defineFields
	"
		self compileDefinition
	"
	super defineFields.
	self
		defineField: #hDevMode type: HANDLEField new;
		defineField: #hDevNames type: HANDLEField new! !
!OS.PrintDialogStructure class categoriesForMethods!
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
!

