﻿"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.ProtocolEnvironment'
	instanceVariableNames: 'class protocols'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ProtocolEnvironment guid: (Core.GUID fromString: '{1afa7dda-3f75-460a-94fd-e9867b79245c}')!

Refactory.Browser.ProtocolEnvironment comment: 'ProtocolEnvironment represents a collection of method categories in a class to be browsed.

N.B. The "protocol" terminology is historic, and should not be confused with Dolphin''s MethodProtocols. In this sense "protocol" is referring only to method categories.

Instance Variables:
	class		<Behavior>	the class that contains the method categories
	protocols	<Collection of: Symbol>	the names of the method categories to be browsed'!

!Refactory.Browser.ProtocolEnvironment categoriesForClass!Refactory-Environments! !

!Refactory.Browser.ProtocolEnvironment methodsFor!

class: aClass protocols: aCollection
	class := aClass.
	protocols := aCollection!

defaultLabel
	| stream |
	stream := String new writeStream.
	stream
		nextPutAll: class fullName;
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
		nextPutAll: class fullName;
		nextPutAll: ' protocols: '.
	protocols asArray storeOn: aStream.
	aStream nextPut: $)! !

!Refactory.Browser.ProtocolEnvironment categoriesForMethods!
class:protocols:!initialize/release!public! !
defaultLabel!constants!private! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesProtocol:in:!public!testing! !
includesSelector:in:!public!testing! !
isEmpty!public!testing! !
postCopy!copying!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.ProtocolEnvironment class methodsFor!

onEnvironment: anEnvironment class: aClass protocols: aCollection
	^(self onEnvironment: anEnvironment)
		class: aClass protocols: aCollection; yourself! !

!Refactory.Browser.ProtocolEnvironment class categoriesForMethods!
onEnvironment:class:protocols:!instance creation!public! !
!

