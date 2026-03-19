"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #DeploymentContext
	instanceVariableNames: 'logStream elementStack aspectSetters aspectGetters developmentClasses preservedMessages rootClasses supersentMethods notifier runFlags logFilename resourceIdentifiers resourceReferences comInterfaceSelectors sentMessageMap messageSenders sentMessages methodsWithRefLiterals'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

DeploymentContext guid: (Core.GUID fromString: '{7703d82d-a2ec-402f-ad0b-3640cd30da56}')!

DeploymentContext comment: ''!

!DeploymentContext categoriesForClass!Kernel-Objects! !

!DeploymentContext methodsFor!

_aspectGetters
	^aspectGetters!

_aspectGetters: aCollection
	aspectGetters := aCollection!

_aspectSetters
	^aspectSetters!

_aspectSetters: aCollection
	aspectSetters := aCollection!

_basicDeleteMethod: aCompiledMethod
	| class |
	class := aCompiledMethod methodClass instanceClass.
	(resourceReferences lookup: class)
		ifNotNil: 
			[:refs |
			refs removeKey: aCompiledMethod selector ifAbsent: [].
			refs isEmpty ifTrue: [resourceReferences removeKey: class]]!

_basicDevelopmentClasses
	^developmentClasses!

_closeLog
	[elementStack isEmpty] whileFalse: [self _endElement: true].
	logFilename
		ifNotNil: 
			[| log handle |
			log := logStream contents.
			handle := Kernel32
						createFile: logFilename
						dwDesiredAccess: "GENERIC_WRITE" 16r40000000
						dwSharedMode: 0
						lpSecurityAttributes: nil
						dwCreationDistribution: "CREATE_ALWAYS" 16r2
						dwFlagsAndAttributes: "FILE_ATTRIBUTE_NORMAL" 16r80
						hTemplateFile: nil.
			Kernel32
				writeFile: handle
					lpBuffer: log
					nNumberOfBytesToWrite: log size
					lpNumberOfBytesWritten: (ByteArray newFixed: 4)
					lpOverlapped: nil;
				closeHandle: handle].
	logStream := logFilename := nil!

_collectGarbage: anInteger
	| deathAt size corpse |
	size := self basicSize.
	corpse := DeadObject.Current.
	deathAt := self
				basicIdentityIndexOf: corpse
				from: 1
				to: size.
	[deathAt > 0] whileTrue: 
			[messageSenders at: deathAt put: nil.
			sentMessages at: deathAt put: nil.
			deathAt := self
						basicIdentityIndexOf: corpse
						from: deathAt
						to: size]!

_comInterfaceSelectors
	^comInterfaceSelectors!

_comInterfaceSelectors: anIdentityDictionary
	comInterfaceSelectors := anIdentityDictionary!

_deleteClass: aClass
	(rootClasses includes: aClass)
		ifTrue: 
			[Warning
				signal: 'The class ' , aClass name , ' cannot be removed because it is a root of the application'.
			^false].
	(resourceReferences removeKey: aClass ifAbsent: nil)
		ifNotNil: [resourceIdentifiers := resourceIdentifiers reject: [:each | each owningClass == aClass]].
	comInterfaceSelectors removeKey: aClass ifAbsent: nil.
	^true!

_deleteResource: aResourceIdentifier
	| refs |
	refs := resourceReferences at: aResourceIdentifier owningClass.
	refs removeKey: aResourceIdentifier selector.
	refs isEmpty ifTrue: [resourceReferences removeKey: aResourceIdentifier owningClass].
	resourceIdentifiers remove: aResourceIdentifier!

_destroyNotifier
	notifier destroy.
	notifier := DeafObject.Current!

_endElement: aBoolean
	aBoolean ifTrue: [logStream crtab: elementStack size - 1].
	self _endTag!

_endTag
	logStream
		nextPutAll: '</';
		nextPutAll: (elementStack removeAtIndex: elementStack size);
		nextPut: $>;
		flush!

_finalActions
	self _endElement: true.
	developmentClasses := resourceIdentifiers := nil.
	self _closeLog!

_finishedStrippingResources
	resourceIdentifiers := resourceIdentifiers asSortedArray!

_finishedWithStripping
	comInterfaceSelectors := resourceReferences := rootClasses := aspectGetters := aspectSetters := preservedMessages := supersentMethods := nil!

_hiddenClassReferencesInResourceMethod: aCompiledMethod
	^((resourceReferences at: aCompiledMethod methodClass instanceClass) at: aCompiledMethod selector)
		at: 1!

_hiddenResourceReferencesInResource: aResourceIdentifier
	^((resourceReferences at: aResourceIdentifier owningClass) at: aResourceIdentifier selector) at: 3!

_hiddenSendsInResourceMethod: aCompiledMethod
	^((resourceReferences at: aCompiledMethod methodClass instanceClass) at: aCompiledMethod selector)
		at: 2!

_logComment: aString
	logStream
		crtab: elementStack size;
		nextPutAll: '<!!-- ';
		nextPutAll: aString;
		nextPutAll: ' -->';
		flush!

_logElement: aString attributes: aCollection value: anObject
	| stream ch |
	self
		_startElement: aString
		attributes: aCollection
		close: anObject isNil.
	anObject isNil ifTrue: [^self].
	stream := anObject displayString readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: 
			[(##(IdentityDictionary withAll: { $" -> '&quot;'. $& -> '&amp;'. $< -> '&lt;'. $> -> '&gt;' })
				lookup: ch) ifNil: [logStream nextPut: ch] ifNotNil: [:quoted | logStream nextPutAll: quoted]].
	self _endTag!

_logStrippingError: anError
	logStream isNil ifTrue: [^self].
	self
		_logElement: 'Error'
		attributes: {'class' -> anError class fullName}
		value: anError description.
	logStream flush!

_methodsWithRefLiterals
	| remaining |
	remaining := WriteStream on: Array new.
	1 to: methodsWithRefLiterals size
		by: 2
		do: 
			[:i |
			| method |
			method := methodsWithRefLiterals at: i.
			method == DeadObject.Current
				ifFalse: 
					[remaining
						nextPut: method;
						nextPut: (methodsWithRefLiterals at: i + 1)]].
	methodsWithRefLiterals := nil.
	^remaining contents!

_methodsWithRefLiterals: anArray
	methodsWithRefLiterals := anArray
				beWeak;
				yourself!

_notifier
	^notifier!

_notifier: anObject
	notifier := anObject!

_notify: aStringMessage
	notifier _notify: aStringMessage!

_openLogFile: aString
	logFilename := aString.
	"We can avoid a dependency on FileStream by building the log in memory, and then writing it directly to a File when done."
	logStream := logFilename ifNil: [DeafObject current] ifNotNil: [self _openLogStream].
	logStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
	self _startElement: 'Lagoon'
		attributes: {'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance'.
				'xsi:noNamespaceSchemaLocation' -> 'Lagoon.xsd'}
		close: false!

_openLogStream
	^Utf8String writeStream!

_preservedMessages
	^preservedMessages!

_preservedMessages: aSet
	preservedMessages := aSet!

_resourceIdentifiers
	^resourceIdentifiers!

_resourceReferences: aLookupTable
	resourceReferences := aLookupTable!

_resourceSelectors
	^resourceIdentifiers collect: [:each | each selector]!

_rootClasses
	^rootClasses!

_rootClasses: anObject
	rootClasses := anObject!

_runFlags
	^runFlags!

_sentMessageMap
	| map |
	map := IdentityDictionary new: messageSenders size.
	1 to: messageSenders size
		do: [:i | (messageSenders at: i) ifNotNil: [:sender | map at: sender put: (sentMessages at: i)]].
	messageSenders := sentMessages := nil.
	^map!

_sentMessageMap: anIdentityDictionary
	| count sendSources sent |
	count := anIdentityDictionary size.
	messageSenders := (MourningWeakArray new: count)
				pathologist: self;
				yourself.
	sendSources := messageSenders writeStream.
	sent := (Array new: count) writeStream.
	anIdentityDictionary keysAndValuesDo: 
			[:eachSender :eachMessages |
			sendSources nextPut: eachSender.
			sent nextPut: eachMessages].
	sentMessages := sent collection!

_setRunFlag: anInteger
	runFlags := runFlags bitOr: anInteger!

_startElement: aString attributes: aCollection close: aBoolean
	logStream
		crtab: elementStack size;
		nextPut: $<;
		nextPutAll: aString.
	aCollection do: 
			[:each |
			logStream
				space;
				display: each key;
				nextPut: $=;
				nextPut: $";
				display: each value;
				nextPut: $"].
	aBoolean
		ifTrue: [logStream nextPutAll: '/>']
		ifFalse: 
			[logStream nextPut: $>.
			elementStack addLast: aString].
	logStream flush!

_supersentMethods
	^supersentMethods!

_supersentMethods: anObject
	supersentMethods := anObject!

_trimComInterfaces
	comInterfaceSelectors
		removeAllKeys: (comInterfaceSelectors keys select: [:each | each bindingOrNil isNil])!

_trimResourceReferences
	| remainingRefs |
	remainingRefs := IdentityDictionary new.
	resourceIdentifiers := Set new.
	ResourceIdentifier allResourceIdentifiersDo: 
			[:each |
			resourceIdentifiers add: each.
			(remainingRefs at: each owningClass ifAbsentPut: [IdentityDictionary new]) at: each selector
				put: ((resourceReferences at: each owningClass) at: each selector)].
	resourceReferences := remainingRefs!

developmentClasses
	"Private - Answers a weak <collection> of all the classes that are in the basic development system.
	These are marked by being in the 'Development' category"

	^developmentClasses select: [:each | each ~~ DeadObject.Current]!

developmentClasses: aWeakCollection
	developmentClasses := aWeakCollection!

elementsExpired: anInteger of: aWeakArray
	"Private - At least one of aWeakArray's elements has died, process the Corpses. The default is to
	do nothing but inform dependents. This message is sent to the aWeakArray's pathologist, 
	which is normally the receiver, but only if the receiver is marked as finalizable.
	The reason for making the default pathologist the receiver (i.e. the MourningWeakArray class)
	is to avoid creating a circular references in all MourningWeakArrays."

	aWeakArray == messageSenders
		ifTrue: [messageSenders nilCorpsesAndDo: [:deathAt | sentMessages at: deathAt put: nil]]!

initialize
	elementStack := OrderedCollection new.
	aspectGetters := rootClasses := Set new.
	logStream := notifier := DeafObject current.
	comInterfaceSelectors := IdentityDictionary new.
	runFlags := 0! !

!DeploymentContext categoriesForMethods!
_aspectGetters!accessing!private! !
_aspectGetters:!accessing!private! !
_aspectSetters!accessing!private! !
_aspectSetters:!accessing!private! !
_basicDeleteMethod:!private!removing! !
_basicDevelopmentClasses!accessing!private! !
_closeLog!operations!private! !
_collectGarbage:!accessing!private! !
_comInterfaceSelectors!operations!private! !
_comInterfaceSelectors:!operations!private! !
_deleteClass:!helpers!private! !
_deleteResource:!operations!private! !
_destroyNotifier!operations!private! !
_endElement:!logging!private! !
_endTag!logging!private! !
_finalActions!operations!private! !
_finishedStrippingResources!helpers!private! !
_finishedWithStripping!private!state! !
_hiddenClassReferencesInResourceMethod:!helpers!private! !
_hiddenResourceReferencesInResource:!helpers!private! !
_hiddenSendsInResourceMethod:!helpers!private! !
_logComment:!logging!private! !
_logElement:attributes:value:!logging!private! !
_logStrippingError:!logging!private! !
_methodsWithRefLiterals!private!removing! !
_methodsWithRefLiterals:!private!removing! !
_notifier!accessing!private! !
_notifier:!accessing!private! !
_notify:!logging!private! !
_openLogFile:!logging!private! !
_openLogStream!logging!private! !
_preservedMessages!accessing!private! !
_preservedMessages:!accessing!private! !
_resourceIdentifiers!initializing!private! !
_resourceReferences:!initializing!private! !
_resourceSelectors!initializing!private! !
_rootClasses!accessing!private! !
_rootClasses:!accessing!private! !
_runFlags!accessing!private! !
_sentMessageMap!accessing!private! !
_sentMessageMap:!accessing!private! !
_setRunFlag:!accessing!private! !
_startElement:attributes:close:!logging!private! !
_supersentMethods!accessing!private! !
_supersentMethods:!accessing!private! !
_trimComInterfaces!operations!private! !
_trimResourceReferences!operations!private! !
developmentClasses!accessing!private! !
developmentClasses:!initializing!private! !
elementsExpired:of:!finalizing!private! !
initialize!initializing!private! !
!

