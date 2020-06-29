"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ADODBConnectionEventsVt
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBConnectionEventsVt guid: (IID fromString: '{00001402-0000-0010-8000-00aa006d2ea4}')!
ADODBConnectionEventsVt comment: '`ADODBConnectionEventsVt` is a wrapper class for the COM interface ''ADODB.ConnectionEventsVt'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001402-0000-0010-8000-00aa006d2ea4), 
	hidden
]
interface ConnectionEventsVt : IUnknown
 {
	[id(0000000000), helpcontext(0x0012d374)]
	HRESULT __stdcall InfoMessage(
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
	[id(0x00000001), helpcontext(0x0012d344)]
	HRESULT __stdcall BeginTransComplete(
		[in]long TransactionLevel,
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
	[id(0x00000003), helpcontext(0x000f4241)]
	HRESULT __stdcall CommitTransComplete(
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
	[id(0x00000002), helpcontext(0x000f4242)]
	HRESULT __stdcall RollbackTransComplete(
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
	[id(0x00000004), helpcontext(0x0012d357)]
	HRESULT __stdcall WillExecute(
		[in, out]BSTR* Source,
		[in, out]CursorTypeEnum* CursorType,
		[in, out]LockTypeEnum* LockType,
		[in, out]long* Options,
		[in, out]EventStatusEnum* adStatus,
		[in]_Command* pCommand,
		[in]_Recordset* pRecordset,
		[in]_Connection* pConnection);
	[id(0x00000005), helpcontext(0x0012d367)]
	HRESULT __stdcall ExecuteComplete(
		[in]long RecordsAffected,
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Command* pCommand,
		[in]_Recordset* pRecordset,
		[in]_Connection* pConnection);
	[id(0x00000006), helpcontext(0x0012d355)]
	HRESULT __stdcall WillConnect(
		[in, out]BSTR* ConnectionString,
		[in, out]BSTR* UserID,
		[in, out]BSTR* Password,
		[in, out]long* Options,
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
	[id(0x00000007), helpcontext(0x0012d356)]
	HRESULT __stdcall ConnectComplete(
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
	[id(0x00000008), helpcontext(0x000f4243)]
	HRESULT __stdcall Disconnect(
		[in, out]EventStatusEnum* adStatus,
		[in]_Connection* pConnection);
};
```
'!
!ADODBConnectionEventsVt categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBConnectionEventsVt methodsFor!

beginTransComplete: transactionLevel pError: pError adStatus: adStatus pConnection: pConnection
	"Invoke the BeginTransComplete() method of the COM object."

	^self
		BeginTransComplete: transactionLevel
		pError: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

BeginTransComplete: transactionLevel pError: pError adStatus: adStatus pConnection: pConnection
	"Private - Invoke the BeginTransComplete() method of the COM object.

		HRESULT __stdcall BeginTransComplete(
			[in]long TransactionLevel,
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 5 sdword ADODBError* sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

commitTransComplete: pError adStatus: adStatus pConnection: pConnection
	"Invoke the CommitTransComplete() method of the COM object."

	^self
		CommitTransComplete: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

CommitTransComplete: pError adStatus: adStatus pConnection: pConnection
	"Private - Invoke the CommitTransComplete() method of the COM object.

		HRESULT __stdcall CommitTransComplete(
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 6 ADODBError* sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

connectComplete: pError adStatus: adStatus pConnection: pConnection
	"Invoke the ConnectComplete() method of the COM object."

	^self
		ConnectComplete: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

ConnectComplete: pError adStatus: adStatus pConnection: pConnection
	"Private - Invoke the ConnectComplete() method of the COM object.

		HRESULT __stdcall ConnectComplete(
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 11 ADODBError* sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

disconnect: adStatus pConnection: pConnection
	"Invoke the Disconnect() method of the COM object."

	^self Disconnect: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

Disconnect: adStatus pConnection: pConnection
	"Private - Invoke the Disconnect() method of the COM object.

		HRESULT __stdcall Disconnect(
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 12 sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

executeComplete: recordsAffected pError: pError adStatus: adStatus pCommand: pCommand pRecordset: pRecordset pConnection: pConnection
	"Invoke the ExecuteComplete() method of the COM object."

	^self
		ExecuteComplete: recordsAffected
		pError: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pCommand: pCommand
		pRecordset: pRecordset
		pConnection: pConnection!

ExecuteComplete: recordsAffected pError: pError adStatus: adStatus pCommand: pCommand pRecordset: pRecordset pConnection: pConnection
	"Private - Invoke the ExecuteComplete() method of the COM object.

		HRESULT __stdcall ExecuteComplete(
			[in]long RecordsAffected,
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Command* pCommand,
			[in]_Recordset* pRecordset,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 9 sdword ADODBError* sdword* ADODB_Command* ADODB_Recordset* ADODB_Connection*>
	^self invalidCall: _failureCode!

infoMessage: pError adStatus: adStatus pConnection: pConnection
	"Invoke the InfoMessage() method of the COM object."

	^self
		InfoMessage: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

InfoMessage: pError adStatus: adStatus pConnection: pConnection
	"Private - Invoke the InfoMessage() method of the COM object.

		HRESULT __stdcall InfoMessage(
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 4 ADODBError* sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

rollbackTransComplete: pError adStatus: adStatus pConnection: pConnection
	"Invoke the RollbackTransComplete() method of the COM object."

	^self
		RollbackTransComplete: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

RollbackTransComplete: pError adStatus: adStatus pConnection: pConnection
	"Private - Invoke the RollbackTransComplete() method of the COM object.

		HRESULT __stdcall RollbackTransComplete(
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 7 ADODBError* sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

willConnect: connectionString userID: userID password: password options: options adStatus: adStatus pConnection: pConnection
	"Invoke the WillConnect() method of the COM object."

	| outputs |
	outputs := {connectionString asBSTR.
				userID asBSTR.
				password asBSTR.
				SDWORD new
					value: options;
					yourself.
				SDWORD new
					value: adStatus;
					yourself}.
	self
		WillConnect: (outputs basicAt: 1)
		UserID: (outputs basicAt: 2)
		Password: (outputs basicAt: 3)
		Options: (outputs basicAt: 4)
		adStatus: (outputs basicAt: 5)
		pConnection: pConnection.
	^outputs collect: [:each | each asObject]!

WillConnect: connectionString UserID: userID Password: password Options: options adStatus: adStatus pConnection: pConnection
	"Private - Invoke the WillConnect() method of the COM object.

		HRESULT __stdcall WillConnect(
			[in, out]BSTR* ConnectionString,
			[in, out]BSTR* UserID,
			[in, out]BSTR* Password,
			[in, out]long* Options,
			[in, out]EventStatusEnum* adStatus,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 10 bstr* bstr* bstr* sdword* sdword* ADODB_Connection*>
	^self invalidCall: _failureCode!

willExecute: source cursorType: cursorType lockType: lockType options: options adStatus: adStatus pCommand: pCommand pRecordset: pRecordset pConnection: pConnection
	"Invoke the WillExecute() method of the COM object."

	| outputs |
	outputs := {source asBSTR.
				SDWORD new
					value: cursorType;
					yourself.
				SDWORD new
					value: lockType;
					yourself.
				SDWORD new
					value: options;
					yourself.
				SDWORD new
					value: adStatus;
					yourself}.
	self
		WillExecute: (outputs basicAt: 1)
		CursorType: (outputs basicAt: 2)
		LockType: (outputs basicAt: 3)
		Options: (outputs basicAt: 4)
		adStatus: (outputs basicAt: 5)
		pCommand: pCommand
		pRecordset: pRecordset
		pConnection: pConnection.
	^outputs collect: [:each | each asObject]!

WillExecute: source CursorType: cursorType LockType: lockType Options: options adStatus: adStatus pCommand: pCommand pRecordset: pRecordset pConnection: pConnection
	"Private - Invoke the WillExecute() method of the COM object.

		HRESULT __stdcall WillExecute(
			[in, out]BSTR* Source,
			[in, out]CursorTypeEnum* CursorType,
			[in, out]LockTypeEnum* LockType,
			[in, out]long* Options,
			[in, out]EventStatusEnum* adStatus,
			[in]_Command* pCommand,
			[in]_Recordset* pRecordset,
			[in]_Connection* pConnection);"

	<virtual stdcall: hresult 8 bstr* sdword* sdword* sdword* sdword* ADODB_Command* ADODB_Recordset* ADODB_Connection*>
	^self invalidCall: _failureCode! !
!ADODBConnectionEventsVt categoriesFor: #beginTransComplete:pError:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #BeginTransComplete:pError:adStatus:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #commitTransComplete:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #CommitTransComplete:adStatus:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #connectComplete:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #ConnectComplete:adStatus:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #disconnect:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #Disconnect:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #executeComplete:pError:adStatus:pCommand:pRecordset:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #ExecuteComplete:pError:adStatus:pCommand:pRecordset:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #infoMessage:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #InfoMessage:adStatus:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #rollbackTransComplete:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #RollbackTransComplete:adStatus:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #willConnect:userID:password:options:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #WillConnect:UserID:Password:Options:adStatus:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !
!ADODBConnectionEventsVt categoriesFor: #willExecute:cursorType:lockType:options:adStatus:pCommand:pRecordset:pConnection:!**auto generated**!methods!public! !
!ADODBConnectionEventsVt categoriesFor: #WillExecute:CursorType:LockType:Options:adStatus:pCommand:pRecordset:pConnection:!**auto generated**!COM Interfaces-ConnectionEventsVt!private! !

!ADODBConnectionEventsVt class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ConnectionEventsVt'
		ADODBConnectionEventsVt defineTemplate"

	self
		defineFunction: #InfoMessage:adStatus:pConnection:
			argumentTypes: 'ADODBError* sdword* ADODB_Connection*';
		defineFunction: #BeginTransComplete:pError:adStatus:pConnection:
			argumentTypes: 'sdword ADODBError* sdword* ADODB_Connection*';
		defineFunction: #CommitTransComplete:adStatus:pConnection:
			argumentTypes: 'ADODBError* sdword* ADODB_Connection*';
		defineFunction: #RollbackTransComplete:adStatus:pConnection:
			argumentTypes: 'ADODBError* sdword* ADODB_Connection*';
		defineFunction: #WillExecute:CursorType:LockType:Options:adStatus:pCommand:pRecordset:pConnection:
			argumentTypes: 'bstr* sdword* sdword* sdword* sdword* ADODB_Command* ADODB_Recordset* ADODB_Connection*';
		defineFunction: #ExecuteComplete:pError:adStatus:pCommand:pRecordset:pConnection:
			argumentTypes: 'sdword ADODBError* sdword* ADODB_Command* ADODB_Recordset* ADODB_Connection*';
		defineFunction: #WillConnect:UserID:Password:Options:adStatus:pConnection:
			argumentTypes: 'bstr* bstr* bstr* sdword* sdword* ADODB_Connection*';
		defineFunction: #ConnectComplete:adStatus:pConnection:
			argumentTypes: 'ADODBError* sdword* ADODB_Connection*';
		defineFunction: #Disconnect:pConnection:
			argumentTypes: 'sdword* ADODB_Connection*'
! !
!ADODBConnectionEventsVt class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

