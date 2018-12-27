"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BP_ANIMATIONPARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BP_ANIMATIONPARAMS guid: (GUID fromString: '{74d57e87-6087-4e82-ac07-680d0a3db4e6}')!
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

	^bytes dwordAtOffset: ##(self offsetOf: #dwDuration)!

dwDuration: anInteger
	"Set the receiver's 'dwDuration' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwDuration) put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

style
	"Answer the <Integer> value of the receiver's 'style' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #style)!

style: anInteger
	"Set the receiver's 'style' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #style) put: anInteger! !
!BP_ANIMATIONPARAMS categoriesFor: #dwDuration!**compiled accessors**!public! !
!BP_ANIMATIONPARAMS categoriesFor: #dwDuration:!**compiled accessors**!public! !
!BP_ANIMATIONPARAMS categoriesFor: #dwFlags!**compiled accessors**!public! !
!BP_ANIMATIONPARAMS categoriesFor: #dwFlags:!**compiled accessors**!public! !
!BP_ANIMATIONPARAMS categoriesFor: #dwSize:!**compiled accessors**!public! !
!BP_ANIMATIONPARAMS categoriesFor: #style!**compiled accessors**!public! !
!BP_ANIMATIONPARAMS categoriesFor: #style:!**compiled accessors**!public! !

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
!BP_ANIMATIONPARAMS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!BP_ANIMATIONPARAMS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

