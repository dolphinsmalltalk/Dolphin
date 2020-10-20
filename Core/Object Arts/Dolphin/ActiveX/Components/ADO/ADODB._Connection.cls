"Filed out from Dolphin Smalltalk 7"!

ADODB.Connection15 subclass: #'ADODB._Connection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._Connection guid: (OS.COM.IID fromString: '{00001550-0000-0010-8000-00aa006d2ea4}')!
ADODB._Connection comment: '`_Connection` is a wrapper class for the COM interface ''ADODB._Connection'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001550-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c901), 
	dual
]
interface _Connection : Connection15
 {
	[id(0x00000015), helpcontext(0x0012c8b8)]
	HRESULT __stdcall Cancel();
};
```
'!
!ADODB._Connection categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._Connection methodsFor!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 37>
	^self invalidCall: _failureCode! !
!ADODB._Connection categoriesFor: #Cancel!**auto generated**!COM Interfaces-_Connection!public! !

!ADODB._Connection class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Connection) for which the receiver is the default interface."

	^CLSID fromString: '{00000514-0000-0010-8000-00aa006d2ea4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Connection'
		_Connection defineTemplate"

	self
		defineFunction: #Cancel
! !
!ADODB._Connection class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB._Connection class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

