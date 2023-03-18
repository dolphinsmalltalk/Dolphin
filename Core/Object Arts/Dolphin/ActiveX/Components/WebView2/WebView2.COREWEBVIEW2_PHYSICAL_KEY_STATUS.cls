"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_COREWEBVIEW2_PHYSICAL_KEY_STATUS_Size' -> 16r18.
			'_OffsetOf_IsExtendedKey' -> 16r8.
			'_OffsetOf_IsKeyReleased' -> 16r14.
			'_OffsetOf_IsMenuKeyDown' -> 16rC.
			'_OffsetOf_RepeatCount' -> 16r0.
			'_OffsetOf_ScanCode' -> 16r4.
			'_OffsetOf_WasKeyDown' -> 16r10
		}!
WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS guid: (Core.GUID fromString: '{192b5d12-5eb1-4a47-8648-a87c55e672a2}')!
WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS comment: '`COREWEBVIEW2_PHYSICAL_KEY_STATUS` is an `ExternalStructure` class to wrap the struct ''WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS'' from type information in the '''' library.

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
	"Answer the <Boolean> value of the receiver's 'IsExtendedKey' field."

	^(bytes uint32AtOffset: _OffsetOf_IsExtendedKey) asBoolean!

IsExtendedKey: aBoolean
	"Set the receiver's 'IsExtendedKey' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_IsExtendedKey put: aBoolean asParameter!

IsKeyReleased
	"Answer the <Boolean> value of the receiver's 'IsKeyReleased' field."

	^(bytes uint32AtOffset: _OffsetOf_IsKeyReleased) asBoolean!

IsKeyReleased: aBoolean
	"Set the receiver's 'IsKeyReleased' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_IsKeyReleased put: aBoolean asParameter!

IsMenuKeyDown
	"Answer the <Boolean> value of the receiver's 'IsMenuKeyDown' field."

	^(bytes uint32AtOffset: _OffsetOf_IsMenuKeyDown) asBoolean!

IsMenuKeyDown: aBoolean
	"Set the receiver's 'IsMenuKeyDown' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_IsMenuKeyDown put: aBoolean asParameter!

RepeatCount
	"Answer the <Integer> value of the receiver's 'RepeatCount' field."

	^bytes uint32AtOffset: _OffsetOf_RepeatCount!

RepeatCount: anInteger
	"Set the receiver's 'RepeatCount' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_RepeatCount put: anInteger!

ScanCode
	"Answer the <Integer> value of the receiver's 'ScanCode' field."

	^bytes uint32AtOffset: _OffsetOf_ScanCode!

ScanCode: anInteger
	"Set the receiver's 'ScanCode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ScanCode put: anInteger!

WasKeyDown
	"Answer the <Boolean> value of the receiver's 'WasKeyDown' field."

	^(bytes uint32AtOffset: _OffsetOf_WasKeyDown) asBoolean!

WasKeyDown: aBoolean
	"Set the receiver's 'WasKeyDown' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_WasKeyDown put: aBoolean asParameter! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS categoriesForMethods!
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

!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS class methodsFor!

byteSize
	^_COREWEBVIEW2_PHYSICAL_KEY_STATUS_Size!

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
		defineField: #RepeatCount type: UInt32Field new offset: 0;
		defineField: #ScanCode type: UInt32Field new offset: 4;
		defineField: #IsExtendedKey type: BOOLField new offset: 8;
		defineField: #IsMenuKeyDown type: BOOLField new offset: 12;
		defineField: #WasKeyDown type: BOOLField new offset: 16;
		defineField: #IsKeyReleased type: BOOLField new offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#RepeatCount #ScanCode #IsExtendedKey #IsMenuKeyDown #WasKeyDown #IsKeyReleased)! !
!WebView2.COREWEBVIEW2_PHYSICAL_KEY_STATUS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

