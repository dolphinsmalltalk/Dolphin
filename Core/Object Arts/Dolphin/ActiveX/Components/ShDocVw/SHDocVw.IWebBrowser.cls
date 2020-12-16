"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'SHDocVw.IWebBrowser'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
SHDocVw.IWebBrowser guid: (OS.COM.IID fromString: '{eab22ac1-30c1-11cf-a7eb-0000c05bae0b}')!
SHDocVw.IWebBrowser comment: '<IWebBrowser> is a wrapper class for the COM interface ''SHDocVw.IWebBrowser'' generated from type information in the ''Microsoft Internet Controls'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Web Browser interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!SHDocVw.IWebBrowser categoriesForClass!COM-Interfaces!SHDocVw-Interfaces! !
!SHDocVw.IWebBrowser methodsFor!

application
	"Answer the <IDispatch> value of the 'Application' property of the receiver.
	Helpstring: Returns the application automation object if accessible, this automation object otherwise.."

	| answer |
	answer := IDispatch newPointer.
	self get_Application: answer.
	^answer asObject!

busy
	"Answer the <varbool> value of the 'Busy' property of the receiver.
	Helpstring: Query to see if something is still in progress."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Busy: answer.
	^answer asObject!

container
	"Answer the <IDispatch> value of the 'Container' property of the receiver.
	Helpstring: Returns the container/parent automation object, if any."

	| answer |
	answer := IDispatch newPointer.
	self get_Container: answer.
	^answer asObject!

document
	"Answer the <IDispatch> value of the 'Document' property of the receiver.
	Helpstring: Returns the active Document automation object, if any."

	| answer |
	answer := IDispatch newPointer.
	self get_Document: answer.
	^answer asObject!

get_Application: ppDisp
	"Private - Get the value of the 'Application' property of the receiver.

		HRESULT __stdcall Application(
			[out, retval]IDispatch** ppDisp);"

	<virtual stdcall: hresult 16 IDispatch**>
	^self invalidCall: _failureCode!

get_Busy: pBool
	"Private - Get the value of the 'Busy' property of the receiver.

		HRESULT __stdcall Busy(
			[out, retval]VARIANT_BOOL* pBool);"

	<virtual stdcall: hresult 32 varbool*>
	^self invalidCall: _failureCode!

get_Container: ppDisp
	"Private - Get the value of the 'Container' property of the receiver.

		HRESULT __stdcall Container(
			[out, retval]IDispatch** ppDisp);"

	<virtual stdcall: hresult 18 IDispatch**>
	^self invalidCall: _failureCode!

get_Document: ppDisp
	"Private - Get the value of the 'Document' property of the receiver.

		HRESULT __stdcall Document(
			[out, retval]IDispatch** ppDisp);"

	<virtual stdcall: hresult 19 IDispatch**>
	^self invalidCall: _failureCode!

get_Height: pl
	"Private - Get the value of the 'Height' property of the receiver.

		HRESULT __stdcall Height(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 28 sdword*>
	^self invalidCall: _failureCode!

get_Left: pl
	"Private - Get the value of the 'Left' property of the receiver.

		HRESULT __stdcall Left(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall: _failureCode!

get_LocationName: locationName
	"Private - Get the value of the 'LocationName' property of the receiver.

		HRESULT __stdcall LocationName(
			[out, retval]BSTR* LocationName);"

	<virtual stdcall: hresult 30 bstr*>
	^self invalidCall: _failureCode!

get_LocationURL: locationURL
	"Private - Get the value of the 'LocationURL' property of the receiver.

		HRESULT __stdcall LocationURL(
			[out, retval]BSTR* LocationURL);"

	<virtual stdcall: hresult 31 bstr*>
	^self invalidCall: _failureCode!

get_Parent: ppDisp
	"Private - Get the value of the 'Parent' property of the receiver.

		HRESULT __stdcall Parent(
			[out, retval]IDispatch** ppDisp);"

	<virtual stdcall: hresult 17 IDispatch**>
	^self invalidCall: _failureCode!

get_Top: pl
	"Private - Get the value of the 'Top' property of the receiver.

		HRESULT __stdcall Top(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall: _failureCode!

get_TopLevelContainer: pBool
	"Private - Get the value of the 'TopLevelContainer' property of the receiver.

		HRESULT __stdcall TopLevelContainer(
			[out, retval]VARIANT_BOOL* pBool);"

	<virtual stdcall: hresult 20 varbool*>
	^self invalidCall: _failureCode!

get_Type: type
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval]BSTR* Type);"

	<virtual stdcall: hresult 21 bstr*>
	^self invalidCall: _failureCode!

get_Width: pl
	"Private - Get the value of the 'Width' property of the receiver.

		HRESULT __stdcall Width(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 26 sdword*>
	^self invalidCall: _failureCode!

GoBack
	"Invoke the GoBack() method of the COM object.
	Helpstring: Navigates to the previous item in the history list.

		HRESULT __stdcall GoBack();"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode!

GoForward
	"Invoke the GoForward() method of the COM object.
	Helpstring: Navigates to the next item in the history list.

		HRESULT __stdcall GoForward();"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

GoHome
	"Invoke the GoHome() method of the COM object.
	Helpstring: Go home/start page.

		HRESULT __stdcall GoHome();"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode!

GoSearch
	"Invoke the GoSearch() method of the COM object.
	Helpstring: Go Search Page.

		HRESULT __stdcall GoSearch();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

height
	"Answer the <sdword> value of the 'Height' property of the receiver.
	Helpstring: The vertical dimension (pixels) of the frame window/object."

	| answer |
	answer := SDWORD new.
	self get_Height: answer.
	^answer asObject!

height: pl
	"Set the 'Height' property of the receiver to the <sdword> value of the argument.
	Helpstring: The vertical dimension (pixels) of the frame window/object."

	self put_Height: pl!

left
	"Answer the <sdword> value of the 'Left' property of the receiver.
	Helpstring: The horizontal position (pixels) of the frame window relative to the screen/container."

	| answer |
	answer := SDWORD new.
	self get_Left: answer.
	^answer asObject!

left: pl
	"Set the 'Left' property of the receiver to the <sdword> value of the argument.
	Helpstring: The horizontal position (pixels) of the frame window relative to the screen/container."

	self put_Left: pl!

locationName
	"Answer the <bstr> value of the 'LocationName' property of the receiver.
	Helpstring: Gets the short (UI-friendly) name of the URL/file currently viewed."

	| answer |
	answer := BSTR new.
	self get_LocationName: answer.
	^answer asObject!

locationURL
	"Answer the <bstr> value of the 'LocationURL' property of the receiver.
	Helpstring: Gets the full URL/path currently viewed."

	| answer |
	answer := BSTR new.
	self get_LocationURL: answer.
	^answer asObject!

navigate: url
	"Navigate to a new URL."

	| missing |
	missing := VARIANT unspecified.
	self navigate: url
		flags: missing 
		targetFrameName: missing
		postData: missing
		headers: missing
!

navigate: url flags: flags targetFrameName: targetFrameName postData: postData headers: headers
	"Invoke the Navigate() method of the COM object.
	Helpstring: Navigates to a URL or file."

	^self
		Navigate: url
		Flags: flags asVariant
		TargetFrameName: targetFrameName asVariant
		PostData: postData asVariant
		Headers: headers asVariant!

Navigate: url Flags: flags TargetFrameName: targetFrameName PostData: postData Headers: headers
	"Private - Invoke the Navigate() method of the COM object.
	Helpstring: Navigates to a URL or file.

		HRESULT __stdcall Navigate(
			[in]BSTR URL,
			[in, optional]VARIANT* Flags,
			[in, optional]VARIANT* TargetFrameName,
			[in, optional]VARIANT* PostData,
			[in, optional]VARIANT* Headers);"

	<virtual stdcall: hresult 12 bstr variant* variant* variant* variant*>
	^self invalidCall: _failureCode!

parent
	"Answer the <IDispatch> value of the 'Parent' property of the receiver.
	Helpstring: Returns the automation object of the container/parent if one exists or this automation object."

	| answer |
	answer := IDispatch newPointer.
	self get_Parent: answer.
	^answer asObject!

put_Height: pl
	"Private - Set the value of the 'Height' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall Height(
			[in]long pl);"

	<virtual stdcall: hresult 29 sdword>
	^self invalidCall: _failureCode!

put_Left: pl
	"Private - Set the value of the 'Left' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall Left(
			[in]long pl);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall: _failureCode!

put_Top: pl
	"Private - Set the value of the 'Top' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall Top(
			[in]long pl);"

	<virtual stdcall: hresult 25 sdword>
	^self invalidCall: _failureCode!

put_Width: pl
	"Private - Set the value of the 'Width' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall Width(
			[in]long pl);"

	<virtual stdcall: hresult 27 sdword>
	^self invalidCall: _failureCode!

Refresh
	"Invoke the Refresh() method of the COM object.
	Helpstring: Refresh the currently viewed page.

		HRESULT __stdcall Refresh();"

	<virtual stdcall: hresult 13>
	^self invalidCall: _failureCode!

refresh2
	"Invoke the Refresh2() method of the COM object.
	Default values are passed for all optional parameters."

	^self refresh2: VARIANT unspecified!

refresh2: level
	"Invoke the Refresh2() method of the COM object.
	Helpstring: Refresh the currently viewed page."

	^self Refresh2: level asVariant!

Refresh2: level
	"Private - Invoke the Refresh2() method of the COM object.
	Helpstring: Refresh the currently viewed page.

		HRESULT __stdcall Refresh2(
			[in, optional]VARIANT* Level);"

	<virtual stdcall: hresult 14 variant*>
	^self invalidCall: _failureCode!

Stop
	"Invoke the Stop() method of the COM object.
	Helpstring: Stops opening a file.

		HRESULT __stdcall Stop();"

	<virtual stdcall: hresult 15>
	^self invalidCall: _failureCode!

top
	"Answer the <sdword> value of the 'Top' property of the receiver.
	Helpstring: The vertical position (pixels) of the frame window relative to the screen/container."

	| answer |
	answer := SDWORD new.
	self get_Top: answer.
	^answer asObject!

top: pl
	"Set the 'Top' property of the receiver to the <sdword> value of the argument.
	Helpstring: The vertical position (pixels) of the frame window relative to the screen/container."

	self put_Top: pl!

topLevelContainer
	"Answer the <varbool> value of the 'TopLevelContainer' property of the receiver.
	Helpstring: Returns True if this is the top level object."

	| answer |
	answer := VARIANT_BOOL new.
	self get_TopLevelContainer: answer.
	^answer asObject!

type
	"Answer the <bstr> value of the 'Type' property of the receiver.
	Helpstring: Returns the type of the contained document object."

	| answer |
	answer := BSTR new.
	self get_Type: answer.
	^answer asObject!

value
	"Answer the URL currently under scrutiny.
	Implementation Note: The value property on this interface (well actually on the derived interface
	<IWebBrowserApp>) is a particularly cretinous choice - the 'application' name, and is read only.
	The URL is a more sensible choice."

	^self locationURL!

value: value
	"Set the special property which is the default value for the receiver."

	self navigate: value
!

width
	"Answer the <sdword> value of the 'Width' property of the receiver.
	Helpstring: The horizontal dimension (pixels) of the frame window/object."

	| answer |
	answer := SDWORD new.
	self get_Width: answer.
	^answer asObject!

width: pl
	"Set the 'Width' property of the receiver to the <sdword> value of the argument.
	Helpstring: The horizontal dimension (pixels) of the frame window/object."

	self put_Width: pl! !
!SHDocVw.IWebBrowser categoriesFor: #application!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #busy!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #container!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #document!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #get_Application:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Busy:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Container:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Document:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Height:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Left:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_LocationName:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_LocationURL:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Parent:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Top:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_TopLevelContainer:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Type:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #get_Width:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #GoBack!**auto generated**!COM Interfaces-IWebBrowser!public! !
!SHDocVw.IWebBrowser categoriesFor: #GoForward!**auto generated**!COM Interfaces-IWebBrowser!public! !
!SHDocVw.IWebBrowser categoriesFor: #GoHome!**auto generated**!COM Interfaces-IWebBrowser!public! !
!SHDocVw.IWebBrowser categoriesFor: #GoSearch!**auto generated**!COM Interfaces-IWebBrowser!public! !
!SHDocVw.IWebBrowser categoriesFor: #height!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #height:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #left!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #left:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #locationName!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #locationURL!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #navigate:!operations!public! !
!SHDocVw.IWebBrowser categoriesFor: #navigate:flags:targetFrameName:postData:headers:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser categoriesFor: #Navigate:Flags:TargetFrameName:PostData:Headers:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #parent!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #put_Height:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #put_Left:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #put_Top:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #put_Width:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #Refresh!**auto generated**!COM Interfaces-IWebBrowser!public! !
!SHDocVw.IWebBrowser categoriesFor: #refresh2!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser categoriesFor: #refresh2:!**auto generated**!methods!public! !
!SHDocVw.IWebBrowser categoriesFor: #Refresh2:!**auto generated**!COM Interfaces-IWebBrowser!private! !
!SHDocVw.IWebBrowser categoriesFor: #Stop!**auto generated**!COM Interfaces-IWebBrowser!public! !
!SHDocVw.IWebBrowser categoriesFor: #top!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #top:!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #topLevelContainer!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #type!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #value!accessing!public! !
!SHDocVw.IWebBrowser categoriesFor: #value:!accessing!public! !
!SHDocVw.IWebBrowser categoriesFor: #width!**auto generated**!properties!public! !
!SHDocVw.IWebBrowser categoriesFor: #width:!**auto generated**!properties!public! !

!SHDocVw.IWebBrowser class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (WebBrowser_V1) for which the receiver is the default interface."

	^CLSID fromString: '{eab22ac3-30c1-11cf-a7eb-0000c05bae0b}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SHDocVw.IWebBrowser'
		IWebBrowser defineTemplate"

	self
		defineFunction: #GoBack;
		defineFunction: #GoForward;
		defineFunction: #GoHome;
		defineFunction: #GoSearch;
		defineFunction: #Navigate:Flags:TargetFrameName:PostData:Headers:
			argumentTypes: 'bstr variant* variant* variant* variant*';
		defineFunction: #Refresh;
		defineFunction: #Refresh2:
			argumentTypes: 'variant*';
		defineFunction: #Stop;
		defineFunction: #get_Application:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_Parent:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_Container:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_Document:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_TopLevelContainer:
			argumentTypes: 'varbool*';
		defineFunction: #get_Type:
			argumentTypes: 'bstr*';
		defineFunction: #get_Left:
			argumentTypes: 'sdword*';
		defineFunction: #put_Left:
			argumentTypes: 'sdword';
		defineFunction: #get_Top:
			argumentTypes: 'sdword*';
		defineFunction: #put_Top:
			argumentTypes: 'sdword';
		defineFunction: #get_Width:
			argumentTypes: 'sdword*';
		defineFunction: #put_Width:
			argumentTypes: 'sdword';
		defineFunction: #get_Height:
			argumentTypes: 'sdword*';
		defineFunction: #put_Height:
			argumentTypes: 'sdword';
		defineFunction: #get_LocationName:
			argumentTypes: 'bstr*';
		defineFunction: #get_LocationURL:
			argumentTypes: 'bstr*';
		defineFunction: #get_Busy:
			argumentTypes: 'varbool*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IWebBrowser initializeTypeLib"

	typeLib := SHDocVwLib! !
!SHDocVw.IWebBrowser class categoriesFor: #clsid!**auto generated**!constants!private! !
!SHDocVw.IWebBrowser class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!SHDocVw.IWebBrowser class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

