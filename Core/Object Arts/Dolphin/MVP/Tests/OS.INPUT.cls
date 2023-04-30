"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.INPUT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.SendInputConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_INPUT_Size' -> 16r1C.
			'_OffsetOf_dx' -> 16r4.
			'_OffsetOf_dy' -> 16r8.
			'_OffsetOf_ki_dwExtraInfo' -> 16r10.
			'_OffsetOf_ki_dwFlags' -> 16r8.
			'_OffsetOf_ki_time' -> 16rC.
			'_OffsetOf_mi_dwExtraInfo' -> 16r18.
			'_OffsetOf_mi_dwFlags' -> 16r10.
			'_OffsetOf_mi_time' -> 16r14.
			'_OffsetOf_mouseData' -> 16rC.
			'_OffsetOf_type' -> 16r0.
			'_OffsetOf_uMsg' -> 16r4.
			'_OffsetOf_wParamH' -> 16rA.
			'_OffsetOf_wParamL' -> 16r8.
			'_OffsetOf_wScan' -> 16r6.
			'_OffsetOf_wVk' -> 16r4
		}!
OS.INPUT guid: (Core.GUID fromString: '{6a520d8f-1dcb-456c-9933-95ee79174bd6}')!
OS.INPUT comment: '`INPUT` is an `External.Structure` class to wrap the struct ''Win32.INPUT'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by SendInput() to store information for synthesizing input events such as keystrokes, mouse movement, and mouse clicks."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(6a520d8f-1dcb-456c-9933-95ee79174bd6), helpstring("Used by SendInput() to store information for synthesizing input events such as keystrokes, mouse movement, and mouse clicks.")]
struct tagINPUT {
	[helpstring("Specifies the type of the input event")] INPUTSources Type;
	union {
		[helpstring("Contains information about a simulated mouse event.")] MOUSEINPUT mi;
		[helpstring("Contains information about a simulated keyboard event.")] KEYBDINPUT ki;
		[helpstring("Contains information about a simulated event from input hardware other than a keyboard or mouse.")] HARDWAREINPUT hi;
	};
} INPUT;
```
'!
!OS.INPUT categoriesForClass!Win32-Structs! !
!OS.INPUT methodsFor!

dwExtraInfo
	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [self mi_dwExtraInfo]
		ifFalse: [type == INPUT_KEYBOARD ifTrue: [self ki_dwExtraInfo] ifFalse: [self shouldNotImplement]]!

dwExtraInfo: anInteger
	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [self mi_dwExtraInfo: anInteger]
		ifFalse: 
			[type == INPUT_KEYBOARD ifTrue: [self ki_dwExtraInfo: anInteger] ifFalse: [self shouldNotImplement]]!

dwFlags
	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [self mi_dwFlags]
		ifFalse: [type == INPUT_KEYBOARD ifTrue: [self ki_dwFlags] ifFalse: [self shouldNotImplement]]!

dwFlags: anInteger
	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [self mi_dwFlags: anInteger]
		ifFalse: 
			[type == INPUT_KEYBOARD ifTrue: [self ki_dwFlags: anInteger] ifFalse: [self shouldNotImplement]]!

dx
	"Answer the <Integer> value of the receiver's 'dx' field."

	^bytes int32AtOffset: _OffsetOf_dx!

dx: anInteger
	"Set the receiver's 'dx' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dx put: anInteger!

dy
	"Answer the <Integer> value of the receiver's 'dy' field."

	^bytes int32AtOffset: _OffsetOf_dy!

dy: anInteger
	"Set the receiver's 'dy' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dy put: anInteger!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of <Symbol>, being the fields defined in
	the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance."

	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [#(#dx #dy #mouseData #mi_dwFlags #mi_time #mi_dwExtraInfo)]
		ifFalse: 
			[type == INPUT_KEYBOARD
				ifTrue: 
					["KEYBDINPUT"
					#(#wVk #wScan #ki_dwFlags #ki_time)]
				ifFalse: 
					["HARDWARDINPUT"
					#(#uMsg #wParamL #wParamH)]]!

ki_dwExtraInfo
	"Answer the <Integer> value of the receiver's 'ki_dwExtraInfo' field."

	^bytes uint32AtOffset: _OffsetOf_ki_dwExtraInfo!

ki_dwExtraInfo: anInteger
	"Set the receiver's 'ki_dwExtraInfo' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ki_dwExtraInfo put: anInteger!

ki_dwFlags
	"Answer the <Integer> value of the receiver's 'ki_dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_ki_dwFlags!

ki_dwFlags: anInteger
	"Set the receiver's 'ki_dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ki_dwFlags put: anInteger!

ki_time
	"Answer the <Integer> value of the receiver's 'ki_time' field."

	^bytes uint32AtOffset: _OffsetOf_ki_time!

ki_time: anInteger
	"Set the receiver's 'ki_time' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ki_time put: anInteger!

mi_dwExtraInfo
	"Answer the <Integer> value of the receiver's 'mi_dwExtraInfo' field."

	^bytes uintPtrAtOffset: _OffsetOf_mi_dwExtraInfo!

mi_dwExtraInfo: anInteger
	"Set the receiver's 'mi_dwExtraInfo' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_mi_dwExtraInfo put: anInteger!

mi_dwFlags
	"Answer the <Integer> value of the receiver's 'mi_dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_mi_dwFlags!

mi_dwFlags: anInteger
	"Set the receiver's 'mi_dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_mi_dwFlags put: anInteger!

mi_time
	"Answer the <Integer> value of the receiver's 'mi_time' field."

	^bytes uint32AtOffset: _OffsetOf_mi_time!

mi_time: anInteger
	"Set the receiver's 'mi_time' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_mi_time put: anInteger!

mouseData
	"Answer the <Integer> value of the receiver's 'mouseData' field."

	^bytes uint32AtOffset: _OffsetOf_mouseData!

mouseData: anInteger
	"Set the receiver's 'mouseData' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_mouseData put: anInteger!

time
	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [self mi_time]
		ifFalse: [type == INPUT_KEYBOARD ifTrue: [self ki_time] ifFalse: [self shouldNotImplement]]!

time: anInteger
	| type |
	type := self type.
	^type == INPUT_MOUSE
		ifTrue: [self mi_time: anInteger]
		ifFalse: [type == INPUT_KEYBOARD ifTrue: [self ki_time: anInteger] ifFalse: [self shouldNotImplement]]!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes int32AtOffset: _OffsetOf_type!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_type put: anInteger!

uMsg
	"Answer the <Integer> value of the receiver's 'uMsg' field."

	^bytes uint32AtOffset: _OffsetOf_uMsg!

uMsg: anInteger
	"Set the receiver's 'uMsg' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_uMsg put: anInteger!

wParamH
	"Answer the <Integer> value of the receiver's 'wParamH' field."

	^bytes uint16AtOffset: _OffsetOf_wParamH!

wParamH: anInteger
	"Set the receiver's 'wParamH' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wParamH put: anInteger!

wParamL
	"Answer the <Integer> value of the receiver's 'wParamL' field."

	^bytes uint16AtOffset: _OffsetOf_wParamL!

wParamL: anInteger
	"Set the receiver's 'wParamL' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wParamL put: anInteger!

wScan
	"Answer the <Integer> value of the receiver's 'wScan' field."

	^bytes uint16AtOffset: _OffsetOf_wScan!

wScan: anInteger
	"Set the receiver's 'wScan' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wScan put: anInteger!

wVk
	"Answer the <Integer> value of the receiver's 'wVk' field."

	^bytes uint16AtOffset: _OffsetOf_wVk!

wVk: anInteger
	"Set the receiver's 'wVk' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wVk put: anInteger! !
!OS.INPUT categoriesForMethods!
dwExtraInfo!accessing!public! !
dwExtraInfo:!accessing!public! !
dwFlags!accessing!public! !
dwFlags:!accessing!public! !
dx!**compiled accessors**!public! !
dx:!**compiled accessors**!public! !
dy!**compiled accessors**!public! !
dy:!**compiled accessors**!public! !
getValidFields!accessing!private! !
ki_dwExtraInfo!**compiled accessors**!public! !
ki_dwExtraInfo:!**compiled accessors**!public! !
ki_dwFlags!**compiled accessors**!public! !
ki_dwFlags:!**compiled accessors**!public! !
ki_time!**compiled accessors**!public! !
ki_time:!**compiled accessors**!public! !
mi_dwExtraInfo!**compiled accessors**!public! !
mi_dwExtraInfo:!**compiled accessors**!public! !
mi_dwFlags!**compiled accessors**!public! !
mi_dwFlags:!**compiled accessors**!public! !
mi_time!**compiled accessors**!public! !
mi_time:!**compiled accessors**!public! !
mouseData!**compiled accessors**!public! !
mouseData:!**compiled accessors**!public! !
time!accessing!public! !
time:!accessing!public! !
type!**compiled accessors**!public! !
type:!**compiled accessors**!public! !
uMsg!**compiled accessors**!public! !
uMsg:!**compiled accessors**!public! !
wParamH!**compiled accessors**!public! !
wParamH:!**compiled accessors**!public! !
wParamL!**compiled accessors**!public! !
wParamL:!**compiled accessors**!public! !
wScan!**compiled accessors**!public! !
wScan:!**compiled accessors**!public! !
wVk!**compiled accessors**!public! !
wVk:!**compiled accessors**!public! !
!

!OS.INPUT class methodsFor!

byteSize
	^_INPUT_Size!

defineFields
	"Define the fields of the INPUT structure.

	INPUT compileDefinition

		typedef [uuid(6a520d8f-1dcb-456c-9933-95ee79174bd6), helpstring('Used by SendInput() to store information for synthesizing input events such as keystrokes, mouse movement, and mouse clicks.')]
		struct tagINPUT {
			[helpstring('Specifies the type of the input event')] INPUTSources Type;
			union {
				[helpstring('Contains information about a simulated mouse event.')] MOUSEINPUT mi;
				[helpstring('Contains information about a simulated keyboard event.')] KEYBDINPUT ki;
				[helpstring('Contains information about a simulated event from input hardware other than a keyboard or mouse.')] HARDWAREINPUT hi;
			};
		} INPUT;
"

	self
		defineField: #type
		type: Int32Field new
		offset: 0.


	"KEYBDINPUT"
	self
		defineField: #wVk
			type: UInt16Field new
			offset: 4;
		defineField: #wScan
			type: UInt16Field new
			offset: 6;
		defineField: #ki_dwFlags
			type: UInt32Field new
			offset: 8;
		defineField: #ki_time
			type: UInt32Field new
			offset: 12;
		defineField: #ki_dwExtraInfo
			type: UInt32Field new
			offset: 16.

	"MOUSEINPUT"
	self
		defineField: #dx
			type: Int32Field new
			offset: 4;
		defineField: #dy
			type: Int32Field new
			offset: 8;
		defineField: #mouseData
			type: UInt32Field new
			offset: 12;
		defineField: #mi_dwFlags
			type: UInt32Field new
			offset: 16;
		defineField: #mi_time
			type: UInt32Field new
			offset: 20;
		defineField: #mi_dwExtraInfo
			type: UIntPtrField new
			offset: 24.

	"HARDWAREINPUT"
	self
		defineField: #uMsg
			type: UInt32Field new
			offset: 4;
		defineField: #wParamL
			type: UInt16Field new
			offset: 8;
		defineField: #wParamH
			type: UInt16Field new
			offset: 10.
	self byteSize: 24 + VMConstants.IntPtrSize!

getFieldNames
	^#(#type #dx #uMsg #wVk #wScan #dy #ki_dwFlags #wParamL #wParamH #ki_time #mouseData #ki_dwExtraInfo #mi_dwFlags #mi_time #mi_dwExtraInfo)! !
!OS.INPUT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

