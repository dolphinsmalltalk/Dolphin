"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'STON.Tests.TestKnownObject'
	instanceVariableNames: 'id description'
	classVariableNames: 'KnownObjects'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STON.Tests.TestKnownObject guid: (Core.GUID fromString: '{2b317ef3-5cd3-432a-bad1-866b9801ab51}')!

STON.Tests.TestKnownObject comment: ''!

!STON.Tests.TestKnownObject methodsFor!

= object
	self class == object class ifFalse: [ ^ false ].
	^ self id = object id!

description
	^ description!

description: string
	description := string!

hash
	^ self id hash!

id
	^id!

id: uuid
	id := uuid.
	self description: 'I am a complex object known under the ID ', id asString, ' - I was created @ ', DateAndTime now asString!

initialize
	super initialize.
	self id: UUID new.
	self class addKnownObject: self!

printOn: stream
	super printOn: stream.
	stream nextPut: $(; print: id; nextPut: $)!

stonOn: stonWriter
	"We only write out our id"
	
	stonWriter writeObject: self listSingleton: self id asString! !

!STON.Tests.TestKnownObject categoriesForMethods!
=!comparing!public! !
description!public! !
description:!public! !
hash!comparing!public! !
id!accessing!public! !
id:!initialization!public! !
initialize!initialization!public! !
printOn:!printing!public! !
stonOn:!printing!public!ston/core! !
!

!STON.Tests.TestKnownObject class methodsFor!

addKnownObject: object
	^ self knownObjects addIfNotPresent: object!

fromId: idString
	"Given id, return a matching instance of me, either by returning an existing known instance or by creating a new one (that is automatically added to the known instances)"
	
	| uuid |
	uuid := UUID fromString: idString.
	^ self knownObjects 
		detect: [ :each | each id = uuid ] 
		ifNone: [ self new id: uuid ]!

fromSton: stonReader
	^ self fromId: stonReader parseListSingleton!

knownObjects
	^ KnownObjects ifNil: [ KnownObjects := OrderedCollection new ]!

resetKnownObjects
	KnownObjects ifNotNil: [ :collection | collection removeAll ]! !

!STON.Tests.TestKnownObject class categoriesForMethods!
addKnownObject:!accessing!public! !
fromId:!instance creation!public! !
fromSton:!instance creation!public! !
knownObjects!accessing!public! !
resetKnownObjects!accessing!public! !
!

