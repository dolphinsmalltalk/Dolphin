"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBClassManagerForSerialization
	instanceVariableNames: 'classesToDescription idToClassDescription'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClassManagerForSerialization guid: (GUID fromString: '{9666921e-41f2-47f4-ac93-76c551ceb2a3}')!
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

