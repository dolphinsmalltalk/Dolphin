"Filed out from Dolphin Smalltalk"!

STON.Tests.STONTestUser
	subclass: #'STON.Tests.STONTestUser3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.STONTestUser3 guid: (Core.GUID fromString: '{b5d23459-cf60-4402-97e1-6eba03cc0694}')!
STON.Tests.STONTestUser3 comment: 'STONTestUser3 extends STONTestUser but wants nil instance variables to be written'!
!STON.Tests.STONTestUser3 categoriesForClass!STON-Tests-Base! !
!STON.Tests.STONTestUser3 methodsFor!

stonShouldWriteNilInstVars
	^ true! !
!STON.Tests.STONTestUser3 categoriesForMethods!
stonShouldWriteNilInstVars!public!ston/core! !
!

!STON.Tests.STONTestUser3 class methodsFor!

stonAllInstVarNames
	^ #(username password enabled)!

stonName
	^ 'TestUser3'! !
!STON.Tests.STONTestUser3 class categoriesForMethods!
stonAllInstVarNames!public!ston/core! !
stonName!public!ston/core! !
!

