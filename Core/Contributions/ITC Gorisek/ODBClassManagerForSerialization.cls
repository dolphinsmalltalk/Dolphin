"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBClassManagerForSerialization
	instanceVariableNames: 'classesToDescription idToClassDescription'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClassManagerForSerialization guid: (GUID fromString: '{9666921E-41F2-47F4-AC93-76C551CEB2A3}')!
ODBClassManagerForSerialization comment: ''!
!ODBClassManagerForSerialization categoriesForClass!No category! !
!ODBClassManagerForSerialization methodsFor!

classDescriptionAt: anInteger 
	(anInteger < 1 or: [anInteger > idToClassDescription size]) 
		ifTrue: [self error: '[Deserializer] Class description not found'].
	^idToClassDescription at: anInteger!

initializeForSerialization
	idToClassDescription := OrderedCollection new.
	classesToDescription := IdentityDictionary new!

loadFromStream: stream 
	| n classDescription |
	n := stream getPositiveInteger.
	n > 10000 ifTrue: [self error: '[Deserializer] Number of classes is too big'].
	idToClassDescription := Array new: n.
	1 to: n
		do: 
			[:i | 
			classDescription := ODBSerializer classDescriptionFrom: stream.
			classDescription classID: i.
			idToClassDescription at: i put: classDescription]!

register: aClass 
	| classDescription |
	^classesToDescription at: aClass
		ifAbsentPut: 
			[classDescription := ODBSerializer classDescriptionFor: aClass.
			idToClassDescription add: classDescription.
			classDescription classID: idToClassDescription size.
			classDescription]!

saveOnStream: stream 
	stream putPositiveInteger: idToClassDescription size.
	idToClassDescription do: [:each | each saveOnStream: stream]! !
!ODBClassManagerForSerialization categoriesFor: #classDescriptionAt:!public! !
!ODBClassManagerForSerialization categoriesFor: #initializeForSerialization!private! !
!ODBClassManagerForSerialization categoriesFor: #loadFromStream:!private! !
!ODBClassManagerForSerialization categoriesFor: #register:!public! !
!ODBClassManagerForSerialization categoriesFor: #saveOnStream:!private! !

