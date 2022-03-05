"Filed out from Dolphin Smalltalk"!

STONTestUser subclass: #STONTestUser2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONTestUser2 guid: (GUID fromString: '{2b83d7a9-b33a-4c5e-a872-6a271dcf9f7e}')!
STONTestUser2 comment: 'STONTestUser2 extends STONTestUser with explicit implementations of #fromSton: and #stonOn:'!
!STONTestUser2 categoriesForClass!STON-Tests-Base! !
!STONTestUser2 methodsFor!

fromSton: stonReader
	stonReader parseMapDo: [ :key :value |
		key = #username ifTrue: [ username := value ].
		key = #password ifTrue: [ password := value ].
		key = #enabled ifTrue: [ enabled := value ] ]
	!

stonOn: stonWriter	
	stonWriter writeObject: self streamMap: [ :dictionary |
		dictionary
			at: #username put: username;
			at: #password put: password;
			at: #enabled put: enabled ]! !
!STONTestUser2 categoriesForMethods!
fromSton:!public!ston/core! !
stonOn:!public!ston/core! !
!

!STONTestUser2 class methodsFor!

stonName
	^ #TestUser2! !
!STONTestUser2 class categoriesForMethods!
stonName!public!ston/core! !
!

