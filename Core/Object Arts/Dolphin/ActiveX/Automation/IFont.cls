"Filed out from Dolphin Smalltalk 2000 release 4.0"!

IUnknown subclass: #IFont
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

IFont class instanceVariableNames: ''!

IFont comment: '<IFont> is a wrapper class for the COM interface ''OCIDL.IFont'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

IFont guid: (IID fromString: '{BEF6E002-A874-101A-8BBA-00AA00300CAB}')!

!IFont categoriesForClass!COM-Interfaces! !

!IFont methodsFor!

= anObject
	"Answer whether the <Object> argument, pfontOther, is equivalent to the
	receiver."

	^(anObject isKindOf: COMInterface) and: [
		(self IsEqual: anObject) == S_OK]
!

addRefHfont: aFont 
	"Invoke the AddRefHfont() method of the COM Object."

	self AddRefHfont: aFont asParameter
!

AddRefHfont: hFont
	"Private - Invoke the AddRefHfont() method of the COM object wrapped by the receiver.

		HRESULT __stdcall AddRefHfont(
			[in] HFONT hFont);
	"

	<virtual stdcall: hresult 24 handle>
	^self invalidCall
!

bold
	"Answer the whether the receiver describes a bold font."

	| answer |
	answer := SDWORD new.
	self get_Bold: answer.
	^answer asInteger asBoolean!

bold: isBold 
	"Set the 'Bold' property of the receiver to the <boolean> argument."

	self put_Bold: isBold
!

charset
	"Answer the <sword> value of the 'Charset' property of the receiver."

	| answer |
	answer := (SWORD new).
	self
		get_Charset: answer.
	^answer asObject
!

charset: pcharset 
	"Set the 'Charset' property of the receiver to the <sword> value of the argument."

	self
		put_Charset: pcharset
!

clone
	"Answer the <IFont> result of invoking the COM Object's Clone() method."

	| answer |
	answer := IFont newPointer.
	self
		Clone: answer.
	^answer asObject
!

Clone: ppfont
	"Private - Invoke the Clone() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Clone(
			[out] IFont** ppfont);
	"

	<virtual stdcall: hresult 21 IFont**>
	^self invalidCall
!

get_Bold: pbold
	"Private - Get the value of the 'Bold' property of the receiver.

		HRESULT __stdcall Bold(
			[out, retval] BOOL* pbold);
	"

	<virtual stdcall: hresult 8 bool*>
	^self invalidCall
!

get_Charset: pcharset
	"Private - Get the value of the 'Charset' property of the receiver.

		HRESULT __stdcall Charset(
			[out, retval] short* pcharset);
	"

	<virtual stdcall: hresult 18 sword*>
	^self invalidCall
!

get_hFont: phfont
	"Private - Get the value of the 'hFont' property of the receiver.

		HRESULT __stdcall hFont(
			[out, retval] HFONT* phfont);
	"

	<virtual stdcall: hresult 20 handle*>
	^self invalidCall
!

get_Italic: pitalic
	"Private - Get the value of the 'Italic' property of the receiver.

		HRESULT __stdcall Italic(
			[out, retval] BOOL* pitalic);
	"

	<virtual stdcall: hresult 10 bool*>
	^self invalidCall
!

get_Name: pname
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval] BSTR* pname);
	"

	<virtual stdcall: hresult 4 bstr*>
	^self invalidCall
!

get_Size: psize
	"Private - Get the value of the 'Size' property of the receiver.

		HRESULT __stdcall Size(
			[out, retval] CURRENCY* psize);
	"

	<virtual stdcall: hresult 6 qword*>
	^self invalidCall
!

get_Strikethrough: pstrikethrough
	"Private - Get the value of the 'Strikethrough' property of the receiver.

		HRESULT __stdcall Strikethrough(
			[out, retval] BOOL* pstrikethrough);
	"

	<virtual stdcall: hresult 14 bool*>
	^self invalidCall
!

get_Underline: punderline
	"Private - Get the value of the 'Underline' property of the receiver.

		HRESULT __stdcall Underline(
			[out, retval] BOOL* punderline);
	"

	<virtual stdcall: hresult 12 bool*>
	^self invalidCall
!

get_Weight: pweight
	"Private - Get the value of the 'Weight' property of the receiver.

		HRESULT __stdcall Weight(
			[out, retval] short* pweight);
	"

	<virtual stdcall: hresult 16 sword*>
	^self invalidCall
!

hFont
	"Answer the handle of the font."

	| answer |
	answer := ExternalHandle new.
	self
		get_hFont: answer.
	^answer asObject
!

IsEqual: pfontOther
	"Private - Invoke the IsEqual() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsEqual(
			[in] IFont* pfontOther);
	"

	<virtual stdcall: hresult 22 IFont*>
	^self invalidCall
!

italic
	"Answer whether the receiver describes an italic font."

	| answer |
	answer := SDWORD new.
	self get_Italic: answer.
	^answer asInteger asBoolean
!

italic: isItalic 
	"Set the 'Italic' property of the receiver to the <boolean> argument."

	self
		put_Italic: isItalic
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Name: answer.
	^answer asObject
!

name: pname 
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self
		put_Name: pname
!

put_Bold: isBold
	"Private - Set the value of the 'Bold' property of the object wrapped by the 
	 receiver to the <boolean> argument, isBold.

		HRESULT __stdcall Bold(
			[in] BOOL pbold);
	"

	<virtual stdcall: hresult 9 bool>
	^self invalidCall
!

put_Charset: pcharset
	"Private - Set the value of the 'Charset' property of the object wrapped by the 
	 receiver to the <sword> argument, pcharset.

		HRESULT __stdcall Charset(
			[in] short pcharset);
	"

	<virtual stdcall: hresult 19 sword>
	^self invalidCall
!

put_Italic: isItalic
	"Private - Set the value of the 'Italic' property of the object wrapped by the 
	 receiver to the <varbool> argument, isItalic.

		HRESULT __stdcall Italic(
			[in] BOOL pitalic);
	"

	<virtual stdcall: hresult 11 bool>
	^self invalidCall
!

put_Name: pname
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pname.

		HRESULT __stdcall Name(
			[in] BSTR pname);
	"

	<virtual stdcall: hresult 5 bstr>
	^self invalidCall
!

put_Size: psize
	"Private - Set the value of the 'Size' property of the object wrapped by the 
	 receiver to the <qword> argument, psize.

		HRESULT __stdcall Size(
			[in] CY psize);
	"

	<virtual stdcall: hresult 7 qword>
	^self invalidCall
!

put_Strikethrough: isStruckThrough
	"Private - Set the value of the 'Strikethrough' property of the object wrapped by the 
	 receiver to the <boolean> argument, isStruckThrough.

		HRESULT __stdcall Strikethrough(
			[in] BOOL isStruckThrough);
	"

	<virtual stdcall: hresult 15 bool>
	^self invalidCall
!

put_Underline: isUnderlined
	"Private - Set the value of the 'Underline' property of the object wrapped by the 
	 receiver to the <boolean> argument, isUnderlined.

		HRESULT __stdcall Underline(
			[in] BOOL isUnderlined);
	"

	<virtual stdcall: hresult 13 bool>
	^self invalidCall
!

put_Weight: pweight
	"Private - Set the value of the 'Weight' property of the object wrapped by the 
	 receiver to the <sword> argument, pweight.

		HRESULT __stdcall Weight(
			[in] short pweight);
	"

	<virtual stdcall: hresult 17 sword>
	^self invalidCall
!

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
	^self invalidCall
!

setRatio: cyLogical cyHimetric: cyHimetric 
	"Invoke the SetRatio() method of the COM Object."

	self
		SetRatio: cyLogical
		cyHimetric: cyHimetric
!

SetRatio: cyLogical cyHimetric: cyHimetric
	"Private - Invoke the SetRatio() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetRatio(
			[in] long cyLogical,
			[in] long cyHimetric);
	"

	<virtual stdcall: hresult 23 sdword sdword>
	^self invalidCall
!

size
	"Answer the <qword> value of the 'Size' property of the receiver."

	| answer |
	answer := (ULARGE_INTEGER new).
	self
		get_Size: answer.
	^answer asObject
!

size: psize 
	"Set the 'Size' property of the receiver to the <qword> value of the argument."

	self
		put_Size: psize
!

strikethrough
	"Answer whether the receiver is describing a struckthrough font."

	| answer |
	answer := SDWORD new.
	self get_Strikethrough: answer.
	^answer asInteger asBoolean
!

strikethrough: isStruckThrough 
	"Set the 'Strikethrough' property of the receiver to the <boolean> argument."

	self put_Strikethrough: isStruckThrough
!

underline
	"Answer whether the receiver describes an underlined font."

	| answer |
	answer := SDWORD new.
	self get_Underline: answer.
	^answer asInteger asBoolean
!

underline: isUnderlined 
	"Set the 'Underline' property of the receiver to the <boolean> argument."

	self put_Underline: isUnderlined
!

weight
	"Answer the <sword> value of the 'Weight' property of the receiver."

	| answer |
	answer := (SWORD new).
	self
		get_Weight: answer.
	^answer asObject
!

weight: pweight 
	"Set the 'Weight' property of the receiver to the <sword> value of the argument."

	self
		put_Weight: pweight
! !

!IFont categoriesFor: #=!methods!public! !
!IFont categoriesFor: #addRefHfont:!methods!public! !
!IFont categoriesFor: #AddRefHfont:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #bold!properties!public! !
!IFont categoriesFor: #bold:!properties!public! !
!IFont categoriesFor: #charset!properties!public! !
!IFont categoriesFor: #charset:!properties!public! !
!IFont categoriesFor: #clone!methods!public! !
!IFont categoriesFor: #Clone:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Bold:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Charset:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_hFont:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Italic:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Name:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Size:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Strikethrough:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Underline:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #get_Weight:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #hFont!properties!public! !
!IFont categoriesFor: #IsEqual:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #italic!properties!public! !
!IFont categoriesFor: #italic:!properties!public! !
!IFont categoriesFor: #name!properties!public! !
!IFont categoriesFor: #name:!properties!public! !
!IFont categoriesFor: #put_Bold:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Charset:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Italic:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Name:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Size:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Strikethrough:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Underline:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #put_Weight:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #releaseHfont:!methods!public! !
!IFont categoriesFor: #ReleaseHfont:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #setRatio:cyHimetric:!methods!public! !
!IFont categoriesFor: #SetRatio:cyHimetric:!*-primitives!COM Interfaces-IFont!private! !
!IFont categoriesFor: #size!properties!public! !
!IFont categoriesFor: #size:!properties!public! !
!IFont categoriesFor: #strikethrough!properties!public! !
!IFont categoriesFor: #strikethrough:!properties!public! !
!IFont categoriesFor: #underline!properties!public! !
!IFont categoriesFor: #underline:!properties!public! !
!IFont categoriesFor: #weight!properties!public! !
!IFont categoriesFor: #weight:!properties!public! !

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

