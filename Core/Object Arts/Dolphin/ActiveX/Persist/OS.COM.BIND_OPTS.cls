"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.COM.BIND_OPTS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BIND_OPTS_Size' -> 16r10.
			'_OffsetOf_dwTickCountDeadline' -> 16rC.
			'_OffsetOf_grfFlags' -> 16r4.
			'_OffsetOf_grfMode' -> 16r8
		}!

OS.COM.BIND_OPTS guid: (Core.GUID fromString: '{87b4c5b3-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.COM.BIND_OPTS comment: 'BIND_OPTS is an external structure class to represent the OLE moniker structure of the same name.

BIND_OPTS is used to specify options to be taken account of when a moniker is being bound. These options are set into the bind context with IBindCtx:::SetBindOptions, and retrived with IBindCtx::GetBindOptions.

BIND_OPTS has been superceded by BIND_OPTS2 with the advent of DCOM.'!

!OS.COM.BIND_OPTS categoriesForClass!External-Data-Structured-COM! !

!OS.COM.BIND_OPTS methodsFor!

dwTickCountDeadline
	"Answer the <Integer> value of the receiver's 'dwTickCountDeadline' field."

	^bytes uint32AtOffset: _OffsetOf_dwTickCountDeadline!

dwTickCountDeadline: anInteger
	"Set the receiver's 'dwTickCountDeadline' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwTickCountDeadline put: anInteger!

grfFlags
	"Answer the <Integer> value of the receiver's 'grfFlags' field."

	^bytes uint32AtOffset: _OffsetOf_grfFlags!

grfFlags: anInteger
	"Set the receiver's 'grfFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfFlags put: anInteger!

grfMode
	"Answer the <Integer> value of the receiver's 'grfMode' field."

	^bytes uint32AtOffset: _OffsetOf_grfMode!

grfMode: anInteger
	"Set the receiver's 'grfMode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfMode put: anInteger! !

!OS.COM.BIND_OPTS categoriesForMethods!
dwTickCountDeadline!**compiled accessors**!public! !
dwTickCountDeadline:!**compiled accessors**!public! !
grfFlags!**compiled accessors**!public! !
grfFlags:!**compiled accessors**!public! !
grfMode!**compiled accessors**!public! !
grfMode:!**compiled accessors**!public! !
!

!OS.COM.BIND_OPTS class methodsFor!

byteSize
	^_BIND_OPTS_Size!

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

	super defineFields.
	self
		defineField: #grfFlags				type: UInt32Field new;
		defineField: #grfMode				type: UInt32Field new;
		defineField: #dwTickCountDeadline	type: UInt32Field new!

getFieldNames
	^#(#dwSize #grfFlags #grfMode #dwTickCountDeadline)! !

!OS.COM.BIND_OPTS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

