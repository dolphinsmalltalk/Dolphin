"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'ADODB._Stream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._Stream guid: (OS.COM.IID fromString: '{00001565-0000-0010-8000-00aa006d2ea4}')!
ADODB._Stream comment: '`_Stream` is a wrapper class for the COM interface ''ADODB._Stream'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001565-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012ccc7), 
	hidden, 
	dual
]
interface _Stream : IDispatch
 {
	[id(0x00000001), propget, helpcontext(0x0012ccb2)]
	HRESULT __stdcall Size(
		[out, retval]long* pSize);
	[id(0x00000002), propget, helpcontext(0x0012ccb3)]
	HRESULT __stdcall EOS(
		[out, retval]VARIANT_BOOL* pEOS);
	[id(0x00000003), propget, helpcontext(0x0012ccb4)]
	HRESULT __stdcall Position(
		[out, retval]long* pPos);
	[id(0x00000003), propput, helpcontext(0x0012ccb4)]
	HRESULT __stdcall Position(
		[in]long pPos);
	[id(0x00000004), propget, helpcontext(0x0012ccb5)]
	HRESULT __stdcall Type(
		[out, retval]StreamTypeEnum* ptype);
	[id(0x00000004), propput, helpcontext(0x0012ccb5)]
	HRESULT __stdcall Type(
		[in]StreamTypeEnum ptype);
	[id(0x00000005), propget, helpcontext(0x0012ccb6)]
	HRESULT __stdcall LineSeparator(
		[out, retval]LineSeparatorEnum* pLS);
	[id(0x00000005), propput, helpcontext(0x0012ccb6)]
	HRESULT __stdcall LineSeparator(
		[in]LineSeparatorEnum pLS);
	[id(0x00000006), propget, helpcontext(0x0012ccb7)]
	HRESULT __stdcall State(
		[out, retval]ObjectStateEnum* pState);
	[id(0x00000007), propget, helpcontext(0x0012ccb8)]
	HRESULT __stdcall Mode(
		[out, retval]ConnectModeEnum* pMode);
	[id(0x00000007), propput, helpcontext(0x0012ccb8)]
	HRESULT __stdcall Mode(
		[in]ConnectModeEnum pMode);
	[id(0x00000008), propget, helpcontext(0x0012ccb9)]
	HRESULT __stdcall Charset(
		[out, retval]BSTR* pbstrCharset);
	[id(0x00000008), propput, helpcontext(0x0012ccb9)]
	HRESULT __stdcall Charset(
		[in]BSTR pbstrCharset);
	[id(0x00000009), helpcontext(0x0012ccba)]
	HRESULT __stdcall Read(
		[in, defaultvalue(-1)]long NumBytes,
		[out, retval]VARIANT* pval);
	[id(0x0000000a), helpcontext(0x0012ccbb)]
	HRESULT __stdcall Open(
		[in, optional]VARIANT Source,
		[in, defaultvalue(0)]ConnectModeEnum Mode,
		[in, defaultvalue(-1)]StreamOpenOptionsEnum Options,
		[in, defaultvalue("")]BSTR UserName,
		[in, defaultvalue("")]BSTR Password);
	[id(0x0000000b), helpcontext(0x0012ccbc)]
	HRESULT __stdcall Close();
	[id(0x0000000c), helpcontext(0x0012ccbd)]
	HRESULT __stdcall SkipLine();
	[id(0x0000000d), helpcontext(0x0012ccbe)]
	HRESULT __stdcall Write(
		[in]VARIANT Buffer);
	[id(0x0000000e), helpcontext(0x0012ccbf)]
	HRESULT __stdcall SetEOS();
	[id(0x0000000f), helpcontext(0x0012ccc0)]
	HRESULT __stdcall CopyTo(
		[in]_Stream* DestStream,
		[in, defaultvalue(-1)]long CharNumber);
	[id(0x00000010), helpcontext(0x0012ccc1)]
	HRESULT __stdcall Flush();
	[id(0x00000011), helpcontext(0x0012ccc2)]
	HRESULT __stdcall SaveToFile(
		[in]BSTR FileName,
		[in, defaultvalue(1)]SaveOptionsEnum Options);
	[id(0x00000012), helpcontext(0x0012ccc3)]
	HRESULT __stdcall LoadFromFile(
		[in]BSTR FileName);
	[id(0x00000013), helpcontext(0x0012ccc4)]
	HRESULT __stdcall ReadText(
		[in, defaultvalue(-1)]long NumChars,
		[out, retval]BSTR* pbstr);
	[id(0x00000014), helpcontext(0x0012ccc5)]
	HRESULT __stdcall WriteText(
		[in]BSTR Data,
		[in, defaultvalue(0)]StreamWriteEnum Options);
	[id(0x00000015), helpcontext(0x0012ccc6)]
	HRESULT __stdcall Cancel();
};
```
'!
!ADODB._Stream categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._Stream methodsFor!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 33>
	^self invalidCall: _failureCode!

charset
	"Answer the <bstr> value of the 'Charset' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Charset: answer.
	^answer asObject!

charset: pbstrCharset
	"Set the 'Charset' property of the receiver to the <bstr> value of the argument."

	self put_Charset: pbstrCharset!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 23>
	^self invalidCall: _failureCode!

copyTo: destStream
	"Invoke the CopyTo() method of the COM object.
	Default values are passed for all optional parameters."

	^self CopyTo: destStream CharNumber: -1!

CopyTo: destStream CharNumber: charNumber
	"Invoke the CopyTo() method of the COM object.

		HRESULT __stdcall CopyTo(
			[in]_Stream* DestStream,
			[in, defaultvalue(-1)]long CharNumber);"

	<virtual stdcall: hresult 27 _Stream* sdword>
	^self invalidCall: _failureCode!

eos
	"Answer the <varbool> value of the 'EOS' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_EOS: answer.
	^answer asObject!

Flush
	"Invoke the Flush() method of the COM object.

		HRESULT __stdcall Flush();"

	<virtual stdcall: hresult 28>
	^self invalidCall: _failureCode!

get_Charset: pbstrCharset
	"Private - Get the value of the 'Charset' property of the receiver.

		HRESULT __stdcall Charset(
			[out, retval]BSTR* pbstrCharset);"

	<virtual stdcall: hresult 19 bstr*>
	^self invalidCall: _failureCode!

get_EOS: pEOS
	"Private - Get the value of the 'EOS' property of the receiver.

		HRESULT __stdcall EOS(
			[out, retval]VARIANT_BOOL* pEOS);"

	<virtual stdcall: hresult 9 varbool*>
	^self invalidCall: _failureCode!

get_LineSeparator: pLS
	"Private - Get the value of the 'LineSeparator' property of the receiver.

		HRESULT __stdcall LineSeparator(
			[out, retval]LineSeparatorEnum* pLS);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_Mode: pMode
	"Private - Get the value of the 'Mode' property of the receiver.

		HRESULT __stdcall Mode(
			[out, retval]ConnectModeEnum* pMode);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall: _failureCode!

get_Position: pPos
	"Private - Get the value of the 'Position' property of the receiver.

		HRESULT __stdcall Position(
			[out, retval]long* pPos);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_Size: pSize
	"Private - Get the value of the 'Size' property of the receiver.

		HRESULT __stdcall Size(
			[out, retval]long* pSize);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_State: pState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]ObjectStateEnum* pState);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall: _failureCode!

get_Type: ptype
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval]StreamTypeEnum* ptype);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

lineSeparator
	"Answer the <sdword> value of the 'LineSeparator' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_LineSeparator: answer.
	^answer asObject!

lineSeparator: pLS
	"Set the 'LineSeparator' property of the receiver to the <sdword> value of the argument."

	self put_LineSeparator: pLS!

LoadFromFile: fileName
	"Invoke the LoadFromFile() method of the COM object.

		HRESULT __stdcall LoadFromFile(
			[in]BSTR FileName);"

	<virtual stdcall: hresult 30 bstr>
	^self invalidCall: _failureCode!

mode
	"Answer the <sdword> value of the 'Mode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Mode: answer.
	^answer asObject!

mode: pMode
	"Set the 'Mode' property of the receiver to the <sdword> value of the argument."

	self put_Mode: pMode!

open
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		open: VARIANT unspecified
		mode: 0
		options: -1
		userName: ''
		password: ''!

open: source mode: mode options: options userName: userName password: password
	"Invoke the Open() method of the COM object."

	^self
		Open: source asVariant
		Mode: mode
		Options: options
		UserName: userName
		Password: password!

Open: source Mode: mode Options: options UserName: userName Password: password
	"Private - Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in, optional]VARIANT Source,
			[in, defaultvalue(0)]ConnectModeEnum Mode,
			[in, defaultvalue(-1)]StreamOpenOptionsEnum Options,
			[in, defaultvalue('')]BSTR UserName,
			[in, defaultvalue('')]BSTR Password);"

	<virtual stdcall: hresult 22 variant sdword sdword bstr bstr>
	^self invalidCall: _failureCode!

position
	"Answer the <sdword> value of the 'Position' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Position: answer.
	^answer asObject!

position: pPos
	"Set the 'Position' property of the receiver to the <sdword> value of the argument."

	self put_Position: pPos!

put_Charset: pbstrCharset
	"Private - Set the value of the 'Charset' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrCharset.

		HRESULT __stdcall Charset(
			[in]BSTR pbstrCharset);"

	<virtual stdcall: hresult 20 bstr>
	^self invalidCall: _failureCode!

put_LineSeparator: pLS
	"Private - Set the value of the 'LineSeparator' property of the object wrapped by the 
	 receiver to the <sdword> argument, pLS.

		HRESULT __stdcall LineSeparator(
			[in]LineSeparatorEnum pLS);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall: _failureCode!

put_Mode: pMode
	"Private - Set the value of the 'Mode' property of the object wrapped by the 
	 receiver to the <sdword> argument, pMode.

		HRESULT __stdcall Mode(
			[in]ConnectModeEnum pMode);"

	<virtual stdcall: hresult 18 sdword>
	^self invalidCall: _failureCode!

put_Position: pPos
	"Private - Set the value of the 'Position' property of the object wrapped by the 
	 receiver to the <sdword> argument, pPos.

		HRESULT __stdcall Position(
			[in]long pPos);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall: _failureCode!

put_Type: ptype
	"Private - Set the value of the 'Type' property of the object wrapped by the 
	 receiver to the <sdword> argument, ptype.

		HRESULT __stdcall Type(
			[in]StreamTypeEnum ptype);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall: _failureCode!

read
	"Answer the <variant> result of invoking the Read() method of the COM object.
	Default values are passed for all optional parameters."

	^self read: -1!

read: numBytes
	"Answer the <variant> result of invoking the Read() method of the COM object."

	| answer |
	answer := VARIANT new.
	self Read: numBytes pval: answer.
	^answer asObject!

Read: numBytes pval: pval
	"Private - Invoke the Read() method of the COM object.

		HRESULT __stdcall Read(
			[in, defaultvalue(-1)]long NumBytes,
			[out, retval]VARIANT* pval);"

	<virtual stdcall: hresult 21 sdword variant*>
	^self invalidCall: _failureCode!

readText
	"Answer the <bstr> result of invoking the ReadText() method of the COM object.
	Default values are passed for all optional parameters."

	^self readText: -1!

readText: numChars
	"Answer the <bstr> result of invoking the ReadText() method of the COM object."

	| answer |
	answer := BSTR new.
	self ReadText: numChars pbstr: answer.
	^answer asObject!

ReadText: numChars pbstr: pbstr
	"Private - Invoke the ReadText() method of the COM object.

		HRESULT __stdcall ReadText(
			[in, defaultvalue(-1)]long NumChars,
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 31 sdword bstr*>
	^self invalidCall: _failureCode!

saveToFile: fileName
	"Invoke the SaveToFile() method of the COM object.
	Default values are passed for all optional parameters."

	^self SaveToFile: fileName Options: 1!

SaveToFile: fileName Options: options
	"Invoke the SaveToFile() method of the COM object.

		HRESULT __stdcall SaveToFile(
			[in]BSTR FileName,
			[in, defaultvalue(1)]SaveOptionsEnum Options);"

	<virtual stdcall: hresult 29 bstr sdword>
	^self invalidCall: _failureCode!

SetEOS
	"Invoke the SetEOS() method of the COM object.

		HRESULT __stdcall SetEOS();"

	<virtual stdcall: hresult 26>
	^self invalidCall: _failureCode!

size
	"Answer the <sdword> value of the 'Size' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Size: answer.
	^answer asObject!

SkipLine
	"Invoke the SkipLine() method of the COM object.

		HRESULT __stdcall SkipLine();"

	<virtual stdcall: hresult 24>
	^self invalidCall: _failureCode!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Type: answer.
	^answer asObject!

type: ptype
	"Set the 'Type' property of the receiver to the <sdword> value of the argument."

	self put_Type: ptype!

write: buffer
	"Invoke the Write() method of the COM object."

	^self Write: buffer asVariant!

Write: buffer
	"Private - Invoke the Write() method of the COM object.

		HRESULT __stdcall Write(
			[in]VARIANT Buffer);"

	<virtual stdcall: hresult 25 variant>
	^self invalidCall: _failureCode!

writeText: data
	"Invoke the WriteText() method of the COM object.
	Default values are passed for all optional parameters."

	^self WriteText: data Options: 0!

WriteText: data Options: options
	"Invoke the WriteText() method of the COM object.

		HRESULT __stdcall WriteText(
			[in]BSTR Data,
			[in, defaultvalue(0)]StreamWriteEnum Options);"

	<virtual stdcall: hresult 32 bstr sdword>
	^self invalidCall: _failureCode! !
!ADODB._Stream categoriesFor: #Cancel!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #charset!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #charset:!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #Close!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #copyTo:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #CopyTo:CharNumber:!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #eos!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #Flush!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #get_Charset:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_EOS:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_LineSeparator:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_Mode:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_Position:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_Size:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_State:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #get_Type:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #lineSeparator!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #lineSeparator:!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #LoadFromFile:!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #mode!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #mode:!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #open!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #open:mode:options:userName:password:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #Open:Mode:Options:UserName:Password:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #position!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #position:!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #put_Charset:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #put_LineSeparator:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #put_Mode:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #put_Position:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #put_Type:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #read!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #read:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #Read:pval:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #readText!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #readText:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #ReadText:pbstr:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #saveToFile:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #SaveToFile:Options:!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #SetEOS!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #size!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #SkipLine!**auto generated**!COM Interfaces-_Stream!public! !
!ADODB._Stream categoriesFor: #state!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #type!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #type:!**auto generated**!properties!public! !
!ADODB._Stream categoriesFor: #write:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #Write:!**auto generated**!COM Interfaces-_Stream!private! !
!ADODB._Stream categoriesFor: #writeText:!**auto generated**!methods!public! !
!ADODB._Stream categoriesFor: #WriteText:Options:!**auto generated**!COM Interfaces-_Stream!public! !

!ADODB._Stream class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Stream) for which the receiver is the default interface."

	^CLSID fromString: '{00000566-0000-0010-8000-00aa006d2ea4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Stream'
		_Stream defineTemplate"

	self
		defineFunction: #get_Size:
			argumentTypes: 'sdword*';
		defineFunction: #get_EOS:
			argumentTypes: 'varbool*';
		defineFunction: #get_Position:
			argumentTypes: 'sdword*';
		defineFunction: #put_Position:
			argumentTypes: 'sdword';
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #put_Type:
			argumentTypes: 'sdword';
		defineFunction: #get_LineSeparator:
			argumentTypes: 'sdword*';
		defineFunction: #put_LineSeparator:
			argumentTypes: 'sdword';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_Mode:
			argumentTypes: 'sdword*';
		defineFunction: #put_Mode:
			argumentTypes: 'sdword';
		defineFunction: #get_Charset:
			argumentTypes: 'bstr*';
		defineFunction: #put_Charset:
			argumentTypes: 'bstr';
		defineFunction: #Read:pval:
			argumentTypes: 'sdword variant*';
		defineFunction: #Open:Mode:Options:UserName:Password:
			argumentTypes: 'variant sdword sdword bstr bstr';
		defineFunction: #Close;
		defineFunction: #SkipLine;
		defineFunction: #Write:
			argumentTypes: 'variant';
		defineFunction: #SetEOS;
		defineFunction: #CopyTo:CharNumber:
			argumentTypes: '_Stream* sdword';
		defineFunction: #Flush;
		defineFunction: #SaveToFile:Options:
			argumentTypes: 'bstr sdword';
		defineFunction: #LoadFromFile:
			argumentTypes: 'bstr';
		defineFunction: #ReadText:pbstr:
			argumentTypes: 'sdword bstr*';
		defineFunction: #WriteText:Options:
			argumentTypes: 'bstr sdword';
		defineFunction: #Cancel
! !
!ADODB._Stream class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB._Stream class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

