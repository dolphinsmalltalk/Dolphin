"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #KEYBDINPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
KEYBDINPUT guid: (GUID fromString: '{738577D8-40AF-48C2-A731-70202483AFB3}')!
KEYBDINPUT comment: '<KEYBDINPUT> is an <ExternalStructure> class to wrap the struct ''Win32.KEYBDINPUT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Contains information about a simulated keyboard event."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(738577D8-40AF-48C2-A731-70202483AFB3), helpstring("Contains information about a simulated keyboard event.")]
struct tagKEYBDINPUT {
	[helpstring("Specifies a virtual-key code.")] WORD wVk;
	[helpstring("Specifies a hardware scan code for the key.")] WORD wScan;
	[helpstring("Flags from the KEYEVENTF enumeration specifying various aspects of a keystroke.")] DWORD dwFlags;
	[helpstring("Time stamp for the event, in milliseconds, or 0 if the system is to generate it")] DWORD time;
	[helpstring("Extra data associated with the keystroke that the application can call GetMessageExtraInfo to retrieve")] ULONG dwExtraInfo;
} KEYBDINPUT;
'!
!KEYBDINPUT categoriesForClass!Win32-Structs! !
!KEYBDINPUT methodsFor!

dwExtraInfo
	"Answer the receiver's dwExtraInfo field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwExtraInfo: anObject
	"Set the receiver's dwExtraInfo field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwFlags: anObject
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

time
	"Answer the receiver's time field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

time: anObject
	"Set the receiver's time field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

wScan
	"Answer the receiver's wScan field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

wScan: anObject
	"Set the receiver's wScan field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject!

wVk
	"Answer the receiver's wVk field as a Smalltalk object."

	^(bytes wordAtOffset: 0)!

wVk: anObject
	"Set the receiver's wVk field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!KEYBDINPUT categoriesFor: #dwExtraInfo!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #dwExtraInfo:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #dwFlags!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #dwFlags:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #time!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #time:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wScan!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wScan:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wVk!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wVk:!**compiled accessors**!public! !

!KEYBDINPUT class methodsFor!

defineFields
	"Define the fields of the KEYBDINPUT structure.

	KEYBDINPUT  compileDefinition

		typedef [uuid(738577D8-40AF-48C2-A731-70202483AFB3), helpstring('Contains information about a simulated keyboard event.')]
		struct tagKEYBDINPUT {
			[helpstring('Specifies a virtual-key code.')] WORD wVk;
			[helpstring('Specifies a hardware scan code for the key.')] WORD wScan;
			[helpstring('Flags from the KEYEVENTF enumeration specifying various aspects of a keystroke.')] DWORD dwFlags;
			[helpstring('Time stamp for the event, in milliseconds, or 0 if the system is to generate it')] DWORD time;
			[helpstring('Extra data associated with the keystroke that the application can call GetMessageExtraInfo to retrieve')] ULONG dwExtraInfo;
		} KEYBDINPUT;
"

	self
		defineField: #wVk type: WORDField new offset: 0;
		defineField: #wScan type: WORDField new offset: 2;
		defineField: #dwFlags type: DWORDField new offset: 4;
		defineField: #time type: DWORDField new offset: 8;
		defineField: #dwExtraInfo type: DWORDField new offset: 12.
	self byteSize: 16! !
!KEYBDINPUT class categoriesFor: #defineFields!**auto generated**!initializing!public! !

