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

aspectGetters
	^aspectGetters!

aspectGetters: aCollection
	aspectGetters := aCollection!

aspectSetters
	^aspectSetters!

aspectSetters: aCollection
	aspectSetters := aCollection!

basicDevelopmentClasses
	^developmentClasses!

closeLog
	[elementStack isEmpty] whileFalse: [self endElement: true].
	logFilename isNil
		ifFalse: 
			[(File
				open: logFilename
				mode: #truncate
				check: false
				share: #exclusive)
				write: logStream contents;
				close].
	logStream := nil!

destroyNotifier
	notifier destroy.
	notifier := DeafObject.Current!

developmentClasses
	"Answers a weak <collection> of all the classes that are in the basic development system.
	These are marked by being in the 'Development' category"

	^developmentClasses select: [:each | each ~~ DeadObject.Current]!

endElement: aBoolean
	aBoolean ifTrue: [logStream crtab: elementStack size - 1].
	self endTag!

endTag
	logStream
		nextPutAll: '</';
		nextPutAll: elementStack removeLast;
		nextPut: $>;
		flush!

finishedWithStripping
	rootClasses := aspectGetters := aspectSetters := preservedMessages := supersentMethods := nil!

initialize
	elementStack := OrderedCollection new.
	aspectGetters := rootClasses := #().
	logStream := notifier := DeafObject current.
	runFlags := 0!

logComment: aString
	logStream
		crtab: elementStack size;
		nextPutAll: '<!!-- ';
		nextPutAll: aString;
		nextPutAll: ' -->';
		flush!

logElement: aString attributes: aCollection value: anObject
	self startTag: aString attributes: aCollection.
	anObject notNil ifTrue: [self logValue: anObject].
	self endTag!

logStrippingError: anError
	logStream isNil ifTrue: [^self].
	self
		logElement: 'Error'
		attributes: {'class' -> anError class fullName}
		value: anError description.
	logStream flush!

logValue: anObject
	| string |
	string := anObject displayString.
	(string includesAnyOf: '<>
	&')
		ifTrue: 
			[string do: 
					[:each |
					(##(LookupTable new
						at: $& put: '&amp;';
						at: $< put: '&lt;';
						at: $> put: '&gt;';
						at: $" put: '&quot;';
						shrink
					"						at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';")
							at: each
							ifAbsent: nil) ifNil: [logStream nextPut: each] ifNotNil: [:quoted | logStream nextPutAll: quoted]
					"						at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"
					"						at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"]]
		ifFalse: [logStream nextPutAll: string]!

notifier
	^notifier!

notifier: anObject
	notifier := anObject!

notify: aStringMessage
	notifier notify: aStringMessage!

openLogFile: aString
	logFilename := aString.
	"We can avoid a dependency on FileStream by building the log in memory, and then writing it directly to a File when done."
	logStream := aString ifNil: [DeafObject current] ifNotNil: [Utf8String writeStream].
	logStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
	self startElement: 'Lagoon'
		attributes: {'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance'.
				'xsi:noNamespaceSchemaLocation' -> 'Lagoon.xsd'}!

preservedMessages
	^preservedMessages!

preservedMessages: aSet
	preservedMessages := aSet!

rootClasses
	^rootClasses!

rootClasses: anObject
	rootClasses := anObject!

runFlags
	^runFlags!

setRunFlag: anInteger
	runFlags := runFlags bitOr: anInteger!

snapshotDevelopmentClasses
	developmentClasses := WeakArray withAll: (Object classCategoryClass name: 'Development') classes!

startElement: aString attributes: aCollection
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

startTag: aString attributes: aCollection
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
	elementStack addLast: aString!

supersentMethods
	^supersentMethods!

supersentMethods: anObject
	supersentMethods := anObject! !
!DeploymentContext categoriesForMethods!
aspectGetters!accessing!public! !
aspectGetters:!accessing!public! !
aspectSetters!accessing!public! !
aspectSetters:!accessing!public! !
basicDevelopmentClasses!accessing!public! !
closeLog!operations!public! !
destroyNotifier!operations!private! !
developmentClasses!accessing!public! !
endElement:!logging!public! !
endTag!logging!public! !
finishedWithStripping!public!state! !
initialize!initializing!private! !
logComment:!logging!private! !
logElement:attributes:value:!logging!private! !
logStrippingError:!logging!private! !
logValue:!logging!private! !
notifier!accessing!public! !
notifier:!accessing!public! !
notify:!logging!public! !
openLogFile:!logging!public! !
preservedMessages!accessing!public! !
preservedMessages:!accessing!public! !
rootClasses!accessing!public! !
rootClasses:!accessing!public! !
runFlags!accessing!public! !
setRunFlag:!accessing!public! !
snapshotDevelopmentClasses!configuration!public! !
startElement:attributes:!logging!private! !
startTag:attributes:!logging!public! !
supersentMethods!accessing!public! !
supersentMethods:!accessing!public! !
!

