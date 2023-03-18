"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.BP_PAINTPARAMS'
	instanceVariableNames: 'blendFunction'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BP_PAINTPARAMS_Size' -> 16r10.
			'_OffsetOf_dwFlags' -> 16r4.
			'_OffsetOf_dwSize' -> 16r0.
			'_OffsetOf_pBlendFunction' -> 16rC.
			'_OffsetOf_prcExclude' -> 16r8
		}!
OS.BP_PAINTPARAMS guid: (Core.GUID fromString: '{caca75ff-b81a-424e-9ffe-ae0e691932d5}')!
OS.BP_PAINTPARAMS comment: ''!
!OS.BP_PAINTPARAMS categoriesForClass!Win32-Structs! !
!OS.BP_PAINTPARAMS methodsFor!

blendFunction
	^blendFunction!

blendFunction: aBLENDFUNCTION 
	blendFunction := aBLENDFUNCTION.
	self pBlendFunction: aBLENDFUNCTION yourAddress!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

pBlendFunction
	"Answer the <BLENDFUNCTION> value of the receiver's 'pBlendFunction' field."

	^OS.BLENDFUNCTION fromAddress: (bytes intPtrAtOffset: _OffsetOf_pBlendFunction)!

pBlendFunction: aBLENDFUNCTION
	"Set the receiver's 'pBlendFunction' field to the value of the argument, aBLENDFUNCTION"

	bytes uintPtrAtOffset: _OffsetOf_pBlendFunction put: aBLENDFUNCTION yourAddress!

prcExclude
	"Answer the <RECTL> value of the receiver's 'prcExclude' field."

	^OS.RECTL fromAddress: (bytes intPtrAtOffset: _OffsetOf_prcExclude)!

prcExclude: aRECTL
	"Set the receiver's 'prcExclude' field to the value of the argument, aRECTL"

	bytes uintPtrAtOffset: _OffsetOf_prcExclude put: aRECTL yourAddress! !
!OS.BP_PAINTPARAMS categoriesForMethods!
blendFunction!accessing!public! !
blendFunction:!accessing!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
pBlendFunction!**compiled accessors**!public! !
pBlendFunction:!**compiled accessors**!public! !
prcExclude!**compiled accessors**!public! !
prcExclude:!**compiled accessors**!public! !
!

!OS.BP_PAINTPARAMS class methodsFor!

byteSize
	^_BP_PAINTPARAMS_Size!

defineFields
	"Define the fields of the BP_PAINTPARAMS structure.

	BP_PAINTPARAMS  compileDefinition

		typedef 
		struct tagBP_PAINTPARAMS {
			DWORD cbSize;
			DWORD dwFlags;
			RECTL* prcExclude;
			BLENDFUNCTION* pBlendFunction;
		} BP_PAINTPARAMS;
"

	self
		defineField: #dwSize type: UInt32Field writeOnly;
		defineField: #dwFlags type: UInt32Field new;
		defineField: #prcExclude type: (PointerField type: RECTL);
		defineField: #pBlendFunction type: (PointerField type: BLENDFUNCTION)!

getFieldNames
	^#(#dwSize #dwFlags #prcExclude #pBlendFunction)! !
!OS.BP_PAINTPARAMS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

