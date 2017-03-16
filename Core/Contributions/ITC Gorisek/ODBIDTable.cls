"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBIDTable
	instanceVariableNames: 'lastID'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBIDTable guid: (GUID fromString: '{8162ee1a-0fb8-11d4-b091-000000000000}')!
ODBIDTable comment: ''!
!ODBIDTable categoriesForClass!No category! !
!ODBIDTable methodsFor!

add: anInteger 
	"Store anInteger and answer its ID."

	lastID := self getLastID + 1.
	stream
		atPosition: lastID * 4 + self headerLength putLong: anInteger;
		atPosition: self headerLength putLong: lastID.
	^lastID!

at: anInteger 
	"Answer <position> at anInteger or <nil> if absent."

	anInteger > lastID ifTrue: [anInteger > self getLastID ifTrue: [^nil]].
	^stream atPositionGetLong: anInteger * 4 + self headerLength!

at: anInteger ifAbsent: aBlock 
	"Answer <position> at anInteger. Evaluate aBlock if absent."

	anInteger > lastID ifTrue: [anInteger > self getLastID ifTrue: [^aBlock value]].
	^stream atPositionGetLong: anInteger * 4 + self headerLength!

at: anInteger put: aPosition 
	"Put aPosition at anInteger."

	^stream atPosition: anInteger * 4 + self headerLength putLong: aPosition!

created
	"Private - Initialize lastID count."

	stream
		putLong: 0;
		flush!

descriptionString
	^'OmniBase ID Table
OmniBase 1.0, David Gorisek (c) 1998

'!

getLastID
	"Answer value of last ID in file."

	^lastID := stream atPositionGetLong: self headerLength!

indexesAndValuesDo: aBlock 
	1 to: self getLastID do: [:index | aBlock value: index value: (self at: index)]!

initialize
	lastID := 0! !
!ODBIDTable categoriesFor: #add:!public! !
!ODBIDTable categoriesFor: #at:!public! !
!ODBIDTable categoriesFor: #at:ifAbsent:!public! !
!ODBIDTable categoriesFor: #at:put:!public! !
!ODBIDTable categoriesFor: #created!public! !
!ODBIDTable categoriesFor: #descriptionString!public! !
!ODBIDTable categoriesFor: #getLastID!public! !
!ODBIDTable categoriesFor: #indexesAndValuesDo:!public! !
!ODBIDTable categoriesFor: #initialize!public! !

