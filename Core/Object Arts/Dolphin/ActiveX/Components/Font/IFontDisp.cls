"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IFontDisp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IFontDisp guid: (IID fromString: '{bef6e003-a874-101a-8bba-00aa00300cab}')!
IFontDisp comment: '`IFontDisp` is a wrapper class generated for the dispatch interface ''stdole.Font'' from type information in the ''OLE Automation'' library. It contains methods to get and set the properties and invoke the methods exposed by that interface.

IFontDisp is a standard dispinterface used to represent OLE Fonts, for example to get/set the font ambient property of an ActiveX control site.

IDL definition follows:
```
[
	uuid(bef6e003-a874-101a-8bba-00aa00300cab)
]
dispinterface Font {
	properties:
		[
			id(0000000000)
		]
BSTR Name;
		[
			id(0x00000002)
		]
CURRENCY Size;
		[
			id(0x00000003)
		]
VARIANT_BOOL Bold;
		[
			id(0x00000004)
		]
VARIANT_BOOL Italic;
		[
			id(0x00000005)
		]
VARIANT_BOOL Underline;
		[
			id(0x00000006)
		]
VARIANT_BOOL Strikethrough;
		[
			id(0x00000007)
		]
short Weight;
		[
			id(0x00000008)
		]
short Charset;

	methods:

};
```
'!
!IFontDisp categoriesForClass!COM-Interfaces! !
!IFontDisp methodsFor!

bold
	"Answer the <varbool> value of the 'Bold' property of the receiver.
		VARIANT_BOOL Bold"

	^self getPropertyId: 3!

bold: newVal
	"Set the 'Bold' property of the receiver to the <varbool> value of the argument.
		VARIANT_BOOL Bold"

	self setPropertyId: 3 value: newVal!

charset
	"Answer the <sword> value of the 'Charset' property of the receiver.
		short Charset"

	^self getPropertyId: 8!

charset: newVal
	"Set the 'Charset' property of the receiver to the <sword> value of the argument.
		short Charset"

	self setPropertyId: 8 value: newVal!

italic
	"Answer the <varbool> value of the 'Italic' property of the receiver.
		VARIANT_BOOL Italic"

	^self getPropertyId: 4!

italic: newVal
	"Set the 'Italic' property of the receiver to the <varbool> value of the argument.
		VARIANT_BOOL Italic"

	self setPropertyId: 4 value: newVal!

name
	"Answer the <bstr> value of the 'Name' property of the receiver.
		BSTR Name"

	^self getPropertyId: 0!

name: newVal
	"Set the 'Name' property of the receiver to the <bstr> value of the argument.
		BSTR Name"

	self setPropertyId: 0 value: newVal!

size
	"Answer the <CURRENCY> value of the 'Size' property of the receiver.
		CURRENCY Size"

	^self getPropertyId: 2!

size: newVal
	"Set the 'Size' property of the receiver to the <CURRENCY> value of the argument.
		CURRENCY Size"

	self setPropertyId: 2 value: newVal!

strikethrough
	"Answer the <varbool> value of the 'Strikethrough' property of the receiver.
		VARIANT_BOOL Strikethrough"

	^self getPropertyId: 6!

strikethrough: newVal
	"Set the 'Strikethrough' property of the receiver to the <varbool> value of the argument.
		VARIANT_BOOL Strikethrough"

	self setPropertyId: 6 value: newVal!

underline
	"Answer the <varbool> value of the 'Underline' property of the receiver.
		VARIANT_BOOL Underline"

	^self getPropertyId: 5!

underline: newVal
	"Set the 'Underline' property of the receiver to the <varbool> value of the argument.
		VARIANT_BOOL Underline"

	self setPropertyId: 5 value: newVal!

value
	"Answer the <bstr> value of the 'Name' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self name!

value: newVal
	"Set the 'Name' property of the receiver to the <bstr> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self name: newVal!

weight
	"Answer the <sword> value of the 'Weight' property of the receiver.
		short Weight"

	^self getPropertyId: 7!

weight: newVal
	"Set the 'Weight' property of the receiver to the <sword> value of the argument.
		short Weight"

	self setPropertyId: 7 value: newVal! !
!IFontDisp categoriesFor: #bold!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #bold:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #charset!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #charset:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #italic!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #italic:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #name!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #name:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #size!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #size:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #strikethrough!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #strikethrough:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #underline!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #underline:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #value!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #value:!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #weight!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #weight:!**auto generated**!properties!public! !

!IFontDisp class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (StdFont) for which the receiver is the default interface."

	^CLSID fromString: '{0be35203-8f91-11ce-9de3-00aa004bb851}'
!

fromFont: aFont 
	"Answer a new instance of the receiver on an OLE font object which is equivalent to the
	<Font>, aFont."

	| answer fd |
	fd := FONTDESC fromFont: aFont.
	answer := IFontDisp newPointer.
	OLEAutLibrary default 
		oleCreateFontIndirect: fd
		riid: IFontDisp iid
		ppvObj: answer.
	^answer! !
!IFontDisp class categoriesFor: #clsid!**auto generated**!constants!private! !
!IFontDisp class categoriesFor: #fromFont:!instance creation!public! !

