"Filed out from Dolphin Smalltalk"!

STONTestUser subclass: #STONTestUser3
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STONTestUser3 guid: (GUID fromString: '{b5d23459-cf60-4402-97e1-6eba03cc0694}')!

STONTestUser3 comment: 'STONTestUser3 extends STONTestUser but wants nil instance variables to be written'!

!STONTestUser3 categoriesForClass!STON-Tests-Base! !

!STONTestUser3 methodsFor!

stonShouldWriteNilInstVars
	^ true! !

!STONTestUser3 categoriesForMethods!
stonShouldWriteNilInstVars!public!ston/core! !
!

!STONTestUser3 class methodsFor!

stonAllInstVarNames
	^ #(username password enabled)!

stonName
	^ 'TestUser3'! !

!STONTestUser3 class categoriesForMethods!
stonAllInstVarNames!public!ston/core! !
stonName!public!ston/core! !
!

