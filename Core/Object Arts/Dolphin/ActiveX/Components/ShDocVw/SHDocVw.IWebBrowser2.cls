"Filed out from Dolphin Smalltalk 7"!

SHDocVw.IWebBrowserApp subclass: #'SHDocVw.IWebBrowser2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
SHDocVw.IWebBrowser2 guid: (OS.COM.IID fromString: '{d30c1661-cdaf-11d0-8a3e-00c04fc9e26e}')!
SHDocVw.IWebBrowser2 comment: '<IWebBrowser2> is a wrapper class for the COM interface ''SHDocVw.IWebBrowser2'' generated from type information in the ''Microsoft Internet Controls'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Web Browser Interface for IE4."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!SHDocVw.IWebBrowser2 categoriesForClass!COM-Interfaces!SHDocVw-Interfaces! !
!SHDocVw.IWebBrowser2 methodsFor!

addressBar
	"Answer the <varbool> value of the 'AddressBar' property of the receiver.
	Helpstring: Controls whether address bar is shown"

	| answer |
	answer := VARIANT_BOOL new.
	self get_AddressBar: answer.
	^answer asObject!

addressBar: value
	"Set the 'AddressBar' property of the receiver to the <varbool> value of the argument.
	Helpstring: Controls whether address bar is shown"

	self put_AddressBar: value!

execWB: cmdID cmdexecopt: cmdexecopt
	"Invoke the ExecWB() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		execWB: cmdID
		cmdexecopt: cmdexecopt
		pvaIn: VARIANT unspecified
		pvaOut: VARIANT unspecified!

execWB: cmdID cmdexecopt: cmdexecopt pvaIn: pvaIn pvaOut: pvaOut
	"Invoke the ExecWB() method of the COM object.
	Helpstring: IOleCommandTarget::Exec"

	^self
		ExecWB: cmdID
		cmdexecopt: cmdexecopt
		pvaIn: pvaIn asVariant
		pvaOut: pvaOut asVariant!

ExecWB: cmdID cmdexecopt: cmdexecopt pvaIn: pvaIn pvaOut: pvaOut
	"Private - Invoke the ExecWB() method of the COM object.
	Helpstring: IOleCommandTarget::Exec

		HRESULT __stdcall ExecWB(
			[in]OLECMDID cmdID,
			[in]OLECMDEXECOPT cmdexecopt,
			[in, optional]VARIANT* pvaIn,
			[in, out, optional]VARIANT* pvaOut);"

	<virtual stdcall: hresult 55 sdword sdword variant* variant*>
	^self invalidCall: _failureCode!

get_AddressBar: value
	"Private - Get the value of the 'AddressBar' property of the receiver.

		HRESULT __stdcall AddressBar(
			[out, retval]VARIANT_BOOL* Value);"

	<virtual stdcall: hresult 68 varbool*>
	^self invalidCall: _failureCode!

get_Offline: pbOffline
	"Private - Get the value of the 'Offline' property of the receiver.

		HRESULT __stdcall Offline(
			[out, retval]VARIANT_BOOL* pbOffline);"

	<virtual stdcall: hresult 58 varbool*>
	^self invalidCall: _failureCode!

get_ReadyState: plReadyState
	"Private - Get the value of the 'ReadyState' property of the receiver.

		HRESULT __stdcall ReadyState(
			[out, retval]READYSTATE* plReadyState);"

	<virtual stdcall: hresult 57 sdword*>
	^self invalidCall: _failureCode!

get_RegisterAsBrowser: pbRegister
	"Private - Get the value of the 'RegisterAsBrowser' property of the receiver.

		HRESULT __stdcall RegisterAsBrowser(
			[out, retval]VARIANT_BOOL* pbRegister);"

	<virtual stdcall: hresult 62 varbool*>
	^self invalidCall: _failureCode!

get_RegisterAsDropTarget: pbRegister
	"Private - Get the value of the 'RegisterAsDropTarget' property of the receiver.

		HRESULT __stdcall RegisterAsDropTarget(
			[out, retval]VARIANT_BOOL* pbRegister);"

	<virtual stdcall: hresult 64 varbool*>
	^self invalidCall: _failureCode!

get_Resizable: value
	"Private - Get the value of the 'Resizable' property of the receiver.

		HRESULT __stdcall Resizable(
			[out, retval]VARIANT_BOOL* Value);"

	<virtual stdcall: hresult 70 varbool*>
	^self invalidCall: _failureCode!

get_Silent: pbSilent
	"Private - Get the value of the 'Silent' property of the receiver.

		HRESULT __stdcall Silent(
			[out, retval]VARIANT_BOOL* pbSilent);"

	<virtual stdcall: hresult 60 varbool*>
	^self invalidCall: _failureCode!

get_TheaterMode: pbRegister
	"Private - Get the value of the 'TheaterMode' property of the receiver.

		HRESULT __stdcall TheaterMode(
			[out, retval]VARIANT_BOOL* pbRegister);"

	<virtual stdcall: hresult 66 varbool*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

navigate2: url
	"Invoke the Navigate2() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		navigate2: url
		flags: VARIANT unspecified
		targetFrameName: VARIANT unspecified
		postData: VARIANT unspecified
		headers: VARIANT unspecified!

navigate2: url flags: flags targetFrameName: targetFrameName postData: postData headers: headers
	"Invoke the Navigate2() method of the COM object.
	Helpstring: Navigates to a URL or file or pidl."

	^self
		Navigate2: url asVariant
		Flags: flags asVariant
		TargetFrameName: targetFrameName asVariant
		PostData: postData asVariant
		Headers: headers asVariant!

Navigate2: url Flags: flags TargetFrameName: targetFrameName PostData: postData Headers: headers
	"Private - Invoke the Navigate2() method of the COM object.
	Helpstring: Navigates to a URL or file or pidl.

		HRESULT __stdcall Navigate2(
			[in]VARIANT* URL,
			[in, optional]VARIANT* Flags,
			[in, optional]VARIANT* TargetFrameName,
			[in, optional]VARIANT* PostData,
			[in, optional]VARIANT* Headers);"

	<virtual stdcall: hresult 53 variant* variant* variant* variant* variant*>
	^self invalidCall: _failureCode!

offline
	"Answer the <varbool> value of the 'Offline' property of the receiver.
	Helpstring: Controls if the frame is offline (read from cache)"

	| answer |
	answer := VARIANT_BOOL new.
	self get_Offline: answer.
	^answer asObject!

offline: pbOffline
	"Set the 'Offline' property of the receiver to the <varbool> value of the argument.
	Helpstring: Controls if the frame is offline (read from cache)"

	self put_Offline: pbOffline!

put_AddressBar: value
	"Private - Set the value of the 'AddressBar' property of the object wrapped by the 
	 receiver to the <varbool> argument, value.

		HRESULT __stdcall AddressBar(
			[in]VARIANT_BOOL Value);"

	<virtual stdcall: hresult 69 varbool>
	^self invalidCall: _failureCode!

put_Offline: pbOffline
	"Private - Set the value of the 'Offline' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbOffline.

		HRESULT __stdcall Offline(
			[in]VARIANT_BOOL pbOffline);"

	<virtual stdcall: hresult 59 varbool>
	^self invalidCall: _failureCode!

put_RegisterAsBrowser: pbRegister
	"Private - Set the value of the 'RegisterAsBrowser' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbRegister.

		HRESULT __stdcall RegisterAsBrowser(
			[in]VARIANT_BOOL pbRegister);"

	<virtual stdcall: hresult 63 varbool>
	^self invalidCall: _failureCode!

put_RegisterAsDropTarget: pbRegister
	"Private - Set the value of the 'RegisterAsDropTarget' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbRegister.

		HRESULT __stdcall RegisterAsDropTarget(
			[in]VARIANT_BOOL pbRegister);"

	<virtual stdcall: hresult 65 varbool>
	^self invalidCall: _failureCode!

put_Resizable: value
	"Private - Set the value of the 'Resizable' property of the object wrapped by the 
	 receiver to the <varbool> argument, value.

		HRESULT __stdcall Resizable(
			[in]VARIANT_BOOL Value);"

	<virtual stdcall: hresult 71 varbool>
	^self invalidCall: _failureCode!

put_Silent: pbSilent
	"Private - Set the value of the 'Silent' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbSilent.

		HRESULT __stdcall Silent(
			[in]VARIANT_BOOL pbSilent);"

	<virtual stdcall: hresult 61 varbool>
	^self invalidCall: _failureCode!

put_TheaterMode: pbRegister
	"Private - Set the value of the 'TheaterMode' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbRegister.

		HRESULT __stdcall TheaterMode(
			[in]VARIANT_BOOL pbRegister);"

	<virtual stdcall: hresult 67 varbool>
	^self invalidCall: _failureCode!

queryStatusWB: cmdID
	"Answer the <sdword> result of invoking the QueryStatusWB() method of the COM object.
	Helpstring: IOleCommandTarget::QueryStatus"

	| answer |
	answer := SDWORD new.
	self QueryStatusWB: cmdID pcmdf: answer.
	^answer asObject!

QueryStatusWB: cmdID pcmdf: pcmdf
	"Private - Invoke the QueryStatusWB() method of the COM object.
	Helpstring: IOleCommandTarget::QueryStatus

		HRESULT __stdcall QueryStatusWB(
			[in]OLECMDID cmdID,
			[out, retval]OLECMDF* pcmdf);"

	<virtual stdcall: hresult 54 sdword sdword*>
	^self invalidCall: _failureCode!

readyState
	"Answer the <sdword> value of the 'ReadyState' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ReadyState: answer.
	^answer asObject!

registerAsBrowser
	"Answer the <varbool> value of the 'RegisterAsBrowser' property of the receiver.
	Helpstring: Registers OC as a top-level browser (for target name resolution)"

	| answer |
	answer := VARIANT_BOOL new.
	self get_RegisterAsBrowser: answer.
	^answer asObject!

registerAsBrowser: pbRegister
	"Set the 'RegisterAsBrowser' property of the receiver to the <varbool> value of the argument.
	Helpstring: Registers OC as a top-level browser (for target name resolution)"

	self put_RegisterAsBrowser: pbRegister!

registerAsDropTarget
	"Answer the <varbool> value of the 'RegisterAsDropTarget' property of the receiver.
	Helpstring: Registers OC as a drop target for navigation"

	| answer |
	answer := VARIANT_BOOL new.
	self get_RegisterAsDropTarget: answer.
	^answer asObject!

registerAsDropTarget: pbRegister
	"Set the 'RegisterAsDropTarget' property of the receiver to the <varbool> value of the argument.
	Helpstring: Registers OC as a drop target for navigation"

	self put_RegisterAsDropTarget: pbRegister!

resizable
	"Answer the <varbool> value of the 'Resizable' property of the receiver.
	Helpstring: Controls whether the window is resizable"

	| answer |
	answer := VARIANT_BOOL new.
	self get_Resizable: answer.
	^answer asObject!

resizable: value
	"Set the 'Resizable' property of the receiver to the <varbool> value of the argument.
	Helpstring: Controls whether the window is resizable"

	self put_Resizable: value!

showBrowserBar: pvaClsid
	"Invoke the ShowBrowserBar() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		showBrowserBar: pvaClsid
		pvarShow: VARIANT unspecified
		pvarSize: VARIANT unspecified!

showBrowserBar: pvaClsid pvarShow: pvarShow pvarSize: pvarSize
	"Invoke the ShowBrowserBar() method of the COM object.
	Helpstring: Set BrowserBar to Clsid"

	^self
		ShowBrowserBar: pvaClsid asVariant
		pvarShow: pvarShow asVariant
		pvarSize: pvarSize asVariant!

ShowBrowserBar: pvaClsid pvarShow: pvarShow pvarSize: pvarSize
	"Private - Invoke the ShowBrowserBar() method of the COM object.
	Helpstring: Set BrowserBar to Clsid

		HRESULT __stdcall ShowBrowserBar(
			[in]VARIANT* pvaClsid,
			[in, optional]VARIANT* pvarShow,
			[in, optional]VARIANT* pvarSize);"

	<virtual stdcall: hresult 56 variant* variant* variant*>
	^self invalidCall: _failureCode!

silent
	"Answer the <varbool> value of the 'Silent' property of the receiver.
	Helpstring: Controls if any dialog boxes can be shown"

	| answer |
	answer := VARIANT_BOOL new.
	self get_Silent: answer.
	^answer asObject!

silent: pbSilent
	"Set the 'Silent' property of the receiver to the <varbool> value of the argument.
	Helpstring: Controls if any dialog boxes can be shown"

	self put_Silent: pbSilent!

theaterMode
	"Answer the <varbool> value of the 'TheaterMode' property of the receiver.
	Helpstring: Controls if the browser is in theater mode"

	| answer |
	answer := VARIANT_BOOL new.
	self get_TheaterMode: answer.
	^answer asObject!

theaterMode: pbRegister
	"Set the 'TheaterMode' property of the receiver to the <varbool> value of the argument.
	Helpstring: Controls if the browser is in theater mode"

	self put_TheaterMode: pbRegister! !
!SHDocVw.IWebBrowser2 categoriesFor: #addressBar!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #addressBar:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #execWB:cmdexecopt:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #execWB:cmdexecopt:pvaIn:pvaOut:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #ExecWB:cmdexecopt:pvaIn:pvaOut:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_AddressBar:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_Offline:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_ReadyState:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_RegisterAsBrowser:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_RegisterAsDropTarget:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_Resizable:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_Silent:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #get_TheaterMode:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #isExtensible!**auto generated**!public!testing! !
!SHDocVw.IWebBrowser2 categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!SHDocVw.IWebBrowser2 categoriesFor: #navigate2:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #navigate2:flags:targetFrameName:postData:headers:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #Navigate2:Flags:TargetFrameName:PostData:Headers:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #offline!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #offline:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_AddressBar:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_Offline:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_RegisterAsBrowser:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_RegisterAsDropTarget:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_Resizable:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_Silent:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #put_TheaterMode:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #queryStatusWB:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #QueryStatusWB:pcmdf:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #readyState!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #registerAsBrowser!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #registerAsBrowser:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #registerAsDropTarget!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #registerAsDropTarget:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #resizable!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #resizable:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #showBrowserBar:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #showBrowserBar:pvarShow:pvarSize:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #ShowBrowserBar:pvarShow:pvarSize:!**auto generated**!COM Interfaces-IWebBrowser2!private! !
!SHDocVw.IWebBrowser2 categoriesFor: #silent!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #silent:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #theaterMode!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser2 categoriesFor: #theaterMode:!**auto generated**!properties!public! !

!SHDocVw.IWebBrowser2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SHDocVw.IWebBrowser2'
		IWebBrowser2 defineTemplate"

	self
		defineFunction: #Navigate2:Flags:TargetFrameName:PostData:Headers:
			argumentTypes: 'variant* variant* variant* variant* variant*';
		defineFunction: #QueryStatusWB:pcmdf:
			argumentTypes: 'sdword sdword*';
		defineFunction: #ExecWB:cmdexecopt:pvaIn:pvaOut:
			argumentTypes: 'sdword sdword variant* variant*';
		defineFunction: #ShowBrowserBar:pvarShow:pvarSize:
			argumentTypes: 'variant* variant* variant*';
		defineFunction: #get_ReadyState:
			argumentTypes: 'sdword*';
		defineFunction: #get_Offline:
			argumentTypes: 'varbool*';
		defineFunction: #put_Offline:
			argumentTypes: 'varbool';
		defineFunction: #get_Silent:
			argumentTypes: 'varbool*';
		defineFunction: #put_Silent:
			argumentTypes: 'varbool';
		defineFunction: #get_RegisterAsBrowser:
			argumentTypes: 'varbool*';
		defineFunction: #put_RegisterAsBrowser:
			argumentTypes: 'varbool';
		defineFunction: #get_RegisterAsDropTarget:
			argumentTypes: 'varbool*';
		defineFunction: #put_RegisterAsDropTarget:
			argumentTypes: 'varbool';
		defineFunction: #get_TheaterMode:
			argumentTypes: 'varbool*';
		defineFunction: #put_TheaterMode:
			argumentTypes: 'varbool';
		defineFunction: #get_AddressBar:
			argumentTypes: 'varbool*';
		defineFunction: #put_AddressBar:
			argumentTypes: 'varbool';
		defineFunction: #get_Resizable:
			argumentTypes: 'varbool*';
		defineFunction: #put_Resizable:
			argumentTypes: 'varbool'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IWebBrowser2 initializeTypeLib"

	typeLib := SHDocVwLib!

newInternetExplorer
	"Answer a new instance of the receiver on the InternetExplorer COM object"

	^self onCLSID: (CLSID fromString: '{0002df01-0000-0000-c000-000000000046}')
!

newInternetExplorerMedium
	"Answer a new instance of the receiver on the InternetExplorerMedium COM object"

	^self onCLSID: (CLSID fromString: '{d5e8041d-920f-45e9-b8fb-b1deb82c6e5e}')
!

newShellBrowserWindow
	"Answer a new instance of the receiver on the ShellBrowserWindow COM object"

	^self onCLSID: (CLSID fromString: '{c08afd90-f2a1-11d1-8455-00a0c91f3880}')
!

newWebBrowser
	"Answer a new instance of the receiver on the WebBrowser COM object"

	^self onCLSID: (CLSID fromString: '{8856f961-340a-11d0-a96b-00c04fd705a2}')
! !
!SHDocVw.IWebBrowser2 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!SHDocVw.IWebBrowser2 class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !
!SHDocVw.IWebBrowser2 class categoriesFor: #newInternetExplorer!**auto generated**!instance creation!private! !
!SHDocVw.IWebBrowser2 class categoriesFor: #newInternetExplorerMedium!**auto generated**!instance creation!private! !
!SHDocVw.IWebBrowser2 class categoriesFor: #newShellBrowserWindow!**auto generated**!instance creation!private! !
!SHDocVw.IWebBrowser2 class categoriesFor: #newWebBrowser!**auto generated**!instance creation!private! !

