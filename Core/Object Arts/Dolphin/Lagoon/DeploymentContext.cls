"Filed out from Dolphin Smalltalk 7"!

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
							ifAbsent: []) ifNil: [logStream nextPut: each] ifNotNil: [:quoted | logStream nextPutAll: quoted]
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
!DeploymentContext categoriesFor: #aspectGetters!accessing!public! !
!DeploymentContext categoriesFor: #aspectGetters:!accessing!public! !
!DeploymentContext categoriesFor: #aspectSetters!accessing!public! !
!DeploymentContext categoriesFor: #aspectSetters:!accessing!public! !
!DeploymentContext categoriesFor: #basicDevelopmentClasses!accessing!public! !
!DeploymentContext categoriesFor: #closeLog!operations!public! !
!DeploymentContext categoriesFor: #destroyNotifier!operations!private! !
!DeploymentContext categoriesFor: #developmentClasses!accessing!public! !
!DeploymentContext categoriesFor: #endElement:!logging!public! !
!DeploymentContext categoriesFor: #endTag!logging!public! !
!DeploymentContext categoriesFor: #finishedWithStripping!public!state! !
!DeploymentContext categoriesFor: #initialize!initializing!private! !
!DeploymentContext categoriesFor: #logComment:!logging!private! !
!DeploymentContext categoriesFor: #logElement:attributes:value:!logging!private! !
!DeploymentContext categoriesFor: #logStrippingError:!logging!private! !
!DeploymentContext categoriesFor: #logValue:!logging!private! !
!DeploymentContext categoriesFor: #notifier!accessing!public! !
!DeploymentContext categoriesFor: #notifier:!accessing!public! !
!DeploymentContext categoriesFor: #notify:!logging!public! !
!DeploymentContext categoriesFor: #openLogFile:!logging!public! !
!DeploymentContext categoriesFor: #preservedMessages!accessing!public! !
!DeploymentContext categoriesFor: #preservedMessages:!accessing!public! !
!DeploymentContext categoriesFor: #rootClasses!accessing!public! !
!DeploymentContext categoriesFor: #rootClasses:!accessing!public! !
!DeploymentContext categoriesFor: #runFlags!accessing!public! !
!DeploymentContext categoriesFor: #setRunFlag:!accessing!public! !
!DeploymentContext categoriesFor: #snapshotDevelopmentClasses!configuration!public! !
!DeploymentContext categoriesFor: #startElement:attributes:!logging!private! !
!DeploymentContext categoriesFor: #startTag:attributes:!logging!public! !
!DeploymentContext categoriesFor: #supersentMethods!accessing!public! !
!DeploymentContext categoriesFor: #supersentMethods:!accessing!public! !

