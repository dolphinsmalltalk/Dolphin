"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #INPPlugHole
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'NPDolphinConstants'
	classInstanceVariableNames: ''!
INPPlugHole guid: (IID fromString: '{F0B3E8DC-719F-11D3-97BC-0080C8D59432}')!
INPPlugHole comment: '<INPPlugHole> is a wrapper class for the COM interface ''NPDolphin.INPPlugHole'' generated from type information in the ''Dolphin Internet Browser Plugin 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"INPPlugHole Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!INPPlugHole categoriesForClass!Plugin-Interfaces! !
!INPPlugHole methodsFor!

DestroyStream: piStream
	"Invoke the DestroyStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Ask Netscape to destroy the specified NPStream'

		HRESULT __stdcall DestroyStream(
			[in] INPStream* piStream);
	"

	<virtual stdcall: hresult 4 INPStream*>
	^self invalidCall
!

DestroyStream: piStream reason: reason
	"Invoke the DestroyStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Ask Netscape to destroy the specified NPStream'

		HRESULT __stdcall DestroyStream(
			[in] INPStream* piStream,
			[in] short reason);
	"

	<virtual stdcall: hresult 4 INPStream* sword>
	^self invalidCall
!

ForceRedraw: piInstance
	"Invoke the ForceRedraw() method of the COM object wrapped by the receiver.
	Helpstring: 'Force a paint message for the specified windowless plugin instance'

		HRESULT __stdcall ForceRedraw(
			[in] unsigned long piInstance);
	"

	<virtual stdcall: hresult 4 dword>
	^self invalidCall
!

get_JavaEnv: ppiJRIEnv
	"Get the value of the 'JavaEnv' property of the receiver.
	Helpstring: 'Get the Java execution environment'

		HRESULT __stdcall JavaEnv(
			[out, retval] IUnknown** ppiJRIEnv);
	"

	<virtual stdcall: hresult 5 IUnknown**>
	^self invalidCall
!

get_JavaPeer: instance pVal: pVal
	"Get the value of the 'JavaPeer' property of the receiver.
	Helpstring: 'The java object associated with the specified plug-in instance'

		HRESULT __stdcall JavaPeer(
			[in] unsigned long Instance,
			[out, retval] long* pVal);
	"

	<virtual stdcall: hresult 6 dword sdword*>
	^self invalidCall
!

get_Peer: pVal
	"Get the value of the 'Peer' property of the receiver.
	Helpstring: 'Corresponding peer object in the Dolphin image.'

		HRESULT __stdcall Peer(
			[out, retval] IUnknown** pVal);
	"

	<virtual stdcall: hresult 13 IUnknown**>
	^self invalidCall
!

get_UserAgent: instance pVal: pVal
	"Get the value of the 'UserAgent' property of the receiver.
	Helpstring: 'Browser''s user agent description'

		HRESULT __stdcall UserAgent(
			[in] unsigned long Instance,
			[out, retval] LPSTR* pVal);
	"

	<virtual stdcall: hresult 21 dword lpstr*>
	^self invalidCall
!

get_Value: instance Variable: variable pVal: pVal
	"Get the value of the 'Value' property of the receiver.
	Helpstring: 'Query a variable value associated with the specified plug-in instance from the browser'

		HRESULT __stdcall Value(
			[in] unsigned long Instance,
			[in] long Variable,
			[out, retval] VARIANT* pVal);
	"

	<virtual stdcall: hresult 9 dword sdword VARIANT*>
	^self invalidCall
!

GetURL: instance URL: url Target: target
	"Invoke the GetURL() method of the COM object wrapped by the receiver.
	Helpstring: 'Request a stream on the specified URL from the browser'

		HRESULT __stdcall GetURL(
			[in] unsigned long Instance,
			[in] LPSTR URL,
			[in] LPSTR Target);
	"

	<virtual stdcall: hresult 7 dword lpstr lpstr>
	^self invalidCall
!

GetURLNotify: instance URL: url Target: target NotifyData: notifyData
	"Invoke the GetURLNotify() method of the COM object wrapped by the receiver.
	Helpstring: 'Requests creation of a new stream with the contents of the specified URL; gets notification of the result through INPP::URLNotify'

		HRESULT __stdcall GetURLNotify(
			[in] unsigned long Instance,
			[in] LPSTR URL,
			[in] LPSTR Target,
			unsigned long NotifyData);
	"

	<virtual stdcall: hresult 8 dword lpstr lpstr dword>
	^self invalidCall
!

GetVersions: pPluginVer pBrowserVer: pBrowserVer
	"Invoke the GetVersions() method of the COM object wrapped by the receiver.
	Helpstring: 'Get the Netscape Plugin API version numbers'

		HRESULT __stdcall GetVersions(
			[out] unsigned long* pPluginVer,
			[out] unsigned long* pBrowserVer);
	"

	<virtual stdcall: hresult 15 dword* dword*>
	^self invalidCall
!

InvalidateRect: instance Top: top Left: left Bottom: bottom Right: right
	"Invoke the InvalidateRect() method of the COM object wrapped by the receiver.
	Helpstring: 'Invalidates specified drawing area prior to repainting or refreshing a windowless plug-in'

		HRESULT __stdcall InvalidateRect(
			[in] unsigned long Instance,
			[in] long Top,
			[in] long Left,
			[in] long Bottom,
			[in] long Right);
	"

	<virtual stdcall: hresult 11 dword sdword sdword sdword sdword>
	^self invalidCall
!

InvalidateRegion: instance Region: region
	"Invoke the InvalidateRegion() method of the COM object wrapped by the receiver.
	Helpstring: 'Invalidates specified drawing region prior to repainting or refreshing a windowless plug-in'

		HRESULT __stdcall InvalidateRegion(
			[in] unsigned long Instance,
			[in] long Region);
	"

	<virtual stdcall: hresult 12 dword sdword>
	^self invalidCall
!

javaEnv
	"Answer the <IUnknown> value of the 'JavaEnv' property of the receiver.
	Helpstring: 'Get the Java execution environment'"

	| ppiJRIEnv |
	ppiJRIEnv := IUnknown newPointer.
	self get_JavaEnv: ppiJRIEnv.
	^ppiJRIEnv asObject
!

javaPeer: instance 
	"Answer the <sdword> value of the 'JavaPeer' property of the receiver.
	Helpstring: 'The java object associated with the specified plug-in instance'"

	| pVal |
	pVal := SDWORD new.
	self get_JavaPeer: instance pVal: pVal.
	^pVal asObject
!

newStream: instance mimeType: mimeType target: target 
	"Answer the <INPStream> result of invoking the COM Object's NewStream() method.
	Helpstring: 'Requests the creation of a new data stream onto which the plug-in can write (i.e. for output)'"

	| ppiStream |
	ppiStream := INPStream newPointer.
	self NewStream: instance MIMEType: mimeType Target: target ppiStream: ppiStream.
	^ppiStream asObject
!

NewStream: instance MIMEType: mimeType Target: target ppiStream: ppiStream
	"Invoke the NewStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Requests the creation of a new data stream onto which the plug-in can write (i.e. for output)'

		HRESULT __stdcall NewStream(
			[in] unsigned long Instance,
			[in] LPSTR MIMEType,
			LPSTR Target,
			[out, retval] INPStream** ppiStream);
	"

	<virtual stdcall: hresult 16 dword lpstr lpstr INPStream**>
	^self invalidCall
!

peer
	"Answer the <IUnknown> value of the 'Peer' property of the receiver.
	Helpstring: 'Corresponding peer object in the Dolphin image.'"

	| pVal |
	pVal := IUnknown newPointer.
	self get_Peer: pVal.
	^pVal asObject
!

PostURL: instance URL: url Target: target BufLen: bufLen Buf: buf File: file
	"Invoke the PostURL() method of the COM object wrapped by the receiver.
	Helpstring: 'Post data from a file or buffer to the specified URL'

		HRESULT __stdcall PostURL(
			[in] unsigned long Instance,
			[in] LPSTR URL,
			[in] LPSTR Target,
			[in] unsigned long BufLen,
			[in] LPSTR Buf,
			[in] long File);
	"

	<virtual stdcall: hresult 17 dword lpstr lpstr dword lpstr sdword>
	^self invalidCall
!

PostURLNotify: instance URL: url Target: target BufLen: bufLen Buf: buf File: file NotifyData: notifyData
	"Invoke the PostURLNotify() method of the COM object wrapped by the receiver.
	Helpstring: 'Posts data to a URL with notifications'

		HRESULT __stdcall PostURLNotify(
			[in] unsigned long Instance,
			[in] LPSTR URL,
			[in] LPSTR Target,
			[in] unsigned long BufLen,
			[in] LPSTR Buf,
			long File,
			[in] unsigned long NotifyData);
	"

	<virtual stdcall: hresult 18 dword lpstr lpstr dword lpstr sdword dword>
	^self invalidCall
!

put_Peer: pVal
	"Set the value of the 'Peer' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, pVal.
	Helpstring: 'Corresponding peer object in the Dolphin image.'

		HRESULT __stdcall Peer(
			[in] IUnknown* pVal);
	"

	<virtual stdcall: hresult 14 IUnknown*>
	^self invalidCall
!

put_Status: instance _: arg2
	"Set the value of the 'Status' property of the object wrapped by the 
	 receiver to the <lpstr> argument, arg2.
	Helpstring: 'Set the browser status line text'

		HRESULT __stdcall Status(
			[in] unsigned long Instance,
			[in] LPSTR arg2);
	"

	<virtual stdcall: hresult 20 dword lpstr>
	^self invalidCall
!

put_Value: instance Variable: variable pVal: pVal
	"Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <VARIANT> argument, pVal.
	Helpstring: 'Query a variable value associated with the specified plug-in instance from the browser'

		HRESULT __stdcall Value(
			[in] unsigned long Instance,
			[in] long Variable,
			[in] VARIANT pVal);
	"

	<virtual stdcall: hresult 10 dword sdword VARIANT>
	^self invalidCall
!

ReloadPlugins: reloadPages
	"Invoke the ReloadPlugins() method of the COM object wrapped by the receiver.
	Helpstring: 'Reloads all plug-ins in the Plugins directory'

		HRESULT __stdcall ReloadPlugins(
			[in] long ReloadPages);
	"

	<virtual stdcall: hresult 19 sdword>
	^self invalidCall
!

RequestRead: stream offset: offset Length: length
	"Invoke the RequestRead() method of the COM object wrapped by the receiver.
	Helpstring: 'Request a range of bytes (delivered asynchronously) from a seekable stream'

		HRESULT __stdcall RequestRead(
			[in] INPStream* Stream,
			[in] long offset,
			[in] unsigned long Length);
	"

	<virtual stdcall: hresult 22 INPStream* sdword dword>
	^self invalidCall
!

status: instance _: arg2 
	"Set the 'Status' property of the receiver to the <lpstr> value of the argument.
	Helpstring: 'Set the browser status line text'"

	self put_Status: instance _: arg2
!

userAgent: instance 
	"Answer the <lpstr> value of the 'UserAgent' property of the receiver.
	Helpstring: 'Browser''s user agent description'"

	| pVal answer |
	pVal := COMTaskMemory new.
	self get_UserAgent: instance pVal: pVal.
	answer := String fromAddress: pVal.
	pVal free.
	^answer
!

value: instance variable: variable 
	"Answer the <VARIANT> value of the 'Value' property of the receiver.
	Helpstring: 'Query a variable value associated with the specified plug-in instance from the browser'"

	| pVal |
	pVal := VARIANT new.
	self get_Value: instance Variable: variable pVal: pVal asVariant.
	^pVal asObject
!

value: instance variable: variable pVal: pVal 
	"Set the 'Value' property of the receiver to the <VARIANT> value of the argument.
	Helpstring: 'Query a variable value associated with the specified plug-in instance from the browser'"

	self put_Value: instance Variable: variable pVal: pVal asVariant
!

WriteStream: stream BufLen: bufLen Buf: buf
	"Invoke the WriteStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Write a block of bytes to a stream'

		HRESULT __stdcall WriteStream(
			[in] INPStream* Stream,
			[in] long BufLen,
			[in] char* Buf);
	"

	<virtual stdcall: hresult 25 INPStream* sdword byte*>
	^self invalidCall
! !
!INPPlugHole categoriesFor: #DestroyStream:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #DestroyStream:reason:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #ForceRedraw:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #get_JavaEnv:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #get_JavaPeer:pVal:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #get_Peer:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #get_UserAgent:pVal:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #get_Value:Variable:pVal:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #GetURL:URL:Target:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #GetURLNotify:URL:Target:NotifyData:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #GetVersions:pBrowserVer:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #InvalidateRect:Top:Left:Bottom:Right:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #InvalidateRegion:Region:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #javaEnv!**auto generated**!public! !
!INPPlugHole categoriesFor: #javaPeer:!**auto generated**!public! !
!INPPlugHole categoriesFor: #newStream:mimeType:target:!**auto generated**!public! !
!INPPlugHole categoriesFor: #NewStream:MIMEType:Target:ppiStream:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #peer!**auto generated**!public! !
!INPPlugHole categoriesFor: #PostURL:URL:Target:BufLen:Buf:File:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #PostURLNotify:URL:Target:BufLen:Buf:File:NotifyData:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #put_Peer:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #put_Status:_:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #put_Value:Variable:pVal:!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #ReloadPlugins:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #RequestRead:offset:Length:!**auto generated**!COM Interfaces-INPPlugHole!public! !
!INPPlugHole categoriesFor: #status:_:!**auto generated**!public! !
!INPPlugHole categoriesFor: #userAgent:!accessing!public! !
!INPPlugHole categoriesFor: #value:variable:!**auto generated**!public! !
!INPPlugHole categoriesFor: #value:variable:pVal:!**auto generated**!public! !
!INPPlugHole categoriesFor: #WriteStream:BufLen:Buf:!**auto generated**!COM Interfaces-INPPlugHole!public! !

!INPPlugHole class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'NPDolphin.INPPlugHole'
		INPPlugHole defineTemplate
	"

	self
		defineFunction: #ForceRedraw:
			argumentTypes: 'dword';
		defineFunction: #get_JavaEnv:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_JavaPeer:pVal:
			argumentTypes: 'dword sdword*';
		defineFunction: #GetURL:URL:Target:
			argumentTypes: 'dword lpstr lpstr';
		defineFunction: #GetURLNotify:URL:Target:NotifyData:
			argumentTypes: 'dword lpstr lpstr dword';
		defineFunction: #get_Value:Variable:pVal:
			argumentTypes: 'dword sdword VARIANT*';
		defineFunction: #put_Value:Variable:pVal:
			argumentTypes: 'dword sdword VARIANT';
		defineFunction: #InvalidateRect:Top:Left:Bottom:Right:
			argumentTypes: 'dword sdword sdword sdword sdword';
		defineFunction: #InvalidateRegion:Region:
			argumentTypes: 'dword sdword';
		defineFunction: #get_Peer:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Peer:
			argumentTypes: 'IUnknown*';
		defineFunction: #GetVersions:pBrowserVer:
			argumentTypes: 'dword* dword*';
		defineFunction: #NewStream:MIMEType:Target:ppiStream:
			argumentTypes: 'dword lpstr lpstr INPStream**';
		defineFunction: #PostURL:URL:Target:BufLen:Buf:File:
			argumentTypes: 'dword lpstr lpstr dword lpstr sdword';
		defineFunction: #PostURLNotify:URL:Target:BufLen:Buf:File:NotifyData:
			argumentTypes: 'dword lpstr lpstr dword lpstr sdword dword';
		defineFunction: #ReloadPlugins:
			argumentTypes: 'sdword';
		defineFunction: #put_Status:_:
			argumentTypes: 'dword lpstr';
		defineFunction: #get_UserAgent:pVal:
			argumentTypes: 'dword lpstr*'
! !
!INPPlugHole class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

