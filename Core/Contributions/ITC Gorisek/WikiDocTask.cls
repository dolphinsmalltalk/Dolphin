"Filed out from Dolphin Smalltalk X6.1"!

WebTask subclass: #WikiDocTask
	instanceVariableNames: 'defaultToolbar language transaction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocTask guid: (GUID fromString: '{ADEB1EFD-1F6B-4485-A130-8CFD62BDF6E0}')!
WikiDocTask comment: ''!
!WikiDocTask categoriesForClass!Unclassified! !
!WikiDocTask methodsFor!

defaultToolbar
	^defaultToolbar!

defaultToolbar: anObject
	defaultToolbar := anObject!

dispatch: request using: possibleActions on: stream withDefault: defaultAction 
	| t |
	t := transaction isNil ifTrue: [application newTransaction] ifFalse: [transaction].
	
	[
	[Processor activeProcess language: language.
	super 
		dispatch: request
		using: possibleActions
		on: stream
		withDefault: defaultAction] 
			evaluateIn: t] 
			ensure: [transaction isNil ifTrue: [t abort]]!

initialize
	super initialize.
	language := Processor activeProcess language!

newCoder: stream 
	^(application basicNewCoder: stream)
		task: self urlPrefix: self taskURLPrefix;
		session: session;
		sessionURLPrefix: self sessionURLPrefix;
		defaultToolbar: defaultToolbar;
		topNavigation: parentTopNavigation!

sessionURLPrefix
	^'/' , application urlPrefix , '/' , WikiDocIndexServlet servletName!

setTransaction: anODBTransaction 
	transaction := anODBTransaction!

transaction
	^transaction!

updateReferencesFor: page oldReferences: oldReferences newReferences: newReferences pageLanguage: pageLanguage 
	| myRefs |
	oldReferences isNilOrEmpty 
		ifFalse: 
			[oldReferences do: 
					[:eachRef | 
					| eachPageName eachPageLanguage refPage |
					eachPageLanguage := eachRef key.
					eachPageName := eachRef value.
					refPage := application getOrCreatePersistentPage: eachPageName language: eachPageLanguage.
					refPage removeReference: page]].
	newReferences do: 
			[:eachRef | 
			| eachPageName eachPageLanguage refPage |
			eachPageLanguage := eachRef key.
			eachPageName := eachRef value.
			refPage := application getOrCreatePersistentPage: eachPageName language: eachPageLanguage.
			refPage addReference: page language: pageLanguage].
	"update refereces to this page - to je zaradi zbrisanih strani"
	(myRefs := page referencesToPage) isNilOrEmpty 
		ifFalse: 
			[myRefs do: 
					[:eachRef | 
					| eachPage eachPageLanguage |
					eachRef class == Association 
						ifTrue: 
							[eachPageLanguage := eachRef key.
							eachPage := eachRef value]
						ifFalse: 
							[eachPage := eachRef.
							eachPageLanguage := language].
					((application getPage: eachPage pageName language: eachPageLanguage) 
						isIdenticalTo: eachPage) ifFalse: [page removeReference: eachPage]]]! !
!WikiDocTask categoriesFor: #defaultToolbar!accessing!private! !
!WikiDocTask categoriesFor: #defaultToolbar:!accessing!private! !
!WikiDocTask categoriesFor: #dispatch:using:on:withDefault:!public! !
!WikiDocTask categoriesFor: #initialize!public! !
!WikiDocTask categoriesFor: #newCoder:!public! !
!WikiDocTask categoriesFor: #sessionURLPrefix!public! !
!WikiDocTask categoriesFor: #setTransaction:!public! !
!WikiDocTask categoriesFor: #transaction!public! !
!WikiDocTask categoriesFor: #updateReferencesFor:oldReferences:newReferences:pageLanguage:!private! !

