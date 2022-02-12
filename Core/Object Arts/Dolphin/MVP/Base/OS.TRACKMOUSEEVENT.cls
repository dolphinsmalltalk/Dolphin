"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.TRACKMOUSEEVENT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFlags' -> 16r4.
		'_OffsetOf_dwHoverTime' -> 16rC.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_hwndTrack' -> 16r8.
		'_TRACKMOUSEEVENT_Size' -> 16r10
	}!
OS.TRACKMOUSEEVENT guid: (Core.GUID fromString: '{f8a7c94e-cff5-4d76-be3c-2de4f4f6a4ef}')!
OS.TRACKMOUSEEVENT comment: '<TRACKMOUSEEVENT> is an <ExternalStructure> class to wrap the struct ''Win32.TRACKMOUSEEVENT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Used in conjunction with the TrackMouseEvent function to track when the mouse pointer leaves a window or hovers over a window for a specified amount of time."

IDL definition follows:

typedef [uuid(F8A7C94E-CFF5-4D76-BE3C-2DE4F4F6A4EF), helpstring("Used in conjunction with the TrackMouseEvent function to track when the mouse pointer leaves a window or hovers over a window for a specified amount of time.")]
struct tagTRACKMOUSEEVENT {
	[helpstring("Specifies the size of the TRACKMOUSEEVENT structure.")] DWORD cbSize;
	[helpstring("Specifies the services requested.")] DWORD dwFlags;
	[helpstring("Specifies a handle to the window to track.")] HWND hwndTrack;
	[helpstring("Specifies the hover time-out (if TME_HOVER was specified in dwFlags), in milliseconds.")] DWORD dwHoverTime;
} TRACKMOUSEEVENT;
'!
!OS.TRACKMOUSEEVENT categoriesForClass!Win32-Structs! !
!OS.TRACKMOUSEEVENT methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwHoverTime
	"Answer the <Integer> value of the receiver's 'dwHoverTime' field."

	^bytes dwordAtOffset: _OffsetOf_dwHoverTime!

dwHoverTime: anInteger
	"Set the receiver's 'dwHoverTime' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwHoverTime put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

hwndTrack
	"Answer the <ExternalHandle> value of the receiver's 'hwndTrack' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwndTrack) asExternalHandle!

hwndTrack: anExternalHandle
	"Set the receiver's 'hwndTrack' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndTrack put: anExternalHandle! !
!OS.TRACKMOUSEEVENT categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwHoverTime!**compiled accessors**!public! !
dwHoverTime:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
hwndTrack!**compiled accessors**!public! !
hwndTrack:!**compiled accessors**!public! !
!

!OS.TRACKMOUSEEVENT class methodsFor!

byteSize
	^_TRACKMOUSEEVENT_Size!

defineFields
	"Define the fields of the TRACKMOUSEEVENT structure.
		TRACKMOUSEEVENT compileDefinition
	
		typedef [uuid(F8A7C94E-CFF5-4D76-BE3C-2DE4F4F6A4EF), helpstring('Used in conjunction with the TrackMouseEvent function to track when the mouse pointer leaves a window or hovers over a window for a specified amount of time.')]
		struct tagTRACKMOUSEEVENT {
			[helpstring('Specifies the size of the TRACKMOUSEEVENT structure.')] DWORD cbSize;
			[helpstring('Specifies the services requested.')] DWORD dwFlags;
			[helpstring('Specifies a handle to the window to track.')] HWND hwndTrack;
			[helpstring('Specifies the hover time-out (if TME_HOVER was specified in dwFlags), in milliseconds.')] DWORD dwHoverTime;
		} TRACKMOUSEEVENT;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #dwFlags type: DWORDField new;
		defineField: #hwndTrack type: HANDLEField new;
		defineField: #dwHoverTime type: DWORDField new!

getFieldNames
	^#(#dwSize #dwFlags #hwndTrack #dwHoverTime)! !
!OS.TRACKMOUSEEVENT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

