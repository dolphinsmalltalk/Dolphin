"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOIDataSource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOIDataSource guid: (IID fromString: '{cd000029-8b95-11d1-82db-00c04fb1625d}')!
CDOIDataSource comment: '<CDOIDataSource> is a wrapper class for the COM interface ''CDO.IDataSource'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to extract messages from or embed messages into other CDO message body parts"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOIDataSource categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOIDataSource methodsFor!

activeConnection
	"Answer the <ADODB_Connection> value of the 'ActiveConnection' property of the receiver.
	Helpstring: 'Not implemented. Reserved for future use.'"

	| answer |
	answer := ADODB_Connection newPointer.
	self
		get_ActiveConnection: answer.
	^answer asObject
!

get_ActiveConnection: varActiveConnection
	"Private - Get the value of the 'ActiveConnection' property of the receiver.
	Helpstring: 'Not implemented. Reserved for future use.'

		HRESULT __stdcall ActiveConnection(
			[out, retval] _Connection** varActiveConnection);
	"

	<virtual stdcall: hresult 13 ADODB_Connection**>
	^self invalidCall: _failureCode!

get_IsDirty: pIsDirty
	"Private - Get the value of the 'IsDirty' property of the receiver.
	Helpstring: 'Indicates whether the local data has been changed since the last save or bind operation.'

		HRESULT __stdcall IsDirty(
			[out, retval] VARIANT_BOOL* pIsDirty);
	"

	<virtual stdcall: hresult 10 varbool*>
	^self invalidCall: _failureCode!

get_Source: varSource
	"Private - Get the value of the 'Source' property of the receiver.
	Helpstring: 'Returns the currently bound object. When you bind resources by URL, an ADO _Record interface is returned on an open Record object.'

		HRESULT __stdcall Source(
			[out, retval] IUnknown** varSource);
	"

	<virtual stdcall: hresult 9 IUnknown**>
	^self invalidCall: _failureCode!

get_SourceClass: varSourceClass
	"Private - Get the value of the 'SourceClass' property of the receiver.
	Helpstring: 'The interface name (type) of the currently bound object. When you bind resources by URL, the value _Record is returned.'

		HRESULT __stdcall SourceClass(
			[out, retval] BSTR* varSourceClass);
	"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_SourceURL: varSourceURL
	"Private - Get the value of the 'SourceURL' property of the receiver.
	Helpstring: 'Not Implemented. Reserved for future use.'

		HRESULT __stdcall SourceURL(
			[out, retval] BSTR* varSourceURL);
	"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

isDirty
	"Answer the <varbool> value of the 'IsDirty' property of the receiver.
	Helpstring: 'Indicates whether the local data has been changed since the last save or bind operation.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_IsDirty: answer.
	^answer asObject
!

isDirty: pIsDirty
	"Set the 'IsDirty' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Indicates whether the local data has been changed since the last save or bind operation.'"

	self
		put_IsDirty: pIsDirty
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

Open: sourceURL ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Invoke the Open() method of the COM object wrapped by the receiver.
	Helpstring: 'Not implemented. Reserved for future use.'

		HRESULT __stdcall Open(
			[in] BSTR SourceURL,
			[in, optional, defaultvalue()] IDispatch* ActiveConnection,
			[in, optional] ConnectModeEnum Mode,
			[in, optional, defaultvalue(-1)] RecordCreateOptionsEnum CreateOptions,
			[in, optional] RecordOpenOptionsEnum Options,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password);
	"

	<virtual stdcall: hresult 17 bstr IDispatch* sdword sdword sdword bstr bstr>
	^self invalidCall: _failureCode!

OpenObject: source InterfaceName: interfaceName
	"Invoke the OpenObject() method of the COM object wrapped by the receiver.
	Helpstring: 'Binds to and opens data from the specified object.'

		HRESULT __stdcall OpenObject(
			[in] IUnknown* Source,
			[in] BSTR InterfaceName);
	"

	<virtual stdcall: hresult 15 IUnknown* bstr>
	^self invalidCall: _failureCode!

put_IsDirty: pIsDirty
	"Private - Set the value of the 'IsDirty' property of the object wrapped by the 
	 receiver to the <varbool> argument, pIsDirty.
	Helpstring: 'Indicates whether the local data has been changed since the last save or bind operation.'

		HRESULT __stdcall IsDirty(
			[in] VARIANT_BOOL pIsDirty);
	"

	<virtual stdcall: hresult 11 varbool>
	^self invalidCall: _failureCode!

Save
	"Invoke the Save() method of the COM object wrapped by the receiver.
	Helpstring: 'Saves data into the currently bound object.'

		HRESULT __stdcall Save();
	"

	<virtual stdcall: hresult 18>
	^self invalidCall: _failureCode!

SaveTo: sourceURL ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Invoke the SaveTo() method of the COM object wrapped by the receiver.
	Helpstring: 'Not implemented. Reserved for future use.'

		HRESULT __stdcall SaveTo(
			[in] BSTR SourceURL,
			[in, optional, defaultvalue()] IDispatch* ActiveConnection,
			[in, optional] ConnectModeEnum Mode,
			[in, optional] RecordCreateOptionsEnum CreateOptions,
			[in, optional] RecordOpenOptionsEnum Options,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password);
	"

	<virtual stdcall: hresult 16 bstr IDispatch* sdword sdword sdword bstr bstr>
	^self invalidCall: _failureCode!

SaveToContainer: containerURL ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Invoke the SaveToContainer() method of the COM object wrapped by the receiver.
	Helpstring: 'Not implemented. Reserved for future use.'

		HRESULT __stdcall SaveToContainer(
			[in] BSTR ContainerURL,
			[in, optional, defaultvalue()] IDispatch* ActiveConnection,
			[in, optional] ConnectModeEnum Mode,
			[in, optional] RecordCreateOptionsEnum CreateOptions,
			[in, optional] RecordOpenOptionsEnum Options,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password);
	"

	<virtual stdcall: hresult 19 bstr IDispatch* sdword sdword sdword bstr bstr>
	^self invalidCall: _failureCode!

SaveToObject: source InterfaceName: interfaceName
	"Invoke the SaveToObject() method of the COM object wrapped by the receiver.
	Helpstring: 'Binds to and saves data into the specified object.'

		HRESULT __stdcall SaveToObject(
			[in] IUnknown* Source,
			[in] BSTR InterfaceName);
	"

	<virtual stdcall: hresult 14 IUnknown* bstr>
	^self invalidCall: _failureCode!

source
	"Answer the <IUnknown> value of the 'Source' property of the receiver.
	Helpstring: 'Returns the currently bound object. When you bind resources by URL, an ADO _Record interface is returned on an open Record object.'"

	| answer |
	answer := IUnknown newPointer.
	self
		get_Source: answer.
	^answer asObject
!

sourceClass
	"Answer the <bstr> value of the 'SourceClass' property of the receiver.
	Helpstring: 'The interface name (type) of the currently bound object. When you bind resources by URL, the value _Record is returned.'"

	| answer |
	answer := BSTR new.
	self
		get_SourceClass: answer.
	^answer asObject
!

sourceURL
	"Answer the <bstr> value of the 'SourceURL' property of the receiver.
	Helpstring: 'Not Implemented. Reserved for future use.'"

	| answer |
	answer := BSTR new.
	self
		get_SourceURL: answer.
	^answer asObject
! !
!CDOIDataSource categoriesFor: #activeConnection!**auto generated**!properties!public! !
!CDOIDataSource categoriesFor: #get_ActiveConnection:!**auto generated**!COM Interfaces-IDataSource!private! !
!CDOIDataSource categoriesFor: #get_IsDirty:!**auto generated**!COM Interfaces-IDataSource!private! !
!CDOIDataSource categoriesFor: #get_Source:!**auto generated**!COM Interfaces-IDataSource!private! !
!CDOIDataSource categoriesFor: #get_SourceClass:!**auto generated**!COM Interfaces-IDataSource!private! !
!CDOIDataSource categoriesFor: #get_SourceURL:!**auto generated**!COM Interfaces-IDataSource!private! !
!CDOIDataSource categoriesFor: #isDirty!**auto generated**!properties!public! !
!CDOIDataSource categoriesFor: #isDirty:!**auto generated**!properties!public! !
!CDOIDataSource categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOIDataSource categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOIDataSource categoriesFor: #Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-IDataSource!public! !
!CDOIDataSource categoriesFor: #OpenObject:InterfaceName:!**auto generated**!COM Interfaces-IDataSource!public! !
!CDOIDataSource categoriesFor: #put_IsDirty:!**auto generated**!COM Interfaces-IDataSource!private! !
!CDOIDataSource categoriesFor: #Save!**auto generated**!COM Interfaces-IDataSource!public! !
!CDOIDataSource categoriesFor: #SaveTo:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-IDataSource!public! !
!CDOIDataSource categoriesFor: #SaveToContainer:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-IDataSource!public! !
!CDOIDataSource categoriesFor: #SaveToObject:InterfaceName:!**auto generated**!COM Interfaces-IDataSource!public! !
!CDOIDataSource categoriesFor: #source!**auto generated**!properties!public! !
!CDOIDataSource categoriesFor: #sourceClass!**auto generated**!properties!public! !
!CDOIDataSource categoriesFor: #sourceURL!**auto generated**!properties!public! !

!CDOIDataSource class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IDataSource'
		CDOIDataSource defineTemplate
	"

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
			argumentTypes: 'ADODB_Connection**';
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
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOIDataSource initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOIDataSource class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOIDataSource class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

