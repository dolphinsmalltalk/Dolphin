﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'OS.COM.IPictureDisp'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IPictureDisp guid: (OS.COM.IID fromString: '{7bf80981-bf32-101a-8bbb-00aa00300cab}')!

OS.COM.IPictureDisp comment: '`IPictureDisp` is a wrapper class generated for the dispatch interface ''stdole.Picture'' from type information in the ''OLE Automation'' library. It contains methods to get and set the properties and invoke the methods exposed by that interface.

The type library contains no documentation for this dispinterface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:
```
[
	uuid(7bf80981-bf32-101a-8bbb-00aa00300cab)
]
dispinterface Picture {
	properties:
		[
			id(0000000000), 
			readonly
		]
[readonly] OLE_HANDLE Handle;
		[
			id(0x00000002)
		]
OLE_HANDLE hPal;
		[
			id(0x00000003), 
			readonly
		]
[readonly] short Type;
		[
			id(0x00000004), 
			readonly
		]
[readonly] OLE_XSIZE_HIMETRIC Width;
		[
			id(0x00000005), 
			readonly
		]
[readonly] OLE_YSIZE_HIMETRIC Height;

	methods:
[id(0x00000006)]
		void Render(
			int hdc,
			long x,
			long y,
			long cx,
			long cy,
			OLE_XPOS_HIMETRIC xSrc,
			OLE_YPOS_HIMETRIC ySrc,
			OLE_XSIZE_HIMETRIC cxSrc,
			OLE_YSIZE_HIMETRIC cySrc,
			void* prcWBounds);
};
```
'!

!OS.COM.IPictureDisp categoriesForClass!COM-Interfaces! !

!OS.COM.IPictureDisp methodsFor!

handle
	"Answer the <sdword> value of the 'Handle' property of the receiver.
		OLE_HANDLE Handle"

	^self getPropertyId: 0!

height
	"Answer the <sdword> value of the 'Height' property of the receiver.
		OLE_YSIZE_HIMETRIC Height"

	^self getPropertyId: 5!

hPal
	"Answer the <sdword> value of the 'hPal' property of the receiver.
		OLE_HANDLE hPal"

	^self getPropertyId: 2!

hPal: newVal
	"Set the 'hPal' property of the receiver to the <sdword> value of the argument.
		OLE_HANDLE hPal"

	self setPropertyId: 2 value: newVal!

render: hdc x: x y: y cx: cx cy: cy xSrc: xSrc ySrc: ySrc cxSrc: cxSrc cySrc: cySrc prcWBounds: prcWBounds
	"Invoke the Render() method of the COM object."

	self invokeId: 6 withArguments: {hdc. x. y. cx. cy. xSrc. ySrc. cxSrc. cySrc. prcWBounds}!

type
	"Answer the <sword> value of the 'Type' property of the receiver.
		short Type"

	^self getPropertyId: 3!

value
	"Answer the <sdword> value of the 'Handle' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self handle!

value: newVal
	"Set the 'Handle' property of the receiver to the <sdword> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self handle: newVal!

width
	"Answer the <sdword> value of the 'Width' property of the receiver.
		OLE_XSIZE_HIMETRIC Width"

	^self getPropertyId: 4! !

!OS.COM.IPictureDisp categoriesForMethods!
handle!**auto generated**!properties!public! !
height!**auto generated**!properties!public! !
hPal!**auto generated**!properties!public! !
hPal:!**auto generated**!properties!public! !
render:x:y:cx:cy:xSrc:ySrc:cxSrc:cySrc:prcWBounds:!**auto generated**!methods!public! !
type!**auto generated**!properties!public! !
value!**auto generated**!properties!public! !
value:!**auto generated**!properties!public! !
width!**auto generated**!properties!public! !
!

!OS.COM.IPictureDisp class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (StdPicture) for which the receiver is the default interface."

	^CLSID fromString: '{0be35204-8f91-11ce-9de3-00aa004bb851}'! !

!OS.COM.IPictureDisp class categoriesForMethods!
clsid!**auto generated**!constants!private! !
!

