"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #BP_ANIMATIONPARAMS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwDuration _OffsetOf_dwFlags _OffsetOf_dwSize _OffsetOf_style'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BP_ANIMATIONPARAMS guid: (GUID fromString: '{74d57e87-6087-4e82-ac07-680d0a3db4e6}')!
BP_ANIMATIONPARAMS addClassConstant: '_OffsetOf_dwDuration' value: 16rC!
BP_ANIMATIONPARAMS addClassConstant: '_OffsetOf_dwFlags' value: 16r4!
BP_ANIMATIONPARAMS addClassConstant: '_OffsetOf_dwSize' value: 16r0!
BP_ANIMATIONPARAMS addClassConstant: '_OffsetOf_style' value: 16r8!
BP_ANIMATIONPARAMS comment: '<BP_ANIMATIONPARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.BP_ANIMATIONPARAMS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(74D57E87-6087-4E82-AC07-680D0A3DB4E6)]
struct tagBP_ANIMATIONPARAMS {
	unsigned long cbSize;
	[helpstring("BPAF_ flags")] unsigned long dwFlags;
	BP_ANIMATIONSTYLE style;
	unsigned long dwDuration;
} BP_ANIMATIONPARAMS;
'!
!BP_ANIMATIONPARAMS categoriesForClass!Win32-Structs! !
!BP_ANIMATIONPARAMS methodsFor!

dwDuration
	"Answer the <Integer> value of the receiver's 'dwDuration' field."

	^bytes dwordAtOffset: _OffsetOf_dwDuration!

dwDuration: anInteger
	"Set the receiver's 'dwDuration' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwDuration put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

style
	"Answer the <Integer> value of the receiver's 'style' field."

	^bytes sdwordAtOffset: _OffsetOf_style!

style: anInteger
	"Set the receiver's 'style' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_style put: anInteger! !
!BP_ANIMATIONPARAMS categoriesForMethods!
dwDuration!**compiled accessors**!public! !
dwDuration:!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
style!**compiled accessors**!public! !
style:!**compiled accessors**!public! !
!

!BP_ANIMATIONPARAMS class methodsFor!

defineFields
	"Define the fields of the BP_ANIMATIONPARAMS structure.

	BP_ANIMATIONPARAMS  compileDefinition

		typedef [uuid(74D57E87-6087-4E82-AC07-680D0A3DB4E6)]
		struct tagBP_ANIMATIONPARAMS {
			unsigned long cbSize;
			[helpstring('BPAF_ flags')] unsigned long dwFlags;
			BP_ANIMATIONSTYLE style;
			unsigned long dwDuration;
		} BP_ANIMATIONPARAMS;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #dwFlags type: DWORDField new;
		defineField: #style type: SDWORDField new;
		defineField: #dwDuration type: DWORDField new!

getFieldNames
	^#(#dwSize #dwFlags #style #dwDuration)! !
!BP_ANIMATIONPARAMS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

