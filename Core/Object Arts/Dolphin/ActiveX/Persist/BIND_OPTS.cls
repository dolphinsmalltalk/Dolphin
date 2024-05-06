"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #BIND_OPTS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_dwTickCountDeadline _OffsetOf_grfFlags _OffsetOf_grfMode'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BIND_OPTS guid: (GUID fromString: '{87b4c5b3-026e-11d3-9fd7-00a0cc3e4a32}')!

BIND_OPTS addClassConstant: '_OffsetOf_dwSize' value: 16r0!
BIND_OPTS addClassConstant: '_OffsetOf_dwTickCountDeadline' value: 16rC!
BIND_OPTS addClassConstant: '_OffsetOf_grfFlags' value: 16r4!
BIND_OPTS addClassConstant: '_OffsetOf_grfMode' value: 16r8!

BIND_OPTS comment: 'BIND_OPTS is an external structure class to represent the OLE moniker structure of the same name.

BIND_OPTS is used to specify options to be taken account of when a moniker is being bound. These options are set into the bind context with IBindCtx:::SetBindOptions, and retrived with IBindCtx::GetBindOptions.

BIND_OPTS has been superceded by BIND_OPTS2 with the advent of DCOM.'!

!BIND_OPTS categoriesForClass!External-Data-Structured-COM! !

!BIND_OPTS methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwTickCountDeadline
	"Answer the <Integer> value of the receiver's 'dwTickCountDeadline' field."

	^bytes dwordAtOffset: _OffsetOf_dwTickCountDeadline!

dwTickCountDeadline: anInteger
	"Set the receiver's 'dwTickCountDeadline' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwTickCountDeadline put: anInteger!

grfFlags
	"Answer the <Integer> value of the receiver's 'grfFlags' field."

	^bytes dwordAtOffset: _OffsetOf_grfFlags!

grfFlags: anInteger
	"Set the receiver's 'grfFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_grfFlags put: anInteger!

grfMode
	"Answer the <Integer> value of the receiver's 'grfMode' field."

	^bytes dwordAtOffset: _OffsetOf_grfMode!

grfMode: anInteger
	"Set the receiver's 'grfMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_grfMode put: anInteger! !

!BIND_OPTS categoriesForMethods!
dwSize:!**compiled accessors**!public! !
dwTickCountDeadline!**compiled accessors**!public! !
dwTickCountDeadline:!**compiled accessors**!public! !
grfFlags!**compiled accessors**!public! !
grfFlags:!**compiled accessors**!public! !
grfMode!**compiled accessors**!public! !
grfMode:!**compiled accessors**!public! !
!

!BIND_OPTS class methodsFor!

defineFields
	"Define the fields of the BIND_OPTS structure.

		BIND_OPTS compileDefinition.

		struct  BIND_OPTS
		{
			DWORD cbStruct;
			DWORD grfFlags;
			DWORD grfMode;
			DWORD dwTickCountDeadline;
		};
	"

	self
		"Use standard name for structure size member"
		defineField: #dwSize				type: DWORDField writeOnly beOverride;
		defineField: #grfFlags				type: DWORDField new;
		defineField: #grfMode				type: DWORDField new;
		defineField: #dwTickCountDeadline	type: DWORDField new!

getFieldNames
	^#(#dwSize #grfFlags #grfMode #dwTickCountDeadline)! !

!BIND_OPTS class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

