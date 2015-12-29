"Filed out from Dolphin Smalltalk X6.1"!

WebAppStartUp subclass: #WikiDocSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocSessionManager guid: (GUID fromString: '{C7F3831F-50B4-4BFC-B8FE-669CF83E6049}')!
WikiDocSessionManager comment: ''!
!WikiDocSessionManager categoriesForClass!Unclassified! !
!WikiDocSessionManager methodsFor!

main
	| appClass |
	self mainShellClass show.
	self openConsole.
	self stdout 
		nextPutAll: '
WikiDoc 1.0
(c) 2004-' , Date today year printString 
				, ' IT consulting Gorisek d.o.o.
http://www.gorisek.com

Starting web server...
Server time: ' 
					, Timestamp now asFilenameString , '
'.
	self parseCommandLine ifFalse: [^self exit].
	appClass := WikiDocApplication.
	WikiDocApplication default liveUpdatesLoadAndCompileAll.
	self startApplication: appClass default! !
!WikiDocSessionManager categoriesFor: #main!public! !

