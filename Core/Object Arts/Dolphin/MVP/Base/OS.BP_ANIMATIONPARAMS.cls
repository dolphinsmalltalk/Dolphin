"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.BP_ANIMATIONPARAMS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_BP_ANIMATIONPARAMS_Size' -> 16r10.
		'_OffsetOf_dwDuration' -> 16rC.
		'_OffsetOf_dwFlags' -> 16r4.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_style' -> 16r8
	}!
OS.BP_ANIMATIONPARAMS guid: (Core.GUID fromString: '{74d57e87-6087-4e82-ac07-680d0a3db4e6}')!
OS.BP_ANIMATIONPARAMS comment: '<BP_ANIMATIONPARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.BP_ANIMATIONPARAMS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.BP_ANIMATIONPARAMS categoriesForClass!Win32-Structs! !
!OS.BP_ANIMATIONPARAMS methodsFor!

dwDuration
	"Answer the <Integer> value of the receiver's 'dwDuration' field."

	^bytes uint32AtOffset: _OffsetOf_dwDuration!

dwDuration: anInteger
	"Set the receiver's 'dwDuration' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwDuration put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

style
	"Answer the <Integer> value of the receiver's 'style' field."

	^bytes int32AtOffset: _OffsetOf_style!

style: anInteger
	"Set the receiver's 'style' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_style put: anInteger! !
!OS.BP_ANIMATIONPARAMS categoriesForMethods!
dwDuration!**compiled accessors**!public! !
dwDuration:!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
style!**compiled accessors**!public! !
style:!**compiled accessors**!public! !
!

!OS.BP_ANIMATIONPARAMS class methodsFor!

byteSize
	^_BP_ANIMATIONPARAMS_Size!

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
		defineField: #dwSize type: UInt32Field writeOnly beOverride;
		defineField: #dwFlags type: UInt32Field new;
		defineField: #style type: Int32Field new;
		defineField: #dwDuration type: UInt32Field new!

getFieldNames
	^#(#dwSize #dwFlags #style #dwDuration)! !
!OS.BP_ANIMATIONPARAMS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

