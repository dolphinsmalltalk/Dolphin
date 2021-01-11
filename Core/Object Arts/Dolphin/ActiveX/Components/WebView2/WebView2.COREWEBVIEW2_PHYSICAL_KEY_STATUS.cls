"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_IsExtendedKey' -> 16r8.
		'_OffsetOf_IsKeyReleased' -> 16r14.
		'_OffsetOf_IsMenuKeyDown' -> 16rC.
		'_OffsetOf_RepeatCount' -> 16r0.
		'_OffsetOf_ScanCode' -> 16r4.
		'_OffsetOf_WasKeyDown' -> 16r10
	}!
WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS guid: (Core.GUID fromString: '{056eb694-ccbb-4ba7-9a71-bc9eeb270836}')!
WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS comment: '`COREWEBVIEW2_PHYSICAL_KEY_STATUS` is an `External.Structure` class to wrap the struct ''WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS'' from type information in the '''' library.

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
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesForClass!WebView2-Structs! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS methodsFor!

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
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #IsExtendedKey!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #IsExtendedKey:!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #IsKeyReleased!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #IsKeyReleased:!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #IsMenuKeyDown!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #IsMenuKeyDown:!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #RepeatCount!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #RepeatCount:!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #ScanCode!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #ScanCode:!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #WasKeyDown!**compiled accessors**!public! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesFor: #WasKeyDown:!**compiled accessors**!public! !

!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS class methodsFor!

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
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

