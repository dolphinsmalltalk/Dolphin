"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IFont
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IFont guid: (IID fromString: '{bef6e002-a874-101a-8bba-00aa00300cab}')!
IFont comment: '`IFont` is a wrapper class for the COM interface ''stdole.IFont'' generated from type information in the ''OLE Automation'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Font Object"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:
```
[
	object, 
	uuid(bef6e002-a874-101a-8bba-00aa00300cab), 
	helpstring("Font Object"), 
	hidden
]
interface IFont : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Name(
		[out, retval]BSTR* pname);
	[id(0x60010000), propput]
	HRESULT __stdcall Name(
		[in]BSTR pname);
	[id(0x60010002), propget]
	HRESULT __stdcall Size(
		[out, retval]CURRENCY* psize);
	[id(0x60010002), propput]
	HRESULT __stdcall Size(
		[in]CURRENCY psize);
	[id(0x60010004), propget]
	HRESULT __stdcall Bold(
		[out, retval]VARIANT_BOOL* pbold);
	[id(0x60010004), propput]
	HRESULT __stdcall Bold(
		[in]VARIANT_BOOL pbold);
	[id(0x60010006), propget]
	HRESULT __stdcall Italic(
		[out, retval]VARIANT_BOOL* pitalic);
	[id(0x60010006), propput]
	HRESULT __stdcall Italic(
		[in]VARIANT_BOOL pitalic);
	[id(0x60010008), propget]
	HRESULT __stdcall Underline(
		[out, retval]VARIANT_BOOL* punderline);
	[id(0x60010008), propput]
	HRESULT __stdcall Underline(
		[in]VARIANT_BOOL punderline);
	[id(0x6001000a), propget]
	HRESULT __stdcall Strikethrough(
		[out, retval]VARIANT_BOOL* pstrikethrough);
	[id(0x6001000a), propput]
	HRESULT __stdcall Strikethrough(
		[in]VARIANT_BOOL pstrikethrough);
	[id(0x6001000c), propget]
	HRESULT __stdcall Weight(
		[out, retval]short* pweight);
	[id(0x6001000c), propput]
	HRESULT __stdcall Weight(
		[in]short pweight);
	[id(0x6001000e), propget]
	HRESULT __stdcall Charset(
		[out, retval]short* pcharset);
	[id(0x6001000e), propput]
	HRESULT __stdcall Charset(
		[in]short pcharset);
	[id(0x60010010), propget]
	HRESULT __stdcall hFont(
		[out, retval]OLE_HANDLE* phfont);
	[id(0x60010011)]
	HRESULT __stdcall Clone(
		[out]IFont** ppfont);
	[id(0x60010012)]
	HRESULT __stdcall IsEqual(
		[in]IFont* pfontOther);
	[id(0x60010013)]
	HRESULT __stdcall SetRatio(
		[in]long cyLogical,
		[in]long cyHimetric);
	[id(0x60010014)]
	HRESULT __stdcall AddRefHfont(
		[in]OLE_HANDLE hFont);
	[id(0x60010015)]
	HRESULT __stdcall ReleaseHfont(
		[in]OLE_HANDLE hFont);
};
```
'!
!IFont categoriesForClass!COM-Interfaces! !
!IFont methodsFor!

= anObject 
	"Answer whether the <Object> argument, pfontOther, is equivalent to the
	receiver."

	^(anObject isKindOf: COMInterface) and: [self isEqual: anObject]!

addRefHfont: aFont 
	"Invoke the AddRefHfont() method of the COM Object."

	self AddRefHfont: aFont asParameter
!

AddRefHfont: hFont
	"Private - Invoke the AddRefHfont() method of the COM object wrapped by the receiver.

		HRESULT __stdcall AddRefHfont(
			[in] OLE_HANDLE hFont);
	"

	<virtual stdcall: hresult 24 handle>
	^self invalidCall: _failureCode!

bold
	"Answer the <varbool> value of the 'Bold' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Bold: answer.
	^answer asObject!

bold: pbold
	"Set the 'Bold' property of the receiver to the <varbool> value of the argument."

	self put_Bold: pbold!

charset
	"Answer the <sword> value of the 'Charset' property of the receiver."

	| answer |
	answer := SWORD new.
	self get_Charset: answer.
	^answer asObject!

charset: pcharset
	"Set the 'Charset' property of the receiver to the <sword> value of the argument."

	self put_Charset: pcharset!

clone
	"Answer the <IFont> result of invoking the Clone() method of the COM object."

	| answer |
	answer := IFont newPointer.
	self Clone: answer.
	^answer asObject!

Clone: ppfont
	"Private - Invoke the Clone() method of the COM object.

		HRESULT __stdcall Clone(
			[out]IFont** ppfont);"

	<virtual stdcall: hresult 21 IFont**>
	^self invalidCall: _failureCode!

get_Bold: pbold
	"Private - Get the value of the 'Bold' property of the receiver.

		HRESULT __stdcall Bold(
			[out, retval]VARIANT_BOOL* pbold);"

	<virtual stdcall: hresult 8 varbool*>
	^self invalidCall: _failureCode!

get_Charset: pcharset
	"Private - Get the value of the 'Charset' property of the receiver.

		HRESULT __stdcall Charset(
			[out, retval]short* pcharset);"

	<virtual stdcall: hresult 18 sword*>
	^self invalidCall: _failureCode!

get_hFont: phfont
	"Private - Get the value of the 'hFont' property of the receiver.

		HRESULT __stdcall hFont(
			[out, retval] OLE_HANDLE* phfont);"

	<virtual stdcall: hresult 20 handle*>
	^self invalidCall: _failureCode!

get_Italic: pitalic
	"Private - Get the value of the 'Italic' property of the receiver.

		HRESULT __stdcall Italic(
			[out, retval]VARIANT_BOOL* pitalic);"

	<virtual stdcall: hresult 10 varbool*>
	^self invalidCall: _failureCode!

get_Name: pname
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pname);"

	<virtual stdcall: hresult 4 bstr*>
	^self invalidCall: _failureCode!

get_Size: psize
	"Private - Get the value of the 'Size' property of the receiver.

		HRESULT __stdcall Size(
			[out, retval]CURRENCY* psize);"

	<virtual stdcall: hresult 6 CURRENCY*>
	^self invalidCall: _failureCode!

get_Strikethrough: pstrikethrough
	"Private - Get the value of the 'Strikethrough' property of the receiver.

		HRESULT __stdcall Strikethrough(
			[out, retval]VARIANT_BOOL* pstrikethrough);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall: _failureCode!

get_Underline: punderline
	"Private - Get the value of the 'Underline' property of the receiver.

		HRESULT __stdcall Underline(
			[out, retval]VARIANT_BOOL* punderline);"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall: _failureCode!

get_Weight: pweight
	"Private - Get the value of the 'Weight' property of the receiver.

		HRESULT __stdcall Weight(
			[out, retval]short* pweight);"

	<virtual stdcall: hresult 16 sword*>
	^self invalidCall: _failureCode!

hFont
	"Answer the handle of the font."

	| answer |
	answer := ExternalHandle new.
	self get_hFont: answer.
	^answer asObject!

isEqual: pfontOther
	"Invoke the IsEqual() method of the COM object."

	^(self IsEqual: pfontOther) == S_OK
!

IsEqual: pfontOther
	"Private - Invoke the IsEqual() method of the COM object.

		HRESULT __stdcall IsEqual(
			[in]IFont* pfontOther);"

	<virtual stdcall: hresult 22 IFont*>
	^self invalidCall: _failureCode!

italic
	"Answer the <varbool> value of the 'Italic' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Italic: answer.
	^answer asObject!

italic: pitalic
	"Set the 'Italic' property of the receiver to the <varbool> value of the argument."

	self put_Italic: pitalic!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject!

name: pname
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self put_Name: pname!

put_Bold: pbold
	"Private - Set the value of the 'Bold' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbold.

		HRESULT __stdcall Bold(
			[in]VARIANT_BOOL pbold);"

	<virtual stdcall: hresult 9 varbool>
	^self invalidCall: _failureCode!

put_Charset: pcharset
	"Private - Set the value of the 'Charset' property of the object wrapped by the 
	 receiver to the <sword> argument, pcharset.

		HRESULT __stdcall Charset(
			[in]short pcharset);"

	<virtual stdcall: hresult 19 sword>
	^self invalidCall: _failureCode!

put_Italic: pitalic
	"Private - Set the value of the 'Italic' property of the object wrapped by the 
	 receiver to the <varbool> argument, pitalic.

		HRESULT __stdcall Italic(
			[in]VARIANT_BOOL pitalic);"

	<virtual stdcall: hresult 11 varbool>
	^self invalidCall: _failureCode!

put_Name: pname
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pname.

		HRESULT __stdcall Name(
			[in]BSTR pname);"

	<virtual stdcall: hresult 5 bstr>
	^self invalidCall: _failureCode!

put_Size: psize
	"Private - Set the value of the 'Size' property of the object wrapped by the 
	 receiver to the <CURRENCY> argument, psize.

		HRESULT __stdcall Size(
			[in]CURRENCY psize);"

	<virtual stdcall: hresult 7 CURRENCY>
	^self invalidCall: _failureCode!

put_Strikethrough: pstrikethrough
	"Private - Set the value of the 'Strikethrough' property of the object wrapped by the 
	 receiver to the <varbool> argument, pstrikethrough.

		HRESULT __stdcall Strikethrough(
			[in]VARIANT_BOOL pstrikethrough);"

	<virtual stdcall: hresult 15 varbool>
	^self invalidCall: _failureCode!

put_Underline: punderline
	"Private - Set the value of the 'Underline' property of the object wrapped by the 
	 receiver to the <varbool> argument, punderline.

		HRESULT __stdcall Underline(
			[in]VARIANT_BOOL punderline);"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall: _failureCode!

put_Weight: pweight
	"Private - Set the value of the 'Weight' property of the object wrapped by the 
	 receiver to the <sword> argument, pweight.

		HRESULT __stdcall Weight(
			[in]short pweight);"

	<virtual stdcall: hresult 17 sword>
	^self invalidCall: _failureCode!

releaseHfont: aFont 
	"Invoke the ReleaseHfont() method of the COM Object."

	self ReleaseHfont: aFont asParameter
!

ReleaseHfont: hFont
	"Private - Invoke the ReleaseHfont() method of the COM object wrapped by the receiver.

		HRESULT __stdcall ReleaseHfont(
			[in] HFONT hFont);
	"

	<virtual stdcall: hresult 25 handle>
	^self invalidCall: _failureCode!

setRatio: cyLogical cyHimetric: cyHimetric
	"Invoke the SetRatio() method of the COM object."

	^self SetRatio: cyLogical cyHimetric: cyHimetric!

SetRatio: cyLogical cyHimetric: cyHimetric
	"Private - Invoke the SetRatio() method of the COM object.

		HRESULT __stdcall SetRatio(
			[in]long cyLogical,
			[in]long cyHimetric);"

	<virtual stdcall: hresult 23 sdword sdword>
	^self invalidCall: _failureCode!

size
	"Answer the <CURRENCY> value of the 'Size' property of the receiver."

	| answer |
	answer := CURRENCY new.
	self get_Size: answer.
	^answer asObject!

size: psize 
	"Set the 'Size' property of the receiver to the <CURRENCY> value of the argument."

	self put_Size: (CURRENCY new value: psize)!

strikethrough
	"Answer the <varbool> value of the 'Strikethrough' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Strikethrough: answer.
	^answer asObject!

strikethrough: pstrikethrough
	"Set the 'Strikethrough' property of the receiver to the <varbool> value of the argument."

	self put_Strikethrough: pstrikethrough!

underline
	"Answer the <varbool> value of the 'Underline' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Underline: answer.
	^answer asObject!

underline: punderline
	"Set the 'Underline' property of the receiver to the <varbool> value of the argument."

	self put_Underline: punderline!

weight
	"Answer the <sword> value of the 'Weight' property of the receiver."

	| answer |
	answer := SWORD new.
	self get_Weight: answer.
	^answer asObject!

weight: pweight
	"Set the 'Weight' property of the receiver to the <sword> value of the argument."

	self put_Weight: pweight! !
!IFont categoriesFor: #=!methods!public! !
!IFont categoriesFor: #addRefHfont:!methods!public! !
!IFont categoriesFor: #AddRefHfont:!COM Interfaces-IFont!private! !
!IFont categoriesFor: #bold!**auto generated**!properties!public! !
!IFont categoriesFor: #bold:!**auto generated**!properties!public! !
!IFont categoriesFor: #charset!**auto generated**!properties!public! !
!IFont categoriesFor: #charset:!**auto generated**!properties!public! !
!IFont categoriesFor: #clone!**auto generated**!methods!public! !
!IFont categoriesFor: #Clone:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Bold:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Charset:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_hFont:!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Italic:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Name:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Size:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Strikethrough:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Underline:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Weight:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #hFont!properties!public! !
!IFont categoriesFor: #isEqual:!methods!public! !
!IFont categoriesFor: #IsEqual:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #italic!**auto generated**!properties!public! !
!IFont categoriesFor: #italic:!**auto generated**!properties!public! !
!IFont categoriesFor: #name!**auto generated**!properties!public! !
!IFont categoriesFor: #name:!**auto generated**!properties!public! !
!IFont categoriesFor: #put_Bold:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Charset:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Italic:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Name:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Size:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Strikethrough:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Underline:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Weight:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #releaseHfont:!methods!public! !
!IFont categoriesFor: #ReleaseHfont:!COM Interfaces-IFont!private! !
!IFont categoriesFor: #setRatio:cyHimetric:!**auto generated**!methods!public! !
!IFont categoriesFor: #SetRatio:cyHimetric:!**auto generated**!COM Interfaces-IFont!private! !
!IFont categoriesFor: #size!**auto generated**!properties!public! !
!IFont categoriesFor: #size:!properties!public! !
!IFont categoriesFor: #strikethrough!**auto generated**!properties!public! !
!IFont categoriesFor: #strikethrough:!**auto generated**!properties!public! !
!IFont categoriesFor: #underline!**auto generated**!properties!public! !
!IFont categoriesFor: #underline:!**auto generated**!properties!public! !
!IFont categoriesFor: #weight!**auto generated**!properties!public! !
!IFont categoriesFor: #weight:!**auto generated**!properties!public! !

!IFont class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (StdFont) for which the receiver is the default interface.
	"

	^CLSID fromString: '{0BE35203-8F91-11CE-9DE3-00AA004BB851}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'stdole.IFont'
		IFont defineTemplate
	"

	self
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #put_Name:
			argumentTypes: 'bstr';
		defineFunction: #get_Size:
			argumentTypes: 'qword*';
		defineFunction: #put_Size:
			argumentTypes: 'qword';
		defineFunction: #get_Bold:
			argumentTypes: 'bool*';
		defineFunction: #put_Bold:
			argumentTypes: 'bool';
		defineFunction: #get_Italic:
			argumentTypes: 'bool*';
		defineFunction: #put_Italic:
			argumentTypes: 'bool';
		defineFunction: #get_Underline:
			argumentTypes: 'bool*';
		defineFunction: #put_Underline:
			argumentTypes: 'bool';
		defineFunction: #get_Strikethrough:
			argumentTypes: 'bool*';
		defineFunction: #put_Strikethrough:
			argumentTypes: 'bool';
		defineFunction: #get_Weight:
			argumentTypes: 'sword*';
		defineFunction: #put_Weight:
			argumentTypes: 'sword';
		defineFunction: #get_Charset:
			argumentTypes: 'sword*';
		defineFunction: #put_Charset:
			argumentTypes: 'sword';
		defineFunction: #get_hFont:
			argumentTypes: 'handle*';
		defineFunction: #Clone:
			argumentTypes: 'IFont**';
		defineFunction: #IsEqual:
			argumentTypes: 'IFont*';
		defineFunction: #SetRatio:cyHimetric:
			argumentTypes: 'sdword sdword';
		defineFunction: #AddRefHfont:
			argumentTypes: 'handle';
		defineFunction: #ReleaseHfont:
			argumentTypes: 'handle'
! !
!IFont class categoriesFor: #clsid!constants!private! !
!IFont class categoriesFor: #defineFunctions!initializing!public! !

