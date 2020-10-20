"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'ADODB.ConnectionEventsVt'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.ConnectionEventsVt guid: (OS.COM.IID fromString: '{00001402-0000-0010-8000-00aa006d2ea4}')!
ADODB.ConnectionEventsVt comment: '`ConnectionEventsVt` is a wrapper class for the COM interface ''ADODB.ConnectionEventsVt'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

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
!ADODB.ConnectionEventsVt categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.ConnectionEventsVt methodsFor!

beginTransComplete: transactionLevel pError: pError adStatus: adStatus pConnection: pConnection
	"Invoke the BeginTransComplete() method of the COM object."

	^self
		BeginTransComplete: transactionLevel
		pError: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

BeginTransComplete: beginTransComplete pError: pError adStatus: adStatus pConnection: pConnection
	"Callout for the ConnectionEventsVt::BeginTransComplete() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 5 sdword ADODB.Error* External.SDWORD* ADODB._Connection*>
	^self invalidCall: _failureCode!

commitTransComplete: pError adStatus: adStatus pConnection: pConnection
	"Invoke the CommitTransComplete() method of the COM object."

	^self
		CommitTransComplete: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

CommitTransComplete: commitTransComplete adStatus: adStatus pConnection: pConnection
	"Callout for the ConnectionEventsVt::CommitTransComplete() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 6 ADODB.Error* External.SDWORD* ADODB._Connection*>
	^self invalidCall: _failureCode!

connectComplete: pError adStatus: adStatus pConnection: pConnection
	"Invoke the ConnectComplete() method of the COM object."

	^self
		ConnectComplete: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

ConnectComplete: connectComplete adStatus: adStatus pConnection: pConnection
	"Callout for the ConnectionEventsVt::ConnectComplete() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 11 ADODB.Error* External.SDWORD* ADODB._Connection*>
	^self invalidCall: _failureCode!

disconnect: adStatus pConnection: pConnection
	"Invoke the Disconnect() method of the COM object."

	^self Disconnect: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

Disconnect: disconnect pConnection: pConnection
	"Callout for the ConnectionEventsVt::Disconnect() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 12 External.SDWORD* ADODB._Connection*>
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

ExecuteComplete: executeComplete pError: pError adStatus: adStatus pCommand: pCommand pRecordset: pRecordset pConnection: pConnection
	"Callout for the ConnectionEventsVt::ExecuteComplete() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 9 sdword ADODB.Error* External.SDWORD* ADODB._Command* ADODB._Recordset* ADODB._Connection*>
	^self invalidCall: _failureCode!

infoMessage: pError adStatus: adStatus pConnection: pConnection
	"Invoke the InfoMessage() method of the COM object."

	^self
		InfoMessage: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

InfoMessage: infoMessage adStatus: adStatus pConnection: pConnection
	"Callout for the ConnectionEventsVt::InfoMessage() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 ADODB.Error* External.SDWORD* ADODB._Connection*>
	^self invalidCall: _failureCode!

rollbackTransComplete: pError adStatus: adStatus pConnection: pConnection
	"Invoke the RollbackTransComplete() method of the COM object."

	^self
		RollbackTransComplete: pError
		adStatus: (SDWORD new
				value: adStatus;
				yourself)
		pConnection: pConnection!

RollbackTransComplete: rollbackTransComplete adStatus: adStatus pConnection: pConnection
	"Callout for the ConnectionEventsVt::RollbackTransComplete() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 7 ADODB.Error* External.SDWORD* ADODB._Connection*>
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

WillConnect: willConnect UserID: userID Password: password Options: options adStatus: adStatus pConnection: pConnection
	"Callout for the ConnectionEventsVt::WillConnect() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 10 lppvoid lppvoid lppvoid External.SDWORD* External.SDWORD* ADODB._Connection*>
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

WillExecute: willExecute CursorType: cursorType LockType: lockType Options: options adStatus: adStatus pCommand: pCommand pRecordset: pRecordset pConnection: pConnection
	"Callout for the ConnectionEventsVt::WillExecute() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ConnectionEventsVt>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 8 lppvoid External.SDWORD* External.SDWORD* External.SDWORD* External.SDWORD* ADODB._Command* ADODB._Recordset* ADODB._Connection*>
	^self invalidCall: _failureCode! !
!ADODB.ConnectionEventsVt categoriesFor: #beginTransComplete:pError:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #BeginTransComplete:pError:adStatus:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #commitTransComplete:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #CommitTransComplete:adStatus:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #connectComplete:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #ConnectComplete:adStatus:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #disconnect:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #Disconnect:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #executeComplete:pError:adStatus:pCommand:pRecordset:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #ExecuteComplete:pError:adStatus:pCommand:pRecordset:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #infoMessage:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #InfoMessage:adStatus:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #rollbackTransComplete:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #RollbackTransComplete:adStatus:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #willConnect:userID:password:options:adStatus:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #WillConnect:UserID:Password:Options:adStatus:pConnection:!COM Interfaces-ConnectionEventsVt!public! !
!ADODB.ConnectionEventsVt categoriesFor: #willExecute:cursorType:lockType:options:adStatus:pCommand:pRecordset:pConnection:!**auto generated**!methods!public! !
!ADODB.ConnectionEventsVt categoriesFor: #WillExecute:CursorType:LockType:Options:adStatus:pCommand:pRecordset:pConnection:!COM Interfaces-ConnectionEventsVt!public! !

!ADODB.ConnectionEventsVt class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ConnectionEventsVt'
		ConnectionEventsVt defineTemplate"

	self
		defineFunction: #InfoMessage:adStatus:pConnection:
			argumentTypes: 'Error* sdword* _Connection*';
		defineFunction: #BeginTransComplete:pError:adStatus:pConnection:
			argumentTypes: 'sdword Error* sdword* _Connection*';
		defineFunction: #CommitTransComplete:adStatus:pConnection:
			argumentTypes: 'Error* sdword* _Connection*';
		defineFunction: #RollbackTransComplete:adStatus:pConnection:
			argumentTypes: 'Error* sdword* _Connection*';
		defineFunction: #WillExecute:CursorType:LockType:Options:adStatus:pCommand:pRecordset:pConnection:
			argumentTypes: 'bstr* sdword* sdword* sdword* sdword* _Command* _Recordset* _Connection*';
		defineFunction: #ExecuteComplete:pError:adStatus:pCommand:pRecordset:pConnection:
			argumentTypes: 'sdword Error* sdword* _Command* _Recordset* _Connection*';
		defineFunction: #WillConnect:UserID:Password:Options:adStatus:pConnection:
			argumentTypes: 'bstr* bstr* bstr* sdword* sdword* _Connection*';
		defineFunction: #ConnectComplete:adStatus:pConnection:
			argumentTypes: 'Error* sdword* _Connection*';
		defineFunction: #Disconnect:pConnection:
			argumentTypes: 'sdword* _Connection*'
! !
!ADODB.ConnectionEventsVt class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

