"Filed out from Dolphin Smalltalk"!

FileOpenDialog subclass: #MultipleFileOpenDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultipleFileOpenDialog guid: (GUID fromString: '{6bf5baa9-0551-40bd-a72f-e1e38b778543}')!
MultipleFileOpenDialog comment: 'MultipleFileOpenDialog is no longer required. To request multiple filenames just specify a maximum file count > 1, i.e. use the following pattern:

	FileOpenDialog new
		maxFileCount: 30;
		showModal'!
!MultipleFileOpenDialog categoriesForClass!IDB Goodies! !
!MultipleFileOpenDialog methodsFor!

defaultMaxFileCount
	"Answers the default number of selections that are expected  to fit into the buffer"

	^25! !
!MultipleFileOpenDialog categoriesForMethods!
defaultMaxFileCount!accessing!public! !
!

