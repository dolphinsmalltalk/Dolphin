"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.DeploymentContext'
	instanceVariableNames: 'logStream elementStack aspectSetters aspectGetters developmentClasses preservedMessages rootClasses supersentMethods notifier runFlags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AllResourcesStripped' -> 16r1.
		'RemoveAbstractUnreachable' -> 16r2
	}!
Tools.DeploymentContext guid: (Core.GUID fromString: '{7703d82d-a2ec-402f-ad0b-3640cd30da56}')!
Tools.DeploymentContext comment: ''!
!Tools.DeploymentContext categoriesForClass!Kernel-Objects! !
!Tools.DeploymentContext methodsFor!

allResourcesStripped
	runFlags := runFlags bitOr: AllResourcesStripped!

areAllResourcesStripped
	^runFlags allMask: AllResourcesStripped!

aspectGetters
	^aspectGetters!

aspectGetters: anObject
	aspectGetters := anObject!

aspectSetters
	^aspectSetters!

aspectSetters: anObject
	aspectSetters := anObject!

basicDevelopmentClasses
	^developmentClasses!

closeLog
	[elementStack isEmpty] whileFalse: [self endElement: true].
	logStream close.
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
	rootClasses := #().
	logStream := notifier := DeafObject current.
	runFlags := 0!

logComment: aString
	logStream
		crtab: elementStack size;
		nextPutAll: '<!!-- ';
		nextPutAll: aString;
		nextPutAll: ' -->';
		flush!

logElement: aCollection attributes: anObject value: aString
	self startTag: aString attributes: aCollection.
	anObject notNil ifTrue: [self logValue: anObject].
	self endTag!

logStrippingError: anError
	logStream isNil ifTrue: [^self].
	self
		logElement: {'class' -> anError class fullName}
		attributes: anError description
		value: 'Error'.
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
	logStream := aString ifNil: [String writeStream] ifNotNil: [FileStream write: aString text: true].
	logStream
		nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>';
		cr.
	self startElement: 'Lagoon'
		attributes: {'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance'.
				'xsi:noNamespaceSchemaLocation' -> 'Lagoon.xsd'}!

preservedMessages
	^preservedMessages!

preservedMessages: aSet
	preservedMessages := aSet!

removeAbstractUnreachable
	runFlags := runFlags bitOr: RemoveAbstractUnreachable.!

rootClasses
	^rootClasses!

rootClasses: anObject
	rootClasses := anObject!

shouldRemoveAbstractUnreachable
	^runFlags allMask: RemoveAbstractUnreachable.!

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
!Tools.DeploymentContext categoriesFor: #allResourcesStripped!public!state! !
!Tools.DeploymentContext categoriesFor: #areAllResourcesStripped!public!state!testing! !
!Tools.DeploymentContext categoriesFor: #aspectGetters!accessing!public! !
!Tools.DeploymentContext categoriesFor: #aspectGetters:!accessing!public! !
!Tools.DeploymentContext categoriesFor: #aspectSetters!accessing!public! !
!Tools.DeploymentContext categoriesFor: #aspectSetters:!accessing!public! !
!Tools.DeploymentContext categoriesFor: #basicDevelopmentClasses!accessing!public! !
!Tools.DeploymentContext categoriesFor: #closeLog!operations!public! !
!Tools.DeploymentContext categoriesFor: #destroyNotifier!operations!private! !
!Tools.DeploymentContext categoriesFor: #developmentClasses!accessing!public! !
!Tools.DeploymentContext categoriesFor: #endElement:!logging!public! !
!Tools.DeploymentContext categoriesFor: #endTag!logging!public! !
!Tools.DeploymentContext categoriesFor: #finishedWithStripping!public!state! !
!Tools.DeploymentContext categoriesFor: #initialize!initializing!private! !
!Tools.DeploymentContext categoriesFor: #logComment:!logging!public! !
!Tools.DeploymentContext categoriesFor: #logElement:attributes:value:!logging!public! !
!Tools.DeploymentContext categoriesFor: #logStrippingError:!logging!public! !
!Tools.DeploymentContext categoriesFor: #logValue:!logging!public! !
!Tools.DeploymentContext categoriesFor: #notifier!accessing!public! !
!Tools.DeploymentContext categoriesFor: #notifier:!accessing!public! !
!Tools.DeploymentContext categoriesFor: #notify:!logging!public! !
!Tools.DeploymentContext categoriesFor: #openLogFile:!logging!public! !
!Tools.DeploymentContext categoriesFor: #preservedMessages!accessing!public! !
!Tools.DeploymentContext categoriesFor: #preservedMessages:!accessing!public! !
!Tools.DeploymentContext categoriesFor: #removeAbstractUnreachable!public!state! !
!Tools.DeploymentContext categoriesFor: #rootClasses!accessing!public! !
!Tools.DeploymentContext categoriesFor: #rootClasses:!accessing!public! !
!Tools.DeploymentContext categoriesFor: #shouldRemoveAbstractUnreachable!public!state!testing! !
!Tools.DeploymentContext categoriesFor: #snapshotDevelopmentClasses!configuration!public! !
!Tools.DeploymentContext categoriesFor: #startElement:attributes:!logging!public! !
!Tools.DeploymentContext categoriesFor: #startTag:attributes:!logging!public! !
!Tools.DeploymentContext categoriesFor: #supersentMethods!accessing!public! !
!Tools.DeploymentContext categoriesFor: #supersentMethods:!accessing!public! !

!Tools.DeploymentContext class methodsFor!

new
	^super new initialize! !
!Tools.DeploymentContext class categoriesFor: #new!public! !

