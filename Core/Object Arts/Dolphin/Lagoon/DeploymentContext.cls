"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #DeploymentContext
	instanceVariableNames: 'logStream elementStack aspectSetters aspectGetters developmentClasses preservedMessages rootClasses supersentMethods notifier runFlags logFilename'
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
	logStream := nil!

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

_finishedWithStripping
	rootClasses := aspectGetters := aspectSetters := preservedMessages := supersentMethods := nil!

_logComment: aString
	logStream
		crtab: elementStack size;
		nextPutAll: '<!!-- ';
		nextPutAll: aString;
		nextPutAll: ' -->';
		flush!

_logElement: aString attributes: aCollection value: anObject
	self _startElement: aString attributes: aCollection.
	anObject notNil ifTrue: [self _logValue: anObject].
	self _endTag!

_logStrippingError: anError
	logStream isNil ifTrue: [^self].
	self
		_logElement: 'Error'
		attributes: {'class' -> anError class fullName}
		value: anError description.
	logStream flush!

_logValue: anObject
	| stream ch |
	stream := anObject displayString readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: 
			[(##(LookupTable new
				at: $& put: '&amp;';
				at: $< put: '&lt;';
				at: $> put: '&gt;';
				at: $" put: '&quot;';
				shrink
			"			at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';")
					lookup: ch) ifNil: [logStream nextPut: ch] ifNotNil: [:quoted | logStream nextPutAll: quoted]
			"			at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"
			"			at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"
			"			at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"
			"			at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"]!

_notifier: anObject
	notifier := anObject!

_notify: aStringMessage
	notifier _notify: aStringMessage!

_openLogFile: aString
	logFilename := aString.
	"We can avoid a dependency on FileStream by building the log in memory, and then writing it directly to a File when done."
	logStream := aString ifNil: [DeafObject current] ifNotNil: [Utf8String writeStream].
	logStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
	self _startElement: 'Lagoon'
		attributes: {'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance'.
				'xsi:noNamespaceSchemaLocation' -> 'Lagoon.xsd'}!

_preservedMessages
	^preservedMessages!

_preservedMessages: aSet
	preservedMessages := aSet!

_rootClasses
	^rootClasses!

_rootClasses: anObject
	rootClasses := anObject!

_runFlags
	^runFlags!

_setRunFlag: anInteger
	runFlags := runFlags bitOr: anInteger!

_snapshotDevelopmentClasses
	developmentClasses := WeakArray withAll: (Object classCategoryClass name: 'Development') classes!

_startElement: aString attributes: aCollection
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
	logStream nextPut: $>.
	elementStack addLast: aString.
	logStream flush!

_supersentMethods
	^supersentMethods!

_supersentMethods: anObject
	supersentMethods := anObject!

developmentClasses
	"Private - Answers a weak <collection> of all the classes that are in the basic development system.
	These are marked by being in the 'Development' category"

	^developmentClasses select: [:each | each ~~ DeadObject.Current]!

initialize
	elementStack := OrderedCollection new.
	aspectGetters := rootClasses := Set new.
	logStream := notifier := DeafObject current.
	runFlags := 0! !
!DeploymentContext categoriesForMethods!
_aspectGetters!accessing!private! !
_aspectGetters:!accessing!private! !
_aspectSetters!accessing!private! !
_aspectSetters:!accessing!private! !
_basicDevelopmentClasses!accessing!private! !
_closeLog!operations!private! !
_destroyNotifier!operations!private! !
_endElement:!logging!private! !
_endTag!logging!private! !
_finishedWithStripping!private!state! !
_logComment:!logging!private! !
_logElement:attributes:value:!logging!private! !
_logStrippingError:!logging!private! !
_logValue:!logging!private! !
_notifier:!accessing!private! !
_notify:!logging!private! !
_openLogFile:!logging!private! !
_preservedMessages!accessing!private! !
_preservedMessages:!accessing!private! !
_rootClasses!accessing!private! !
_rootClasses:!accessing!private! !
_runFlags!accessing!private! !
_setRunFlag:!accessing!private! !
_snapshotDevelopmentClasses!configuration!private! !
_startElement:attributes:!logging!private! !
_supersentMethods!accessing!private! !
_supersentMethods:!accessing!private! !
developmentClasses!accessing!private! !
initialize!initializing!private! !
!

