﻿"Filed out from Dolphin Smalltalk"!

Refactory.Browser.AndEnvironment
	subclass: #'Refactory.Browser.SmalllintFilterEnvironment'
	instanceVariableNames: 'lintRuleName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.SmalllintFilterEnvironment guid: (Core.GUID fromString: '{7fcd066a-29bc-4257-8ede-900b16e13492}')!

Refactory.Browser.SmalllintFilterEnvironment comment: 'SmalllintFilterEnvironment is a special environment that is used to filter out invalid Smalllint results.

Instance Variables:
	lintRuleName	<String>	the name of the lint rule that we are looking at'!

!Refactory.Browser.SmalllintFilterEnvironment categoriesForClass!Refactory-Environments! !

!Refactory.Browser.SmalllintFilterEnvironment methodsFor!

addFilterForClass: aBehavior
	(BasicLintRule filterFor: lintRuleName) addClass: aBehavior.
	andedEnvironment environment addClass: aBehavior!

addFilterForClass: aBehavior andSelector: aSymbol
	(BasicLintRule filterFor: lintRuleName) addClass: aBehavior selector: aSymbol.
	andedEnvironment environment addClass: aBehavior selector: aSymbol!

canFilterSelectors
	^environment isClassEnvironment not!

isForSmalllint
	^true!

lintRuleName: aString 
	lintRuleName := aString! !

!Refactory.Browser.SmalllintFilterEnvironment categoriesForMethods!
addFilterForClass:!accessing!actions!public! !
addFilterForClass:andSelector:!accessing!actions!public! !
canFilterSelectors!public!testing! !
isForSmalllint!public!testing! !
lintRuleName:!accessing!public! !
!

