"Filed out from Dolphin Smalltalk XP 2002 release 5.02"!

AndEnvironment subclass: #SmalllintFilterEnvironment
	instanceVariableNames: 'lintRuleName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalllintFilterEnvironment guid: (GUID fromString: '{7FCD066A-29BC-4257-8EDE-900B16E13492}')!
SmalllintFilterEnvironment comment: 'SmalllintFilterEnvironment is a special environment that is used to filter out invalid Smalllint results.

Instance Variables:
	lintRuleName	<String>	the name of the lint rule that we are looking at'!
!SmalllintFilterEnvironment categoriesForClass!Refactory-Environments! !
!SmalllintFilterEnvironment methodsFor!

addFilterForClass: aBehavior 
	(BasicLintRule filterFor: lintRuleName) addClass: aBehavior.
	andedEnvironment environment addClass: aBehavior!

addFilterForClass: aBehavior andSelector: aSymbol 
	(BasicLintRule filterFor: lintRuleName) addClass: aBehavior
		selector: aSymbol.
	andedEnvironment environment addClass: aBehavior selector: aSymbol!

canFilterSelectors
	^environment isClassEnvironment not!

isForSmalllint
	^true!

lintRuleName: aString 
	lintRuleName := aString! !
!SmalllintFilterEnvironment categoriesFor: #addFilterForClass:!accessing!actions!public! !
!SmalllintFilterEnvironment categoriesFor: #addFilterForClass:andSelector:!accessing!actions!public! !
!SmalllintFilterEnvironment categoriesFor: #canFilterSelectors!public!testing! !
!SmalllintFilterEnvironment categoriesFor: #isForSmalllint!public!testing! !
!SmalllintFilterEnvironment categoriesFor: #lintRuleName:!accessing!public! !

