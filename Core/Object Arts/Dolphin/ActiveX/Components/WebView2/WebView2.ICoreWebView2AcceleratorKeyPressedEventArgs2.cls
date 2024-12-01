"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs
	subclass: #'WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 guid: (OS.COM.IID fromString: '{03b2c8c8-7799-4e34-bd66-ed26aa85f2bf}')!

WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 isEgressOnly: true!

WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 comment: '`ICoreWebView2AcceleratorKeyPressedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(03b2c8c8-7799-4e34-bd66-ed26aa85f2bf)
]
interface ICoreWebView2AcceleratorKeyPressedEventArgs2 : ICoreWebView2AcceleratorKeyPressedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall IsBrowserAcceleratorKeyEnabled(
		[out, retval]long* value);
	[id(0x60020000), propput]
	HRESULT __stdcall IsBrowserAcceleratorKeyEnabled(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 methodsFor!

get_IsBrowserAcceleratorKeyEnabled: value
	"Private - Get the value of the 'IsBrowserAcceleratorKeyEnabled' property of the receiver.

		HRESULT __stdcall IsBrowserAcceleratorKeyEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 10 int32*>
	^self invalidCall: _failureCode!

printPropertiesOn: aStream
	super printPropertiesOn: aStream.
	
	aStream
		nextPutAll: ', isEnabled: ';
		print: self isBrowserAcceleratorKeyEnabled!

put_IsBrowserAcceleratorKeyEnabled: value
	"Private - Set the value of the 'IsBrowserAcceleratorKeyEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall IsBrowserAcceleratorKeyEnabled(
			[in]long value);"

	<virtual stdcall: hresult 11 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 categoriesForMethods!
get_IsBrowserAcceleratorKeyEnabled:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs2!private! !
printPropertiesOn:!printing!private! !
put_IsBrowserAcceleratorKeyEnabled:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs2!private! !
!

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2'
		ICoreWebView2AcceleratorKeyPressedEventArgs2 defineTemplate"

	self
		defineFunction: #get_IsBrowserAcceleratorKeyEnabled:
			argumentTypes: 'int32*';
		defineFunction: #put_IsBrowserAcceleratorKeyEnabled:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

