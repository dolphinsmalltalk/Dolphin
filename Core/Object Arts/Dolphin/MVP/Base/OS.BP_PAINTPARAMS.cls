"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BP_PAINTPARAMS
	instanceVariableNames: 'blendFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFlags' -> 16r4.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_pBlendFunction' -> 16rC.
		'_OffsetOf_prcExclude' -> 16r8
	}!
BP_PAINTPARAMS guid: (GUID fromString: '{caca75ff-b81a-424e-9ffe-ae0e691932d5}')!
BP_PAINTPARAMS comment: ''!
!BP_PAINTPARAMS categoriesForClass!Win32-Structs! !
!BP_PAINTPARAMS methodsFor!

blendFunction
	^blendFunction!

blendFunction: aBLENDFUNCTION 
	blendFunction := aBLENDFUNCTION.
	self pBlendFunction: aBLENDFUNCTION yourAddress!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

pBlendFunction
	"Answer the <BLENDFUNCTION> value of the receiver's 'pBlendFunction' field."

	^BLENDFUNCTION fromAddress: (bytes intPtrAtOffset: _OffsetOf_pBlendFunction)!

pBlendFunction: aBLENDFUNCTION
	"Set the receiver's 'pBlendFunction' field to the value of the argument, aBLENDFUNCTION"

	bytes uintPtrAtOffset: _OffsetOf_pBlendFunction put: aBLENDFUNCTION yourAddress!

prcExclude
	"Answer the <RECT> value of the receiver's 'prcExclude' field."

	^RECT fromAddress: (bytes intPtrAtOffset: _OffsetOf_prcExclude)!

prcExclude: aRECT
	"Set the receiver's 'prcExclude' field to the value of the argument, aRECT"

	bytes uintPtrAtOffset: _OffsetOf_prcExclude put: aRECT yourAddress! !
!BP_PAINTPARAMS categoriesFor: #blendFunction!accessing!public! !
!BP_PAINTPARAMS categoriesFor: #blendFunction:!accessing!public! !
!BP_PAINTPARAMS categoriesFor: #dwFlags!**compiled accessors**!public! !
!BP_PAINTPARAMS categoriesFor: #dwFlags:!**compiled accessors**!public! !
!BP_PAINTPARAMS categoriesFor: #dwSize:!**compiled accessors**!public! !
!BP_PAINTPARAMS categoriesFor: #pBlendFunction!**compiled accessors**!public! !
!BP_PAINTPARAMS categoriesFor: #pBlendFunction:!**compiled accessors**!public! !
!BP_PAINTPARAMS categoriesFor: #prcExclude!**compiled accessors**!public! !
!BP_PAINTPARAMS categoriesFor: #prcExclude:!**compiled accessors**!public! !

!BP_PAINTPARAMS class methodsFor!

defineFields
	"Define the fields of the BP_PAINTPARAMS structure.

	BP_PAINTPARAMS  compileDefinition

		typedef 
		struct tagBP_PAINTPARAMS {
			DWORD cbSize;
			DWORD dwFlags;
			RECT* prcExclude;
			BLENDFUNCTION* pBlendFunction;
		} BP_PAINTPARAMS;
"

	self
		defineField: #dwSize type: DWORDField writeOnly;
		defineField: #dwFlags type: DWORDField new;
		defineField: #prcExclude type: (PointerField type: RECT);
		defineField: #pBlendFunction type: (PointerField type: BLENDFUNCTION)!

getFieldNames
	^#(#dwSize #dwFlags #prcExclude #pBlendFunction)! !
!BP_PAINTPARAMS class categoriesFor: #defineFields!public!template definition! !
!BP_PAINTPARAMS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

