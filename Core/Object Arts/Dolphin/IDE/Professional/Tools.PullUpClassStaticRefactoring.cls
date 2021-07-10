"Filed out from Dolphin Smalltalk"!

Refactory.Browser.PullUpClassVariableRefactoring subclass: #'Tools.PullUpClassStaticRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PullUpClassStaticRefactoring guid: (Core.GUID fromString: '{1c0b9ac3-0d93-4c89-af42-ff4fcf815418}')!
Tools.PullUpClassStaticRefactoring comment: 'Dolphin-specific specialization of PullUpClassVariableRefactoring that preserves the value of class constants that are moved.'!
!Tools.PullUpClassStaticRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.PullUpClassStaticRefactoring methodsFor!

transform
	| subclass |
	subclass := self subclassDefiningVariable.
	(subclass classConstants detect: [:each | each key = variableName] ifNone: [])
		ifNil: 
			[subclass removeClassVariable: variableName.
			class addClassVariable: variableName]
		ifNotNil: 
			[:binding |
			subclass removeClassConstant: binding.
			class addClassConstant: binding]! !
!Tools.PullUpClassStaticRefactoring categoriesForMethods!
transform!public!transforming! !
!

