"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #SPEVENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPEVENT guid: (GUID fromString: '{F97B7E00-78DC-4C24-826D-863796AA77CA}')!
SPEVENT comment: '<SPEVENT> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPEVENT'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPEVENT {
	unsigned short eEventId;
	unsigned short elParamType;
	unsigned long ulStreamNum;
	unsigned __int64 ullAudioStreamOffset;
	UINT_PTR wParam;
	LONG_PTR lParam;
} SPEVENT;
'!
!SPEVENT categoriesForClass!SpeechLib-Structs! !
!SPEVENT methodsFor!

eEventId
	"Answer the receiver's eEventId field as a Smalltalk object."

	^(bytes wordAtOffset: 0)!

eEventId: anObject
	"Set the receiver's eEventId field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

elParamType
	"Answer the receiver's elParamType field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

elParamType: anObject
	"Set the receiver's elParamType field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes intPtrAtOffset: 20!

lParam: anObject 
	"Set the receiver's lParam field to the value of anObject."

	bytes intPtrAtOffset: 20 put: anObject!

ullAudioStreamOffset
	"Answer the receiver's ullAudioStreamOffset field as a Smalltalk object."

	^(bytes qwordAtOffset: 8)!

ullAudioStreamOffset: anObject
	"Set the receiver's ullAudioStreamOffset field to the value of anObject."

	bytes qwordAtOffset: 8 put: anObject!

ulStreamNum
	"Answer the receiver's ulStreamNum field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulStreamNum: anObject
	"Set the receiver's ulStreamNum field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

wParam
	"Answer the receiver's wParam field as a Smalltalk object."

	^bytes uintPtrAtOffset: 16!

wParam: anObject 
	"Set the receiver's wParam field to the value of anObject."

	bytes uintPtrAtOffset: 16 put: anObject! !
!SPEVENT categoriesFor: #eEventId!**compiled accessors**!public! !
!SPEVENT categoriesFor: #eEventId:!**compiled accessors**!public! !
!SPEVENT categoriesFor: #elParamType!**compiled accessors**!public! !
!SPEVENT categoriesFor: #elParamType:!**compiled accessors**!public! !
!SPEVENT categoriesFor: #lParam!**compiled accessors**!public! !
!SPEVENT categoriesFor: #lParam:!**compiled accessors**!public! !
!SPEVENT categoriesFor: #ullAudioStreamOffset!**compiled accessors**!public! !
!SPEVENT categoriesFor: #ullAudioStreamOffset:!**compiled accessors**!public! !
!SPEVENT categoriesFor: #ulStreamNum!**compiled accessors**!public! !
!SPEVENT categoriesFor: #ulStreamNum:!**compiled accessors**!public! !
!SPEVENT categoriesFor: #wParam!**compiled accessors**!public! !
!SPEVENT categoriesFor: #wParam:!**compiled accessors**!public! !

!SPEVENT class methodsFor!

defineFields
	"Define the fields of the SPEVENT structure.
		SPEVENT compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPEVENT {
			unsigned short eEventId;
			unsigned short elParamType;
			unsigned long ulStreamNum;
			unsigned __int64 ullAudioStreamOffset;
			UINT_PTR wParam;
			LONG_PTR lParam;
		} SPEVENT;
"

	self
		defineField: #eEventId type: WORDField new;
		defineField: #elParamType type: WORDField new;
		defineField: #ulStreamNum type: DWORDField new;
		defineField: #ullAudioStreamOffset type: QWORDField new;
		defineField: #wParam type: UINT_PTRField new;
		defineField: #lParam type: INT_PTRField new!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 166! !
!SPEVENT class categoriesFor: #defineFields!initializing!public! !
!SPEVENT class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

