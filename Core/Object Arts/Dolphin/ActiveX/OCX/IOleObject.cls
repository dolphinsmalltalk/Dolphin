﻿"Filed out from Dolphin Smalltalk"!

IUnknown subclass: #IOleObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IOleObject guid: (IID fromString: '{00000112-0000-0000-c000-000000000046}')!
IOleObject comment: '<IOleObject> is a wrapper class for the COM interface ''OLEIDL.IOleObject'' generated from type information in the ''OLEIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

This class was originally generated by the type library analyzer in Dolphin 4, but many of the OLE interfaces it references are not present in 3.x. The missing interfaces have been replaced with IUnknown, as we are only using a small part of this interface and don''t want to bloat the image with the entirety of OLE Embedding and In-place Activation!!
'!
!IOleObject categoriesForClass!COM-Interfaces! !
!IOleObject methodsFor!

Advise: pAdvSink pdwConnection: pdwConnection
	"Private - Invoke the Advise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Advise(
			[in] IAdviseSink* pAdvSink,
			[out] unsigned long* pdwConnection);
	"

	<virtual stdcall: hresult 20 IUnknown* dword*>
	^self invalidCall: _failureCode!

appName
	"Answer the name of the application hosting the object."

	^self getUserType: 3!

close: dwSaveOption 
	"Invoke the Close() method of the COM Object."

	| hr |
	hr := self Close: dwSaveOption.
	hr < 0 ifTrue: [self hresultError: hr]
!

Close: dwSaveOption
	"Private - Invoke the Close() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Close(
			[in] unsigned long dwSaveOption);
	"

	<virtual stdcall: sdword 7 dword>
	^self invalidCall: _failureCode!

DoVerb: iVerb lpmsg: lpmsg pActiveSite: pActiveSite lindex: lindex hwndParent: hwndParent lprcPosRect: lprcPosRect
	"Private - Invoke the DoVerb() method of the COM object wrapped by the receiver.

		HRESULT __stdcall DoVerb(
			[in] long iVerb,
			[in] MSG* lpmsg,
			[in] IOleClientSite* pActiveSite,
			[in] long lindex,
			[in] HWND hwndParent,
			[in] RECT* lprcPosRect);
	"

	<virtual stdcall: hresult 12 sdword MSG* IOleClientSite* sdword handle RECT*>
	^self invalidCall: _failureCode!

doVerb: iVerb msg: aMSG activeSite: piSite parentView: parentView rectangle: rect 
	"Ask the OLE object to perform the action identified by the <integer> verb, iVerb.
	Note that the lindex parameter is defaulted."

	^self
		DoVerb: iVerb
		lpmsg: aMSG
		pActiveSite: piSite
		lindex: 0
		hwndParent: parentView asParameter
		lprcPosRect: rect asParameter			"Coords in pels of object in parent"
!

EnumAdvise: ppenumAdvise
	"Private - Invoke the EnumAdvise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumAdvise(
			[out] IEnumSTATDATA** ppenumAdvise);
	"

	<virtual stdcall: hresult 22 IUnknown**>
	^self invalidCall: _failureCode!

enumVerbs
	| ienum |
	ienum := IEnumStruct elementClass: OLEVERB.
	self EnumVerbs: ienum.
	^ienum!

EnumVerbs: ppEnumOleVerb
	"Private - Invoke the EnumVerbs() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumVerbs(
			[out] IEnumOLEVERB** ppEnumOleVerb);
	"

	<virtual stdcall: hresult 13 IUnknown**>
	^self invalidCall: _failureCode!

fullName
	"Answer the full name of the object."

	^self getUserType: 1!

GetClientSite: ppClientSite
	"Private - Invoke the GetClientSite() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetClientSite(
			[out] IOleClientSite** ppClientSite);
	"

	<virtual stdcall: hresult 5 IOleClientSite**>
	^self invalidCall: _failureCode!

GetClipboardData: dwReserved ppDataObject: ppDataObject
	"Private - Invoke the GetClipboardData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetClipboardData(
			[in] unsigned long dwReserved,
			[out] IDataObject** ppDataObject);
	"

	<virtual stdcall: hresult 11 dword IUnknown**>
	^self invalidCall: _failureCode!

getExtent: dwDrawAspect 
	"Answer the <SIZE> result of invoking the COM Object's GetExtent() method."

	| answer |
	answer := (SIZE new).
	self
		GetExtent: dwDrawAspect
		psizel: answer.
	^answer asObject
!

GetExtent: dwDrawAspect psizel: psizel
	"Private - Invoke the GetExtent() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetExtent(
			[in] unsigned long dwDrawAspect,
			[out] SIZEL* psizel);
	"

	<virtual stdcall: hresult 19 dword SIZE*>
	^self invalidCall: _failureCode!

getMiscStatus: dwAspect 
	"Answer the <DWORD> result of invoking the COM Object's GetMiscStatus() method."

	| answer |
	answer := (DWORD new).
	self
		GetMiscStatus: dwAspect
		pdwStatus: answer.
	^answer asObject
!

GetMiscStatus: dwAspect pdwStatus: pdwStatus
	"Private - Invoke the GetMiscStatus() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetMiscStatus(
			[in] unsigned long dwAspect,
			[out] unsigned long* pdwStatus);
	"

	<virtual stdcall: hresult 23 dword dword*>
	^self invalidCall: _failureCode!

GetMoniker: dwAssign dwWhichMoniker: dwWhichMoniker ppmk: ppmk
	"Private - Invoke the GetMoniker() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetMoniker(
			[in] unsigned long dwAssign,
			[in] unsigned long dwWhichMoniker,
			[out] IMoniker** ppmk);
	"

	<virtual stdcall: hresult 9 dword dword IUnknown**>
	^self invalidCall: _failureCode!

getUserClassID
	"Answer the <GUID> result of invoking the COM Object's GetUserClassID() method."

	| answer |
	answer := GUID new.
	self
		GetUserClassID: answer.
	^answer asObject
!

GetUserClassID: pClsid
	"Private - Invoke the GetUserClassID() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetUserClassID(
			[out] GUID* pClsid);
	"

	<virtual stdcall: hresult 16 guid*>
	^self invalidCall: _failureCode!

getUserType: dwFormOfType
	"Answer the <Utf16String> result of invoking the COM Object's GetUserType() method.
	Auto-generated method would work here (handles task memory correctly), but rewritten for 
	improved efficiency."

	| mem answer |
	mem := COMTaskMemory new.
	self GetUserType: dwFormOfType pszUserType: mem.
	answer := (Utf16String fromAddress: mem) asString.
	mem free.
	^answer!

GetUserType: dwFormOfType pszUserType: pszUserType
	"Private - Invoke the GetUserType() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetUserType(
			[in] unsigned long dwFormOfType,
			[out] LPWSTR* pszUserType);
	"

	<virtual stdcall: hresult 17 dword lpwstr*>
	^self invalidCall: _failureCode!

InitFromData: pDataObject fCreation: fCreation dwReserved: dwReserved
	"Private - Invoke the InitFromData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall InitFromData(
			[in] IDataObject* pDataObject,
			[in] long fCreation,
			[in] unsigned long dwReserved);
	"

	<virtual stdcall: hresult 10 IUnknown* sdword dword>
	^self invalidCall: _failureCode!

IsUpToDate
	"Private - Invoke the IsUpToDate() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsUpToDate();
	"

	<virtual stdcall: hresult 15>
	^self invalidCall: _failureCode!

SetClientSite: pClientSite
	"Private - Invoke the SetClientSite() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetClientSite(
			[in] IOleClientSite* pClientSite);
	"

	<virtual stdcall: sdword 4 IOleClientSite*>
	^self invalidCall: _failureCode!

SetColorScheme: pLogpal
	"Private - Invoke the SetColorScheme() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetColorScheme(
			[in] LOGPALETTE* pLogpal);
	"

	<virtual stdcall: hresult 24 LOGPALETTE*>
	^self invalidCall: _failureCode!

setExtent: dwDrawAspect psizel: psizel 
	"Set the extent of the specified aspect of the receiver to the 
	specified number of pixels. Answer whether the resize was
	accepted (fixed size objects answer false)."

	| hr |
	hr := self
		SetExtent: dwDrawAspect
		psizel: psizel asParameter.
	^hr < 0
		ifTrue: [
			hr = E_FAIL
				ifTrue: [false]
				ifFalse: [self hresultError: hr]]
		ifFalse: [true].
!

SetExtent: dwDrawAspect psizel: psizel
	"Private - Invoke the SetExtent() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetExtent(
			[in] unsigned long dwDrawAspect,
			[in] SIZEL* psizel);
	"

	<virtual stdcall: sdword 18 dword SIZE*>
	^self invalidCall: _failureCode!

setHostNames: szContainerApp szContainerObj: szContainerObj
	"Invoke the SetHostNames() method of the COM Object.
	Implementation of this method is optional, so we suppress any E_NOTIMPL errors
	that may be reported."

	| hr |
	hr := self SetHostNames: szContainerApp asUtf16String szContainerObj: szContainerObj asUtf16String.
	hr < 0 ifTrue: [hr = E_NOTIMPL ifFalse: [^self hresultError: hr]].
	^hr!

SetHostNames: szContainerApp szContainerObj: szContainerObj
	"Private - Invoke the SetHostNames() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetHostNames(
			[in] LPWSTR szContainerApp,
			[in] LPWSTR szContainerObj);
	"

	<virtual stdcall: sdword 6 lpwstr lpwstr>
	^self invalidCall: _failureCode!

SetMoniker: dwWhichMoniker pmk: pmk
	"Private - Invoke the SetMoniker() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetMoniker(
			[in] unsigned long dwWhichMoniker,
			[in] IMoniker* pmk);
	"

	<virtual stdcall: hresult 8 dword IUnknown*>
	^self invalidCall: _failureCode!

shortName
	"Answer the full name of the object."

	^self getUserType: 2!

unadvise: dwConnection 
	"Invoke the Unadvise() method of the COM Object."

	| hr |
	hr := self Unadvise: dwConnection.
	hr < 0 ifTrue: [self hresultError: hr]
!

Unadvise: dwConnection
	"Private - Invoke the Unadvise() method of the COM object wrapped by the receiver.
	Implementation Note: No auto-raising of HRESULTError through this low-level method.

		HRESULT __stdcall Unadvise(
			[in] unsigned long dwConnection);
	"

	<virtual stdcall: sdword 21 dword>
	^self invalidCall: _failureCode!

Update
	"Private - Invoke the Update() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Update();
	"

	<virtual stdcall: hresult 14>
	^self invalidCall: _failureCode!

verbs
	^[OLEEnumerator onIEnum: self enumVerbs] on: HRESULTError
		do: 
			[:ex | 
			"If we get OLEOBJ_E_NOVERBS then just return an empty collection"
			ex hresult asUnsignedInteger = 16r80040180 ifTrue: [ex return: #()] ifFalse: [ex pass]]! !
!IOleObject categoriesForMethods!
Advise:pdwConnection:!COM Interfaces-IOleObject!private! !
appName!accessing!public! !
close:!methods!public! !
Close:!COM Interfaces-IOleObject!private! !
DoVerb:lpmsg:pActiveSite:lindex:hwndParent:lprcPosRect:!**auto generated**!COM Interfaces-IOleObject!private! !
doVerb:msg:activeSite:parentView:rectangle:!methods!public! !
EnumAdvise:!COM Interfaces-IOleObject!private! !
enumVerbs!accessing!public! !
EnumVerbs:!COM Interfaces-IOleObject!private! !
fullName!accessing!public! !
GetClientSite:!**auto generated**!COM Interfaces-IOleObject!private! !
GetClipboardData:ppDataObject:!COM Interfaces-IOleObject!private! !
getExtent:!**auto generated**!methods!public! !
GetExtent:psizel:!**auto generated**!COM Interfaces-IOleObject!private! !
getMiscStatus:!**auto generated**!methods!public! !
GetMiscStatus:pdwStatus:!**auto generated**!COM Interfaces-IOleObject!private! !
GetMoniker:dwWhichMoniker:ppmk:!COM Interfaces-IOleObject!private! !
getUserClassID!**auto generated**!methods!public! !
GetUserClassID:!**auto generated**!COM Interfaces-IOleObject!private! !
getUserType:!methods!public! !
GetUserType:pszUserType:!**auto generated**!COM Interfaces-IOleObject!private! !
InitFromData:fCreation:dwReserved:!**auto generated**!COM Interfaces-IOleObject!private! !
IsUpToDate!**auto generated**!COM Interfaces-IOleObject!private! !
SetClientSite:!**auto generated**!COM Interfaces-IOleObject!private! !
SetColorScheme:!**auto generated**!COM Interfaces-IOleObject!private! !
setExtent:psizel:!methods!public! !
SetExtent:psizel:!COM Interfaces-IOleObject!private! !
setHostNames:szContainerObj:!**auto generated**!methods!public! !
SetHostNames:szContainerObj:!COM Interfaces-IOleObject!private! !
SetMoniker:pmk:!**auto generated**!COM Interfaces-IOleObject!private! !
shortName!accessing!public! !
unadvise:!methods!public! !
Unadvise:!COM Interfaces-IOleObject!private! !
Update!**auto generated**!COM Interfaces-IOleObject!private! !
verbs!accessing!public! !
!

IOleObject methodProtocol: #'OLEIDL.IOleObject' attributes: #() selectors: #(#Advise:pdwConnection: #Close: #DoVerb:lpmsg:pActiveSite:lindex:hwndParent:lprcPosRect: #EnumAdvise: #EnumVerbs: #GetClientSite: #GetClipboardData:ppDataObject: #GetExtent:psizel: #GetMiscStatus:pdwStatus: #GetMoniker:dwWhichMoniker:ppmk: #GetUserClassID: #GetUserType:pszUserType: #InitFromData:fCreation:dwReserved: #IsUpToDate #SetClientSite: #SetColorScheme: #SetExtent:psizel: #SetHostNames:szContainerObj: #SetMoniker:pmk: #Unadvise: #Update)!

!IOleObject class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OLEIDL.IOleObject'
		IOleObject defineTemplate

	A number of methods returning HRESULTs are defined as returing SDWORDs
	in order to suppress the auto-exception raising.
	"

	self
		defineFunction: #SetClientSite:
			returnType: 'sdword'
			argumentTypes: 'IOleClientSite*';
		defineFunction: #GetClientSite:
			argumentTypes: 'IOleClientSite**';
		defineFunction: #SetHostNames:szContainerObj:
			returnType: 'sdword'
			argumentTypes: 'lpwstr lpwstr';
		defineFunction: #Close:
			returnType: 'sdword'
			argumentTypes: 'dword';
		defineFunction: #SetMoniker:pmk:
"			argumentTypes: 'dword IMoniker*';"
			argumentTypes: 'dword IUnknown*';
		defineFunction: #GetMoniker:dwWhichMoniker:ppmk:
"			argumentTypes: 'dword dword IMoniker**';"
			argumentTypes: 'dword dword IUnknown**';
		defineFunction: #InitFromData:fCreation:dwReserved:
"			argumentTypes: 'IDataObject* sdword dword';"
			argumentTypes: 'IUnknown* sdword dword';
		defineFunction: #GetClipboardData:ppDataObject:
"			argumentTypes: 'dword IDataObject**';"
			argumentTypes: 'dword IUnknown**';
		defineFunction: #DoVerb:lpmsg:pActiveSite:lindex:hwndParent:lprcPosRect:
			argumentTypes: 'sdword MSG* IOleClientSite* sdword handle RECT*';
		defineFunction: #EnumVerbs:
"			argumentTypes: 'IEnumOLEVERB**';"
			argumentTypes: 'IUnknown**';
		defineFunction: #Update;
		defineFunction: #IsUpToDate;
		defineFunction: #GetUserClassID:
			argumentTypes: 'GUID*';
		defineFunction: #GetUserType:pszUserType:
			argumentTypes: 'dword lpwstr*';
		defineFunction: #SetExtent:psizel:
			returnType: 'sdword'		"Fixed size objects return E_FAIL"
			argumentTypes: 'dword SIZE*';
		defineFunction: #GetExtent:psizel:
			argumentTypes: 'dword SIZE*';
		defineFunction: #Advise:pdwConnection:
"			argumentTypes: 'IAdviseSink* dword*';"
			argumentTypes: 'IUnknown* dword*';
		defineFunction: #Unadvise:
			returnType: 'sdword'				"Typically don't care about errors on Unadvise"
			argumentTypes: 'dword';
		defineFunction: #EnumAdvise:
"			argumentTypes: 'IEnumSTATDATA**';"
			argumentTypes: 'IUnknown**';
		defineFunction: #GetMiscStatus:pdwStatus:
			argumentTypes: 'dword dword*';
		defineFunction: #SetColorScheme:
			argumentTypes: 'LOGPALETTE*'
! !
!IOleObject class categoriesForMethods!
defineFunctions!initializing!public! !
!
