"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Controller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Controller guid: (IID fromString: '{4d00c0d1-9434-4eb6-8078-8697a560334f}')!
ICoreWebView2Controller comment: '`ICoreWebView2Controller` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Controller'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

At the time of writing there are two later versions of this interface. In order to reduce the burden of degrading gracefully to older versions, default implementations of the additional methods and properties are added.

IDL definition follows:
```
[
	object, 
	uuid(4d00c0d1-9434-4eb6-8078-8697a560334f)
]
interface ICoreWebView2Controller : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsVisible(
		[out, retval]long* IsVisible);
	[id(0x60010000), propput]
	HRESULT __stdcall IsVisible(
		[in]long IsVisible);
	[id(0x60010002), propget]
	HRESULT __stdcall Bounds(
		[out, retval]RECT* Bounds);
	[id(0x60010002), propput]
	HRESULT __stdcall Bounds(
		[in]RECT Bounds);
	[id(0x60010004), propget]
	HRESULT __stdcall ZoomFactor(
		[out, retval]double* ZoomFactor);
	[id(0x60010004), propput]
	HRESULT __stdcall ZoomFactor(
		[in]double ZoomFactor);
	[id(0x60010006)]
	HRESULT __stdcall add_ZoomFactorChanged(
		[in]ICoreWebView2ZoomFactorChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010007)]
	HRESULT __stdcall remove_ZoomFactorChanged(
		[in]EventRegistrationToken token);
	[id(0x60010008)]
	HRESULT __stdcall SetBoundsAndZoomFactor(
		[in]RECT Bounds,
		[in]double ZoomFactor);
	[id(0x60010009)]
	HRESULT __stdcall MoveFocus(
		[in]COREWEBVIEW2_MOVE_FOCUS_REASON reason);
	[id(0x6001000a)]
	HRESULT __stdcall add_MoveFocusRequested(
		[in]ICoreWebView2MoveFocusRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000b)]
	HRESULT __stdcall remove_MoveFocusRequested(
		[in]EventRegistrationToken token);
	[id(0x6001000c)]
	HRESULT __stdcall add_GotFocus(
		[in]ICoreWebView2FocusChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000d)]
	HRESULT __stdcall remove_GotFocus(
		[in]EventRegistrationToken token);
	[id(0x6001000e)]
	HRESULT __stdcall add_LostFocus(
		[in]ICoreWebView2FocusChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000f)]
	HRESULT __stdcall remove_LostFocus(
		[in]EventRegistrationToken token);
	[id(0x60010010)]
	HRESULT __stdcall add_AcceleratorKeyPressed(
		[in]ICoreWebView2AcceleratorKeyPressedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010011)]
	HRESULT __stdcall remove_AcceleratorKeyPressed(
		[in]EventRegistrationToken token);
	[id(0x60010012), propget]
	HRESULT __stdcall ParentWindow(
		[out, retval]wireHWND* ParentWindow);
	[id(0x60010012), propput]
	HRESULT __stdcall ParentWindow(
		[in]wireHWND ParentWindow);
	[id(0x60010014)]
	HRESULT __stdcall NotifyParentWindowPositionChanged();
	[id(0x60010015)]
	HRESULT __stdcall Close();
	[id(0x60010016), propget]
	HRESULT __stdcall CoreWebView2(
		[out, retval]ICoreWebView2** CoreWebView2);
};
```
'!
!ICoreWebView2Controller categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Controller methodsFor!

Add_AcceleratorKeyPressed: eventHandler token: token
	"Private - Invoke the add_AcceleratorKeyPressed() method of the COM object.

		HRESULT __stdcall add_AcceleratorKeyPressed(
			[in]ICoreWebView2AcceleratorKeyPressedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 20 ICoreWebView2AcceleratorKeyPressedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_GotFocus: eventHandler token: token
	"Private - Invoke the add_GotFocus() method of the COM object.

		HRESULT __stdcall add_GotFocus(
			[in]ICoreWebView2FocusChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 16 ICoreWebView2FocusChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_LostFocus: eventHandler token: token
	"Private - Invoke the add_LostFocus() method of the COM object.

		HRESULT __stdcall add_LostFocus(
			[in]ICoreWebView2FocusChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 18 ICoreWebView2FocusChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_MoveFocusRequested: eventHandler token: token
	"Private - Invoke the add_MoveFocusRequested() method of the COM object.

		HRESULT __stdcall add_MoveFocusRequested(
			[in]ICoreWebView2MoveFocusRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 14 ICoreWebView2MoveFocusRequestedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_RasterizationScaleChanged: eventHandler token: token
	"Not supported by this version"

	^E_NOTIMPL!

Add_ZoomFactorChanged: eventHandler token: token
	"Private - Invoke the add_ZoomFactorChanged() method of the COM object.

		HRESULT __stdcall add_ZoomFactorChanged(
			[in]ICoreWebView2ZoomFactorChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 10 ICoreWebView2ZoomFactorChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

allowExternalDrop
	"Answer the <Boolean> value of the 'AllowExternalDrop' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AllowExternalDrop: answer.
	^answer value!

allowExternalDrop: value
	"Set the 'AllowExternalDrop' property of the receiver to the <sdword> value of the argument."

	self put_AllowExternalDrop: value!

bounds
	"Answer the <RECT> value of the 'Bounds' property of the receiver."

	| answer |
	answer := RECT new.
	self get_Bounds: answer.
	^answer asObject!

bounds: bounds
	"Set the 'Bounds' property of the receiver to the <RECT> value of the argument."

	self put_Bounds: bounds!

boundsMode
	"Answer the <sdword> value of the 'BoundsMode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_BoundsMode: answer.
	^answer asObject!

boundsMode: boundsMode
	"Set the 'BoundsMode' property of the receiver to the <sdword> value of the argument."

	self put_BoundsMode: boundsMode!

close
	"Invoke the Close() method of the COM object."

	^self Close!

Close
	"Private - Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 25>
	^self invalidCall: _failureCode!

coreWebView2
	"Answer the <ICoreWebView2> value of the 'CoreWebView2' property of the receiver."

	| answer |
	answer := ICoreWebView2 newPointer.
	self get_CoreWebView2: answer.
	^answer asObject!

defaultBackgroundColor
	"Answer the <Color> value of the 'DefaultBackgroundColor' property of the receiver."

	| answer |
	answer := QWORD newBuffer.
	self get_DefaultBackgroundColor: answer.
	^Color fromArgbCode: answer value!

defaultBackgroundColor: backgroundColor
	"Set the 'DefaultBackgroundColor' property of the receiver to the <COREWEBVIEW2_COLOR> value of the argument."

	self put_DefaultBackgroundColor: backgroundColor argbCode!

get_AllowExternalDrop: value
	"Private - Get the value of the 'AllowExternalDrop' property of the receiver.

		HRESULT __stdcall AllowExternalDrop(
			[out, retval]long* value);"

	^E_NOTIMPL!

get_Bounds: bounds
	"Private - Get the value of the 'Bounds' property of the receiver.

		HRESULT __stdcall Bounds(
			[out, retval]RECT* Bounds);"

	<virtual stdcall: hresult 6 RECT*>
	^self invalidCall: _failureCode!

get_BoundsMode: boundsMode
	"Private - Get the value of the 'BoundsMode' property of the receiver.

		HRESULT __stdcall BoundsMode(
			[out, retval]COREWEBVIEW2_BOUNDS_MODE* BoundsMode);"

	"Not supported by this version"

	^E_NOTIMPL!

get_CoreWebView2: coreWebView2
	"Private - Get the value of the 'CoreWebView2' property of the receiver.

		HRESULT __stdcall CoreWebView2(
			[out, retval]ICoreWebView2** CoreWebView2);"

	<virtual stdcall: hresult 26 ICoreWebView2**>
	^self invalidCall: _failureCode!

get_DefaultBackgroundColor: backgroundColor
	"Private - Get the value of the 'DefaultBackgroundColor' property of the receiver.

		HRESULT __stdcall DefaultBackgroundColor(
			[out, retval]COREWEBVIEW2_COLOR* backgroundColor);"

	backgroundColor value: Color white argbCode.
	^S_OK!

get_IsVisible: isVisible
	"Private - Get the value of the 'IsVisible' property of the receiver.

		HRESULT __stdcall IsVisible(
			[out, retval]long* IsVisible);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

get_ParentWindow: parentWindow
	"Private - Get the value of the 'ParentWindow' property of the receiver.

		HRESULT __stdcall ParentWindow(
			[out, retval]wireHWND* ParentWindow);"

	<virtual stdcall: hresult 22 handle*>
	^self invalidCall: _failureCode!

get_RasterizationScale: scale
	"Private - Get the value of the 'RasterizationScale' property of the receiver.

		HRESULT __stdcall RasterizationScale(
			[out, retval]double* scale);"

	scale value: 1.0.
	^S_OK!

get_ShouldDetectMonitorScaleChanges: pBool
	"Private - Get the value of the 'ShouldDetectMonitorScaleChanges' property of the receiver.

		HRESULT __stdcall ShouldDetectMonitorScaleChanges(
			[out, retval]long* value);"

	"Not supported by this version"

	pBool value: 1.
	^S_OK!

get_ZoomFactor: zoomFactor
	"Private - Get the value of the 'ZoomFactor' property of the receiver.

		HRESULT __stdcall ZoomFactor(
			[out, retval]double* ZoomFactor);"

	<virtual stdcall: hresult 8 double*>
	^self invalidCall: _failureCode!

isVisible
	"Answer the <Boolean> value of the 'IsVisible' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsVisible: answer.
	^answer asObject!

isVisible: isVisible
	"Set the 'IsVisible' property of the receiver to the <sdword> value of the argument."

	self put_IsVisible: isVisible asParameter!

moveFocus: reason
	"Invoke the MoveFocus() method of the COM object."

	^self MoveFocus: reason!

MoveFocus: reason
	"Private - Invoke the MoveFocus() method of the COM object.

		HRESULT __stdcall MoveFocus(
			[in]COREWEBVIEW2_MOVE_FOCUS_REASON reason);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall: _failureCode!

notifyParentWindowPositionChanged
	"Invoke the NotifyParentWindowPositionChanged() method of the COM object."

	^self NotifyParentWindowPositionChanged!

NotifyParentWindowPositionChanged
	"Private - Invoke the NotifyParentWindowPositionChanged() method of the COM object.

		HRESULT __stdcall NotifyParentWindowPositionChanged();"

	<virtual stdcall: hresult 24>
	^self invalidCall: _failureCode!

parentWindow
	"Answer the <handle> value of the 'ParentWindow' property of the receiver."

	| answer |
	answer := ExternalHandle new.
	self get_ParentWindow: answer.
	^answer asObject!

parentWindow: parentWindow
	"Set the 'ParentWindow' property of the receiver to the <handle> value of the argument."

	self put_ParentWindow: parentWindow!

printableProperties
	^#(#isVisible #rectangle #zoomFactor #defaultBackgroundColor #boundsMode #rasterizationScale #shouldDetectMonitorScaleChanges)!

put_AllowExternalDrop: value
	"Private - Set the value of the 'AllowExternalDrop' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall AllowExternalDrop(
			[in]long value);"

	^E_NOTIMPL!

put_Bounds: bounds
	"Private - Set the value of the 'Bounds' property of the object wrapped by the 
	 receiver to the <RECT> argument, bounds.

		HRESULT __stdcall Bounds(
			[in]RECT Bounds);"

	<virtual stdcall: hresult 7 RECT>
	^self invalidCall: _failureCode!

put_BoundsMode: boundsMode
	"Private - Set the value of the 'BoundsMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, boundsMode.

		HRESULT __stdcall BoundsMode(
			[in]COREWEBVIEW2_BOUNDS_MODE BoundsMode);"

	"Not supported by this version"

	^E_NOTIMPL!

put_DefaultBackgroundColor: backgroundColor
	"Private - Set the value of the 'DefaultBackgroundColor' property of the object wrapped by the 
	 receiver to the <COREWEBVIEW2_COLOR> argument, backgroundColor.

		HRESULT __stdcall DefaultBackgroundColor(
			[in]COREWEBVIEW2_COLOR backgroundColor);"

	^E_NOTIMPL!

put_IsVisible: isVisible
	"Private - Set the value of the 'IsVisible' property of the object wrapped by the 
	 receiver to the <sdword> argument, isVisible.

		HRESULT __stdcall IsVisible(
			[in]long IsVisible);"

	<virtual stdcall: hresult 5 sdword>
	^self invalidCall: _failureCode!

put_ParentWindow: parentWindow
	"Private - Set the value of the 'ParentWindow' property of the object wrapped by the 
	 receiver to the <handle> argument, parentWindow.

		HRESULT __stdcall ParentWindow(
			[in]wireHWND ParentWindow);"

	<virtual stdcall: hresult 23 handle>
	^self invalidCall: _failureCode!

put_RasterizationScale: scale
	"Private - Set the value of the 'RasterizationScale' property of the object wrapped by the 
	 receiver to the <double> argument, scale.

		HRESULT __stdcall RasterizationScale(
			[in]double scale);"

	"Not supported by this version"

	^E_NOTIMPL!

put_ShouldDetectMonitorScaleChanges: value
	"Private - Set the value of the 'ShouldDetectMonitorScaleChanges' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ShouldDetectMonitorScaleChanges(
			[in]long value);"

	"Not supported by this version"

	^E_NOTIMPL!

put_ZoomFactor: zoomFactor
	"Private - Set the value of the 'ZoomFactor' property of the object wrapped by the 
	 receiver to the <double> argument, zoomFactor.

		HRESULT __stdcall ZoomFactor(
			[in]double ZoomFactor);"

	<virtual stdcall: hresult 9 double>
	^self invalidCall: _failureCode!

rasterizationScale
	"Answer the <double> value of the 'RasterizationScale' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_RasterizationScale: answer.
	^answer asObject!

rasterizationScale: scale
	"Set the 'RasterizationScale' property of the receiver to the <double> value of the argument."

	self put_RasterizationScale: scale!

rectangle
	^self bounds!

rectangle: aRectangle
	self bounds: aRectangle asParameter!

Remove_AcceleratorKeyPressed: token
	"Private - Invoke the remove_AcceleratorKeyPressed() method of the COM object.

		HRESULT __stdcall remove_AcceleratorKeyPressed(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 21 sqword>
	^self invalidCall: _failureCode!

Remove_GotFocus: token
	"Private - Invoke the remove_GotFocus() method of the COM object.

		HRESULT __stdcall remove_GotFocus(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 17 sqword>
	^self invalidCall: _failureCode!

Remove_LostFocus: token
	"Private - Invoke the remove_LostFocus() method of the COM object.

		HRESULT __stdcall remove_LostFocus(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 19 sqword>
	^self invalidCall: _failureCode!

Remove_MoveFocusRequested: token
	"Private - Invoke the remove_MoveFocusRequested() method of the COM object.

		HRESULT __stdcall remove_MoveFocusRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 15 sqword>
	^self invalidCall: _failureCode!

Remove_RasterizationScaleChanged: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_ZoomFactorChanged: token
	"Private - Invoke the remove_ZoomFactorChanged() method of the COM object.

		HRESULT __stdcall remove_ZoomFactorChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 11 sqword>
	^self invalidCall: _failureCode!

setBoundsAndZoomFactor: bounds zoomFactor: zoomFactor
	"Invoke the SetBoundsAndZoomFactor() method of the COM object."

	^self SetBoundsAndZoomFactor: bounds asParameter zoomFactor: zoomFactor!

SetBoundsAndZoomFactor: bounds zoomFactor: zoomFactor
	"Private - Invoke the SetBoundsAndZoomFactor() method of the COM object.

		HRESULT __stdcall SetBoundsAndZoomFactor(
			[in]RECT Bounds,
			[in]double ZoomFactor);"

	<virtual stdcall: hresult 12 RECT double>
	^self invalidCall: _failureCode!

shouldDetectMonitorScaleChanges
	"Answer the <Boolean> value of the 'ShouldDetectMonitorScaleChanges' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_ShouldDetectMonitorScaleChanges: answer.
	^answer asObject!

shouldDetectMonitorScaleChanges: value
	"Set the 'ShouldDetectMonitorScaleChanges' property of the receiver to the <sdword> value of the argument."

	self put_ShouldDetectMonitorScaleChanges: value asParameter!

zoomFactor
	"Answer the <double> value of the 'ZoomFactor' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_ZoomFactor: answer.
	^answer asObject!

zoomFactor: zoomFactor
	"Set the 'ZoomFactor' property of the receiver to the <double> value of the argument."

	self put_ZoomFactor: zoomFactor! !
!ICoreWebView2Controller categoriesForMethods!
Add_AcceleratorKeyPressed:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Add_GotFocus:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Add_LostFocus:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Add_MoveFocusRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Add_RasterizationScaleChanged:token:!COM Interfaces-ICoreWebView2Controller3!events!private! !
Add_ZoomFactorChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
allowExternalDrop!properties!public! !
allowExternalDrop:!**auto generated**!properties!public! !
bounds!**auto generated**!properties!public! !
bounds:!**auto generated**!properties!public! !
boundsMode!properties!public! !
boundsMode:!properties!public! !
close!**auto generated**!methods!public! !
Close!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
coreWebView2!**auto generated**!properties!public! !
defaultBackgroundColor!properties!public! !
defaultBackgroundColor:!properties!public! !
get_AllowExternalDrop:!**auto generated**!COM Interfaces-ICoreWebView2Controller4!private! !
get_Bounds:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
get_BoundsMode:!COM Interfaces-ICoreWebView2Controller3!private!properties! !
get_CoreWebView2:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
get_DefaultBackgroundColor:!COM Interfaces-ICoreWebView2Controller2!private!properties! !
get_IsVisible:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
get_ParentWindow:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
get_RasterizationScale:!COM Interfaces-ICoreWebView2Controller3!private!properties! !
get_ShouldDetectMonitorScaleChanges:!COM Interfaces-ICoreWebView2Controller3!private!properties! !
get_ZoomFactor:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
isVisible!properties!public! !
isVisible:!properties!public! !
moveFocus:!**auto generated**!methods!public! !
MoveFocus:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
notifyParentWindowPositionChanged!**auto generated**!methods!public! !
NotifyParentWindowPositionChanged!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
parentWindow!**auto generated**!properties!public! !
parentWindow:!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_AllowExternalDrop:!**auto generated**!COM Interfaces-ICoreWebView2Controller4!private! !
put_Bounds:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
put_BoundsMode:!COM Interfaces-ICoreWebView2Controller3!private!properties! !
put_DefaultBackgroundColor:!COM Interfaces-ICoreWebView2Controller2!private!properties! !
put_IsVisible:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
put_ParentWindow:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
put_RasterizationScale:!COM Interfaces-ICoreWebView2Controller3!private!properties! !
put_ShouldDetectMonitorScaleChanges:!COM Interfaces-ICoreWebView2Controller3!private!properties! !
put_ZoomFactor:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
rasterizationScale!properties!public! !
rasterizationScale:!properties!public! !
rectangle!geometry!public! !
rectangle:!geometry!public! !
Remove_AcceleratorKeyPressed:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Remove_GotFocus:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Remove_LostFocus:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Remove_MoveFocusRequested:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
Remove_RasterizationScaleChanged:!COM Interfaces-ICoreWebView2Controller3!events!private! !
Remove_ZoomFactorChanged:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
setBoundsAndZoomFactor:zoomFactor:!methods!public! !
SetBoundsAndZoomFactor:zoomFactor:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
shouldDetectMonitorScaleChanges!properties!public! !
shouldDetectMonitorScaleChanges:!properties!public! !
zoomFactor!**auto generated**!properties!public! !
zoomFactor:!**auto generated**!properties!public! !
!

!ICoreWebView2Controller class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Controller'
		ICoreWebView2Controller defineTemplate"

	self
		defineFunction: #get_IsVisible:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsVisible:
			argumentTypes: 'sdword';
		defineFunction: #get_Bounds:
			argumentTypes: 'RECT*';
		defineFunction: #put_Bounds:
			argumentTypes: 'RECT';
		defineFunction: #get_ZoomFactor:
			argumentTypes: 'double*';
		defineFunction: #put_ZoomFactor:
			argumentTypes: 'double';
		defineFunction: #Add_ZoomFactorChanged:token:
			argumentTypes: 'ICoreWebView2ZoomFactorChangedEventHandler* sqword*';
		defineFunction: #Remove_ZoomFactorChanged:
			argumentTypes: 'sqword';
		defineFunction: #SetBoundsAndZoomFactor:zoomFactor:
			argumentTypes: 'RECT double';
		defineFunction: #MoveFocus:
			argumentTypes: 'sdword';
		defineFunction: #Add_MoveFocusRequested:token:
			argumentTypes: 'ICoreWebView2MoveFocusRequestedEventHandler* sqword*';
		defineFunction: #Remove_MoveFocusRequested:
			argumentTypes: 'sqword';
		defineFunction: #Add_GotFocus:token:
			argumentTypes: 'ICoreWebView2FocusChangedEventHandler* sqword*';
		defineFunction: #Remove_GotFocus:
			argumentTypes: 'sqword';
		defineFunction: #Add_LostFocus:token:
			argumentTypes: 'ICoreWebView2FocusChangedEventHandler* sqword*';
		defineFunction: #Remove_LostFocus:
			argumentTypes: 'sqword';
		defineFunction: #Add_AcceleratorKeyPressed:token:
			argumentTypes: 'ICoreWebView2AcceleratorKeyPressedEventHandler* sqword*';
		defineFunction: #Remove_AcceleratorKeyPressed:
			argumentTypes: 'sqword';
		defineFunction: #get_ParentWindow:
			argumentTypes: 'handle*';
		defineFunction: #put_ParentWindow:
			argumentTypes: 'handle';
		defineFunction: #NotifyParentWindowPositionChanged;
		defineFunction: #Close;
		defineFunction: #get_CoreWebView2:
			argumentTypes: 'ICoreWebView2**'
! !
!ICoreWebView2Controller class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

