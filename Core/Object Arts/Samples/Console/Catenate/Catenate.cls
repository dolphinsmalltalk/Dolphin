"Filed out from Dolphin Smalltalk"!

ConsoleSessionManager subclass: #Catenate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Catenate guid: (GUID fromString: '{8004fa9a-2326-4df3-8107-51cfcd06d5c9}')!

Catenate comment: 'Catenate is a sample command line application that performs the same function as the Unix ''cat'' and DOS ''type'' commands (i.e. it copies the contents of the files specified on its command line to the standard output stream).'!

!Catenate categoriesForClass!Unclassified! !

!Catenate methodsFor!

cat: fileNames 
	"Dump the contents of all the files listed as arguments to stdout without any text translation."

	fileNames do: 
			[:f | 
			| in next |
			in := FileStream read: f text: false.
			
			[next := in nextAvailable: 1024.
			next isEmpty] whileFalse: [self stdout nextPutAll: next]].
	self stdout flush.!

main
	self argc < 2 
		ifTrue: 
			[(self stderr)
				nextPutAll: 'Dolphin Smalltalk Catenate Sample';
				cr;
				nextPutAll: 'Copyright (c) Object Arts Ltd, 2000-2002.';
				crtab: 1;
				nextPutAll: 'Usage: ';
				display: self argv first;
				nextPutAll: ' <file1>,<file2>,...<fileN>';
				cr]
		ifFalse: [self cat: (self argv copyFrom: 2)]!

openStdOut
	"Private - We want to open stdout in untranslated mode as we are going to dump the file contents exactly as they are."

	^StdioBinaryFileStream fromHandle: VM stdout! !

!Catenate categoriesForMethods!
cat:!operations-startup!public! !
main!operations-startup!public! !
openStdOut!helpers!private! !
!

