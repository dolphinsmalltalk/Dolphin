"Filed out from Dolphin Smalltalk X6.1"!

WikiDocObject subclass: #WikiDocPage
	instanceVariableNames: 'pageName currentVersion versions references pageTitle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocPage guid: (GUID fromString: '{3E405332-9406-493D-9A72-F9CCFC21F03B}')!
WikiDocPage comment: ''!
!WikiDocPage categoriesForClass!Unclassified! !
!WikiDocPage methodsFor!

addReference: aPage language: language 
	references isNil ifTrue: [references := OrderedCollection new].
	references detect: 
			[:eachRef | 
			| eachPage |
			eachRef class == Association 
				ifTrue: [eachPage := eachRef value]
				ifFalse: [eachPage := eachRef].
			eachPage isIdenticalTo: aPage]
		ifNone: 
			[references add: (Association key: language value: aPage).
			self markDirty]!

createNewVersion
	currentVersion isNil ifTrue: [versions := OrderedCollection new].
	^currentVersion := versions add: ((WikiDocPageVersion newPersistent)
						page: self;
						yourself)!

currentVersion
	^currentVersion!

getCurrentVersion
	currentVersion isNil 
		ifTrue: 
			[versions := OrderedCollection new.
			currentVersion := versions add: ((WikiDocPageVersion newPersistent)
								page: self;
								yourself)].
	^currentVersion!

getPageTitle
	| result |
	(result := pageTitle) isNil 
		ifTrue: 
			[| parser |
			
			[parser := (WikiDocPageParser new)
						generateHtmlFrom: self getCurrentVersion contents
							for: self getCurrentVersion
							on: (WriteStream on: String new)
							urlPrefix: ''
							application: nil
							session: nil;
						yourself] 
					on: Error
					do: [:ex | ex exitWith: nil].
			parser isNil ifFalse: [result := parser pageTitle]].
	^result isNil ifTrue: [self pageName] ifFalse: [result]!

pageName
	^pageName!

pageName: anObject
	pageName := anObject!

pageRankingValue
	^self referencesToPage size!

pageTitle
	pageTitle isNilOrEmpty ifTrue: [^self pageName].
	^pageTitle!

pageTitle: aString 
	pageTitle := aString!

pageVersions
	^versions!

referencesToPage
	^references!

removeReference: aPage 
	| newReferences |
	references isNil 
		ifFalse: 
			[newReferences := references reject: 
							[:eachRef | 
							| eachPage |
							eachRef class == Association 
								ifTrue: [eachPage := eachRef value]
								ifFalse: [eachPage := eachRef].
							eachPage isIdenticalTo: aPage].
			newReferences size = references size 
				ifFalse: 
					[self markDirty.
					references := newReferences]]!

setCurrentVersion: aPageVersion 
	currentVersion := aPageVersion.
	self markDirty! !
!WikiDocPage categoriesFor: #addReference:language:!public! !
!WikiDocPage categoriesFor: #createNewVersion!public! !
!WikiDocPage categoriesFor: #currentVersion!public! !
!WikiDocPage categoriesFor: #getCurrentVersion!public! !
!WikiDocPage categoriesFor: #getPageTitle!public! !
!WikiDocPage categoriesFor: #pageName!accessing!public! !
!WikiDocPage categoriesFor: #pageName:!accessing!public! !
!WikiDocPage categoriesFor: #pageRankingValue!public! !
!WikiDocPage categoriesFor: #pageTitle!accessing!public! !
!WikiDocPage categoriesFor: #pageTitle:!accessing!public! !
!WikiDocPage categoriesFor: #pageVersions!public! !
!WikiDocPage categoriesFor: #referencesToPage!public! !
!WikiDocPage categoriesFor: #removeReference:!public! !
!WikiDocPage categoriesFor: #setCurrentVersion:!public! !

!WikiDocPage class methodsFor!

isValidPageName: aString 
	| str |
	aString isNilOrEmpty ifTrue: [^false].
	aString trimBlanks = aString ifFalse: [^false].
	str := aString asUppercase.
	#('HTTP://*' 'MAILTO:*' 'HTTPS://*') do: [:eachMatch | (eachMatch match: str) ifTrue: [^false]].
	#($> $< $# $[ $] $% $$ $= $| ${ $} $: $;) 
		do: [:eachCh | (aString includes: eachCh) ifTrue: [^false]].
	^true! !
!WikiDocPage class categoriesFor: #isValidPageName:!public! !

