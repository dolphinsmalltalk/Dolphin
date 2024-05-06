"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GdiplusStartupOutput
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_NotificationHook _OffsetOf_NotificationUnhook'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusStartupOutput guid: (GUID fromString: '{40bb7e65-cd3b-49aa-b850-f404c6d944fc}')!

GdiplusStartupOutput addClassConstant: '_OffsetOf_NotificationHook' value: 16r0!
GdiplusStartupOutput addClassConstant: '_OffsetOf_NotificationUnhook' value: 16r4!

GdiplusStartupOutput comment: '<GdiplusStartupOutput> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GdiplusStartupOutput'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains the following helpstring for this struct
	"The 2 fields are NULL if SuppressBackgroundThread is FALSE. Otherwise, they are functions which must be called on the apps main message loop to replace the background thread. "

IDL definition follows:

typedef [uuid(40BB7E65-CD3B-49AA-B850-F404C6D944FC), helpstring("The 2 fields are NULL if SuppressBackgroundThread is FALSE. Otherwise, they are functions which must be called on the apps main message loop to replace the background thread. ")]
struct tagGdiplusStartupOutput {
	[helpstring("''NotificationHook'' should be called before starting the message loop")] void* NotificationHook;
	[helpstring("''NotificationUnhook'' should be called after the message loop ends.")] void* NotificationUnhook;
} GdiplusStartupOutput;
'!

!GdiplusStartupOutput categoriesForClass!Unclassified! !

!GdiplusStartupOutput methodsFor!

NotificationHook
	"Answer the <ExternalAddress> value of the receiver's 'NotificationHook' field."

	^(bytes uintPtrAtOffset: _OffsetOf_NotificationHook) asExternalAddress!

NotificationHook: anExternalAddress
	"Set the receiver's 'NotificationHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_NotificationHook put: anExternalAddress!

NotificationUnhook
	"Answer the <ExternalAddress> value of the receiver's 'NotificationUnhook' field."

	^(bytes uintPtrAtOffset: _OffsetOf_NotificationUnhook) asExternalAddress!

NotificationUnhook: anExternalAddress
	"Set the receiver's 'NotificationUnhook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_NotificationUnhook put: anExternalAddress! !

!GdiplusStartupOutput categoriesForMethods!
NotificationHook!**compiled accessors**!public! !
NotificationHook:!**compiled accessors**!public! !
NotificationUnhook!**compiled accessors**!public! !
NotificationUnhook:!**compiled accessors**!public! !
!

!GdiplusStartupOutput class methodsFor!

defineFields
	"Define the fields of the GdiplusStartupOutput structure.
		GdiplusStartupOutput compileDefinition
	
		typedef [uuid(40BB7E65-CD3B-49AA-B850-F404C6D944FC), helpstring('The 2 fields are NULL if SuppressBackgroundThread is FALSE. Otherwise, they are functions which must be called on the apps main message loop to replace the background thread. ')]
		struct tagGdiplusStartupOutput {
			[helpstring(''NotificationHook' should be called before starting the message loop')] void* NotificationHook;
			[helpstring(''NotificationUnhook' should be called after the message loop ends.')] void* NotificationUnhook;
		} GdiplusStartupOutput;
"

	self
		defineField: #NotificationHook type: LPVOIDField new offset: 0;
		defineField: #NotificationUnhook type: LPVOIDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#NotificationHook #NotificationUnhook)! !

!GdiplusStartupOutput class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

