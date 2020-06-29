"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #ProtocolEnvironment
	instanceVariableNames: 'class protocols'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProtocolEnvironment guid: (GUID fromString: '{1afa7dda-3f75-460a-94fd-e9867b79245c}')!
ProtocolEnvironment comment: 'ProtocolEnvironment represents a collection of method categories in a class to be browsed.

N.B. The "protocol" terminology is historic, and should not be confused with Dolphin''s MethodProtocols. In this sense "protocol" is referring only to method categories.

Instance Variables:
	class		<Behavior>	the class that contains the method categories
	protocols	<Collection of: Symbol>	the names of the method categories to be browsed'!
!ProtocolEnvironment categoriesForClass!Refactory-Environments! !
!ProtocolEnvironment methodsFor!

class: aClass protocols: aCollection
	class := aClass.
	protocols := aCollection!

defaultLabel
	| stream |
	stream := String new writeStream.
	stream
		nextPutAll: class name;
		nextPut: $>.
	#rbFix.	"Use #do:separatedBy: to avoid extraneous final space"
	protocols do: [:each | stream nextPutAll: each] separatedBy: [stream space].
	^stream contents!

includesCategory: aCategory
	^(super includesCategory: aCategory) and: 
			[(environment classNamesFor: aCategory) inject: false
				into: 
					[:bool :each |
					bool or: 
							[| aClass |
							aClass := each asQualifiedReference valueOrNil.
							aClass == class or: [aClass class == class]]]]!

includesClass: aClass
	^aClass == class and: [super includesClass: aClass]!

includesProtocol: aProtocol in: aClass
	^aClass == class and: [(super includesProtocol: aProtocol in: aClass)
			and: [protocols includes: aProtocol]]!

includesSelector: aSelector in: aClass 
	^(super includesSelector: aSelector in: aClass) and: 
			[(protocols intersection:
				(environment whichProtocolsInclude: aSelector in: aClass)) notEmpty]!

isEmpty
	^protocols isEmpty!

postCopy
	protocols := protocols copy.
	^super postCopy!

storeOn: aStream 
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream
		nextPutAll: ' class: ';
		nextPutAll: class name;
		nextPutAll: ' protocols: '.
	protocols asArray storeOn: aStream.
	aStream nextPut: $)! !
!ProtocolEnvironment categoriesFor: #class:protocols:!initialize/release!public! !
!ProtocolEnvironment categoriesFor: #defaultLabel!constants!private! !
!ProtocolEnvironment categoriesFor: #includesCategory:!public!testing! !
!ProtocolEnvironment categoriesFor: #includesClass:!public!testing! !
!ProtocolEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!ProtocolEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!ProtocolEnvironment categoriesFor: #isEmpty!public!testing! !
!ProtocolEnvironment categoriesFor: #postCopy!copying!public! !
!ProtocolEnvironment categoriesFor: #storeOn:!printing!public! !

!ProtocolEnvironment class methodsFor!

onEnvironment: anEnvironment class: aClass protocols: aCollection
	^(self onEnvironment: anEnvironment)
		class: aClass protocols: aCollection; yourself! !
!ProtocolEnvironment class categoriesFor: #onEnvironment:class:protocols:!instance creation!public! !

