"Filed out from Dolphin Smalltalk 7"!

OS.COM.AbstractDispatchImplementation subclass: #'OS.COM.EventSink'
	instanceVariableNames: 'idMap target connector cookie tiSource flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'GenericEventMask' -> 16r2.
		'NoIndividualEventsMask' -> 16r4.
		'TraceMask' -> 16r1
	}!
OS.COM.EventSink guid: (Core.GUID fromString: '{d578b1aa-48d3-49f7-a2d0-de3267236311}')!
OS.COM.EventSink comment: 'AXEventSink is a generic connection point callback interface (i.e. event sink) implementation for event dispinterfaces. AXEventSink itself handles incoming events by triggering a same named Smalltalk event, the selector of which is generated from the function description in the type library. The primary keyword of the selector is the name of the event (unchanged in any way), with subsequent keywords the name of the corresponding argument from the library, or just an underscore & colon pair (_:) if the argument is unnamed. In-only arguments are converted from the variant parameter to the equivalent Smalltalk object, whereas output arguments are passed around as a <VARIANT> which can be updated with the value to pass out.

AXEventSink implements <IDispatch> (mostly via inheritance), but only the Invoke() method. All other methods are associated with requesting type information about the interface, which it wouldn''t make sense for the caller to do, since it defines the interface and ought therefore to be well aware of its specification.

Note that COM components "source" interfaces are almost always dispinterfaces because VB is restricted to this type, although connection point interface can be vtbl based interfaces too. Some components (e.g. ADO) support both types. Where an event interface is specified as a dual it can be more efficiently implemented using <AXForwardingDualImp>. Where a custom interface is employed, this can simply be implemented against the object which is to receive the events.

'!
!OS.COM.EventSink categoriesForClass!COM-Implementations! !
!OS.COM.EventSink methodsFor!

connect: anIUnknown
	"Connect the receiver to appropriate connection point of the the COM object, punkSource.
	Answer the advise cookie.
	Note: If the Active-X object has been implemented using ATL, which is common, then one of
	these standard error codes may result:
		0x80040200 	-	CONNECT_E_NOCONNECTION
			This indicates that there is no such connection point on the source.
		0x80040202 
			This indicates that the source has queried back for the sink interface off the receiver
			and received an E_NOINTERFACE response. This should not occur because of the receiver's
			implementation of #supportedInterfaces.
	"

	| container |
	self disconnect.
	"We must register the IID as a dispinterface as otherwise query back from source will fail"
	Interface registerDispinterface: tiSource iid.
	container := anIUnknown queryInterface: IConnectionPointContainer.
	connector := container findConnectionPoint: tiSource.
	cookie := connector advise: (self queryInterface: IDispatch).
	"Transcript nextPutAll: 'Connected '; print: self; cr."
	^cookie!

disconnect
	"Disconnect the receiver from the connection point to which it has previously been
	connected."

	"Transcript nextPutAll: 'Disconnecting '; print: self; cr."

	connector notNull ifFalse: [^self].
	connector Unadvise: cookie.
	connector free.
	connector := nil!

eventNames
	"Answer a <collection> of <Symbol>s that are the names of the events that the
	receiver sinks."

	^idMap values!

handleEvent: aSymbol withArguments: anArray
	"Forward the specified event on to the target with the supplied arguments.
	Can be overridden by subclasses that wish to handle the event in a different way (e.g. by
	forwarding it to a particular object as a message rather than an event). In this case
	we just trigger an event off the supplied target."

	self triggerGenericEvent ifTrue: [
		self target trigger: #axEvent:withArguments: with: aSymbol with: anArray].
	self triggerIndividualEvents ifTrue: [
		self target trigger: aSymbol withArguments: anArray].
	^S_OK
!

invokeId: dispid flags: callTypeFlags withArguments: argArray
	"Invoke the receiver's method with <integer> dispatch id, dispid, and the <Array> of
	<variantCompatible> arguments, argArray."

	| selector |
	selector := idMap at: dispid ifAbsent: [^HRESULTError signalWith: E_NOTIMPL].
	self isTracingEnabled ifTrue: [self traceEvent: selector withArguments: argArray].
	^self handleEvent: selector withArguments: argArray!

isTracingEnabled
	"Answer whether debug tracing of incoming events is enabled."

	^flags allMask: TraceMask!

isTracingEnabled: aBoolean
	"Turn debug debug tracing of incoming events on or off."

	flags := flags mask: TraceMask set: aBoolean!

printOn: aStream
	"Append debug info about the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: (tiSource isNull ifTrue: [IID null] ifFalse: [tiSource iid]);
		space;
		print: cookie;
		nextPut: $)!

publishedEventNames
	"Answer a <collection> of <Symbol>s that are the names of the events that the
	receiver will trigger off its target as currently configured."

	| answer |
	answer := OrderedCollection new.
	self triggerGenericEvent ifTrue: [answer add: #axEvent:withArguments:].
	self triggerIndividualEvents ifTrue: [answer addAll: self eventNames].
	^answer!

setTarget: anObject sourceTypeInfo: anAXInterfaceTypeAnalyzer
	"Private - Initialize the receiver's identity instance variables."

	| fns |
	flags := 0.
	target := anObject.
	tiSource := anAXInterfaceTypeAnalyzer.

	"At present we only hold the selectors in the map, but a more sophisticated sink would keep more 
	 info in order to coerce the arguments."
	fns := tiSource functions.
	idMap := LookupTable new: fns size.
	fns do: [:f | idMap at: f memid put: f selector]
!

sourceTypeInfo
	"Answer the <TKindDispatchAnalyzer> which describes the source interface
	which is being handled by the receiver."

	^tiSource!

target
	"Answer the target to which the receiver dispatches the incoming late bound calls."

	^target!

target: anObject
	"Set the target to which the receiver dispatches the incoming late bound calls."

	target := anObject!

traceEvent: aSymbol withArguments: anArray
	"Private - Signal a notification (which if unhandled will be written to the current session's 
	trace device, e.g. the Transcript) with details of the specified event."

	Notification signal: ((String smalltalkWriteStream: 80)
				nextPutAll: 'Event: ';
				print: aSymbol;
				nextPutAll: ' args: ';
				print: anArray;
				contents)
		with: self target!

triggerGenericEvent
	"Answer whether the receiver will trigger the generic #axEvent:withArguments: event off
	its target on receipt of events from the COM event source. By default this is off."

	^flags allMask: GenericEventMask!

triggerGenericEvent: aBoolean
	"Set whether the receiver will trigger the generic #axEvent:withArguments: event off
	its target on receipt of events from the COM event source."

	flags := flags mask: GenericEventMask set: aBoolean!

triggerIndividualEvents
	"Answer whether the receiver will trigger the generic #axEvent:withArguments: event off
	its target on receipt of events from the COM event source. By default this is on."

	^flags noMask: NoIndividualEventsMask!

triggerIndividualEvents: aBoolean
	"Answer whether the receiver will trigger the generic #axEvent:withArguments: event off
	its target on receipt of events from the COM event source. By default this is on."

	flags := flags mask: NoIndividualEventsMask set: aBoolean not! !
!OS.COM.EventSink categoriesFor: #connect:!operations!public! !
!OS.COM.EventSink categoriesFor: #disconnect!operations!public! !
!OS.COM.EventSink categoriesFor: #eventNames!events!public! !
!OS.COM.EventSink categoriesFor: #handleEvent:withArguments:!event handling!public! !
!OS.COM.EventSink categoriesFor: #invokeId:flags:withArguments:!operations!public! !
!OS.COM.EventSink categoriesFor: #isTracingEnabled!event handling!private! !
!OS.COM.EventSink categoriesFor: #isTracingEnabled:!event handling!private! !
!OS.COM.EventSink categoriesFor: #printOn:!development!printing!public! !
!OS.COM.EventSink categoriesFor: #publishedEventNames!events!public! !
!OS.COM.EventSink categoriesFor: #setTarget:sourceTypeInfo:!initializing!private! !
!OS.COM.EventSink categoriesFor: #sourceTypeInfo!accessing!public! !
!OS.COM.EventSink categoriesFor: #target!accessing!public! !
!OS.COM.EventSink categoriesFor: #target:!accessing!public! !
!OS.COM.EventSink categoriesFor: #traceEvent:withArguments:!event handling!private! !
!OS.COM.EventSink categoriesFor: #triggerGenericEvent!accessing!public! !
!OS.COM.EventSink categoriesFor: #triggerGenericEvent:!accessing!public! !
!OS.COM.EventSink categoriesFor: #triggerIndividualEvents!accessing!public! !
!OS.COM.EventSink categoriesFor: #triggerIndividualEvents:!accessing!public! !

!OS.COM.EventSink class methodsFor!

new
	"Instances of the receiver must be instantiated with #target:sourceTypeInfo:"

	^self shouldNotImplement!

target: anObject sourceTypeInfo: anAXInterfaceTypeAnalyzer
	"Answer a new instance of the receiver which, when connected, arranges for the events
	described by the <AXInterfaceTypeAnalyzer> to be forwarded as triggered Smalltalk
	events off the <Object> target. In other words <AXInterfaceTypeAnalyzer> describes the 
	event (or 'source') interface that a COM object publishes. Events named after the methods
	in that interface will be triggered off the <Object> target as and when the COM object
	to which this sink is connected invokes the methods."

	^super new setTarget: anObject sourceTypeInfo: anAXInterfaceTypeAnalyzer! !
!OS.COM.EventSink class categoriesFor: #new!instance creation!public! !
!OS.COM.EventSink class categoriesFor: #target:sourceTypeInfo:!instance creation!public! !

