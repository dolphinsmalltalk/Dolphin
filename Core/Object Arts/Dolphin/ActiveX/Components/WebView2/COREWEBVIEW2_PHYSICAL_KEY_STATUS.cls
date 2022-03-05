"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #COREWEBVIEW2_PHYSICAL_KEY_STATUS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_IsExtendedKey _OffsetOf_IsKeyReleased _OffsetOf_IsMenuKeyDown _OffsetOf_RepeatCount _OffsetOf_ScanCode _OffsetOf_WasKeyDown'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COREWEBVIEW2_PHYSICAL_KEY_STATUS guid: (GUID fromString: '{192b5d12-5eb1-4a47-8648-a87c55e672a2}')!
COREWEBVIEW2_PHYSICAL_KEY_STATUS addClassConstant: '_OffsetOf_IsExtendedKey' value: 16r8!
COREWEBVIEW2_PHYSICAL_KEY_STATUS addClassConstant: '_OffsetOf_IsKeyReleased' value: 16r14!
COREWEBVIEW2_PHYSICAL_KEY_STATUS addClassConstant: '_OffsetOf_IsMenuKeyDown' value: 16rC!
COREWEBVIEW2_PHYSICAL_KEY_STATUS addClassConstant: '_OffsetOf_RepeatCount' value: 16r0!
COREWEBVIEW2_PHYSICAL_KEY_STATUS addClassConstant: '_OffsetOf_ScanCode' value: 16r4!
COREWEBVIEW2_PHYSICAL_KEY_STATUS addClassConstant: '_OffsetOf_WasKeyDown' value: 16r10!
COREWEBVIEW2_PHYSICAL_KEY_STATUS comment: '`COREWEBVIEW2_PHYSICAL_KEY_STATUS` is an `ExternalStructure` class to wrap the struct ''WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS'' from type information in the '''' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCOREWEBVIEW2_PHYSICAL_KEY_STATUS {
	unsigned int RepeatCount;
	unsigned int ScanCode;
	long IsExtendedKey;
	long IsMenuKeyDown;
	long WasKeyDown;
	long IsKeyReleased;
} COREWEBVIEW2_PHYSICAL_KEY_STATUS;
```
'!
!COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesForClass!WebView2-Structs! !
!COREWEBVIEW2_PHYSICAL_KEY_STATUS methodsFor!

IsExtendedKey
	"Answer the <Integer> value of the receiver's 'IsExtendedKey' field."

	^bytes sdwordAtOffset: _OffsetOf_IsExtendedKey!

IsExtendedKey: anInteger
	"Set the receiver's 'IsExtendedKey' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_IsExtendedKey put: anInteger!

IsKeyReleased
	"Answer the <Integer> value of the receiver's 'IsKeyReleased' field."

	^bytes sdwordAtOffset: _OffsetOf_IsKeyReleased!

IsKeyReleased: anInteger
	"Set the receiver's 'IsKeyReleased' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_IsKeyReleased put: anInteger!

IsMenuKeyDown
	"Answer the <Integer> value of the receiver's 'IsMenuKeyDown' field."

	^bytes sdwordAtOffset: _OffsetOf_IsMenuKeyDown!

IsMenuKeyDown: anInteger
	"Set the receiver's 'IsMenuKeyDown' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_IsMenuKeyDown put: anInteger!

RepeatCount
	"Answer the <Integer> value of the receiver's 'RepeatCount' field."

	^bytes dwordAtOffset: _OffsetOf_RepeatCount!

RepeatCount: anInteger
	"Set the receiver's 'RepeatCount' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_RepeatCount put: anInteger!

ScanCode
	"Answer the <Integer> value of the receiver's 'ScanCode' field."

	^bytes dwordAtOffset: _OffsetOf_ScanCode!

ScanCode: anInteger
	"Set the receiver's 'ScanCode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ScanCode put: anInteger!

WasKeyDown
	"Answer the <Integer> value of the receiver's 'WasKeyDown' field."

	^bytes sdwordAtOffset: _OffsetOf_WasKeyDown!

WasKeyDown: anInteger
	"Set the receiver's 'WasKeyDown' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_WasKeyDown put: anInteger! !
!COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesForMethods!
IsExtendedKey!**compiled accessors**!public! !
IsExtendedKey:!**compiled accessors**!public! !
IsKeyReleased!**compiled accessors**!public! !
IsKeyReleased:!**compiled accessors**!public! !
IsMenuKeyDown!**compiled accessors**!public! !
IsMenuKeyDown:!**compiled accessors**!public! !
RepeatCount!**compiled accessors**!public! !
RepeatCount:!**compiled accessors**!public! !
ScanCode!**compiled accessors**!public! !
ScanCode:!**compiled accessors**!public! !
WasKeyDown!**compiled accessors**!public! !
WasKeyDown:!**compiled accessors**!public! !
!

!COREWEBVIEW2_PHYSICAL_KEY_STATUS class methodsFor!

defineFields
	"Define the fields of the COREWEBVIEW2_PHYSICAL_KEY_STATUS structure.

	COREWEBVIEW2_PHYSICAL_KEY_STATUS compileDefinition

		typedef 
		struct tagCOREWEBVIEW2_PHYSICAL_KEY_STATUS {
			unsigned int RepeatCount;
			unsigned int ScanCode;
			long IsExtendedKey;
			long IsMenuKeyDown;
			long WasKeyDown;
			long IsKeyReleased;
		} COREWEBVIEW2_PHYSICAL_KEY_STATUS;
"

	self
		defineField: #RepeatCount type: DWORDField new offset: 0;
		defineField: #ScanCode type: DWORDField new offset: 4;
		defineField: #IsExtendedKey type: SDWORDField new offset: 8;
		defineField: #IsMenuKeyDown type: SDWORDField new offset: 12;
		defineField: #WasKeyDown type: SDWORDField new offset: 16;
		defineField: #IsKeyReleased type: SDWORDField new offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#RepeatCount #ScanCode #IsExtendedKey #IsMenuKeyDown #WasKeyDown #IsKeyReleased)! !
!COREWEBVIEW2_PHYSICAL_KEY_STATUS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

