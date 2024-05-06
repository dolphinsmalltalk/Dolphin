"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2PointerInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2PointerInfo guid: (IID fromString: '{e6995887-d10d-4f5d-9359-4ce46e4f96b9}')!

ICoreWebView2PointerInfo comment: '`ICoreWebView2PointerInfo` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PointerInfo'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e6995887-d10d-4f5d-9359-4ce46e4f96b9)
]
interface ICoreWebView2PointerInfo : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall PointerKind(
		[out, retval]unsigned long* PointerKind);
	[id(0x60010000), propput]
	HRESULT __stdcall PointerKind(
		[in]unsigned long PointerKind);
	[id(0x60010002), propget]
	HRESULT __stdcall PointerId(
		[out, retval]unsigned int* PointerId);
	[id(0x60010002), propput]
	HRESULT __stdcall PointerId(
		[in]unsigned int PointerId);
	[id(0x60010004), propget]
	HRESULT __stdcall FrameId(
		[out, retval]unsigned int* FrameId);
	[id(0x60010004), propput]
	HRESULT __stdcall FrameId(
		[in]unsigned int FrameId);
	[id(0x60010006), propget]
	HRESULT __stdcall PointerFlags(
		[out, retval]unsigned int* PointerFlags);
	[id(0x60010006), propput]
	HRESULT __stdcall PointerFlags(
		[in]unsigned int PointerFlags);
	[id(0x60010008), propget]
	HRESULT __stdcall PointerDeviceRect(
		[out, retval]RECT* PointerDeviceRect);
	[id(0x60010008), propput]
	HRESULT __stdcall PointerDeviceRect(
		[in]RECT PointerDeviceRect);
	[id(0x6001000a), propget]
	HRESULT __stdcall DisplayRect(
		[out, retval]RECT* DisplayRect);
	[id(0x6001000a), propput]
	HRESULT __stdcall DisplayRect(
		[in]RECT DisplayRect);
	[id(0x6001000c), propget]
	HRESULT __stdcall PixelLocation(
		[out, retval]POINT* PixelLocation);
	[id(0x6001000c), propput]
	HRESULT __stdcall PixelLocation(
		[in]POINT PixelLocation);
	[id(0x6001000e), propget]
	HRESULT __stdcall HimetricLocation(
		[out, retval]POINT* HimetricLocation);
	[id(0x6001000e), propput]
	HRESULT __stdcall HimetricLocation(
		[in]POINT HimetricLocation);
	[id(0x60010010), propget]
	HRESULT __stdcall PixelLocationRaw(
		[out, retval]POINT* PixelLocationRaw);
	[id(0x60010010), propput]
	HRESULT __stdcall PixelLocationRaw(
		[in]POINT PixelLocationRaw);
	[id(0x60010012), propget]
	HRESULT __stdcall HimetricLocationRaw(
		[out, retval]POINT* HimetricLocationRaw);
	[id(0x60010012), propput]
	HRESULT __stdcall HimetricLocationRaw(
		[in]POINT HimetricLocationRaw);
	[id(0x60010014), propget]
	HRESULT __stdcall Time(
		[out, retval]unsigned long* Time);
	[id(0x60010014), propput]
	HRESULT __stdcall Time(
		[in]unsigned long Time);
	[id(0x60010016), propget]
	HRESULT __stdcall HistoryCount(
		[out, retval]unsigned int* HistoryCount);
	[id(0x60010016), propput]
	HRESULT __stdcall HistoryCount(
		[in]unsigned int HistoryCount);
	[id(0x60010018), propget]
	HRESULT __stdcall InputData(
		[out, retval]int* InputData);
	[id(0x60010018), propput]
	HRESULT __stdcall InputData(
		[in]int InputData);
	[id(0x6001001a), propget]
	HRESULT __stdcall KeyStates(
		[out, retval]unsigned long* KeyStates);
	[id(0x6001001a), propput]
	HRESULT __stdcall KeyStates(
		[in]unsigned long KeyStates);
	[id(0x6001001c), propget]
	HRESULT __stdcall PerformanceCount(
		[out, retval]unsigned __int64* PerformanceCount);
	[id(0x6001001c), propput]
	HRESULT __stdcall PerformanceCount(
		[in]unsigned __int64 PerformanceCount);
	[id(0x6001001e), propget]
	HRESULT __stdcall ButtonChangeKind(
		[out, retval]int* ButtonChangeKind);
	[id(0x6001001e), propput]
	HRESULT __stdcall ButtonChangeKind(
		[in]int ButtonChangeKind);
	[id(0x60010020), propget]
	HRESULT __stdcall PenFlags(
		[out, retval]unsigned int* PenFlags);
	[id(0x60010020), propput]
	HRESULT __stdcall PenFlags(
		[in]unsigned int PenFlags);
	[id(0x60010022), propget]
	HRESULT __stdcall PenMask(
		[out, retval]unsigned int* PenMask);
	[id(0x60010022), propput]
	HRESULT __stdcall PenMask(
		[in]unsigned int PenMask);
	[id(0x60010024), propget]
	HRESULT __stdcall PenPressure(
		[out, retval]unsigned int* PenPressure);
	[id(0x60010024), propput]
	HRESULT __stdcall PenPressure(
		[in]unsigned int PenPressure);
	[id(0x60010026), propget]
	HRESULT __stdcall PenRotation(
		[out, retval]unsigned int* PenRotation);
	[id(0x60010026), propput]
	HRESULT __stdcall PenRotation(
		[in]unsigned int PenRotation);
	[id(0x60010028), propget]
	HRESULT __stdcall PenTiltX(
		[out, retval]int* PenTiltX);
	[id(0x60010028), propput]
	HRESULT __stdcall PenTiltX(
		[in]int PenTiltX);
	[id(0x6001002a), propget]
	HRESULT __stdcall PenTiltY(
		[out, retval]int* PenTiltY);
	[id(0x6001002a), propput]
	HRESULT __stdcall PenTiltY(
		[in]int PenTiltY);
	[id(0x6001002c), propget]
	HRESULT __stdcall TouchFlags(
		[out, retval]unsigned int* TouchFlags);
	[id(0x6001002c), propput]
	HRESULT __stdcall TouchFlags(
		[in]unsigned int TouchFlags);
	[id(0x6001002e), propget]
	HRESULT __stdcall TouchMask(
		[out, retval]unsigned int* TouchMask);
	[id(0x6001002e), propput]
	HRESULT __stdcall TouchMask(
		[in]unsigned int TouchMask);
	[id(0x60010030), propget]
	HRESULT __stdcall TouchContact(
		[out, retval]RECT* TouchContact);
	[id(0x60010030), propput]
	HRESULT __stdcall TouchContact(
		[in]RECT TouchContact);
	[id(0x60010032), propget]
	HRESULT __stdcall TouchContactRaw(
		[out, retval]RECT* TouchContactRaw);
	[id(0x60010032), propput]
	HRESULT __stdcall TouchContactRaw(
		[in]RECT TouchContactRaw);
	[id(0x60010034), propget]
	HRESULT __stdcall TouchOrientation(
		[out, retval]unsigned int* TouchOrientation);
	[id(0x60010034), propput]
	HRESULT __stdcall TouchOrientation(
		[in]unsigned int TouchOrientation);
	[id(0x60010036), propget]
	HRESULT __stdcall TouchPressure(
		[out, retval]unsigned int* TouchPressure);
	[id(0x60010036), propput]
	HRESULT __stdcall TouchPressure(
		[in]unsigned int TouchPressure);
};
```
'!

!ICoreWebView2PointerInfo categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2PointerInfo methodsFor!

buttonChangeKind
	"Answer the <sdword> value of the 'ButtonChangeKind' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ButtonChangeKind: answer.
	^answer asObject!

buttonChangeKind: buttonChangeKind
	"Set the 'ButtonChangeKind' property of the receiver to the <sdword> value of the argument."

	self put_ButtonChangeKind: buttonChangeKind!

displayRect
	"Answer the <RECT> value of the 'DisplayRect' property of the receiver."

	| answer |
	answer := RECT new.
	self get_DisplayRect: answer.
	^answer asObject!

displayRect: displayRect
	"Set the 'DisplayRect' property of the receiver to the <RECT> value of the argument."

	self put_DisplayRect: displayRect asParameter!

frameId
	"Answer the <dword> value of the 'FrameId' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_FrameId: answer.
	^answer asObject!

frameId: frameId
	"Set the 'FrameId' property of the receiver to the <dword> value of the argument."

	self put_FrameId: frameId!

get_ButtonChangeKind: buttonChangeKind
	"Private - Get the value of the 'ButtonChangeKind' property of the receiver.

		HRESULT __stdcall ButtonChangeKind(
			[out, retval]int* ButtonChangeKind);"

	<virtual stdcall: hresult 34 sdword*>
	^self invalidCall: _failureCode!

get_DisplayRect: displayRect
	"Private - Get the value of the 'DisplayRect' property of the receiver.

		HRESULT __stdcall DisplayRect(
			[out, retval]RECT* DisplayRect);"

	<virtual stdcall: hresult 14 RECT*>
	^self invalidCall: _failureCode!

get_FrameId: frameId
	"Private - Get the value of the 'FrameId' property of the receiver.

		HRESULT __stdcall FrameId(
			[out, retval]unsigned int* FrameId);"

	<virtual stdcall: hresult 8 dword*>
	^self invalidCall: _failureCode!

get_HimetricLocation: himetricLocation
	"Private - Get the value of the 'HimetricLocation' property of the receiver.

		HRESULT __stdcall HimetricLocation(
			[out, retval]POINT* HimetricLocation);"

	<virtual stdcall: hresult 18 POINTL*>
	^self invalidCall: _failureCode!

get_HimetricLocationRaw: himetricLocationRaw
	"Private - Get the value of the 'HimetricLocationRaw' property of the receiver.

		HRESULT __stdcall HimetricLocationRaw(
			[out, retval]POINT* HimetricLocationRaw);"

	<virtual stdcall: hresult 22 POINTL*>
	^self invalidCall: _failureCode!

get_HistoryCount: historyCount
	"Private - Get the value of the 'HistoryCount' property of the receiver.

		HRESULT __stdcall HistoryCount(
			[out, retval]unsigned int* HistoryCount);"

	<virtual stdcall: hresult 26 dword*>
	^self invalidCall: _failureCode!

get_InputData: inputData
	"Private - Get the value of the 'InputData' property of the receiver.

		HRESULT __stdcall InputData(
			[out, retval]int* InputData);"

	<virtual stdcall: hresult 28 sdword*>
	^self invalidCall: _failureCode!

get_KeyStates: keyStates
	"Private - Get the value of the 'KeyStates' property of the receiver.

		HRESULT __stdcall KeyStates(
			[out, retval]unsigned long* KeyStates);"

	<virtual stdcall: hresult 30 dword*>
	^self invalidCall: _failureCode!

get_PenFlags: penFlags
	"Private - Get the value of the 'PenFlags' property of the receiver.

		HRESULT __stdcall PenFlags(
			[out, retval]unsigned int* PenFlags);"

	<virtual stdcall: hresult 36 dword*>
	^self invalidCall: _failureCode!

get_PenMask: penMask
	"Private - Get the value of the 'PenMask' property of the receiver.

		HRESULT __stdcall PenMask(
			[out, retval]unsigned int* PenMask);"

	<virtual stdcall: hresult 38 dword*>
	^self invalidCall: _failureCode!

get_PenPressure: penPressure
	"Private - Get the value of the 'PenPressure' property of the receiver.

		HRESULT __stdcall PenPressure(
			[out, retval]unsigned int* PenPressure);"

	<virtual stdcall: hresult 40 dword*>
	^self invalidCall: _failureCode!

get_PenRotation: penRotation
	"Private - Get the value of the 'PenRotation' property of the receiver.

		HRESULT __stdcall PenRotation(
			[out, retval]unsigned int* PenRotation);"

	<virtual stdcall: hresult 42 dword*>
	^self invalidCall: _failureCode!

get_PenTiltX: penTiltX
	"Private - Get the value of the 'PenTiltX' property of the receiver.

		HRESULT __stdcall PenTiltX(
			[out, retval]int* PenTiltX);"

	<virtual stdcall: hresult 44 sdword*>
	^self invalidCall: _failureCode!

get_PenTiltY: penTiltY
	"Private - Get the value of the 'PenTiltY' property of the receiver.

		HRESULT __stdcall PenTiltY(
			[out, retval]int* PenTiltY);"

	<virtual stdcall: hresult 46 sdword*>
	^self invalidCall: _failureCode!

get_PerformanceCount: performanceCount
	"Private - Get the value of the 'PerformanceCount' property of the receiver.

		HRESULT __stdcall PerformanceCount(
			[out, retval]unsigned __int64* PerformanceCount);"

	<virtual stdcall: hresult 32 qword*>
	^self invalidCall: _failureCode!

get_PixelLocation: pixelLocation
	"Private - Get the value of the 'PixelLocation' property of the receiver.

		HRESULT __stdcall PixelLocation(
			[out, retval]POINT* PixelLocation);"

	<virtual stdcall: hresult 16 POINTL*>
	^self invalidCall: _failureCode!

get_PixelLocationRaw: pixelLocationRaw
	"Private - Get the value of the 'PixelLocationRaw' property of the receiver.

		HRESULT __stdcall PixelLocationRaw(
			[out, retval]POINT* PixelLocationRaw);"

	<virtual stdcall: hresult 20 POINTL*>
	^self invalidCall: _failureCode!

get_PointerDeviceRect: pointerDeviceRect
	"Private - Get the value of the 'PointerDeviceRect' property of the receiver.

		HRESULT __stdcall PointerDeviceRect(
			[out, retval]RECT* PointerDeviceRect);"

	<virtual stdcall: hresult 12 RECT*>
	^self invalidCall: _failureCode!

get_PointerFlags: pointerFlags
	"Private - Get the value of the 'PointerFlags' property of the receiver.

		HRESULT __stdcall PointerFlags(
			[out, retval]unsigned int* PointerFlags);"

	<virtual stdcall: hresult 10 dword*>
	^self invalidCall: _failureCode!

get_PointerId: pointerId
	"Private - Get the value of the 'PointerId' property of the receiver.

		HRESULT __stdcall PointerId(
			[out, retval]unsigned int* PointerId);"

	<virtual stdcall: hresult 6 dword*>
	^self invalidCall: _failureCode!

get_PointerKind: pointerKind
	"Private - Get the value of the 'PointerKind' property of the receiver.

		HRESULT __stdcall PointerKind(
			[out, retval]unsigned long* PointerKind);"

	<virtual stdcall: hresult 4 dword*>
	^self invalidCall: _failureCode!

get_Time: time
	"Private - Get the value of the 'Time' property of the receiver.

		HRESULT __stdcall Time(
			[out, retval]unsigned long* Time);"

	<virtual stdcall: hresult 24 dword*>
	^self invalidCall: _failureCode!

get_TouchContact: touchContact
	"Private - Get the value of the 'TouchContact' property of the receiver.

		HRESULT __stdcall TouchContact(
			[out, retval]RECT* TouchContact);"

	<virtual stdcall: hresult 52 RECT*>
	^self invalidCall: _failureCode!

get_TouchContactRaw: touchContactRaw
	"Private - Get the value of the 'TouchContactRaw' property of the receiver.

		HRESULT __stdcall TouchContactRaw(
			[out, retval]RECT* TouchContactRaw);"

	<virtual stdcall: hresult 54 RECT*>
	^self invalidCall: _failureCode!

get_TouchFlags: touchFlags
	"Private - Get the value of the 'TouchFlags' property of the receiver.

		HRESULT __stdcall TouchFlags(
			[out, retval]unsigned int* TouchFlags);"

	<virtual stdcall: hresult 48 dword*>
	^self invalidCall: _failureCode!

get_TouchMask: touchMask
	"Private - Get the value of the 'TouchMask' property of the receiver.

		HRESULT __stdcall TouchMask(
			[out, retval]unsigned int* TouchMask);"

	<virtual stdcall: hresult 50 dword*>
	^self invalidCall: _failureCode!

get_TouchOrientation: touchOrientation
	"Private - Get the value of the 'TouchOrientation' property of the receiver.

		HRESULT __stdcall TouchOrientation(
			[out, retval]unsigned int* TouchOrientation);"

	<virtual stdcall: hresult 56 dword*>
	^self invalidCall: _failureCode!

get_TouchPressure: touchPressure
	"Private - Get the value of the 'TouchPressure' property of the receiver.

		HRESULT __stdcall TouchPressure(
			[out, retval]unsigned int* TouchPressure);"

	<virtual stdcall: hresult 58 dword*>
	^self invalidCall: _failureCode!

himetricLocation
	"Answer the <POINTL> value of the 'HimetricLocation' property of the receiver."

	| answer |
	answer := POINTL new.
	self get_HimetricLocation: answer.
	^answer asObject!

himetricLocation: himetricLocation
	"Set the 'HimetricLocation' property of the receiver to the <POINTL> value of the argument."

	self put_HimetricLocation: himetricLocation asParameter!

himetricLocationRaw
	"Answer the <POINTL> value of the 'HimetricLocationRaw' property of the receiver."

	| answer |
	answer := POINTL new.
	self get_HimetricLocationRaw: answer.
	^answer asObject!

himetricLocationRaw: himetricLocationRaw
	"Set the 'HimetricLocationRaw' property of the receiver to the <POINTL> value of the argument."

	self put_HimetricLocationRaw: himetricLocationRaw asParameter!

historyCount
	"Answer the <dword> value of the 'HistoryCount' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_HistoryCount: answer.
	^answer asObject!

historyCount: historyCount
	"Set the 'HistoryCount' property of the receiver to the <dword> value of the argument."

	self put_HistoryCount: historyCount!

inputData
	"Answer the <sdword> value of the 'InputData' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_InputData: answer.
	^answer asObject!

inputData: inputData
	"Set the 'InputData' property of the receiver to the <sdword> value of the argument."

	self put_InputData: inputData!

keyStates
	"Answer the <dword> value of the 'KeyStates' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_KeyStates: answer.
	^answer asObject!

keyStates: keyStates
	"Set the 'KeyStates' property of the receiver to the <dword> value of the argument."

	self put_KeyStates: keyStates!

penFlags
	"Answer the <dword> value of the 'PenFlags' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PenFlags: answer.
	^answer asObject!

penFlags: penFlags
	"Set the 'PenFlags' property of the receiver to the <dword> value of the argument."

	self put_PenFlags: penFlags!

penMask
	"Answer the <dword> value of the 'PenMask' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PenMask: answer.
	^answer asObject!

penMask: penMask
	"Set the 'PenMask' property of the receiver to the <dword> value of the argument."

	self put_PenMask: penMask!

penPressure
	"Answer the <dword> value of the 'PenPressure' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PenPressure: answer.
	^answer asObject!

penPressure: penPressure
	"Set the 'PenPressure' property of the receiver to the <dword> value of the argument."

	self put_PenPressure: penPressure!

penRotation
	"Answer the <dword> value of the 'PenRotation' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PenRotation: answer.
	^answer asObject!

penRotation: penRotation
	"Set the 'PenRotation' property of the receiver to the <dword> value of the argument."

	self put_PenRotation: penRotation!

penTilt
	^self penTiltX @ self penTiltY!

penTiltX
	"Answer the <sdword> value of the 'PenTiltX' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_PenTiltX: answer.
	^answer asObject!

penTiltX: penTiltX
	"Set the 'PenTiltX' property of the receiver to the <sdword> value of the argument."

	self put_PenTiltX: penTiltX!

penTiltY
	"Answer the <sdword> value of the 'PenTiltY' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_PenTiltY: answer.
	^answer asObject!

penTiltY: penTiltY
	"Set the 'PenTiltY' property of the receiver to the <sdword> value of the argument."

	self put_PenTiltY: penTiltY!

performanceCount
	"Answer the <qword> value of the 'PerformanceCount' property of the receiver."

	| answer |
	answer := ULARGE_INTEGER new.
	self get_PerformanceCount: answer.
	^answer asObject!

performanceCount: performanceCount
	"Set the 'PerformanceCount' property of the receiver to the <qword> value of the argument."

	self put_PerformanceCount: performanceCount!

pixelLocation
	"Answer the <POINTL> value of the 'PixelLocation' property of the receiver."

	| answer |
	answer := POINTL new.
	self get_PixelLocation: answer.
	^answer asObject!

pixelLocation: pixelLocation
	"Set the 'PixelLocation' property of the receiver to the <POINTL> value of the argument."

	self put_PixelLocation: pixelLocation asParameter!

pixelLocationRaw
	"Answer the <POINTL> value of the 'PixelLocationRaw' property of the receiver."

	| answer |
	answer := POINTL new.
	self get_PixelLocationRaw: answer.
	^answer asObject!

pixelLocationRaw: pixelLocationRaw
	"Set the 'PixelLocationRaw' property of the receiver to the <POINTL> value of the argument."

	self put_PixelLocationRaw: pixelLocationRaw asParameter!

pointerDeviceRect
	"Answer the <RECT> value of the 'PointerDeviceRect' property of the receiver."

	| answer |
	answer := RECT new.
	self get_PointerDeviceRect: answer.
	^answer asObject!

pointerDeviceRect: pointerDeviceRect
	"Set the 'PointerDeviceRect' property of the receiver to the <RECT> value of the argument."

	self put_PointerDeviceRect: pointerDeviceRect asParameter!

pointerFlags
	"Answer the <dword> value of the 'PointerFlags' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PointerFlags: answer.
	^answer asObject!

pointerFlags: pointerFlags
	"Set the 'PointerFlags' property of the receiver to the <dword> value of the argument."

	self put_PointerFlags: pointerFlags!

pointerId
	"Answer the <dword> value of the 'PointerId' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PointerId: answer.
	^answer asObject!

pointerId: pointerId
	"Set the 'PointerId' property of the receiver to the <dword> value of the argument."

	self put_PointerId: pointerId!

pointerKind
	"Answer the <dword> value of the 'PointerKind' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_PointerKind: answer.
	^answer asObject!

pointerKind: pointerKind
	"Set the 'PointerKind' property of the receiver to the <dword> value of the argument."

	self put_PointerKind: pointerKind!

printableProperties
	^#(#buttonChangeKind #displayRect #frameId #himetricLocation #himetricLocationRaw #historyCount #inputData #keyStates #penFlags #penMask #penPressure #penRotation #penTilt #performanceCount #pixelLocation #pointerDeviceRect #pointerFlags #pointerId #pointerKind #time #touchContact #touchFlags #touchMask #touchOrientation #touchPressure)!

put_ButtonChangeKind: buttonChangeKind
	"Private - Set the value of the 'ButtonChangeKind' property of the object wrapped by the 
	 receiver to the <sdword> argument, buttonChangeKind.

		HRESULT __stdcall ButtonChangeKind(
			[in]int ButtonChangeKind);"

	<virtual stdcall: hresult 35 sdword>
	^self invalidCall: _failureCode!

put_DisplayRect: displayRect
	"Private - Set the value of the 'DisplayRect' property of the object wrapped by the 
	 receiver to the <RECT> argument, displayRect.

		HRESULT __stdcall DisplayRect(
			[in]RECT DisplayRect);"

	<virtual stdcall: hresult 15 RECT>
	^self invalidCall: _failureCode!

put_FrameId: frameId
	"Private - Set the value of the 'FrameId' property of the object wrapped by the 
	 receiver to the <dword> argument, frameId.

		HRESULT __stdcall FrameId(
			[in]unsigned int FrameId);"

	<virtual stdcall: hresult 9 dword>
	^self invalidCall: _failureCode!

put_HimetricLocation: himetricLocation
	"Private - Set the value of the 'HimetricLocation' property of the object wrapped by the 
	 receiver to the <POINTL> argument, himetricLocation.

		HRESULT __stdcall HimetricLocation(
			[in]POINT HimetricLocation);"

	<virtual stdcall: hresult 19 POINTL>
	^self invalidCall: _failureCode!

put_HimetricLocationRaw: himetricLocationRaw
	"Private - Set the value of the 'HimetricLocationRaw' property of the object wrapped by the 
	 receiver to the <POINTL> argument, himetricLocationRaw.

		HRESULT __stdcall HimetricLocationRaw(
			[in]POINT HimetricLocationRaw);"

	<virtual stdcall: hresult 23 POINTL>
	^self invalidCall: _failureCode!

put_HistoryCount: historyCount
	"Private - Set the value of the 'HistoryCount' property of the object wrapped by the 
	 receiver to the <dword> argument, historyCount.

		HRESULT __stdcall HistoryCount(
			[in]unsigned int HistoryCount);"

	<virtual stdcall: hresult 27 dword>
	^self invalidCall: _failureCode!

put_InputData: inputData
	"Private - Set the value of the 'InputData' property of the object wrapped by the 
	 receiver to the <sdword> argument, inputData.

		HRESULT __stdcall InputData(
			[in]int InputData);"

	<virtual stdcall: hresult 29 sdword>
	^self invalidCall: _failureCode!

put_KeyStates: keyStates
	"Private - Set the value of the 'KeyStates' property of the object wrapped by the 
	 receiver to the <dword> argument, keyStates.

		HRESULT __stdcall KeyStates(
			[in]unsigned long KeyStates);"

	<virtual stdcall: hresult 31 dword>
	^self invalidCall: _failureCode!

put_PenFlags: penFlags
	"Private - Set the value of the 'PenFlags' property of the object wrapped by the 
	 receiver to the <dword> argument, penFlags.

		HRESULT __stdcall PenFlags(
			[in]unsigned int PenFlags);"

	<virtual stdcall: hresult 37 dword>
	^self invalidCall: _failureCode!

put_PenMask: penMask
	"Private - Set the value of the 'PenMask' property of the object wrapped by the 
	 receiver to the <dword> argument, penMask.

		HRESULT __stdcall PenMask(
			[in]unsigned int PenMask);"

	<virtual stdcall: hresult 39 dword>
	^self invalidCall: _failureCode!

put_PenPressure: penPressure
	"Private - Set the value of the 'PenPressure' property of the object wrapped by the 
	 receiver to the <dword> argument, penPressure.

		HRESULT __stdcall PenPressure(
			[in]unsigned int PenPressure);"

	<virtual stdcall: hresult 41 dword>
	^self invalidCall: _failureCode!

put_PenRotation: penRotation
	"Private - Set the value of the 'PenRotation' property of the object wrapped by the 
	 receiver to the <dword> argument, penRotation.

		HRESULT __stdcall PenRotation(
			[in]unsigned int PenRotation);"

	<virtual stdcall: hresult 43 dword>
	^self invalidCall: _failureCode!

put_PenTiltX: penTiltX
	"Private - Set the value of the 'PenTiltX' property of the object wrapped by the 
	 receiver to the <sdword> argument, penTiltX.

		HRESULT __stdcall PenTiltX(
			[in]int PenTiltX);"

	<virtual stdcall: hresult 45 sdword>
	^self invalidCall: _failureCode!

put_PenTiltY: penTiltY
	"Private - Set the value of the 'PenTiltY' property of the object wrapped by the 
	 receiver to the <sdword> argument, penTiltY.

		HRESULT __stdcall PenTiltY(
			[in]int PenTiltY);"

	<virtual stdcall: hresult 47 sdword>
	^self invalidCall: _failureCode!

put_PerformanceCount: performanceCount
	"Private - Set the value of the 'PerformanceCount' property of the object wrapped by the 
	 receiver to the <qword> argument, performanceCount.

		HRESULT __stdcall PerformanceCount(
			[in]unsigned __int64 PerformanceCount);"

	<virtual stdcall: hresult 33 qword>
	^self invalidCall: _failureCode!

put_PixelLocation: pixelLocation
	"Private - Set the value of the 'PixelLocation' property of the object wrapped by the 
	 receiver to the <POINTL> argument, pixelLocation.

		HRESULT __stdcall PixelLocation(
			[in]POINT PixelLocation);"

	<virtual stdcall: hresult 17 POINTL>
	^self invalidCall: _failureCode!

put_PixelLocationRaw: pixelLocationRaw
	"Private - Set the value of the 'PixelLocationRaw' property of the object wrapped by the 
	 receiver to the <POINTL> argument, pixelLocationRaw.

		HRESULT __stdcall PixelLocationRaw(
			[in]POINT PixelLocationRaw);"

	<virtual stdcall: hresult 21 POINTL>
	^self invalidCall: _failureCode!

put_PointerDeviceRect: pointerDeviceRect
	"Private - Set the value of the 'PointerDeviceRect' property of the object wrapped by the 
	 receiver to the <RECT> argument, pointerDeviceRect.

		HRESULT __stdcall PointerDeviceRect(
			[in]RECT PointerDeviceRect);"

	<virtual stdcall: hresult 13 RECT>
	^self invalidCall: _failureCode!

put_PointerFlags: pointerFlags
	"Private - Set the value of the 'PointerFlags' property of the object wrapped by the 
	 receiver to the <dword> argument, pointerFlags.

		HRESULT __stdcall PointerFlags(
			[in]unsigned int PointerFlags);"

	<virtual stdcall: hresult 11 dword>
	^self invalidCall: _failureCode!

put_PointerId: pointerId
	"Private - Set the value of the 'PointerId' property of the object wrapped by the 
	 receiver to the <dword> argument, pointerId.

		HRESULT __stdcall PointerId(
			[in]unsigned int PointerId);"

	<virtual stdcall: hresult 7 dword>
	^self invalidCall: _failureCode!

put_PointerKind: pointerKind
	"Private - Set the value of the 'PointerKind' property of the object wrapped by the 
	 receiver to the <dword> argument, pointerKind.

		HRESULT __stdcall PointerKind(
			[in]unsigned long PointerKind);"

	<virtual stdcall: hresult 5 dword>
	^self invalidCall: _failureCode!

put_Time: time
	"Private - Set the value of the 'Time' property of the object wrapped by the 
	 receiver to the <dword> argument, time.

		HRESULT __stdcall Time(
			[in]unsigned long Time);"

	<virtual stdcall: hresult 25 dword>
	^self invalidCall: _failureCode!

put_TouchContact: touchContact
	"Private - Set the value of the 'TouchContact' property of the object wrapped by the 
	 receiver to the <RECT> argument, touchContact.

		HRESULT __stdcall TouchContact(
			[in]RECT TouchContact);"

	<virtual stdcall: hresult 53 RECT>
	^self invalidCall: _failureCode!

put_TouchContactRaw: touchContactRaw
	"Private - Set the value of the 'TouchContactRaw' property of the object wrapped by the 
	 receiver to the <RECT> argument, touchContactRaw.

		HRESULT __stdcall TouchContactRaw(
			[in]RECT TouchContactRaw);"

	<virtual stdcall: hresult 55 RECT>
	^self invalidCall: _failureCode!

put_TouchFlags: touchFlags
	"Private - Set the value of the 'TouchFlags' property of the object wrapped by the 
	 receiver to the <dword> argument, touchFlags.

		HRESULT __stdcall TouchFlags(
			[in]unsigned int TouchFlags);"

	<virtual stdcall: hresult 49 dword>
	^self invalidCall: _failureCode!

put_TouchMask: touchMask
	"Private - Set the value of the 'TouchMask' property of the object wrapped by the 
	 receiver to the <dword> argument, touchMask.

		HRESULT __stdcall TouchMask(
			[in]unsigned int TouchMask);"

	<virtual stdcall: hresult 51 dword>
	^self invalidCall: _failureCode!

put_TouchOrientation: touchOrientation
	"Private - Set the value of the 'TouchOrientation' property of the object wrapped by the 
	 receiver to the <dword> argument, touchOrientation.

		HRESULT __stdcall TouchOrientation(
			[in]unsigned int TouchOrientation);"

	<virtual stdcall: hresult 57 dword>
	^self invalidCall: _failureCode!

put_TouchPressure: touchPressure
	"Private - Set the value of the 'TouchPressure' property of the object wrapped by the 
	 receiver to the <dword> argument, touchPressure.

		HRESULT __stdcall TouchPressure(
			[in]unsigned int TouchPressure);"

	<virtual stdcall: hresult 59 dword>
	^self invalidCall: _failureCode!

time
	"Answer the <dword> value of the 'Time' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_Time: answer.
	^answer asObject!

time: time
	"Set the 'Time' property of the receiver to the <dword> value of the argument."

	self put_Time: time!

touchContact
	"Answer the <RECT> value of the 'TouchContact' property of the receiver."

	| answer |
	answer := RECT new.
	self get_TouchContact: answer.
	^answer asObject!

touchContact: touchContact
	"Set the 'TouchContact' property of the receiver to the <RECT> value of the argument."

	self put_TouchContact: touchContact!

touchContactRaw
	"Answer the <RECT> value of the 'TouchContactRaw' property of the receiver."

	| answer |
	answer := RECT new.
	self get_TouchContactRaw: answer.
	^answer asObject!

touchContactRaw: touchContactRaw
	"Set the 'TouchContactRaw' property of the receiver to the <RECT> value of the argument."

	self put_TouchContactRaw: touchContactRaw!

touchFlags
	"Answer the <dword> value of the 'TouchFlags' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_TouchFlags: answer.
	^answer asObject!

touchFlags: touchFlags
	"Set the 'TouchFlags' property of the receiver to the <dword> value of the argument."

	self put_TouchFlags: touchFlags!

touchMask
	"Answer the <dword> value of the 'TouchMask' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_TouchMask: answer.
	^answer asObject!

touchMask: touchMask
	"Set the 'TouchMask' property of the receiver to the <dword> value of the argument."

	self put_TouchMask: touchMask!

touchOrientation
	"Answer the <dword> value of the 'TouchOrientation' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_TouchOrientation: answer.
	^answer asObject!

touchOrientation: touchOrientation
	"Set the 'TouchOrientation' property of the receiver to the <dword> value of the argument."

	self put_TouchOrientation: touchOrientation!

touchPressure
	"Answer the <dword> value of the 'TouchPressure' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_TouchPressure: answer.
	^answer asObject!

touchPressure: touchPressure
	"Set the 'TouchPressure' property of the receiver to the <dword> value of the argument."

	self put_TouchPressure: touchPressure! !

!ICoreWebView2PointerInfo categoriesForMethods!
buttonChangeKind!**auto generated**!properties!public! !
buttonChangeKind:!**auto generated**!properties!public! !
displayRect!**auto generated**!properties!public! !
displayRect:!properties!public! !
frameId!**auto generated**!properties!public! !
frameId:!**auto generated**!properties!public! !
get_ButtonChangeKind:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_DisplayRect:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_FrameId:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_HimetricLocation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_HimetricLocationRaw:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_HistoryCount:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_InputData:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_KeyStates:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PenFlags:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PenMask:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PenPressure:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PenRotation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PenTiltX:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PenTiltY:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PerformanceCount:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PixelLocation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PixelLocationRaw:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PointerDeviceRect:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PointerFlags:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PointerId:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_PointerKind:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_Time:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_TouchContact:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_TouchContactRaw:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_TouchFlags:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_TouchMask:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_TouchOrientation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
get_TouchPressure:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
himetricLocation!**auto generated**!properties!public! !
himetricLocation:!properties!public! !
himetricLocationRaw!**auto generated**!properties!public! !
himetricLocationRaw:!properties!public! !
historyCount!**auto generated**!properties!public! !
historyCount:!**auto generated**!properties!public! !
inputData!**auto generated**!properties!public! !
inputData:!**auto generated**!properties!public! !
keyStates!**auto generated**!properties!public! !
keyStates:!**auto generated**!properties!public! !
penFlags!**auto generated**!properties!public! !
penFlags:!**auto generated**!properties!public! !
penMask!**auto generated**!properties!public! !
penMask:!**auto generated**!properties!public! !
penPressure!**auto generated**!properties!public! !
penPressure:!**auto generated**!properties!public! !
penRotation!**auto generated**!properties!public! !
penRotation:!**auto generated**!properties!public! !
penTilt!properties!public! !
penTiltX!**auto generated**!properties!public! !
penTiltX:!**auto generated**!properties!public! !
penTiltY!**auto generated**!properties!public! !
penTiltY:!**auto generated**!properties!public! !
performanceCount!**auto generated**!properties!public! !
performanceCount:!**auto generated**!properties!public! !
pixelLocation!**auto generated**!properties!public! !
pixelLocation:!properties!public! !
pixelLocationRaw!**auto generated**!properties!public! !
pixelLocationRaw:!properties!public! !
pointerDeviceRect!**auto generated**!properties!public! !
pointerDeviceRect:!properties!public! !
pointerFlags!**auto generated**!properties!public! !
pointerFlags:!**auto generated**!properties!public! !
pointerId!**auto generated**!properties!public! !
pointerId:!**auto generated**!properties!public! !
pointerKind!**auto generated**!properties!public! !
pointerKind:!**auto generated**!properties!public! !
printableProperties!printing!public! !
put_ButtonChangeKind:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_DisplayRect:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_FrameId:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_HimetricLocation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_HimetricLocationRaw:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_HistoryCount:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_InputData:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_KeyStates:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PenFlags:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PenMask:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PenPressure:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PenRotation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PenTiltX:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PenTiltY:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PerformanceCount:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PixelLocation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PixelLocationRaw:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PointerDeviceRect:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PointerFlags:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PointerId:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_PointerKind:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_Time:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_TouchContact:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_TouchContactRaw:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_TouchFlags:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_TouchMask:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_TouchOrientation:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
put_TouchPressure:!**auto generated**!COM Interfaces-ICoreWebView2PointerInfo!private! !
time!**auto generated**!properties!public! !
time:!**auto generated**!properties!public! !
touchContact!**auto generated**!properties!public! !
touchContact:!**auto generated**!properties!public! !
touchContactRaw!**auto generated**!properties!public! !
touchContactRaw:!**auto generated**!properties!public! !
touchFlags!**auto generated**!properties!public! !
touchFlags:!**auto generated**!properties!public! !
touchMask!**auto generated**!properties!public! !
touchMask:!**auto generated**!properties!public! !
touchOrientation!**auto generated**!properties!public! !
touchOrientation:!**auto generated**!properties!public! !
touchPressure!**auto generated**!properties!public! !
touchPressure:!**auto generated**!properties!public! !
!

!ICoreWebView2PointerInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PointerInfo'
		ICoreWebView2PointerInfo defineTemplate"

	self
		defineFunction: #get_PointerKind:
			argumentTypes: 'dword*';
		defineFunction: #put_PointerKind:
			argumentTypes: 'dword';
		defineFunction: #get_PointerId:
			argumentTypes: 'dword*';
		defineFunction: #put_PointerId:
			argumentTypes: 'dword';
		defineFunction: #get_FrameId:
			argumentTypes: 'dword*';
		defineFunction: #put_FrameId:
			argumentTypes: 'dword';
		defineFunction: #get_PointerFlags:
			argumentTypes: 'dword*';
		defineFunction: #put_PointerFlags:
			argumentTypes: 'dword';
		defineFunction: #get_PointerDeviceRect:
			argumentTypes: 'RECT*';
		defineFunction: #put_PointerDeviceRect:
			argumentTypes: 'RECT';
		defineFunction: #get_DisplayRect:
			argumentTypes: 'RECT*';
		defineFunction: #put_DisplayRect:
			argumentTypes: 'RECT';
		defineFunction: #get_PixelLocation:
			argumentTypes: 'POINTL*';
		defineFunction: #put_PixelLocation:
			argumentTypes: 'POINTL';
		defineFunction: #get_HimetricLocation:
			argumentTypes: 'POINTL*';
		defineFunction: #put_HimetricLocation:
			argumentTypes: 'POINTL';
		defineFunction: #get_PixelLocationRaw:
			argumentTypes: 'POINTL*';
		defineFunction: #put_PixelLocationRaw:
			argumentTypes: 'POINTL';
		defineFunction: #get_HimetricLocationRaw:
			argumentTypes: 'POINTL*';
		defineFunction: #put_HimetricLocationRaw:
			argumentTypes: 'POINTL';
		defineFunction: #get_Time:
			argumentTypes: 'dword*';
		defineFunction: #put_Time:
			argumentTypes: 'dword';
		defineFunction: #get_HistoryCount:
			argumentTypes: 'dword*';
		defineFunction: #put_HistoryCount:
			argumentTypes: 'dword';
		defineFunction: #get_InputData:
			argumentTypes: 'sdword*';
		defineFunction: #put_InputData:
			argumentTypes: 'sdword';
		defineFunction: #get_KeyStates:
			argumentTypes: 'dword*';
		defineFunction: #put_KeyStates:
			argumentTypes: 'dword';
		defineFunction: #get_PerformanceCount:
			argumentTypes: 'qword*';
		defineFunction: #put_PerformanceCount:
			argumentTypes: 'qword';
		defineFunction: #get_ButtonChangeKind:
			argumentTypes: 'sdword*';
		defineFunction: #put_ButtonChangeKind:
			argumentTypes: 'sdword';
		defineFunction: #get_PenFlags:
			argumentTypes: 'dword*';
		defineFunction: #put_PenFlags:
			argumentTypes: 'dword';
		defineFunction: #get_PenMask:
			argumentTypes: 'dword*';
		defineFunction: #put_PenMask:
			argumentTypes: 'dword';
		defineFunction: #get_PenPressure:
			argumentTypes: 'dword*';
		defineFunction: #put_PenPressure:
			argumentTypes: 'dword';
		defineFunction: #get_PenRotation:
			argumentTypes: 'dword*';
		defineFunction: #put_PenRotation:
			argumentTypes: 'dword';
		defineFunction: #get_PenTiltX:
			argumentTypes: 'sdword*';
		defineFunction: #put_PenTiltX:
			argumentTypes: 'sdword';
		defineFunction: #get_PenTiltY:
			argumentTypes: 'sdword*';
		defineFunction: #put_PenTiltY:
			argumentTypes: 'sdword';
		defineFunction: #get_TouchFlags:
			argumentTypes: 'dword*';
		defineFunction: #put_TouchFlags:
			argumentTypes: 'dword';
		defineFunction: #get_TouchMask:
			argumentTypes: 'dword*';
		defineFunction: #put_TouchMask:
			argumentTypes: 'dword';
		defineFunction: #get_TouchContact:
			argumentTypes: 'RECT*';
		defineFunction: #put_TouchContact:
			argumentTypes: 'RECT';
		defineFunction: #get_TouchContactRaw:
			argumentTypes: 'RECT*';
		defineFunction: #put_TouchContactRaw:
			argumentTypes: 'RECT';
		defineFunction: #get_TouchOrientation:
			argumentTypes: 'dword*';
		defineFunction: #put_TouchOrientation:
			argumentTypes: 'dword';
		defineFunction: #get_TouchPressure:
			argumentTypes: 'dword*';
		defineFunction: #put_TouchPressure:
			argumentTypes: 'dword'
! !

!ICoreWebView2PointerInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

