"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BP_PAINTPARAMS
	instanceVariableNames: 'blendFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

pBlendFunction
	"Answer the receiver's pBlendFunction field as a Smalltalk object."

	^BLENDFUNCTION fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pBlendFunction))!

pBlendFunction: anObject 
	"Set the receiver's pBlendFunction field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pBlendFunction) put: anObject yourAddress!

prcExclude
	"Answer the receiver's prcExclude field as a Smalltalk object."

	^RECT fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #prcExclude))!

prcExclude: anObject 
	"Set the receiver's prcExclude field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #prcExclude) put: anObject yourAddress! !
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
		defineField: #pBlendFunction type: (PointerField type: BLENDFUNCTION)! !
!BP_PAINTPARAMS class categoriesFor: #defineFields!initializing!public! !

