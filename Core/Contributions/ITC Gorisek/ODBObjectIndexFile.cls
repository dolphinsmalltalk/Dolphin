"Filed out from Dolphin Smalltalk X6.2"!

ODBFile subclass: #ODBObjectIndexFile
	instanceVariableNames: 'valueLength pageSize start gcPosition gcBuffer gcCount var1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectIndexFile guid: (GUID fromString: '{8162EE1D-0FB8-11D4-B091-000000000000}')!
ODBObjectIndexFile comment: ''!
!ODBObjectIndexFile categoriesForClass!No category! !
!ODBObjectIndexFile methodsFor!

addHolders: holders 
	"Add object holders to table and initialize their object ID indexes."

	| lastIndex freeHolders count count2 buffer holder |
	count := holders size.
	count2 := 0.
	buffer := ByteArray new: 8.
	self waitForAddingLock.
	
	[stream 
		atPosition: self headerLength + 4
		getBytesFor: buffer
		len: 8.
	lastIndex := buffer odbLongAt: 1.
	"       (freeHolders := buffer odLongAt: 5) == 0 ifFalse: [
            count2 := count min: freeHolders.
            count := count - count2.
            stream position: self headerLength + 8; putLong: freeHolders - count2; flush.
            buffer := ByteArray new: count2 * 4.
            bufPos := lastIndex * valueLength + start + (freeHolders - count2 * 4).
            stream position: bufPos; getBytesFor: buffer; truncate: bufPos.
            1 to: count2 do: [:i |
                holder := holders at: i.
                bufPos := buffer odLongAt: (i * 4 - 3).
                holder objectID index: bufPos."
	"               self at: bufPos put: holder contents"
	"           ].
            stream flush
        ].
        count == 0 ifTrue: [ ^self ]."
	stream atPosition: self headerLength + 4 putLong: lastIndex + count] 
			ensure: [self unlockAdding].
	buffer := ByteArray new: count * valueLength.
	count2 + 1 to: holders size
		do: 
			[:i | 
			holder := holders at: i.
			lastIndex := lastIndex + 1.
			holder objectID index: lastIndex
			"       buffer replaceFrom: bufPos to: bufPos + valueLength - 1 with: holder contents startingAt: 1.
        bufPos := bufPos + valueLength"].
	stream
		atPosition: lastIndex * valueLength + start putBytesFrom: buffer;
		flush!

at: anInteger 
	"Answer bytes at index anInteger, <nil> if none."

	| bytes |
	anInteger < 1 ifTrue: [OmniBase signalError: 'Invalid object ID'].
	bytes := ByteArray new: valueLength.
	(stream 
		atPosition: (anInteger - 1) * valueLength + start
		getBytesFor: bytes
		len: valueLength) == valueLength 
		ifFalse: [^nil].
	"   (bytes at: 1) == 0 ifFalse: [ ^bytes ].
    (bytes at: 2) == 0 ifFalse: [ ^bytes ].
    (bytes at: 3) == 0 ifFalse: [ ^bytes ].
    (bytes at: 4) == 0 ifFalse: [ ^bytes ]."
	(bytes at: 9) == 0 ifFalse: [^bytes].
	^nil!

at: anInteger put: value 
	"Put value at anInteger."

	anInteger < 1 ifTrue: [OmniBase signalError: 'Invalid object ID'].
	stream 
		atPosition: (anInteger - 1) * valueLength + start
		putBytesFrom: value
		len: valueLength!

COMMENT
	"header				- self getHeaderLength
	last file index			- 4 bytes long integer
	last object ID index		- 4 bytes long integer
	unused				- 7 bytes
	swapped object space flag	- 1 byte
	...					- object headers"

	!

created
	stream
		putBytesFrom: (ByteArray new: 16);
		flush!

createOn: aString 
	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateNew
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareAll
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self writeHeader!

descriptionString
	^'OmniBase Object Index File
OmniBase 1.0, David Gorisek (c) 1998

'!

flushGCBuffer
	stream 
		atPosition: gcPosition
		putBytesFrom: gcBuffer
		len: ((gcCount - 1) \\ 256 + 1) * 4.
	gcPosition := stream position.
	stream
		truncate: gcPosition;
		flush;
		atPosition: self headerLength + 8 putLong: gcCount;
		flush!

getLastIndex
	"Private - Answer index of last object holder."

	^stream atPositionGetLong: self headerLength + 4!

indexesAndValuesDo: aBlock 
	| lastIndex buffer bufSize bufPos value |
	buffer := ByteArray new: 400 * valueLength.
	lastIndex := self getLastIndex.
	
	[gcCount := 0.
	gcPosition := lastIndex * valueLength + start.
	gcBuffer := ByteArray new: 1024.
	bufSize := stream
				position: start;
				getBytesFor: buffer.
	bufPos := 1.
	1 to: lastIndex
		do: 
			[:index | 
			value := buffer copyFrom: bufPos to: bufPos + valueLength - 1.
			(value at: 9) == 0 ifFalse: [aBlock value: index value: value].
			bufPos := bufPos + valueLength.
			bufPos >= bufSize 
				ifTrue: 
					[stream position: index * valueLength + start.
					bufSize := stream getBytesFor: buffer.
					bufPos := 1]].
	gcCount \\ 256 = 0 ifFalse: [self flushGCBuffer]] 
			ensure: 
				[gcCount := nil.
				gcBuffer := nil]!

initialize
	start := self headerLength + 16.
	valueLength := ODBObjectHolder sizeInBytes!

lock: index 
	"Lock <value> at index."

	self waitForLockAt: (index - 1) * valueLength + start length: valueLength!

newObjectFileID
	"Get new ID for object file. Thread-safe."

	| newID |
	self waitForLockAt: self headerLength length: 4.
	
	[newID := (stream atPositionGetLong: self headerLength) + 1.
	stream atPosition: self headerLength putLong: newID] 
			ensure: [self unlockAt: self headerLength length: 4].
	^newID!

openOn: aString 
	"Open transaction file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeOpenExisting
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareAll
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self compareHeader!

removeIndex: index 
	self at: index put: (ByteArray new: valueLength).
	gcCount isNil 
		ifFalse: 
			[gcBuffer odbLongAt: ((gcCount \\ 256) * 4) + 1 put: index.
			gcCount := gcCount + 1.
			gcCount \\ 256 = 0 ifTrue: [self flushGCBuffer]]!

setLastIndex: anInteger 
	"Private - Answer set index of last object holder."

	^stream atPosition: self headerLength + 4 putLong: anInteger!

swappedObjectSpaces
	"Answer <true> if object space A and B were swapped due to single container reorganization."

	| buf |
	buf := ByteArray new: 1.
	(stream atPosition: self headerLength + 15 getBytesFor: buf) = 1 ifTrue: [^(buf at: 1) = 1].
	OmniBase signalError: 'File read error'!

swappedObjectSpaces: aBoolean 
	"Set to <true> if object space A and B were swapped due to single container reorganization."

	| buf |
	buf := ByteArray new: 1.
	buf at: 1 put: (aBoolean ifTrue: [1] ifFalse: [0]).
	stream
		atPosition: self headerLength + 15 putBytesFrom: buf;
		flush!

unlock: index 
	"Unlock  <value> at index."

	self unlockAt: (index - 1) * valueLength + start length: valueLength! !
!ODBObjectIndexFile categoriesFor: #addHolders:!public! !
!ODBObjectIndexFile categoriesFor: #at:!public! !
!ODBObjectIndexFile categoriesFor: #at:put:!public! !
!ODBObjectIndexFile categoriesFor: #COMMENT!public! !
!ODBObjectIndexFile categoriesFor: #created!public! !
!ODBObjectIndexFile categoriesFor: #createOn:!public! !
!ODBObjectIndexFile categoriesFor: #descriptionString!public! !
!ODBObjectIndexFile categoriesFor: #flushGCBuffer!public! !
!ODBObjectIndexFile categoriesFor: #getLastIndex!public! !
!ODBObjectIndexFile categoriesFor: #indexesAndValuesDo:!public! !
!ODBObjectIndexFile categoriesFor: #initialize!public! !
!ODBObjectIndexFile categoriesFor: #lock:!public! !
!ODBObjectIndexFile categoriesFor: #newObjectFileID!public! !
!ODBObjectIndexFile categoriesFor: #openOn:!public! !
!ODBObjectIndexFile categoriesFor: #removeIndex:!public! !
!ODBObjectIndexFile categoriesFor: #setLastIndex:!public! !
!ODBObjectIndexFile categoriesFor: #swappedObjectSpaces!public! !
!ODBObjectIndexFile categoriesFor: #swappedObjectSpaces:!public! !
!ODBObjectIndexFile categoriesFor: #unlock:!public! !

