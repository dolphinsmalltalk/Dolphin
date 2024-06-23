"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.IDataSource'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

CDO.IDataSource guid: (OS.COM.IID fromString: '{cd000029-8b95-11d1-82db-00c04fb1625d}')!

CDO.IDataSource comment: '<CDO.IDataSource> is a wrapper class for the COM interface ''CDO.IDataSource'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to extract messages from or embed messages into other CDO message body parts"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CDO.IDataSource categoriesForClass!CDO-Interfaces!COM-Interfaces! !

!CDO.IDataSource methodsFor!

activeConnection
	"Answer the <ADODB._Connection> value of the 'ActiveConnection' property of the receiver.
	Helpstring: Not implemented. Reserved for future use."

	| answer |
	answer := ADODB._Connection newPointer.
	self get_ActiveConnection: answer.
	^answer asObject!

get_ActiveConnection: varActiveConnection
	"Private - Get the value of the 'ActiveConnection' property of the receiver.

		HRESULT __stdcall ActiveConnection(
			[out, retval]_Connection** varActiveConnection);"

	<virtual stdcall: hresult 13 ADODB._Connection**>
	^self invalidCall: _failureCode!

get_IsDirty: pIsDirty
	"Private - Get the value of the 'IsDirty' property of the receiver.

		HRESULT __stdcall IsDirty(
			[out, retval]VARIANT_BOOL* pIsDirty);"

	<virtual stdcall: hresult 10 varbool*>
	^self invalidCall: _failureCode!

get_Source: varSource
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]IUnknown** varSource);"

	<virtual stdcall: hresult 9 IUnknown**>
	^self invalidCall: _failureCode!

get_SourceClass: varSourceClass
	"Private - Get the value of the 'SourceClass' property of the receiver.

		HRESULT __stdcall SourceClass(
			[out, retval]BSTR* varSourceClass);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_SourceURL: varSourceURL
	"Private - Get the value of the 'SourceURL' property of the receiver.

		HRESULT __stdcall SourceURL(
			[out, retval]BSTR* varSourceURL);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

isDirty
	"Answer the <varbool> value of the 'IsDirty' property of the receiver.
	Helpstring: Indicates whether the local data has been changed since the last save or bind operation."

	| answer |
	answer := VARIANT_BOOL new.
	self get_IsDirty: answer.
	^answer asObject!

isDirty: pIsDirty
	"Set the 'IsDirty' property of the receiver to the <varbool> value of the argument.
	Helpstring: Indicates whether the local data has been changed since the last save or bind operation."

	self put_IsDirty: pIsDirty!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

open: sourceURL
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		Open: sourceURL
		ActiveConnection: nil
		Mode: 0
		CreateOptions: -1
		Options: 0
		UserName: nil
		Password: nil!

Open: sourceURL ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Invoke the Open() method of the COM object.
	Helpstring: Not implemented. Reserved for future use.

		HRESULT __stdcall Open(
			[in]BSTR SourceURL,
			[in, defaultvalue(nil)]IDispatch* ActiveConnection,
			[in, optional]ConnectModeEnum Mode,
			[in, defaultvalue(-1)]RecordCreateOptionsEnum CreateOptions,
			[in, optional]RecordOpenOptionsEnum Options,
			[in, optional]BSTR UserName,
			[in, optional]BSTR Password);"

	<virtual stdcall: hresult 17 bstr IDispatch* int32 int32 int32 bstr bstr>
	^self invalidCall: _failureCode!

OpenObject: source InterfaceName: interfaceName
	"Invoke the OpenObject() method of the COM object.
	Helpstring: Binds to and opens data from the specified object.

		HRESULT __stdcall OpenObject(
			[in]IUnknown* Source,
			[in]BSTR InterfaceName);"

	<virtual stdcall: hresult 15 IUnknown* bstr>
	^self invalidCall: _failureCode!

put_IsDirty: pIsDirty
	"Private - Set the value of the 'IsDirty' property of the object wrapped by the 
	 receiver to the <varbool> argument, pIsDirty.

		HRESULT __stdcall IsDirty(
			[in]VARIANT_BOOL pIsDirty);"

	<virtual stdcall: hresult 11 varbool>
	^self invalidCall: _failureCode!

Save
	"Invoke the Save() method of the COM object.
	Helpstring: Saves data into the currently bound object.

		HRESULT __stdcall Save();"

	<virtual stdcall: hresult 18>
	^self invalidCall: _failureCode!

saveTo: sourceURL
	"Invoke the SaveTo() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		SaveTo: sourceURL
		ActiveConnection: nil
		Mode: 0
		CreateOptions: 0
		Options: 0
		UserName: nil
		Password: nil!

SaveTo: sourceURL ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Invoke the SaveTo() method of the COM object.
	Helpstring: Not implemented. Reserved for future use.

		HRESULT __stdcall SaveTo(
			[in]BSTR SourceURL,
			[in, defaultvalue(nil)]IDispatch* ActiveConnection,
			[in, optional]ConnectModeEnum Mode,
			[in, optional]RecordCreateOptionsEnum CreateOptions,
			[in, optional]RecordOpenOptionsEnum Options,
			[in, optional]BSTR UserName,
			[in, optional]BSTR Password);"

	<virtual stdcall: hresult 16 bstr IDispatch* int32 int32 int32 bstr bstr>
	^self invalidCall: _failureCode!

saveToContainer: containerURL
	"Invoke the SaveToContainer() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		SaveToContainer: containerURL
		ActiveConnection: nil
		Mode: 0
		CreateOptions: 0
		Options: 0
		UserName: nil
		Password: nil!

SaveToContainer: containerURL ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Invoke the SaveToContainer() method of the COM object.
	Helpstring: Not implemented. Reserved for future use.

		HRESULT __stdcall SaveToContainer(
			[in]BSTR ContainerURL,
			[in, defaultvalue(nil)]IDispatch* ActiveConnection,
			[in, optional]ConnectModeEnum Mode,
			[in, optional]RecordCreateOptionsEnum CreateOptions,
			[in, optional]RecordOpenOptionsEnum Options,
			[in, optional]BSTR UserName,
			[in, optional]BSTR Password);"

	<virtual stdcall: hresult 19 bstr IDispatch* int32 int32 int32 bstr bstr>
	^self invalidCall: _failureCode!

SaveToObject: source InterfaceName: interfaceName
	"Invoke the SaveToObject() method of the COM object.
	Helpstring: Binds to and saves data into the specified object.

		HRESULT __stdcall SaveToObject(
			[in]IUnknown* Source,
			[in]BSTR InterfaceName);"

	<virtual stdcall: hresult 14 IUnknown* bstr>
	^self invalidCall: _failureCode!

source
	"Answer the <IUnknown> value of the 'Source' property of the receiver.
	Helpstring: Returns the currently bound object. When you bind resources by URL, an ADO _Record interface is returned on an open Record object."

	| answer |
	answer := IUnknown newPointer.
	self get_Source: answer.
	^answer asObject!

sourceClass
	"Answer the <bstr> value of the 'SourceClass' property of the receiver.
	Helpstring: The interface name (type) of the currently bound object. When you bind resources by URL, the value _Record is returned."

	| answer |
	answer := BSTR new.
	self get_SourceClass: answer.
	^answer asObject!

sourceURL
	"Answer the <bstr> value of the 'SourceURL' property of the receiver.
	Helpstring: Not Implemented. Reserved for future use."

	| answer |
	answer := BSTR new.
	self get_SourceURL: answer.
	^answer asObject! !

!CDO.IDataSource categoriesForMethods!
activeConnection!**auto generated**!properties!public! !
get_ActiveConnection:!**auto generated**!COM Interfaces-IDataSource!private! !
get_IsDirty:!**auto generated**!COM Interfaces-IDataSource!private! !
get_Source:!**auto generated**!COM Interfaces-IDataSource!private! !
get_SourceClass:!**auto generated**!COM Interfaces-IDataSource!private! !
get_SourceURL:!**auto generated**!COM Interfaces-IDataSource!private! !
isDirty!**auto generated**!properties!public! !
isDirty:!**auto generated**!properties!public! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
open:!**auto generated**!methods!public! !
Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-IDataSource!public! !
OpenObject:InterfaceName:!**auto generated**!COM Interfaces-IDataSource!public! !
put_IsDirty:!**auto generated**!COM Interfaces-IDataSource!private! !
Save!**auto generated**!COM Interfaces-IDataSource!public! !
saveTo:!**auto generated**!methods!public! !
SaveTo:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-IDataSource!public! !
saveToContainer:!**auto generated**!methods!public! !
SaveToContainer:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-IDataSource!public! !
SaveToObject:InterfaceName:!**auto generated**!COM Interfaces-IDataSource!public! !
source!**auto generated**!properties!public! !
sourceClass!**auto generated**!properties!public! !
sourceURL!**auto generated**!properties!public! !
!

!CDO.IDataSource class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IDataSource'
		IDataSource defineTemplate"

	self
		defineFunction: #get_SourceClass:
			argumentTypes: 'bstr*';
		defineFunction: #get_Source:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_IsDirty:
			argumentTypes: 'varbool*';
		defineFunction: #put_IsDirty:
			argumentTypes: 'varbool';
		defineFunction: #get_SourceURL:
			argumentTypes: 'bstr*';
		defineFunction: #get_ActiveConnection:
			argumentTypes: 'ADODB._Connection**';
		defineFunction: #SaveToObject:InterfaceName:
			argumentTypes: 'IUnknown* bstr';
		defineFunction: #OpenObject:InterfaceName:
			argumentTypes: 'IUnknown* bstr';
		defineFunction: #SaveTo:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:
			argumentTypes: 'bstr IDispatch* sdword sdword sdword bstr bstr';
		defineFunction: #Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:
			argumentTypes: 'bstr IDispatch* sdword sdword sdword bstr bstr';
		defineFunction: #Save;
		defineFunction: #SaveToContainer:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:
			argumentTypes: 'bstr IDispatch* sdword sdword sdword bstr bstr'
! !

!CDO.IDataSource class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

