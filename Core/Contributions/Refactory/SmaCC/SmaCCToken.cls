"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCToken
	instanceVariableNames: 'start id value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCToken guid: (GUID fromString: '{7B7E4235-C8CC-488D-B349-21C3A42BAEDE}')!
SmaCCToken comment: 'SmaCCTokens are used as the interface objects between scanner and parser. They hold the string that was scanned and its position information. Also, included in the token is its id. The id specifies what type of token it is.

Instance Variables:
	id	<Array of: Integer>	the list of possible token types this represents. There can be overlapping tokens, so we list all of the id here. The default parser only looks at the first id, but we can redefine this behavior in a subclass to look at all possibilities until we find a valid token.
	start	<Integer>	the starting position of the token in the original input
	value	<Object>	the value of our token (normally a string, but could be anything)
'!
!SmaCCToken categoriesForClass!SmaCC Runtime! !
!SmaCCToken methodsFor!

id
	^id!

printOn: aStream 
	aStream
		nextPut: ${;
		nextPutAll: self value;
		nextPut: $(;
		nextPutAll: self startPosition printString;
		nextPut: $,;
		nextPutAll: self stopPosition printString;
		nextPut: $,;
		nextPutAll: self id printString;
		nextPutAll: ')}'!

startPosition
	^start + 1!

stopPosition
	^start + value size!

value
	^value!

value: anObject start: startPositionInteger id: anInteger 
	value := anObject.
	start := startPositionInteger.
	id := anInteger! !
!SmaCCToken categoriesFor: #id!accessing!public! !
!SmaCCToken categoriesFor: #printOn:!printing!public! !
!SmaCCToken categoriesFor: #startPosition!accessing!public! !
!SmaCCToken categoriesFor: #stopPosition!accessing!public! !
!SmaCCToken categoriesFor: #value!accessing!public! !
!SmaCCToken categoriesFor: #value:start:id:!initialize-release!public! !

!SmaCCToken class methodsFor!

value: aString start: anInteger id: anObject 
	^(self new)
		value: aString
			start: anInteger
			id: anObject;
		yourself! !
!SmaCCToken class categoriesFor: #value:start:id:!instance creation!public! !

