"Filed out from Dolphin Smalltalk 2000 release 4.01"!

BrowserTextTool subclass: #BrowserNotesTool
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserNotesTool comment: ''!

BrowserNotesTool guid: (GUID fromString: '{A8B6C1C2-0E73-11D5-B80B-000102677BBF}')!

!BrowserNotesTool categoriesForClass!Unclassified! !
!BrowserNotesTool methodsFor!

accept
	| items isClass |
	items := self selectedEnvyItems.
	isClass := self selector isNil and: [self className notNil].
	items do: 
			[:each | 
			isClass
				ifTrue: [self applications do: [:app | each description: self text in: app]]
				ifFalse: [each description: self text]].
	self updateContents!

isEnabled
	^self selectedEnvyItem notNil!

updateContents
	| item note |
	item := self selectedEnvyItem.
	item isNil ifTrue: [^self text: ''].
	note := item == self nonMetaClass
				ifTrue: [item descriptionFrom: self application]
				ifFalse: [item description].
	self text: (note isEmpty
			ifTrue: ['Enter a note']
			ifFalse: [note])! !
!BrowserNotesTool categoriesFor: #accept!*-unclassified!public! !
!BrowserNotesTool categoriesFor: #isEnabled!*-unclassified!public! !
!BrowserNotesTool categoriesFor: #updateContents!*-unclassified!public! !

