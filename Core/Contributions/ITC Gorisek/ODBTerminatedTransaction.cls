"Filed out from Dolphin Smalltalk 7"!

ODBTransaction subclass: #ODBTerminatedTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBTerminatedTransaction guid: (GUID fromString: '{8162ee2c-0fb8-11d4-b091-000000000000}')!
ODBTerminatedTransaction comment: ''!
!ODBTerminatedTransaction categoriesForClass!No category! !
!ODBTerminatedTransaction methodsFor!

start
	"Start transaction. Transaction has been terminated 
        without being aborted in previous session."

	transactionManager transactionStart: self.
	versionDescriptor versionNumber: transactionFile versionNumber.
	locks := transactionFile locks!

transactionFile: aTransactionFile 
	transactionFile := aTransactionFile! !
!ODBTerminatedTransaction categoriesFor: #start!public! !
!ODBTerminatedTransaction categoriesFor: #transactionFile:!private! !

