"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2NonClientRegionChangedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NonClientRegionChangedEventArgs guid: (OS.COM.IID fromString: '{ab71d500-0820-4a52-809c-48db04ff93bf}')!

WebView2.ICoreWebView2NonClientRegionChangedEventArgs comment: '`ICoreWebView2NonClientRegionChangedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NonClientRegionChangedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ab71d500-0820-4a52-809c-48db04ff93bf)
]
interface ICoreWebView2NonClientRegionChangedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall RegionKind(
		[out, retval]COREWEBVIEW2_NON_CLIENT_REGION_KIND* value);
};
```
'!

!WebView2.ICoreWebView2NonClientRegionChangedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NonClientRegionChangedEventArgs methodsFor!

get_RegionKind: value
	"Private - Get the value of the 'RegionKind' property of the receiver.

		HRESULT __stdcall RegionKind(
			[out, retval]COREWEBVIEW2_NON_CLIENT_REGION_KIND* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

printableProperties
	^#(#regionKindName)!

regionKind
	"Answer the <int32> value of the 'RegionKind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_RegionKind: answer.
	^answer asObject!

regionKindName
	"Answer the symbolic name of the 'RegionKind' property of the receiver."

	^(IdentityDictionary withAll: {
				COREWEBVIEW2_NON_CLIENT_REGION_KIND_NOWHERE -> #nowhere.
				COREWEBVIEW2_NON_CLIENT_REGION_KIND_CLIENT -> #client.
				COREWEBVIEW2_NON_CLIENT_REGION_KIND_CAPTION -> #caption.
				COREWEBVIEW2_NON_CLIENT_REGION_KIND_MINIMIZE -> #minimize.
				COREWEBVIEW2_NON_CLIENT_REGION_KIND_MAXIMIZE -> #maximize.
				COREWEBVIEW2_NON_CLIENT_REGION_KIND_CLOSE -> #close
			})
		lookup: self regionKind! !

!WebView2.ICoreWebView2NonClientRegionChangedEventArgs categoriesForMethods!
get_RegionKind:!**auto generated**!COM Interfaces-ICoreWebView2NonClientRegionChangedEventArgs!private! !
printableProperties!printing!private! !
regionKind!**auto generated**!properties!public! !
regionKindName!properties!public! !
!

!WebView2.ICoreWebView2NonClientRegionChangedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NonClientRegionChangedEventArgs'
		ICoreWebView2NonClientRegionChangedEventArgs defineTemplate"

	self
		defineFunction: #get_RegionKind:
			argumentTypes: 'int32*'
! !

!WebView2.ICoreWebView2NonClientRegionChangedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

