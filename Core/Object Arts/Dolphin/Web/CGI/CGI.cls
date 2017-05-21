"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CGI
	instanceVariableNames: 'paramString'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CGI guid: (GUID fromString: '{2e575dc8-0be3-4415-9bb0-b7cda7515d14}')!
CGI comment: ''!
!CGI categoriesForClass!Unclassified! !
!CGI methodsFor!

params
	"Answer a dictionary of the parameters held by the receiver"

	| params |
	params := IdentityDictionary new.

	(self paramString subStrings: $&) do: [:each | | pair |
		pair := each subStrings: $=.
		params at: (pair at: 1) asSymbol put: (pair at: 2 ifAbsent: []) ].		
		
	params copy associationsDo: [:each |
		each value notNil ifTrue: [
			params at: each key put: each value unescapePercents]].
	^params.!

paramString
	"Answer the parameter string for the receiver"

	paramString isNil ifTrue: [
		paramString := SessionManager current stdin contents ].
	^paramString!

paramString: aString
	"Private - Initialize the receiver"

	paramString := aString.! !
!CGI categoriesFor: #params!accessing!public! !
!CGI categoriesFor: #paramString!accessing!private! !
!CGI categoriesFor: #paramString:!initializing!private! !

!CGI class methodsFor!

withParamString: aString
	"Answer an instance of the receiver set up to use aString for the passed parameters"

	^self new paramString: aString! !
!CGI class categoriesFor: #withParamString:!instance creation!public! !

