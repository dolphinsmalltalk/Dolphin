"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #DeploymentContext
	instanceVariableNames: 'logStream elementStack aspectSetters aspectGetters developmentClasses preservedMessages rootClasses supersentMethods notifier runFlags logFilename resourceIdentifiers resourceReferences comInterfaceSelectors'
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
	| refs class |
	aCompiledMethod isResourceMethod ifFalse: [^self].
	class := aCompiledMethod methodClass instanceClass.
	refs := resourceReferences at: class.
	refs removeKey: aCompiledMethod selector.
	refs isEmpty ifTrue: [resourceReferences removeKey: class]!

_basicDevelopmentClasses
	^developmentClasses!

_closeLog
	[elementStack isEmpty] whileFalse: [self _endElement: true].
	logFilename
		ifNotNil: 
			[| log |
			log := logStream contents.
			(File
				open: logFilename
				mode: #truncate
				check: false
				share: #exclusive)
				write: log count: log size;
				close].
	logStream := logFilename := nil!

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
			[(##(IdentityDictionary withAll: { $& -> '&amp;'. $< -> '&lt;'. $> -> '&gt;'. $" -> '&quot;' })
				lookup: ch) ifNil: [logStream nextPut: ch] ifNotNil: [:quoted | logStream nextPutAll: quoted]].
	self _endTag!

_logStrippingError: anError
	logStream isNil ifTrue: [^self].
	self
		_logElement: 'Error'
		attributes: {'class' -> anError class fullName}
		value: anError description.
	logStream flush!

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
_setRunFlag:!accessing!private! !
_startElement:attributes:close:!logging!private! !
_supersentMethods!accessing!private! !
_supersentMethods:!accessing!private! !
_trimComInterfaces!operations!private! !
_trimResourceReferences!operations!private! !
developmentClasses!accessing!private! !
developmentClasses:!initializing!private! !
initialize!initializing!private! !
!

