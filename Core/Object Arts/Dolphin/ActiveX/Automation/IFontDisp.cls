"Filed out from Dolphin Smalltalk 99 release 3.1"!

IDispatch subclass: #IFontDisp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

IFontDisp class instanceVariableNames: ''!

IFontDisp comment: '<IFontDisp> is a wrapper class generated for the dispatch interface ''stdole.Font'' from type information in the ''OLE Automation'' library (stdole2.tlb). It contains methods to get and set the properties exposed by that interface.

IFontDisp is a standard dispinterface used to represent OLE Fonts, for example to get/set the font ambient property of an ActiveX control site.'!

IFontDisp guid: (IID fromString: '{BEF6E003-A874-101A-8BBA-00AA00300CAB}')!

!IFontDisp categoriesForClass!COM-Interfaces! !

!IFontDisp methodsFor!

bold
	"Answer the <varbool> value of the 'bold' property of the object.
	
		VARIANT_BOOL Bold
	"

	^(self getPropertyId: 3)
!

bold: newVal
	"Set the 'bold' property of the object to the <varbool> value of the argument, newVal.
	
		VARIANT_BOOL Bold
	"

	self setPropertyId: 3 value: newVal
!

charset
	"Answer the <sword> value of the 'charset' property of the object.
	
		short Charset
	"

	^(self getPropertyId: 8)
!

charset: newVal
	"Set the 'charset' property of the object to the <sword> value of the argument, newVal.
	
		short Charset
	"

	self setPropertyId: 8 value: newVal
!

italic
	"Answer the <varbool> value of the 'italic' property of the object.
	
		VARIANT_BOOL Italic
	"

	^(self getPropertyId: 4)
!

italic: newVal
	"Set the 'italic' property of the object to the <varbool> value of the argument, newVal.
	
		VARIANT_BOOL Italic
	"

	self setPropertyId: 4 value: newVal
!

name
	"Answer the <bstr> value of the 'name' property of the object.
	
		BSTR Name
	"

	^(self getPropertyId: 0)
!

name: newVal
	"Set the 'name' property of the object to the <bstr> value of the argument, newVal.
	
		BSTR Name
	"

	self setPropertyId: 0 value: newVal
!

size
	"Answer the <cy> value of the 'size' property of the object.
	
		CURRENCY Size
	"

	^(self getPropertyId: 2)
!

size: newVal
	"Set the 'size' property of the object to the <cy> value of the argument, newVal.
	
		CURRENCY Size
	"

	self setPropertyId: 2 value: newVal
!

strikethrough
	"Answer the <varbool> value of the 'strikethrough' property of the object.
	
		VARIANT_BOOL Strikethrough
	"

	^(self getPropertyId: 6)
!

strikethrough: newVal
	"Set the 'strikethrough' property of the object to the <varbool> value of the argument, newVal.
	
		VARIANT_BOOL Strikethrough
	"

	self setPropertyId: 6 value: newVal
!

underline
	"Answer the <varbool> value of the 'underline' property of the object.
	
		VARIANT_BOOL Underline
	"

	^(self getPropertyId: 5)
!

underline: newVal
	"Set the 'underline' property of the object to the <varbool> value of the argument, newVal.
	
		VARIANT_BOOL Underline
	"

	self setPropertyId: 5 value: newVal
!

weight
	"Answer the <sword> value of the 'weight' property of the object.
	
		short Weight
	"

	^(self getPropertyId: 7)
!

weight: newVal
	"Set the 'weight' property of the object to the <sword> value of the argument, newVal.
	
		short Weight
	"

	self setPropertyId: 7 value: newVal
! !

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
!IFontDisp categoriesFor: #weight!**auto generated**!properties!public! !
!IFontDisp categoriesFor: #weight:!**auto generated**!properties!public! !

!IFontDisp class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (StdFont) for which the receiver is the default interface.
	"

	^CLSID fromString: '{0BE35203-8F91-11CE-9DE3-00AA004BB851}'
!

fromFont: aFont
	"Answer a new instance of the receiver on an OLE font object which is equivalent to the
	<Font>, aFont."

	| answer fd hr |
	fd := FONTDESC fromFont: aFont.
	answer := IFontDisp newPointer.
	hr := OLEAutLibrary default oleCreateFontIndirect: fd riid: IFontDisp iid ppvObj: answer.
	^answer
! !

!IFontDisp class categoriesFor: #clsid!**auto generated**!constants!private! !
!IFontDisp class categoriesFor: #fromFont:!instance creation!public! !

