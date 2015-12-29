"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocUserEditTask
	instanceVariableNames: 'user'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUserEditTask guid: (GUID fromString: '{CE305270-597E-4B90-BC29-75A24321FE9E}')!
WikiDocUserEditTask comment: ''!
!WikiDocUserEditTask categoriesForClass!Unclassified! !
!WikiDocUserEditTask methodsFor!

errorsUser: u 
	| errors |
	errors := LookupTable new.
	u username isNilOrEmpty 
		ifTrue: [errors at: 'username' put: 'asp.error.MandatoryEntry']
		ifFalse: 
			[u username size < 2 
				ifTrue: [errors at: 'username' put: 'asp.user.error.UsernameTooShort']
				ifFalse: 
					[(u username conform: [:eachChar | eachChar isLetter or: [eachChar isDigit]]) 
						ifFalse: [errors at: 'username' put: 'asp.user.error.UsernameWithInvalidCharacters']]].
	u password isNilOrEmpty ifTrue: [errors at: 'password' put: 'asp.error.MandatoryEntry'].
	u eMail isNilOrEmpty 
		ifFalse: 
			[(application checkEmail: u eMail) 
				ifFalse: [errors at: 'eMail' put: 'asp.error.InvalidEmail']].
	^errors!

getDefaultToolbar
	| buttons |
	buttons := OrderedCollection new.
	buttons
		add: (Array 
					with: 'Add new user' webTranslate
					with: nil
					with: true
					with: superTask taskURLPrefix , '?action=addNewUser&lang=' , language);
		add: nil;
		add: (Array 
					with: 'WikiDoc.RecentChanges' webTranslate
					with: 'lucka'
					with: true
					with: self sessionURLPrefix , '?action=recentChanges&lang=' , language);
		add: nil;
		add: (Array 
					with: 'WikiDoc.CreateNewPage' webTranslate
					with: 'createNew'
					with: true
					with: self sessionURLPrefix , '?action=createNewPage&lang=' , language);
		add: nil.
	^buttons!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processSave:on: #processGoBack:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	(self newCoder: stream) 
		showUserEditPage: user
		errors: nil
		isNewUser: user username isNil!

processGoBack: request on: stream 
	superTask processDefault: request on: stream!

processSave: request on: stream 
	| u errors |
	u := WikiDocUser new.
	[self updateUser: u from: request] evaluateIn: application newReadOnlyTransaction.
	errors := self errorsUser: u.
	errors isNilOrEmpty 
		ifTrue: 
			[(request stringAt: 'password') = (request stringAt: 'passwordConfirm') 
				ifFalse: [errors at: 'password' put: 'Passwords do not match, please enter password again']].
	errors isNilOrEmpty 
		ifFalse: 
			[(self newCoder: stream) 
				showUserEditPage: u
				errors: errors
				isNewUser: user username isNil]
		ifTrue: 
			[u username = user username 
				ifFalse: 
					[user username isNil ifFalse: [application userIndex removeKey: user username].
					application userIndex at: u username put: user].
			self updateUser: user from: request.
			user markDirty.
			transaction commit.
			
			[superTask
				updateSearchCache;
				processDefault: request on: stream] 
					evaluateIn: superTask transaction]!

setUser: aWikiDocUser 
	user := aWikiDocUser!

updateUser: u from: request 
	u
		username: (request stringAt: 'username') asUppercase;
		password: (request stringAt: 'password');
		fullName: (request stringOrNilAt: 'fullName');
		inactive: (request booleanAt: 'inactive');
		eMail: (request stringOrNilAt: 'eMail');
		homepage: (request stringOrNilAt: 'homepage').
	(request booleanAt: 'groupServerAdmins') 
		ifTrue: [u addRole: #serverAdmin]
		ifFalse: [u removeRole: #serverAdmin].
	(request booleanAt: 'groupUserAdmins') 
		ifTrue: [u addRole: #userAdmin]
		ifFalse: [u removeRole: #userAdmin]! !
!WikiDocUserEditTask categoriesFor: #errorsUser:!public! !
!WikiDocUserEditTask categoriesFor: #getDefaultToolbar!public! !
!WikiDocUserEditTask categoriesFor: #process:on:!public! !
!WikiDocUserEditTask categoriesFor: #processDefault:on:!public! !
!WikiDocUserEditTask categoriesFor: #processGoBack:on:!public! !
!WikiDocUserEditTask categoriesFor: #processSave:on:!public! !
!WikiDocUserEditTask categoriesFor: #setUser:!public! !
!WikiDocUserEditTask categoriesFor: #updateUser:from:!public! !

