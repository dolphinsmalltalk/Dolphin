"Filed out from Dolphin Smalltalk 7"!

ControlView subclass: #AXControlSite
	instanceVariableNames: 'progId dispControl host sink hostFlags propertyMap ambientDispatch unkControl licenseKey _reserved1 _reserved2'
	classVariableNames: 'StandardPropNames WM_ATLGETHOST'
	poolDictionaries: 'AXAutomationConstants AXAutomationErrors'
	classInstanceVariableNames: ''
	classConstants: {
		'AllowContextMenuMask' -> 16r400.
		'AllowShowUIMask' -> 16r200.
		'AllowWindowlessMask' -> 16r20.
		'DisplayAsDefaultMask' -> 16r80.
		'FireControlEventsMask' -> 16r4.
		'FirePropertyEventsMask' -> 16r1.
		'ReflectMask' -> 16r100.
		'TraceEventsMask' -> 16r2.
		'UserModeMask' -> 16r40.
		'WM_FORWARDMSG' -> 16r37F
	}!
AXControlSite guid: (GUID fromString: '{804d8c3f-38c6-4928-bd58-574c2b24a053}')!
AXControlSite comment: 'AXControlSite is a <ControlView> which is able to host almost any Active-X control - also referred to as OLE controls, or OCXs. This includes both non-visual controls that require in-place activation (see example1), or to host true visual controls (see AXControlSite class>>example2) including the Microsoft Web Browser control. Events from the control can be enabled, and are triggered off the AXControlSite''s presenter (usually itself).

The best way to experiment with AXControlSite is to try it out in the simple Active-X control browser, <AXTestContainer>.

Instance Variables:
	progId		<readableString>. prog id or CLSID string of the control (or can be HTML text)
	dispControl	<IDispatch>. The control''s default interface (down cast to actual interface if generated)
	host		<IAxWinHostWindow> of the ATL host.
	sink		<AXEventSink>|nil. If sinking events, then an object which sinks events from the control.
	hostFlags		<integer>. Various flags (mainly ambient properties).
	propertyMap	<LookupTable>. Map between property dispids and names.
	ambientDispatch 	<IAxWinAmbientDispatch> of the ATL host.
	unkControl 	<IUnknown> of the hosted control.
	licenseKey 	<readableString>|nil. License for the hosted control, if required.
	reserved1 		Reserved for future use.
	reserved2		Reserved for future use.

Class Variables:
	AllowContextMenuMask	<integer>. Ambient boolean property mask.
	AllowShowUIMask		<integer>. Ambient boolean property mask.
	AllowWindowlessMask	<integer>. Ambient boolean property mask.
	DisplayAsDefaultMask	<integer>. Ambient boolean property mask.
	FireControlEventsMask 	<integer>. Mask for control events enabled/disabled flag.
	FirePropertyEventsMask	<integer>. Mask for property notifications enabled/disabled flag.
	ReflectMask		<integer>. Ambient boolean property mask.
	TraceEventsMask		<integer>. Mask for event tracing enabled/disabled flag.
	UserModeMask		<integer>. Ambient boolean property mask.
	WM_FORWARDMSG	<integer>. Id of Windows message sent to control for pre-translating MSGs. Used by ATL to forward a message to another window for processing WPARAM - DWORD dwUserData - defined by user, LPARAM - LPMSG pMsg - a pointer to the MSG structure, return value - 0 if the message was not processed, nonzero if it was
	WM_ATLGETHOST	<integer>. Id of Windows message sent to control host to request IAxWinHostWindow.
'!
!AXControlSite categoriesForClass!MVP-Views! !
!AXControlSite methodsFor!

aboutControl
	"Pop the controls about box."

	[self controlDispatch invokeId: -552 flags: DISPATCH_METHOD parms: DISPPARAMS zeroArgs retVal: nil]
		on: HRESULTError do: [:e | | caption |
			caption := self progId.
			caption size > 50 ifTrue: [
				caption := (caption leftString: 50), '...'].
			MessageBox 
				warning: 'Sorry, the control refused to show its about box.'
				caption: caption]!

allowContextMenu
	"Answer whether the embedded control is permitted to pop a context menu.
	This is an ambient property."

	^self ambientDispatch allowContextMenu
!

allowContextMenu: aBoolean
	"Set whether the receiver's embedded control can pop a context menu.
	This is an ambient property."

	hostFlags := hostFlags mask: AllowContextMenuMask set: aBoolean.
	self ambientDispatch allowContextMenu: aBoolean


!

allowShowUI
	"Answer whether the embedded control is permitted to show its UI.
	This is an ambient property."

	^self ambientDispatch allowShowUI!

allowShowUI: aBoolean
	"Set whether the receiver's embedded control can show its UI.
	This is an ambient property."

	hostFlags := hostFlags mask: AllowShowUIMask set: aBoolean.
	self ambientDispatch allowShowUI: aBoolean!

allowWindowless
	"Answer whether the control can be activated in windowless mode."

	^self ambientDispatch allowWindowlessActivation!

allowWindowless: aBoolean
	"Set whether the hosted control can be activated without a window or not.
	This is an ambient property. Note that we must recreate the control for any
	notice to be taken of the flag, and even then many controls do not support
	windowless activation."

	| oldHostFlags |
	oldHostFlags := hostFlags.
	hostFlags := hostFlags mask: AllowWindowlessMask set: aBoolean.
	self ambientDispatch allowWindowlessActivation: aBoolean.
	hostFlags ~= oldHostFlags ifTrue: [self recreateControl].
!

ambientDispatch
	"Answer an <IAxWinAmbientDispatch> which is the dispinterface used to get/set ambient properties on the control site."

	ambientDispatch isNull ifTrue: [
		ambientDispatch := self hostInterface queryInterface: IAxWinAmbientDispatchEx].
	^ambientDispatch!

backcolor
	"Answers the background colour of the receiver, or nil if the default."

	| color |
	color := self ambientDispatch backColor.
	^color = Color window ifFalse: [color]!

backcolor: aColor
	"Sets the background colour of the receiver to the <Color>, color.
	We need to pass on this ambient property to the ATL control host.
	Note that the control may ignore the ambient property entirely, or
	respect it only on initial creation."

	self ambientDispatch backColor: aColor
!

binaryStoreControlOnIStream: target
	"Private - Persist the current control state to the <IStream>, target,
	using its implementation of <IPersistStream>."

	unkControl isNull ifFalse: [ | ips |
		ips := unkControl 
				queryInterface: IPersistStreamInit
				ifNone: [unkControl queryInterface: IPersistStream].
		ips isNull
			ifFalse: [
				OLELibrary default oleSaveToStream: ips pStm: target.
				^self]].

	target nextPutCLSID: self clsid!

clientSite
	"Answer the receiver's <IOleClientSite> interface."

	| site |
	site := self hostInterface queryInterface: IOleClientSite.
	self assert: [site notNil].
	^site!

clsid
	"Answer the <CLSID> of the hosted control."

	^CLSID fromString: self progId!

connectSink
	"Private - Wire up an <AXEventSink> to the control's default event interface, and set it up to trigger
	events off the receiver's presenter when they arrive from the control."

	| tiSink unk |
	sink := nil.
	unk := self controlUnknown.
	tiSink := (unk coclassTypeInfoIfNone: []) 
				ifNotNil: [:coclass | coclass defaultSourceInterface].
	tiSink isNil ifTrue: [^self].
	sink := self eventSinkClass target: self presenter sourceTypeInfo: tiSink.
	sink
		isTracingEnabled: self isTracingEvents;
		connect: unk!

controlBinaryStoreBytes
	"Private - Answer a <ByteArray> containing the persisted representation of the receiver's control
	using its implementation of <IPersistStream>."

	| stm answer |
	stm := IStream onHGLOBAL.	"Faster than our own implementation on Smalltalk streams"
	self binaryStoreControlOnIStream: stm.
	answer := stm contents.
	stm free.
	^answer!

controlBinaryStoreBytes: aByteArray 
	"Private - Reconstitute a control in the receiver from its persisted representation in the
	<ByteArray> argument, assuming that the stream format is that output by OleSaveToStream()."

	| stm |
	stm := aByteArray readStream queryInterface: IStream.
	stm nextCLSID.
	self safeCreateControlFromStream: stm.
	stm free!

controlDispatch
	"Answer an <IDispatch> on the embedded controls default dispatch interface,
	or nil if no control is currently hosted. Note that this should be a an instance of 
	a dual interface derived from IDispatch (i.e. the control's default interface) where
	that interface wrappers have been generated for the control.
	Implementation Note: Although we get given the control's IUnknown as a result
	of the ATL create call, the control may send us events through IPropertyNotifySink
	before that call returns, so we have to be prepared to initialize this lazily. "

	dispControl isNull ifTrue: [self queryControlDispatch].
	^dispControl!

controlOleObject
	^self controlUnknown queryInterface: IOleObject!

controlUnknown
	"Answer an <IUnknown> on the embedded control. Note that maintain this as the 
	same Smalltalk object, even though the underlying interface pointer may be changed.
	This allows us to recreate the control without affecting any existing clients.
	Implementation Note: Although we get given the control's IUnknown as a result
	of the ATL create call, the control may send us events through IPropertyNotifySink
	before that call returns, so we have to be prepared to initialize this lazily. "

	unkControl isNull
		ifTrue: 
			[| punk |
			punk := IUnknown newPointer.
			self hostInterface QueryControl: punk iid ppiObject: punk.
			unkControl isNil ifTrue: [unkControl := punk] ifFalse: [unkControl attach: punk detach]].
	^unkControl!

controlVerbs
	"Answer a collection of <OLEVERB>s describing the verbs implemented by the control currently
	hosted in the receiver."

	^self controlOleObject ifNil: [#()] ifNotNil: [:obj | obj verbs]!

create
	"Private - Creates the receiver's window (and embedded control)."

	| answer |
	answer := super create.
	self assert: [self isStateRestoring not].
	self createControl.
	^answer!

createControl
	"Private - Create the embedded control in its initalized state."

	self free.
	"We must discard the old controls interface pointer, as it is probably of the wrong type"
	dispControl := nil.
	self safeCreateControlFromStream: nil!

defaultProgId
	"Answer the 'prog id' of the Active-X control to be hosted in the receiver by default (i.e. initially
	and when no other prog id is specified). Note that this can be any of the following formats:
		1) A prog id, e.g. 'MSCAL.Calendar'
		2) A CLSID string, e.g. '{8E27C92B-1264-101C-8A2F-040224009C02}'
		3) Some HTML text, e.g. 'mshtml:<html><body>Powered by Dolphin Smalltalk</body></html'
		4) A URL, e.g. 'http://www.object-arts.com'
		
	"

	^'mshtml:
<h2>Active-X Control Site</h2>
<h4>Copyright © Object Arts Ltd</h4>'!

disconnectSink
	"Private - Disconnect the event sink (if any)."

	sink isNil ifTrue: [^self].
	sink disconnect.
	sink := nil!

docHostDblClickFlags
	"Ambient property."

	^self ambientDispatch docHostDoubleClickFlags!

docHostDblClickFlags: anInteger 
	"Ambient property."

	self ambientDispatch docHostDoubleClickFlags: anInteger!

docHostFlags
	"Ambient property."

	^self ambientDispatch docHostFlags!

docHostFlags: anInteger
	"Ambient property."

	self ambientDispatch docHostFlags: anInteger!

doPrimaryVerb
	self doVerb: 0!

doVerb: anInteger 
	| oleObj hr |
	oleObj := self controlOleObject.
	oleObj isNil ifTrue: [^E_NOTIMPL].
	hr := oleObj 
				doVerb: anInteger
				msg: nil
				activeSite: self clientSite
				parentView: self
				rectangle: self clientRectangle.
	oleObj free.
	^hr!

editControlProperties
	"Pop the control's property dialog. Note that this will only work for some controls when in design mode,
	so we make sure we are switched into it.
	Issue: Unfortunately asking the control to display its property dialog may result in nothing happenning 
	and no error code. It seems that some controls don't like to display their own property dialog, even 
	though they have property sheets, and must have the dialog externally constructed (see Dolphin 4 for 
	how to do it)."

	| hr error wasDesignMode |
	(wasDesignMode := self isDesignMode) ifFalse: [self isDesignMode: true].
	hr := [self doVerb: -7	"OLEIVERB_PROPERTIES"] on: HRESULTError
				do: 
					[:e | 
					error := e description.
					e hresult asInteger].
	hr ~= S_OK 
		ifTrue: 
			[error isNil ifTrue: [error := (HRESULT fromInteger: hr) displayString].
			MessageBox 
				errorMsg: 'Sorry, the control reports that it cannot display its property dialog at this time.'
				caption: error].
	wasDesignMode ifFalse: [self isDesignMode: false]!

eventSinkClass
	"Answer the class of <AXEventSink> to use to handle events from the hosted control."

	^AXEventSink!

finalRelease
	"The last reference to the receiver (as a COM object) has been released.
	This is an opportunity to actively clean up, rather than passively waiting 
	for finalization which is asynchronous and may never happen if the 
	object doesn't become garbage."

	"Override as necessary"!

firesControlEvents
	"Answer whether the receiver will sink events from the control's default source dispinterface
	and trigger corresponding Dolphin events off the presenter."

	^hostFlags allMask: FireControlEventsMask
!

firesControlEvents: aBoolean
	"Set whether the receiver will sink events from the control's default source dispinterface
	and trigger corresponding Dolphin events off the presenter."

	| oldFlags |
	oldFlags := hostFlags.
	hostFlags := hostFlags mask: FireControlEventsMask set: aBoolean.
	(oldFlags ~= hostFlags and: [self isOpen]) ifTrue: [
		aBoolean 
			ifTrue: [self connectSink]
			ifFalse: [self disconnectSink]]
!

firesPropertyNotifications
	"Answer whether the receiver will trigger #controlPropertyChanged: events, with the property
	name as argument, via its <presenter> when property change notifications are received from
	the control through <IPropertyNotifySink>."

	^hostFlags allMask: FirePropertyEventsMask
!

firesPropertyNotifications: aBoolean
	"Set whether the receiver will trigger #controlPropertyChanged: events, with the property
	name as argument, via its <presenter> when property change notifications are received from
	the control through <IPropertyNotifySink>."

	| wasObserving |
	wasObserving := self observePropertyNotifications.
	hostFlags := hostFlags mask: FirePropertyEventsMask set: aBoolean.
	wasObserving == self observePropertyNotifications ifFalse: [self recreateControl]!

forecolor
	"Answers the ambient foreground colour of the receiver"

	| color |
	color := self ambientDispatch foreColor.
	^color = Color windowText ifFalse: [color]!

forecolor: aColor
	"Sets the ambient foreground colour of the receiver to the <Color>, color.
	We need to pass on this ambient property to the ATL control host.
	Note that the control may ignore the ambient property entirely, or
	respect it only on initial creation."

	self ambientDispatch foreColor: aColor!

free
	"Release any external resources held by the receiver."

	self disconnectSink.
	dispControl isNull ifFalse: [dispControl free].
	unkControl isNull ifFalse: [unkControl free].
	ambientDispatch isNull ifFalse: [ambientDispatch free. ambientDispatch := nil].
	host isNull ifFalse: [host free. host := nil].
	!

getPropertyNameForDispid: dispid
	"Private - Lookup the name corresponding to the <integer> dispid."

	"Might be one of the standard properties if not strictly positive"

	| name disp tiDisp noTypeInfo |
	dispid <= 0 ifTrue: [(StandardPropNames lookup: dispid) ifNotNil: [:s | ^s]].
	disp := self controlDispatch.
	noTypeInfo := [^dispid printString asSymbol].
	tiDisp := disp typeInfoIfNone: noTypeInfo.
	name := tiDisp nameOfID: dispid
				ifAbsent: 
					["Not a property exposed through the default interface, so we must search all 
					non-source interfaces."
					(disp coclassTypeInfoIfNone: noTypeInfo) nonSourceInterfaces
						detect: [:ti | ti ~= tiDisp and: [(name := ti nameOfID: dispid ifAbsent: []) notNil]]
						ifNone: []].
	^(name ifNil: [dispid printString]) asSymbol!

hasMessageReflect
	"Answer whether message reflection is enabled.
	This is an ambient property."

	^self ambientDispatch messageReflect!

hasMessageReflect: aBoolean 
	"Answer whether message reflection is enabled.
	This is an ambient property."

	hostFlags := hostFlags mask: ReflectMask set: aBoolean.
	self ambientDispatch messageReflect: aBoolean!

hostInterface
	"Answer an <IDolphinAxHost> on the control host itself."

	host isNull ifTrue: [ | unkContainer |
		unkContainer := IUnknown fromAddress: (self sendMessage: self class getHostMsg).
		host := unkContainer queryInterface: IDolphinAxHost].
	^host!

initialize
	"Private - Initialize the receiver's instance variables."

	super initialize.
	progId := self defaultProgId.
	hostFlags := FireControlEventsMask | AllowContextMenuMask | ReflectMask | AllowWindowlessMask
				| UserModeMask.
	propertyMap := LookupTable new!

isDefault
	"Answer whether the receiver is in 'Display as Default' mode'.
	This is an ambient property, but is only relevant if the control
	behaves like a <PushButton> (i.e. if the control is marked 
	OLEMISC_ACTSLIKEBUTTON)."

	^self ambientDispatch displayAsDefault
!

isDefault: aBoolean 
	"Set whether the receiver is in 'Display as Default' mode'.
	This is an ambient property, but is only relevant if the control
	behaves like a <PushButton> (i.e. if the control is marked 
	OLEMISC_ACTSLIKEBUTTON)."

	hostFlags := hostFlags mask: DisplayAsDefaultMask set: aBoolean.
	self ambientDispatch displayAsDefault: aBoolean!

isDesignMode
	"Answer whether the control is in design mode or not."

	^self ambientDispatch userMode not!

isDesignMode: aBoolean
	"Set whether the control is in design mode or not."

	hostFlags := hostFlags mask: UserModeMask set: aBoolean not.
	self ambientDispatch userMode: aBoolean not!

isSinkingEvents
	"Answer whether the receiver is actually sinking events from the control's 
	default source dispinterface and triggering corresponding Dolphin events 
	off the presenter (events might have been requested, but may not be available)."

	^sink notNil
!

isTracingEvents
	"Answer whether the receiver is currently tracing incoming events from the control.
	This is a debugging mode and should be turned off in a runtime system."

	^hostFlags allMask: TraceEventsMask
!

isTracingEvents: aBoolean
	"Answer whether the receiver is currently tracing incoming events from the control.
	This is a debugging mode and should be turned off in a runtime system."

	hostFlags := hostFlags mask: TraceEventsMask set: aBoolean.
	self isSinkingEvents ifTrue: [sink isTracingEnabled: aBoolean]!

isWindowless
	"Answer whether the control has been activated in windowless mode."

	^self hostInterface isWindowless
!

licenseKey
	"Answer the <readableString> license key used to unlock the hosted control."

	^licenseKey!

licenseKey: aString 
	"Store <readableString> license key to be used to unlock licensed controls.
	This is only required when the hosted control is licensed.
	Implementation Note: Setting this requires that the control be recreated."

	licenseKey ~= aString ifFalse: [^self].
	licenseKey := aString.
	self isOpen ifTrue: [self createControl]!

observePropertyNotifications
	"Private - Answer whether the site should observer property change notifications through <IPropertyNotifySink>"

	^self firesPropertyNotifications!

OnChanged: dispid
	"Private - Implement the IPropertyNotifySink::OnChanged() method.
	The property with <integer> id, dispid, has changed, trigger an event
	to that effect."

	self propertyChanged: (self propertyNameFromDispid: dispid).
	^S_OK!

onDestroyed
	"Private - Handler handler for destroy. Override in order to disconnect the event sink."

	self free.
	^super onDestroyed!

OnRequestEdit: dispid
	"Private - Implement the IPropertyNotifySink::OnRequestEdit() method.
	The control is requesting permission to edit the bindable property with <integer> id,
	dispid."

	| permissionGranted property |
	property := self propertyNameFromDispid: dispid.
	self isTracingEvents
		ifTrue: 
			[Notification signal: ((String smalltalkWriteStream: 80)
						nextPutAll: 'IPropertyNotifySink::OnRequestEdit(';
						print: property;
						nextPut: $);
						contents)
				with: self].
	permissionGranted := true asValue.
	self presenter
		trigger: #controlPropertyChanging:accept:
		with: property
		with: permissionGranted.
	^permissionGranted value ifTrue: [S_OK] ifFalse: [S_FALSE]!

optionKeyPath
	"Answer the option key path (whatever that is).
	This is an ambient property."

	^self ambientDispatch optionKeyPath!

optionKeyPath: aString 
	"Set the option key path ambient property."

	^self ambientDispatch optionKeyPath: aString!

presenter: aPresenter
	"Sets the presenter associated with the receiver.
	Implementation Note: Override because we must update the event sink's target."

	| s |
	super presenter: aPresenter.
	(s := self sink) notNil ifTrue: [
		s target: aPresenter]!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message. Give the embedded control a chance to dispatch 
	this message. The ATL host supports a special window message for this purpose,
	WM_FORWARDMSG."

	^(self
		sendMessage: WM_FORWARDMSG
		wParam: 0
		lpParam: aMSG) ~~ 0
!

progId
	"Answer the progId of the hosted control."

	^progId!

progId: aString 
	"Set the progId of the hosted control.
	If the window is already open, then create the control."

	progId ~= aString ifFalse: [^self].
	propertyMap := LookupTable new.
	progId := (aString isNil or: [aString isEmpty]) 
				ifTrue: [self defaultProgId]
				ifFalse: [aString].
	self isOpen ifTrue: [self createControl]!

propertyChanged: aSymbol
	self isTracingEvents
		ifTrue: 
			[Notification signal: ((String smalltalkWriteStream: 80)
						nextPutAll: 'IPropertyNotifySink::OnChanged(';
						print: aSymbol;
						nextPut: $);
						contents)
				with: self].
	self firesPropertyNotifications
		ifTrue: [self presenter trigger: #controlPropertyChanged: with: aSymbol]!

propertyNameFromDispid: anInteger
	"Private - Map an <integer> dispid to a property name using the type information for the
	control's default dispinterface."

	^propertyMap at: anInteger ifAbsentPut: [self getPropertyNameForDispid: anInteger]!

publishedEvents
	"Answer a <Set> of <Symbol>s that describe the published events triggered
	by the receiver. Note that this will include the events from the control (unless
	the receiver is not its own presenter), and the collection will therefore vary by
	instance."

	| answer |
	answer := super publishedEvents.
	self presenter == self ifTrue: [
		answer addAll: self triggeredEvents].
	^answer!

queryControlDispatch
	"Private - Query the control's default dispatch interface, maintaining the same <IDispatch> 
	subinstance, if previously allocated, so that any clients which have previously accessed it do not 
	have the rug pulled from under their feet."

	dispControl isNil 
		ifTrue: 
			[dispControl := (self controlUnknown queryInterface: IDispatch) asImplType]
		ifFalse: 
			[self assert: [dispControl isNull].
			dispControl beNullPointer.
			self controlUnknown QueryInterface: dispControl iid ppvObject: dispControl]!

queryInterface: anInterfaceClass
	"Answer a new interface which supports the specified interface protocol
	(usually a class), or nil if the receiver does not support the interface."

	^self queryInterface: anInterfaceClass ifNone: []
!

queryInterface: anInterfaceClass ifNone: exceptionHandler 
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(self supportedInterfaces detect: [:ic | ic supportsInterface: anInterfaceClass]
		ifNone: []) 
			ifNil: [exceptionHandler value]
			ifNotNil: [:class | class on: self implementor: self]!

recreateControl
	"Private - Recreate the embedded control by persisting and 
	then reconstituting it."

	| stm |
	stm := IStream onHGLOBAL.
	self binaryStoreControlOnIStream: stm.
	self free.
	stm
		reset;
		nextCLSID.
	self safeCreateControlFromStream: stm.
	stm free.
	"Ensure the dispinterface has been re-queried."
	self controlDispatch!

restoreAmbientProperties
	"Private - Copy across non-default ambient properties to the ATL control host 
	which are cached in instance variables of the receiver."

	(hostFlags allMask: AllowContextMenuMask) ifFalse: [self allowContextMenu: false].
	(hostFlags allMask: AllowWindowlessMask) ifFalse: [self allowWindowless: false].
	(hostFlags allMask: AllowShowUIMask) ifTrue: [self allowShowUI: true].
	(hostFlags allMask: DisplayAsDefaultMask) ifTrue: [self isDefault: true].
	(hostFlags allMask: UserModeMask) ifFalse: [self isDesignMode: true].
	(hostFlags allMask: ReflectMask) ifFalse: [self hasMessageReflect: false].
	self usesAmbientColors 
		ifTrue: 
			[| color |
			color := self forecolor.
			(color isNil and: [color ~= Color windowText]) ifTrue: [self forecolor: color].
			color := self backcolor.
			(color isNil and: [color ~= Color window]) ifTrue: [self backcolor: color]].
	self setFont: self actualFont!

safeCreateControlFromStream: pStream
	"Private - Reconstitute a control in the receiver from its persisted representation in the
	<IStream>, pStream (assumed to be a stream over a previously serialized representation of
	the control's state such as that created by a call to OleSaveToStream()."

	| wszName unkSink control |
	wszName := self progId.
	propertyMap := LookupTable new.
	unkSink := self observePropertyNotifications ifTrue: [self queryInterface: IPropertyNotifySink].
	self assert: [unkControl isNull].
	control := self hostInterface
				createControlLicEx: wszName
				hWnd: self asParameter
				pStream: pStream
				piAdvise: unkSink
				bstrLic: self licenseKey.
	"If the control fire an event during the creation control, we may already have
	 had to query the control's interface, otherwise we attach the returned value
	to the any pre-existing IUnknown object."
	unkControl isNull
		ifTrue: [unkControl isNil ifTrue: [unkControl := control] ifFalse: [unkControl attach: control detach]]
		ifFalse: [control free].
	self queryControlDispatch.
	self firesControlEvents ifTrue: [self connectSink]!

setFont: aFont
	"Private - Set the specified font as the receiver's ambient font.
	Note that the control may ignore the ambient property entirely, or
	respect it only on initial creation."

	aFont resolution: self resolution.
	self ambientDispatch font: (IFontDisp fromFont: aFont)!

showGrabHandles
	"Answer whether the control should show grab handles.
	This is an ambient property. Under ATL 3.0 this will always be false."

	^self ambientDispatch showGrabHandles!

showHatching
	"Answer whether the control should show hatching.
	This is an ambient property. Under ATL 3.0 this will always be false."

	^self ambientDispatch showHatching
!

sink
	"Answer the <AXEventSink> value of the receiver's ''sink'' 
	instance variable."

	^sink!

state
	"Private - Answer a <MessageSequence> which, when replayed, will restore the receiver 
	to its current state. Note that we avoid storing any settings in the state which are the
	defaults."

	"	^sequence yourself"

	| controlState sequence tmp |
	sequence := super state.
	handle notNull ifFalse: [^sequence].
	controlState := OrderedCollection new.
	controlState add: (MessageSend receiver: self selector: #restoreAmbientProperties).
	(tmp := self optionKeyPath) notEmpty 
		ifTrue: 
			[controlState add: (MessageSend 
						receiver: self
						selector: #optionKeyPath:
						argument: tmp)].
	(tmp := self docHostFlags) = 12 
		ifFalse: 
			["DOCHOSTUIFLAG_NO3DBORDER"
			controlState add: (MessageSend 
						receiver: self
						selector: #docHostFlags:
						argument: tmp)].
	(tmp := self docHostDblClickFlags) = 0 
		ifFalse: 
			["DOCHOSTUIDBLCLK_DEFAULT"
			controlState add: (MessageSend 
						receiver: self
						selector: #docHostDblClickFlags:
						argument: tmp)].
	controlState add: (MessageSend 
				receiver: self
				selector: #controlBinaryStoreBytes:
				argument: self controlBinaryStoreBytes).
	#todo.	"Need more control over addition to MessageSequence (e.g. add:afterIndex:) in the meantime use private #list accessor"
	sequence list addAll: controlState afterIndex: 1.
	^sequence!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	We need only support the standard property notification sink interface since
	all other control container requirements are satisfied by the ATL host window
	that we are wrapping."

	^#(
		##(IPropertyNotifySink)
	)

!

triggeredEvents
	"Answer the events that the receiver triggers off its presenter."

	| answer |
	answer := Set new.
	self isSinkingEvents ifTrue: [
		answer addAll: sink publishedEventNames].
	self firesPropertyNotifications ifTrue: [
		answer 
			add: #controlPropertyChanging:accept:;
			add: #controlPropertyChanged:].
	^answer
!

usesAmbientColors
	"Answer whether this control makes use of the ambient foreground and background color
	properties. If it doesn't then there is no point attempting to set them."

	^true! !
!AXControlSite categoriesFor: #aboutControl!operations!public! !
!AXControlSite categoriesFor: #allowContextMenu!ambient properties!public!testing! !
!AXControlSite categoriesFor: #allowContextMenu:!ambient properties!public! !
!AXControlSite categoriesFor: #allowShowUI!ambient properties!public!testing! !
!AXControlSite categoriesFor: #allowShowUI:!ambient properties!public! !
!AXControlSite categoriesFor: #allowWindowless!ambient properties!public!testing! !
!AXControlSite categoriesFor: #allowWindowless:!ambient properties!public! !
!AXControlSite categoriesFor: #ambientDispatch!ambient properties!public! !
!AXControlSite categoriesFor: #backcolor!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #backcolor:!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #binaryStoreControlOnIStream:!binary filing!private! !
!AXControlSite categoriesFor: #clientSite!operations!public! !
!AXControlSite categoriesFor: #clsid!accessing!public! !
!AXControlSite categoriesFor: #connectSink!helpers!private! !
!AXControlSite categoriesFor: #controlBinaryStoreBytes!binary filing!private! !
!AXControlSite categoriesFor: #controlBinaryStoreBytes:!binary filing!private! !
!AXControlSite categoriesFor: #controlDispatch!accessing!public! !
!AXControlSite categoriesFor: #controlOleObject!public! !
!AXControlSite categoriesFor: #controlUnknown!accessing!public! !
!AXControlSite categoriesFor: #controlVerbs!public! !
!AXControlSite categoriesFor: #create!private!realizing/unrealizing! !
!AXControlSite categoriesFor: #createControl!private!realizing/unrealizing! !
!AXControlSite categoriesFor: #defaultProgId!constants!public! !
!AXControlSite categoriesFor: #disconnectSink!helpers!private! !
!AXControlSite categoriesFor: #docHostDblClickFlags!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #docHostDblClickFlags:!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #docHostFlags!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #docHostFlags:!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #doPrimaryVerb!public! !
!AXControlSite categoriesFor: #doVerb:!public! !
!AXControlSite categoriesFor: #editControlProperties!operations!public! !
!AXControlSite categoriesFor: #eventSinkClass!constants!public! !
!AXControlSite categoriesFor: #finalRelease!public!realizing/unrealizing! !
!AXControlSite categoriesFor: #firesControlEvents!public!testing! !
!AXControlSite categoriesFor: #firesControlEvents:!accessing!public! !
!AXControlSite categoriesFor: #firesPropertyNotifications!public!testing! !
!AXControlSite categoriesFor: #firesPropertyNotifications:!accessing!public! !
!AXControlSite categoriesFor: #forecolor!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #forecolor:!accessing!ambient properties!public! !
!AXControlSite categoriesFor: #free!public!realizing/unrealizing! !
!AXControlSite categoriesFor: #getPropertyNameForDispid:!helpers!private! !
!AXControlSite categoriesFor: #hasMessageReflect!ambient properties!public! !
!AXControlSite categoriesFor: #hasMessageReflect:!ambient properties!public! !
!AXControlSite categoriesFor: #hostInterface!accessing!public! !
!AXControlSite categoriesFor: #initialize!initializing!private! !
!AXControlSite categoriesFor: #isDefault!ambient properties!public! !
!AXControlSite categoriesFor: #isDefault:!ambient properties!public! !
!AXControlSite categoriesFor: #isDesignMode!ambient properties!public!testing! !
!AXControlSite categoriesFor: #isDesignMode:!ambient properties!public! !
!AXControlSite categoriesFor: #isSinkingEvents!public!testing! !
!AXControlSite categoriesFor: #isTracingEvents!public!testing! !
!AXControlSite categoriesFor: #isTracingEvents:!accessing!public! !
!AXControlSite categoriesFor: #isWindowless!public!testing! !
!AXControlSite categoriesFor: #licenseKey!accessing!public! !
!AXControlSite categoriesFor: #licenseKey:!accessing!public! !
!AXControlSite categoriesFor: #observePropertyNotifications!helpers!private! !
!AXControlSite categoriesFor: #OnChanged:!event handling!private! !
!AXControlSite categoriesFor: #onDestroyed!event handling!private! !
!AXControlSite categoriesFor: #OnRequestEdit:!event handling!private! !
!AXControlSite categoriesFor: #optionKeyPath!ambient properties!public! !
!AXControlSite categoriesFor: #optionKeyPath:!ambient properties!public! !
!AXControlSite categoriesFor: #presenter:!initializing!public! !
!AXControlSite categoriesFor: #preTranslateKeyboardInput:!dispatching!public! !
!AXControlSite categoriesFor: #progId!accessing!public! !
!AXControlSite categoriesFor: #progId:!accessing!public! !
!AXControlSite categoriesFor: #propertyChanged:!event handling!private! !
!AXControlSite categoriesFor: #propertyNameFromDispid:!helpers!private! !
!AXControlSite categoriesFor: #publishedEvents!development!events!public! !
!AXControlSite categoriesFor: #queryControlDispatch!accessing!private! !
!AXControlSite categoriesFor: #queryInterface:!accessing-interfaces!public! !
!AXControlSite categoriesFor: #queryInterface:ifNone:!accessing!accessing-interfaces!public! !
!AXControlSite categoriesFor: #recreateControl!private!realizing/unrealizing! !
!AXControlSite categoriesFor: #restoreAmbientProperties!ambient properties!private! !
!AXControlSite categoriesFor: #safeCreateControlFromStream:!helpers!private! !
!AXControlSite categoriesFor: #setFont:!accessing!ambient properties!private! !
!AXControlSite categoriesFor: #showGrabHandles!ambient properties!public!testing! !
!AXControlSite categoriesFor: #showHatching!ambient properties!public!testing! !
!AXControlSite categoriesFor: #sink!accessing!public! !
!AXControlSite categoriesFor: #state!binary filing!private! !
!AXControlSite categoriesFor: #supportedInterfaces!constants!public! !
!AXControlSite categoriesFor: #triggeredEvents!events!public! !
!AXControlSite categoriesFor: #usesAmbientColors!public!testing! !

AXControlSite methodProtocol: #COMObject attributes: #(#readOnly) selectors: #(#clsid #finalRelease #queryInterface: #queryInterface:ifNone:)!
AXControlSite methodProtocol: #IPropertyNotifySink attributes: #(#readOnly) selectors: #(#OnChanged: #OnRequestEdit:)!

!AXControlSite class methodsFor!

chooseControl: defaultProgId 
	"Prompt the user to choose a control, defaulting to that with the <readableString> progId, defaultProgId, 
	answering the <readableString> progId of that chosen, or nil if none was chosen (the user pressed
	cancel)."

	| prompter controlReg choices choicePresenter imageManager |
	choices := ICatInformation controls.
	controlReg := defaultProgId isNil 
				ifFalse: 
					[([CLSID fromString: defaultProgId] on: HRESULTError do: [:e | nil]) 
						ifNotNil: [:clsid | clsid notNil ifTrue: [choices detect: [:e | e clsid = clsid] ifNone: []]]].
	prompter := ChoicePrompter 
				create: 'Extensible choice prompter'
				on: controlReg asValue
				choices: choices
				caption: 'Please choose a control...'.
	prompter
		newCaption: 'Other Active-X control...';
		newPrompt: 'Please enter a Prog Id:';
		newBlock: [:aString | COMObjectRegistration clsid: (CLSID fromString: aString)].
	imageManager := ImageManager new.
	imageManager maskcolor: Color face3d.
	prompter
		getImageBlock: [:objreg | imageManager addImage: objreg toolboxImage];
		imageManager: imageManager.
	choicePresenter := prompter presenterNamed: 'choices'.
	choicePresenter viewModel searchPolicy: SearchPolicy equality.
	^prompter showModal ifNotNil: [:choice | choice clsid displayString]!

example1
	"Host the standard MS serial communications OCX in an invisible window (this control has no useful
	 visuals).  When you run this you will get an Inspector window, but no other GUI.
		self example1

	Note that unless an Active-X requires in-place activation (most recent non-visual components, e.g. MSXML, 
	do not) then you should use IDispatch>>createObject:, or simply generate from the type library and use
	<DefaultInterfaceClass> new."

	| host mscomm inspector |
	host := self progId: 'MSCOMMLib.MSComm'.
	mscomm := host controlDispatch.
	inspector := mscomm inspect.

	"N.B. When finished you should explicitly destroy the AXControlSite window, or it will hang around,
	 generally when you've finished with the non-visual control. If you are hosting a visual control then
	 closing the window containing the AXControlSite will do the job without manual intervention.
	 In this case we destroy the host when the inspector is closed."
	inspector when: #viewClosed send: #destroy to: host
!

example2
	"Host the standard MS calendar OCX in a visible window that rings the bell when the date is changed.
		self example2

	Note that normally you can just add an AXControlSite window into your view in the View Composer
	rather than creating the views programmatically as here.
	"

	| shell host mscal |
	shell := ShellView new 
			layoutManager: BorderLayout new;
			create; 
			extent: 300@300;
			yourself.
	host := self new
			progId: '{8E27C92B-1264-101C-8A2F-040224009C02}';	"You can use the CLSID or a prog id"
			parentView: shell;
			arrangement: #center;
			create; show;
			yourself.
	shell show.
	
	"Simple demo of inbound events from the control"
	host presenter when: #Click send: #bell to: Sound.

	mscal := host controlDispatch.

	"You can try setting some of the properties in the inspector and watch the effect on the control"
	mscal inspect.
	shell beActive
!

example3
	"Host the standard MS FlexGrid OCX in a visible window and drive it a little via IDispatch
		self example3
	Note that normally you can just add an AXControlSite window into your view in the View Composer
	rather than creating the views programmatically as here.
	"

	| shell host grid classes coords dispid |
	shell := ShellView new 
			layoutManager: BorderLayout new;
			create; 
			extent: 400@300;
			yourself.
	host := self new
			progId: 'MSFlexGridLib.MSFlexGrid';
			parentView: shell;
			arrangement: #center;
			create; show;
			yourself.
	shell show.
	grid := host controlDispatch.

	"One can see from this example that using the raw IDispatch calls will quickly become long 
	winded and error prone, quite apart from being aesthetically unpleasant, and so it is certainly 
	worth generating the interface if you intend to make more than a few calls."
	classes := Object subclasses asSortedCollection.
	grid setProperty: 'redraw' value: false.
	grid setProperty: 'FontName' value: 'Times New Roman'; setProperty: 'FontSize' value: 14.
	grid setProperty: 'rows' value: classes size + 1.
	grid setProperty: 'cols' value: 3.
	dispid := grid idOfName: 'TextMatrix'.
	"Note that it is much faster to use TextMatrix as changing the Row or Column not only involves
	 more propputs, but also causes a large number of events to be sent back. This is especially
	 important in the loop."
	grid setPropertyId: dispid withArguments: #(0 0) value: 'Class'.
	grid setProperty: 'ColWidth' item: 0 value: 3500.

	grid setPropertyId: dispid withArguments: #(0 1) value: 'Methods'.
	grid setPropertyId: dispid withArguments: #(0 2) value: 'Class Methods'.

	"Allow columns and rows to be resized by the user"
	grid setProperty: 'allowUserResizing' value: 3.
	coords := Array new: 2.
	1 to: classes size do: [:i | | class |
		coords at: 1 put: i; at: 2 put: 0.
		class := classes at: i.
		grid setPropertyId: dispid withArguments: coords value: class name.
		"Display the number of methods on the instance side..."
		coords at: 2 put: 1.
		grid setPropertyId: dispid
			withArguments: coords 
			value: class methodDictionary size.
		"...And the class side."
		coords at: 2 put: 2.
		grid setPropertyId: dispid
			withArguments: coords 
			value: class class methodDictionary size].
	grid setProperty: 'redraw' value: true.
	"Pop up the about box - special dispid"
	host aboutControl!

getHostMsg
	"Answer the registered window message that can be sent to an ATL host window to retrieve
	the control container's IUnknown."

	^WM_ATLGETHOST!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variable
		self initialize
	"

	IPersistStream.	"Deliberately create a dependency on 'OLE Persistence Base' package"

	self addClassConstant: 'StandardPropNames' value: ((LookupTable new)
		at: 0"DISPID_VALUE" put: #Value;
		at: -500"DISPID_AUTOSIZE" put: #Autosize;                 
		at: -501"DISPID_BACKCOLOR" put: #BackColor;
		at: -502"DISPID_BACKSTYLE" put: #BackStyle;
		at: -503"DISPID_BORDERCOLOR" put: #BorderColor;
		at: -504"DISPID_BORDERSTYLE" put: #BorderStyle;
		at: -505"DISPID_BORDERWIDTH" put: #BorderWidth;
		at: -507"DISPID_DRAWMODE" put: #DrawMode;
		at: -508"DISPID_DRAWSTYLE" put: #DrawStyle;
		at: -509"DISPID_DRAWWIDTH" put: #DrawWidth;
		at: -510"DISPID_FILLCOLOR" put: #FillColor;
		at: -511"DISPID_FILLSTYLE" put: #FillStyle;
		at: -512"DISPID_FONT" put: #Font;
		at: -513"DISPID_FORECOLOR" put: #ForeColor;
		at: -514"DISPID_ENABLED" put: #Enabled;
		at: -515"DISPID_HWND" put: #Hwnd;
		at: -516"DISPID_TABSTOP" put: #Tabstop;
		at: -517"DISPID_TEXT" put: #Text;
		at: -518"DISPID_CAPTION" put: #Caption;
		at: -519"DISPID_BORDERVISIBLE" put: #BorderVisible;
		at: -520"DISPID_APPEARANCE" put: #Appearance;
		at: -521"DISPID_MOUSEPOINTER" put: #MousePointer;
		at: -522"DISPID_MOUSEICON" put: #MouseIcon;
		at: -523"DISPID_PICTURE" put: #Picture;
		at: -524"DISPID_VALID" put: #Valid;
		at: -525"DISPID_READYSTATE" put: #ReadyState;
		at: -526"DISPID_LISTINDEX" put: #ListIndex;
		at: -527"DISPID_SELECTED" put: #Selected;
		at: -528"DISPID_LIST" put: #List;
		at: -529"DISPID_COLUMN" put: #Column;
		at: -531"DISPID_LISTCOUNT" put: #ListCount;
		at: -532"DISPID_MULTISELECT" put: #MultiSelect;
		at: -533"DISPID_MAXLENGTH" put: #MaxLength;
		at: -534"DISPID_PASSWORDCHAR" put: #PasswordChar;
		at: -535"DISPID_SCROLLBARS" put: #Scrollbars;
		at: -536"DISPID_WORDWRAP" put: #Wordwrap;
		at: -537"DISPID_MULTILINE" put: #Multiline;
		at: -538"DISPID_NUMBEROFROWS" put: #NumberOfRows;
		at: -539"DISPID_NUMBEROFCOLUMNS" put: #NumberOfColumns;
		at: -540"DISPID_DISPLAYSTYLE" put: #DisplayStyle;
		at: -541"DISPID_GROUPNAME" put: #GroupName;
		at: -542"DISPID_IMEMODE" put: #IMEMode;
		at: -543"DISPID_ACCELERATOR" put: #Accelerator;
		at: -544"DISPID_ENTERKEYBEHAVIOR" put: #EnterKeyBehavior;
		at: -545"DISPID_TABKEYBEHAVIOR" put: #TabKeyBehavior;
		at: -546"DISPID_SELTEXT" put: #SelText;
		at: -547"DISPID_SELSTART" put: #SelStart;
		at: -548"DISPID_SELLENGTH" put: #SelLength;
		shrink;
		yourself)!

onStartup
	"The system is starting: Initialize the host window class and register the window message
	used for communicating with it."

	VMLibrary default axWinInit.
	WM_ATLGETHOST := UserLibrary default registerWindowMessage: 'WM_ATLGETHOST'!

progId: aString 
	"Answer a new instance of the receiver hosting the OCX with the specified prog id (which may also be 
	a CLSID string in the normal printed form, i.e. that big hex number with curly brackets)."

	^(self new)
		progId: aString;
		create;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.AXControlSite) 34 25 nil nil 34 2 8 1140916224 1 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 537169509 8 'mshtml:
<h2>Active-X Control Site</h2>
<h4>Copyright © Object Arts Ltd</h4>' 590854 ##(Smalltalk.IDispatch) nil nil 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 656134 ##(Smalltalk.ITypeInfo2) nil nil 525062 ##(Smalltalk.TYPEATTR) nil 576 608 nil 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) nil nil 2049 524550 ##(Smalltalk.TLIBATTR) 8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 0 0] nil nil nil nil 170 176 34 6 8 'PROPVARIANT' #VARIANT 8 'GUID' #GUID 8 'RemotableHandle' #ExternalHandle nil nil nil 1329 nil nil nil nil 918022 ##(Smalltalk.IDolphinAxHost) nil nil 722438 ##(Smalltalk.AXEventSink) 170 176 34 76 8 -2147418100 #onselectstart 8 -2147418099 #onerrorupdate 2073 #oncontrolselect 8 -2147418101 #ondragstart -1217 #onreadystatechange 2047 #oncontextmenu 2099 #onfocusout -1203 #onkeydown 2075 #onselectionchange 8 -2147418098 #ondatasetchanged 2089 #onactivate 8 -2147418097 #ondataavailable -1201 #ondblclick 8 -2147418093 #onpropertychange 8 -2147418105 #onrowenter -1213 #onmouseup 2091 #ondeactivate -1199 #onclick 8 -2147418078 #oncellchange 2053 #onstop -1211 #onmousemove 2067 #onmousewheel 8 -2147418079 #onrowsinserted 8 -2147418102 #onhelp 8 -2147418106 #onrowexit 2055 #onbeforeeditfocus -1209 #onmousedown 2095 #onbeforeactivate 8 -2147418104 #onmouseover 8 -2147418108 #onbeforeupdate 8 -2147418096 #ondatasetcomplete 8 -2147418107 #onafterupdate 8 -2147418103 #onmouseout 2069 #onbeforedeactivate -1207 #onkeyup 2097 #onfocusin 8 -2147418080 #onrowsdelete -1205 #onkeypress 416 1049094 ##(Smalltalk.IConnectionPoint) nil nil 534110177 562 594 nil nil 626 nil 1248 1264 nil 672 nil 262198 ##(Smalltalk.GUID) 16 96 242 80 48 181 152 207 17 187 130 0 170 0 189 206 11 1279 nil nil nil 1 2761 170 176 8 #() 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) nil nil nil nil 524806 ##(Smalltalk.IUnknown) nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 1538 531 221 416 1490 #restoreAmbientProperties 1344 416 1490 #controlBinaryStoreBytes: 34 1 8 #[13 0 10 0 60 0 104 0 50 0 62 0 65 0 99 0 116 0 105 0 118 0 101 0 45 0 88 0 32 0 67 0 111 0 110 0 116 0 114 0 111 0 108 0 32 0 83 0 105 0 116 0 101 0 60 0 47 0 104 0 50 0 62 0 13 0 10 0 60 0 104 0 52 0 62 0 67 0 111 0 112 0 121 0 114 0 105 0 103 0 104 0 116 0 32 0 169 0 32 0 79 0 98 0 106 0 101 0 99 0 116 0 32 0 65 0 114 0 116 0 115 0 32 0 76 0 116 0 100 0 60 0 47 0 104 0 52 0 62 0] 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 136 8 0 0 120 0 0 0] 8 #() 1538 193 193 nil 27 )!

stbConvertProxy: aSTBViewProxy
	"There was a bug in AXControlSite>>state in DPro 4.0 such that the recorded state
	is an <OrderedCollection> rather than a <MessageSequence> (caused by the misuse of a
	cascaded #yourself for the return value). Patch that up here."

	aSTBViewProxy version < 10 
		ifTrue: 
			[| state |
			state := aSTBViewProxy state.
			(state isKindOf: MessageSequence) 
				ifFalse: [aSTBViewProxy state: (MessageSequence withMessages: state)]].
	^super stbConvertProxy: aSTBViewProxy!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'AtlAxWin71'! !
!AXControlSite class categoriesFor: #chooseControl:!helpers!public! !
!AXControlSite class categoriesFor: #example1!examples!public! !
!AXControlSite class categoriesFor: #example2!examples!public! !
!AXControlSite class categoriesFor: #example3!examples!public! !
!AXControlSite class categoriesFor: #getHostMsg!initializing!public! !
!AXControlSite class categoriesFor: #icon!constants!public! !
!AXControlSite class categoriesFor: #initialize!initializing!public! !
!AXControlSite class categoriesFor: #onStartup!events-session!public! !
!AXControlSite class categoriesFor: #progId:!accessing!instance creation!public! !
!AXControlSite class categoriesFor: #resource_Default_view!public!resources-views! !
!AXControlSite class categoriesFor: #stbConvertProxy:!binary filing!public! !
!AXControlSite class categoriesFor: #winClassName!constants!private! !

