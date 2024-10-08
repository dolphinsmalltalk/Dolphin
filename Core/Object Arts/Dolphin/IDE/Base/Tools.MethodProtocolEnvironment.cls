﻿"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Tools.MethodProtocolEnvironment'
	instanceVariableNames: 'protocols'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.MethodProtocolEnvironment guid: (Core.GUID fromString: '{e2dca651-3bdb-4a9e-a4a7-c13ed6b54082}')!

Tools.MethodProtocolEnvironment comment: '`MethodProtocolEnvironment` is a Dolphin specific `BrowserEnvironment` that represents the classes that conform to a set of Dolphin method protocols.

Note the confusion of terminology with the Refactory `ProtocolEnvironment` class. The latter is using the old Smallltalk-80 terminology - in Dolphin we refer to Smalltalk-80 "protocols" as "method categories".

Instance Variables:
	protocols		`<collection>` of `MethodProtocol`
'!

!Tools.MethodProtocolEnvironment categoriesForClass!Refactory-Environments! !

!Tools.MethodProtocolEnvironment methodsFor!

defaultLabel
	| stream |
	stream := String smalltalkWriteStream: 40.
	stream nextPutAll: 'Methods in '.
	protocols size == 1
		ifTrue: 
			[stream
				nextPutAll: 'the ';
				display: protocols first;
				nextPutAll: ' protocol']
		ifFalse: 
			[stream nextPutAll: 'any of the protocols '.
			protocols do: [:p | stream display: p] separatedBy: [stream nextPutAll: ', ']].
	^stream contents!

includesClass: aClass 
	^(super includesClass: aClass) 
		and: [protocols anySatisfy: [:each | aClass conformsToProtocol: each]]!

includesSelector: aSelector in: aClass 
	^(super includesSelector: aSelector in: aClass) 
		and: [protocols anySatisfy: [:each | each includesSelector: aSelector]]!

protocols: aCollection 
	protocols := aCollection!

storeOn: aStream 
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream
		space;
		display: #protocolNames:;
		space.
	(protocols asArray collect: [:each | each name]) storeOn: aStream.
	aStream nextPut: $)! !

!Tools.MethodProtocolEnvironment categoriesForMethods!
defaultLabel!constants!private! !
includesClass:!public!testing! !
includesSelector:in:!public!testing! !
protocols:!accessing!private! !
storeOn:!printing!public! !
!

!Tools.MethodProtocolEnvironment class methodsFor!

onEnvironment: anEnvironment protocols: aCollection 
	^(self onEnvironment: anEnvironment)
		protocols: aCollection;
		yourself! !

!Tools.MethodProtocolEnvironment class categoriesForMethods!
onEnvironment:protocols:!instance creation!public! !
!

