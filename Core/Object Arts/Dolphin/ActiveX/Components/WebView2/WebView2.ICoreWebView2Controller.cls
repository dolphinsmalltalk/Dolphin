"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2Controller'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Controller guid: (OS.COM.IID fromString: '{4d00c0d1-9434-4eb6-8078-8697a560334f}')!
WebView2.ICoreWebView2Controller comment: '`ICoreWebView2Controller` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Controller'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

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
!WebView2.ICoreWebView2Controller categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Controller methodsFor!

add_AcceleratorKeyPressed: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_AcceleratorKeyPressed() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_AcceleratorKeyPressed: eventHandler token: answer.
	^answer asObject!

Add_AcceleratorKeyPressed: eventHandler token: token
	"Private - Invoke the add_AcceleratorKeyPressed() method of the COM object.

		HRESULT __stdcall add_AcceleratorKeyPressed(
			[in]ICoreWebView2AcceleratorKeyPressedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 20 ICoreWebView2AcceleratorKeyPressedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_GotFocus: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_GotFocus() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_GotFocus: eventHandler token: answer.
	^answer asObject!

Add_GotFocus: eventHandler token: token
	"Private - Invoke the add_GotFocus() method of the COM object.

		HRESULT __stdcall add_GotFocus(
			[in]ICoreWebView2FocusChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 16 ICoreWebView2FocusChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_LostFocus: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_LostFocus() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_LostFocus: eventHandler token: answer.
	^answer asObject!

Add_LostFocus: eventHandler token: token
	"Private - Invoke the add_LostFocus() method of the COM object.

		HRESULT __stdcall add_LostFocus(
			[in]ICoreWebView2FocusChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 18 ICoreWebView2FocusChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_MoveFocusRequested: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_MoveFocusRequested() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_MoveFocusRequested: eventHandler token: answer.
	^answer asObject!

Add_MoveFocusRequested: eventHandler token: token
	"Private - Invoke the add_MoveFocusRequested() method of the COM object.

		HRESULT __stdcall add_MoveFocusRequested(
			[in]ICoreWebView2MoveFocusRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 14 ICoreWebView2MoveFocusRequestedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_ZoomFactorChanged: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_ZoomFactorChanged() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_ZoomFactorChanged: eventHandler token: answer.
	^answer asObject!

Add_ZoomFactorChanged: eventHandler token: token
	"Private - Invoke the add_ZoomFactorChanged() method of the COM object.

		HRESULT __stdcall add_ZoomFactorChanged(
			[in]ICoreWebView2ZoomFactorChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 10 ICoreWebView2ZoomFactorChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

bounds
	"Answer the <RECTL> value of the 'Bounds' property of the receiver."

	| answer |
	answer := RECTL new.
	self get_Bounds: answer.
	^answer asObject!

bounds: bounds
	"Set the 'Bounds' property of the receiver to the <RECTL> value of the argument."

	self put_Bounds: bounds!

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

get_Bounds: bounds
	"Private - Get the value of the 'Bounds' property of the receiver.

		HRESULT __stdcall Bounds(
			[out, retval]RECT* Bounds);"

	<virtual stdcall: hresult 6 RECTL*>
	^self invalidCall: _failureCode!

get_CoreWebView2: coreWebView2
	"Private - Get the value of the 'CoreWebView2' property of the receiver.

		HRESULT __stdcall CoreWebView2(
			[out, retval]ICoreWebView2** CoreWebView2);"

	<virtual stdcall: hresult 26 ICoreWebView2**>
	^self invalidCall: _failureCode!

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

get_ZoomFactor: zoomFactor
	"Private - Get the value of the 'ZoomFactor' property of the receiver.

		HRESULT __stdcall ZoomFactor(
			[out, retval]double* ZoomFactor);"

	<virtual stdcall: hresult 8 double*>
	^self invalidCall: _failureCode!

isVisible
	"Answer the <sdword> value of the 'IsVisible' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsVisible: answer.
	^answer asObject!

isVisible: isVisible
	"Set the 'IsVisible' property of the receiver to the <sdword> value of the argument."

	self put_IsVisible: isVisible!

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
	answer := Handle new.
	self get_ParentWindow: answer.
	^answer asObject!

parentWindow: parentWindow
	"Set the 'ParentWindow' property of the receiver to the <handle> value of the argument."

	self put_ParentWindow: parentWindow!

put_Bounds: bounds
	"Private - Set the value of the 'Bounds' property of the object wrapped by the 
	 receiver to the <RECTL> argument, bounds.

		HRESULT __stdcall Bounds(
			[in]RECT Bounds);"

	<virtual stdcall: hresult 7 RECTL>
	^self invalidCall: _failureCode!

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

put_ZoomFactor: zoomFactor
	"Private - Set the value of the 'ZoomFactor' property of the object wrapped by the 
	 receiver to the <double> argument, zoomFactor.

		HRESULT __stdcall ZoomFactor(
			[in]double ZoomFactor);"

	<virtual stdcall: hresult 9 double>
	^self invalidCall: _failureCode!

remove_AcceleratorKeyPressed: token
	"Invoke the remove_AcceleratorKeyPressed() method of the COM object."

	^self Remove_AcceleratorKeyPressed: token!

Remove_AcceleratorKeyPressed: token
	"Private - Invoke the remove_AcceleratorKeyPressed() method of the COM object.

		HRESULT __stdcall remove_AcceleratorKeyPressed(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 21 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_GotFocus: token
	"Invoke the remove_GotFocus() method of the COM object."

	^self Remove_GotFocus: token!

Remove_GotFocus: token
	"Private - Invoke the remove_GotFocus() method of the COM object.

		HRESULT __stdcall remove_GotFocus(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 17 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_LostFocus: token
	"Invoke the remove_LostFocus() method of the COM object."

	^self Remove_LostFocus: token!

Remove_LostFocus: token
	"Private - Invoke the remove_LostFocus() method of the COM object.

		HRESULT __stdcall remove_LostFocus(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 19 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_MoveFocusRequested: token
	"Invoke the remove_MoveFocusRequested() method of the COM object."

	^self Remove_MoveFocusRequested: token!

Remove_MoveFocusRequested: token
	"Private - Invoke the remove_MoveFocusRequested() method of the COM object.

		HRESULT __stdcall remove_MoveFocusRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 15 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_ZoomFactorChanged: token
	"Invoke the remove_ZoomFactorChanged() method of the COM object."

	^self Remove_ZoomFactorChanged: token!

Remove_ZoomFactorChanged: token
	"Private - Invoke the remove_ZoomFactorChanged() method of the COM object.

		HRESULT __stdcall remove_ZoomFactorChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 11 EventRegistrationToken>
	^self invalidCall: _failureCode!

setBoundsAndZoomFactor: bounds zoomFactor: zoomFactor
	"Invoke the SetBoundsAndZoomFactor() method of the COM object."

	^self SetBoundsAndZoomFactor: bounds zoomFactor: zoomFactor!

SetBoundsAndZoomFactor: bounds zoomFactor: zoomFactor
	"Private - Invoke the SetBoundsAndZoomFactor() method of the COM object.

		HRESULT __stdcall SetBoundsAndZoomFactor(
			[in]RECT Bounds,
			[in]double ZoomFactor);"

	<virtual stdcall: hresult 12 RECTL double>
	^self invalidCall: _failureCode!

zoomFactor
	"Answer the <double> value of the 'ZoomFactor' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_ZoomFactor: answer.
	^answer asObject!

zoomFactor: zoomFactor
	"Set the 'ZoomFactor' property of the receiver to the <double> value of the argument."

	self put_ZoomFactor: zoomFactor! !
!WebView2.ICoreWebView2Controller categoriesFor: #add_AcceleratorKeyPressed:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Add_AcceleratorKeyPressed:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #add_GotFocus:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Add_GotFocus:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #add_LostFocus:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Add_LostFocus:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #add_MoveFocusRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Add_MoveFocusRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #add_ZoomFactorChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Add_ZoomFactorChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #bounds!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #bounds:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #close!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Close!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #coreWebView2!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #get_Bounds:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #get_CoreWebView2:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #get_IsVisible:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #get_ParentWindow:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #get_ZoomFactor:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #isVisible!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #isVisible:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #moveFocus:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #MoveFocus:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #notifyParentWindowPositionChanged!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #NotifyParentWindowPositionChanged!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #parentWindow!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #parentWindow:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #put_Bounds:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #put_IsVisible:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #put_ParentWindow:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #put_ZoomFactor:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #remove_AcceleratorKeyPressed:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Remove_AcceleratorKeyPressed:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #remove_GotFocus:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Remove_GotFocus:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #remove_LostFocus:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Remove_LostFocus:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #remove_MoveFocusRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Remove_MoveFocusRequested:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #remove_ZoomFactorChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #Remove_ZoomFactorChanged:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #setBoundsAndZoomFactor:zoomFactor:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #SetBoundsAndZoomFactor:zoomFactor:!**auto generated**!COM Interfaces-ICoreWebView2Controller!private! !
!WebView2.ICoreWebView2Controller categoriesFor: #zoomFactor!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Controller categoriesFor: #zoomFactor:!**auto generated**!properties!public! !

!WebView2.ICoreWebView2Controller class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Controller'
		ICoreWebView2Controller defineTemplate"

	self
		defineFunction: #get_IsVisible:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsVisible:
			argumentTypes: 'sdword';
		defineFunction: #get_Bounds:
			argumentTypes: 'RECTL*';
		defineFunction: #put_Bounds:
			argumentTypes: 'RECTL';
		defineFunction: #get_ZoomFactor:
			argumentTypes: 'double*';
		defineFunction: #put_ZoomFactor:
			argumentTypes: 'double';
		defineFunction: #Add_ZoomFactorChanged:token:
			argumentTypes: 'ICoreWebView2ZoomFactorChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_ZoomFactorChanged:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #SetBoundsAndZoomFactor:zoomFactor:
			argumentTypes: 'RECTL double';
		defineFunction: #MoveFocus:
			argumentTypes: 'sdword';
		defineFunction: #Add_MoveFocusRequested:token:
			argumentTypes: 'ICoreWebView2MoveFocusRequestedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_MoveFocusRequested:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_GotFocus:token:
			argumentTypes: 'ICoreWebView2FocusChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_GotFocus:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_LostFocus:token:
			argumentTypes: 'ICoreWebView2FocusChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_LostFocus:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_AcceleratorKeyPressed:token:
			argumentTypes: 'ICoreWebView2AcceleratorKeyPressedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_AcceleratorKeyPressed:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #get_ParentWindow:
			argumentTypes: 'handle*';
		defineFunction: #put_ParentWindow:
			argumentTypes: 'handle';
		defineFunction: #NotifyParentWindowPositionChanged;
		defineFunction: #Close;
		defineFunction: #get_CoreWebView2:
			argumentTypes: 'ICoreWebView2**'
! !
!WebView2.ICoreWebView2Controller class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

