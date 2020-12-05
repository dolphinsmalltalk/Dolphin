"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BrowserEnvironmentWrapper subclass: #'Refactory.Browser.MethodProtocolEnvironment'
	instanceVariableNames: 'protocols'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.MethodProtocolEnvironment guid: (Core.GUID fromString: '{e2dca651-3bdb-4a9e-a4a7-c13ed6b54082}')!
Refactory.Browser.MethodProtocolEnvironment comment: 'MethodProtocolEnvironment is a Dolphin specific <BrowserEnvironment> that represents the classes that conform to a set of Dolphin method protocols.

Note the confusion of terminology with the Refactory ProtocolEnvironment class. The latter is using the old Smallltalk-80 terminology - in Dolphin we refer to Smalltalk-80 "protocols" as "method categories".

Instance Variables:
	protocols		<collection> of <MethodProtocol>
'!
!Refactory.Browser.MethodProtocolEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.MethodProtocolEnvironment methodsFor!

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
!Refactory.Browser.MethodProtocolEnvironment categoriesFor: #defaultLabel!constants!private! !
!Refactory.Browser.MethodProtocolEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.MethodProtocolEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.MethodProtocolEnvironment categoriesFor: #protocols:!accessing!private! !
!Refactory.Browser.MethodProtocolEnvironment categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.MethodProtocolEnvironment class methodsFor!

onEnvironment: anEnvironment protocols: aCollection 
	^(self onEnvironment: anEnvironment)
		protocols: aCollection;
		yourself! !
!Refactory.Browser.MethodProtocolEnvironment class categoriesFor: #onEnvironment:protocols:!instance creation!public! !

