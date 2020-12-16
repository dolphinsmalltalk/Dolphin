"Filed out from Dolphin Smalltalk 7"!

SHDocVw.IWebBrowser subclass: #'SHDocVw.IWebBrowserApp'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
SHDocVw.IWebBrowserApp guid: (OS.COM.IID fromString: '{0002df05-0000-0000-c000-000000000046}')!
SHDocVw.IWebBrowserApp comment: '<IWebBrowserApp> is a wrapper class for the COM interface ''SHDocVw.IWebBrowserApp'' generated from type information in the ''Microsoft Internet Controls'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Web Browser Application Interface."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!SHDocVw.IWebBrowserApp categoriesForClass!COM-Interfaces!SHDocVw-Interfaces! !
!SHDocVw.IWebBrowserApp methodsFor!

clientToWindow: pcx pcy: pcy
	"Invoke the ClientToWindow() method of the COM Object.
	Helpstring: 'Converts client sizes into window sizes.'
	Implementation Note: Originally auto-generated, but modified to return a <Point>."

	| x y |
	x := SDWORD new value: pcx; yourself.
	y := SDWORD new value: pcy; yourself.
	self
		ClientToWindow: x
		pcy: y.
	^x value @ y value
!

ClientToWindow: pcx pcy: pcy
	"Private - Invoke the ClientToWindow() method of the COM object.
	Helpstring: Converts client sizes into window sizes.

		HRESULT __stdcall ClientToWindow(
			[in, out]int* pcx,
			[in, out]int* pcy);"

	<virtual stdcall: hresult 34 sdword* sdword*>
	^self invalidCall: _failureCode!

fullName
	"Answer the <bstr> value of the 'FullName' property of the receiver.
	Helpstring: Returns file specification of the application, including path."

	| answer |
	answer := BSTR new.
	self get_FullName: answer.
	^answer asObject!

fullScreen
	"Answer the <varbool> value of the 'FullScreen' property of the receiver.
	Helpstring: Maximizes window and turns off statusbar, toolbar, menubar, and titlebar."

	| answer |
	answer := VARIANT_BOOL new.
	self get_FullScreen: answer.
	^answer asObject!

fullScreen: pbFullScreen
	"Set the 'FullScreen' property of the receiver to the <varbool> value of the argument.
	Helpstring: Maximizes window and turns off statusbar, toolbar, menubar, and titlebar."

	self put_FullScreen: pbFullScreen!

get_FullName: fullName
	"Private - Get the value of the 'FullName' property of the receiver.

		HRESULT __stdcall FullName(
			[out, retval]BSTR* FullName);"

	<virtual stdcall: hresult 39 bstr*>
	^self invalidCall: _failureCode!

get_FullScreen: pbFullScreen
	"Private - Get the value of the 'FullScreen' property of the receiver.

		HRESULT __stdcall FullScreen(
			[out, retval]VARIANT_BOOL* pbFullScreen);"

	<virtual stdcall: hresult 51 varbool*>
	^self invalidCall: _failureCode!

get_HWND: pHWND
	"Private - Get the value of the 'HWND' property of the receiver.

		HRESULT __stdcall HWND(
			[out, retval]long* pHWND);"

	<virtual stdcall: hresult 38 sdword*>
	^self invalidCall: _failureCode!

get_MenuBar: value
	"Private - Get the value of the 'MenuBar' property of the receiver.

		HRESULT __stdcall MenuBar(
			[out, retval]VARIANT_BOOL* Value);"

	<virtual stdcall: hresult 49 varbool*>
	^self invalidCall: _failureCode!

get_Name: name
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* Name);"

	<virtual stdcall: hresult 37 bstr*>
	^self invalidCall: _failureCode!

get_Path: path
	"Private - Get the value of the 'Path' property of the receiver.

		HRESULT __stdcall Path(
			[out, retval]BSTR* Path);"

	<virtual stdcall: hresult 40 bstr*>
	^self invalidCall: _failureCode!

get_StatusBar: pBool
	"Private - Get the value of the 'StatusBar' property of the receiver.

		HRESULT __stdcall StatusBar(
			[out, retval]VARIANT_BOOL* pBool);"

	<virtual stdcall: hresult 43 varbool*>
	^self invalidCall: _failureCode!

get_StatusText: statusText
	"Private - Get the value of the 'StatusText' property of the receiver.

		HRESULT __stdcall StatusText(
			[out, retval]BSTR* StatusText);"

	<virtual stdcall: hresult 45 bstr*>
	^self invalidCall: _failureCode!

get_ToolBar: value
	"Private - Get the value of the 'ToolBar' property of the receiver.

		HRESULT __stdcall ToolBar(
			[out, retval]int* Value);"

	<virtual stdcall: hresult 47 sdword*>
	^self invalidCall: _failureCode!

get_Visible: pBool
	"Private - Get the value of the 'Visible' property of the receiver.

		HRESULT __stdcall Visible(
			[out, retval]VARIANT_BOOL* pBool);"

	<virtual stdcall: hresult 41 varbool*>
	^self invalidCall: _failureCode!

GetProperty: property pvtValue: pvtValue
	"Private - Invoke the GetProperty() method of the COM object.
	Helpstring: Retrieve the Associated value for the property vtValue in the context of the object.

		HRESULT __stdcall GetProperty(
			[in]BSTR Property,
			[out, retval]VARIANT* pvtValue);"

	<virtual stdcall: hresult 36 bstr variant*>
	^self invalidCall: _failureCode!

getProperty_: property
	"Answer the <variant> result of invoking the GetProperty() method of the COM object.
	Helpstring: Retrieve the Associated value for the property vtValue in the context of the object."

	| answer |
	answer := VARIANT new.
	self GetProperty: property pvtValue: answer.
	^answer asObject!

hwnd
	"Answer the <sdword> value of the 'HWND' property of the receiver.
	Helpstring: Returns the HWND of the current IE window."

	| answer |
	answer := SDWORD new.
	self get_HWND: answer.
	^answer asObject!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

menuBar
	"Answer the <varbool> value of the 'MenuBar' property of the receiver.
	Helpstring: Controls whether menubar is shown."

	| answer |
	answer := VARIANT_BOOL new.
	self get_MenuBar: answer.
	^answer asObject!

menuBar: value
	"Set the 'MenuBar' property of the receiver to the <varbool> value of the argument.
	Helpstring: Controls whether menubar is shown."

	self put_MenuBar: value!

name
	"Answer the <bstr> value of the 'Name' property of the receiver.
	Helpstring: Returns name of the application."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject!

path
	"Answer the <bstr> value of the 'Path' property of the receiver.
	Helpstring: Returns the path to the application."

	| answer |
	answer := BSTR new.
	self get_Path: answer.
	^answer asObject!

put_FullScreen: pbFullScreen
	"Private - Set the value of the 'FullScreen' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbFullScreen.

		HRESULT __stdcall FullScreen(
			[in]VARIANT_BOOL pbFullScreen);"

	<virtual stdcall: hresult 52 varbool>
	^self invalidCall: _failureCode!

put_MenuBar: value
	"Private - Set the value of the 'MenuBar' property of the object wrapped by the 
	 receiver to the <varbool> argument, value.

		HRESULT __stdcall MenuBar(
			[in]VARIANT_BOOL Value);"

	<virtual stdcall: hresult 50 varbool>
	^self invalidCall: _failureCode!

put_StatusBar: pBool
	"Private - Set the value of the 'StatusBar' property of the object wrapped by the 
	 receiver to the <varbool> argument, pBool.

		HRESULT __stdcall StatusBar(
			[in]VARIANT_BOOL pBool);"

	<virtual stdcall: hresult 44 varbool>
	^self invalidCall: _failureCode!

put_StatusText: statusText
	"Private - Set the value of the 'StatusText' property of the object wrapped by the 
	 receiver to the <bstr> argument, statusText.

		HRESULT __stdcall StatusText(
			[in]BSTR StatusText);"

	<virtual stdcall: hresult 46 bstr>
	^self invalidCall: _failureCode!

put_ToolBar: value
	"Private - Set the value of the 'ToolBar' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ToolBar(
			[in]int Value);"

	<virtual stdcall: hresult 48 sdword>
	^self invalidCall: _failureCode!

put_Visible: pBool
	"Private - Set the value of the 'Visible' property of the object wrapped by the 
	 receiver to the <varbool> argument, pBool.

		HRESULT __stdcall Visible(
			[in]VARIANT_BOOL pBool);"

	<virtual stdcall: hresult 42 varbool>
	^self invalidCall: _failureCode!

putProperty: property vtValue: vtValue
	"Invoke the PutProperty() method of the COM object.
	Helpstring: Associates vtValue with the name szProperty in the context of the object."

	^self PutProperty: property vtValue: vtValue asVariant!

PutProperty: property vtValue: vtValue
	"Private - Invoke the PutProperty() method of the COM object.
	Helpstring: Associates vtValue with the name szProperty in the context of the object.

		HRESULT __stdcall PutProperty(
			[in]BSTR Property,
			[in]VARIANT vtValue);"

	<virtual stdcall: hresult 35 bstr variant>
	^self invalidCall: _failureCode!

Quit
	"Invoke the Quit() method of the COM object.
	Helpstring: Exits application and closes the open document.

		HRESULT __stdcall Quit();"

	<virtual stdcall: hresult 33>
	^self invalidCall: _failureCode!

statusBar
	"Answer the <varbool> value of the 'StatusBar' property of the receiver.
	Helpstring: Turn on or off the statusbar."

	| answer |
	answer := VARIANT_BOOL new.
	self get_StatusBar: answer.
	^answer asObject!

statusBar: pBool
	"Set the 'StatusBar' property of the receiver to the <varbool> value of the argument.
	Helpstring: Turn on or off the statusbar."

	self put_StatusBar: pBool!

statusText
	"Answer the <bstr> value of the 'StatusText' property of the receiver.
	Helpstring: Text of Status window."

	| answer |
	answer := BSTR new.
	self get_StatusText: answer.
	^answer asObject!

statusText: statusText
	"Set the 'StatusText' property of the receiver to the <bstr> value of the argument.
	Helpstring: Text of Status window."

	self put_StatusText: statusText!

toolBar
	"Answer the <sdword> value of the 'ToolBar' property of the receiver.
	Helpstring: Controls which toolbar is shown."

	| answer |
	answer := SDWORD new.
	self get_ToolBar: answer.
	^answer asObject!

toolBar: value
	"Set the 'ToolBar' property of the receiver to the <sdword> value of the argument.
	Helpstring: Controls which toolbar is shown."

	self put_ToolBar: value!

value
	"Answer the <bstr> value of the 'Name' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self name!

visible
	"Answer the <varbool> value of the 'Visible' property of the receiver.
	Helpstring: Determines whether the application is visible or hidden."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Visible: answer.
	^answer asObject!

visible: pBool
	"Set the 'Visible' property of the receiver to the <varbool> value of the argument.
	Helpstring: Determines whether the application is visible or hidden."

	self put_Visible: pBool! !
!SHDocVw.IWebBrowserApp categoriesFor: #clientToWindow:pcy:!methods!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #ClientToWindow:pcy:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #fullName!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #fullScreen!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #fullScreen:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_FullName:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_FullScreen:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_HWND:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_MenuBar:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_Name:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_Path:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_StatusBar:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_StatusText:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_ToolBar:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #GetProperty:pvtValue:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #getProperty_:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #hwnd!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #isExtensible!**auto generated**!public!testing! !
!SHDocVw.IWebBrowserApp categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!SHDocVw.IWebBrowserApp categoriesFor: #menuBar!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #menuBar:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #name!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #path!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #put_FullScreen:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #put_MenuBar:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #put_StatusBar:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #put_StatusText:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #put_ToolBar:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #put_Visible:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #putProperty:vtValue:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #PutProperty:vtValue:!**auto generated**!COM Interfaces-IWebBrowserApp!private! !
!SHDocVw.IWebBrowserApp categoriesFor: #Quit!**auto generated**!COM Interfaces-IWebBrowserApp!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #statusBar!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #statusBar:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #statusText!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #statusText:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #toolBar!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #toolBar:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #value!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #visible!**auto generated**!properties!public! !
!SHDocVw.IWebBrowserApp categoriesFor: #visible:!**auto generated**!properties!public! !

!SHDocVw.IWebBrowserApp class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SHDocVw.IWebBrowserApp'
		IWebBrowserApp defineTemplate"

	self
		defineFunction: #Quit;
		defineFunction: #ClientToWindow:pcy:
			argumentTypes: 'sdword* sdword*';
		defineFunction: #PutProperty:vtValue:
			argumentTypes: 'bstr variant';
		defineFunction: #GetProperty:pvtValue:
			argumentTypes: 'bstr variant*';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_HWND:
			argumentTypes: 'sdword*';
		defineFunction: #get_FullName:
			argumentTypes: 'bstr*';
		defineFunction: #get_Path:
			argumentTypes: 'bstr*';
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_Visible:
			argumentTypes: 'varbool';
		defineFunction: #get_StatusBar:
			argumentTypes: 'varbool*';
		defineFunction: #put_StatusBar:
			argumentTypes: 'varbool';
		defineFunction: #get_StatusText:
			argumentTypes: 'bstr*';
		defineFunction: #put_StatusText:
			argumentTypes: 'bstr';
		defineFunction: #get_ToolBar:
			argumentTypes: 'sdword*';
		defineFunction: #put_ToolBar:
			argumentTypes: 'sdword';
		defineFunction: #get_MenuBar:
			argumentTypes: 'varbool*';
		defineFunction: #put_MenuBar:
			argumentTypes: 'varbool';
		defineFunction: #get_FullScreen:
			argumentTypes: 'varbool*';
		defineFunction: #put_FullScreen:
			argumentTypes: 'varbool'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IWebBrowserApp initializeTypeLib"

	typeLib := SHDocVwLib! !
!SHDocVw.IWebBrowserApp class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!SHDocVw.IWebBrowserApp class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

